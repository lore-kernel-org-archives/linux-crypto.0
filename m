Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A63234FF67
	for <linux-crypto@vger.kernel.org>; Thu,  6 Nov 2025 16:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762446736; cv=none; b=S3bB+QENE6GlV5tbH4a6Jz8vddX6H4Fn2LZ36gMXreNCn3f70cvbTcz4KOfXXLBcE51hJZ3UpkPQUZur5v+E2HTNx+i6qF+j7/P+zf23dwoWCDhFp3tbgEquZTHe8xoWO5zYtdrTFM1SkixLCzg/nEJeK/v2nHXPf1cvmCDPx08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762446736; c=relaxed/simple;
	bh=L3Ng/aC4fiC+veLj0saleTuVV2+DCXLKDn5kGqHtuy0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=d1S1+/llXlzFLgWY4hJeIQ0MRHU8sqWXE3OoFKkN+Rklj+hcly8T3jkh1XVFA7k2Zds3E5TtKQYr45xwcqsonQa3M7ySiHQOyjsy6lAeuRSqNCCML9cjZleaMk7jTlWc5zKQrpb3ERiCNKsVumwLIOyabHY0r46iDGSZwNx73Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gG3v6ESQ; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gG3v6ESQ"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-640e970598cso214709a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 08:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762446732; x=1763051532; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X5w8hxKvRTGPo6IVAgTGxIFQbqEmNhRknqABWcJ9Jzg=;
        b=gG3v6ESQVKQiKvJpbiNAO/15hqcosNgMNo/epHDTDAc7jRrAiRC9jHEw07FSrdw7uJ
         yMmFEYj0FmxKqXVGZcvLbhHeH+bgjVo74ef+ZHEiN/Q7bYx/4rMC7JvCgQaOiH2usyfl
         5h8Ahh9kwyCw0se3vf/7zvcnoilb6595AR0VMbr6PL6FcipRX+tA1KNb5sS0B76eiRF+
         lzE8qhFreg9cNR5n40YrMAFATFVNMkRPtGTOGfth9xH8W3h9r/XGds1PKU8rW2gThmhl
         TR256aG8E71CFHg9UEIPGnkHg1Y/ZZtQoDtgcYOYujKTS1RmiKXMn8xZcYmr5I8btTu1
         onow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762446732; x=1763051532;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X5w8hxKvRTGPo6IVAgTGxIFQbqEmNhRknqABWcJ9Jzg=;
        b=tS8pTdXh4aj49gbVCEfXf5fGK3TqcYmz5K4aFnxOOonsUMZjNU38LpNQ9kJmHPvPSa
         aEnvaEtUi8zh2bBgECWTFpgHVEU2x8pbwhZn6ShMoru+jxJu6nEKP3/qCJN1FGCNQEir
         Oy8pYxi9ZPxV7PJEiW+dTheK8E1UspFvNLmpuQ/i7VFG3JyAyTwGS95ApUIZdsgtQ4Hb
         6q9HU9TXzONxTNfxZl1+uHn+oNHVMNX8ZB+PtxBonPs5FZBlw60QvgjJHUaAJK6IODN9
         ZuC22yZf8IH4hQZGbsYpwsiO+p+voR/ILBto120pDEER4ZFYWiwGe22TnKz7QPv8Tp2P
         DtlA==
X-Gm-Message-State: AOJu0YxiG1OtloN5uEqwhgkjFIxL6rvUGJhq6u76kkMzDso5xqXHBskI
	uTlhRFYaYAY1ORV/yj3REkFGn/hYyj0jPx90BudiOoN/SXfSiiGFznrIeymtsegQDNo=
X-Gm-Gg: ASbGnctljzDwFO1qFIOcVXG/cJehbBvIsZgAnKnmKjq9CGit1a+2DXOJd/hAvyIlF9D
	1wIjWG4JkYrQvYJ7sJp/7HtI1XOG/J1CALwlX+2SR159MNr2QIu2iqKSfXJkAPg4JdJDMiPmJh5
	5pk5nTeJWdfun5JYbWJMgprRhVfPpjer02/kCA3p2RY0T5vmyTKmpWi5ddauczT6eR2lFuWwdDy
	1tmCQt76AQrr8E7+StF02yQmAjx4o1d2pwtDF9hqsOheMu1TiIbMzbyEzojabZkcizH6MtEugze
	hrgnZ2hxaZa7C/0BAs2jgGvgO89AYdNYZiAIBKYYNSkSwg2KrvdjXnDRzSxIa/WB32u5b13Pyth
	/89oxTvmNKN/Eg4ALcPtybBAgDJ1jthkr3tHLA8RMq0blpiaEsqPBalJQNKoXiTd14FQX8gvTr6
	r80S+y/XyIcwYfVTOmdUNItfxpp1w=
X-Google-Smtp-Source: AGHT+IE9h1lVDXWHqHj++HSZUT/NFsSiE1jYUZHNmeLSFQNvfG4uP3f+jidAfY0g2Kf4kE3sf0UIzQ==
X-Received: by 2002:a17:906:7312:b0:b72:5d4a:45d4 with SMTP id a640c23a62f3a-b726529529amr440381766b.3.1762446731609;
        Thu, 06 Nov 2025 08:32:11 -0800 (PST)
Received: from [127.0.1.1] ([178.197.219.123])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7289682544sm249625566b.53.2025.11.06.08.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 08:32:11 -0800 (PST)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Thu, 06 Nov 2025 17:31:57 +0100
Subject: [PATCH 5/6] crypto: ccp - Simplify with of_device_get_match_data()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251106-crypto-of-match-v1-5-36b26cd35cff@linaro.org>
References: <20251106-crypto-of-match-v1-0-36b26cd35cff@linaro.org>
In-Reply-To: <20251106-crypto-of-match-v1-0-36b26cd35cff@linaro.org>
To: Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Florian Fainelli <florian.fainelli@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Ray Jui <rjui@broadcom.com>, Scott Branden <sbranden@broadcom.com>, 
 Jesper Nilsson <jesper.nilsson@axis.com>, 
 Lars Persson <lars.persson@axis.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
 Srujana Challa <schalla@marvell.com>, 
 Bharat Bhushan <bbhushan2@marvell.com>
Cc: linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@axis.com, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1468;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=L3Ng/aC4fiC+veLj0saleTuVV2+DCXLKDn5kGqHtuy0=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBpDM1/OKTMp82LpfdWbmimej/PbfwdV/l181iXL
 aSDDQ45vi6JAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCaQzNfwAKCRDBN2bmhouD
 180yD/9YhNT1mZl/Gz0eu9cIi6GLKX/FcdI1PNrXMl8bw7s4vs1hVt9p9r/kUMoST9QyDOIwnYw
 XS+PuirEFbK+HmBlGgfxdA91pX+AGFO+J23YE6atRjfNOAsGSTc2sVRgv6DKDXKeSbqKs/Dm1j4
 ecZuoXXG4FuC1khyhcp8YVQrVNRvseXzEISg7jolnlwq1siSSf0hYONVx6Y8hVU78dn5y7RZJyJ
 E6NgvHZcWxzARm5BDGGMr2wJ8oa4lyyIl2a1xtzArRjQmabZLTEAV9EZ0E28DHRJ13d56NnkYmV
 iNmFJyL5F3U24cBwn0VSm1L8J7VtUXp6zGw3effQ5wk95PP8SSbIDNMOSfjdljfXTEswYxZmWPa
 dfBnAr8LBBy5iIn/QpvVuVIYde3WjRgY/vjxv6YdzZ+fwqlJgu9NSXMB3S8UB+66t8Ll9VhQW/Z
 2HSHHYJwZjmqYy/4D13eV/bLfalQcFfPA5ihUnKCpzSqTNXT0ojLLosi1LNXvjQIllwogaqqvUR
 x9jzgeU6hQiUO4ZPa5e224D8zDWDp3d5QrbMm/B/GDeAmd8NI3xy2yb4wykagxyd31YQ9Xnpzum
 Cd7LO4hFlWXOYgMoFeSFgqjOjkhsNe1S+TNtM/hqg6jwNt14Rg0LLrm5VOJErM5swlNr2EhgKZK
 awaGOcR/fI5C97w==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

Driver's probe function matches against driver's of_device_id table,
where each entry has non-NULL match data, so of_match_node() can be
simplified with of_device_get_match_data().

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/crypto/ccp/sp-platform.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/crypto/ccp/sp-platform.c b/drivers/crypto/ccp/sp-platform.c
index de8a8183efdb..3f9843fa7782 100644
--- a/drivers/crypto/ccp/sp-platform.c
+++ b/drivers/crypto/ccp/sp-platform.c
@@ -52,17 +52,6 @@ static const struct of_device_id sp_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, sp_of_match);
 
-static struct sp_dev_vdata *sp_get_of_version(struct platform_device *pdev)
-{
-	const struct of_device_id *match;
-
-	match = of_match_node(sp_of_match, pdev->dev.of_node);
-	if (match && match->data)
-		return (struct sp_dev_vdata *)match->data;
-
-	return NULL;
-}
-
 static const struct sp_dev_vdata *sp_get_acpi_version(struct platform_device *pdev)
 {
 	const struct acpi_device_id *match;
@@ -123,7 +112,7 @@ static int sp_platform_probe(struct platform_device *pdev)
 		goto e_err;
 
 	sp->dev_specific = sp_platform;
-	sp->dev_vdata = pdev->dev.of_node ? sp_get_of_version(pdev)
+	sp->dev_vdata = pdev->dev.of_node ? of_device_get_match_data(&pdev->dev)
 					 : sp_get_acpi_version(pdev);
 	if (!sp->dev_vdata) {
 		ret = -ENODEV;

-- 
2.48.1

