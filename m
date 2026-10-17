Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D597A3BED2D
	for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2026 21:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792271124; cv=none; b=KvXBO5k0N65usqjO83a2hxpV5TslDTZQsVR8Ho0YwHC1yhBhKyIFse35sWv7CaYpR5Nko8eh/OAAXLNS2DmvLimVp3mStynKeX1xmlCYXJL3EVo0Tvr3VhDkZSiq56+Xt3lcPsz5Eicbbk+KuvQ2J4XsGZZ6tpOBAdzXHDn9c3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792271124; c=relaxed/simple;
	bh=eGw2YuVzGCEWEFpz7eCjB80XmNGsACc8knr9wmw9b0s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u5qJpGGzeU1ox9ffNhCs32NmLhxTpyRDsH1f+l5lrg2a0OqSmpu5FZlkR+CXT+9Cs5X55b2AxJPLZQ6lflaItevs5wTK6PH3sgnbPXYynnqNAKwjE8kQYDU6C5ubll1ZbNEopWIjL2n+YXS3bXPsyW+Z2IUspXpGmDo+LgBdrng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M23F6Qbf; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M23F6Qbf"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48e10a70540so22571f8f.1
        for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2026 14:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792271121; x=1792875921; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=E2w+v6VTOfFscSyBhyB3vO7STl8TgCqdyv6t5/3oCTY=;
        b=M23F6QbfqBVXu8ZNx6wUUBb0NIQDs+ny89ey/7/BK/LaB3oaw1aOR6gABPLvs8rYLc
         EWCiMamx5IVvwzBaHi9MVSfv5T1ZCIfeNiE7sA5QbaM2cuVP/SHYqLvTPtHgJR0ZDmfi
         kEboKpNSSrSeL6gVgg2tT8IqZmqU2+ZmLKAfUm/yEn72727H4kEnOuZEeotrprjTt1Ub
         75uM+Letz1q7lcU8UT4R1zbctu9JY0iO6fioZpOdPOy21ZiWta4HBMN2JXxQ3sLSslGV
         8xHk6OlB9nqvKnMMH7rqaGUdaDsMVJXiM2PaIUekt3lQvVLXr0aggP6K+BGRzkur5IjM
         wcCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792271121; x=1792875921;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E2w+v6VTOfFscSyBhyB3vO7STl8TgCqdyv6t5/3oCTY=;
        b=qaotjzmlm//oXe4CrcrFB7903TWVa/ML4L6k8pK0tTdhx2GBPPX+vYADovBGGfZA1B
         SjAkxu/bG8J92hJJV9/aqrDqKQZmyZ1qdf3j51PdciDSOH5dgm4LBxohINAecs/gxVJQ
         b9WXfd++X5cTNDYKsDk5EQiehZDMeWha0izuLalyd714Gs9Tlcwr0UhHQIY1RhuRarMl
         BAnnXhpxQVFrKPdoQaVuDr26LLxT0JhzZrIyeFkr5m9yKQpm+rApWTmO5W46FwR0NyzR
         BdEbFst16nKr5NJn02jWtmeuGUTEmaCGdl/I5wQsSDJJxWrsrm+6EYK1BtuM90h7BURU
         3zUQ==
X-Forwarded-Encrypted: i=1; AKwUvBy7w9iuWl1vBODFloiUISqJtx2mnlUXaOdVpBo3TGCXGyoSl4BGnbCbFhw+/GGiG2TfFUxNu5E/j41BE+U=@vger.kernel.org
X-Gm-Message-State: AFq9FYKCI2x/WTSMSJ8KvuRcHSCHgM/V/9Q4ajM5YYoqQOvjO2D2e+Pl
	MdFtk7PtQvxsSIVe3Y41xta4h+u3GVAhBMt65BHKgvq5pDhEXgKDGkE2
X-Gm-Gg: AYBFou23TGmpLtnLu3wzsbQ28WiOT01IcVi5M5E2MDfspe1xv12tqt4xeAtHm2zSQTW
	yTauyU3y3UW20vNbEwmV0qgm2pyLjkKF+Z9VcE0nWb8Q9YPqvzFiL0S1lb8i9pzbWkO1RGfzsE4
	cl7MpcoLQ8wcp7rGECC8RpKERkpLdyw12h8AIts6a3Pi4WTmjHTHTFjJNQeA0oGXgWCEXt3+sTV
	OqEnFY2AJu7Aqche6ARuD/67Njc/1/qkhVTipiFqVi+7Z6ygqcP/01q7hNxigq9rzrvDwGiQQtF
	cfdgicqcC/Mpd+io6Eo5YYfiTYRk3p5M5uJP+s0jR5agyQ/yVfIxC18o1pu+IHaAgrFmJgL12JB
	EmMUeh4osalgcLUxr6cqXWe9DuiNKc3YvDpx2nWjTxmrEwaywN805YI39qxk/0i8ovRot2ABjZE
	nM4QCa091Vy4Q8ReQx3OxJEPFlEQawfy/4lZmLSvePNBM9dhxHXhMIYG8Rg/BG0wVeNAodTLHwE
	aa+Fvi2
X-Received: by 2002:a05:600c:8b25:b0:49f:fe39:5bc8 with SMTP id 5b1f17b1804b1-4a1d75f987dmr101048615e9.12.1792271120770;
        Sat, 17 Oct 2026 14:05:20 -0700 (PDT)
Received: from fedora.domain.name ([217.218.152.248])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1cca26dc8sm109085575e9.3.2026.10.17.14.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 14:05:20 -0700 (PDT)
From: m-amirpour <ampr.mhd@gmail.com>
To: keyrings@vger.kernel.org
Cc: dhowells@redhat.com,
	lukas@wunner.de,
	ignat@linux.win,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
Subject: [PATCH] crypto: asymmetric_keys: Fix PKCS#7 selftest error reporting
Date: Sun, 18 Oct 2026 00:35:13 +0330
Message-ID: <20261017210513.135540-1-ampr.mhd@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>

pkcs7_parse_message() returns an error pointer on failure, but the
selftest prints ret, which still contains the result of the previous
x509_load_certificate_list() call.

Print the parser's error pointer with %pe so that a failure reports
the actual parsing error.

Signed-off-by: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
---
 crypto/asymmetric_keys/selftest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/selftest.c b/crypto/asymmetric_keys/selftest.c
index 98dc5cdfdeb..42857b02258 100644
--- a/crypto/asymmetric_keys/selftest.c
+++ b/crypto/asymmetric_keys/selftest.c
@@ -41,7 +41,7 @@ void fips_signature_selftest(const char *name,
 
 	pkcs7 = pkcs7_parse_message(sig, sig_len);
 	if (IS_ERR(pkcs7))
-		panic("Certs %s selftest: pkcs7_parse_message() = %d\n", name, ret);
+		panic("Certs %s selftest: pkcs7_parse_message() = %pe\n", name, pkcs7);
 
 	pkcs7_supply_detached_data(pkcs7, data, data_len);
 
-- 
2.55.0

