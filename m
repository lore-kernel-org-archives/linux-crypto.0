Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E10C2E95A8E
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Oct 2023 07:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345410AbjJIHc7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Oct 2023 03:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345404AbjJIHc6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Oct 2023 03:32:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131C9AB
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 00:32:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88DBC433C9
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 07:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696836776;
        bh=366zidm3mI4N6QjzW8Mm0yy828Fc1fuBFssIf3ZfewI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=GSkrcuvI9bJINX0ihHArxm0wOswmAmVMJF2P28wMo0KO/rSn06i+tx/828uF3t5lS
         AcxyTbT79CiqlOYBgoRnwrTR0EXqZ8svpayCdQ2kxJjx8kFHbaZPc1VNv0fDWejs6o
         HziMwwKhPz4jc1RevYIHtgXQmj53hQBFmdqeMy7TFF2YawVLyY9GwheBZ+G23fggXn
         /Fz1AmE55w7pCKR/B8XNZShuUKJeEeJwT2vimp6L/wFTG8gqn+EEmwZg/CSxodW2GC
         tvr33COZaxhNrwb1iaQBlfBCGT4Ltz6AdAKBR6rTLza/Y1wi+eJZZGYbGdUBilFgAq
         7MjKhetJ3/0Gw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 1/2] crypto: shash - optimize the default digest and finup
Date:   Mon,  9 Oct 2023 00:32:13 -0700
Message-ID: <20231009073214.423279-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009073214.423279-1-ebiggers@kernel.org>
References: <20231009073214.423279-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

For an shash algorithm that doesn't implement ->digest, currently
crypto_shash_digest() with aligned input makes 5 indirect calls: 1 to
shash_digest_unaligned(), 1 to ->init, 2 to ->update ('alignmask + 1'
bytes, then the rest), then 1 to ->final.  This is true even if the
algorithm implements ->finup.  This is caused by an unnecessary fallback
to code meant to handle unaligned inputs.  In fact,
crypto_shash_digest() already does the needed alignment check earlier.
Therefore, optimize the number of indirect calls for aligned inputs to 3
when the algorithm implements ->finup.  It remains at 5 when the
algorithm implements neither ->finup nor ->digest.

Similarly, for an shash algorithm that doesn't implement ->finup,
currently crypto_shash_finup() with aligned input makes 4 indirect
calls: 1 to shash_finup_unaligned(), 2 to ->update, and
1 to ->final.  Optimize this to 3 calls.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/shash.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 1fadb6b59bdcc..d99dc2f94c65f 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -184,20 +184,29 @@ int crypto_shash_final(struct shash_desc *desc, u8 *out)
 }
 EXPORT_SYMBOL_GPL(crypto_shash_final);
 
 static int shash_finup_unaligned(struct shash_desc *desc, const u8 *data,
 				 unsigned int len, u8 *out)
 {
 	return shash_update_unaligned(desc, data, len) ?:
 	       shash_final_unaligned(desc, out);
 }
 
+static int shash_default_finup(struct shash_desc *desc, const u8 *data,
+			       unsigned int len, u8 *out)
+{
+	struct shash_alg *shash = crypto_shash_alg(desc->tfm);
+
+	return shash->update(desc, data, len) ?:
+	       shash->final(desc, out);
+}
+
 int crypto_shash_finup(struct shash_desc *desc, const u8 *data,
 		       unsigned int len, u8 *out)
 {
 	struct crypto_shash *tfm = desc->tfm;
 	struct shash_alg *shash = crypto_shash_alg(tfm);
 	unsigned long alignmask = crypto_shash_alignmask(tfm);
 	int err;
 
 	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
 		struct crypto_istat_hash *istat = shash_get_stat(shash);
@@ -217,20 +226,29 @@ int crypto_shash_finup(struct shash_desc *desc, const u8 *data,
 EXPORT_SYMBOL_GPL(crypto_shash_finup);
 
 static int shash_digest_unaligned(struct shash_desc *desc, const u8 *data,
 				  unsigned int len, u8 *out)
 {
 	return crypto_shash_init(desc) ?:
 	       shash_update_unaligned(desc, data, len) ?:
 	       shash_final_unaligned(desc, out);
 }
 
+static int shash_default_digest(struct shash_desc *desc, const u8 *data,
+				unsigned int len, u8 *out)
+{
+	struct shash_alg *shash = crypto_shash_alg(desc->tfm);
+
+	return shash->init(desc) ?:
+	       shash->finup(desc, data, len, out);
+}
+
 int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *out)
 {
 	struct crypto_shash *tfm = desc->tfm;
 	struct shash_alg *shash = crypto_shash_alg(tfm);
 	unsigned long alignmask = crypto_shash_alignmask(tfm);
 	int err;
 
 	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
 		struct crypto_istat_hash *istat = shash_get_stat(shash);
@@ -649,23 +667,23 @@ static int shash_prepare_alg(struct shash_alg *alg)
 		return -EINVAL;
 
 	err = hash_prepare_alg(&alg->halg);
 	if (err)
 		return err;
 
 	base->cra_type = &crypto_shash_type;
 	base->cra_flags |= CRYPTO_ALG_TYPE_SHASH;
 
 	if (!alg->finup)
-		alg->finup = shash_finup_unaligned;
+		alg->finup = shash_default_finup;
 	if (!alg->digest)
-		alg->digest = shash_digest_unaligned;
+		alg->digest = shash_default_digest;
 	if (!alg->export) {
 		alg->export = shash_default_export;
 		alg->import = shash_default_import;
 		alg->halg.statesize = alg->descsize;
 	}
 	if (!alg->setkey)
 		alg->setkey = shash_no_setkey;
 
 	return 0;
 }
-- 
2.42.0

