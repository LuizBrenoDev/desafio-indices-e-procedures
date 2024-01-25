-- Desafio DIO Procedures
/**
AVISO: A procedure não foi modificada para o cenário de universidade pois não possuo esse banco de dados
AVISO 2: Na descrição do projeto, houve ambiguidade quanto às funções da procedure. Se haveria inserção de valores ou recuperação de valores. 
Acabei fazendo a segunda opção por estar indeciso sobre a situação.
Se a implementação estiver incorreta, estou disponível para modificar qualquer aspecto.

*/
USE shop;

delimiter $$
CREATE PROCEDURE procedure_ecommerce 
	(operation_type INT, id_produto_procedure INT, id_pedido_procedure INT, id_cliente_procedure INT) 
	BEGIN
		DECLARE CONTINUE HANDLER FOR 1339
			BEGIN
				SELECT 1339 AS ERROR_CODE, 
                "ERRO: Opção inválida. Utilize 1 (SELECT), 2 (UPDATE) ou 3 (DELETE)." AS ERROR_MESSAGE;
            END;
		CASE operation_type
			WHEN 1 THEN 
				-- Situação de recuperação de dados
                -- Recupera todas as informações importantes de um pedido
				IF id_pedido_procedure != 0 THEN
					SELECT id_pedido, cliente.id_cliente, cliente.nome, entrega.status, cliente.endereço, pedido.entrega_codigo_rastreio
                    FROM cliente, pedido, entrega
                    WHERE cliente.id_cliente = pedido.id_cliente_do_pedido 
                    AND pedido.entrega_codigo_rastreio = entrega.codigo_rastreio
                    AND pedido.id_pedido = id_pedido_procedure;
				END IF;
            WHEN 2 THEN
			        -- Situação de atualização
					-- Compara a quantidade de produtos presentes em produtos_do_fornecedor e estoque
                    -- e se são diferentes
                    SET @quantidade_no_estoque = (SELECT DISTINCT estoque.quantidade_produto
                    FROM estoque, produtos_do_fornecedor
                    WHERE estoque.id_produto = id_produto_procedure);
                    
                    SET @quantidade_do_fornecedor = (SELECT DISTINCT produtos_do_fornecedor.quantidade_produtos 
					FROM produtos_do_fornecedor, estoque
					WHERE produtos_do_fornecedor.id_produto = id_produto_procedure);
                    
					IF @quantidade_no_estoque != @quantidade_do_fornecedor THEN
						UPDATE produtos_do_fornecedor 
						SET quantidade_produtos = @quantidade_no_estoque
						WHERE produtos_do_fornecedor.id_produto = id_produto_procedure;
					END IF;
				WHEN 3 THEN
					-- Situação de deleção
                    -- Deleta vendedores que possuem o mesmo CPF de um cliente
					IF id_cliente_procedure != 0 THEN
						SET @suspect_cpf = (SELECT cpf FROM cliente WHERE id_cliente = id_cliente_procedure);
						SET @suspect = (SELECT id_vendedor FROM vendedor WHERE vendedor.cpf = @suspect_cpf);
						
                        DELETE FROM vendedor WHERE id_vendedor = @suspect;
                        SELECT "Vendedor inválido deletado" AS message;
					ELSEIF id_cliente_procedure = NULL OR id_cliente_procedure = 0 THEN
						SELECT "Argumento inválido" AS message;
					END IF;
		END CASE;
    END$$
delimiter ;

