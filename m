Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAAAEEC0;
	Thu,  9 Jul 2026 02:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783565137; cv=none; b=I/qIoY799w/nnYFhEHlB8+0WczaABcyllZWyuOl2R9wHkUjR6I/M/a7oILgqagNA7TlN4Ptmxwk7PVxWKPuAiHXLmBqmqYSTmkJCTbxCqp1ozKkgJRezkfK8kzm+iVCLuCMz85iVdUyPelC77GwAaFyByuLKaewm09M5zxMUEOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783565137; c=relaxed/simple;
	bh=B4sB5XWE7cSAeuarIdTc/s0UhzdgTJZD73Hdg4hcUKA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mrlw0MbAsOueEMKieirE/urHfjcWuNi8tLJYhTZPVTaLMRYH9ZGjnmUC1NI1f5fzHTDObA34ES3H1FVI4RMYkR6aDMZIhpZjtWlVB56mSfLzG9VxkGh7GCrPRrCo0y8vO7Q+nkrWPmm3LujUCi61IjzmC1KjVweWHzffx3MgVNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FUaxzpFJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FUaxzpFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCF51F000E9;
	Thu,  9 Jul 2026 02:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783565136;
	bh=jSlk9Z/FGzf1qqoSCxsV+iIQUjW/+mexmFdaAGfOUTc=;
	h=From:To:Cc:Subject:Date;
	b=FUaxzpFJdPh4gbaS+L+AaLHlCVKSiuVk3QeLkYeYXaHqXJutrCZWPFYj1HdKQi0cR
	 MT4HrZRPLluA4G9RcVeMFuI26fo7j3V61J1z6U6sg6ulTXjJPSwxl8I6kBwcNbWPbu
	 iGFcAE8lTBh/VCxXwFvAkLTw79pr2z0zvO3pWda1xfDxfE7WlVNwtAUrQesZmWdHBx
	 w1Kdiimz9u261mxfn87wJlPvIQwFXeHSYTAX6DNQ3VHnGDwfbPZeSpRvLZtlA1o2mY
	 P9NFSDfub1eOfuTi6isHmwOaHQEwf9XgrCQuzKDx7MZTSj80SrOkNj9a06YItzWpkH
	 CwKG0+Cm8u1bg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <jouni.malinen@oss.qualcomm.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] wifi: mac80211: Fix cryptographic MAC comparison to be constant-time
Date: Wed,  8 Jul 2026 22:44:43 -0400
Message-ID: <20260709024443.58132-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
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
index d2f4a17eab99..00b91e6ed994 100644
--- a/net/mac80211/fils_aead.c
+++ b/net/mac80211/fils_aead.c
@@ -195,7 +195,7 @@ static int aes_siv_decrypt(const u8 *key, size_t key_len,
 	res = aes_s2v(key /* K1 */, key_len, num_elem, addr, len, check);
 	if (res)
 		return res;
-	if (memcmp(check, frame_iv, AES_BLOCK_SIZE) != 0)
+	if (crypto_memneq(check, frame_iv, AES_BLOCK_SIZE))
 		return -EINVAL;
 	return 0;
 }

base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
-- 
2.55.0

