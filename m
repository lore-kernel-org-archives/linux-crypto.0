Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CA1282F35
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 00:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785285737; cv=none; b=nz25rNQZYG4gj5Uld2E4fd2OsrZU++cvDHNmp4OQMvC2dPQNgnJkL4AhjM9JzgDYTLA7dWSGAb5jLPExH3D2/g0GGBLN0PNVMcABD6QBpkjbiwdfTWtybmjevE0k8F95P7dFtx1XOlpOMCebNcDKK4txQ/avTEew4ArEVRdBI04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785285737; c=relaxed/simple;
	bh=o+7v+TEu5ghY+2FA5SCYrCH2NtB/YDNwhFxthLjJVp4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iPF57DzhfpyhixljBA2NXQGGJBe6GUyeP8UdncsoG5seg0ToY6D80YLc3g7XpKRca/6LJ0vDfhgzqeoM0rMtozpICkdkcsyKur/QJjPeo8xokKeto6x5jFnoy/FkDBStJOePFgG0Unx2UqR+tP2JprPlobBHk4LjvY0h651SV/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=TaKq12a3; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="TaKq12a3"
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 4C6763F677
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 00:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1785285726;
	bh=YP+6wrlQaSGx7RuJqwRMUdE3V+ruvBfPJx2GlyHwNNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=TaKq12a3ytZgp8mS29oMsN1bpwM03uJKFdxMd13xl8nhPO2EBI+dtKWYOfteyuj9r
	 Wh6LVp+HSLMnb098nXyyPCNY4NWjtre317QdrQESKOcYWOg9O2sIZhfV3tBUdIp40q
	 ZXqgjopCEZiExFYs0g43dKm1BYYAGq5RmeMxaEz+gnR8u4+fhHpCmHpuQRGNm/tr9d
	 lA4rGk8pPF4ZePd6jKQ0gYDBJs2d0j1X11jp3dpmMBLKjCmYY2anTbK4KaN3LgjT5c
	 x+5cstfpWoVzyxGweKKwl5VHEq0nN3k3G2ripjVxR3iwHHVMhLwCStda2eEQxFI+8S
	 QQ/jCVeuIiNx0rZX0d98qxkZ5mEhBnTBOlahm84wd3SCejJ+K7L+/x+gdUhuEcLrOb
	 S9zDnmzJ2Fv6YRmV1wRUo++Uo2R5z9yoydYyOsBNPmklPifWWwTWBrzcyjnwT9atg/
	 UmJo1gfLYNSnpB6lZe+RBp5yZUMn4onJXJMw9NRkikd38zdYwsFuNT+5mX2KKC4XZs
	 ukW2IFazRTsgXYsoSuM0Q/pRHXbEBE7kCYLi8u1yzS2BIKMDQ2ngAp6mZsuVndxbl5
	 Li1+0IF5CNznkHnzMlDU13d8FDeoEeEafunrGU03ESFcTF3o7o3/zRsKlRkFBWdILO
	 ksrhE2LoGPfCVImWk7y6DAKA=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d001671a54so9081175ad.2
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 17:42:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785285724; x=1785890524;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YP+6wrlQaSGx7RuJqwRMUdE3V+ruvBfPJx2GlyHwNNQ=;
        b=ri7Z+qnDuu/KpFfOHzfZGStB6aLXKZ7sdLgJYXa4F/gt1iTClp6N8G8vji3FVQEgG2
         OTPBQ9B4r0YUh57NE80bd8RtnrQDiPwsO77dnaDXaapLlV36+lFHT4aH0DuXDXtbEOTG
         kOF3lIlcxzsR7+74+fFuRMWGocWMUQIHCrzAfN3lLpD6N7UPRMFW9jZM1qmotnXaUbRX
         bqAZvELUrXLvt0y/A4Yg9CjbuUEccnVKD78fa7/D9XQ6NwuEBnR8XR6ZbzNmdQcGJ9pQ
         DW62dhMjBwIfJLcakrzB5wvwRkhH8DLu1aW8zTF2GAQxCaC34y1bntOTSkhUau5VmoVo
         TSHw==
X-Forwarded-Encrypted: i=1; AHgh+Ro2t0J7Pi9ypfNRQvOKWjU4WLaHGcpbE3KV8ZqT6bR8Q4/XHq078dC1ogKg6kprbZBFO9Lug2Kr8ymd21c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6Zo1ESQhMF1k2mU0GdKPk6gyUgaOw24cl1k2IN//p25gG7CMv
	7R3xfhrT83eGV2ctdNjhy2KGtMmlf1J9USEJRkcrc0GLXlRrQRKHAFTd0tSbLgBLFKskNXxvkXr
	Bo8ywjv02+iRoXmaqATWiH0lumX3PwrSFpb+AyWVYKEx3aVzMm/EBtlM2e2JxmpqCTUmplY2JjS
	Osbm2UkA==
X-Gm-Gg: AR+sD11HHor3r51Nb5LhYowe0o4/W+8u4t7Baff1+IPeVQRecGDITTn68WQsRvPiT8W
	lPb+HH0KjqFX4THz08W7fTLueV3rhslDZMRLEJIoTlkAJAJ02SdbTg96p6qXgcIB4472V67+ZHh
	RrK3h1YoJCDd3cyH9ITff8kNbPmCPcwRI1qLRMKfwOiY7qFexb84Ttdp79WICk19k1XeySr5B+E
	q10R2Ou2+i9VGUofFRADa2e32sgO3bCVt9ktkGwKbv4LLcy15PXBypNI4QJOO4iHJ9Ln52hf/bA
	Od/uiLXpkCbRu9LJT5sSqpcSB6P4lKbFSaCfll2xpcQN9djy8rXg71j6BS3YxO74p9uywlnOfiC
	K3lOyz8KaRk4=
X-Received: by 2002:a17:903:2a88:b0:2c9:ae0b:61e3 with SMTP id d9443c01a7336-2d015b145bcmr55232565ad.2.1785285724397;
        Tue, 28 Jul 2026 17:42:04 -0700 (PDT)
X-Received: by 2002:a17:903:2a88:b0:2c9:ae0b:61e3 with SMTP id d9443c01a7336-2d015b145bcmr55232355ad.2.1785285724066;
        Tue, 28 Jul 2026 17:42:04 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504b15f77sm3566229eec.4.2026.07.28.17.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 17:42:03 -0700 (PDT)
From: Changwei Zou <changwei.zou@canonical.com>
To: lukas@wunner.de
Cc: Martin.Kepplinger-Novakovic@ginzinger.com,
	changwei.zou@canonical.com,
	davem@davemloft.net,
	herbert@gondor.apana.org.au,
	ignat@linux.win,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	martink@posteo.de
Subject: [PATCH v3] crypto: rsassa-pkcs1 - Align DMA buffer to CRYPTO_DMA_ALIGN
Date: Wed, 29 Jul 2026 10:41:56 +1000
Message-ID: <20260729004156.11925-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

out_buf is used as a DMA buffer for the RSA verification operation.
If out_buf is not aligned to CRYPTO_DMA_ALIGN, cacheline sharing
problems (data corruption) would occur on CPUs with DMA-incoherent caches,
leading to -EKEYREJECTED.

Fix by aligning out_buf to CRYPTO_DMA_ALIGN using PTR_ALIGN(), and
allocating CRYPTO_DMA_ALIGN - 1 extra bytes in the child_req allocation
to accommodate the alignment padding as child_reqsize is a variable.

The intermittent error 'Key was rejected by service' on i.MX8 with CAAM
can be triggered when loading signed kernel modules.

    for i in $(seq 1 100); do
        sudo modprobe xfs 2>&1 && echo "SUCCESS on attempt $i" \
        && sudo rmmod xfs || echo "FAILED on attempt $i"
    done

Fixes: 8552cb04e083 ("crypto: rsassa-pkcs1 - Copy source data for SG list")
Signed-off-by: Changwei Zou <changwei.zou@canonical.com>
---
 crypto/rsassa-pkcs1.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/crypto/rsassa-pkcs1.c b/crypto/rsassa-pkcs1.c
index 94fa5e9600e7..c683f3c61528 100644
--- a/crypto/rsassa-pkcs1.c
+++ b/crypto/rsassa-pkcs1.c
@@ -237,12 +237,13 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
 		return -EINVAL;
 
 	/* RFC 8017 sec 8.2.2 step 2 - RSA verification */
-	child_req = kmalloc(sizeof(*child_req) + child_reqsize + ctx->key_size,
-			    GFP_KERNEL);
+	child_req = kmalloc(sizeof(*child_req) + child_reqsize +
+			    ctx->key_size + CRYPTO_DMA_ALIGN - 1, GFP_KERNEL);
 	if (!child_req)
 		return -ENOMEM;
 
-	out_buf = (u8 *)(child_req + 1) + child_reqsize;
+	out_buf = PTR_ALIGN((u8 *)(child_req + 1) + child_reqsize,
+			    CRYPTO_DMA_ALIGN);
 	memcpy(out_buf, src, slen);
 
 	crypto_init_wait(&cwait);
-- 
2.43.0

