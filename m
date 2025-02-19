Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9B7215196;
	Wed, 19 Feb 2025 18:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739989469; cv=none; b=tJDzAbA533OnQ/WiNK3JTVaISMboy8pBcS7j5eiKcDYuaxGo7dR7iek3A6XXCT6ShuCnhgqAY4f2cQyGRN02kpt/9YjYJj1+MO8FOUs4mVc3fsAGiT95OCbSNHswBbfz+tD1yk3Wxx6i0xXUPJk5ojWOyzHKqPIhmOx/haSfibM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739989469; c=relaxed/simple;
	bh=n97Wpwb+rCABvDN9tt69mu3JcMHR+6ylMZTfgUxLF9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7OYL2UmpOGZYTEGL+Ecelcxusoq0TMfJjdGKDqMYBu2Uli7XTZgnHNdGKt591Z8SnMoNbIYbKG2XBoMnnWLy0tNMoW4q4cxKYJWc6jAVO2+ddsbDC3QN/cu+mSyh32+TL6esy5yfc9aWi3D1DYxaiSKiXtm/5EBOgN7P19fMpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=utTKV1bw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="utTKV1bw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2C5C4CEFC;
	Wed, 19 Feb 2025 18:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739989468;
	bh=n97Wpwb+rCABvDN9tt69mu3JcMHR+6ylMZTfgUxLF9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utTKV1bwjvzHP2IycvmtH8HDphgGwAjGCQAV7zGNXutttI2fFIDWEVfCYuKsGM1E9
	 Ge+ieXX7fJociF1CuVRLMnPmokD9NLc0axuzgjdK3F9nyg+CI7+sdYtO0xp1iB0bK5
	 MOmvGvVPA1OGv3t9a2Em4QSvzVEDfVSBYMfEHrpI6bxXhHy/ljqSmwgu+7qc3wVofk
	 9mBzJbAU6MkYSkU4+03BNWSLGPDzRN7jRxkGkBppKNrB6QupelOjsCMs6IutTtOdJt
	 3NEo/dD6cIj7l1V41gtKxiHDsT7W7IDfIhSJUwIRYrl/vRMGaGjYQVY07mPslbFxlS
	 X9zmr6aAujeZg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v3 07/19] crypto: aegis - use the new scatterwalk functions
Date: Wed, 19 Feb 2025 10:23:29 -0800
Message-ID: <20250219182341.43961-8-ebiggers@kernel.org>
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

Use scatterwalk_next() which consolidates scatterwalk_clamp() and
scatterwalk_map(), and use scatterwalk_done_src() which consolidates
scatterwalk_unmap(), scatterwalk_advance(), and scatterwalk_done().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/aegis128-core.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
index 6cbff298722b4..15d64d836356d 100644
--- a/crypto/aegis128-core.c
+++ b/crypto/aegis128-core.c
@@ -282,14 +282,14 @@ static void crypto_aegis128_process_ad(struct aegis_state *state,
 	union aegis_block buf;
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
 
 		if (pos + size >= AEGIS_BLOCK_SIZE) {
 			if (pos > 0) {
 				unsigned int fill = AEGIS_BLOCK_SIZE - pos;
 				memcpy(buf.bytes + pos, src, fill);
@@ -306,13 +306,11 @@ static void crypto_aegis128_process_ad(struct aegis_state *state,
 
 		memcpy(buf.bytes + pos, src, left);
 
 		pos += left;
 		assoclen -= size;
-		scatterwalk_unmap(mapped);
-		scatterwalk_advance(&walk, size);
-		scatterwalk_done(&walk, 0, assoclen);
+		scatterwalk_done_src(&walk, mapped, size);
 	}
 
 	if (pos > 0) {
 		memset(buf.bytes + pos, 0, AEGIS_BLOCK_SIZE - pos);
 		crypto_aegis128_update_a(state, &buf, do_simd);
-- 
2.48.1

