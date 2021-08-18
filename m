Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D78E7C4320E
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Aug 2021 14:46:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0649610E8
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Aug 2021 14:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238799AbhHROrP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Aug 2021 10:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239504AbhHROrL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Aug 2021 10:47:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C776C610E8;
        Wed, 18 Aug 2021 14:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629297996;
        bh=dnNq6pJOVqMIA97HptfxlkewvfMJcMfte5he5jYR9nE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t9cQF9M/rznmq/IZpk1Caz2WuRKx0hHhNursqzQGAieboRfpQCzq4+RHwA9igD88Z
         ffj8/JRjrotXD/QMJf+Zk6nLK+iITsbiAIWoM4K90d9H81L0OMuyz4Z8YLgSHN7dqB
         071znGvWl/pnr2fdWmjr0L51e+h4AM7KsFW9/0Ck7+ZKBiFshtrMoz3yJioUFUl5IU
         4CxvQZQrSYgv07TyAwoRBEbAd5CzwPMxKPl/YEXrRJ/ElEYEkNxDtD9nuuGr96yITZ
         R22LjQ6ie14cExtBdUFRZLpeRfm4XHh3tQ8fiO6cxG16ozbSGqzjcX1Zn8cl/eiBcQ
         EAbYyeUXWng2w==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 1/2] fs/cifs: Incorporate obsolete MD4 crypto code
Date:   Wed, 18 Aug 2021 16:46:16 +0200
Message-Id: <20210818144617.110061-2-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210818144617.110061-1-ardb@kernel.org>
References: <20210818144617.110061-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

MD4 belongs in a museum, not in a modern OS kernel, but sadly, the
CIFS code still relies on it, and so we have had to keep it around.

So let's move the MD4 implementation back into the CIFS code (where
it used to reside up until 2003), so that we can drop it from the
crypto API in a subsequent patch.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 fs/cifs/Kconfig      |   1 -
 fs/cifs/cifsfs.c     |   1 -
 fs/cifs/smbencrypt.c | 200 +++++++++++++++++---
 3 files changed, 177 insertions(+), 25 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 7364950a9ef4..748f4dd3466c 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -4,7 +4,6 @@ config CIFS
 	depends on INET
 	select NLS
 	select CRYPTO
-	select CRYPTO_MD4
 	select CRYPTO_MD5
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 64b71c4e2a9d..06ce13d274f8 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1755,7 +1755,6 @@ MODULE_DESCRIPTION
 MODULE_VERSION(CIFS_VERSION);
 MODULE_SOFTDEP("ecb");
 MODULE_SOFTDEP("hmac");
-MODULE_SOFTDEP("md4");
 MODULE_SOFTDEP("md5");
 MODULE_SOFTDEP("nls");
 MODULE_SOFTDEP("aes");
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 39a938443e3e..77f720dca86f 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -38,6 +38,177 @@
 #define SSVALX(buf,pos,val) (CVAL(buf,pos)=(val)&0xFF,CVAL(buf,pos+1)=(val)>>8)
 #define SSVAL(buf,pos,val) SSVALX((buf),(pos),((__u16)(val)))
 
+#define MD4_DIGEST_SIZE		16
+#define MD4_HMAC_BLOCK_SIZE	64
+#define MD4_BLOCK_WORDS		16
+#define MD4_HASH_WORDS		4
+
+struct md4_ctx {
+	u32 hash[MD4_HASH_WORDS];
+	u32 block[MD4_BLOCK_WORDS];
+	u64 byte_count;
+};
+
+static inline u32 lshift(u32 x, unsigned int s)
+{
+	x &= 0xFFFFFFFF;
+	return ((x << s) & 0xFFFFFFFF) | (x >> (32 - s));
+}
+
+static inline u32 F(u32 x, u32 y, u32 z)
+{
+	return (x & y) | ((~x) & z);
+}
+
+static inline u32 G(u32 x, u32 y, u32 z)
+{
+	return (x & y) | (x & z) | (y & z);
+}
+
+static inline u32 H(u32 x, u32 y, u32 z)
+{
+	return x ^ y ^ z;
+}
+
+#define ROUND1(a,b,c,d,k,s) (a = lshift(a + F(b,c,d) + k, s))
+#define ROUND2(a,b,c,d,k,s) (a = lshift(a + G(b,c,d) + k + (u32)0x5A827999,s))
+#define ROUND3(a,b,c,d,k,s) (a = lshift(a + H(b,c,d) + k + (u32)0x6ED9EBA1,s))
+
+static void md4_transform(u32 *hash, u32 const *in)
+{
+	u32 a, b, c, d;
+
+	a = hash[0];
+	b = hash[1];
+	c = hash[2];
+	d = hash[3];
+
+	ROUND1(a, b, c, d, in[0], 3);
+	ROUND1(d, a, b, c, in[1], 7);
+	ROUND1(c, d, a, b, in[2], 11);
+	ROUND1(b, c, d, a, in[3], 19);
+	ROUND1(a, b, c, d, in[4], 3);
+	ROUND1(d, a, b, c, in[5], 7);
+	ROUND1(c, d, a, b, in[6], 11);
+	ROUND1(b, c, d, a, in[7], 19);
+	ROUND1(a, b, c, d, in[8], 3);
+	ROUND1(d, a, b, c, in[9], 7);
+	ROUND1(c, d, a, b, in[10], 11);
+	ROUND1(b, c, d, a, in[11], 19);
+	ROUND1(a, b, c, d, in[12], 3);
+	ROUND1(d, a, b, c, in[13], 7);
+	ROUND1(c, d, a, b, in[14], 11);
+	ROUND1(b, c, d, a, in[15], 19);
+
+	ROUND2(a, b, c, d,in[ 0], 3);
+	ROUND2(d, a, b, c, in[4], 5);
+	ROUND2(c, d, a, b, in[8], 9);
+	ROUND2(b, c, d, a, in[12], 13);
+	ROUND2(a, b, c, d, in[1], 3);
+	ROUND2(d, a, b, c, in[5], 5);
+	ROUND2(c, d, a, b, in[9], 9);
+	ROUND2(b, c, d, a, in[13], 13);
+	ROUND2(a, b, c, d, in[2], 3);
+	ROUND2(d, a, b, c, in[6], 5);
+	ROUND2(c, d, a, b, in[10], 9);
+	ROUND2(b, c, d, a, in[14], 13);
+	ROUND2(a, b, c, d, in[3], 3);
+	ROUND2(d, a, b, c, in[7], 5);
+	ROUND2(c, d, a, b, in[11], 9);
+	ROUND2(b, c, d, a, in[15], 13);
+
+	ROUND3(a, b, c, d,in[ 0], 3);
+	ROUND3(d, a, b, c, in[8], 9);
+	ROUND3(c, d, a, b, in[4], 11);
+	ROUND3(b, c, d, a, in[12], 15);
+	ROUND3(a, b, c, d, in[2], 3);
+	ROUND3(d, a, b, c, in[10], 9);
+	ROUND3(c, d, a, b, in[6], 11);
+	ROUND3(b, c, d, a, in[14], 15);
+	ROUND3(a, b, c, d, in[1], 3);
+	ROUND3(d, a, b, c, in[9], 9);
+	ROUND3(c, d, a, b, in[5], 11);
+	ROUND3(b, c, d, a, in[13], 15);
+	ROUND3(a, b, c, d, in[3], 3);
+	ROUND3(d, a, b, c, in[11], 9);
+	ROUND3(c, d, a, b, in[7], 11);
+	ROUND3(b, c, d, a, in[15], 15);
+
+	hash[0] += a;
+	hash[1] += b;
+	hash[2] += c;
+	hash[3] += d;
+}
+
+static inline void md4_transform_helper(struct md4_ctx *ctx)
+{
+	le32_to_cpu_array(ctx->block, ARRAY_SIZE(ctx->block));
+	md4_transform(ctx->hash, ctx->block);
+}
+
+static void md4_init(struct md4_ctx *mctx)
+{
+	mctx->hash[0] = 0x67452301;
+	mctx->hash[1] = 0xefcdab89;
+	mctx->hash[2] = 0x98badcfe;
+	mctx->hash[3] = 0x10325476;
+	mctx->byte_count = 0;
+}
+
+static void md4_update(struct md4_ctx *mctx, const u8 *data, unsigned int len)
+{
+	const u32 avail = sizeof(mctx->block) - (mctx->byte_count & 0x3f);
+
+	mctx->byte_count += len;
+
+	if (avail > len) {
+		memcpy((char *)mctx->block + (sizeof(mctx->block) - avail),
+		       data, len);
+		return;
+	}
+
+	memcpy((char *)mctx->block + (sizeof(mctx->block) - avail),
+	       data, avail);
+
+	md4_transform_helper(mctx);
+	data += avail;
+	len -= avail;
+
+	while (len >= sizeof(mctx->block)) {
+		memcpy(mctx->block, data, sizeof(mctx->block));
+		md4_transform_helper(mctx);
+		data += sizeof(mctx->block);
+		len -= sizeof(mctx->block);
+	}
+
+	memcpy(mctx->block, data, len);
+}
+
+static void md4_final(struct md4_ctx *mctx, u8 *out)
+{
+	const unsigned int offset = mctx->byte_count & 0x3f;
+	char *p = (char *)mctx->block + offset;
+	int padding = 56 - (offset + 1);
+
+	*p++ = 0x80;
+	if (padding < 0) {
+		memset(p, 0x00, padding + sizeof (u64));
+		md4_transform_helper(mctx);
+		p = (char *)mctx->block;
+		padding = 56;
+	}
+
+	memset(p, 0, padding);
+	mctx->block[14] = mctx->byte_count << 3;
+	mctx->block[15] = mctx->byte_count >> 29;
+	le32_to_cpu_array(mctx->block, (sizeof(mctx->block) -
+	                  sizeof(u64)) / sizeof(u32));
+	md4_transform(mctx->hash, mctx->block);
+	cpu_to_le32_array(mctx->hash, ARRAY_SIZE(mctx->hash));
+	memcpy(out, mctx->hash, sizeof(mctx->hash));
+	memset(mctx, 0, sizeof(*mctx));
+}
+
 static void
 str_to_key(unsigned char *str, unsigned char *key)
 {
@@ -108,31 +279,14 @@ E_P24(unsigned char *p21, const unsigned char *c8, unsigned char *p24)
 int
 mdfour(unsigned char *md4_hash, unsigned char *link_str, int link_len)
 {
-	int rc;
-	struct crypto_shash *md4 = NULL;
-	struct sdesc *sdescmd4 = NULL;
+	struct md4_ctx md4;
 
-	rc = cifs_alloc_hash("md4", &md4, &sdescmd4);
-	if (rc)
-		goto mdfour_err;
-
-	rc = crypto_shash_init(&sdescmd4->shash);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not init md4 shash\n", __func__);
-		goto mdfour_err;
-	}
-	rc = crypto_shash_update(&sdescmd4->shash, link_str, link_len);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not update with link_str\n", __func__);
-		goto mdfour_err;
-	}
-	rc = crypto_shash_final(&sdescmd4->shash, md4_hash);
-	if (rc)
-		cifs_dbg(VFS, "%s: Could not generate md4 hash\n", __func__);
+	md4_init(&md4);
+	md4_update(&md4, link_str, link_len);
+	md4_final(&md4, md4_hash);
 
-mdfour_err:
-	cifs_free_hash(&md4, &sdescmd4);
-	return rc;
+	memzero_explicit(&md4, sizeof(md4));
+	return 0;
 }
 
 /*
-- 
2.20.1

