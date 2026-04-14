Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFBB35C19D;
	Tue, 14 Apr 2026 23:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776209963; cv=none; b=p7hz39oKETLMQLMbsyudj0MNQJZgCU3Ri8VAeclAKh4+6YC6lk5U0Ljhk/dTzQjBMRo7xQhkcFbAU9iH8U0NLPTRSpFEVlTIp/faW84sLEB92HDkW6s0bnHhhQB9XqCBUTSXe3bFdt6EViMLOY4oyw1HxavrcGOMO+OBekAYYIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776209963; c=relaxed/simple;
	bh=vE32vpVWrT9zI8K5wtWtbxZQhsSOsIyQzHHWViX4t6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VLsFg8DR4xrU43lsIzIYO0BrDtyS+rBsuJbb5+UiENbErRxZk0F4bqLcyQZRBTjTpZvbmq4FGUvi+g6rAWa5Vsyn4W8LqxmzH0eal/mSJ570Qrg/hBXV3AEpRdMhtLlNYe2pwDQpfAu+QR6vZ8An7lUnvQIcNTElrqnshGDfPwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=bs3TmBIi; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="bs3TmBIi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Gdh5bfDhyAHevqBuue5fWnNKAlzv2YVm0VzgAKpgyY0=; 
	b=bs3TmBIiww35gmbRh6fBqa1Ht25bZv2CUk5d7lxbm2wKGBmo7QPQJVAKLLILa/SUOf4RvmE9mSh
	xuk0BcHPb/uYhPj3T0a9BKnhCWeMNXrdWzetR/7xV/iJ/9qB5uoSklZ9iE4pnHBd2gP0hzXIS/YWo
	3IorbMKlf3ds0UxH66zA7C67axtwJqP77x+mtVDgMw2p3tDvSlthcFkqOyhj7wndXQ4tUNFb+1lnU
	BguX3k67pFH1jeAllpabmLBmegxYoe3LrpDu0YWGKeRLcQZ/iTkYa516x9uiBcOFBl47aEH99kYfW
	DuIdfAQx450q/2oh+fTCMt//59ymIIRvo2MQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wCmw3-0069Qb-2M;
	Wed, 15 Apr 2026 07:39:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 15 Apr 2026 07:39:06 +0800
Date: Wed, 15 Apr 2026 07:39:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wolfgang Walter <linux@stwm.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: authencesn - Fix src offset when decrypting in-place
Message-ID: <ad7QGhjPKRh-Vvm5@gondor.apana.org.au>
References: <2026041152-boaster-patrol-1918@gregkh>
 <b397c5b34ed7484aad6e0acf7e1319c6@stwm.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b397c5b34ed7484aad6e0acf7e1319c6@stwm.de>

On Tue, Apr 14, 2026 at 06:52:22PM +0200, Wolfgang Walter wrote:
> Hello,
> 
> with 6.12.18 ipsec stopped working for us. After reverting commit
> 
> commit 153d5520c3f9fd62e71c7e7f9e34b59cf411e555.
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Fri Mar 27 15:04:17 2026 +0900
> 
>     crypto: authencesn - Do not place hiseq at end of dst for out-of-place
> decryption

Yes this is broken.  Please try this patch:

---8<---
The src SG list offset wasn't set properly when decrypting in-place,
fix it.

Reported-by: Wolfgang Walter <linux@stwm.de>
Fixes: e02494114ebf ("crypto: authencesn - Do not place hiseq at end of dst for out-of-place decryption")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index c0a01d738d9b..af3d584e584f 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -228,9 +228,11 @@ static int crypto_authenc_esn_decrypt_tail(struct aead_request *req,
 
 decrypt:
 
-	if (src != dst)
-		src = scatterwalk_ffwd(areq_ctx->src, src, assoclen);
 	dst = scatterwalk_ffwd(areq_ctx->dst, dst, assoclen);
+	if (req->src == req->dst)
+		src = dst;
+	else
+		src = scatterwalk_ffwd(areq_ctx->src, src, assoclen);
 
 	skcipher_request_set_tfm(skreq, ctx->enc);
 	skcipher_request_set_callback(skreq, flags,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
