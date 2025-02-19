Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D7321B9CE;
	Wed, 19 Feb 2025 18:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739989472; cv=none; b=CaBzQJm8CTlT8mBLqE/W09bfgUa+liGL5cTaqTtgID/W/i0uAbdDS0hf7CRZ8bBCSSyHD0kSAX/nPQuBq5lrfGHOIlzy4ykCQ3A4dmbO1CBE6ZvsmybJnon/siCBUJiLKlsYlwwlHRIqjQrP5T1mXCDtcn9A5IBvok25DBRuIxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739989472; c=relaxed/simple;
	bh=e6jH75bm56vh0co03y8l2mrU5UpBPrA2ekMFTLfJovw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkaJAJo5LO47Lidt1m9BloWNapA9065ROTEonIGwpn4tnDDsErj1u2H50g2E0S80ln1+bcUk3dyZG9y+dimYjBf8+2j4EiCboZjJfkaFYb8xMXxxXOS8fxznzbKXC2GLjOfVJCJmDde4JBm8cKTy804MSdWm3A7p5ws8WLzl+s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=szreaeud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="szreaeud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D3CC4CED1;
	Wed, 19 Feb 2025 18:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739989471;
	bh=e6jH75bm56vh0co03y8l2mrU5UpBPrA2ekMFTLfJovw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=szreaeudSyGlyXEDsUCwHo8DEQpRXBjNhy9pD92PJoyBb/e3GJkH6AB+a4+3oRrxt
	 UXXn3jZeFiqiMBA9WG47io0uf6U6coNDD3dIhCBWaQ+a+/1VhurQmuKMrFa5H16kwP
	 MqONiVwbHOLwPqjxV56LVK3BEmnb5XjwVHc9+av6MLDk9GIZ8U7SINvRDaow7JibjQ
	 vAq2zkMC6bNIlsNpkAg1d4hnDz57Q2ypV6c2B+gBtiz7AgWoUxq8tCMGnujxmk5XiM
	 EVUR7A6UZ4vlrmlNXuhgOowEK0R2+JtITaAahHORHuLxo28tJAYg6eOseqK6UR+76D
	 6/sQXnCH/QU4A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v3 15/19] crypto: x86/aegis - use the new scatterwalk functions
Date: Wed, 19 Feb 2025 10:23:37 -0800
Message-ID: <20250219182341.43961-16-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219182341.43961-1-ebiggers@kernel.org>
References: <20250219182341.43961-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

In crypto_aegis128_aesni_process_ad(), use scatterwalk_next() which
consolidates scatterwalk_clamp() and scatterwalk_map().  Use
scatterwalk_done_src() which consolidates scatterwalk_unmap(),
scatterwalk_advance(), and scatterwalk_done().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aegis128-aesni-glue.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
index 01fa568dc5fc4..1bd093d073ed6 100644
--- a/arch/x86/crypto/aegis128-aesni-glue.c
+++ b/arch/x86/crypto/aegis128-aesni-glue.c
@@ -69,14 +69,14 @@ static void crypto_aegis128_aesni_process_ad(
 	struct aegis_block buf;
 	unsigned int pos = 0;
 
 	scatterwalk_start(&walk, sg_src);
 	while (assoclen != 0) {
-		unsigned int size = scatterwalk_clamp(&walk, assoclen);
+		unsigned int size;
+		const u8 *mapped = scatterwalk_next(&walk, assoclen, &size);
 		unsigned int left = size;
-		void *mapped = scatterwalk_map(&walk);
-		const u8 *src = (const u8 *)mapped;
+		const u8 *src = mapped;
 
 		if (pos + size >= AEGIS128_BLOCK_SIZE) {
 			if (pos > 0) {
 				unsigned int fill = AEGIS128_BLOCK_SIZE - pos;
 				memcpy(buf.bytes + pos, src, fill);
@@ -95,13 +95,11 @@ static void crypto_aegis128_aesni_process_ad(
 
 		memcpy(buf.bytes + pos, src, left);
 		pos += left;
 		assoclen -= size;
 
-		scatterwalk_unmap(mapped);
-		scatterwalk_advance(&walk, size);
-		scatterwalk_done(&walk, 0, assoclen);
+		scatterwalk_done_src(&walk, mapped, size);
 	}
 
 	if (pos > 0) {
 		memset(buf.bytes + pos, 0, AEGIS128_BLOCK_SIZE - pos);
 		aegis128_aesni_ad(state, buf.bytes, AEGIS128_BLOCK_SIZE);
-- 
2.48.1

