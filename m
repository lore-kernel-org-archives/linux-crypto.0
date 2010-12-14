From: Mark Allyn <allyn@well.com>
Subject: Questions on ahash
Date: Tue, 14 Dec 2010 08:01:50 -0800 (PST)
Message-ID: <Pine.GSO.4.64.1012140750200.15150@well.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.well.com ([208.17.81.207]:57166 "EHLO smtp.well.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757739Ab0LNQIp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Dec 2010 11:08:45 -0500
Received: from well.com (well.com [10.0.101.205])
	by smtp.well.com (8.14.3/8.14.3) with ESMTP id oBEG1oCA014126
	for <linux-crypto@vger.kernel.org>; Tue, 14 Dec 2010 08:01:50 -0800
Received: from localhost (allyn@localhost)
	by well.com (8.14.2/8.14.2/Submit) with ESMTP id oBEG1o6x018002
	for <linux-crypto@vger.kernel.org>; Tue, 14 Dec 2010 08:01:50 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Folks:

I am having trouble figuring out the structures used for ahash.

First of all, I see very little commenting on the various structure 
elements.

Here is my attempt to expand out the ahash_alg structre (with my
questions interspaced . . .

This is the top level structure

struct ahash_alg {
         int (*init)(struct ahash_request *req);

***Question; What is this init for?

         int (*update)(struct ahash_request *req);
         int (*final)(struct ahash_request *req);
         int (*finup)(struct ahash_request *req);
         int (*digest)(struct ahash_request *req);
         int (*export)(struct ahash_request *req, void *out);
         int (*import)(struct ahash_request *req, const void *in);
         int (*setkey)(struct crypto_ahash *tfm, const u8 *key,
                       unsigned int keylen);

Question: If all I do for initializing my device is to set the key,
then do I even need the other three init function pointers in this
structure?

         struct hash_alg_common halg;

which is this structure
=========================================
struct hash_alg_common {
         unsigned int digestsize;
         unsigned int statesize;

         struct crypto_alg base;

#########################################3
Which in turn is this structure
struct crypto_alg {
         struct list_head cra_list;
         struct list_head cra_users;

 	u32 cra_flags;

Question: What are these flags?

         unsigned int cra_blocksize;
         unsigned int cra_ctxsize;
         unsigned int cra_alignmask;

Question: What is the alignmask?

         int cra_priority;
         atomic_t cra_refcnt;

         char cra_name[CRYPTO_MAX_ALG_NAME];
         char cra_driver_name[CRYPTO_MAX_ALG_NAME];

         const struct crypto_type *cra_type;

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Which is this structure
struct crypto_type {
         unsigned int (*ctxsize)(struct crypto_alg *alg, u32 type, u32 
mask);
         unsigned int (*extsize)(struct crypto_alg *alg);

Questions: What are these for? Is ctxsize merely the size of the
context structure that my device needs? What is extsize?

         int (*init)(struct crypto_tfm *tfm, u32 type, u32 mask);
         int (*init_tfm)(struct crypto_tfm *tfm);

Question; What is this init for? You have another one above. . .

         void (*show)(struct seq_file *m, struct crypto_alg *alg);
         struct crypto_alg *(*lookup)(const char *name, u32 type, u32 
mask);

         unsigned int type;
         unsigned int maskclear;
         unsigned int maskset;

Question: What are type, maskclear, and maskset?

         unsigned int tfmsize;
};
End of crypto_type structure (*cry_type)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

         union {
                 struct ablkcipher_alg ablkcipher;
                 struct aead_alg aead;
                 struct blkcipher_alg blkcipher;
                 struct cipher_alg cipher;
                 struct compress_alg compress;
                 struct rng_alg rng;
         } cra_u;

         int (*cra_init)(struct crypto_tfm *tfm);

Question: What is this init for? There are two others. Do I merely use my
device's init function (which sets the key) for all three of these inits?

         void (*cra_exit)(struct crypto_tfm *tfm);
         void (*cra_destroy)(struct crypto_alg *alg);

         struct module *cra_module;

Question: What is this module? Is this the same as the one defined in 
include/linux/module.h?

};
end of crypto_alg (base)
###############################################33

end of struct hash_alg_common (halg)
=========================================

};

Thank you for your help

Truly,

Mark Allyn
Portland, Oregon
www.allyn.com
971-563-7588
