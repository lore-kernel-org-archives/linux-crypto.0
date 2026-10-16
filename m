Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279CA3A5E7D;
	Fri, 16 Oct 2026 07:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792137099; cv=none; b=mykvXAQQYc7cS4WxFmr2cvwTt3u7GflZAkVM/JQmo+9TTzZn80LuB3etzmU+sV7Yu8lQnfmXtF0yZgXzh2GfGqoyBHL88CUXMchmETjop4weC26GMb76d3e5Gu5nVSlAIscmbpSQ2PfXLCVd9GcpbCo7u1YC4nOVMvyTKPIf35o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792137099; c=relaxed/simple;
	bh=juTrZ8CAyljddanWKz6QyDPin1GpE77KZkVZXYYBmLA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=n4pbSTfLoo3pyPZ1FuO2t8Y5pboCM2TOjkzuayL25F98tRv2pSByDtUfG3FJFSOfeiWzFdKhpXL4q4bvcv/UNrwxxEy7DSRjyo3NT+yphpv8kpCajK94UEMp3Ij7ehkvytnd6u6+b4iii27JbYMeqtQYYg88cacSIODF1Ncp3jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=gtgrg/co; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="gtgrg/co"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Sender:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References;
	bh=953dKz7gEZpCw/GjrcTRdt66c0/ELYaPrwSqXXQ2iNg=; b=gtgrg/coHFuv+FQWlfg6TJFXYS
	3DH/qRsFem2jecz+AJZ9Fym8RL3NYE3gt6K7Ox6eyocOPgLzhX16X36CB+MLGJkUqBtjkw7dfEwIq
	nyY/5DHtQ11KNBauiHd0lE3bDvzzXRQNcn2x1fgAbUZhkz3kgxd535i/tjQ/zVhvuaJFMjYhWptw5
	RoeMgCbQ5piP8jKlewCBprpe7jybWdnPhDNP8soxmyq+/N4TvuDXkmzzY9ywnl1We4s32vzMFhQ+G
	nj7y8kzblv6XaiZbIRFQSgfY1pIgOpiwCKM9BbMRA8kU0u9KVGLzzhI5U5TJBe+BqB6keUwGQrOWY
	dE93TxYA==;
Received: from [151.115.150.205] (port=42428 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xHciw-0000000BPms-0wkP;
	Fri, 16 Oct 2026 09:51:28 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	stable@vger.kernel.org
Subject: [PATCH v3] crypto: essiv: fix use-after-free in AEAD path
Date: Fri, 16 Oct 2026 07:50:31 +0000
Message-ID: <20261016075030.3463123-2-Jeremy.Jean@oss.cyber.gouv.fr>
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

Check the return status before dereferencing rctx after submitting that
request. If the operation did not return -EINPROGRESS or -EBUSY, then
the request cannot have been freed yet.

Fixes: be1eb7f78aa8 ("crypto: essiv - create wrapper template for ESSIV generation")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---

Changes in v3:
 - Code simplification.

Changes in v2:
 - Drop the local assoc variable and check the return status before
   dereferencing rctx, as requested by Herbert Xu.

v1: https://lore.kernel.org/linux-crypto/20261014222351.2930674-1-Jeremy.Jean@oss.cyber.gouv.fr/
v2: https://lore.kernel.org/linux-crypto/20261015121743.3151400-2-Jeremy.Jean@oss.cyber.gouv.fr/

 crypto/essiv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/essiv.c b/crypto/essiv.c
index a47a3eab6935..3505b2769d93 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -250,7 +250,7 @@ static int essiv_aead_crypt(struct aead_request *req, bool enc)
 	err = enc ? crypto_aead_encrypt(subreq) :
 		    crypto_aead_decrypt(subreq);
 
-	if (rctx->assoc && err != -EINPROGRESS && err != -EBUSY)
-		kfree(rctx->assoc);
+	if (err != -EINPROGRESS && err != -EBUSY)
+		kfree(rctx->assoc);
 	return err;
 }
 
-- 
2.47.3

