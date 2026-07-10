Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386A078F26
	for <linux-crypto@vger.kernel.org>; Fri, 10 Jul 2026 17:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783704657; cv=none; b=V5mRrZWWf/m08AkmbJxWJyWL54q0Vgv78StSwsikmn3bn4lcS5jlz+8ItbuU4ndr6RZ+OXkcnXGn68ZdVhPW+yarxFXy2QIw9roKhPemUi33oTuG+CHOWSm581tK1+ayLUSp154SVwpSpAM6qhpGLxQZnG1nE6HF5yYVZbJQF68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783704657; c=relaxed/simple;
	bh=/zr/axeNwzLqEpCzeT7RCY5ork8kdfWaV4dpnfgpoUA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VqPzrH+fB5IxCkEc2D7+U95oeHJBh3mkdSB8bbORhl1tmwCKkvk4vx2Y0ovoJ3E+bWOWgTQq2CXwODSV1w4GijuNgIhgr46RTW+COsIgWZIi9w9RBQRqNcYAVEu5Hj+dM8Vwin9BOh1EnLsZvECXNkzwOfQLTOrFyhxYffWQIzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=X//9bYaz; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="X//9bYaz"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c15b509c323so171603066b.0
        for <linux-crypto@vger.kernel.org>; Fri, 10 Jul 2026 10:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1783704653; x=1784309453; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FDzbfwt6aO87HJ10PJGzFsqUnWfHCYvGtQuDgYNPfq8=;
        b=X//9bYazY/Sk5fPbuMt43gH64Z0F8FVF9sovzdNXtVxpgABocpDgCFcomece/RcANi
         wia8xA+9JcoKBEW5cZhMmpmk0BToLhv8PuBtnXJojCavKFec8aGOferHKkM27RxktVQw
         JJPnqwFkRr/hSyWa/YR3yQ40XBcXgOfK6/5xpn3sPAJhbypP4H2aHSWqSzAJSu/gcL1M
         vDLag6jO98hybCqv8wF86BFv1Qy51v/LuuW4+kJlfCIcvauQl1FvOshiUTXnRAdFw6hz
         hz6p7vrvBy/p0PDSc+7iDR3SV/QA9t8qbflWsIZbZACsSDMoYqOlFfszikoYsx4sxZoP
         n6TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783704653; x=1784309453;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FDzbfwt6aO87HJ10PJGzFsqUnWfHCYvGtQuDgYNPfq8=;
        b=WogSrC77gTJ0IGF1qzuDWAbvGBUzRF4eEpL/tcfu2v4sxACAY0dFS6L18pqBypLGI4
         KKqYkaMDtPMvdWuQUUM6by8Kr7tN8TmEMsH7ZIaFYG0MHSfDyHa9wbn3AcCO95oLmmYf
         gizirPYtyacBGdTnihxqMEx1rlHtiKYlJ8hIp2aH+AMMcHoh12FFjQaoZGlXt7YdlRO9
         iqM+zLcOA1QPTXophNhi5jyWUdGdGjtstRK+THxfkxKS8rdaSbhXVXL7vQdv8FKAjhd+
         +WzkpUE+ryGustMvlB5y/PXNjGiQ5xbr7DHiJuTDKjau5rYSGIChNI7GwTOPGECCybdP
         a5GQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq3IP0WDEwRgiVi/3EgbmXrwqEg3yg5IundsSLuSHBpztZvXOjcMvzbwBtGqFwzdg/yq2AlPgLL7fgBMno=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAY5rdqoPhrT4D/sEsOOxPd/ENQHTUIO/0e9C9F5bk/kCqErct
	Mfj+kAJjoPpm+g4YVY/b6XvYg8BvOmPMEf5vnnSoxV9/jH94P6yqx0AK
X-Gm-Gg: AfdE7clmqiDgtz4W5D/czjMGzHrOku9CDTXvH07+Z1FZB+Dy5ISE0zB07PCVy9s/bmf
	pLedw955BxF0iCMWAJq5JYSfSSRBJGFXJkJngX+F4I9DTQhSNbFDzvSGEFUeHLjK4KUFPSHrAe3
	LmvSx1sEXxQQw8Xv8dzoC4bm2/v7lMqVLhBW5JsGu5kzrGXLzBB5c7ZreAAHr/GJVUwrMWAZIoy
	MdVU7FX+CqdDu8dklYz9AhBMvHF5INDI/CORgzkxIGR3B6bb/GBN55CIglxl1xrNT49TiQJSvRG
	ZM5nEYO/lQTzVJYupqpxLtfpKP7Wg6ko8LLDtGh4kqZFWQup4xxgIL6f4WeB6LzEwPurK1ztf5t
	yVKoAiTkNMigcQ2gwc0dkxMUQLjiklB/EutGIhRJq9hi2pmyp/uOjOtQotgy0jgAgKQVDsHrbfr
	VLXGQo6dJIbvP9klkMWbudfC9TLJk2c6qBgLpn735z
X-Received: by 2002:a17:907:1c24:b0:c12:9a2b:4838 with SMTP id a640c23a62f3a-c15ce034468mr606117866b.26.1783704653049;
        Fri, 10 Jul 2026 10:30:53 -0700 (PDT)
Received: from fudgebox (k10193.upc-k.chello.nl. [62.108.10.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15dfda815dsm326168966b.36.2026.07.10.10.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 10:30:52 -0700 (PDT)
Date: Fri, 10 Jul 2026 19:30:50 +0200
From: "David C.C.M. Gall" <david.ccm.gall@googlemail.com>
To: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH] crypto: pkcs7_verify: use constant-time comparison for
 digest and signature verification
Message-ID: <alEsSl8i1_FpoU0f@fudgebox>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Replace memcmp() with crypto_memneq() for cryptographic digest and
signature comparisons to prevent timing side-channel attacks.

crypto/asymmetric_keys/pkcs7_verify.c: PKCS#7 message digest comparison
during signature verification passes argument pkcs7 and attached
signatures to pkcs7_digest via pkcs7_verify_one. pkcs7_digest utilized
memcmp which could leak valid prefix length for attached signatures via
timing side-channel.

Assisted-by: gregkh_clanker_t1000
Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
---
 crypto/asymmetric_keys/pkcs7_verify.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 474e2c1ae21b..28953e53177b 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -13,6 +13,7 @@
 #include <linux/asn1.h>
 #include <crypto/hash.h>
 #include <crypto/hash_info.h>
+#include <crypto/utils.h>
 #include <crypto/public_key.h>
 #include "pkcs7_parser.h"
 
@@ -93,8 +94,8 @@ static int pkcs7_digest(struct pkcs7_message *pkcs7,
 			goto error;
 		}
 
-		if (memcmp(sig->m, sinfo->msgdigest,
-			   sinfo->msgdigest_len) != 0) {
+		if (crypto_memneq(sig->m, sinfo->msgdigest,
+				  sinfo->msgdigest_len)) {
 			pr_warn("Sig %u: Message digest doesn't match\n",
 				sinfo->index);
 			ret = -EKEYREJECTED;
-- 
2.43.0

