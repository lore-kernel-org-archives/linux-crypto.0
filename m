Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985D7535B8;
	Sat, 11 May 2024 14:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715439274; cv=none; b=dLykNZ3DF6trlCBhTjGds+bCx217CPjfX/NKtyW+fqqA0IGfQCIDIbckUQAnQO86iaRqZpjbhKQNpAGGxi2Gti+NTdugozTzCQqZslMxgjuxTVdq3NTQKhh7aY54RMdzy+XjM9VP+sbusBeUqd77Vzi8CaLsmGx0s7y4M1/zni0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715439274; c=relaxed/simple;
	bh=SXT6PmgbNQQJcx82IKaKzZ62KKTm+VyZg7hOe/FeYVs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ftqEE5jDKu/MF/Sg4Y/VgSfCGUHHW7th3OJHpGoyEuOoptS9duoY6GsG/FUuzx8dBxJ9UKale+v4ig0af1S49P+XXn1hgcRqSVnA7AVO6uXizBwX4fMoJGv68byEVYlHObAs5BWwvwIN0JzLpOQJKmP3wMsvovdrvzcukSlQjos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=cA8n5jFk; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="cA8n5jFk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=cALCYB3IeIk47FzlqUsK3MjBGhbm4QSkkYWY84cdTVM=; b=cA8n5jFkFgszNO5N
	Jv5PFePd+Qn6kg1hkecCYwLlysDKy3hU5/7kgQpejzl9lAJmpMgnYeOKo9oHEzR4498TNkgsMuL0+
	81aSeAMc0LFeOZo+FG0OlEpS7JZls4NETNRFhuGdrri6eKb9tu3/els+lvHRV5ylivbcwT5s6/F8W
	stR+5xFyeyCqxIrMVQnwjDHx6hfodpeFrHNRlmzpe4jQjtqy98hyplU0W0u6e7As3+XdX9ZP24mYt
	Jjy3XMWM2eStEfcPAK/CeU9tQJaPQwLQZ4E6570BlHOC4wxgIj4r7Rvborb6j16H1KZ9j9tXlKpHd
	QSS3DM9C08XOAkqAhQ==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1s5o7H-000W5i-1Q;
	Sat, 11 May 2024 14:54:27 +0000
From: linux@treblig.org
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] crypto: hifn_795x: Remove unused hifn_*_command structs
Date: Sat, 11 May 2024 15:54:26 +0100
Message-ID: <20240511145426.226379-1-linux@treblig.org>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

Remove 'hifn_mac_command' and 'hifn_comp_command' which are unused.
They're the same structure as 'hifn_crypt_command' which is used.

(I was tempted to remove
   hifn_base_result
   hifn_comp_result
   hifn_mac_result and
   hifn_crypt_result
which are also unused, but they vary, and perhaps they're telling
someone in the future what to look at.)

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/crypto/hifn_795x.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index b4a4ec35bce05..9259915267454 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -495,16 +495,6 @@ struct hifn_crypt_command {
 #define	HIFN_CRYPT_CMD_SRCLEN_M		0xc000
 #define	HIFN_CRYPT_CMD_SRCLEN_S		14
 
-/*
- * Structure to help build up the command data structure.
- */
-struct hifn_mac_command {
-	volatile __le16	masks;
-	volatile __le16	header_skip;
-	volatile __le16	source_count;
-	volatile __le16	reserved;
-};
-
 #define	HIFN_MAC_CMD_ALG_MASK		0x0001
 #define	HIFN_MAC_CMD_ALG_SHA1		0x0000
 #define	HIFN_MAC_CMD_ALG_MD5		0x0001
@@ -526,13 +516,6 @@ struct hifn_mac_command {
 #define	HIFN_MAC_CMD_POS_IPSEC		0x0200
 #define	HIFN_MAC_CMD_NEW_KEY		0x0800
 
-struct hifn_comp_command {
-	volatile __le16		masks;
-	volatile __le16		header_skip;
-	volatile __le16		source_count;
-	volatile __le16		reserved;
-};
-
 #define	HIFN_COMP_CMD_SRCLEN_M		0xc000
 #define	HIFN_COMP_CMD_SRCLEN_S		14
 #define	HIFN_COMP_CMD_ONE		0x0100	/* must be one */
-- 
2.45.0

