Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEED9C433ED
	for <linux-crypto@archiver.kernel.org>; Sun,  2 May 2021 19:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5FB061284
	for <linux-crypto@archiver.kernel.org>; Sun,  2 May 2021 19:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhEBTap (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 2 May 2021 15:30:45 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:32448 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbhEBTap (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 May 2021 15:30:45 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d60 with ME
        id zvVp2400521Fzsu03vVpt8; Sun, 02 May 2021 21:29:51 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 02 May 2021 21:29:51 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [RFC PATCH] crypto: arc4: Implement a version optimized for memory usage
Date:   Sun,  2 May 2021 21:29:46 +0200
Message-Id: <c52bd8972c9763c3fac685d7c6af3c46a23a1477.1619983555.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The S array does not need to be u32, u8 is enough
On machine which have efficient unaligned access, use u8 to save some
memory.

So, provide a version optimized for memory usage in such a case.

Based on my testing, the size of arc4_ctx is:
	u8  version:  264
	u32 version: 1032

On my machine, the u8 version is about 5% faster.
It save ~800 bytes of memory or stack depending on how arc4_ctx is stored.
It is likely to be more cache friendly.

It has been tested an Core i7-3770 with the following test program:

 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>

 #define u8      unsigned char
 #define u32     unsigned int
 #define true    1

struct arc4_ctx_8 {
	u8 S[256];
	u32 x, y;
};
struct arc4_ctx_32 {
	u32 S[256];
	u32 x, y;
};

 #define S_type	u8
int arc4_setkey_8(struct arc4_ctx_8 *ctx, const u8 *in_key, unsigned int key_len)
{
	int i, j = 0, k = 0;

	ctx->x = 1;
	ctx->y = 0;

	for (i = 0; i < 256; i++)
		ctx->S[i] = i;

	for (i = 0; i < 256; i++) {
		S_type a = ctx->S[i];

		j = (j + in_key[k] + a) & 0xff;
		ctx->S[i] = ctx->S[j];
		ctx->S[j] = a;
		if (++k >= key_len)
			k = 0;
	}

	return 0;
}

void arc4_crypt_8(struct arc4_ctx_8 *ctx, u8 *out, const u8 *in, unsigned int len)
{
	S_type *const S = ctx->S;
	S_type a, b, ta, tb;
	u32 x, y, ty;

	if (len == 0)
		return;

	x = ctx->x;
	y = ctx->y;

	a = S[x];
	y = (y + a) & 0xff;
	b = S[y];

	do {
		S[y] = a;
		a = (a + b) & 0xff;
		S[x] = b;
		x = (x + 1) & 0xff;
		ta = S[x];
		ty = (y + ta) & 0xff;
		tb = S[ty];
		*out++ = *in++ ^ S[a];
		if (--len == 0)
			break;
		y = ty;
		a = ta;
		b = tb;
	} while (true);

	ctx->x = x;
	ctx->y = y;
}

 #undef S_type
 #define S_type	u32
int arc4_setkey_32(struct arc4_ctx_32 *ctx, const u8 *in_key, unsigned int key_len)
{
	int i, j = 0, k = 0;

	ctx->x = 1;
	ctx->y = 0;

	for (i = 0; i < 256; i++)
		ctx->S[i] = i;

	for (i = 0; i < 256; i++) {
		S_type a = ctx->S[i];

		j = (j + in_key[k] + a) & 0xff;
		ctx->S[i] = ctx->S[j];
		ctx->S[j] = a;
		if (++k >= key_len)
			k = 0;
	}

	return 0;
}

void arc4_crypt_32(struct arc4_ctx_32 *ctx, u8 *out, const u8 *in, unsigned int len)
{
	S_type *const S = ctx->S;
	S_type a, b, ta, tb;
	u32 x, y, ty;

	if (len == 0)
		return;

	x = ctx->x;
	y = ctx->y;

	a = S[x];
	y = (y + a) & 0xff;
	b = S[y];

	do {
		S[y] = a;
		a = (a + b) & 0xff;
		S[x] = b;
		x = (x + 1) & 0xff;
		ta = S[x];
		ty = (y + ta) & 0xff;
		tb = S[ty];
		*out++ = *in++ ^ S[a];
		if (--len == 0)
			break;
		y = ty;
		a = ta;
		b = tb;
	} while (true);

	ctx->x = x;
	ctx->y = y;
}

 #define KEY     "AZERTY"
 #define in      "AZERTYUIOP_QSDFGHJKLM_WXCVBN"

int main() {
        long i;
        struct arc4_ctx_8 ctx_8;
        u8 out8[1024] = { };
        struct arc4_ctx_32 ctx_32;
        u8 out32[1024] = { };

        arc4_setkey_8(&ctx_8, KEY, strlen(KEY));
        arc4_crypt_8(&ctx_8, out8, in, strlen(in));

        arc4_setkey_32(&ctx_32, KEY, strlen(KEY));
        arc4_crypt_32(&ctx_32, out32, in, strlen(in));

        printf("%ld vs %ld\n", sizeof(ctx_8), sizeof(ctx_32));
        if (memcmp(out8, out32, 1024) == 0)
                printf("Ok\n");
        else
                printf("Broken\n");

        return 0;
}

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
The idea came from code found in staging/rtl8712/
See at the top of:
   https://elixir.bootlin.com/linux/v5.12/source/drivers/staging/rtl8712/rtl871x_security.c

More precisely, in an attempt to clean staging/rtl8712/, I triggered the
kernel test robot about some increasing stack usage:
   https://lore.kernel.org/kernel-janitors/YHQUH+Nqc%2FzS14Tb@kroah.com/T/#m832a01a9d1517e7efc4f671ed46deae9993d6ae9

The above patch works for me, but should be taken as a RFC.
---
 include/crypto/arc4.h | 8 +++++++-
 lib/crypto/arc4.c     | 8 ++++----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/crypto/arc4.h b/include/crypto/arc4.h
index f3c22fe01704..39545ed486e2 100644
--- a/include/crypto/arc4.h
+++ b/include/crypto/arc4.h
@@ -12,8 +12,14 @@
 #define ARC4_MAX_KEY_SIZE	256
 #define ARC4_BLOCK_SIZE		1
 
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+#define S_type	u8
+#else
+#define S_type	u32
+#endif
+
 struct arc4_ctx {
-	u32 S[256];
+	S_type S[256];
 	u32 x, y;
 };
 
diff --git a/lib/crypto/arc4.c b/lib/crypto/arc4.c
index c2020f19c652..e0be0c2a08d9 100644
--- a/lib/crypto/arc4.c
+++ b/lib/crypto/arc4.c
@@ -21,7 +21,7 @@ int arc4_setkey(struct arc4_ctx *ctx, const u8 *in_key, unsigned int key_len)
 		ctx->S[i] = i;
 
 	for (i = 0; i < 256; i++) {
-		u32 a = ctx->S[i];
+		S_type a = ctx->S[i];
 
 		j = (j + in_key[k] + a) & 0xff;
 		ctx->S[i] = ctx->S[j];
@@ -36,9 +36,9 @@ EXPORT_SYMBOL(arc4_setkey);
 
 void arc4_crypt(struct arc4_ctx *ctx, u8 *out, const u8 *in, unsigned int len)
 {
-	u32 *const S = ctx->S;
-	u32 x, y, a, b;
-	u32 ty, ta, tb;
+	S_type *const S = ctx->S;
+	S_type a, b, ta, tb;
+	u32 x, y, ty;
 
 	if (len == 0)
 		return;
-- 
2.30.2

