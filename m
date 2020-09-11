Return-Path: <SRS0=Quof=CU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0243C433E2
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Sep 2020 06:55:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99B02221F0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Sep 2020 06:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbgIKGzK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Sep 2020 02:55:10 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58894 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgIKGzJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Sep 2020 02:55:09 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kGcxd-0007qD-3E; Fri, 11 Sep 2020 16:55:06 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2020 16:55:05 +1000
Date:   Fri, 11 Sep 2020 16:55:05 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] crypto: n2 - Fix sparse endianness warning
Message-ID: <20200911065504.GA32089@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes sparse endianness warnings by changing the type
of hash_init to u8 from u32.  There should be no difference in the
generated code.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index f137f22da8fb..3642bf83d809 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -249,7 +249,7 @@ static inline bool n2_should_run_async(struct spu_queue *qp, int this_len)
 struct n2_ahash_alg {
 	struct list_head	entry;
 	const u8		*hash_zero;
-	const u32		*hash_init;
+	const u8		*hash_init;
 	u8			hw_op_hashsz;
 	u8			digest_size;
 	u8			auth_type;
@@ -1225,7 +1225,7 @@ static LIST_HEAD(skcipher_algs);
 struct n2_hash_tmpl {
 	const char	*name;
 	const u8	*hash_zero;
-	const u32	*hash_init;
+	const u8	*hash_init;
 	u8		hw_op_hashsz;
 	u8		digest_size;
 	u8		block_size;
@@ -1233,7 +1233,7 @@ struct n2_hash_tmpl {
 	u8		hmac_type;
 };
 
-static const u32 n2_md5_init[MD5_HASH_WORDS] = {
+static const __le32 n2_md5_init[MD5_HASH_WORDS] = {
 	cpu_to_le32(MD5_H0),
 	cpu_to_le32(MD5_H1),
 	cpu_to_le32(MD5_H2),
@@ -1254,7 +1254,7 @@ static const u32 n2_sha224_init[SHA256_DIGEST_SIZE / 4] = {
 static const struct n2_hash_tmpl hash_tmpls[] = {
 	{ .name		= "md5",
 	  .hash_zero	= md5_zero_message_hash,
-	  .hash_init	= n2_md5_init,
+	  .hash_init	= (u8 *)n2_md5_init,
 	  .auth_type	= AUTH_TYPE_MD5,
 	  .hmac_type	= AUTH_TYPE_HMAC_MD5,
 	  .hw_op_hashsz	= MD5_DIGEST_SIZE,
@@ -1262,7 +1262,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .block_size	= MD5_HMAC_BLOCK_SIZE },
 	{ .name		= "sha1",
 	  .hash_zero	= sha1_zero_message_hash,
-	  .hash_init	= n2_sha1_init,
+	  .hash_init	= (u8 *)n2_sha1_init,
 	  .auth_type	= AUTH_TYPE_SHA1,
 	  .hmac_type	= AUTH_TYPE_HMAC_SHA1,
 	  .hw_op_hashsz	= SHA1_DIGEST_SIZE,
@@ -1270,7 +1270,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .block_size	= SHA1_BLOCK_SIZE },
 	{ .name		= "sha256",
 	  .hash_zero	= sha256_zero_message_hash,
-	  .hash_init	= n2_sha256_init,
+	  .hash_init	= (u8 *)n2_sha256_init,
 	  .auth_type	= AUTH_TYPE_SHA256,
 	  .hmac_type	= AUTH_TYPE_HMAC_SHA256,
 	  .hw_op_hashsz	= SHA256_DIGEST_SIZE,
@@ -1278,7 +1278,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .block_size	= SHA256_BLOCK_SIZE },
 	{ .name		= "sha224",
 	  .hash_zero	= sha224_zero_message_hash,
-	  .hash_init	= n2_sha224_init,
+	  .hash_init	= (u8 *)n2_sha224_init,
 	  .auth_type	= AUTH_TYPE_SHA256,
 	  .hmac_type	= AUTH_TYPE_RESERVED,
 	  .hw_op_hashsz	= SHA256_DIGEST_SIZE,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
