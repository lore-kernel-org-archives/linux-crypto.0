Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3708C43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 13:30:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3488212F5
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 13:30:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="R2SSGOsz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbfFXNax (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 09:30:53 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37877 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731146AbfFXNax (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 09:30:53 -0400
Received: by mail-wr1-f68.google.com with SMTP id v14so13939301wrr.4
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jun 2019 06:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wbpSbBzvlY2341AHV3nl2ufpbdWGkb7BSkXa/AWYJlg=;
        b=R2SSGOszbHj2vRHfmybyFY9NABk5goBsc+ksOz6sVBuVBf85i81w3YdwtVW6FL4Eyz
         SdWG79tjWD058S81TxZ27/1uQnX8VxuGKbFrPUUBEaosWJqoaEf9Js7gIjphZlIJ6aZF
         i9aBYG6HAYMDkp8QYcCsuNt0DF6phn2sz1xOFjTBgAcBsklbT4BBWeE88zvhjrOhrI9z
         4p9puLYs+lmQehnqZKkwtzU4mfkzDaLC9aPXyjbx5LYt2Bc7oUERSmMt+eV4//M1Pl/Q
         34HyddEVGGwK11g/TKdQ7/PQJ0JXUoXUbTRId17OSs60XnrNsBvJl+R3e71vlYmN+QYu
         AZbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wbpSbBzvlY2341AHV3nl2ufpbdWGkb7BSkXa/AWYJlg=;
        b=KhM0Hux/n+1mtitO4K/XUFlxzrIliIlNgcZkZEvyLAXN6LyaTTB7GcAC6X41ioT051
         71KGl6ghgRAkESbf6a3vFniwmhCW1DOTl5NlMOyMMTvS7kvdlHDZGPLiwZqCnvXaXvwB
         VUJgkANIe11NffCG496VI3HpppoK7yfWy716+RS4Cov8F7dsIuKvfKzKDPMS0kUEW9Hw
         fTaB44/gkqGv55dEJ3c8AfvGNCuZVSsrVCZKBMBWJ2wfLXTdXYTG0wyyAhGYf+MwrIlf
         U10evfXDmCPUUvDBAcAPhJlGvm2rf81lSwsu/lEc+vmXUEGHi7r5r6I2qdFj6vjCFJwb
         qE4g==
X-Gm-Message-State: APjAAAX7qpNHxiOxfctTvjb/ALwHZqtxjTQyMwLN9FjX0lnblm3+Dv7X
        vxdV8dT5CQlMiQdJkv0vJQhm7YqthnAXNA==
X-Google-Smtp-Source: APXvYqy/AYMfptioS/x9BzfU256rLCFiWprFWswV8DyMx9fYqC8XjNO+TYMFJCVhD/iUMLQQbfC5mA==
X-Received: by 2002:adf:ec12:: with SMTP id x18mr77481672wrn.145.1561383045912;
        Mon, 24 Jun 2019 06:30:45 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4866:7cdc:a930:8455])
        by smtp.gmail.com with ESMTPSA id j17sm8954844wrw.6.2019.06.24.06.30.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 06:30:45 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC/RFT PATCH] crypto: aes/generic - use unaligned loads to eliminate 50% of lookup tables
Date:   Mon, 24 Jun 2019 15:30:41 +0200
Message-Id: <20190624133042.7422-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The generic table based AES implementation uses 16 KB worth of lookup
tables, where 4 base tables of 1 KB each are emitted three additional
times with the coefficients rotated by 1, 2 and 3 bytes, respectively.

Given that many architectures tolerate unaligned accesses at moderate
cost, we can sacrifice a bit of performance and reduce the D-cache
footprint of these tables by 50%, by merging the prerotated coefficients
into a single table consisting of entries of double width. For instance,
the first entry of crypto_ft_tab, is currently emitted four times, each
1024 bytes apart, as

  0xa56363c6
  0x6363c6a5
  0x63c6a563
  0xc6a56363

Instead, we can emit a single entry

  0xa56363c6a56363c6

and replace the 1024 byte offset with a 1 byte offset.

Since the performance penalty of using unaligned accesses is not
data dependent, reducing the D-cache footprint like this should
hopefully reduce the time variance of this code, i.e., the correlation
between bits of the key and the processing latency.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
This is mostly a discussion piece, since it won't apply cleanly at the moment,
and it lacks some handling for other users of the lookup tables exported by
this driver (ARM/arm64 scalar AES and AEGIS). However, since it looks like we
will be dropping the x86 AES asm drivers, systems without AES-NI instructions
will be falling back to this generic driver instead.

The assumption is that the reduced D-cache footprint will make it harder to
infer key bits from processing latency, based on the fact that more table
lookups will hit cachelines that were brought in by prior table lookups,
hence reducing the colleration between timing and data.

I'd be interested in comments, and if you care about the performance of this
code on your system, please come back with benchmark numbers (tcrypt mode 200)

 crypto/Kconfig       |  11 +
 crypto/aes_generic.c | 583 ++++++++++----------
 include/crypto/aes.h |  14 +-
 3 files changed, 324 insertions(+), 284 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index c4b96f2e1344..f16934e0efb7 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1084,6 +1084,17 @@ config CRYPTO_AES
 
 	  See <http://csrc.nist.gov/CryptoToolkit/aes/> for more information.
 
+config CRYPTO_AES_REDUCED_TABLES
+	bool "Use reduced AES table set"
+	depends on CRYPTO_AES && HAVE_EFFICIENT_UNALIGNED_ACCESS
+	default y
+	help
+	  Use a set of AES lookup tables that is only half the size, but
+	  uses unaligned accesses to fetch the data. Given that the D-cache
+	  pressure of table based AES induces timing variances that can
+	  sometimes be exploited to infer key bits when the plaintext is
+	  known, this should typically be left enabled.
+
 config CRYPTO_AES_TI
 	tristate "Fixed time AES cipher"
 	select CRYPTO_ALGAPI
diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index f217568917e4..4fbf04c84604 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -56,6 +56,12 @@
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
+#ifdef CONFIG_CRYPTO_AES_REDUCED_TABLES
+#define W(w)	(((u64)(w) << 32) | (w))
+#else
+#define W(w)	(w)
+#endif
+
 static inline u8 byte(const u32 x, const unsigned n)
 {
 	return x >> (n << 3);
@@ -64,72 +70,73 @@ static inline u8 byte(const u32 x, const unsigned n)
 static const u32 rco_tab[10] = { 1, 2, 4, 8, 16, 32, 64, 128, 27, 54 };
 
 /* cacheline-aligned to facilitate prefetching into cache */
-__visible const u32 crypto_ft_tab[4][256] ____cacheline_aligned = {
+__visible const aes_table_word_t crypto_ft_tab[][256] ____cacheline_aligned = {
 	{
-		0xa56363c6, 0x847c7cf8, 0x997777ee, 0x8d7b7bf6,
-		0x0df2f2ff, 0xbd6b6bd6, 0xb16f6fde, 0x54c5c591,
-		0x50303060, 0x03010102, 0xa96767ce, 0x7d2b2b56,
-		0x19fefee7, 0x62d7d7b5, 0xe6abab4d, 0x9a7676ec,
-		0x45caca8f, 0x9d82821f, 0x40c9c989, 0x877d7dfa,
-		0x15fafaef, 0xeb5959b2, 0xc947478e, 0x0bf0f0fb,
-		0xecadad41, 0x67d4d4b3, 0xfda2a25f, 0xeaafaf45,
-		0xbf9c9c23, 0xf7a4a453, 0x967272e4, 0x5bc0c09b,
-		0xc2b7b775, 0x1cfdfde1, 0xae93933d, 0x6a26264c,
-		0x5a36366c, 0x413f3f7e, 0x02f7f7f5, 0x4fcccc83,
-		0x5c343468, 0xf4a5a551, 0x34e5e5d1, 0x08f1f1f9,
-		0x937171e2, 0x73d8d8ab, 0x53313162, 0x3f15152a,
-		0x0c040408, 0x52c7c795, 0x65232346, 0x5ec3c39d,
-		0x28181830, 0xa1969637, 0x0f05050a, 0xb59a9a2f,
-		0x0907070e, 0x36121224, 0x9b80801b, 0x3de2e2df,
-		0x26ebebcd, 0x6927274e, 0xcdb2b27f, 0x9f7575ea,
-		0x1b090912, 0x9e83831d, 0x742c2c58, 0x2e1a1a34,
-		0x2d1b1b36, 0xb26e6edc, 0xee5a5ab4, 0xfba0a05b,
-		0xf65252a4, 0x4d3b3b76, 0x61d6d6b7, 0xceb3b37d,
-		0x7b292952, 0x3ee3e3dd, 0x712f2f5e, 0x97848413,
-		0xf55353a6, 0x68d1d1b9, 0x00000000, 0x2cededc1,
-		0x60202040, 0x1ffcfce3, 0xc8b1b179, 0xed5b5bb6,
-		0xbe6a6ad4, 0x46cbcb8d, 0xd9bebe67, 0x4b393972,
-		0xde4a4a94, 0xd44c4c98, 0xe85858b0, 0x4acfcf85,
-		0x6bd0d0bb, 0x2aefefc5, 0xe5aaaa4f, 0x16fbfbed,
-		0xc5434386, 0xd74d4d9a, 0x55333366, 0x94858511,
-		0xcf45458a, 0x10f9f9e9, 0x06020204, 0x817f7ffe,
-		0xf05050a0, 0x443c3c78, 0xba9f9f25, 0xe3a8a84b,
-		0xf35151a2, 0xfea3a35d, 0xc0404080, 0x8a8f8f05,
-		0xad92923f, 0xbc9d9d21, 0x48383870, 0x04f5f5f1,
-		0xdfbcbc63, 0xc1b6b677, 0x75dadaaf, 0x63212142,
-		0x30101020, 0x1affffe5, 0x0ef3f3fd, 0x6dd2d2bf,
-		0x4ccdcd81, 0x140c0c18, 0x35131326, 0x2fececc3,
-		0xe15f5fbe, 0xa2979735, 0xcc444488, 0x3917172e,
-		0x57c4c493, 0xf2a7a755, 0x827e7efc, 0x473d3d7a,
-		0xac6464c8, 0xe75d5dba, 0x2b191932, 0x957373e6,
-		0xa06060c0, 0x98818119, 0xd14f4f9e, 0x7fdcdca3,
-		0x66222244, 0x7e2a2a54, 0xab90903b, 0x8388880b,
-		0xca46468c, 0x29eeeec7, 0xd3b8b86b, 0x3c141428,
-		0x79dedea7, 0xe25e5ebc, 0x1d0b0b16, 0x76dbdbad,
-		0x3be0e0db, 0x56323264, 0x4e3a3a74, 0x1e0a0a14,
-		0xdb494992, 0x0a06060c, 0x6c242448, 0xe45c5cb8,
-		0x5dc2c29f, 0x6ed3d3bd, 0xefacac43, 0xa66262c4,
-		0xa8919139, 0xa4959531, 0x37e4e4d3, 0x8b7979f2,
-		0x32e7e7d5, 0x43c8c88b, 0x5937376e, 0xb76d6dda,
-		0x8c8d8d01, 0x64d5d5b1, 0xd24e4e9c, 0xe0a9a949,
-		0xb46c6cd8, 0xfa5656ac, 0x07f4f4f3, 0x25eaeacf,
-		0xaf6565ca, 0x8e7a7af4, 0xe9aeae47, 0x18080810,
-		0xd5baba6f, 0x887878f0, 0x6f25254a, 0x722e2e5c,
-		0x241c1c38, 0xf1a6a657, 0xc7b4b473, 0x51c6c697,
-		0x23e8e8cb, 0x7cdddda1, 0x9c7474e8, 0x211f1f3e,
-		0xdd4b4b96, 0xdcbdbd61, 0x868b8b0d, 0x858a8a0f,
-		0x907070e0, 0x423e3e7c, 0xc4b5b571, 0xaa6666cc,
-		0xd8484890, 0x05030306, 0x01f6f6f7, 0x120e0e1c,
-		0xa36161c2, 0x5f35356a, 0xf95757ae, 0xd0b9b969,
-		0x91868617, 0x58c1c199, 0x271d1d3a, 0xb99e9e27,
-		0x38e1e1d9, 0x13f8f8eb, 0xb398982b, 0x33111122,
-		0xbb6969d2, 0x70d9d9a9, 0x898e8e07, 0xa7949433,
-		0xb69b9b2d, 0x221e1e3c, 0x92878715, 0x20e9e9c9,
-		0x49cece87, 0xff5555aa, 0x78282850, 0x7adfdfa5,
-		0x8f8c8c03, 0xf8a1a159, 0x80898909, 0x170d0d1a,
-		0xdabfbf65, 0x31e6e6d7, 0xc6424284, 0xb86868d0,
-		0xc3414182, 0xb0999929, 0x772d2d5a, 0x110f0f1e,
-		0xcbb0b07b, 0xfc5454a8, 0xd6bbbb6d, 0x3a16162c,
+		W(0xa56363c6), W(0x847c7cf8), W(0x997777ee), W(0x8d7b7bf6),
+		W(0x0df2f2ff), W(0xbd6b6bd6), W(0xb16f6fde), W(0x54c5c591),
+		W(0x50303060), W(0x03010102), W(0xa96767ce), W(0x7d2b2b56),
+		W(0x19fefee7), W(0x62d7d7b5), W(0xe6abab4d), W(0x9a7676ec),
+		W(0x45caca8f), W(0x9d82821f), W(0x40c9c989), W(0x877d7dfa),
+		W(0x15fafaef), W(0xeb5959b2), W(0xc947478e), W(0x0bf0f0fb),
+		W(0xecadad41), W(0x67d4d4b3), W(0xfda2a25f), W(0xeaafaf45),
+		W(0xbf9c9c23), W(0xf7a4a453), W(0x967272e4), W(0x5bc0c09b),
+		W(0xc2b7b775), W(0x1cfdfde1), W(0xae93933d), W(0x6a26264c),
+		W(0x5a36366c), W(0x413f3f7e), W(0x02f7f7f5), W(0x4fcccc83),
+		W(0x5c343468), W(0xf4a5a551), W(0x34e5e5d1), W(0x08f1f1f9),
+		W(0x937171e2), W(0x73d8d8ab), W(0x53313162), W(0x3f15152a),
+		W(0x0c040408), W(0x52c7c795), W(0x65232346), W(0x5ec3c39d),
+		W(0x28181830), W(0xa1969637), W(0x0f05050a), W(0xb59a9a2f),
+		W(0x0907070e), W(0x36121224), W(0x9b80801b), W(0x3de2e2df),
+		W(0x26ebebcd), W(0x6927274e), W(0xcdb2b27f), W(0x9f7575ea),
+		W(0x1b090912), W(0x9e83831d), W(0x742c2c58), W(0x2e1a1a34),
+		W(0x2d1b1b36), W(0xb26e6edc), W(0xee5a5ab4), W(0xfba0a05b),
+		W(0xf65252a4), W(0x4d3b3b76), W(0x61d6d6b7), W(0xceb3b37d),
+		W(0x7b292952), W(0x3ee3e3dd), W(0x712f2f5e), W(0x97848413),
+		W(0xf55353a6), W(0x68d1d1b9), W(0x00000000), W(0x2cededc1),
+		W(0x60202040), W(0x1ffcfce3), W(0xc8b1b179), W(0xed5b5bb6),
+		W(0xbe6a6ad4), W(0x46cbcb8d), W(0xd9bebe67), W(0x4b393972),
+		W(0xde4a4a94), W(0xd44c4c98), W(0xe85858b0), W(0x4acfcf85),
+		W(0x6bd0d0bb), W(0x2aefefc5), W(0xe5aaaa4f), W(0x16fbfbed),
+		W(0xc5434386), W(0xd74d4d9a), W(0x55333366), W(0x94858511),
+		W(0xcf45458a), W(0x10f9f9e9), W(0x06020204), W(0x817f7ffe),
+		W(0xf05050a0), W(0x443c3c78), W(0xba9f9f25), W(0xe3a8a84b),
+		W(0xf35151a2), W(0xfea3a35d), W(0xc0404080), W(0x8a8f8f05),
+		W(0xad92923f), W(0xbc9d9d21), W(0x48383870), W(0x04f5f5f1),
+		W(0xdfbcbc63), W(0xc1b6b677), W(0x75dadaaf), W(0x63212142),
+		W(0x30101020), W(0x1affffe5), W(0x0ef3f3fd), W(0x6dd2d2bf),
+		W(0x4ccdcd81), W(0x140c0c18), W(0x35131326), W(0x2fececc3),
+		W(0xe15f5fbe), W(0xa2979735), W(0xcc444488), W(0x3917172e),
+		W(0x57c4c493), W(0xf2a7a755), W(0x827e7efc), W(0x473d3d7a),
+		W(0xac6464c8), W(0xe75d5dba), W(0x2b191932), W(0x957373e6),
+		W(0xa06060c0), W(0x98818119), W(0xd14f4f9e), W(0x7fdcdca3),
+		W(0x66222244), W(0x7e2a2a54), W(0xab90903b), W(0x8388880b),
+		W(0xca46468c), W(0x29eeeec7), W(0xd3b8b86b), W(0x3c141428),
+		W(0x79dedea7), W(0xe25e5ebc), W(0x1d0b0b16), W(0x76dbdbad),
+		W(0x3be0e0db), W(0x56323264), W(0x4e3a3a74), W(0x1e0a0a14),
+		W(0xdb494992), W(0x0a06060c), W(0x6c242448), W(0xe45c5cb8),
+		W(0x5dc2c29f), W(0x6ed3d3bd), W(0xefacac43), W(0xa66262c4),
+		W(0xa8919139), W(0xa4959531), W(0x37e4e4d3), W(0x8b7979f2),
+		W(0x32e7e7d5), W(0x43c8c88b), W(0x5937376e), W(0xb76d6dda),
+		W(0x8c8d8d01), W(0x64d5d5b1), W(0xd24e4e9c), W(0xe0a9a949),
+		W(0xb46c6cd8), W(0xfa5656ac), W(0x07f4f4f3), W(0x25eaeacf),
+		W(0xaf6565ca), W(0x8e7a7af4), W(0xe9aeae47), W(0x18080810),
+		W(0xd5baba6f), W(0x887878f0), W(0x6f25254a), W(0x722e2e5c),
+		W(0x241c1c38), W(0xf1a6a657), W(0xc7b4b473), W(0x51c6c697),
+		W(0x23e8e8cb), W(0x7cdddda1), W(0x9c7474e8), W(0x211f1f3e),
+		W(0xdd4b4b96), W(0xdcbdbd61), W(0x868b8b0d), W(0x858a8a0f),
+		W(0x907070e0), W(0x423e3e7c), W(0xc4b5b571), W(0xaa6666cc),
+		W(0xd8484890), W(0x05030306), W(0x01f6f6f7), W(0x120e0e1c),
+		W(0xa36161c2), W(0x5f35356a), W(0xf95757ae), W(0xd0b9b969),
+		W(0x91868617), W(0x58c1c199), W(0x271d1d3a), W(0xb99e9e27),
+		W(0x38e1e1d9), W(0x13f8f8eb), W(0xb398982b), W(0x33111122),
+		W(0xbb6969d2), W(0x70d9d9a9), W(0x898e8e07), W(0xa7949433),
+		W(0xb69b9b2d), W(0x221e1e3c), W(0x92878715), W(0x20e9e9c9),
+		W(0x49cece87), W(0xff5555aa), W(0x78282850), W(0x7adfdfa5),
+		W(0x8f8c8c03), W(0xf8a1a159), W(0x80898909), W(0x170d0d1a),
+		W(0xdabfbf65), W(0x31e6e6d7), W(0xc6424284), W(0xb86868d0),
+		W(0xc3414182), W(0xb0999929), W(0x772d2d5a), W(0x110f0f1e),
+		W(0xcbb0b07b), W(0xfc5454a8), W(0xd6bbbb6d), W(0x3a16162c),
+#ifndef CONFIG_CRYPTO_AES_REDUCED_TABLES
 	}, {
 		0x6363c6a5, 0x7c7cf884, 0x7777ee99, 0x7b7bf68d,
 		0xf2f2ff0d, 0x6b6bd6bd, 0x6f6fdeb1, 0xc5c59154,
@@ -325,75 +332,77 @@ __visible const u32 crypto_ft_tab[4][256] ____cacheline_aligned = {
 		0x65dabfbf, 0xd731e6e6, 0x84c64242, 0xd0b86868,
 		0x82c34141, 0x29b09999, 0x5a772d2d, 0x1e110f0f,
 		0x7bcbb0b0, 0xa8fc5454, 0x6dd6bbbb, 0x2c3a1616,
+#endif
 	}
 };
 
-__visible const u32 crypto_fl_tab[4][256] ____cacheline_aligned = {
+__visible const aes_table_word_t crypto_fl_tab[][256] ____cacheline_aligned = {
 	{
-		0x00000063, 0x0000007c, 0x00000077, 0x0000007b,
-		0x000000f2, 0x0000006b, 0x0000006f, 0x000000c5,
-		0x00000030, 0x00000001, 0x00000067, 0x0000002b,
-		0x000000fe, 0x000000d7, 0x000000ab, 0x00000076,
-		0x000000ca, 0x00000082, 0x000000c9, 0x0000007d,
-		0x000000fa, 0x00000059, 0x00000047, 0x000000f0,
-		0x000000ad, 0x000000d4, 0x000000a2, 0x000000af,
-		0x0000009c, 0x000000a4, 0x00000072, 0x000000c0,
-		0x000000b7, 0x000000fd, 0x00000093, 0x00000026,
-		0x00000036, 0x0000003f, 0x000000f7, 0x000000cc,
-		0x00000034, 0x000000a5, 0x000000e5, 0x000000f1,
-		0x00000071, 0x000000d8, 0x00000031, 0x00000015,
-		0x00000004, 0x000000c7, 0x00000023, 0x000000c3,
-		0x00000018, 0x00000096, 0x00000005, 0x0000009a,
-		0x00000007, 0x00000012, 0x00000080, 0x000000e2,
-		0x000000eb, 0x00000027, 0x000000b2, 0x00000075,
-		0x00000009, 0x00000083, 0x0000002c, 0x0000001a,
-		0x0000001b, 0x0000006e, 0x0000005a, 0x000000a0,
-		0x00000052, 0x0000003b, 0x000000d6, 0x000000b3,
-		0x00000029, 0x000000e3, 0x0000002f, 0x00000084,
-		0x00000053, 0x000000d1, 0x00000000, 0x000000ed,
-		0x00000020, 0x000000fc, 0x000000b1, 0x0000005b,
-		0x0000006a, 0x000000cb, 0x000000be, 0x00000039,
-		0x0000004a, 0x0000004c, 0x00000058, 0x000000cf,
-		0x000000d0, 0x000000ef, 0x000000aa, 0x000000fb,
-		0x00000043, 0x0000004d, 0x00000033, 0x00000085,
-		0x00000045, 0x000000f9, 0x00000002, 0x0000007f,
-		0x00000050, 0x0000003c, 0x0000009f, 0x000000a8,
-		0x00000051, 0x000000a3, 0x00000040, 0x0000008f,
-		0x00000092, 0x0000009d, 0x00000038, 0x000000f5,
-		0x000000bc, 0x000000b6, 0x000000da, 0x00000021,
-		0x00000010, 0x000000ff, 0x000000f3, 0x000000d2,
-		0x000000cd, 0x0000000c, 0x00000013, 0x000000ec,
-		0x0000005f, 0x00000097, 0x00000044, 0x00000017,
-		0x000000c4, 0x000000a7, 0x0000007e, 0x0000003d,
-		0x00000064, 0x0000005d, 0x00000019, 0x00000073,
-		0x00000060, 0x00000081, 0x0000004f, 0x000000dc,
-		0x00000022, 0x0000002a, 0x00000090, 0x00000088,
-		0x00000046, 0x000000ee, 0x000000b8, 0x00000014,
-		0x000000de, 0x0000005e, 0x0000000b, 0x000000db,
-		0x000000e0, 0x00000032, 0x0000003a, 0x0000000a,
-		0x00000049, 0x00000006, 0x00000024, 0x0000005c,
-		0x000000c2, 0x000000d3, 0x000000ac, 0x00000062,
-		0x00000091, 0x00000095, 0x000000e4, 0x00000079,
-		0x000000e7, 0x000000c8, 0x00000037, 0x0000006d,
-		0x0000008d, 0x000000d5, 0x0000004e, 0x000000a9,
-		0x0000006c, 0x00000056, 0x000000f4, 0x000000ea,
-		0x00000065, 0x0000007a, 0x000000ae, 0x00000008,
-		0x000000ba, 0x00000078, 0x00000025, 0x0000002e,
-		0x0000001c, 0x000000a6, 0x000000b4, 0x000000c6,
-		0x000000e8, 0x000000dd, 0x00000074, 0x0000001f,
-		0x0000004b, 0x000000bd, 0x0000008b, 0x0000008a,
-		0x00000070, 0x0000003e, 0x000000b5, 0x00000066,
-		0x00000048, 0x00000003, 0x000000f6, 0x0000000e,
-		0x00000061, 0x00000035, 0x00000057, 0x000000b9,
-		0x00000086, 0x000000c1, 0x0000001d, 0x0000009e,
-		0x000000e1, 0x000000f8, 0x00000098, 0x00000011,
-		0x00000069, 0x000000d9, 0x0000008e, 0x00000094,
-		0x0000009b, 0x0000001e, 0x00000087, 0x000000e9,
-		0x000000ce, 0x00000055, 0x00000028, 0x000000df,
-		0x0000008c, 0x000000a1, 0x00000089, 0x0000000d,
-		0x000000bf, 0x000000e6, 0x00000042, 0x00000068,
-		0x00000041, 0x00000099, 0x0000002d, 0x0000000f,
-		0x000000b0, 0x00000054, 0x000000bb, 0x00000016,
+		W(0x00000063), W(0x0000007c), W(0x00000077), W(0x0000007b),
+		W(0x000000f2), W(0x0000006b), W(0x0000006f), W(0x000000c5),
+		W(0x00000030), W(0x00000001), W(0x00000067), W(0x0000002b),
+		W(0x000000fe), W(0x000000d7), W(0x000000ab), W(0x00000076),
+		W(0x000000ca), W(0x00000082), W(0x000000c9), W(0x0000007d),
+		W(0x000000fa), W(0x00000059), W(0x00000047), W(0x000000f0),
+		W(0x000000ad), W(0x000000d4), W(0x000000a2), W(0x000000af),
+		W(0x0000009c), W(0x000000a4), W(0x00000072), W(0x000000c0),
+		W(0x000000b7), W(0x000000fd), W(0x00000093), W(0x00000026),
+		W(0x00000036), W(0x0000003f), W(0x000000f7), W(0x000000cc),
+		W(0x00000034), W(0x000000a5), W(0x000000e5), W(0x000000f1),
+		W(0x00000071), W(0x000000d8), W(0x00000031), W(0x00000015),
+		W(0x00000004), W(0x000000c7), W(0x00000023), W(0x000000c3),
+		W(0x00000018), W(0x00000096), W(0x00000005), W(0x0000009a),
+		W(0x00000007), W(0x00000012), W(0x00000080), W(0x000000e2),
+		W(0x000000eb), W(0x00000027), W(0x000000b2), W(0x00000075),
+		W(0x00000009), W(0x00000083), W(0x0000002c), W(0x0000001a),
+		W(0x0000001b), W(0x0000006e), W(0x0000005a), W(0x000000a0),
+		W(0x00000052), W(0x0000003b), W(0x000000d6), W(0x000000b3),
+		W(0x00000029), W(0x000000e3), W(0x0000002f), W(0x00000084),
+		W(0x00000053), W(0x000000d1), W(0x00000000), W(0x000000ed),
+		W(0x00000020), W(0x000000fc), W(0x000000b1), W(0x0000005b),
+		W(0x0000006a), W(0x000000cb), W(0x000000be), W(0x00000039),
+		W(0x0000004a), W(0x0000004c), W(0x00000058), W(0x000000cf),
+		W(0x000000d0), W(0x000000ef), W(0x000000aa), W(0x000000fb),
+		W(0x00000043), W(0x0000004d), W(0x00000033), W(0x00000085),
+		W(0x00000045), W(0x000000f9), W(0x00000002), W(0x0000007f),
+		W(0x00000050), W(0x0000003c), W(0x0000009f), W(0x000000a8),
+		W(0x00000051), W(0x000000a3), W(0x00000040), W(0x0000008f),
+		W(0x00000092), W(0x0000009d), W(0x00000038), W(0x000000f5),
+		W(0x000000bc), W(0x000000b6), W(0x000000da), W(0x00000021),
+		W(0x00000010), W(0x000000ff), W(0x000000f3), W(0x000000d2),
+		W(0x000000cd), W(0x0000000c), W(0x00000013), W(0x000000ec),
+		W(0x0000005f), W(0x00000097), W(0x00000044), W(0x00000017),
+		W(0x000000c4), W(0x000000a7), W(0x0000007e), W(0x0000003d),
+		W(0x00000064), W(0x0000005d), W(0x00000019), W(0x00000073),
+		W(0x00000060), W(0x00000081), W(0x0000004f), W(0x000000dc),
+		W(0x00000022), W(0x0000002a), W(0x00000090), W(0x00000088),
+		W(0x00000046), W(0x000000ee), W(0x000000b8), W(0x00000014),
+		W(0x000000de), W(0x0000005e), W(0x0000000b), W(0x000000db),
+		W(0x000000e0), W(0x00000032), W(0x0000003a), W(0x0000000a),
+		W(0x00000049), W(0x00000006), W(0x00000024), W(0x0000005c),
+		W(0x000000c2), W(0x000000d3), W(0x000000ac), W(0x00000062),
+		W(0x00000091), W(0x00000095), W(0x000000e4), W(0x00000079),
+		W(0x000000e7), W(0x000000c8), W(0x00000037), W(0x0000006d),
+		W(0x0000008d), W(0x000000d5), W(0x0000004e), W(0x000000a9),
+		W(0x0000006c), W(0x00000056), W(0x000000f4), W(0x000000ea),
+		W(0x00000065), W(0x0000007a), W(0x000000ae), W(0x00000008),
+		W(0x000000ba), W(0x00000078), W(0x00000025), W(0x0000002e),
+		W(0x0000001c), W(0x000000a6), W(0x000000b4), W(0x000000c6),
+		W(0x000000e8), W(0x000000dd), W(0x00000074), W(0x0000001f),
+		W(0x0000004b), W(0x000000bd), W(0x0000008b), W(0x0000008a),
+		W(0x00000070), W(0x0000003e), W(0x000000b5), W(0x00000066),
+		W(0x00000048), W(0x00000003), W(0x000000f6), W(0x0000000e),
+		W(0x00000061), W(0x00000035), W(0x00000057), W(0x000000b9),
+		W(0x00000086), W(0x000000c1), W(0x0000001d), W(0x0000009e),
+		W(0x000000e1), W(0x000000f8), W(0x00000098), W(0x00000011),
+		W(0x00000069), W(0x000000d9), W(0x0000008e), W(0x00000094),
+		W(0x0000009b), W(0x0000001e), W(0x00000087), W(0x000000e9),
+		W(0x000000ce), W(0x00000055), W(0x00000028), W(0x000000df),
+		W(0x0000008c), W(0x000000a1), W(0x00000089), W(0x0000000d),
+		W(0x000000bf), W(0x000000e6), W(0x00000042), W(0x00000068),
+		W(0x00000041), W(0x00000099), W(0x0000002d), W(0x0000000f),
+		W(0x000000b0), W(0x00000054), W(0x000000bb), W(0x00000016),
+#ifndef CONFIG_CRYPTO_AES_REDUCED_TABLES
 	}, {
 		0x00006300, 0x00007c00, 0x00007700, 0x00007b00,
 		0x0000f200, 0x00006b00, 0x00006f00, 0x0000c500,
@@ -589,75 +598,77 @@ __visible const u32 crypto_fl_tab[4][256] ____cacheline_aligned = {
 		0xbf000000, 0xe6000000, 0x42000000, 0x68000000,
 		0x41000000, 0x99000000, 0x2d000000, 0x0f000000,
 		0xb0000000, 0x54000000, 0xbb000000, 0x16000000,
+#endif
 	}
 };
 
-__visible const u32 crypto_it_tab[4][256] ____cacheline_aligned = {
+__visible const aes_table_word_t crypto_it_tab[][256] ____cacheline_aligned = {
 	{
-		0x50a7f451, 0x5365417e, 0xc3a4171a, 0x965e273a,
-		0xcb6bab3b, 0xf1459d1f, 0xab58faac, 0x9303e34b,
-		0x55fa3020, 0xf66d76ad, 0x9176cc88, 0x254c02f5,
-		0xfcd7e54f, 0xd7cb2ac5, 0x80443526, 0x8fa362b5,
-		0x495ab1de, 0x671bba25, 0x980eea45, 0xe1c0fe5d,
-		0x02752fc3, 0x12f04c81, 0xa397468d, 0xc6f9d36b,
-		0xe75f8f03, 0x959c9215, 0xeb7a6dbf, 0xda595295,
-		0x2d83bed4, 0xd3217458, 0x2969e049, 0x44c8c98e,
-		0x6a89c275, 0x78798ef4, 0x6b3e5899, 0xdd71b927,
-		0xb64fe1be, 0x17ad88f0, 0x66ac20c9, 0xb43ace7d,
-		0x184adf63, 0x82311ae5, 0x60335197, 0x457f5362,
-		0xe07764b1, 0x84ae6bbb, 0x1ca081fe, 0x942b08f9,
-		0x58684870, 0x19fd458f, 0x876cde94, 0xb7f87b52,
-		0x23d373ab, 0xe2024b72, 0x578f1fe3, 0x2aab5566,
-		0x0728ebb2, 0x03c2b52f, 0x9a7bc586, 0xa50837d3,
-		0xf2872830, 0xb2a5bf23, 0xba6a0302, 0x5c8216ed,
-		0x2b1ccf8a, 0x92b479a7, 0xf0f207f3, 0xa1e2694e,
-		0xcdf4da65, 0xd5be0506, 0x1f6234d1, 0x8afea6c4,
-		0x9d532e34, 0xa055f3a2, 0x32e18a05, 0x75ebf6a4,
-		0x39ec830b, 0xaaef6040, 0x069f715e, 0x51106ebd,
-		0xf98a213e, 0x3d06dd96, 0xae053edd, 0x46bde64d,
-		0xb58d5491, 0x055dc471, 0x6fd40604, 0xff155060,
-		0x24fb9819, 0x97e9bdd6, 0xcc434089, 0x779ed967,
-		0xbd42e8b0, 0x888b8907, 0x385b19e7, 0xdbeec879,
-		0x470a7ca1, 0xe90f427c, 0xc91e84f8, 0x00000000,
-		0x83868009, 0x48ed2b32, 0xac70111e, 0x4e725a6c,
-		0xfbff0efd, 0x5638850f, 0x1ed5ae3d, 0x27392d36,
-		0x64d90f0a, 0x21a65c68, 0xd1545b9b, 0x3a2e3624,
-		0xb1670a0c, 0x0fe75793, 0xd296eeb4, 0x9e919b1b,
-		0x4fc5c080, 0xa220dc61, 0x694b775a, 0x161a121c,
-		0x0aba93e2, 0xe52aa0c0, 0x43e0223c, 0x1d171b12,
-		0x0b0d090e, 0xadc78bf2, 0xb9a8b62d, 0xc8a91e14,
-		0x8519f157, 0x4c0775af, 0xbbdd99ee, 0xfd607fa3,
-		0x9f2601f7, 0xbcf5725c, 0xc53b6644, 0x347efb5b,
-		0x7629438b, 0xdcc623cb, 0x68fcedb6, 0x63f1e4b8,
-		0xcadc31d7, 0x10856342, 0x40229713, 0x2011c684,
-		0x7d244a85, 0xf83dbbd2, 0x1132f9ae, 0x6da129c7,
-		0x4b2f9e1d, 0xf330b2dc, 0xec52860d, 0xd0e3c177,
-		0x6c16b32b, 0x99b970a9, 0xfa489411, 0x2264e947,
-		0xc48cfca8, 0x1a3ff0a0, 0xd82c7d56, 0xef903322,
-		0xc74e4987, 0xc1d138d9, 0xfea2ca8c, 0x360bd498,
-		0xcf81f5a6, 0x28de7aa5, 0x268eb7da, 0xa4bfad3f,
-		0xe49d3a2c, 0x0d927850, 0x9bcc5f6a, 0x62467e54,
-		0xc2138df6, 0xe8b8d890, 0x5ef7392e, 0xf5afc382,
-		0xbe805d9f, 0x7c93d069, 0xa92dd56f, 0xb31225cf,
-		0x3b99acc8, 0xa77d1810, 0x6e639ce8, 0x7bbb3bdb,
-		0x097826cd, 0xf418596e, 0x01b79aec, 0xa89a4f83,
-		0x656e95e6, 0x7ee6ffaa, 0x08cfbc21, 0xe6e815ef,
-		0xd99be7ba, 0xce366f4a, 0xd4099fea, 0xd67cb029,
-		0xafb2a431, 0x31233f2a, 0x3094a5c6, 0xc066a235,
-		0x37bc4e74, 0xa6ca82fc, 0xb0d090e0, 0x15d8a733,
-		0x4a9804f1, 0xf7daec41, 0x0e50cd7f, 0x2ff69117,
-		0x8dd64d76, 0x4db0ef43, 0x544daacc, 0xdf0496e4,
-		0xe3b5d19e, 0x1b886a4c, 0xb81f2cc1, 0x7f516546,
-		0x04ea5e9d, 0x5d358c01, 0x737487fa, 0x2e410bfb,
-		0x5a1d67b3, 0x52d2db92, 0x335610e9, 0x1347d66d,
-		0x8c61d79a, 0x7a0ca137, 0x8e14f859, 0x893c13eb,
-		0xee27a9ce, 0x35c961b7, 0xede51ce1, 0x3cb1477a,
-		0x59dfd29c, 0x3f73f255, 0x79ce1418, 0xbf37c773,
-		0xeacdf753, 0x5baafd5f, 0x146f3ddf, 0x86db4478,
-		0x81f3afca, 0x3ec468b9, 0x2c342438, 0x5f40a3c2,
-		0x72c31d16, 0x0c25e2bc, 0x8b493c28, 0x41950dff,
-		0x7101a839, 0xdeb30c08, 0x9ce4b4d8, 0x90c15664,
-		0x6184cb7b, 0x70b632d5, 0x745c6c48, 0x4257b8d0,
+		W(0x50a7f451), W(0x5365417e), W(0xc3a4171a), W(0x965e273a),
+		W(0xcb6bab3b), W(0xf1459d1f), W(0xab58faac), W(0x9303e34b),
+		W(0x55fa3020), W(0xf66d76ad), W(0x9176cc88), W(0x254c02f5),
+		W(0xfcd7e54f), W(0xd7cb2ac5), W(0x80443526), W(0x8fa362b5),
+		W(0x495ab1de), W(0x671bba25), W(0x980eea45), W(0xe1c0fe5d),
+		W(0x02752fc3), W(0x12f04c81), W(0xa397468d), W(0xc6f9d36b),
+		W(0xe75f8f03), W(0x959c9215), W(0xeb7a6dbf), W(0xda595295),
+		W(0x2d83bed4), W(0xd3217458), W(0x2969e049), W(0x44c8c98e),
+		W(0x6a89c275), W(0x78798ef4), W(0x6b3e5899), W(0xdd71b927),
+		W(0xb64fe1be), W(0x17ad88f0), W(0x66ac20c9), W(0xb43ace7d),
+		W(0x184adf63), W(0x82311ae5), W(0x60335197), W(0x457f5362),
+		W(0xe07764b1), W(0x84ae6bbb), W(0x1ca081fe), W(0x942b08f9),
+		W(0x58684870), W(0x19fd458f), W(0x876cde94), W(0xb7f87b52),
+		W(0x23d373ab), W(0xe2024b72), W(0x578f1fe3), W(0x2aab5566),
+		W(0x0728ebb2), W(0x03c2b52f), W(0x9a7bc586), W(0xa50837d3),
+		W(0xf2872830), W(0xb2a5bf23), W(0xba6a0302), W(0x5c8216ed),
+		W(0x2b1ccf8a), W(0x92b479a7), W(0xf0f207f3), W(0xa1e2694e),
+		W(0xcdf4da65), W(0xd5be0506), W(0x1f6234d1), W(0x8afea6c4),
+		W(0x9d532e34), W(0xa055f3a2), W(0x32e18a05), W(0x75ebf6a4),
+		W(0x39ec830b), W(0xaaef6040), W(0x069f715e), W(0x51106ebd),
+		W(0xf98a213e), W(0x3d06dd96), W(0xae053edd), W(0x46bde64d),
+		W(0xb58d5491), W(0x055dc471), W(0x6fd40604), W(0xff155060),
+		W(0x24fb9819), W(0x97e9bdd6), W(0xcc434089), W(0x779ed967),
+		W(0xbd42e8b0), W(0x888b8907), W(0x385b19e7), W(0xdbeec879),
+		W(0x470a7ca1), W(0xe90f427c), W(0xc91e84f8), W(0x00000000),
+		W(0x83868009), W(0x48ed2b32), W(0xac70111e), W(0x4e725a6c),
+		W(0xfbff0efd), W(0x5638850f), W(0x1ed5ae3d), W(0x27392d36),
+		W(0x64d90f0a), W(0x21a65c68), W(0xd1545b9b), W(0x3a2e3624),
+		W(0xb1670a0c), W(0x0fe75793), W(0xd296eeb4), W(0x9e919b1b),
+		W(0x4fc5c080), W(0xa220dc61), W(0x694b775a), W(0x161a121c),
+		W(0x0aba93e2), W(0xe52aa0c0), W(0x43e0223c), W(0x1d171b12),
+		W(0x0b0d090e), W(0xadc78bf2), W(0xb9a8b62d), W(0xc8a91e14),
+		W(0x8519f157), W(0x4c0775af), W(0xbbdd99ee), W(0xfd607fa3),
+		W(0x9f2601f7), W(0xbcf5725c), W(0xc53b6644), W(0x347efb5b),
+		W(0x7629438b), W(0xdcc623cb), W(0x68fcedb6), W(0x63f1e4b8),
+		W(0xcadc31d7), W(0x10856342), W(0x40229713), W(0x2011c684),
+		W(0x7d244a85), W(0xf83dbbd2), W(0x1132f9ae), W(0x6da129c7),
+		W(0x4b2f9e1d), W(0xf330b2dc), W(0xec52860d), W(0xd0e3c177),
+		W(0x6c16b32b), W(0x99b970a9), W(0xfa489411), W(0x2264e947),
+		W(0xc48cfca8), W(0x1a3ff0a0), W(0xd82c7d56), W(0xef903322),
+		W(0xc74e4987), W(0xc1d138d9), W(0xfea2ca8c), W(0x360bd498),
+		W(0xcf81f5a6), W(0x28de7aa5), W(0x268eb7da), W(0xa4bfad3f),
+		W(0xe49d3a2c), W(0x0d927850), W(0x9bcc5f6a), W(0x62467e54),
+		W(0xc2138df6), W(0xe8b8d890), W(0x5ef7392e), W(0xf5afc382),
+		W(0xbe805d9f), W(0x7c93d069), W(0xa92dd56f), W(0xb31225cf),
+		W(0x3b99acc8), W(0xa77d1810), W(0x6e639ce8), W(0x7bbb3bdb),
+		W(0x097826cd), W(0xf418596e), W(0x01b79aec), W(0xa89a4f83),
+		W(0x656e95e6), W(0x7ee6ffaa), W(0x08cfbc21), W(0xe6e815ef),
+		W(0xd99be7ba), W(0xce366f4a), W(0xd4099fea), W(0xd67cb029),
+		W(0xafb2a431), W(0x31233f2a), W(0x3094a5c6), W(0xc066a235),
+		W(0x37bc4e74), W(0xa6ca82fc), W(0xb0d090e0), W(0x15d8a733),
+		W(0x4a9804f1), W(0xf7daec41), W(0x0e50cd7f), W(0x2ff69117),
+		W(0x8dd64d76), W(0x4db0ef43), W(0x544daacc), W(0xdf0496e4),
+		W(0xe3b5d19e), W(0x1b886a4c), W(0xb81f2cc1), W(0x7f516546),
+		W(0x04ea5e9d), W(0x5d358c01), W(0x737487fa), W(0x2e410bfb),
+		W(0x5a1d67b3), W(0x52d2db92), W(0x335610e9), W(0x1347d66d),
+		W(0x8c61d79a), W(0x7a0ca137), W(0x8e14f859), W(0x893c13eb),
+		W(0xee27a9ce), W(0x35c961b7), W(0xede51ce1), W(0x3cb1477a),
+		W(0x59dfd29c), W(0x3f73f255), W(0x79ce1418), W(0xbf37c773),
+		W(0xeacdf753), W(0x5baafd5f), W(0x146f3ddf), W(0x86db4478),
+		W(0x81f3afca), W(0x3ec468b9), W(0x2c342438), W(0x5f40a3c2),
+		W(0x72c31d16), W(0x0c25e2bc), W(0x8b493c28), W(0x41950dff),
+		W(0x7101a839), W(0xdeb30c08), W(0x9ce4b4d8), W(0x90c15664),
+		W(0x6184cb7b), W(0x70b632d5), W(0x745c6c48), W(0x4257b8d0),
+#ifndef CONFIG_CRYPTO_AES_REDUCED_TABLES
 	}, {
 		0xa7f45150, 0x65417e53, 0xa4171ac3, 0x5e273a96,
 		0x6bab3bcb, 0x459d1ff1, 0x58faacab, 0x03e34b93,
@@ -853,75 +864,77 @@ __visible const u32 crypto_it_tab[4][256] ____cacheline_aligned = {
 		0x1672c31d, 0xbc0c25e2, 0x288b493c, 0xff41950d,
 		0x397101a8, 0x08deb30c, 0xd89ce4b4, 0x6490c156,
 		0x7b6184cb, 0xd570b632, 0x48745c6c, 0xd04257b8,
+#endif
 	}
 };
 
-__visible const u32 crypto_il_tab[4][256] ____cacheline_aligned = {
+__visible const aes_table_word_t crypto_il_tab[][256] ____cacheline_aligned = {
 	{
-		0x00000052, 0x00000009, 0x0000006a, 0x000000d5,
-		0x00000030, 0x00000036, 0x000000a5, 0x00000038,
-		0x000000bf, 0x00000040, 0x000000a3, 0x0000009e,
-		0x00000081, 0x000000f3, 0x000000d7, 0x000000fb,
-		0x0000007c, 0x000000e3, 0x00000039, 0x00000082,
-		0x0000009b, 0x0000002f, 0x000000ff, 0x00000087,
-		0x00000034, 0x0000008e, 0x00000043, 0x00000044,
-		0x000000c4, 0x000000de, 0x000000e9, 0x000000cb,
-		0x00000054, 0x0000007b, 0x00000094, 0x00000032,
-		0x000000a6, 0x000000c2, 0x00000023, 0x0000003d,
-		0x000000ee, 0x0000004c, 0x00000095, 0x0000000b,
-		0x00000042, 0x000000fa, 0x000000c3, 0x0000004e,
-		0x00000008, 0x0000002e, 0x000000a1, 0x00000066,
-		0x00000028, 0x000000d9, 0x00000024, 0x000000b2,
-		0x00000076, 0x0000005b, 0x000000a2, 0x00000049,
-		0x0000006d, 0x0000008b, 0x000000d1, 0x00000025,
-		0x00000072, 0x000000f8, 0x000000f6, 0x00000064,
-		0x00000086, 0x00000068, 0x00000098, 0x00000016,
-		0x000000d4, 0x000000a4, 0x0000005c, 0x000000cc,
-		0x0000005d, 0x00000065, 0x000000b6, 0x00000092,
-		0x0000006c, 0x00000070, 0x00000048, 0x00000050,
-		0x000000fd, 0x000000ed, 0x000000b9, 0x000000da,
-		0x0000005e, 0x00000015, 0x00000046, 0x00000057,
-		0x000000a7, 0x0000008d, 0x0000009d, 0x00000084,
-		0x00000090, 0x000000d8, 0x000000ab, 0x00000000,
-		0x0000008c, 0x000000bc, 0x000000d3, 0x0000000a,
-		0x000000f7, 0x000000e4, 0x00000058, 0x00000005,
-		0x000000b8, 0x000000b3, 0x00000045, 0x00000006,
-		0x000000d0, 0x0000002c, 0x0000001e, 0x0000008f,
-		0x000000ca, 0x0000003f, 0x0000000f, 0x00000002,
-		0x000000c1, 0x000000af, 0x000000bd, 0x00000003,
-		0x00000001, 0x00000013, 0x0000008a, 0x0000006b,
-		0x0000003a, 0x00000091, 0x00000011, 0x00000041,
-		0x0000004f, 0x00000067, 0x000000dc, 0x000000ea,
-		0x00000097, 0x000000f2, 0x000000cf, 0x000000ce,
-		0x000000f0, 0x000000b4, 0x000000e6, 0x00000073,
-		0x00000096, 0x000000ac, 0x00000074, 0x00000022,
-		0x000000e7, 0x000000ad, 0x00000035, 0x00000085,
-		0x000000e2, 0x000000f9, 0x00000037, 0x000000e8,
-		0x0000001c, 0x00000075, 0x000000df, 0x0000006e,
-		0x00000047, 0x000000f1, 0x0000001a, 0x00000071,
-		0x0000001d, 0x00000029, 0x000000c5, 0x00000089,
-		0x0000006f, 0x000000b7, 0x00000062, 0x0000000e,
-		0x000000aa, 0x00000018, 0x000000be, 0x0000001b,
-		0x000000fc, 0x00000056, 0x0000003e, 0x0000004b,
-		0x000000c6, 0x000000d2, 0x00000079, 0x00000020,
-		0x0000009a, 0x000000db, 0x000000c0, 0x000000fe,
-		0x00000078, 0x000000cd, 0x0000005a, 0x000000f4,
-		0x0000001f, 0x000000dd, 0x000000a8, 0x00000033,
-		0x00000088, 0x00000007, 0x000000c7, 0x00000031,
-		0x000000b1, 0x00000012, 0x00000010, 0x00000059,
-		0x00000027, 0x00000080, 0x000000ec, 0x0000005f,
-		0x00000060, 0x00000051, 0x0000007f, 0x000000a9,
-		0x00000019, 0x000000b5, 0x0000004a, 0x0000000d,
-		0x0000002d, 0x000000e5, 0x0000007a, 0x0000009f,
-		0x00000093, 0x000000c9, 0x0000009c, 0x000000ef,
-		0x000000a0, 0x000000e0, 0x0000003b, 0x0000004d,
-		0x000000ae, 0x0000002a, 0x000000f5, 0x000000b0,
-		0x000000c8, 0x000000eb, 0x000000bb, 0x0000003c,
-		0x00000083, 0x00000053, 0x00000099, 0x00000061,
-		0x00000017, 0x0000002b, 0x00000004, 0x0000007e,
-		0x000000ba, 0x00000077, 0x000000d6, 0x00000026,
-		0x000000e1, 0x00000069, 0x00000014, 0x00000063,
-		0x00000055, 0x00000021, 0x0000000c, 0x0000007d,
+		W(0x00000052), W(0x00000009), W(0x0000006a), W(0x000000d5),
+		W(0x00000030), W(0x00000036), W(0x000000a5), W(0x00000038),
+		W(0x000000bf), W(0x00000040), W(0x000000a3), W(0x0000009e),
+		W(0x00000081), W(0x000000f3), W(0x000000d7), W(0x000000fb),
+		W(0x0000007c), W(0x000000e3), W(0x00000039), W(0x00000082),
+		W(0x0000009b), W(0x0000002f), W(0x000000ff), W(0x00000087),
+		W(0x00000034), W(0x0000008e), W(0x00000043), W(0x00000044),
+		W(0x000000c4), W(0x000000de), W(0x000000e9), W(0x000000cb),
+		W(0x00000054), W(0x0000007b), W(0x00000094), W(0x00000032),
+		W(0x000000a6), W(0x000000c2), W(0x00000023), W(0x0000003d),
+		W(0x000000ee), W(0x0000004c), W(0x00000095), W(0x0000000b),
+		W(0x00000042), W(0x000000fa), W(0x000000c3), W(0x0000004e),
+		W(0x00000008), W(0x0000002e), W(0x000000a1), W(0x00000066),
+		W(0x00000028), W(0x000000d9), W(0x00000024), W(0x000000b2),
+		W(0x00000076), W(0x0000005b), W(0x000000a2), W(0x00000049),
+		W(0x0000006d), W(0x0000008b), W(0x000000d1), W(0x00000025),
+		W(0x00000072), W(0x000000f8), W(0x000000f6), W(0x00000064),
+		W(0x00000086), W(0x00000068), W(0x00000098), W(0x00000016),
+		W(0x000000d4), W(0x000000a4), W(0x0000005c), W(0x000000cc),
+		W(0x0000005d), W(0x00000065), W(0x000000b6), W(0x00000092),
+		W(0x0000006c), W(0x00000070), W(0x00000048), W(0x00000050),
+		W(0x000000fd), W(0x000000ed), W(0x000000b9), W(0x000000da),
+		W(0x0000005e), W(0x00000015), W(0x00000046), W(0x00000057),
+		W(0x000000a7), W(0x0000008d), W(0x0000009d), W(0x00000084),
+		W(0x00000090), W(0x000000d8), W(0x000000ab), W(0x00000000),
+		W(0x0000008c), W(0x000000bc), W(0x000000d3), W(0x0000000a),
+		W(0x000000f7), W(0x000000e4), W(0x00000058), W(0x00000005),
+		W(0x000000b8), W(0x000000b3), W(0x00000045), W(0x00000006),
+		W(0x000000d0), W(0x0000002c), W(0x0000001e), W(0x0000008f),
+		W(0x000000ca), W(0x0000003f), W(0x0000000f), W(0x00000002),
+		W(0x000000c1), W(0x000000af), W(0x000000bd), W(0x00000003),
+		W(0x00000001), W(0x00000013), W(0x0000008a), W(0x0000006b),
+		W(0x0000003a), W(0x00000091), W(0x00000011), W(0x00000041),
+		W(0x0000004f), W(0x00000067), W(0x000000dc), W(0x000000ea),
+		W(0x00000097), W(0x000000f2), W(0x000000cf), W(0x000000ce),
+		W(0x000000f0), W(0x000000b4), W(0x000000e6), W(0x00000073),
+		W(0x00000096), W(0x000000ac), W(0x00000074), W(0x00000022),
+		W(0x000000e7), W(0x000000ad), W(0x00000035), W(0x00000085),
+		W(0x000000e2), W(0x000000f9), W(0x00000037), W(0x000000e8),
+		W(0x0000001c), W(0x00000075), W(0x000000df), W(0x0000006e),
+		W(0x00000047), W(0x000000f1), W(0x0000001a), W(0x00000071),
+		W(0x0000001d), W(0x00000029), W(0x000000c5), W(0x00000089),
+		W(0x0000006f), W(0x000000b7), W(0x00000062), W(0x0000000e),
+		W(0x000000aa), W(0x00000018), W(0x000000be), W(0x0000001b),
+		W(0x000000fc), W(0x00000056), W(0x0000003e), W(0x0000004b),
+		W(0x000000c6), W(0x000000d2), W(0x00000079), W(0x00000020),
+		W(0x0000009a), W(0x000000db), W(0x000000c0), W(0x000000fe),
+		W(0x00000078), W(0x000000cd), W(0x0000005a), W(0x000000f4),
+		W(0x0000001f), W(0x000000dd), W(0x000000a8), W(0x00000033),
+		W(0x00000088), W(0x00000007), W(0x000000c7), W(0x00000031),
+		W(0x000000b1), W(0x00000012), W(0x00000010), W(0x00000059),
+		W(0x00000027), W(0x00000080), W(0x000000ec), W(0x0000005f),
+		W(0x00000060), W(0x00000051), W(0x0000007f), W(0x000000a9),
+		W(0x00000019), W(0x000000b5), W(0x0000004a), W(0x0000000d),
+		W(0x0000002d), W(0x000000e5), W(0x0000007a), W(0x0000009f),
+		W(0x00000093), W(0x000000c9), W(0x0000009c), W(0x000000ef),
+		W(0x000000a0), W(0x000000e0), W(0x0000003b), W(0x0000004d),
+		W(0x000000ae), W(0x0000002a), W(0x000000f5), W(0x000000b0),
+		W(0x000000c8), W(0x000000eb), W(0x000000bb), W(0x0000003c),
+		W(0x00000083), W(0x00000053), W(0x00000099), W(0x00000061),
+		W(0x00000017), W(0x0000002b), W(0x00000004), W(0x0000007e),
+		W(0x000000ba), W(0x00000077), W(0x000000d6), W(0x00000026),
+		W(0x000000e1), W(0x00000069), W(0x00000014), W(0x00000063),
+		W(0x00000055), W(0x00000021), W(0x0000000c), W(0x0000007d),
+#ifndef CONFIG_CRYPTO_AES_REDUCED_TABLES
 	}, {
 		0x00005200, 0x00000900, 0x00006a00, 0x0000d500,
 		0x00003000, 0x00003600, 0x0000a500, 0x00003800,
@@ -1117,6 +1130,7 @@ __visible const u32 crypto_il_tab[4][256] ____cacheline_aligned = {
 		0xba000000, 0x77000000, 0xd6000000, 0x26000000,
 		0xe1000000, 0x69000000, 0x14000000, 0x63000000,
 		0x55000000, 0x21000000, 0x0c000000, 0x7d000000,
+#endif
 	}
 };
 
@@ -1125,6 +1139,15 @@ EXPORT_SYMBOL_GPL(crypto_fl_tab);
 EXPORT_SYMBOL_GPL(crypto_it_tab);
 EXPORT_SYMBOL_GPL(crypto_il_tab);
 
+#ifndef CONFIG_CRYPTO_AES_REDUCED_TABLES
+#define aes_tab(t,x,y) crypto_##t##_tab[x][y]
+#elif defined(CONFIG_CPU_BIG_ENDIAN)
+#else
+#define aes_tab(t,x,y) get_unaligned((u32 *)((u8 *)&crypto_##t##_tab[0][y] + (x)))
+#else
+#define aes_tab(t,x,y) get_unaligned((u32 *)((u8 *)&crypto_##t##_tab[0][y] + 4 - (x)))
+#endif
+
 /* initialise the key schedule from the user supplied key */
 
 #define star_x(x) (((x) & 0x7f7f7f7f) << 1) ^ ((((x) & 0x80808080) >> 7) * 0x1b)
@@ -1141,10 +1164,10 @@ EXPORT_SYMBOL_GPL(crypto_il_tab);
 } while (0)
 
 #define ls_box(x)		\
-	crypto_fl_tab[0][byte(x, 0)] ^	\
-	crypto_fl_tab[1][byte(x, 1)] ^	\
-	crypto_fl_tab[2][byte(x, 2)] ^	\
-	crypto_fl_tab[3][byte(x, 3)]
+	aes_tab(fl, 0, byte(x, 0)) ^	\
+	aes_tab(fl, 1, byte(x, 1)) ^	\
+	aes_tab(fl, 2, byte(x, 2)) ^	\
+	aes_tab(fl, 3, byte(x, 3))
 
 #define loop4(i)	do {		\
 	t = ror32(t, 8);		\
@@ -1304,10 +1327,10 @@ EXPORT_SYMBOL_GPL(crypto_aes_set_key);
 /* encrypt a block of text */
 
 #define f_rn(bo, bi, n, k)	do {				\
-	bo[n] = crypto_ft_tab[0][byte(bi[n], 0)] ^			\
-		crypto_ft_tab[1][byte(bi[(n + 1) & 3], 1)] ^		\
-		crypto_ft_tab[2][byte(bi[(n + 2) & 3], 2)] ^		\
-		crypto_ft_tab[3][byte(bi[(n + 3) & 3], 3)] ^ *(k + n);	\
+	bo[n] = aes_tab(ft, 0, byte(bi[n], 0)) ^			\
+		aes_tab(ft, 1, byte(bi[(n + 1) & 3], 1)) ^		\
+		aes_tab(ft, 2, byte(bi[(n + 2) & 3], 2)) ^		\
+		aes_tab(ft, 3, byte(bi[(n + 3) & 3], 3)) ^ *(k + n);	\
 } while (0)
 
 #define f_nround(bo, bi, k)	do {\
@@ -1319,10 +1342,10 @@ EXPORT_SYMBOL_GPL(crypto_aes_set_key);
 } while (0)
 
 #define f_rl(bo, bi, n, k)	do {				\
-	bo[n] = crypto_fl_tab[0][byte(bi[n], 0)] ^			\
-		crypto_fl_tab[1][byte(bi[(n + 1) & 3], 1)] ^		\
-		crypto_fl_tab[2][byte(bi[(n + 2) & 3], 2)] ^		\
-		crypto_fl_tab[3][byte(bi[(n + 3) & 3], 3)] ^ *(k + n);	\
+	bo[n] = aes_tab(fl, 0, byte(bi[n], 0)) ^			\
+		aes_tab(fl, 1, byte(bi[(n + 1) & 3], 1)) ^		\
+		aes_tab(fl, 2, byte(bi[(n + 2) & 3], 2)) ^		\
+		aes_tab(fl, 3, byte(bi[(n + 3) & 3], 3)) ^ *(k + n);	\
 } while (0)
 
 #define f_lround(bo, bi, k)	do {\
@@ -1374,10 +1397,10 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 /* decrypt a block of text */
 
 #define i_rn(bo, bi, n, k)	do {				\
-	bo[n] = crypto_it_tab[0][byte(bi[n], 0)] ^			\
-		crypto_it_tab[1][byte(bi[(n + 3) & 3], 1)] ^		\
-		crypto_it_tab[2][byte(bi[(n + 2) & 3], 2)] ^		\
-		crypto_it_tab[3][byte(bi[(n + 1) & 3], 3)] ^ *(k + n);	\
+	bo[n] = aes_tab(it, 0, byte(bi[n], 0)) ^			\
+		aes_tab(it, 1, byte(bi[(n + 3) & 3], 1)) ^		\
+		aes_tab(it, 2, byte(bi[(n + 2) & 3], 2)) ^		\
+		aes_tab(it, 3, byte(bi[(n + 1) & 3], 3)) ^ *(k + n);	\
 } while (0)
 
 #define i_nround(bo, bi, k)	do {\
@@ -1389,10 +1412,10 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 } while (0)
 
 #define i_rl(bo, bi, n, k)	do {			\
-	bo[n] = crypto_il_tab[0][byte(bi[n], 0)] ^		\
-	crypto_il_tab[1][byte(bi[(n + 3) & 3], 1)] ^		\
-	crypto_il_tab[2][byte(bi[(n + 2) & 3], 2)] ^		\
-	crypto_il_tab[3][byte(bi[(n + 1) & 3], 3)] ^ *(k + n);	\
+	bo[n] = aes_tab(il, 0, byte(bi[n], 0)) ^		\
+		aes_tab(il, 1, byte(bi[(n + 3) & 3], 1)) ^		\
+		aes_tab(il, 2, byte(bi[(n + 2) & 3], 2)) ^		\
+		aes_tab(il, 3, byte(bi[(n + 1) & 3], 3)) ^ *(k + n);	\
 } while (0)
 
 #define i_lround(bo, bi, k)	do {\
diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 0fdb542c70cd..f8ff8f2c52b8 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -28,10 +28,16 @@ struct crypto_aes_ctx {
 	u32 key_length;
 };
 
-extern const u32 crypto_ft_tab[4][256] ____cacheline_aligned;
-extern const u32 crypto_fl_tab[4][256] ____cacheline_aligned;
-extern const u32 crypto_it_tab[4][256] ____cacheline_aligned;
-extern const u32 crypto_il_tab[4][256] ____cacheline_aligned;
+#ifdef CONFIG_CRYPTO_AES_REDUCED_TABLES
+typedef u64 aes_table_word_t;
+#else
+typedef u32 aes_table_word_t;
+#endif
+
+extern const aes_table_word_t crypto_ft_tab[][256] ____cacheline_aligned;
+extern const aes_table_word_t crypto_fl_tab[][256] ____cacheline_aligned;
+extern const aes_table_word_t crypto_it_tab[][256] ____cacheline_aligned;
+extern const aes_table_word_t crypto_il_tab[][256] ____cacheline_aligned;
 
 int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		unsigned int key_len);
-- 
2.20.1

