Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75F24E8DF0
	for <linux-crypto@vger.kernel.org>; Thu,  3 Sep 2026 15:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788450156; cv=none; b=nM8qIJ2zqYXQ7x5bTuM1UFcLXednLqIw8bpwESsmZhuI2raI4A+r2dYbL/Sh/acSbzq4twHfvz6+zRA3qDcj+H8JmkVcTBH4Y7vlA8/tRmVVIvFeJirJgv3BKTeqS38wr6boS6MS8CYu0cfco2TMYRUC+Ac0F8sKh+g+Y0JP+0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788450156; c=relaxed/simple;
	bh=0u3bQpID8XF5Xd7byfgyuw/sWWIFCdViA9EFp8ten4I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nX/QztT/kgMmNaXfhD07swKIfrga1JwPYIzwnt08FmwfaAFFuWtkfwTHGMGUL5sHPgcDJpXRTcIHEeYpFZP23WcrRESJOrPBJW2rLnPhqAd8TFbcYTB+7vnL1oB1led3BkbIUwJaRebs5QNueCFa+HIEPJsJBwdinURpUbS01JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk; spf=pass smtp.mailfrom=thegoodpenguin.co.uk; dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b=tpf1Z/zQ; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b="tpf1Z/zQ"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-39266382df6so2311087a91.3
        for <linux-crypto@vger.kernel.org>; Thu, 03 Sep 2026 08:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thegoodpenguin-co-uk.20251104.gappssmtp.com; s=20251104; t=1788450154; x=1789054954; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OcSaUt4sBLjkqn1EaPdckYXaoX+i2p2j2WYzYCHWwnE=;
        b=tpf1Z/zQAydcepppjyOyfPnTYrwPA2KRzUetih2E4HxUxazIoJBN9WR9v27AL7Hp86
         TCQ5fjGM1Tzhb4t0iliAgNZp0qDdGEVKZ3aPiuqVIGCTnCymqUGZfbZxrpjD7TtdbUxw
         bZHgaoDsD/ifZN54fYKLoZtjd+Gqt1OUJpY1vEVMtShDkeFE5aa5bc6WJalHsa3k8OKH
         LI84CamTpo81s9sw685rJ7tooLGLsUfuMqXVXAAzTJG5+ecmVqILhbae5cFq10qpBss5
         n+dlAaCj9Pudmj7JyV97oqkEsfOIc1stSGX6nauhpFZjOyrxOHWZHCt54lPBDMtCxZ3x
         Ypfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788450154; x=1789054954;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OcSaUt4sBLjkqn1EaPdckYXaoX+i2p2j2WYzYCHWwnE=;
        b=FcJ54myu1dKkWgDdC+3OxVE846EDYnhIc/wn597Vs8x7q6Wzr7xT8cXg1VMdz5JgId
         pXBf2fhl0uMQ0wBS88HlbbyiZfNzAj+l804WGLE2ubBWFmY43eVTntDQz1r+YJf1DwPG
         g70c78aTB62/sJ4U5YbVdJV/BMA2hCh/yM/CWgqzHOHA+WhnGHsL4BIYqlz9oW6S96kf
         ateKUMybj4eszDZaP46EpK7gUPtOp+nEMYgB+gYzyrzclsMIxQQJLEUDbD75yozUlish
         tyoySe7zFxIEey5Kq7m4YOYCVv5IoI5mGyH5aFu4DkPsUQXSp1fRv5IY+K40nvLhUcBg
         2rZg==
X-Gm-Message-State: AFuF++lvhTQG3qqwqHTLD4wvvMOMinsMOoKg2MatpUkiwiL5J34PPoYw
	mjmWBcTqbA+8UfoR0DZRL8NqmAFp3AxohR+xSaEMzyKL5gKLaQo0GzDTANoiKUeFkEE=
X-Gm-Gg: AYBFou3Z2bZwvpGYAhCZcHkpzzikBfnaH2n1hNpvV2e83b5QMi5M2QRg9BqDmISfCKq
	kaT6Xj6QDALNifxGoh8h9wR+C0+54LQRLNVQQzMsEyoel+n/ANCZ5cYOwhLod/hhtm7gIh5vWE3
	rJQ2b5S+LKPYZRCR3FTJS3C46fsdq01FlFzUJYzyoLR5/tHj2/YRpKpCV2AYxdvZ1HtuMUQb7nl
	D7C2UFnRfOyEGgYvKR7oYc4RA+xExoeObFNeUh6pt6Jv4Vl+LYmQEE5te6twNbrG83m1PSxHCn5
	AQDR5Ho4zWeqerGz9C8UyrmF9e9r5FTRqX/q6GctWwGNtaFIz8kSITqDCis8IqYKgvKaxrIeZX2
	gx97KlYxdLRXbtf0Sq2XmWiCQljSqprLOpWS+/mZ83IIb7Eb7iLRkoDQGbgEOAfhAFlCz63ao51
	tnOZ/Y2La4d4JVn/G7u2mVbD42crKR8xf72FM3QZnGTACEdlx4QglYOqI3gNW7Mg4Z6ruMW6qSh
	3vrXw==
X-Received: by 2002:a17:90b:3907:b0:381:11eb:d78e with SMTP id 98e67ed59e1d1-39aee066e04mr17608062a91.14.1788450154191;
        Thu, 03 Sep 2026 08:42:34 -0700 (PDT)
Received: from [10.42.0.1] ([2a00:23c7:1d1a:9c01:521a:d95c:2f1e:64be])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14324356931sm522926c88.4.2026.09.03.08.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 08:42:33 -0700 (PDT)
From: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
Date: Thu, 03 Sep 2026 16:42:16 +0100
Subject: [PATCH 1/2] crypto: ccp: use named initializers for acpi_device_id
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260903-acpi-crypto-v1-1-253cc6fd9836@thegoodpenguin.co.uk>
References: <20260903-acpi-crypto-v1-0-253cc6fd9836@thegoodpenguin.co.uk>
In-Reply-To: <20260903-acpi-crypto-v1-0-253cc6fd9836@thegoodpenguin.co.uk>
To: Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788450148; l=1020;
 i=pzalewski@thegoodpenguin.co.uk; s=20260430; h=from:subject:message-id;
 bh=0u3bQpID8XF5Xd7byfgyuw/sWWIFCdViA9EFp8ten4I=;
 b=Ygev+/OVqb3bE35rm1fgtn5Dq1qalxblQ/0hy0EuzJw+1R/nn0DzqILE779pj2vjdV3/xlphH
 PBlnQaqsXOiC1nLxVgBHtuywLdA6xYLJgmOuLaQ0bUCRL+nd4B3KrLw
X-Developer-Key: i=pzalewski@thegoodpenguin.co.uk; a=ed25519;
 pk=vHq4n9IonORH2GTzLv8r6CWAFHzgfBuNkQPXA8NSly0=

Use a named initializer for the acpi_device_id fields which
makes the code more readable and consistent with how lists
are initialized in the rest of the kernel code base.

While we are at it - unify the list terminator to have
a single space between the brackets and no trailing
comma.

Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>
---
 drivers/crypto/ccp/sp-platform.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/sp-platform.c b/drivers/crypto/ccp/sp-platform.c
index 3f9843fa77827..c7ac840cbe136 100644
--- a/drivers/crypto/ccp/sp-platform.c
+++ b/drivers/crypto/ccp/sp-platform.c
@@ -40,8 +40,8 @@ static const struct sp_dev_vdata dev_vdata[] = {
 };
 
 static const struct acpi_device_id sp_acpi_match[] = {
-	{ "AMDI0C00", (kernel_ulong_t)&dev_vdata[0] },
-	{ },
+	{ .id = "AMDI0C00", .driver_data = (kernel_ulong_t)&dev_vdata[0] },
+	{ }
 };
 MODULE_DEVICE_TABLE(acpi, sp_acpi_match);
 

-- 
2.43.0

