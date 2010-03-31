From: "Nicolas, Mario" <mario.nicolas@intel.com>
Subject: cra_priority usage
Date: Wed, 31 Mar 2010 17:29:13 +0100
Message-ID: <44813D8942D35947805CBEEA94195BB0013E4145A2@irsmsx505.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:32452 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757635Ab0CaQ3T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 31 Mar 2010 12:29:19 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
 
I have written a module that implements GCM algorithm for LKCF (by calling dedicated hardware).

I would like to understand how the priority mechanism works in order to be sure that my module will be selected when I need to. At the moment it seems it is always used, which is great but I'd like to understand why :)
 

Here is the crypto_alg structure I am using to register the algorithm: 

static struct crypto_alg aead_authenc_aes_gcm = {
        .cra_name               =       "rfc4106(gcm(aes))",
        .cra_driver_name        =       "icp_aead",
        .cra_priority           =       ICP_AES_ASYNC_PRIORITY, /* 3001*/
        .cra_flags              =       CRYPTO_ALG_TYPE_AEAD|CRYPTO_ALG_GENIV|CRYPTO_ALG_ASYNC,
        .cra_blocksize          =       AES_BLOCK_SIZE /*16*/,
        .cra_ctxsize            =       0,
        .cra_type               =       &crypto_aead_type,
        .cra_module             =       THIS_MODULE,
        .cra_list               =       LIST_HEAD_INIT(aead_authenc_aes_gcm.cra_list),
        .cra_exit               =       aead_auth_exit,
        .cra_u                  =       {
        .aead = {
                                    .ivsize       = AES_GCM_IV_SIZE, /*8*/
                                    .maxauthsize  = AES_GCM_AUTH_TAG_LEN, /*16*/
                                    .setkey       = setkey_aes_gcm,
                                    .setauthsize  = qat_setauthsize,
                                    .encrypt      = encrypt_aes_gcm,
                                    .decrypt      = decrypt_aes_gcm,
                                    .givencrypt   = geniv_encrypt_aes_gcm,
                                    .givdecrypt   = geniv_decrypt_aes_gcm,
                }
        }
};
 

The algorithm is registered by calling crypto_register_alg in the module_init function.

It seems that my module is always used regardless of the value of the priority (I tried to set it to 0 or even to -1).
I have also tried to load the default gcm kernel module before (or after) mine but my module is selected in both cases.

I have checked in the kernel code and I did not see any location where cra_priority is used.

So my questions are: 
-What is this variable used for?
-If there are multiple implementations of the same algorithm, how is one version chosen as opposed to another one?

I guess that the reason is that an asynchronous version always has a higher priority than a synchronous one. Is that correct?

Thanks

Mario
--------------------------------------------------------------
Intel Shannon Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263
Business address: Dromore House, East Park, Shannon, Co. Clare

This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). Any review or distribution by others is strictly prohibited. If you are not the intended recipient, please contact the sender and delete all copies.


