From: "Nicolas, Mario" <mario.nicolas@intel.com>
Subject: RE: cra_priority usage
Date: Fri, 2 Apr 2010 09:42:11 +0100
Message-ID: <44813D8942D35947805CBEEA94195BB0013E414BD5@irsmsx505.ger.corp.intel.com>
References: <44813D8942D35947805CBEEA94195BB0013E4145A2@irsmsx505.ger.corp.intel.com>
 <20100401085430.GA22789@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57804 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab0DBImU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 2 Apr 2010 04:42:20 -0400
In-Reply-To: <20100401085430.GA22789@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Thank you for your answer. I forgot to mention that the version of the kernel I am using is 2.6.28.10; I can't use the latest one because of the hardware I am using.

The code is below; it registers the 3 algorithms needed for IPSec. The actual implementations of the algorithms are in other files. They basically call a dedicated hardware and for that reason need to be asynchronous. I can send them if you wish.

----------------------------
/*
 * icp_netkey.c
 *
 * This is an implementation of Linux Kernel Crypto API shim that uses
 * the Intel's Quick Assist API. The focus here is IPsec, (Netkey stack).
 * 
 */

#include <linux/module.h>
#include <linux/init.h>
#include <linux/types.h>
#include <linux/errno.h>
#include <linux/crypto.h>
#include <linux/scatterlist.h>
#include <linux/rwsem.h>

#include <crypto/aead.h>
#include <crypto/algapi.h> 

#include "icp_sym_chaining.h"
#include "icp_aes_gcm.h"
#include "icp_netkey.h" 
#include "cpa.h"
#include "cpa_cy_sym.h"
#include "cpa_cy_im.h"

static icp_aead_tfm_desc_t *g_pTfm_desc_list = NULL;
static icp_aead_tfm_desc_t *g_pTfm_desc_list_head = NULL;

static struct kmem_cache *pOpDataCache = NULL;
static struct kmem_cache *pMetaCache = NULL;

static struct rw_semaphore tfm_desc_semaphore;


/* delete the tfm descriptor associated with this aead */
static void del_tfm_desc(const struct crypto_aead* const pAead)
{
    icp_aead_tfm_desc_t *pCurr = NULL;
    CpaStatus status = CPA_STATUS_SUCCESS;
    for (pCurr = g_pTfm_desc_list_head; pCurr != NULL; pCurr = pCurr->pNext)
	{
		if (pCurr->pAead == pAead)
		{
			down_write(&tfm_desc_semaphore);
            ICP_REMOVE_ELEMENT_FROM_LIST(pCurr, g_pTfm_desc_list, g_pTfm_desc_list_head);
			up_write(&tfm_desc_semaphore);
			
			if (pCurr->pEncrypt_session_ctx != NULL)
			{
				status = cpaCySymRemoveSession(CPA_INSTANCE_HANDLE_SINGLE, pCurr->pEncrypt_session_ctx);
			
				if (CPA_STATUS_SUCCESS != status)
				{
					printk("cpaCySymRemoveSession failed. (status = %d)\n", status);
					/* the session could not be removed, its memory can't be freed */
				}
				else
				{
					icp_kfree(pCurr->pEncrypt_session_ctx);
					dprintk("cpaCySymRemoveSession for Encryption was successful. (status = %d)\n", status);
				}
			}
			
			if (pCurr->pDecrypt_session_ctx != NULL)
			{
				status = cpaCySymRemoveSession(CPA_INSTANCE_HANDLE_SINGLE, pCurr->pDecrypt_session_ctx);
			
				if (CPA_STATUS_SUCCESS != status)
				{
				/* the session could not be removed, its memory can't be freed */					
					printk("cpaCySymRemoveSession failed. (status = %d)\n", status);
				}
				else
				{
					icp_kfree(pCurr->pDecrypt_session_ctx);
					dprintk("cpaCySymRemoveSession for Decryption was successful. (status = %d)\n", status);					
				}
			}

            icp_kfree(pCurr);
            dprintk("%s: tfm_desc deleted\n", __FUNCTION__);
            break;
        }
     }
}


static void  aead_auth_exit(struct crypto_tfm *pTfm)
{
	del_tfm_desc((struct crypto_aead *)(pTfm));
}


inline icp_aead_tfm_desc_t *find_tfm_desc(const struct crypto_aead* const pAead)
{
    icp_aead_tfm_desc_t *pCurr = NULL;
	down_read(&tfm_desc_semaphore);
		
    for (pCurr = g_pTfm_desc_list_head; pCurr != NULL; pCurr = pCurr->pNext)
	{
        if (pCurr->pAead == pAead)
		{
            dprintk("%s: found tfm_desc = %p\n", __FUNCTION__, pCurr);
			up_read(&tfm_desc_semaphore);
            return pCurr;
         }
    }
	up_read(&tfm_desc_semaphore);
    return NULL;
}


icp_aead_tfm_desc_t *add_tfm_desc(struct crypto_aead* const pAead)
{
    icp_aead_tfm_desc_t *pCurr = NULL;

    pCurr = find_tfm_desc(pAead);
    if (NULL != pCurr)
	{
        dprintk("%s: tfm_desc already exist for this aead\n", __FUNCTION__);
        return pCurr;
    }

    pCurr = kzalloc(sizeof(icp_aead_tfm_desc_t), GFP_ATOMIC);
    if (NULL == pCurr)
	{
        printk("%s: unable to allocate memory\n", __FUNCTION__);
        return NULL;
    }

    pCurr->pAead = pAead;
	
	down_write(&tfm_desc_semaphore);
    ICP_ADD_ELEMENT_TO_END_OF_LIST(pCurr, g_pTfm_desc_list, g_pTfm_desc_list_head);
	up_write(&tfm_desc_semaphore);

    dprintk("%s: new tfm_desc added %p\n", __FUNCTION__, pCurr);
    return pCurr;
}


static struct crypto_alg aead_authenc_3des_hmac_sha1 = {
        .cra_name               =       "authenc(hmac(sha1),cbc(des3_ede))",
        .cra_driver_name        =       "icp_aead",
        .cra_priority           =       ICP_AES_ASYNC_PRIORITY,
        .cra_flags              =       CRYPTO_ALG_TYPE_AEAD|CRYPTO_ALG_GENIV|CRYPTO_ALG_ASYNC,
        .cra_blocksize          =       DES3_BLOCK_SIZE /*8*/,
        .cra_ctxsize            =       0,
        .cra_type               =       &crypto_aead_type,
        .cra_module             =       THIS_MODULE,
        .cra_list               =       LIST_HEAD_INIT(aead_authenc_3des_hmac_sha1.cra_list),
		.cra_exit               =       aead_auth_exit,
        .cra_u                  =       {
                .aead = {
			.ivsize       = DES3_BLOCK_SIZE /*8*/,
        	.maxauthsize  = SHA1_DIGEST_SIZE /*20*/,
			.setkey       = setkey_3des_hmac_sha1,
			.setauthsize  = qat_setauthsize,
			.encrypt      = encrypt_3des_hmac_sha1,
			.decrypt      = decrypt_3des_hmac_sha1,
			.givencrypt   = geniv_encrypt_3des_hmac_sha1,
			.givdecrypt   = geniv_decrypt_3des_hmac_sha1,
                }
        }
};


static struct crypto_alg aead_authenc_aes_cbc_hmac_sha1 = {
        .cra_name               =       "authenc(hmac(sha1),cbc(aes))",
        .cra_driver_name        =       "icp_aead",
        .cra_priority           =       ICP_AES_ASYNC_PRIORITY,
        .cra_flags              =       CRYPTO_ALG_TYPE_AEAD|CRYPTO_ALG_GENIV|CRYPTO_ALG_ASYNC,
        .cra_blocksize          =       AES_BLOCK_SIZE /*16*/,
        .cra_ctxsize            =       0,
        .cra_type               =       &crypto_aead_type,
        .cra_module             =       THIS_MODULE,
        .cra_list               =       LIST_HEAD_INIT(aead_authenc_aes_cbc_hmac_sha1.cra_list),
		.cra_exit               =       aead_auth_exit,
        .cra_u                  =       {
                .aead = {
			.ivsize       = AES_BLOCK_SIZE /*16*/,
        	.maxauthsize  = SHA1_DIGEST_SIZE /*20*/,
			.setkey       = setkey_aes_cbc_hmac_sha1,
			.setauthsize  = qat_setauthsize,
			.encrypt      = encrypt_aes_cbc_hmac_sha1,
			.decrypt      = decrypt_aes_cbc_hmac_sha1,
			.givencrypt   = geniv_encrypt_aes_cbc_hmac_sha1,
			.givdecrypt   = geniv_decrypt_aes_cbc_hmac_sha1,
                }
        }
};


static struct crypto_alg aead_authenc_aes_gcm = {
        .cra_name               =       "rfc4106(gcm(aes))",
        .cra_driver_name        =       "icp_aead",
        .cra_priority           =       ICP_AES_ASYNC_PRIORITY,
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

static int __init netkey_init(void)
{
    CpaStatus status = CPA_STATUS_SUCCESS;
	Cpa32U bufferListMetaSize = 0;
	int registerStatus =0;

	init_rwsem(&tfm_desc_semaphore);
		
    status = cpaCyStartInstance(CPA_INSTANCE_HANDLE_SINGLE);
    if (CPA_STATUS_SUCCESS != status) {
        printk("cpaCyStartInstance failed. (status = %d)\n", status);
        return -EPERM;
   }

    /* Determine the size of bufferlist pPrivateMetaData */
    status = cpaCyBufferListGetMetaSize(CPA_INSTANCE_HANDLE_SINGLE,
                                            ICP_MAX_NUM_BUFFERS,
                                            &bufferListMetaSize);
    if (CPA_STATUS_SUCCESS != status)
	{
        printk("cpaCyBufferListGetMetaSize failed. (status = %d)\n", status);
		status = cpaCyStopInstance(CPA_INSTANCE_HANDLE_SINGLE);
		if (CPA_STATUS_SUCCESS != status)
		{
             printk("cpaCyStopInstance failed. (status = %d)\n", status);
        }
        return -EPERM;
    }
    dprintk("%s: cpaCyBufferListGetMetaSize = %u\n", __FUNCTION__, bufferListMetaSize);

	/*
	 * Allocation of the OpData includes the allocation space for meta data.
	 * The memory after the opData structure is reserved for this meta data.
	 */

	pOpDataCache = kmem_cache_create("icp_opdata",
					sizeof(icp_aead_op_data_t),
					0, SLAB_HWCACHE_ALIGN,  NULL);
					
	if (NULL == pOpDataCache) {
		printk("%s: unable to allocate OpData cache\n", __FUNCTION__);
		status = cpaCyStopInstance(CPA_INSTANCE_HANDLE_SINGLE);
		if (CPA_STATUS_SUCCESS != status)
		{
             printk("cpaCyStopInstance failed. (status = %d)\n", status);
        }
		return -ENOMEM;
	}

	pMetaCache = kmem_cache_create("icp_meta",
				 bufferListMetaSize,
               			 0, SLAB_HWCACHE_ALIGN, NULL);
	if (NULL == pMetaCache) {
		printk("%s: unable to allocate OpData cache\n", __FUNCTION__);
		kmem_cache_destroy(pOpDataCache);
        pOpDataCache = NULL;
		status = cpaCyStopInstance(CPA_INSTANCE_HANDLE_SINGLE);
		if (CPA_STATUS_SUCCESS != status)
		{
            printk("cpaCyStopInstance failed. (status = %d)\n", status);
		}
		return -ENOMEM;
	}
	
	registerStatus = crypto_register_alg(&aead_authenc_3des_hmac_sha1);
	if (registerStatus != 0)
	{
		printk("Register alg failed for 3DES-HMAC_SHA1\n");
		kmem_cache_destroy(pOpDataCache);
		kmem_cache_destroy(pMetaCache);
		pOpDataCache = NULL;
        pMetaCache = NULL;
		return registerStatus;
	}	
	printk("3DES-HMAC_SHA1 loaded\n");
	
	registerStatus = crypto_register_alg(&aead_authenc_aes_cbc_hmac_sha1);
	if (registerStatus != 0)
	{
		printk("Register alg failed for AES-CBC-HMAC_SHA1\n");
		kmem_cache_destroy(pOpDataCache);
		kmem_cache_destroy(pMetaCache);
		pOpDataCache = NULL;
        pMetaCache = NULL;
		return registerStatus;
	}
	printk("AES-CBC-HMAC_SHA1 loaded\n");
	
	registerStatus = crypto_register_alg(&aead_authenc_aes_gcm);
	if (registerStatus !=0)
	{
		printk("Register alg failed for AES_GCM\n");
		kmem_cache_destroy(pOpDataCache);
		kmem_cache_destroy(pMetaCache);
		pOpDataCache = NULL;
        pMetaCache = NULL;
		return registerStatus;
	}
	printk("AES_GCM loaded\n");
	printk("%s: Intel ICP NetKey Loaded.\n", __FUNCTION__);
	
	return 0;
}

static void __exit netkey_exit(void)
{
    CpaStatus status = CPA_STATUS_SUCCESS;

	printk("%s: crypto_unregister_alg()\n", __FUNCTION__);
	if (crypto_unregister_alg(&aead_authenc_3des_hmac_sha1) != 0)
	{
		printk("Unable to unload 3DES-HMAC_SHA1\n");
	}
	if (crypto_unregister_alg(&aead_authenc_aes_cbc_hmac_sha1) != 0)
	{
		printk("Unable to unload AES-CBC-HMAC_SHA1\n");
	}
	
	if (crypto_unregister_alg(&aead_authenc_aes_gcm) != 0)
	{
		printk("Unable to unload AES_GCM\n");
	}
	
    status = cpaCyStopInstance(CPA_INSTANCE_HANDLE_SINGLE);
    if (CPA_STATUS_SUCCESS != status)
	{
        printk("cpaCyStopInstance failed. (status = %d)\n", status);
    }

     if (NULL != pOpDataCache)
	 {
        kmem_cache_destroy(pOpDataCache);
        pOpDataCache = NULL;
    }
    if (NULL != pMetaCache) {
         kmem_cache_destroy(pMetaCache);
         pMetaCache = NULL;
     }
	
	/* delete all the tfm descriptors */
	while (NULL != g_pTfm_desc_list_head) {
        del_tfm_desc(g_pTfm_desc_list_head->pAead);
    } 
    printk("%s: Intel ICP NetKey Unloaded.\n", __FUNCTION__);
	
}

module_init(netkey_init);
module_exit(netkey_exit);
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("QAT ICP NETKEY");
MODULE_AUTHOR("Intel");
---------------------------------------
Thank you very much.
Best regards,

Mario

-----Original Message-----
From: Herbert Xu [mailto:herbert@gondor.apana.org.au] 
Sent: 01 April 2010 09:55
To: Nicolas, Mario
Cc: linux-crypto@vger.kernel.org
Subject: Re: cra_priority usage

Nicolas, Mario <mario.nicolas@intel.com> wrote:
> So my questions are: 
> -What is this variable used for?
> -If there are multiple implementations of the same algorithm, how is one version chosen as opposed to another one?

The one with the numerically higher priority will be used.  If
there are multiple implementations with the same priority, the
one registered last will be used.

> I guess that the reason is that an asynchronous version always has a higher priority than a synchronous one. Is that correct?

Actually this is probably a bug.  I'll have a look to see why this
is the case.  Can you please post your complete source?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--------------------------------------------------------------
Intel Shannon Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263
Business address: Dromore House, East Park, Shannon, Co. Clare

This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). Any review or distribution by others is strictly prohibited. If you are not the intended recipient, please contact the sender and delete all copies.


