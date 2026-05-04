Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972DF3E0251;
	Mon,  4 May 2026 15:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777909184; cv=none; b=iNt8dpcp4FWS6Ji074hoF0HK5kQ7pFCMCF8RLpv5/VI5pTUVn5vZY0KVX+a5stZ++V4kO7i/WHR2GB3DAdCDz+s+o5ln7BSsiyjbGsW3fdGlqg2806KEubp85U8y9sOMndsC1oAOynlxzyTJxmkdQ4KoZcSiDl9e4ZI+RoTcvl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777909184; c=relaxed/simple;
	bh=wXA66UJbIpzCtYdtcAzvfSpEKu6C0MJtApWKi6F4YDw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WKEyjSOjNOSqNmTy3WDI/uedKn9U9M7H7tSEUb/SJ8kXLNqePE1va3e+uLjFmMRLbzKioUBZyF+0z7Mkw5tVdGni9jyAZZO9MURCXpawOOwL8u5LYTNlo90QQDS77WKo9AjYFg4c/fVMUkHIEKuyrSV7vTLJlnDco+z/c1T69cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=hE2n0h+h; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="hE2n0h+h"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 48B3E1A350F;
	Mon,  4 May 2026 15:39:41 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 1F7F45FD5F;
	Mon,  4 May 2026 15:39:41 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 77AA611AD2BCD;
	Mon,  4 May 2026 17:39:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1777909180; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=uvBvHYQc9incdS4pyRWWg39JHb2lfMzCeMd1O03d4MU=;
	b=hE2n0h+h8wPjrWHv0ilOuElgq3KHEGllQ0NiWDSwf7ced0kGiaHaeP65NtB21xt9+ITwSW
	e7iOa91bcUwyjlKsuUJi159XmjoZcRvdRahgPA0ZWxUt/uuVRF5JwycGPDXIdYii7ssFDw
	NQLRVrjC1CgzcXOlS723LFh9X0vyi+DRdASzQfjEORdVXs2u2ayxDQdbb1ammNwFARkQfV
	JMPMJ7dYvAAvK1Prz2oVpEsspm8+pn7v9IWuBK8kzvcZk1AsrUVq0VBdaOx6yyWDzWTHSe
	zA+EuZjaWUzv8OKJVj6dlSgSqACmfIiU9FwTC9xeUXFzLGZ+xsTdICqRMjS1vQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Mon, 04 May 2026 17:38:29 +0200
Subject: [PATCH 3/4] crypto: talitos - remove useless wrapper
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260504-bootlin_test-7-1-rc1_sec_bugfix-v1-3-c97c641976f5@bootlin.com>
References: <20260504-bootlin_test-7-1-rc1_sec_bugfix-v1-0-c97c641976f5@bootlin.com>
In-Reply-To: <20260504-bootlin_test-7-1-rc1_sec_bugfix-v1-0-c97c641976f5@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, 
 David Howells <dhowells@redhat.com>, 
 Kim Phillips <kim.phillips@freescale.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Paul Louvel <paul.louvel@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777909177; l=1332;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=wXA66UJbIpzCtYdtcAzvfSpEKu6C0MJtApWKi6F4YDw=;
 b=8ca7UXY81DLfirE2MjD+496dbqAgpBfv/+Z7OYhyOE5WBf6N5LvBWIr0o+IbYYSW89QlqfNxQ
 OmVT20gym0fD5mhm+Le0WyX5J49pIUQ7hPHZRnDkxR+F/6W+/1v9vMq
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

ahash_process_req() was a wrapper used in commit 655ef638a2bc ("crypto:
talitos - fix SEC1 32k ahash request limitation"). Rename
ahash_process_req_one() to ahash_process_req() and remove the wrapper.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 6ada42d8aa32..8d063ad5639c 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2061,7 +2061,7 @@ static int ahash_process_req_prepare(struct ahash_request *areq,
 	return 0;
 }
 
-static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes)
+static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
@@ -2147,11 +2147,6 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	return ret;
 }
 
-static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
-{
-	return ahash_process_req_one(areq, nbytes);
-}
-
 static int ahash_init(struct ahash_request *areq)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);

-- 
2.53.0

