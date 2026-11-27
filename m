Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780914;
	b=mkhDOXOQregcLlZLoFZPSjPUvnS2brY7IvCsAXafClBmaPLdGa/CsYK/ZNDQD/K712BF
	 EN1VhsIWG4ABkBJmq+Y8EMDhy3tV+LN+/yj7jI8FsnmoN0LudlnXyMmppBz0QtaL90u/L
	 B2N+4Vbp/tPBso83X0M5Ii7N/F+YAaj8DtAN7JIGf+VjHhvFrr+NZsK9LOOjFp/jVXpI4
	 2MFdV549NjkogD7k1sKAW4+TGJIZkwz1ptfZX680J3dJwt8XTbQvqTsqD+rWpcmId3VpA
	 lpjvWmJvCljIG9ZtHr9YlpukFRSeEE3ttdEl1bvzFWf88ObrNsfUdSA8/8GJLiwfOkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780914;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6o5PkBcDr5mo9vn6AHRcwo7DgEVc20BXfKxW4pDcM60=;
	b=rhhXk5jRNa+WNXzd/emHMWhc+UeiTIGlbM3qosymrdCrG3dvRDoU0d1TugGKRNEqliNu
	 B5M/pQdJD9lhiWX9H8udD4mJJkl2zcJUts/wbsqpOECPWLl9PR+4T5I1aA9G9ApnN0ibW
	 gxP+3bXQzqjfnBXnBN2FZHSUWV/CxtfWCd4RfnK6Bg9eL7PSMKBTztPcjBxttaAuXYRqQ
	 JBSxSPhLDC/jPDcqIwC1LXKKZPUTSEwLltUlxaaK62ZhH0Sg3XA95arDg7Uqt3WjoK7Im
	 4eAQbID8/iChuCauqMDFFsCQRNBMBuLmc1+JMhFtZib0+y5AE7UOGFTgEfXimxzqk2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Gpj0Umx2;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4B4606A321
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:01:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB4B4606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Gpj0Umx2
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4bb70074ab2so85073595e9.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780912; x=1796385712; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6o5PkBcDr5mo9vn6AHRcwo7DgEVc20BXfKxW4pDcM60=;
        b=Gpj0Umx2YLwWJkWNmDrHGQXxLwihpUYAsiMnavVczRdVnVoXqYnAH0EBh8kWODq2Jx
         LfDg/lh8AkQNSIP35Sc02EXjPZhW8zAEh97dUpLh8nrSTblEiw22ixL+pteUPl2Obtui
         FIYUEEqJCqq4b5CJYUJ5mNKP2ewnvmXXbVpaUO9M64QT1nUy0Dtv6b2kBOu8pMFTpGrR
         2HXmgYMv9T/4OqtzRsqQ9Yc4zJ2AIZ/6hzpj2O8Xn4WIwNQJbKkvt8Jnnwqu0JE7uvag
         sQOuawLqCymS3YySXf4lrA8t1ALfBR6Fubgz0/JG8r8ZYfRNtA1y0TL+TemtrNCBthNv
         G64w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780912; x=1796385712;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6o5PkBcDr5mo9vn6AHRcwo7DgEVc20BXfKxW4pDcM60=;
        b=IBCwNkQFIBnGX7dzXfBehxGv8BEM30+v61xyR+aVVHUNW2mm/QO8lAi6furK8IVNNe
         BBbOfp6TvNRhmvAXzJXbWRDWwVryy9texC4LDvHeFp6xwSzOF3o3YDvPNpe8PDjD7blg
         Mz83Wv49njbCHr1txASQIcGtTjdfC6WeYVTByWNwcH/v73OE959oVFcZMu8P/gNBKEmg
         VE5X8vkRtOTZlX4yBfJUYhtUwOvmgC+8q61+5unOGX6VZTo0boXsGou94sZBEkEBdm55
         zn/Dcgm424cHEdH2LDLwjBwkkfGEhq6uaiiXIZWxRFePLRkN8xH9QHc5jAjm3eb6CxHQ
         dV5w==
X-Gm-Message-State: APuU4Z9Od3fersOvlignA6bhA8WmDPmqZ8QOS4qrjCx2Q0LkYklYKXK4
	Z4UBGVPv7iJGw/VP7keQkZZh9/hkNBjgBblW4UonCHECm6W9eZxkpQQn
X-Gm-Gg: AZFdTZfNbmbLxXWSxEDxa2YK9RUHKixVrsJ5jFLtOqKwCGLRYmqm36HEmNtZa1U39w4
	qDifd03QqpBNJGDOdSMvTNAfVvdnSmbEnQ/SH3nflxKIUG1t4GYK8JmQxTV3VtW6pnIF0fNEPxk
	Y2UL9ThbmBeKSfvIXYsTKxcA8rc1YC1jZJSTfRpacVumTT9wig6P4I8CPGD7gDVURpeUIy1WsWY
	EgObFqPIcEwLsMEpZxBhdfA++GHAjpjZq/4aVVzba5bVx+C9nGKlaIB/uCOnouUZJP+lR2OmCna
	mqsb73gtZlIWoaMbFz326lkITC9kIfCaQXvut4NiI6a+TwDhs3hiepFrMmjjnkQXtuEqm47CXA9
	Kwhve1P1XS4DF2d7hRGvCaAQ83q7/zqbw3Xf4lPW1xSUWK40DXkCGXmizFUZRtrM9w1RzsSxMgp
	09LgeItGHOvJlWZsgq7ZhiNoQxFyZkaGpjHSRG3UdlzKGYFFdLBbS3fi/jskBHsa8t4LM2qOkqV
	T4bXvRTg1CGMfjsuhR90z26cHCVTJyvejP/up3ZNEORQ2mqD9HPcIccsPySauMCQMQvZzRCL488
	v92FbUDx1dOE1lDmKGt/myKWh/SwM5A/2r3VYPHF3FIVW3NE
X-Received: by 2002:a05:600c:a0b:b0:4b7:6a8b:9df2 with SMTP id 5b1f17b1804b1-4bb8882432bmr483859845e9.25.1795780911905;
        Fri, 27 Nov 2026 04:01:51 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:01:51 -0800 (PST)
From: Jose Nieto <jnieto.alaber@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jose Nieto <jnieto.alaber@gmail.com>
Subject: [PATCH v14 18/30] crypto: amlogic: g12: drop CRYPTO_ALG_ALLOCATES_MEMORY
Date: Fri, 27 Nov 2026 13:00:51 +0100
Message-ID: <20261127120103.1532882-19-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127120103.1532882-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The driver queues requests to a crypto_engine kthread and does not
allocate memory per request, so CRYPTO_ALG_ALLOCATES_MEMORY is stale.

dm-crypt allocates its skcipher with a mask that excludes
implementations carrying CRYPTO_ALG_ALLOCATES_MEMORY, which prevented
the hardware cipher from being selected.  Dropping the flag lets
dm-crypt bind to the engine.

Signed-off-by: Jose Nieto <jnieto.alaber@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index 6070ee6b488e..72892fdcd55d 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -498,7 +498,7 @@ static struct meson_alg_template algs[] = {
 			.cra_priority = 400,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_ASYNC |
 				CRYPTO_ALG_NEED_FALLBACK,
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
@@ -526,7 +526,7 @@ static struct meson_alg_template algs[] = {
 			.cra_priority = 400,
 			.cra_blocksize = AES_BLOCK_SIZE,
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_ASYNC |
 				CRYPTO_ALG_NEED_FALLBACK,
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
-- 
2.47.3

