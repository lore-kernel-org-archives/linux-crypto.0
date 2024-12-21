Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427121F2399
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772296; cv=none; b=IvE8w4A2ubDvTNn3dAEdh+XP90TKlDH1st3Jzvllu6NPRDoRdV5HSxO2huni2KxivZRRhqu3XbNJZgYdFCoEjYJ47rhy1zConXqAYvv0HIMy7+SwybCy1NhrmPp0kkS+qvBasmrFg3rCkylR3CsNHx5MwAT4bzFD3vGpQsHEWLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772296; c=relaxed/simple;
	bh=5pj/D1hOOx/ISCCP0hxDOq++HsD61KuEGNf//Yqj0yQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uH+4wJ0M0uLXjNtCCr0hl0zJkMUAzJCPfTYmf8zMXs8HTM0YEwvcJ7Sady+nYcWeKKwnX8YvVAJUv9Ou1+9NojhNanJdcmTsfgofdvrUBnEcNN1wv3ZqfKc8veQYwoGPXXFGffg4KloKU7AEUF9milodJ9rDEyhc76qmV5kBAso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KekUY5XG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KekUY5XG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F41C4CECE
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772296;
	bh=5pj/D1hOOx/ISCCP0hxDOq++HsD61KuEGNf//Yqj0yQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=KekUY5XGZO3ebARzWGDgXwieVrb5pkBafoIE5HRjhSRTMKoSTbVVuh/pTv79bY1m/
	 P5Zjt2LSMD+TKcaVF/2NpSKVAIGs2R0p/yDyCD6wl7bH19n6vfsR8JzUu6ljYA35OO
	 7+SJHQnIbZQe9PQoMufFMyBNDBALkG84Qt2/JW59zPDyZm4lcpfpRU0o9bK/1xxwpL
	 bxYjsnDycQQvRtwjlTuwdBax/xzVZHyp4+/Xuny+vCtYGrral3qxnDwJ2WwlzxLl0e
	 G8zuzI7MYH8yEYeXqlHUbq5LUlngUlIof6q9loLfUNsbWJL4KQvKmZHq5/DEFR3IHi
	 IxDlHMqiBkyPQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 25/29] crypto: x86/aegis - use the new scatterwalk functions
Date: Sat, 21 Dec 2024 01:10:52 -0800
Message-ID: <20241221091056.282098-26-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241221091056.282098-1-ebiggers@kernel.org>
References: <20241221091056.282098-1-ebiggers@kernel.org>
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

