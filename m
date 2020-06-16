Return-Path: <SRS0=4Aj0=75=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB76C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 15:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E094D20644
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 15:01:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dZTg/L5E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgFPPBk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Jun 2020 11:01:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39097 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727804AbgFPPBj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jun 2020 11:01:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592319698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R5tIC5Ro9MmDt2v+UQ6lZrEC0jg3ygcjadIpd4rwCW0=;
        b=dZTg/L5EzpO9DG4EKWC8lc7C57XtUaj+kjhijFatQpVoITadhzRy3PaLO0x+NyA/NTBJbZ
        FgZEeuSguP2vmWVrlN24lkNmHomNTXtvctelk+keyBuG3J5Gy8Lxh1Y3/soWaVgiRL52JV
        LNSq5MhsFL2qr+EmMzM39TdhCO/sDfI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-ZbLtKfBZPgO9oXiz3PSHkQ-1; Tue, 16 Jun 2020 11:01:35 -0400
X-MC-Unique: ZbLtKfBZPgO9oXiz3PSHkQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BACB3873439;
        Tue, 16 Jun 2020 15:01:34 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A071100238E;
        Tue, 16 Jun 2020 15:01:31 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 05GF1VPc028868;
        Tue, 16 Jun 2020 11:01:31 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 05GF1VDY028864;
        Tue, 16 Jun 2020 11:01:31 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 16 Jun 2020 11:01:31 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Herbert Xu <herbert@gondor.apana.org.au>
cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>,
        Milan Broz <mbroz@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] crypto: introduce CRYPTO_ALG_ALLOCATES_MEMORY
In-Reply-To: <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.2006161101080.28052@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com> <20200610010450.GA6449@gondor.apana.org.au> <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com> <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Introduce a new flag CRYPTO_ALG_ALLOCATES_MEMORY and modify dm-crypt, so
that it uses only drivers without this flag.

If the flag is set, then the crypto driver allocates memory in its request
routine. Such drivers are not suitable for disk encryption because
GFP_ATOMIC allocation can fail anytime (causing random I/O errors) and
GFP_KERNEL allocation can recurse into the block layer, causing a
deadlock.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6/include/linux/crypto.h
===================================================================
--- linux-2.6.orig/include/linux/crypto.h
+++ linux-2.6/include/linux/crypto.h
@@ -97,9 +97,15 @@
 #define CRYPTO_ALG_OPTIONAL_KEY		0x00004000
 
 /*
+ * The driver is allocating emmory in its encrypt or decrypt callback,
+ * so it should not be used to encrypt block devices.
+ */
+#define CRYPTO_ALG_ALLOCATES_MEMORY	0x00008000
+
+/*
  * Don't trigger module loading
  */
-#define CRYPTO_NOLOAD			0x00008000
+#define CRYPTO_NOLOAD			0x00010000
 
 /*
  * Transform masks and values (for crt_flags).
Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c
+++ linux-2.6/drivers/md/dm-crypt.c
@@ -419,7 +419,7 @@ static int crypt_iv_lmk_ctr(struct crypt
 		return -EINVAL;
 	}
 
-	lmk->hash_tfm = crypto_alloc_shash("md5", 0, 0);
+	lmk->hash_tfm = crypto_alloc_shash("md5", 0, CRYPTO_ALG_ALLOCATES_MEMORY);
 	if (IS_ERR(lmk->hash_tfm)) {
 		ti->error = "Error initializing LMK hash";
 		return PTR_ERR(lmk->hash_tfm);
@@ -581,7 +581,7 @@ static int crypt_iv_tcw_ctr(struct crypt
 		return -EINVAL;
 	}
 
-	tcw->crc32_tfm = crypto_alloc_shash("crc32", 0, 0);
+	tcw->crc32_tfm = crypto_alloc_shash("crc32", 0, CRYPTO_ALG_ALLOCATES_MEMORY);
 	if (IS_ERR(tcw->crc32_tfm)) {
 		ti->error = "Error initializing CRC32 in TCW";
 		return PTR_ERR(tcw->crc32_tfm);
@@ -768,7 +768,7 @@ static int crypt_iv_elephant_ctr(struct
 	struct iv_elephant_private *elephant = &cc->iv_gen_private.elephant;
 	int r;
 
-	elephant->tfm = crypto_alloc_skcipher("ecb(aes)", 0, 0);
+	elephant->tfm = crypto_alloc_skcipher("ecb(aes)", 0, CRYPTO_ALG_ALLOCATES_MEMORY);
 	if (IS_ERR(elephant->tfm)) {
 		r = PTR_ERR(elephant->tfm);
 		elephant->tfm = NULL;
@@ -2088,7 +2088,7 @@ static int crypt_alloc_tfms_skcipher(str
 		return -ENOMEM;
 
 	for (i = 0; i < cc->tfms_count; i++) {
-		cc->cipher_tfm.tfms[i] = crypto_alloc_skcipher(ciphermode, 0, 0);
+		cc->cipher_tfm.tfms[i] = crypto_alloc_skcipher(ciphermode, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
 		if (IS_ERR(cc->cipher_tfm.tfms[i])) {
 			err = PTR_ERR(cc->cipher_tfm.tfms[i]);
 			crypt_free_tfms(cc);
@@ -2114,7 +2114,7 @@ static int crypt_alloc_tfms_aead(struct
 	if (!cc->cipher_tfm.tfms)
 		return -ENOMEM;
 
-	cc->cipher_tfm.tfms_aead[0] = crypto_alloc_aead(ciphermode, 0, 0);
+	cc->cipher_tfm.tfms_aead[0] = crypto_alloc_aead(ciphermode, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
 	if (IS_ERR(cc->cipher_tfm.tfms_aead[0])) {
 		err = PTR_ERR(cc->cipher_tfm.tfms_aead[0]);
 		crypt_free_tfms(cc);
@@ -2565,7 +2565,7 @@ static int crypt_ctr_auth_cipher(struct
 		return -ENOMEM;
 	strncpy(mac_alg, start, end - start);
 
-	mac = crypto_alloc_ahash(mac_alg, 0, 0);
+	mac = crypto_alloc_ahash(mac_alg, 0, CRYPTO_ALG_ALLOCATES_MEMORY);
 	kfree(mac_alg);
 
 	if (IS_ERR(mac))

