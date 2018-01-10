From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-integrity: don't store cipher request on the stack (was:
 [QUESTION] hash import and request initialization)
Date: Wed, 10 Jan 2018 09:32:47 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1801100931240.7460@file01.intranet.prod.int.rdu2.redhat.com>
References: <CAOtvUMdsqEpUSSBZXxHPzuO-84B3VKxRLLN=y1cxfNbt+5qpSQ@mail.gmail.com> <20171226030751.GA11758@gondor.apana.org.au> <CAOtvUMfkGgyhCTUpfpegfmR3DNYhvfRN4oHL1tY9RMRh5sfCfQ@mail.gmail.com> <20171226104010.GA28275@gondor.apana.org.au>
 <CAOtvUMeEw88mYVjb7bDLwGb67aXi2p5e-uRXn0XrDe0uddyT6g@mail.gmail.com> <20171227033500.GA32764@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Mike Snitzer <msnitzer@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756548AbeAJOdA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jan 2018 09:33:00 -0500
In-Reply-To: <20171227033500.GA32764@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On Wed, 27 Dec 2017, Herbert Xu wrote:

> On Tue, Dec 26, 2017 at 02:21:53PM +0200, Gilad Ben-Yossef wrote:
> > 
> > See how SKCIPHER_REQUEST_ON_STACK is being used with an asymmetric skcipher
> > in drivers/md/dm-integrity.c
> 
> That's just broken.  SKCIPHER_REQUEST_ON_STACK is only meant for
> sync algorithms and this code needs to be changed to either do the
> proper request allocation or switch over to allocating sync
> algorithms.
> 
> Cheers,

Hi

Here I send a patch that moves those allocations to the heap.

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-integrity: don't store cipher request on the stack

dm-integrity: don't store cipher request on the stack

Some asynchronous cipher implementations may use DMA. The stack may be
mapped in the vmalloc area that doesn't support DMA. Therefore, the cipher
request and initialization vector shouldn't be on the stack.

This patch allocates the request and iv with kmalloc.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	$ v4.12+

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c
+++ linux-2.6/drivers/md/dm-integrity.c
@@ -2559,7 +2559,8 @@ static int create_journal(struct dm_inte
 	int r = 0;
 	unsigned i;
 	__u64 journal_pages, journal_desc_size, journal_tree_size;
-	unsigned char *crypt_data = NULL;
+	unsigned char *crypt_data = NULL, *crypt_iv = NULL;
+	struct skcipher_request *req = NULL;
 
 	ic->commit_ids[0] = cpu_to_le64(0x1111111111111111ULL);
 	ic->commit_ids[1] = cpu_to_le64(0x2222222222222222ULL);
@@ -2617,9 +2618,20 @@ static int create_journal(struct dm_inte
 
 		if (blocksize == 1) {
 			struct scatterlist *sg;
-			SKCIPHER_REQUEST_ON_STACK(req, ic->journal_crypt);
-			unsigned char iv[ivsize];
-			skcipher_request_set_tfm(req, ic->journal_crypt);
+
+			req = skcipher_request_alloc(ic->journal_crypt, GFP_KERNEL);
+			if (!req) {
+				*error = "Could not allocate crypt request";
+				r = -ENOMEM;
+				goto bad;
+			}
+
+			crypt_iv = kmalloc(ivsize, GFP_KERNEL);
+			if (!crypt_iv) {
+				*error = "Could not allocate iv";
+				r = -ENOMEM;
+				goto bad;
+			}
 
 			ic->journal_xor = dm_integrity_alloc_page_list(ic);
 			if (!ic->journal_xor) {
@@ -2641,9 +2653,9 @@ static int create_journal(struct dm_inte
 				sg_set_buf(&sg[i], va, PAGE_SIZE);
 			}
 			sg_set_buf(&sg[i], &ic->commit_ids, sizeof ic->commit_ids);
-			memset(iv, 0x00, ivsize);
+			memset(crypt_iv, 0x00, ivsize);
 
-			skcipher_request_set_crypt(req, sg, sg, PAGE_SIZE * ic->journal_pages + sizeof ic->commit_ids, iv);
+			skcipher_request_set_crypt(req, sg, sg, PAGE_SIZE * ic->journal_pages + sizeof ic->commit_ids, crypt_iv);
 			init_completion(&comp.comp);
 			comp.in_flight = (atomic_t)ATOMIC_INIT(1);
 			if (do_crypt(true, req, &comp))
@@ -2659,10 +2671,22 @@ static int create_journal(struct dm_inte
 			crypto_free_skcipher(ic->journal_crypt);
 			ic->journal_crypt = NULL;
 		} else {
-			SKCIPHER_REQUEST_ON_STACK(req, ic->journal_crypt);
-			unsigned char iv[ivsize];
 			unsigned crypt_len = roundup(ivsize, blocksize);
 
+			req = skcipher_request_alloc(ic->journal_crypt, GFP_KERNEL);
+			if (!req) {
+				*error = "Could not allocate crypt request";
+				r = -ENOMEM;
+				goto bad;
+			}
+
+			crypt_iv = kmalloc(ivsize, GFP_KERNEL);
+			if (!crypt_iv) {
+				*error = "Could not allocate iv";
+				r = -ENOMEM;
+				goto bad;
+			}
+
 			crypt_data = kmalloc(crypt_len, GFP_KERNEL);
 			if (!crypt_data) {
 				*error = "Unable to allocate crypt data";
@@ -2670,8 +2694,6 @@ static int create_journal(struct dm_inte
 				goto bad;
 			}
 
-			skcipher_request_set_tfm(req, ic->journal_crypt);
-
 			ic->journal_scatterlist = dm_integrity_alloc_journal_scatterlist(ic, ic->journal);
 			if (!ic->journal_scatterlist) {
 				*error = "Unable to allocate sg list";
@@ -2695,12 +2717,12 @@ static int create_journal(struct dm_inte
 				struct skcipher_request *section_req;
 				__u32 section_le = cpu_to_le32(i);
 
-				memset(iv, 0x00, ivsize);
+				memset(crypt_iv, 0x00, ivsize);
 				memset(crypt_data, 0x00, crypt_len);
 				memcpy(crypt_data, &section_le, min((size_t)crypt_len, sizeof(section_le)));
 
 				sg_init_one(&sg, crypt_data, crypt_len);
-				skcipher_request_set_crypt(req, &sg, &sg, crypt_len, iv);
+				skcipher_request_set_crypt(req, &sg, &sg, crypt_len, crypt_iv);
 				init_completion(&comp.comp);
 				comp.in_flight = (atomic_t)ATOMIC_INIT(1);
 				if (do_crypt(true, req, &comp))
@@ -2758,6 +2780,9 @@ retest_commit_id:
 	}
 bad:
 	kfree(crypt_data);
+	kfree(crypt_iv);
+	skcipher_request_free(req);
+
 	return r;
 }
 
