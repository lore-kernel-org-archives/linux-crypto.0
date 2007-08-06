From: Ico <ocf@zevv.nl>
Subject: kernel BUG() when using OCF library
Date: Mon, 6 Aug 2007 18:38:31 +0200
Message-ID: <20070806163831.GL21088@pruts.nl>
References: <20070806161416.GI21088@pruts.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pruts.nl ([82.94.235.106]:52204 "EHLO iron.pruts.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838AbXHFRJu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Aug 2007 13:09:50 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by iron.pruts.nl (Postfix) with ESMTP id 6531B12E41D
	for <linux-crypto@vger.kernel.org>; Mon,  6 Aug 2007 18:38:34 +0200 (CEST)
Received: from iron.pruts.nl ([127.0.0.1])
	by localhost (iron.pruts.nl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BTa21xgu1+a0 for <linux-crypto@vger.kernel.org>;
	Mon,  6 Aug 2007 18:38:31 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20070806161416.GI21088@pruts.nl>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

I've been trying to use OCF in one of my projects, but I run into a nasty
problem I can't seem to solve. I setup a session and call the crypto_dispatch()
function, after which a kernel BUG() occurs in one of the linux crypto.h
functions. There's problably something I forgot or did not properly initialize,
I hope anybody can give me a hint on how to debug and solve this.
                                                                                                                        
The following is an extract of my code involving the crypto library:                                                    
                              
  /* Create session */
                                                                                          
  memset(&ci, 0, sizeof(ci));                                                                                           
  ci.cri_alg  = CRYPTO_ARC4;                                                                                            
  ci.cri_klen = (sizeof(info->key)-1) * 8;                                                                              
  ci.cri_key  = info->key;                                                                                              
  r = crypto_newsession(&info->crypto_sid_cipher, &ci, 0);                                                              
                                                                                                                        
  ...                                                                                                                   
                                                                                                                        
  char iv[32];                                                                                                          

  /* Reserve and create request */
                                                                                                                        
  co = crypto_getreq(1);                                                                                                
  co->crp_sid = info->crypto_sid_cipher;                                                                                
  co->crp_ilen = skbcpy->tail - skbcpy->nh.raw;                                                                         
  co->crp_olen = skbcpy->tail - skbcpy->nh.raw;                                                                         
  co->crp_callback = ebt_crypt_done;                                                                                    
  co->crp_flags = 0;                                                                                                    
  co->crp_buf = skbcpy->nh.raw;                                                                                         
  co->crp_opaque = (void *)skbcpy;                                                                                      
                                                                                                                        
  co->crp_desc->crd_skip = 0;                                                                                           
  co->crp_desc->crd_len = co->crp_ilen;                                                                                 
  co->crp_desc->crd_inject = (void *)iv;                                                                                
  co->crp_desc->crd_flags = CRD_F_ENCRYPT;                                                                              
  co->crp_desc->crd_alg = CRYPTO_ARC4;                                                                                  

  /* Dispatch */
                                                                                                                        
  r = crypto_dispatch(co);                                                                                              

                                                                                                                        
The call to crypto_dispatch results in a kernel BUG message:                                                            
                                                                                                                        
  kernel BUG at include/linux/crypto.h:364!                                                                             
  ...                                                                                                                   
  [<c00e2bcc>] (__bug+0x0/0x58) from [<bf21d350>] (swcr_process+0xb18/0xc84 [cryptosoft])                               
  [<bf21c838>] (swcr_process+0x0/0xc84 [cryptosoft]) from [<bf118170>] (crypto_invoke+0x17c/0x1a8 [ocf])                
  [<bf117ff4>] (crypto_invoke+0x0/0x1a8 [ocf]) from [<bf11776c>] (crypto_dispatch+0x154/0x2c8 [ocf])                    
  [<bf117618>] (crypto_dispatch+0x0/0x2c8 [ocf]) from [<bf11f604>] (ebt_crypt_target+0x3a0/0x434 [ebt_crypt])           
                                                                                                                        
The snippet from crypto.h:                                                                                              
                                                                                                                        
  358: static inline int crypto_cipher_encrypt_iv(struct crypto_tfm *tfm,                                               
  359:                                            struct scatterlist *dst,                                              
  360:                                            struct scatterlist *src,                                              
  361:                                            unsigned int nbytes, u8 *iv)                                          
  362: {                                                                                                                
  363:         BUG_ON(crypto_tfm_alg_type(tfm) != CRYPTO_ALG_TYPE_CIPHER);                                              
  364:         BUG_ON(tfm->crt_cipher.cit_mode == CRYPTO_TFM_MODE_ECB);                                                 
  365:         return tfm->crt_cipher.cit_encrypt_iv(tfm, dst, src, nbytes, iv);                                        
  366: }                                                                                                                
                                                                                                           

Any hints ?

Thank you very much for your time,

Ico

-- 
:wq
^X^Cy^K^X^C^C^C^C
