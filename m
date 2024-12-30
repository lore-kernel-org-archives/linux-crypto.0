Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229D01A4E98;
	Mon, 30 Dec 2024 00:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517768; cv=none; b=iNXq4oonBu0Oj3rLWPzDuCkoB09vHamRBDb1TVTQ8q4rByMs0PWVhyF6e/1c6bKrsKS+LfBV87ofBHpTZ0YvtgLZTylWReRyKTQFxzdzOBgr+iO+3zskR9vqQZTdsLzOzStH9SzrA/KaQW+UcS5uwgZItFFSQGR90+hsgqGyIrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517768; c=relaxed/simple;
	bh=5pj/D1hOOx/ISCCP0hxDOq++HsD61KuEGNf//Yqj0yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uj5D57REkcS750r62xUG53kl0qNw7Z0uPBbR6EizjGYfh/t0TGSF7SxYI+1KU7ryE3qnikVHleb5n+W8wRLa4z2u1NG++jju2mrgWyxnUX3BbwPKrLoIpTGfYhQu1ED1xMhqNxosl9ox/36Aeb3E/UP3riIJ8Ca8STJNC8oce3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fHMdydOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fHMdydOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC581C4CED4;
	Mon, 30 Dec 2024 00:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517768;
	bh=5pj/D1hOOx/ISCCP0hxDOq++HsD61KuEGNf//Yqj0yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHMdydOK+6R0PBeMmR9Fiv3z0HFaKdoTqKa4U+3aCesV5aowRKnGWolDkOrs2Q8hR
	 UJ7g48Lfa/Cb4gHzUc6Nk1spA/TafZjhN0yMC1SVt61SI9BbZ5MfjrEx+w673I4TKS
	 oX8pFqW355F8IuOgTRBmrfqTHJXHmkOv8qzm/Yrt+Gf2ZxDsaIKs2FoAePrkLFDw1S
	 yDpyCgduattu7wJVlU3m/Zoh+QpciQnsD9HaKaHjmaLKFr+waxe2xwrDo2ofwtwuDH
	 QmeAloq2OHYbGfTHbWHALCBKWnDuC2vBDw8VNIBOULAbSu0b/nbDGig/Ojrq+P1cZN
	 LGpmg8O46fhDw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 25/29] crypto: x86/aegis - use the new scatterwalk functions
Date: Sun, 29 Dec 2024 16:14:14 -0800
Message-ID: <20241230001418.74739-26-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230001418.74739-1-ebiggers@kernel.org>
References: <20241230001418.74739-1-ebiggers@kernel.org>
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
index 01fa568dc5fc..1bd093d073ed 100644
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
2.47.1

