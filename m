Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C47283FEE
	for <linux-crypto@vger.kernel.org>; Tue, 30 Dec 2025 21:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767131049; cv=none; b=bqiyNIlRyLKzCOlgTJseS9JmhLfE8MwjHYCWUJSbfwi6/gQuxaWbXhHG2wuVyRY+nNbKO5gIYPAH8Y9ji3gJVLtvHho7EVe4XRu7pDWsz2cFKwWsxhzGGSWhpBGf1PgUm7j0nmjau3XLJIJHtnrflWvB5MQM+zAS+54wqM5xt60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767131049; c=relaxed/simple;
	bh=AQgq9nmb7fCxLefy9wdLBHIwFb24gWOpAgXCoBOOx4o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZCBXi6j6TRInNzrSQ8Tfacba7fFBmDbSXMSFrv3sY8yRvwSdYH8N7VW83edLQPPS66vCZtWdH/HE2n84dmjfOSDAXQJwo1kV1bz7ipcxan1z3sFKX5dSslNCM2FOPkFrL0nK8O22E9pWxSwrPtZemlVMxDZTubtt1xBL/g65Wbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=ZZSKHEIx; arc=none smtp.client-ip=212.77.101.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="ZZSKHEIx"
Received: (wp-smtpd smtp.wp.pl 29609 invoked from network); 30 Dec 2025 22:17:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1767129443; bh=7hKCbRNRCq/8uK8IHfOlY3vk1bSvTtwXNHKdRBGAAgQ=;
          h=From:To:Cc:Subject;
          b=ZZSKHEIxAUIeGO2QT0iEYaCvG8jgBstYm30muMoh1O6QYr6NknpJFhwFVUwcqTyDk
           51Tw9G/hAewlMN+l8PisK630UKRmDrV65+enYxvoNdSa6ejB2Q8Tn+NqmaNCm1iF1t
           UK6Y7ziTqK8f9i9ZEGeZtGmf/Hmeg93qJQQA80kKnZxQmvGyQx54jIlxpM/wNNEVhL
           ewsE2mmszenqF0fXcAdA1oLTO+TPmjeQkjMOljTwvLngMsG1s3Q7zoI7mnHtTZ8QUB
           HZwNISAZxf4B19h3MkUOb8aKjPOxcrzqSd4NvnHYZDCsuS1dphwTaaZyOd1rWJ5KBn
           cqfFTkXMUmUgg==
Received: from 83.5.157.18.ipv4.supernova.orange.pl (HELO laptop-olek.lan) (olek2@wp.pl@[83.5.157.18])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <ansuelsmth@gmail.com>; 30 Dec 2025 22:17:23 +0100
From: Aleksander Jan Bajkowski <olek2@wp.pl>
To: ansuelsmth@gmail.com,
	atenart@kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	vschagen@icloud.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH] crypto: inside-secure/eip93 - fix kernel panic in driver detach
Date: Tue, 30 Dec 2025 22:17:17 +0100
Message-ID: <20251230211721.1110174-1-olek2@wp.pl>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                                      
X-WP-MailID: c1eb65b8a4aeef560a51a8bee05ecb10
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000007 [AaQR]                               

During driver detach, the same hash algorithm is unregistered multiple
times due to a wrong iterator.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/crypto/inside-secure/eip93/eip93-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
index 0b38a567da0e..3cdc3308dcac 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
@@ -90,7 +90,7 @@ static void eip93_unregister_algs(unsigned int i)
 			crypto_unregister_aead(&eip93_algs[j]->alg.aead);
 			break;
 		case EIP93_ALG_TYPE_HASH:
-			crypto_unregister_ahash(&eip93_algs[i]->alg.ahash);
+			crypto_unregister_ahash(&eip93_algs[j]->alg.ahash);
 			break;
 		}
 	}
-- 
2.47.3

