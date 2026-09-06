Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CD92E2EEE
	for <linux-crypto@vger.kernel.org>; Sun,  6 Sep 2026 11:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788694601; cv=none; b=qoc3lXMwZ83nYwzQ40R0cSILuACNSmvxyhdao3PAwwdtZ/cXAz+s7mqCOVS1SfkvjcGTZZIsct8/2j0wC6+u9LlNGovsHdDuxCMBVGq37bJoe6pTU3IDop+THO1RqjZri5QFMPnBZ0msU7JtXA9IKHRQumtlnZhvp8/rkCX5Shg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788694601; c=relaxed/simple;
	bh=9gvB04MxIiwrQ9XTuBbeFvdqXHt16ifuiDB+zqFKGpo=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:Date:Message-ID; b=Dhtq+9cxYThpNV9cSRr2OVROvXCwgNWe3DYOmyjkvCtA+b6DMPaSWkWOadM9DZyYnkJHmmnx9McZtgQCuAY8yg6IrtLVPzlOocNdL2kYc7CnmJeiQqW7ZDQ0LP2vkpTlQw7YOeIWY3WYNh6pSyjNzho3Wdq50rTcbzrFgKYhFSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fNIRuKjG; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fNIRuKjG"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cfbbdfa60bso22634345ad.3
        for <linux-crypto@vger.kernel.org>; Sun, 06 Sep 2026 04:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788694600; x=1789299400; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:content-transfer-encoding
         :mime-version:content-type:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=9gvB04MxIiwrQ9XTuBbeFvdqXHt16ifuiDB+zqFKGpo=;
        b=fNIRuKjGZWKuRFj78RfNV3NNX15yKGR/Vi3SKm50iKAJgp+NVhv2rdQM6WAkmf+J0z
         yqFBJaVDkLUSVLN/7KNSa4psGLXOsVzSHFuhWHmCF2iNAzAV2AhWVqBF422Dn9oabbwm
         If1b3elCJTbVClHiaMleN6WQESskDjkIfOim7DOF5ZlzJIH3URdhEc0v2GeBVpP6u0rs
         cGM5UXJr6sX68Ux1GXXzCCcfVhBAsEEiL5b5URYI9OP5VBCoYeYl1OFcB2Xl05oQeG8M
         AXl5RMvl8znQ2h4HMrh6U2Hz3I/+j/zrg82CpzA7bO3y5/QzGbVSAhwGTAkXzXCfo2Hi
         BTNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788694600; x=1789299400;
        h=message-id:date:subject:cc:to:from:content-transfer-encoding
         :mime-version:content-type:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9gvB04MxIiwrQ9XTuBbeFvdqXHt16ifuiDB+zqFKGpo=;
        b=CLgwOLA6qjvzJGbYuK76l4Vxe7WNQTtGIH+dN/4+f2WnHpou/hVUhlMEpEN/HcDXqt
         tzuimDUcS3JMpoCo3msC3yTNo1gYqR5MOaVH3IGcS6rzkMmk8J8/gYMtn0i4q66blV4u
         Gj5lJWX0/e49OTQYQGAWSyI/UErd1osvfjpkGAfdHwWXo9BTQ7UzWYvMDCZYuT+4MNw0
         oojj4qWPJTcrNOUGrHmZoSDo2zR0Jez3zr0DWqqY4AHoM9sZPQQ8VYnm3aFrju3QfApC
         p69L0lVihomgPQHO5hEA9iOo0omsGS/ipIKgstU+PUMqk1vAdmSkGsz5dKpCv2Hki9GT
         7w7g==
X-Forwarded-Encrypted: i=1; AKwUvBzewv8tBnXT3oZ7cskvwdNVYQ4EVcRYV5eczGrdQXxm8CQ/bFftoM0Sa8fgvxLEbaZIipyz55nX0DNNsqM=@vger.kernel.org
X-Gm-Message-State: AFuF++n1TlXOZ98uTWrxtghNi7v0cGBeXosJm2l8pKOM8rNkuiyGBwa1
	2jmGVGMlwtPSDSr8Vkq1nKxe/Z7hdA8gRfmx9QMpDI50Qw62Uc4YyOBd
X-Gm-Gg: AYBFou2GkNrU1f2cicN7zEKc7QDGSqkSkJLNztuKhnkzOxt32nMarQW1FsCXNvpCNHL
	nzVuj20tZG0A4MxMKXJWlNhmYu7pGZcHIJkf67oEMug7dJ6afrymXrgFq56oP1m9DBGaHoY89+r
	sIwIhjZ75cAqLTE65UfrKaI9zAawn2ypC1UGzl9Ve+QOo0y7l3XxIGpkwzxUac8lLzWPfXf40U9
	KAfkHK6y0nc1nhHrfgmmKjrjkDJgQVWP82CoXcYXHmSktE3IUi7KNDbRwuSVWYwWUCm21q3auTr
	bqhj9+hHGxT9r7OrSLEjnr+KIDUpx2v1MIrbZwNJPoxhDz6cA9i2Uho5KUTAhXj2DLqQqP9iJSk
	ChTQkVdfiHLw+mzi6WgF3WlACJvht2hOYxR0x/D4jHrnG42Q1fWzZUG5funFflMYw+N+ERRVw6b
	EhQiRIGTmsJS9gjuJwniYKz2iQU5ZUMM76z9wJhOmfkiLO/i5mNYnWVw==
X-Received: by 2002:a17:902:ce89:b0:2da:e967:7953 with SMTP id d9443c01a7336-2db125f1626mr232203485ad.12.1788694599751;
        Sun, 06 Sep 2026 04:36:39 -0700 (PDT)
Received: from [127.0.0.1] ([115.190.67.8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db2c60f687sm18118415ad.58.2026.09.06.04.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 04:36:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
From: Ma Yukun <0x4fe6@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Martin Kaiser <martin@kaiser.cx>, linux-crypto@vger.kernel.org
Subject: [PATCH] hwrng: imx-rngc - check return value of clk_prepare_enable()
Date: Sun, 06 Sep 2026 19:36:33 +0800
Message-ID: <178869459340.2131.17730179758509117031@gmail.com>

Y2xrX3ByZXBhcmVfZW5hYmxlKCkgY2FuIGZhaWwgaGVyZSBhbmQgaXRzIHJldHVybiB2YWx1ZSBp
cyBjdXJyZW50bHkKaWdub3JlZC4gSWYgdGhlIGNsb2NrIGZhaWxzIHRvIGVuYWJsZSwgdGhlIHBy
b2JlIGNvbnRpbnVlcyB0byByZWFkCmZyb20gdGhlIGhhcmR3YXJlIHJlZ2lzdGVycyB3aXRob3V0
IGEgY2xvY2ssIHdoaWNoIGNhbiBjYXVzZSBhIGJ1cwpoYW5nIG9yIGV4dGVybmFsIGFib3J0LgoK
Q2hlY2sgdGhlIHJldHVybiB2YWx1ZSBhbmQgZmFpbCBwcm9iZSBpZiB0aGUgY2xvY2sgY2Fubm90
IGJlIGVuYWJsZWQuCgpGaXhlczogMWQ1NDQ5NDQ1YmQwICgiaHdybmc6IG14LXJuZ2MgLSBhZGQg
YSBkcml2ZXIgZm9yIEZyZWVzY2FsZSBSTkdDIikKU2lnbmVkLW9mZi1ieTogTWEgWXVrdW4gPDB4
NGZlNkBnbWFpbC5jb20+Ci0tLQogZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9pbXgtcm5nYy5jIHwg
NCArKystCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9jaGFyL2h3X3JhbmRvbS9pbXgtcm5nYy5jIGIvZHJpdmVycy9j
aGFyL2h3X3JhbmRvbS9pbXgtcm5nYy5jCmluZGV4IDc2OTMzMjhmMS4uNThiZGM3YTZiIDEwMDY0
NAotLS0gYS9kcml2ZXJzL2NoYXIvaHdfcmFuZG9tL2lteC1ybmdjLmMKKysrIGIvZHJpdmVycy9j
aGFyL2h3X3JhbmRvbS9pbXgtcm5nYy5jCkBAIC0yNjYsNyArMjY2LDkgQEAgc3RhdGljIGludCBf
X2luaXQgaW14X3JuZ2NfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikKIAlpZiAo
aXJxIDwgMCkKIAkJcmV0dXJuIGlycTsKIAotCWNsa19wcmVwYXJlX2VuYWJsZShybmdjLT5jbGsp
OworCXJldCA9IGNsa19wcmVwYXJlX2VuYWJsZShybmdjLT5jbGspOworCWlmIChyZXQpCisJCXJl
dHVybiByZXQ7CiAKIAl2ZXJfaWQgPSByZWFkbChybmdjLT5iYXNlICsgUk5HQ19WRVJfSUQpOwot
LSAKMi40My4wCg==
