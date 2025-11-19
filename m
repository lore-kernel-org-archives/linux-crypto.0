Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E6B32C333
	for <linux-crypto@vger.kernel.org>; Wed, 19 Nov 2025 22:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763592178; cv=none; b=FNc9NuO53OtJUfKr6FAia6gCR0Oa6FYL/bh6KzNCYdBL3+4XRA/7QvUw8cWr5ufbQycJWVHks129IKxR8PApQymMd/VfSVbFbwqArfqNSb1Q0PInpKFnnBtig6LFnTzuhaP7vQ/aStYYda/U3VrX1UOVcC+vhwdxbfn8rNVYNpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763592178; c=relaxed/simple;
	bh=HmDHkRA9WpbrXOoEfJ/ddkjX0oLoATDvE1Jo76ssmHo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l5S3rC8W+DKdFIlEnb+2JfKfDkh8ExDfuk3aQ3KR1KtF3FlXhLJDNtqD9HzR0v/LKFbkAAaTrPc8yRSx9Lq31+jaIRmRKzNXiWVsCBtR3L+Eg1o3CLmH2hBsaVWyyQjxRX8qxc3gVTcmZ2egt4EmqFYVqYSkE2SR1Gj5RtBYTgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=yRuc+7k5; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="yRuc+7k5"
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1vLqt2-006yww-Rn; Wed, 19 Nov 2025 23:42:52 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
	:Message-Id:Date:Subject:Cc:To:From;
	bh=4WfkeXMO718uzCZ/CSShybOTo3+QWuW28/UydqaDh1k=; b=yRuc+7k5HDeesQBx0pKiQqGifX
	e2I31OW6Qn46JQlheBVxaD1nMBWzCRF3PLWvQGAfp0DCiQf5jX+J0sn9icn5xsUZLponENMBGAasQ
	6w7YPqyRem/wX7QvjuZhyt5cpPbgUnPEsGdadEugR/w2x4FlQ4jQZLWSFi82cGcazF/PHu7Cf3GlY
	2FpXez+RgZkqejoYbX1fbEvoCjLo4YPIGm7BIjKUoYxACp8dcl2E/CTRDKOSrnuZvXQRlO5N6Z8nr
	F3qakQB/Pk5JvOcO3c1VCjtBMFJKsM8zkwyTHdnBOdMmy7nAXmVCmgTnXGGp4+qLyL6mSm/rN75PZ
	Sb19vLhA==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1vLqt2-00086d-JF; Wed, 19 Nov 2025 23:42:52 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vLqsc-00Fos6-0b; Wed, 19 Nov 2025 23:42:26 +0100
From: david.laight.linux@gmail.com
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	John Allen <john.allen@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH 16/44] drivers/crypto/ccp: use min() instead of min_t()
Date: Wed, 19 Nov 2025 22:41:12 +0000
Message-Id: <20251119224140.8616-17-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251119224140.8616-1-david.laight.linux@gmail.com>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

min_t(unsigned int, a, b) casts an 'unsigned long' to 'unsigned int'.
Use min(a, b) instead as it promotes any 'unsigned int' to 'unsigned long'
and so cannot discard significant bits.

In this case the 'unsigned long' value is small enough that the result
is ok.

Detected by an extra check added to min_t().

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
 drivers/crypto/ccp/ccp-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index c531d13d971f..246801912e1a 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -507,7 +507,7 @@ int ccp_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 {
 	struct ccp_device *ccp = container_of(rng, struct ccp_device, hwrng);
 	u32 trng_value;
-	int len = min_t(int, sizeof(trng_value), max);
+	int len = min(sizeof(trng_value), max);
 
 	/* Locking is provided by the caller so we can update device
 	 * hwrng-related fields safely
-- 
2.39.5

