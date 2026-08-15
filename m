Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7D82D7DCF
	for <linux-crypto@vger.kernel.org>; Sat, 15 Aug 2026 17:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786813708; cv=none; b=HgmWBJjeKQ0f3DQtx/4k7q7Eotbv2P+0ZzK0iczz2M7UlwxK5xTXJTINc/FXmhza4FNvsPnUfz3wISvos6/mRGwR2pxZLIHbQnVMoGg0TUnUbYwsff1zdrlqpLC6MiLFnUp4fvsvRdErIhbvG57u/R+5Db3Gbfx1itosO8POlTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786813708; c=relaxed/simple;
	bh=AhtxvJ+EhlvDKp97WYvO0vAsHP5tRb64VcLlZ7gHwTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Hwnvm8qUOA02qZ7QXYe9mZV8oq8SH3jPCKyFTMjIDjVT6tR4dOCSr/oz2F3Cr4pItOADL2zgDirCYzGrNe5iXsng5zN0RR8QZpJVEcxlcJgImKRMV/BwYctgyuimAC/vbwStQIRFFoXsJrY3FKHDsvAKgHLQ/sLI8b9pDpv3LKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=IhDpYKok; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="IhDpYKok"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-698ae09e356so2487258a12.2
        for <linux-crypto@vger.kernel.org>; Sat, 15 Aug 2026 10:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1786813705; x=1787418505; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b/+rLZmsZRuHHc/j7IikqYNJli/WdzMweu24EFXnWyM=;
        b=IhDpYKokPWPncSkeNLOuF8izTF1FzBnQiTVCcO5zfqt/4YWvIkhAPA+36KO/5mgpqD
         yLXQyxMVugbHIq8HHWskpXiwtlmp3rVQh7JVV9XpaiCZZedJ0391ZAhCHYiF7OekiVNs
         MCFVV6G1k7M2UWfw6bl4TLre9Ov7Vro893QBegi5gw8pdpfj7PEPIRZSmG0CkGrvnhoy
         I/Rk5yqpQjQEQELvLzK00iQav7dzXeWYNXjtvHzzZY+2kcaVYuGnNGzvl3y+IY2SLICC
         iYEQHmGzJXg/YQj0GOwDxsXmjL57WjvLGLPN/18fKnHWvdxj4S7CFltyEVPuXekCYmJd
         EFdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786813705; x=1787418505;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b/+rLZmsZRuHHc/j7IikqYNJli/WdzMweu24EFXnWyM=;
        b=qpg75AGpdon9CtycUGqhqLj9XUU6T2nmvwcb462x15ZwbIPsILcN3o/fDaHG7pvd4t
         9ExgRipDKyjrBJULborWFPP4pfBp90wv0y5Mc4/wY9bUQ2dciflZ09bto3y4aJ5Lx1l/
         O2MAcVaXIdudcTzLUNf/ZZkby37oX8QLiDjz40XdoJSuQaYc38PYX3GcgonEHOQm6WeO
         pJ4C0g1a8VDmWdT1cfZrLQUYcsxyopqhx+e3giiSaMI0WgYlaprF0hWyhAGHjiHX++bV
         j+7EHgfjc9Pk0DEe8LwJ3QEa/mzEH1gLReLWGQnrw6vJ2njPLTbPNzwsG5SubFOLq78M
         znRA==
X-Forwarded-Encrypted: i=1; AHgh+RpkvJPBKwC0Qxp0wjLomDAJ/smQNXB/qOr6Jx8a5xh5XUvNDGtb+aLBnJbbUxo01Dl+NNuTQPiHA/2GJAA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzT9vfsQRfGGPRxRN4QdETc6zNa7NvDd9lUeIbQTL4ZKAMdLL6
	bbL7D0mACUyezYhIBEAlhU/RkBPOYK3CQj87MqwLjkllsb6EgG/VAo+W
X-Gm-Gg: AR+sD12Px/7c27hbfp2wPN60IEthQy+RUpmsw7e3vwG7r7b86f5SnZzhoPFDc269G2D
	TXD9UzPCWBAAvglgcyUwSnCa2ReVbsMa5vOvnGKUMGlWuabZR1rYvYJxNfB50BNFHAghRA1s2mo
	OHii+IVkoeC4wzTzdx6kz4XytX1VSp5E4wCU7dCZcOOqmVWOb6mmH7EYnnK4LFb6jktaxsYuXzM
	7a3qxcpEUTBXnKADegS9XHjQM/4EwuTKy6tgUqqCnZsvlevyOm7BsmWtIXYqCwX4E/Sm/2SRtch
	I7xqZUgbRHvVjJJ/Mu6x4Ys/dFBXJbT7201u4tQY4stuEdCIoUN15457SUqwcZN/6MyDGqORuK7
	BcFSqAgfUrdbheBCsEO1f+0sqemMVLDi1l/oB37N+saVu1iZth0COeOQItbRVogz2RCcGkOigaA
	s8pT7LdyfW2E5Sm/oNfk8MHPVq0x61/QSsqbXAe45MdOxuxFBLqIXxclV8wyPYEn3imNaTNXKbl
	iixMmyxNOkEzBeHScc=
X-Received: by 2002:a05:6402:1ed6:b0:6a1:7718:ad44 with SMTP id 4fb4d7f45d1cf-6a38a9b2241mr6060858a12.21.1786813705072;
        Sat, 15 Aug 2026 10:08:25 -0700 (PDT)
Received: from david.gall (k10193.upc-k.chello.nl. [62.108.10.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a38c9d5713sm2072694a12.6.2026.08.15.10.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 10:08:23 -0700 (PDT)
Date: Sat, 15 Aug 2026 19:08:21 +0200
From: "David C.C.M. Gall" <david.ccm.gall@googlemail.com>
To: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH] crypto: octeontx2 - use crypto_memneq() to check HMAC for
 cipher_null authenc
Message-ID: <aoCdBZ-kLQ0rciFi@david.gall>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

validate_hmac_cipher_null() compares the computed and received HMAC
with memcmp(), which short-circuits on the first differing byte and
leaks tag-match length via timing. Use crypto_memneq() instead.

Because for cipher_null the validated payload is un-encrypted, this
valid prefix leak allows for authenticated message forgery.

Assisted-by: gregkh_clanker_t1000
Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
index 8d9f394d6b50..3ccf17d031c6 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
@@ -11,6 +11,7 @@
 #include <crypto/xts.h>
 #include <crypto/gcm.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/utils.h>
 #include <linux/sort.h>
 #include <linux/module.h>
 #include "otx2_cptvf.h"
@@ -90,9 +91,9 @@ static inline int validate_hmac_cipher_null(struct otx2_cpt_req_info *cpt_req)
 	req = container_of(cpt_req->areq, struct aead_request, base);
 	tfm = crypto_aead_reqtfm(req);
 	rctx = aead_request_ctx_dma(req);
-	if (memcmp(rctx->fctx.hmac.s.hmac_calc,
-		   rctx->fctx.hmac.s.hmac_recv,
-		   crypto_aead_authsize(tfm)) != 0)
+	if (crypto_memneq(rctx->fctx.hmac.s.hmac_calc,
+			  rctx->fctx.hmac.s.hmac_recv,
+			  crypto_aead_authsize(tfm)))
 		return -EBADMSG;
 
 	return 0;
-- 
2.43.0

