Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C04F42B75D
	for <linux-crypto@vger.kernel.org>; Thu,  7 May 2026 14:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778164946; cv=none; b=A2LiKf7qAKkyH5cDbtkn9lidrX9E00W6ZvVoBJSdxU1xC9aUtnGT7CJzLkiTBWJhzi+hQ4G3AVhExtGFpatXnTpae9OhoWLivIK6ev6xEozUcwJ/dKK5v0Ad53rXAOVbaKFE/v/E9gwMoQqmFJ5Rs0qU8FwclyjmQsSnJSJHOIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778164946; c=relaxed/simple;
	bh=iNY1bV6sEU6UZySxVCoMKc1UN0Cns0l8ZB7lYYXZRGE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Z1X7K+ZN25Ek8vIma8YIjSmjSMCc312zMbS2W9nS2Kr/6/PGlEU89hVKntBJyg2M/iHAFo3r9aY4gAGe0r7P6u7+SAYuFRLommAMpIUmwOHyuEMxZDP6iR/xl7t/Gs07sxgatGyafbZjq7qOT02uJI2HuGshmC+6XFLypSb4YGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=dS4Xlwf0; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="dS4Xlwf0"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id E87CBC5DC62;
	Thu,  7 May 2026 14:43:10 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 33F6760495;
	Thu,  7 May 2026 14:42:23 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 029AE108194EE;
	Thu,  7 May 2026 16:42:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1778164942; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=KkM/TUCrKEGYPN5lXa8hKMsrHIbcVv/R/bnS/meaV8s=;
	b=dS4Xlwf0bHOj5W2ScVjDaQrNgFoh7t/Rpno7Vv++WlAgbd6Sw4fFNMpS29XoqM4vXQ/3zB
	Gd/Lm5qQkmONngxdxSgCshKewKWtqQw1CP8DFUW1x2PVB/VDKMmkPAuhlLMuAoGJdFIuTh
	KQOv/3cidtkQaXkD6VOKQbUdrh1uS0yil7+ixZ9DlrWaNumehgbKnUDABnGrdhW+FX9GNq
	lqXOURJiggIY8cty0tOgZDP5QGmdxQFdJmbSHeRn4yTGZCA2RMgE9W7PlFlTHaLW7ep3GS
	PEhh+5WyC5EhDSVJ3K1EfYGWIw3MFe8Fb2llOVFx2BGCOfDgkm32Pq5DSEjY5A==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 07 May 2026 16:41:56 +0200
Subject: [PATCH v3 10/11] crypto: talitos/hash - remove useless wrapper
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-10-c98d7589b942@bootlin.com>
References: <20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-0-c98d7589b942@bootlin.com>
In-Reply-To: <20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-0-c98d7589b942@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, 
 David Howells <dhowells@redhat.com>, 
 Kim Phillips <kim.phillips@freescale.com>, 
 Christophe Leroy <chleroy@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Paul Louvel <paul.louvel@bootlin.com>, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778164923; l=1346;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=iNY1bV6sEU6UZySxVCoMKc1UN0Cns0l8ZB7lYYXZRGE=;
 b=mbtLfy80Hkz69Dn7hQb06P6+OIr6Bw2GBBKEJK74retGcF5Pi2GLrJyfgrc7u7PPkhoLj//dO
 8IvIU8dPseND5VrKLVlFsWaxs2duZCeb4MzhdOx9/ys2zq+GOCUi+9s
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
index 6be42935068a..b4283b6c18ef 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2003,7 +2003,7 @@ ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbytes,
 	return first;
 }
 
-static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes)
+static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
@@ -2084,11 +2084,6 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
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
2.54.0

