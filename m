Return-Path: <SRS0=RX8q=B4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B54C433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 08:25:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5078D20789
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 08:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgHRIZe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Aug 2020 04:25:34 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42300 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgHRIZe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Aug 2020 04:25:34 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k7wvz-0000da-Pv; Tue, 18 Aug 2020 18:25:32 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 18 Aug 2020 18:25:31 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 18 Aug 2020 18:25:31 +1000
Subject: [PATCH 2/6] crypto: ahash - Add helper to free single spawn instance
References: <20200818082410.GA24497@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
        ebiggers@kernel.org, Ben Greear <greearb@candelatech.com>
Message-Id: <E1k7wvz-0000da-Pv@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds ahash_free_singlespawn_instance which is the
ahash counterpart to the shash helper.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ahash.c                 |    7 +++++++
 include/crypto/internal/hash.h |    1 +
 2 files changed, 8 insertions(+)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 68a0f0cb75c4c..3398e43d66f01 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -678,5 +678,12 @@ bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg)
 }
 EXPORT_SYMBOL_GPL(crypto_hash_alg_has_setkey);
 
+void ahash_free_singlespawn_instance(struct ahash_instance *inst)
+{
+	crypto_drop_spawn(ahash_instance_ctx(inst));
+	kfree(inst);
+}
+EXPORT_SYMBOL_GPL(ahash_free_singlespawn_instance);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous cryptographic hash type");
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 89f6f46ab2b8b..12665b72672d3 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -87,6 +87,7 @@ int crypto_register_ahashes(struct ahash_alg *algs, int count);
 void crypto_unregister_ahashes(struct ahash_alg *algs, int count);
 int ahash_register_instance(struct crypto_template *tmpl,
 			    struct ahash_instance *inst);
+void ahash_free_singlespawn_instance(struct ahash_instance *inst);
 
 int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
 		    unsigned int keylen);
