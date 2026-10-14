Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A24312836;
	Wed, 14 Oct 2026 22:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792016653; cv=none; b=ngh81PUzgvQps8yMMIaqkuO5omYLdPYkjm1AFTFYAmDcoSEUbt7pfziMSMqqRDRppsRD8Wpilh3pNzb2IyKCcD613yo3fo1Ku0G/up6PtZEx4UZZ4GSesMFadwE5evHiamR1v27PrFv5J0QYzT0SDhVXcop+OE90zSrO/LvAyF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792016653; c=relaxed/simple;
	bh=FOrWl+3hKVM3E0yFnK8y0KiAl+sD05mmhgu1G+jz7iY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cPrr7ce80uRZpGGDJTQFFDc4qmq9tLhq48RvMEdpmAa3+nIVNOoaB9+ouQ+hlhupPCdBgDHkWAqWJ4h6Ekcv7yQEw2d4dZwkXT/F88Sb31QKlivmAaVPdQpvXWE/DJWZ9u/vCllJURPN4YNs+NU4UxUXrpo04nx/EYrmhaAQODE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=h5hb5Sgq; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="h5hb5Sgq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Sender:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References;
	bh=g3hYliZa2aN88Wi7FBg1RWhJwDGu2cojpb/JM8a2nCg=; b=h5hb5Sgq/Hwc5jCisdJ6kG3e3u
	PcTTrpVXvyfCiWsopiT5yvIR17HeBtenXWEvMH+7cWmsQmKqKih6Tdp3v6BRPG3oz3NNxijrGC5Fu
	ki3XCJ+CqrhOeL/3JzoX+TvDuuebgZ3umydWDOyB2Aa5C2SjcRzjG4+iVtiXy2jPX6xnucSo167Ya
	k/KXlMkZ6rgW6Pr8+aHprRtJfbehp/QTM8rIRXZ+8rg+CKIeYNW4jlF5BDHIAOx1IjExJFmaSGk4E
	13SD0sP/rDL1NfUEAPQDGfsnO03dAYVHsbgJ6/kQndMaSqDKBvK+qdT9WaSavYGnlfWIlbKOHIT8p
	tsrIOhkQ==;
Received: from [151.115.150.205] (port=36162 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xH7OE-000000083Go-3On1;
	Thu, 15 Oct 2026 00:24:02 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: essiv: fix use-after-free in AEAD path
Date: Wed, 14 Oct 2026 22:23:51 +0000
Message-ID: <20261014222351.2930674-1-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

The request that ESSIV submits to its wrapped AEAD transform may
finish before crypto_aead_encrypt() or crypto_aead_decrypt() returns.
In case this happens, essiv_aead_done() calls aead_request_complete()
on the original ESSIV request, which can end up freeing the request
before essiv_aead_crypt() resumes, creating a UAF:

  BUG: KASAN: slab-use-after-free in essiv_aead_crypt+0x8e6/0x950
  Read of size 8 at addr ffff888102af1360 by task init/66

Keep the temporary assoc pointer in a local variable before submitting
that request.

Fixes: be1eb7f78aa8 ("crypto: essiv - create wrapper template for ESSIV generation")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 crypto/essiv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/essiv.c b/crypto/essiv.c
index a47a3eab6935..d85136feaf3b 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -189,6 +189,7 @@ static int essiv_aead_crypt(struct aead_request *req, bool enc)
 	int ivsize = crypto_aead_ivsize(tfm);
 	int ssize = req->assoclen - ivsize;
 	struct scatterlist *src = req->src;
+	u8 *assoc;
 	int err;
 
 	if (ssize < 0)
@@ -247,11 +248,12 @@ static int essiv_aead_crypt(struct aead_request *req, bool enc)
 				  essiv_aead_done, req);
 	aead_request_set_crypt(subreq, src, req->dst, req->cryptlen, req->iv);
 
+	assoc = rctx->assoc;
 	err = enc ? crypto_aead_encrypt(subreq) :
 		    crypto_aead_decrypt(subreq);
 
-	if (rctx->assoc && err != -EINPROGRESS && err != -EBUSY)
-		kfree(rctx->assoc);
+	if (assoc && err != -EINPROGRESS && err != -EBUSY)
+		kfree(assoc);
 	return err;
 }
 
-- 
2.47.3

