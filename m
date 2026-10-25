Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792962094;
	b=h3PopuhMdFzKyNYuj+JABvs2L8m8kIi6N7EX0XC4NWCsHgbODKxdLdTgc1uR5cq/9bfD
	 OdpBwj2Ml2fYiDuWbHxcS4x833BHxzDtiJ6x6+t9IwGwdvNNLeueVUhhSyGpefABTn1DM
	 MXJohtpkIPnE0XKPK3EDYMgigQErxg8opBzKN/CdHXXiouBpoAHfBfa1+uSUC9kwBp6bJ
	 jDv4lqWlrmyy+ko9aiBP4ESY20mCf33dWUUg5bqiOXlixKK/QoPzGv/uY0tr2YVwYl/ht
	 pH1l0CyAOH8eQVeK14bRHYbsdcAlDCVd1vfn/1zMeguzWGm+rk0+CmeEf81ZvvUjA8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792962094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3g+p5AOGdITDii67J24gqDoEuR4BTYwLoBIHBXhPWsQ=;
	b=rG0xyamRtdP/xso3O9jql4mE8SjuKXGhVKcv0LxkQMxdhq27poNBTwQkKXtj5vqeMcRo
	 N6enjfYTdGB2OrVbhMxozZIn6dHnNukAvVHXspBNzKQIzXCpJckFEXVFxeMyx9QPhP2vx
	 qu4uFTXFzFO4KCQk2ynxA7EninPeYixLAI+l6O3UVDu4WZ09C+XhqQSI5jgu67wpJMyRH
	 cY/Bg2f82Gc7xI336+fzmTDa3UkiLYWTR7c8nETYdlBHOaL13FCOGnabjMJ1tHQgQgYHx
	 xF1SIE4QR71N2rQz8miXvQCszqNUNhbY2Wp/3tBbStH7S462D0egPvOfM73qDUJef4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zq5UW2wz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369EF606A31B;
	Sun, 25 Oct 2026 21:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zq5UW2wz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963C61F01828;
	Sun, 25 Oct 2026 21:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792962093;
	bh=3g+p5AOGdITDii67J24gqDoEuR4BTYwLoBIHBXhPWsQ=;
	h=From:To:Cc:Subject:Date;
	b=Zq5UW2wzz4PCxEJn/n0U9WKwpvOhyWp6XVdu/xZ03rvbqfNg0hpKNnFU+crLagyB8
	 bbtWZ7nYxr/+sIZj90p64xI7uouW7s4K3WYU+7Azdss4dNV1mT13bssZJKZkTEmluC
	 6qq1M8N67sD9jsX+OiAIwO8td5e+aK5tF59tLPI9N/y1e/7ModiZcP0Rvo22dpPOu+
	 zbuQUtORGUFXOUPGV/eq7oEQJU5luHXl7MbXAVGkUFflLHlZnlz7/v58AYr+Osr1w9
	 o7nu7sBPu9uarzzD14XlsSJHftiv7M9J0/U0TXyo4wa/kAaVteNTHSS6x+wG/waqzc
	 JyNR0Vov1WqVg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-crypto@vger.kernel.org,
	Yuqi Xu <xuyuqiabc@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH RESEND] wifi: mac80211: Fix cryptographic MAC comparison to be constant-time
Date: Sun, 25 Oct 2026 14:00:32 -0700
Message-ID: <20261025210032.134911-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To prevent timing attacks, the comparison of cryptographic message
authentication codes (MACs) needs to have data-independent timing.
Replace the memcmp() with the correct function, crypto_memneq().

Fixes: 39404feee691 ("mac80211: FILS AEAD protection for station mode association frames")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/mac80211/fils_aead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/fils_aead.c b/net/mac80211/fils_aead.c
index 9c4f00d61981d..638ced7685af6 100644
--- a/net/mac80211/fils_aead.c
+++ b/net/mac80211/fils_aead.c
@@ -202,7 +202,7 @@ static int aes_siv_decrypt(const u8 *key, size_t key_len,
 	res = aes_s2v(key /* K1 */, key_len, num_elem, addr, len, check);
 	if (res)
 		return res;
-	if (memcmp(check, frame_iv, AES_BLOCK_SIZE) != 0)
+	if (crypto_memneq(check, frame_iv, AES_BLOCK_SIZE))
 		return -EINVAL;
 	return 0;
 }

base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7
-- 
2.56.0

