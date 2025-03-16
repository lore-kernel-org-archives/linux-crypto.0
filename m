Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAF02E3377;
	Sun, 16 Mar 2025 21:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742159776; cv=none; b=DNHwgsfsT6a6/OzYLRs32YLPAnPPg9Q8NHGVlMBNVntEWvAI9ZvVQfKducfAL+svURPS7WapdSyQ4ldn/wEq+agxrJp6hs04n+MOIlCvW4acH3onHHEaV2PlLFiZYPQ5BlU+DSFuh3Vn3XXV4f8KV+6REiCY3vHgF7uzhQ2/PmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742159776; c=relaxed/simple;
	bh=ZB+I5gPoZ37X4w6tg0oQ/jXiZeSDFNLZyC5prmX5/4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TKp3XVqsaKzgZyeY09EH2kuNOLk+bsB1AvBevwm9qpREGkzhuDaGJJ68LgW6qqQRNlHuLTkCr+b46WC5NQVob2l56vBWCjrfWnkzcVm/zTdpYmuRjihuqaqC68Kmd5Qi/157/HDHeb+u/omPXbRcmSMT1Hr/aJ1lKJ8LPI88pJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t/n7mF9K; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t/n7mF9K"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742159770;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Fp1xelj0V5ejeJ62qJk9O9c3RGNOIw4UHrxss5oRzIM=;
	b=t/n7mF9KcVrPeUVrFufVVNhvxdeq1Uhf+lw2hO4dCvWyybJa/yT0u1jqrvLdW3WqROQyly
	NFq/yR4AtSa4sPINexRRNKjb2ZuQX6rebSwfXIj1NpCl6qR3mslGqyHYx0xh0GP58/CkcN
	KdI0HTUhHJIzyHKCE7ow1ettRwXbnHM=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: essiv - Replace memcpy() + NUL-termination with strscpy()
Date: Sun, 16 Mar 2025 22:15:04 +0100
Message-ID: <20250316211504.39327-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use strscpy() to copy the NUL-terminated string 'p' to the destination
buffer instead of using memcpy() followed by a manual NUL-termination.

No functional changes intended.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/essiv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/essiv.c b/crypto/essiv.c
index 1c00c3324058..ec0ec8992c2d 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -405,8 +405,7 @@ static bool parse_cipher_name(char *essiv_cipher_name, const char *cra_name)
 	if (len >= CRYPTO_MAX_ALG_NAME)
 		return false;
 
-	memcpy(essiv_cipher_name, p, len);
-	essiv_cipher_name[len] = '\0';
+	strscpy(essiv_cipher_name, p, len + 1);
 	return true;
 }
 
-- 
2.48.1

