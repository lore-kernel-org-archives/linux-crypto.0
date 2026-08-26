Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F0E3C3F58;
	Wed, 26 Aug 2026 10:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787740694; cv=none; b=skt8FZDBAki6UCgPfO2xpbNnN52QNiqhOV+5OFc8cGI4DeKRcFeU8wJuqPDpkYRwojMbCsHhf3eCMbmE8Z10rrzAid3yT2hH5H50Lofn50pg2ID8J+wCJaXWwfRMoIskDsfaH1R1rO/V19DVYswmnN2Gm3BQyapA0j/+M/ClZdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787740694; c=relaxed/simple;
	bh=NNr3wJwKgF17WRk8Cum0iRCECpT9rOyBZZDyBkYK7K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z8ir1zJWkmk0mztrPtXfXVj8SsvrP39rwdtmVogSn46EWO06eZOKKjUmkPjSBO7mWd0tu7Vw4kaMyX6kd2Zf1R2dKGVBfgdTwnO3yXjwvDt4gqu+7TxnbdHJBmLBasWPQKYldw+z88PW95xeksHtUcE93zt6yKvG6qa8LL7L9sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=Zan91M+P; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="Zan91M+P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=1Op76IBQC/iqUI0z51m9oAU5bBAu8rPm4iiBYTVK9RE=; b=Zan91M+PIBjueVpEiMNm/ekBcQ
	2YCqhYohApj4KMFrK5y6yv48MxyFrqVFTtQg7WMAoZLUMXq6lRM6T6qj1VVT/NRCk3Zn0MCHYGnPT
	0nxmUG8avTKwCp3t1/XEZI3uoF/tcnl0xvB2PGSNB2cSq2AF0WdXsaSp4MXnfDIBRptKST3Nc+a+5
	MdcwQwfQhFFcEdgMjFEgT9r09bEBDdAafVRsbdU6uIKAJPwLLab2tKinSnncyYWJUpnSGxWIfFDFc
	1wRAd4Q4OEZigVhdSS+oFeSZ/GqA/o3VA8/JPQNQ70KOHps0IATqiSdOGf4FkS9zIOd7DBwbRCR6Y
	YjEXQlZg==;
Received: from [151.115.150.205] (port=37352 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1wzB1F-0000000GmVI-47Xk;
	Wed, 26 Aug 2026 12:38:10 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH 1/2] crypto: rsassa-pkcs1: reject undersized keys when signing
Date: Wed, 26 Aug 2026 10:37:43 +0000
Message-ID: <20260826103744.1554131-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260826103744.1554131-1-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20260826103744.1554131-1-Jeremy.Jean@oss.cyber.gouv.fr>
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

rsassa_pkcs1_sign() subtracts 11 from the unsigned key size before
checking that the key is large enough for PKCS#1 v1.5 padding:

	if (slen + hash_prefix->size > ctx->key_size - 11)
		return -EOVERFLOW;

If the RSA modulus is shorter than 11 bytes, the subtraction wraps.
With a one-byte key and hash=none, the padding memset() writes past
the output buffer.

KASAN reports:

    BUG: KASAN: slab-out-of-bounds in rsassa_pkcs1_sign+0x1ad/0x3b0
    Write of size 4294967294 at addr ...
    The buggy address is located 0 bytes to the right of
     allocated 1-byte region [...]

Reject keys shorter than the minimum encoded message size.

Fixes: 3d5b1ecdea6f ("crypto: rsa - RSA padding algorithm")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 crypto/rsassa-pkcs1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/rsassa-pkcs1.c b/crypto/rsassa-pkcs1.c
index 94fa5e9600e7..d0e4a885397f 100644
--- a/crypto/rsassa-pkcs1.c
+++ b/crypto/rsassa-pkcs1.c
@@ -169,7 +169,7 @@ static int rsassa_pkcs1_sign(struct crypto_sig *tfm,
 	u8 *in_buf;
 	int err;
 
-	if (!ctx->key_size)
+	if (ctx->key_size < 11)
 		return -EINVAL;
 
 	if (dlen < ctx->key_size)
-- 
2.47.3

