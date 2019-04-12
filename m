Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B4AC282DA
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 05:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A910218D2
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 05:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555045253;
	bh=p0SKoHGM/gfEs5Ya1A5I5v9kzdYNh9n9CAiX73Dgj/E=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=1n15dluWtlxsGBrPhcYV/sUMnyJfbiFk3M/ZBXf9Hads3jktf8kYrZK9QSZ7n9ObG
	 43u/n+gX8bpPS/VV51a/nFWrKBIU/e+SVT9jaE3LN/IbSlRugvlpg+H/9avb32SlzZ
	 0jV2/iWQ586YN2xfl527YY8k1MygM/K3fT4A429s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfDLFAw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 01:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726837AbfDLFAv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 01:00:51 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33C8921872;
        Fri, 12 Apr 2019 05:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555045250;
        bh=p0SKoHGM/gfEs5Ya1A5I5v9kzdYNh9n9CAiX73Dgj/E=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=mXX5QjLvEiBxyjSzbFWrpvsHfziNLmEJbCAij9c95EuvGofK7P97fX+dqsnoIO3dp
         gyZrI55lP5euOipS+cMywInp7oz1XtF3KWzEmThDAILhqYWyTg3zj5f6rUKSI7Sgf2
         2XKvisDF6F5vVN80N2Y/L6FHWcykuC/U92xAzDN8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 3/7] crypto: testmgr - add helpers for fuzzing against generic implementation
Date:   Thu, 11 Apr 2019 21:57:38 -0700
Message-Id: <20190412045742.1725-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190412045742.1725-1-ebiggers@kernel.org>
References: <20190412045742.1725-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add some helper functions in preparation for fuzz testing algorithms
against their generic implementation.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 128 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 0e7548fb183e4..27efa3e8824ca 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -128,6 +128,7 @@ struct kpp_test_suite {
 
 struct alg_test_desc {
 	const char *alg;
+	const char *generic_driver;
 	int (*test)(const struct alg_test_desc *desc, const char *driver,
 		    u32 type, u32 mask);
 	int fips_allowed;	/* set if alg is allowed in fips mode */
@@ -745,6 +746,91 @@ static int build_cipher_test_sglists(struct cipher_test_sglists *tsgls,
 }
 
 #ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+
+/* Generate a random length in range [0, max_len], but prefer smaller values */
+static unsigned int generate_random_length(unsigned int max_len)
+{
+	unsigned int len = prandom_u32() % (max_len + 1);
+
+	switch (prandom_u32() % 4) {
+	case 0:
+		return len % 64;
+	case 1:
+		return len % 256;
+	case 2:
+		return len % 1024;
+	default:
+		return len;
+	}
+}
+
+/* Sometimes make some random changes to the given data buffer */
+static void mutate_buffer(u8 *buf, size_t count)
+{
+	size_t num_flips;
+	size_t i;
+	size_t pos;
+
+	/* Sometimes flip some bits */
+	if (prandom_u32() % 4 == 0) {
+		num_flips = min_t(size_t, 1 << (prandom_u32() % 8), count * 8);
+		for (i = 0; i < num_flips; i++) {
+			pos = prandom_u32() % (count * 8);
+			buf[pos / 8] ^= 1 << (pos % 8);
+		}
+	}
+
+	/* Sometimes flip some bytes */
+	if (prandom_u32() % 4 == 0) {
+		num_flips = min_t(size_t, 1 << (prandom_u32() % 8), count);
+		for (i = 0; i < num_flips; i++)
+			buf[prandom_u32() % count] ^= 0xff;
+	}
+}
+
+/* Randomly generate 'count' bytes, but sometimes make them "interesting" */
+static void generate_random_bytes(u8 *buf, size_t count)
+{
+	u8 b;
+	u8 increment;
+	size_t i;
+
+	if (count == 0)
+		return;
+
+	switch (prandom_u32() % 8) { /* Choose a generation strategy */
+	case 0:
+	case 1:
+		/* All the same byte, plus optional mutations */
+		switch (prandom_u32() % 4) {
+		case 0:
+			b = 0x00;
+			break;
+		case 1:
+			b = 0xff;
+			break;
+		default:
+			b = (u8)prandom_u32();
+			break;
+		}
+		memset(buf, b, count);
+		mutate_buffer(buf, count);
+		break;
+	case 2:
+		/* Ascending or descending bytes, plus optional mutations */
+		increment = (u8)prandom_u32();
+		b = (u8)prandom_u32();
+		for (i = 0; i < count; i++, b += increment)
+			buf[i] = b;
+		mutate_buffer(buf, count);
+		break;
+	default:
+		/* Fully random bytes */
+		for (i = 0; i < count; i++)
+			buf[i] = (u8)prandom_u32();
+	}
+}
+
 static char *generate_random_sgl_divisions(struct test_sg_division *divs,
 					   size_t max_divs, char *p, char *end,
 					   bool gen_flushes, u32 req_flags)
@@ -899,6 +985,48 @@ static void crypto_reenable_simd_for_test(void)
 	__this_cpu_write(crypto_simd_disabled_for_test, false);
 	preempt_enable();
 }
+
+/*
+ * Given an algorithm name, build the name of the generic implementation of that
+ * algorithm, assuming the usual naming convention.  Specifically, this appends
+ * "-generic" to every part of the name that is not a template name.  Examples:
+ *
+ *	aes => aes-generic
+ *	cbc(aes) => cbc(aes-generic)
+ *	cts(cbc(aes)) => cts(cbc(aes-generic))
+ *	rfc7539(chacha20,poly1305) => rfc7539(chacha20-generic,poly1305-generic)
+ *
+ * Return: 0 on success, or -ENAMETOOLONG if the generic name would be too long
+ */
+static int build_generic_driver_name(const char *algname,
+				     char driver_name[CRYPTO_MAX_ALG_NAME])
+{
+	const char *in = algname;
+	char *out = driver_name;
+	size_t len = strlen(algname);
+
+	if (len >= CRYPTO_MAX_ALG_NAME)
+		goto too_long;
+	do {
+		const char *in_saved = in;
+
+		while (*in && *in != '(' && *in != ')' && *in != ',')
+			*out++ = *in++;
+		if (*in != '(' && in > in_saved) {
+			len += 8;
+			if (len >= CRYPTO_MAX_ALG_NAME)
+				goto too_long;
+			memcpy(out, "-generic", 8);
+			out += 8;
+		}
+	} while ((*out++ = *in++) != '\0');
+	return 0;
+
+too_long:
+	pr_err("alg: generic driver name for \"%s\" would be too long\n",
+	       algname);
+	return -ENAMETOOLONG;
+}
 #else /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
 static void crypto_disable_simd_for_test(void)
 {
-- 
2.21.0

