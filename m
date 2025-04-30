Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6E12DC779;
	Wed, 30 Apr 2025 12:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746014449; cv=none; b=LNwe80zr5JIYOuvebJvW6PNR9Jznkf4DCDplnq1LPVuzkWR0UeNcC52oK7e/oMOYhHxB1z6Rg2ZynTtOSRK6UyVzYjfo25/fjX8r5A2DlYjFtBx7jUqOTxjZRrCd/ZJAF3eBkPaQPAv4hQKBLXTJU/GH+Vwtl4r7wXeLl5hJiso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746014449; c=relaxed/simple;
	bh=kxdRKp2lzjagy8gOzCDfUJcqbQMHv+M8TNnx8KCN8WI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IO4b14UGqtfBfrlDDBoiHEvTBEv42Fom46KoPtoK/E4a1c3CAmp+HZ32SQx3ug4FzdBON9CpOAJpmAL94dZjwer/+2/8gv4DO/4Dp65vexrKpfJNXWVe56H/IblUWEmEMzvi0acgaI3kdJywZH8CPw4SP2QFqKC1uZb5BTriyB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ftg6vtPC; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ftg6vtPC"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ac6e8cf9132so1421144766b.2;
        Wed, 30 Apr 2025 05:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746014446; x=1746619246; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NnW1V4G7QDzDaIONh5ACII2mYnPVAr6ZbvWhIzGCX+k=;
        b=Ftg6vtPC8SmmkrH+BvFIUKBKtoDO0aDFCB/JgAJ94fAFs7Ku2JaLTiZJMOFKv37pBx
         3yae+jOYoRTBu4EEseR3NfHvJW4mnwJlqWPl1xh5mbBNNZbFg9Quzrvcn+yFeW7WBXOa
         dS9TjJIwyfPEXfOxK9Ra79+H8PqOHKa/sEG7RsPmRawMvKUjUuzgwOxf7ORrbbncLSDR
         Xfta2Zbrxdx9ldOdQY0qeRTmhYievxTOReEmcCwQ7x3/sI2HAO7JTIgJDesklcTrxYab
         nFwKiLC86ItY/6nG2iRtZ4Slt19c6UO7umuqh4LrT3RFqGsW+BrJWMrs4rP3ixpop9CM
         H2TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746014446; x=1746619246;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NnW1V4G7QDzDaIONh5ACII2mYnPVAr6ZbvWhIzGCX+k=;
        b=ND7hU8lmOSDIKVldQaC/5Plnmmvgf2EuaaVG6qOFaGUmHdzYk2rQcddE6fMch8chTN
         mnDGv2VjGdpV8UYpI5d3KHhW4e4IlaLyx8U8JORwVlIJsnJsZHAYS7X2VqmoJWc7TX1N
         LnqvCSnwS4dzyvHtObJe50xD1UX89fy6qc7fwgxxfpCewumnvNDudCeIXoTQoU6DETIj
         x8qf5jHxpbsVNtZrb1LiFYKYmbARVpagZ7yWbGEr2ujmvljxLhIjHrGWXGvchB+diXJc
         t6fC/oEFxaadzbot2NK9yNPEAynmgIfmRzeyuiwoq5OEHdW+UPSZNpDrJ9ESkI2ILrlr
         gqtg==
X-Forwarded-Encrypted: i=1; AJvYcCUZbTux8jlKCcAboGDUz2H623XcJDa/REN2HuGyKJbEtw5jKfEtH7TcgvjrCB7DPJkIp1Rb7Yq0p3gpqOc=@vger.kernel.org, AJvYcCUmVvIMntCsuhe51dCHUFXGv/v/mLRfeSLfyrRYgMFVdUa6Zify/Jkm13URFUxY9eumIYSkVs2wP0xM/3uP@vger.kernel.org
X-Gm-Message-State: AOJu0YxwIF8beAJxwEE6cyXK7ae+1haRhWNivTEY67/QRxF1ZyrKw4Ca
	WK1Zrfi29vdN12xgsmRlF8nTwdJj/yzFgxFk1pYS1INRsmQO/HMK
X-Gm-Gg: ASbGnctNK8RmcXZafEBBjcHTlNhuZhcfAOo07VADM9zD+ckeRC/MsSyCvrTvFqADpgp
	IP/Xr9uQMOwoD8oPGU0p1fogNLlI5PAQ0JQ29pdKJ9mDZsI7e//jCAkzMTImKSuwKW6yzNVOawG
	5Ta0KMvgk4pBZQV/JeHdYGt/oK/yvNoydDBC91LqOMTUmQtpeN4hoTauPsEqv1V2kktXcvIV0B3
	6OlRVa04HRyh9nmF0o3X/81YWWcZpnO1UJwf5s1jxfD9DORtRva/iABSJ6JpGURW8T4b/KKMx/5
	n2ZgAZZDhFJsCoqJvUeXhn9FDBTyxJFvr3d4ojYThpYu8CrG42dqy+NaZf87N5Vh+4wKma7TAIc
	hdtU=
X-Google-Smtp-Source: AGHT+IEzCqp2C+g91jO5PGP9Djnt7u31GuUe/k4aFGoYVUesU7GnbTtM7j8u4LECq2tRaHqh89SsbQ==
X-Received: by 2002:a17:907:9488:b0:ace:3214:fed8 with SMTP id a640c23a62f3a-acedc630b9emr322914666b.27.1746014445764;
        Wed, 30 Apr 2025 05:00:45 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e41a850sm914382466b.32.2025.04.30.05.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 05:00:45 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH] crypto: rng - fix documentation for crypto_rng_alg()
Date: Wed, 30 Apr 2025 14:59:53 +0300
Message-ID: <20250430115953.1180650-1-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current documentation states that crypto_rng_alg() returns the cra_name of
the rng algorithm, but it actually returns a 'struct rng_alg' pointer from
a RNG handle.

Update documentation to reflect this.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 include/crypto/rng.h | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index 5ac4388f50e1..f8224cc390f8 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -102,12 +102,10 @@ static inline struct rng_alg *__crypto_rng_alg(struct crypto_alg *alg)
 }
 
 /**
- * crypto_rng_alg - obtain name of RNG
- * @tfm: cipher handle
- *
- * Return the generic name (cra_name) of the initialized random number generator
+ * crypto_rng_alg() - obtain 'struct rng_alg' pointer from RNG handle
+ * @tfm: RNG handle
  *
- * Return: generic name string
+ * Return: Pointer to 'struct rng_alg', derived from @tfm RNG handle
  */
 static inline struct rng_alg *crypto_rng_alg(struct crypto_rng *tfm)
 {
-- 
2.48.1

