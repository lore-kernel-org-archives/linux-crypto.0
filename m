Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D9C32F741;
	Mon,  5 Jan 2026 05:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767590114; cv=none; b=a/X2DOVc0YA/RpKw02YIn2Ca5u5GqdPk9ibPGaIQitpOPGKVO93fVoJXTF/yO6wONxyKg2ogT5scb/p1jDFLhWeXUEBC8PLWut9BqC8vBeVxa18XF8n5xN2bFxpFuF+9jqJ4WUNmt71bBuXmOgpnUZd7cA1n6wr+LQkF8EClipA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767590114; c=relaxed/simple;
	bh=0EBUEmVTe0e4bzKdqvPELWwoIgTHdjzdDZHfkwljOsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lm97XRvcDiyoXXCGC22LV60+RMYYG3EP1/nb6UKvfoIhoRDSOWuawkj1NXSyfniKUnY/k8XllSTvUV/y5LZB8QYI+6yXJI8f4AOPmSTYxqasNVcubCNLrp+kKHAsRrvmhvJ9Nb3nhmNyuddSTNYE8BvvqlOIVfpdfrANqG/kqI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rOAhnKYR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rOAhnKYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF948C19421;
	Mon,  5 Jan 2026 05:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767590114;
	bh=0EBUEmVTe0e4bzKdqvPELWwoIgTHdjzdDZHfkwljOsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOAhnKYROQMEoMD81Em7mWQ61HyLgE3WDv40a+uauy0zXQQ0mHHhwqwczGz06JzjM
	 BdNHtV7nIaURBKsF+oSa2rFdIAEXQ7LByXqGJRKmIrdfOf6QiEc5WT1lC9vh/BhW9a
	 IQ9OEsk+eGFsSOCFKi5iDvmfEmKDGx5jd+GTG1pUfu7myy1vVeHI3pUsbThA4X2oyu
	 lJCDZSbKqwRYYUw6a5frOfQp/Jv2FxRovn8kxjvrIGakLOdH6Z1+7/6yA/2TAaFePp
	 BbafT19y5VWI6JSqqbcyOypU34Iu6dDnPvbkNn++RQT2plgft3r939P/tX35BnbGzF
	 L9/mowQabouBA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 36/36] lib/crypto: aes: Drop 'volatile' from aes_sbox and aes_inv_sbox
Date: Sun,  4 Jan 2026 21:13:09 -0800
Message-ID: <20260105051311.1607207-37-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260105051311.1607207-1-ebiggers@kernel.org>
References: <20260105051311.1607207-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The volatile keyword is no longer necessary or useful on aes_sbox and
aes_inv_sbox, since the table prefetching is now done using a helper
function that casts to volatile itself and also includes an optimization
barrier.  Since it prevents some compiler optimizations, remove it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/aes.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index 98ade1758735..e85c905296f1 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -9,15 +9,11 @@
 #include <linux/crypto.h>
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/unaligned.h>
 
-/*
- * Emit the sbox as volatile const to prevent the compiler from doing
- * constant folding on sbox references involving fixed indexes.
- */
-static volatile const u8 __cacheline_aligned aes_sbox[] = {
+static const u8 __cacheline_aligned aes_sbox[] = {
 	0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5,
 	0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
 	0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0,
 	0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
 	0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc,
@@ -48,11 +44,11 @@ static volatile const u8 __cacheline_aligned aes_sbox[] = {
 	0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
 	0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68,
 	0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16,
 };
 
-static volatile const u8 __cacheline_aligned aes_inv_sbox[] = {
+static const u8 __cacheline_aligned aes_inv_sbox[] = {
 	0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38,
 	0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb,
 	0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87,
 	0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb,
 	0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d,
@@ -428,11 +424,11 @@ static void __maybe_unused aes_decrypt_generic(const u32 inv_rndkeys[],
 		w[1] = w1;
 		w[2] = w2;
 		w[3] = w3;
 	} while (--n);
 
-	aes_prefetch((const void *)aes_inv_sbox, sizeof(aes_inv_sbox));
+	aes_prefetch(aes_inv_sbox, sizeof(aes_inv_sbox));
 	put_unaligned_le32(declast_quarterround(w, 0, *rkp++), &out[0]);
 	put_unaligned_le32(declast_quarterround(w, 1, *rkp++), &out[4]);
 	put_unaligned_le32(declast_quarterround(w, 2, *rkp++), &out[8]);
 	put_unaligned_le32(declast_quarterround(w, 3, *rkp++), &out[12]);
 }
-- 
2.52.0

