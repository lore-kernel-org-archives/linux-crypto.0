Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3722239E7D;
	Wed,  8 Apr 2026 03:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775617766; cv=none; b=FnM0T5DQSOPxCeMZGL+OAPYM1eUW8296TZCracHogijKHd+ukGKgLzomKNaqzy9QDRL/dH9jviohlb5nPTKFc0+TvCrcGlEV7RF6xpD86pNAM1i/jp2ejcAxuH04HtvtWJdtev/GiEgD20ME/WmurF9Q0OHtkuqmSKhwVH3lsL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775617766; c=relaxed/simple;
	bh=clFqp8uYqEOC0hX7vhxXuHH5l5xR2disoNQCo5id2vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7H4e8Gm9h+8MkmIRWb2L+9CRX2hEj8Y1DxDX84QlKxwumDDnxR0Bd5dF4Dupi30PCBmQrYMl/FqEF3MOwd3+JJ6CNi1vRJU/SjBnGYK+caxW7Lq0uc5vX2eDCtWpwg4Wa7xzdMighOOtYrZACSI4XuSfGaYYYlJ4p24Oh5JjG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y+pe85d2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y+pe85d2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F2AC19424;
	Wed,  8 Apr 2026 03:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775617766;
	bh=clFqp8uYqEOC0hX7vhxXuHH5l5xR2disoNQCo5id2vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+pe85d2drLC5E/x0gsZxx7ir5X8cA8UYTRDJdkV1lqkn4zQDAs4m3Ct1lRtjUekA
	 eRMAFiCJ1nq1KMq61ppDrGgQLRr06h3eYNKCe1O+wHgsUew7143YcgwMGMo4JJYBCH
	 W5F5/CMNINTTQIaXt25PHaU4sJ3JmsG3sawZnwzM43XzHsZaZnQaRJXc7PO6INmwIQ
	 8VCN4umerZ4bmlomV+CLDu9wE1ywre6H7hvQhCMZk47gIy8CkzfFRbAy82XJePxLIv
	 wAX+EIXv4+SLzjWNc/rvCkhgGXviCefw77wyg9bIKc3llKOwxhntxKe3eWg65HtrRw
	 GAqZR5BDrBcDw==
From: Eric Biggers <ebiggers@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH wireless-next v2 1/6] wifi: ipw2x00: Rename michael_mic() to libipw_michael_mic()
Date: Tue,  7 Apr 2026 20:06:46 -0700
Message-ID: <20260408030651.80336-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408030651.80336-1-ebiggers@kernel.org>
References: <20260408030651.80336-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename the driver-local michael_mic() function to libipw_michael_mic()
to prevent a name conflict with the common michael_mic() function.

Note that this code will be superseded later when libipw starts using
the common michael_mic().  This commit just prevents a bisection hazard.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c b/drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c
index c6b0de8d91aea..c2cd6808fd0fe 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c
@@ -462,11 +462,11 @@ static int libipw_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	skb_trim(skb, skb->len - 4);
 
 	return keyidx;
 }
 
-static int michael_mic(struct crypto_shash *tfm_michael, u8 *key, u8 *hdr,
+static int libipw_michael_mic(struct crypto_shash *tfm_michael, u8 *key, u8 *hdr,
 		       u8 *data, size_t data_len, u8 *mic)
 {
 	SHASH_DESC_ON_STACK(desc, tfm_michael);
 	int err;
 
@@ -544,11 +544,11 @@ static int libipw_michael_mic_add(struct sk_buff *skb, int hdr_len,
 		return -1;
 	}
 
 	michael_mic_hdr(skb, tkey->tx_hdr);
 	pos = skb_put(skb, 8);
-	if (michael_mic(tkey->tx_tfm_michael, &tkey->key[16], tkey->tx_hdr,
+	if (libipw_michael_mic(tkey->tx_tfm_michael, &tkey->key[16], tkey->tx_hdr,
 			skb->data + hdr_len, skb->len - 8 - hdr_len, pos))
 		return -1;
 
 	return 0;
 }
@@ -582,11 +582,11 @@ static int libipw_michael_mic_verify(struct sk_buff *skb, int keyidx,
 
 	if (!tkey->key_set)
 		return -1;
 
 	michael_mic_hdr(skb, tkey->rx_hdr);
-	if (michael_mic(tkey->rx_tfm_michael, &tkey->key[24], tkey->rx_hdr,
+	if (libipw_michael_mic(tkey->rx_tfm_michael, &tkey->key[24], tkey->rx_hdr,
 			skb->data + hdr_len, skb->len - 8 - hdr_len, mic))
 		return -1;
 	if (memcmp(mic, skb->data + skb->len - 8, 8) != 0) {
 		struct ieee80211_hdr *hdr;
 		hdr = (struct ieee80211_hdr *)skb->data;
-- 
2.53.0

