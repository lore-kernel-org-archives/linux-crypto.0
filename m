Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780911;
	b=MFCCk5h3QbId1Rt4GyNCEeA7L6ZY/AOH8yUJChFBzOhN5XKV4xaAhk5y4SAJ1vxZjNTx
	 9v2NZXVoplZ1HDZ5LKCVmUjx7R93OrTV9qMN41cU5+K1apn2zS/va4rYXGLgz6s1notOg
	 GahufdVHKnN53h4u1SDXn7S2EWUmqb42zGAW0ss5vb9p/ZLLuSr9UccrILFX3I4Xke5qE
	 a6Hw9Zm7U8Ks9xOmnyyQcbsmHVCGXCpJ6VQKvVGwMHlBA5+uWZZK2BesM8TagB7gKfklQ
	 xLXlmBl7JlvbCbvVcgs0NvRJZzyL1VqOSV86H9662eMF/JH8MOqAL5GvEjqaVJqc1IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780911;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MZ3xsoglCFbUSUZhb0QwwHkubepyifev4aez9qIahDI=;
	b=s7hqEskZNRLm7IsnXV43hskLjoYZZt6a3qw/F4mc5lfL3WSUX79WWxNC89ycjB/AMoxP
	 V+pusBCGR8/NJOBXPmkOgI6IQjsC0rfye9+8cx/yFxb4psl4JBzgtZ1aYpJkLH4kZ/Nxz
	 nOeememvnr3kTCOkf0kELsv3XJOq4WClqgltjii/ToPPny7R0BgRNAtyvId51sFJyCt/N
	 pyy8pUTesSVWWz5vrQmhFgCEANn6LxmVxh7m0yR4/SAIT+NZVmwHiGndtcGueroMBY1vU
	 Ayhpy0s1QrddSJe3z703rm3Ym4iBFcrZcq53Emm1KMsmpL9CdJb1teltqMZm90ETtLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jOOiZExH;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C60606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:01:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14C60606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jOOiZExH
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4ac95761c85so62459775e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:01:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780909; x=1796385709; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MZ3xsoglCFbUSUZhb0QwwHkubepyifev4aez9qIahDI=;
        b=jOOiZExHbjznA/ln2UnOPrG76s5InV93s3oDYf745lKBTCT4nvUENnUqLIWgIxddca
         A+xR/kiaWkkgcz9R9wjf2c2jK5P4CQRYe5RFSn5mD4TlSEO3XH1Yo3g3+b7G4n5AOMlx
         +DckmDpgH3YbPGxSdQNUvrzrR3OkrhamVDh5j+K/GyTOQMJAJ9EL94pGjoId8fHoKyzI
         1j5ofmLU37Ha0mfDuVtnoCP5a8/PHwsGOSxea/BS7wPxAdVeNzTVDe3k59NrPaN3kZzR
         aZd1SEpYOr5AXU+HqeoL3TU8R/ICnDm73dPmQDxaPm9ohxrCZ7H9LKa7r7pzTYJqyYpC
         /pAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780909; x=1796385709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MZ3xsoglCFbUSUZhb0QwwHkubepyifev4aez9qIahDI=;
        b=k5lh5PvWXPCk6gJ3/UXa9nox4Yuwjn7vWJBzFZtZnvK60AjzB1IWG+ultx9HmQqGEC
         QZFB27HxNu7yn5x15GG9QJTIGrBX2riFH37vd7bf2ADFiG2b7FSeHW7p83dg+uJwV9So
         z/2Kj70bBETkrOZ63GF7FWN1IdmQ/+Pr/LQLtObrArSQNyiOvuVIstf584EKOa7QC8aI
         1pI8/wEsljVUymbcMrHvmfMGHyJ79211uxQPyfNHkVPCuWQJJYaU+FukpmOwRPSkRsBr
         8cAd4lEdIy8uUC5jEo/DQ/pRLkZSziwCqjyUWGMwsqNgS/CMYyT23gSkHkhYNsoDi0bz
         evig==
X-Gm-Message-State: APuU4Z8rYI9jxZHlScOFIWg6qDD0p0n9HOT/wTPQfevVBhaay3I5mX1I
	vqsJ67SI2MFHN87Gw7wg2ScUqMPndFo1sKgKC5dyqrW6LeLJnUsgqoE8
X-Gm-Gg: AZFdTZeNPSXuIVJDGtkMGO0BsfeWlbdPEBd0HnPiTRqvLdQA9lablO5h9tctHc8/0UP
	gd5jhPVxQjXvcQwKaGfPZi+6fIh1/wIpHj6cPmtjrSJdIcQqceJGSceMK+jHIOSTjxAfA/pxoR5
	cg+vIOfcdsbDUYsbeXjRdj4K0n/1qDmF+jtLjuZPi78XJQhG5rbo+xd3dtOtOuH8HcVTNHlWQ6h
	UdIMZ84y4gnJyOCVzl1/Ypu5oZ8IAiBudLbx0vphYaW6B3CQBsVf7FSt9yZvHINzO6S1oPQ6Llx
	U1pu1Vfk3zKYerrC0E4f7S10SAgnT0fdvHm4mhfPRQ6EbXnDUqJdMZv+ZEoO6dTq8+9ctoAlVgt
	+ofHMSH6rcPIuMNdWoDk0pOPMM+uGPTqI1w4eHuXXXtLU5cbvRZ1zw2WpyfBo6ycEKN0M6Dd+1Y
	3c2LlNirhruypR7tJGkG9KaBcq0xlnlruuGqayTGRnilIa/P8c/ojvPHmvCToOavIFS0muPhu6G
	Xco+h6t20hTNwPZA1IDa6iN8tUgc7genBkUjSQDCGG0cLO+iJ2/xhW5JZsQ0YLbXLX41qEhSyMP
	Ya4W/0xa/nCcGWuf9K60kFVK+XwEyOc9Ko1bqPIXq803Pno=
X-Received: by 2002:a05:600d:18:b0:4bb:9001:1aa with SMTP id 5b1f17b1804b1-4bb900102b8mr353975225e9.10.1795780901984;
        Fri, 27 Nov 2026 04:01:41 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:01:41 -0800 (PST)
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
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v14 16/30] crypto: amlogic - Add support for AXG-series
Date: Fri, 27 Nov 2026 13:00:49 +0100
Message-ID: <20261127120103.1532882-17-jnieto.alaber@gmail.com>
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

From: Alexey Romanov <romanov.alexey2000@gmail.com>

Tested via tcrypt module and with custom tests.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 0fb0da20e06b..08d89db14788 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -290,6 +290,14 @@ static const struct meson_pdata meson_g12a_pdata = {
 	.support_192bit_key = false,
 };
 
+static const struct meson_pdata meson_axg_pdata = {
+	.descs_reg = 0x0,
+	.status_reg = 0x8,
+	.setup_desc_cnt = 3,
+	.hasher_supported = true,
+	.support_192bit_key = true,
+};
+
 static const struct of_device_id meson_crypto_of_match_table[] = {
 	{
 		.compatible = "amlogic,gxl-crypto",
@@ -299,6 +307,10 @@ static const struct of_device_id meson_crypto_of_match_table[] = {
 		.compatible = "amlogic,g12a-crypto",
 		.data = &meson_g12a_pdata,
 	},
+	{
+		.compatible = "amlogic,axg-crypto",
+		.data = &meson_axg_pdata,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, meson_crypto_of_match_table);
-- 
2.47.3

