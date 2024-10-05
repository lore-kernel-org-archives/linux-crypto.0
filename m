Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C0C231C8F;
	Sat,  5 Oct 2024 23:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728170081; cv=none; b=EhOh9dg1dZ9UduaBScBnssh8RGvN7DwYm/RBC2vTtB52GskisxS6L/kOrvNSmb8vn73ULDwb93K1Gzv8nk3PnPfHyaNK0eUjtXJIjVZWCT0K/Hvd7oS7bHYiSd0WvATYrj5yjw38NSlrwy8kLjRQ03otQIaJps058xVoTvsR9P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728170081; c=relaxed/simple;
	bh=55JqzKe/ic7TX/w1MQyQqPCecWERm7eQO4l3DpCtnZs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NNTyav/lOr5ZxocAgHiMHWUTfzxFPA1Kdub/e3jxOT4/IDBz73gKFmdf/UkoCFlI9eLeeWviIKwoyhoyJeuD8Nn2vy7eVbN/BnQv+llKs/KdLVK+d6GGo9bSp/rDahomNBvThD/zxZGS5rfKsFSEV9VOmjnP+TvS9d6LYDqt5mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=Cs63PiEz; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="Cs63PiEz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=ijtOb56oHzu1JziCMLT9W2TGCyKMmg0cuQIugWCib0Q=; b=Cs63PiEzB/o6ooui
	6gMGtalJ5YAAS4xIjQu0QcGJrcli7+DROqE+XPog0Uf5nuPkrws00K7qlMZghw7mO0ujxBCEXTkIj
	910bK6HLfqWwSV8I8GwN4mXX8LEKrINKW7ro6PMpgrAx1Kaz7hz2HWk8xHX5ebfC5rUINb4whmhUU
	flykahUR1OMkYgZV2sSME9CBRi5sCPn9KjlJMLUD5Vgj4gwimF1yHqYcXblQiJaWm16T2m3m84IPS
	Wyn7i/g6gJOwlJWeIzMZflJ19UFz7VCTG9QZZkFtsJbE/UbZojj29tow4DaN6fn4OI2KtfEct+CTx
	vqKNOU2mWqwA3spmpw==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1sxDyK-009DWA-09;
	Sat, 05 Oct 2024 23:14:00 +0000
From: linux@treblig.org
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] crypto: x86/cast5: Remove unused cast5_ctr_16way
Date: Sun,  6 Oct 2024 00:13:58 +0100
Message-ID: <20241005231358.304682-1-linux@treblig.org>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

commit e2d60e2f597a ("crypto: x86/cast5 - drop CTR mode implementation")

removed the calls to cast5_ctr_16way but left the avx implementation.

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S | 76 -----------------------
 1 file changed, 76 deletions(-)

diff --git a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
index b4e460a87f18..fb95a614249d 100644
--- a/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/cast5-avx-x86_64-asm_64.S
@@ -487,79 +487,3 @@ SYM_FUNC_START(cast5_cbc_dec_16way)
 	FRAME_END
 	RET;
 SYM_FUNC_END(cast5_cbc_dec_16way)
-
-SYM_FUNC_START(cast5_ctr_16way)
-	/* input:
-	 *	%rdi: ctx
-	 *	%rsi: dst
-	 *	%rdx: src
-	 *	%rcx: iv (big endian, 64bit)
-	 */
-	FRAME_BEGIN
-	pushq %r12;
-	pushq %r15;
-
-	movq %rdi, CTX;
-	movq %rsi, %r11;
-	movq %rdx, %r12;
-
-	vpcmpeqd RTMP, RTMP, RTMP;
-	vpsrldq $8, RTMP, RTMP; /* low: -1, high: 0 */
-
-	vpcmpeqd RKR, RKR, RKR;
-	vpaddq RKR, RKR, RKR; /* low: -2, high: -2 */
-	vmovdqa .Lbswap_iv_mask(%rip), R1ST;
-	vmovdqa .Lbswap128_mask(%rip), RKM;
-
-	/* load IV and byteswap */
-	vmovq (%rcx), RX;
-	vpshufb R1ST, RX, RX;
-
-	/* construct IVs */
-	vpsubq RTMP, RX, RX;  /* le: IV1, IV0 */
-	vpshufb RKM, RX, RL1; /* be: IV0, IV1 */
-	vpsubq RKR, RX, RX;
-	vpshufb RKM, RX, RR1; /* be: IV2, IV3 */
-	vpsubq RKR, RX, RX;
-	vpshufb RKM, RX, RL2; /* be: IV4, IV5 */
-	vpsubq RKR, RX, RX;
-	vpshufb RKM, RX, RR2; /* be: IV6, IV7 */
-	vpsubq RKR, RX, RX;
-	vpshufb RKM, RX, RL3; /* be: IV8, IV9 */
-	vpsubq RKR, RX, RX;
-	vpshufb RKM, RX, RR3; /* be: IV10, IV11 */
-	vpsubq RKR, RX, RX;
-	vpshufb RKM, RX, RL4; /* be: IV12, IV13 */
-	vpsubq RKR, RX, RX;
-	vpshufb RKM, RX, RR4; /* be: IV14, IV15 */
-
-	/* store last IV */
-	vpsubq RTMP, RX, RX; /* le: IV16, IV14 */
-	vpshufb R1ST, RX, RX; /* be: IV16, IV16 */
-	vmovq RX, (%rcx);
-
-	call __cast5_enc_blk16;
-
-	/* dst = src ^ iv */
-	vpxor (0*16)(%r12), RR1, RR1;
-	vpxor (1*16)(%r12), RL1, RL1;
-	vpxor (2*16)(%r12), RR2, RR2;
-	vpxor (3*16)(%r12), RL2, RL2;
-	vpxor (4*16)(%r12), RR3, RR3;
-	vpxor (5*16)(%r12), RL3, RL3;
-	vpxor (6*16)(%r12), RR4, RR4;
-	vpxor (7*16)(%r12), RL4, RL4;
-	vmovdqu RR1, (0*16)(%r11);
-	vmovdqu RL1, (1*16)(%r11);
-	vmovdqu RR2, (2*16)(%r11);
-	vmovdqu RL2, (3*16)(%r11);
-	vmovdqu RR3, (4*16)(%r11);
-	vmovdqu RL3, (5*16)(%r11);
-	vmovdqu RR4, (6*16)(%r11);
-	vmovdqu RL4, (7*16)(%r11);
-
-	popq %r15;
-	popq %r12;
-	FRAME_END
-	RET;
-SYM_FUNC_END(cast5_ctr_16way)
-- 
2.46.2

