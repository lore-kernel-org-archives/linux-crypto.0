Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780913;
	b=dukgINXyJamiR3oUXT1xKd1gA1gYW9b/LIFL/Hd6BBJ4I42ae6BRMcCfIyXtu100+gpC
	 68SUxGOoPEjXVzgsNV8GqXExSYGHRCLDs8d514B0sSEEgkasaGtIrVnkcL48J4IUZRgIE
	 2PvUzc1IF1VvMiIsdxUkTU/lSJVyQlsjtbyuYbF7GWVIgXE9DLSzHZ/a2sIAX81hXiVjz
	 e9H+pCDo/9vXUOZRFiH3v7L0qGMCuXagwdENqy2Zq/j/25gxf+IJNrYhZ9qT9UjMRjJHp
	 tF8gdnHRUUIPze9I/E8Y9n5B8ujXPxwdKqdVFbOTfrS7H+KuLCIJtZ4IypkX2iXo9KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780913;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JDAQR0t8kY5iGUVaxptzIa8OAS8vI1YyQp0Tt2BgYTk=;
	b=L+eLakBLnmYaqHUZYCD7RcAqp5IaVwXeSpYNyNhF3cjovVyF0RWfJ0EWE9U2UYx/a0eO
	 h5UfcEARq5azmc5PMXfUebwkH89gJS45+DQW5I61W7k4v5T+1IbYwDFCY8B3qTUKsQu/X
	 7+8CAjB5G9qjl2SPct2ir7Ulmu9TqTO23Dm7egIUfIjhWAgsFI83S6J1++RCnpva3jaTx
	 /QB6gn8EGaYmCh1N/67PptG4e2ycTNHWxpXYEjOCMU2KEM1oCuXoiWqXygepWSB+bgFv2
	 EbJA8Ks20RaD8TBm8G9hjdKhdNlUkquDe1fJrW5X00B+CM2BjT0Jzqj9dYmhROQQ0rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="MhU/aln5";
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90311606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:01:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90311606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MhU/aln5
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4bb5b8ef642so69871175e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780912; x=1796385712; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JDAQR0t8kY5iGUVaxptzIa8OAS8vI1YyQp0Tt2BgYTk=;
        b=MhU/aln5bkzzPoOpWT6PO2DzPhAB/DGmijpQK1gmrUbqek6TRSglVXYCUNFvPAA9s3
         70+G04C+G2VoY4Aj4xngUOwDSuaWWfd/awcP5TWH1/R/XhEbnVXXd130Elltwudl2SmE
         /52XFo7gkw0NBtYUvgjgeMaB7LlKNzTIWgsd0F4y1rVF+V/Ne4v4ybtuZalv9SnE3qgE
         OUH+6YvqL8bfaIplc45veKr/NkPktYwrBFF45aWjzfRtXGB+ObwLIBOz3GhDnOHdUxOn
         OhJtKsVNLdBTgUWNqghWfsxY2R1wV7mqBbQJTezCjlNmLCZsqG6rJ6g/5wHI3AxxI6eN
         IeiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780912; x=1796385712;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JDAQR0t8kY5iGUVaxptzIa8OAS8vI1YyQp0Tt2BgYTk=;
        b=eCfZxxIyerDhsavJ2WQNcgxeGShbvW5SoRMf6Nn2Ib15mB3FjKnBOZx/5G6LcVS6Hv
         ugily1orsCoJI0t2C5nVdpAbdZ7Snlt8cmPnCDVfBqy5pErzQJEpTEOdH6iI22g27ne8
         mHqZZIA4yNKIaK5FdHywOmiA/Rbiu92MXQ4e1Wpm6qsoEBhtbTnSz+5Bha1HQatzOmPn
         MuYmdCA1OYx84rdh2HFBhepqxyE/FKwdH+aVai40ufWXpkXWhJKt01naBd0tcM82eXEs
         7InQXWnAX3l196zlrzJI9enekXU2W4b4HOZItIXSZDNT2r9wYNv8OSi76jHJ2Wi48q8A
         yydw==
X-Gm-Message-State: APuU4Z853QoRuTquQ6xoKRHLQnNyK/jkg8wrK9vQtpmy+571TTl3jeSD
	Reao2MGZW5KTxf7wacii4GL7L/MtSqqQqKYaSqp12p9ntawi539VAey5tJVeh79R0sA=
X-Gm-Gg: AZFdTZflPFcFmQ9ko9Yki6Lo7681/Jp0q8a/VjKAH4lI1AYSDnfaOKIH6iwcNv9IvZ8
	SI25eUbd3s0z7IE2L8VBsTws23lsG0qbuceie7c5Ve7MDLzLIXZNagcRSjf1aho2jyyZaWyEGxv
	1dHJ2H7bGBbmNfmr0iLjrWRXxWDDyzKZuB2jxtUhs9EaLjpFPQ5372/FCWwqiu9s8hXlRCrNFFw
	yD+UwZSV22VBnimywCrz9JFSw8vfLj7w3GeaFqx00n8YVOT7/RLLa5sWljSObHCIK6C1CZybMl4
	pJjeXkz52xydURXtv0qfrskh4ePGl6vJTb5UTrgMog6Ju75uuiPMwxe+a3ol0odlBk83h7Ybium
	UWfUKgdgZ2pOmL/1CIq6xj/DjlWiWd8A28QtFZQzA364G2Q3aO8WDY75jUZX5UmTqXjg2gBECXm
	/fTFkyuNoT5itd0EOK6Lo31hMRJansZQM+Yg+cI9NIaeZ7r5Z7NfRVDglLrLi55OCURhRybtNdl
	eSFT5ljQyvJT02pO6wWeFHghAS7firsjOZtkR+Qu7wmEbgRdbd5YIaQLc+he/VfFVOZpuecauHY
	5MHSVVRPRBJ9ldZ9pcLsXj11ffhBSKuckQOaQKNKLdK4ve8=
X-Received: by 2002:a05:600c:5303:b0:4a2:1a:a11d with SMTP id 5b1f17b1804b1-4bb88785d24mr475302715e9.0.1795780910582;
        Fri, 27 Nov 2026 04:01:50 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:01:50 -0800 (PST)
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
Subject: [PATCH v14 17/30] crypto: amlogic - Add support for A1-series
Date: Fri, 27 Nov 2026 13:00:50 +0100
Message-ID: <20261127120103.1532882-18-jnieto.alaber@gmail.com>
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

This platform data also can be used for S4 as fallback.
Tested via tcrypt module and with custom tests.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 08d89db14788..3a6bac10bb04 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -298,6 +298,14 @@ static const struct meson_pdata meson_axg_pdata = {
 	.support_192bit_key = true,
 };
 
+static const struct meson_pdata meson_a1_pdata = {
+	.descs_reg = 0x0,
+	.status_reg = 0x8,
+	.setup_desc_cnt = 1,
+	.hasher_supported = true,
+	.support_192bit_key = false,
+};
+
 static const struct of_device_id meson_crypto_of_match_table[] = {
 	{
 		.compatible = "amlogic,gxl-crypto",
@@ -311,6 +319,14 @@ static const struct of_device_id meson_crypto_of_match_table[] = {
 		.compatible = "amlogic,axg-crypto",
 		.data = &meson_axg_pdata,
 	},
+	{
+		.compatible = "amlogic,a1-crypto",
+		.data = &meson_a1_pdata,
+	},
+	{
+		.compatible = "amlogic,s4-crypto",
+		.data = &meson_a1_pdata,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, meson_crypto_of_match_table);
-- 
2.47.3

