Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85009190462
	for <linux-crypto@vger.kernel.org>; Sun,  4 Oct 2026 05:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791090606; cv=none; b=Qdp19JE1kE3K87m5ZlrDhlPMMzTtSG5rtIl9C9gCol3LUXKwEXRExUjVgQZ2MEQL7FpI+7ohfuY6an2yuFiuujBXz/uuN/7iMfYaaBPHSNWwN6rJJNtW+ouSl+BXHTddLTO60SV48avzHCQd3dq8Dd2wuNkX4KcZTXdb7p89j8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791090606; c=relaxed/simple;
	bh=IXzXisik/Zy5HF8UDVd3aRDCXeaSkyvSVfGa+Dmmx/8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LpVf7OKxzM332whjgNpVsA82M7N7uBfkN/mlxQ5e3zI8SOgFHq+Xqu1j3SD4Fn1SnFiT3qwztA5MPhOOmz7SeVR6F5OqlJNohN6dFJ2sJ1bbaa2Jfy8VNUYe/lbpv+iz+lr1307eeX0nPTlHTTAxlkW5pLbCod5wpw2uajGx6LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N2Z1UPor; arc=none smtp.client-ip=74.125.227.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N2Z1UPor"
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-396ccda24afso201359a91.3
        for <linux-crypto@vger.kernel.org>; Sat, 03 Oct 2026 22:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791090603; x=1791695403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=O39FQFwyEOH81dyYEdu1kpPgRRCGO2BOYjVofQBwRYA=;
        b=N2Z1UPoreiUxFkjhHjnqbI4m8j5gvYudz3SKJuJwaMbFtOknNJqQSHpM1UDPl32k6i
         HTnmgmQyk90jqhXXMA884wTyg7hoik4xJA+s2UwU9BmcEAggnzKnf8Oy/XHMBrN3wIZN
         sUu1Gqdzw4lDRSXjVB67YeF6FNdJkvhrgLrNr4asU4YN1hQvCB6DyIFWlgoP1UR/t8s0
         AMz3weHcudabo/kG2DMg+66QlKcQfRCzXDnpgpnNrUOdUrzMc2GRWZe3br+I4t8IfuV3
         AsmZ+Mro2Qzty2LGZrzUnhEvSPZ6xNiSB6VIqUGO2UBgr6fBP1BdsFcn4SQNlDdLAoQU
         BONw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791090603; x=1791695403;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O39FQFwyEOH81dyYEdu1kpPgRRCGO2BOYjVofQBwRYA=;
        b=YHveTj4NQOMJHdfYhN0Q4IUP8Hlup37nIAlvsU6J/CCGfNgCQDhP7KbmfEyKUbj1Gy
         kImx1YTmowaVh+LbaVJqP/ZVlA8CMw6CoTl/WJncMOGorYyH4rZkdJisb1GcUeWborpo
         VRJJWqCZPA7AxodcHuvLCDMbcosT/h8Edw2usjhH0i8aAc2eI8LDFGGTQ6W9eVtoScPP
         FKA/ry19di6NE2SHz368nmv6IbIAEQTPbCUngKopcaezQ5NC3yZa8yFuQn3JimVKrjZD
         SEAVAszLm3vJaBCQtx1EZsWS1Z79SHm5CC67I3grGob02PWf43cPlEdsYC/M6aQR2VAD
         dYVA==
X-Forwarded-Encrypted: i=1; AKwUvBw+lE16I9L5WJM8EgdkvJWdAOM39qU3czQvqP6m4PpItUU8mKNUMYSwMJi99zYL7w2a6+j396jd/xbv364=@vger.kernel.org
X-Gm-Message-State: AFq9FYJapaqnFdhhXCZ7eRzMnXmVai/LkCZnY5ZTVH9WyRcx9WVBidDw
	fwUfHD2EX7fQ9sttfS1YNvTnAAW/bmB9QWMaF6E/AmsvvjZdVrZtovN/
X-Gm-Gg: AYBFou2c7oyc69qZcDQ2TLlWZfghsFYIsycCsqFglsMUVafKWbujyXY6oH2BhrsyJBV
	a/7yKnvOLHfooR4GUdcIRZKlcWNnPGZX23MTuWeoFmipBgbzRAumvJoGbKSCPfEmxCDtuxWNkir
	NEEXwoWplcTR9QQgCqMegmB//blW36KPBCCORPUnsg8cNra0UBTkh82Q9vHqDaQk7KD/0+QNI1R
	SWlYh92jbgUBrSnKHC3qZTqH4XU8IC/W3pB4YIZqX/dlweyLeJRhP8oip6fndm03wXJyZamgBZ/
	MORKaCWw40p4xutWhsizToDAlyRFIn7Yrq8b9Uvld35mO4nk9V5DtD8GIuLgJ3e/SGZNQ8L81Wy
	br91Jx1kOZwER4T0xNLiA4c+awf1q7WdbnQIfCdMMwjJiJNcbK5F06c+1YVTwVP8IfP7DmpbcFq
	cyYjoW/5j5ljbHWeHIIEldJtHwaf8CmBxIzrqi8h3Ml4IT3KV4jKcZsHt4cifMqFP2MCjBlbOg0
	ux1Kjp+aZ4JIzyjz0YQQg==
X-Received: by 2002:a17:90a:2ce1:b0:3a6:dc2f:f087 with SMTP id 98e67ed59e1d1-3a6dc2ff4ffmr1693679a91.53.1791090602694;
        Sat, 03 Oct 2026 22:10:02 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a7e4b00de6sm100531a91.1.2026.10.03.22.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 22:10:01 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Daehyeon Ko <4ncienth@gmail.com>
Subject: [PATCH] crypto: algif_skcipher: rewind rounded output bytes
Date: Sun,  4 Oct 2026 14:09:46 +0900
Message-ID: <20261004050946.3131044-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

af_alg_get_rsgl() advances the receive iterator by the unrounded RX
scatterlist length.  For a continuing skcipher request,
_skcipher_recvmsg() then rounds its local length down to a whole chunksize
without restoring the iterator.

A later chunk starts after bytes which the provider never wrote, while the
syscall returns only the processed length.  When copy_splice_read()
supplies non-zeroed pages and publishes that return as a dense prefix, the
gap exposes stale bytes from a previous page lifetime.

With unprivileged xts(aes), a 31-byte MSG_MORE request followed by one
final byte advances a 47-byte destination while returning 32 bytes.  A
hardened v7.2-rc5 image retained all 15 seeded stale bytes in 4,829 of
4,829 records.  With init_on_alloc enabled, all 72,345 gap bytes observed
were zero.

Rewind the iterator by the tail excluded during rounding, before rejecting
a zero processed length.  The crypto request uses only the rounded length;
af_alg_free_resources() releases the entire RX list before another receive
iteration.

The fixed target-like kernel returned byte-identical dense 48-byte output
in 4,771 of 4,771 rounds.  The unmodified kernel returned the vulnerable
32-byte short record in 2,409 of 2,409 rounds.

Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
---
 crypto/algif_skcipher.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 1e61fe6e24b99d..291dbd69893257 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -135,12 +135,16 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	 * full block size buffers.
 	 */
 	if (ctx->more || len < ctx->used) {
-		if (len < bs) {
+		size_t excess = len % bs;
+
+		len -= excess;
+		iov_iter_revert(&msg->msg_iter, excess);
+
+		if (!len) {
 			err = -EINVAL;
 			goto free;
 		}
 
-		len -= len % bs;
 		cflags |= CRYPTO_SKCIPHER_REQ_NOTFINAL;
 	}
 
-- 
2.55.0

