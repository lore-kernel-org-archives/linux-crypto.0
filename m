Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C4D54F83;
	Sat, 11 May 2024 14:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715439127; cv=none; b=AhAKeuWyZM+jGXqbPRU00bVnZ7ax4MljjnTVCoM4sMLJDNqKia2r3tJmPz8DVdi8Is/X5IvCTfCouCbZhbjVXuwAF3iVa6h+MyF/jUBQ6AAcbuJo42j+6Aw119BwBot5aoMkQWPDgXPTYzB4mWUKxCopfUpj0sQX0XXGtryy/G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715439127; c=relaxed/simple;
	bh=hESMlG+DyjJvYR3YjuIVOG1Vn3/rspdgNSEah+6LKgo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hWHpNvW9RqpgLHmBr0M5ujKuyoUs23Wv6UlVZAdckeitTWlGwQ5GEdOMl8Y4r8xaMYzLvBMS+P6yUQ3hSpaSlsISsYekWsESwAaR+J1UtR5HW4mEL3p3pDFF0XY+AajaBZPIJcT84dZy9gD3IFSYo2QKr08rJ/6HO9nzkfgoDOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=fv47BPLk; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="fv47BPLk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=d2vLCzehgHm47XW0WpV2IkhRw0DOIxl0U0Um3oclJ28=; b=fv47BPLk9y7JW0Cd
	4xRqcaTaU9jZgdJQSEZfrS9DiiCGlmAJe/VRbH79CWKeJftX219p2x9T6WCvFIrkZ2eJx9pDdqOup
	PtIR9PNtCfZKMdaWNrxRId+Bj+Xv666CVcuw3jgiK1R9celsO+v19iZNPFJDf8HL1187Gmvvfacxr
	anMk7Kslq563NGe8Exe3lA+sX3j2tfmW44IBnvYv/sTRo8o0yBwN1EOmbNL73rslmeF/zv6Fg16Rt
	ebtA3qDcPxsKePQgq/aHlf/Pf97EYZafEpOS/EL6oUp3LvI+A8mg1PrsgGBLOtn5eHpIg/BcSIE8z
	YhL5Yr+S1KR0RYHgzg==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1s5o4v-000W4D-0L;
	Sat, 11 May 2024 14:52:01 +0000
From: linux@treblig.org
To: gilad@benyossef.com,
	herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] crypto: ccree: Remove unused struct 'tdes_keys'
Date: Sat, 11 May 2024 15:52:00 +0100
Message-ID: <20240511145200.226295-1-linux@treblig.org>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

'tdes_keys' appears unused.
Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/crypto/ccree/cc_cipher.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index cd66a580e8b64..3fb667a17bbb1 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -261,12 +261,6 @@ static void cc_cipher_exit(struct crypto_tfm *tfm)
 	kfree_sensitive(ctx_p->user.key);
 }
 
-struct tdes_keys {
-	u8	key1[DES_KEY_SIZE];
-	u8	key2[DES_KEY_SIZE];
-	u8	key3[DES_KEY_SIZE];
-};
-
 static enum cc_hw_crypto_key cc_slot_to_hw_key(u8 slot_num)
 {
 	switch (slot_num) {
-- 
2.45.0

