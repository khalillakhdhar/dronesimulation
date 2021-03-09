classdef billes < handle
    properties
	blockchain              
    end
    methods
	function obj = billes(Block_Chain)
	    obj.blockchain = Block_Chain;
	end

	function bille(obj,newData) 
	    latestBlock = obj.blockchain.getLatest(); 
	    nex_block = strec_block(latestBlock.indice_bloc+1,...
		newData,...
		latestBlock.crypt); 
	    not_found = true;
	    iter = 1; 
	    while( not_found)
		new_hasha = cryptage(  strcat( nex_block.getCombined(), num2str(iter) ));                
		if( strcmp(new_hasha(1:2),'00') )
		    nex_block.poin_mem = iter             
		    nex_block.crypt = new_hasha        
		    obj.blockchain.addBlock(nex_block);  
		    break
		end
		iter = iter + 1;
	    end
	end

    end
end