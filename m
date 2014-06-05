From: "Hsieh, Che-Min" <cheminh@qti.qualcomm.com>
Subject: [QUESTION] authenc(hmac(sha 1 or 256),cbc(aes))  fallback
Date: Thu, 5 Jun 2014 15:01:19 +0000
Message-ID: <A83C99F8370D4D42BEB2D2B3153A6BBC30808F0A@NASANEXD02C.na.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10172 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbaFEPBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Jun 2014 11:01:21 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert:  

Did anyone report problem on the area of authen(hmac(sha1), cbc(aes)) fallback, since linux 3-10?
I am working on android linux 3-10.
Our hardware does not support aes 192.
I am following the example from picoxcell_crypto.c. In the cra_init, driver does the following to allocate
a fallback crypto_aead.
tx->sw_cipher = crypto_alloc_aead
                                     (alg->cra_name, 0,
                                     CRYPTO_ALG_ASYNC |
                                    CRYPTO_ALG_NEED_FALLBACK);

I define two xfrm. 
They are as such:
#ip xfrm  state show
src 10.2.243.105 dst 10.2.243.29
        proto esp spi 0x00000701 reqid 0 mode transport
        replay-window 0
        auth-trunc hmac(sha256) 0x8d967d88f6caa9d714800ab3d48051d63f73a3120102030405060708090a0b 96
        enc cbc(aes) 0x7d8adc5f52e6b2291f27a4c0384624a7
        sel src 0.0.0.0/0 dst 0.0.0.0/0
src 10.2.243.29 dst 10.2.243.105
        proto esp spi 0x00000601 reqid 0 mode transport
        replay-window 0
        auth-trunc hmac(sha256) 0x8d967d88f6caa9d714800ab3d48051d63f73a3120102030405060708090a0b 96
        enc cbc(aes) 0x7d8adc5f52e6b2291f27a4c0384624a7
        sel src 0.0.0.0/0 dst 0.0.0.0/0

It seems the 2nd xfrm->__crt_alg  is pointing to software implementation algorithm, instead of our driver. 

xfrm state is aes128 ciphering and the sw implementation  is not supposedly to happen. As the result of 2nd xfrm pointing to software implementation, one direction of traffic (for the 2nd xfrm)  is "aead"ed  by software implementation.
Does it make sense? 
I put trace in crypto modules.  After 
ip xfrm state add command for both xfrm, the trace displays as included at end of this mail.
I put some notes,  with  indentation as <==, in time [132.061018], [  132.067901], [  132.104352], [  132.335460] , [  132.370316] , [  132.377779]  ,[  132.381226]   


 [  131.951846] crypto_alg_mod_lookup name hmac(sha256) type 408 mask 40e
[  131.957094] crypto_alg_lookup hmac(sha256) 408 40e
[  131.962022] crypto_alg_lookup hmac(sha256) 408 40e alg   (null)
[  131.971769]  crypto_larval_lookup. request_module hmac(sha256)
[  131.976593] crypto_alg_lookup hmac(sha256) 408 40e
[  131.981335] crypto_alg_lookup hmac(sha256) 408 40e alg   (null)
[  131.987259]  crypto_larval_lookup. crypto_larval_add hmac(sha256) 408 40e
[  131.994088] crypto_alg_mod_lookup name sha256 type 409 mask 40f
[  131.999755] crypto_alg_lookup sha256 409 40f
[  132.004236] crypto_alg_lookup sha256 409 40f alg c08308ac
[  132.009544]  return larval c08308ac
[  132.013128]  return alg cbdcf62c
[  132.016257] crypto_alg_mod_lookup name cbc(aes) type 404 mask 40c
[  132.022130] crypto_alg_lookup cbc(aes) 404 40c
[  132.026756] crypto_alg_lookup cbc(aes) 404 40c alg e73be008
[  132.032286]  return larval e73be008

[  132.035825] crypto_alg_mod_lookup name authenc(hmac(sha256),cbc(aes)) type 403 mask 40f
[  132.043571] crypto_alg_lookup authenc(hmac(sha256),cbc(aes)) 403 40f
[  132.050123] crypto_alg_lookup authenc(hmac(sha256),cbc(aes)) 403 40f alg cbb1d008
[  132.057571]  return larval cbb1d008
[  132.061018]  crypto_alloc_aead authenc(hmac(sha256),cbc(aes)) 3 f cbb1d008
       <== for the first xfrm, alg is 0xcbb1d008
[  132.067901] crypto_alg_mod_lookup name authenc(hmac(sha256),cbc(aes)) type 403 mask 58f
        <==  driver does crypto_alloc_aead() with CRYPTO_ALG_NEED_FALLBACK (0x100) set in mask.
[  132.075708] crypto_alg_lookup authenc(hmac(sha256),cbc(aes)) 403 58f
[  132.082200] crypto_alg_lookup authenc(hmac(sha256),cbc(aes)) 403 58f alg   (null)
[  132.091553] crypto_alg_lookup authenc(hmac(sha256),cbc(aes)) 403 58f
[  132.096887] crypto_alg_lookup authenc(hmac(sha256),cbc(aes)) 403 58f alg   (null)
[  132.104352]  crypto_larval_lookup. crypto_larval_add authenc(hmac(sha256),cbc(aes)) 403 58f
     <== add larval for sw implementation algorithm.
[  132.112737] crypto_alg_mod_lookup name hmac(sha256) type 40a mask 40c
[  132.118928] crypto_alg_lookup hmac(sha256) 408 40c
[  132.123862] crypto_alg_lookup hmac(sha256) 408 40c alg cbb1d910
[  132.129788]  return larval cbb1d910
[  132.133236] crypto_alg_mod_lookup name cbc(aes) type 404 mask 48c
[  132.139160] crypto_alg_lookup cbc(aes) 404 48c
[  132.143738] crypto_alg_lookup cbc(aes) 404 48c alg   (null)
[  132.152931]  crypto_larval_lookup. request_module cbc(aes)
[  132.157399] crypto_alg_lookup cbc(aes) 404 48c
[  132.161802] crypto_alg_lookup cbc(aes) 404 48c alg   (null)
[  132.167378]  crypto_larval_lookup. crypto_larval_add cbc(aes) 404 48c
[  132.173840] crypto_alg_mod_lookup name aes type 401 mask 40f
[  132.179273] crypto_alg_lookup aes 401 40f
[  132.183415] crypto_alg_lookup aes 401 40f alg c0831074
[  132.188560]  return larval c0831074
[  132.192121]  return alg cbdcf200
[  132.195245] crypto_alg_mod_lookup name cbc(aes) type 404 mask 8c
[  132.201033] crypto_alg_lookup cbc(aes) 4 8c
[  132.205406] crypto_alg_lookup cbc(aes) 4 8c alg cbdcf200
[  132.210669]  return larval cbdcf200
[  132.214168] crypto_alg_lookup cbc(aes-generic) 6 8f
[  132.219006] crypto_alg_lookup cbc(aes-generic) 6 8f alg   (null)
[  132.228647]  crypto_larval_lookup. request_module cbc(aes-generic)
[  132.233782] crypto_alg_lookup cbc(aes-generic) 6 8f
[  132.238673] crypto_alg_lookup cbc(aes-generic) 6 8f alg   (null)
[  132.244699]  crypto_larval_lookup. crypto_larval_add cbc(aes-generic) 6 8f
[  132.251494] crypto_alg_mod_lookup name stdrng type 40c mask 40f
[  132.257242] crypto_alg_lookup stdrng 40c 40f
[  132.261648] crypto_alg_lookup stdrng 40c 40f alg c08315d0
[  132.267051]  return larval c08315d0
[  132.270503] crypto_alg_mod_lookup name cbc(aes-generic) type 404 mask 68c
[  132.277122] crypto_alg_lookup cbc(aes-generic) 404 68c
[  132.282393] crypto_alg_lookup cbc(aes-generic) 404 68c alg cbdcf200
[  132.288744]  return larval cbdcf200
[  132.292208] crypto_alg_mod_lookup name hmac(sha256) type 40a mask 40c
[  132.298400] crypto_alg_lookup hmac(sha256) 408 40c
[  132.303314] crypto_alg_lookup hmac(sha256) 408 40c alg cbb1d910
[  132.309239]  return larval cbb1d910
[  132.312688] crypto_alg_mod_lookup name cbc(aes) type 404 mask 48c
[  132.318612] crypto_alg_lookup cbc(aes) 404 48c
[  132.323191] crypto_alg_lookup cbc(aes) 404 48c alg cbde2000
[  132.328769]  return larval cbde2000
 [  132.332317]  return alg cbde2a00
 [  132.335460]  crypto_alloc_aead authenc(hmac(sha256),cbc(aes)) 3 18f cbde2a00

        <=== fallback xfrm, algorithm is cbde2a00.
[  132.342465] _qcrypto_ahash_hmac_cra_init cbd2a480
[  132.347282] _qcrypto_aes-aead_setkey setkey
[  132.351488] _qcrypto_do_aead_setkey setkey
[  132.356993] crypto_alg_mod_lookup name authenc(hmac(sha256),cbc(aes)) type 403 mask 40f
     <== 2nd xfrm. NO CRYPTO_ALG_NEED_FALLBACK
[  132.363777] crypto_alg_lookup authenc(hmac(sha256),cbc(aes)) 403 40f
[  132.370316] crypto_alg_lookup authenc(hmac(sha256),cbc(aes)) 403 40f alg cbde2a00
[  132.377779]  return larval cbde2a00
     ==> why it finds the larval for the sw implementation??

[  132.381226]  crypto_alloc_aead authenc(hmac(sha256),cbc(aes)) 3 f cbde2a00
    ==> alg is cbde2a00 of sw implementation.
    ==> same as alg of fallback xfrm
[  132.388108] _qcrypto_ahash_hmac_cra_init cbd2ab80


Thanks.
Chemin
