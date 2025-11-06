Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2A134F265
	for <linux-crypto@vger.kernel.org>; Thu,  6 Nov 2025 16:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762446734; cv=none; b=ZMxlWL+uDVQa6giheZ80yt6Xeymxudc5koAqtnCrrMwfbTeMy+FZ5Ye0HF6tVQP1CW936gPFazDg/0Daj0BtqhgbcbNXYHyVZRuQDotUn6vTqaWCFOhJfb6ybcPB7xaE6mlnGvJ7s7VauUQYQOLuVTTMVayljDloY+b6d7ZGn4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762446734; c=relaxed/simple;
	bh=kMWfmj/ptzyaxsCFocF8hhBseEl2zvCJsZs+GsRu/Qk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PDhrlkKbP/NfXomi+c/ucalX61x9LoDFJvRFzSi9taDKD6WN/5zpUcanNORxjd3i4V41/WgWdlzyiSGmc2nxqMxmHP3OnDnJ2b9kNyBCutRg7EUhUw6FNhlcAiAAuA4XapJgn5M+WJaZwByFWff0q3m6livBWhNIeZezsp9+oyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EFFtl36m; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EFFtl36m"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6411f1c4b4fso204248a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 08:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762446730; x=1763051530; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZGmeAD+s54GN07CXVStO6BNg5fZaJA+7jizpGW7KNys=;
        b=EFFtl36m/EInEft3CNmVUM2Ts/vKlffWODDuYp/f5pSXd9dkNsm7NizLn3/umpcEp9
         JVZ9Rhbh21AgFmj+Q9aPBMT1/1glV1uFjFGa5j3/BL4ljrNhswiqyjxomz46yBBTrvFA
         bDP7s5sIfQX0P6PcRyBfkJEIQ+LT4VJC4Z7w/n1qBfSsqcAD7BTpnHOmkTFl+s4hVTAj
         fAChr0TMvlwnT1F+3l7JED1TULN9MNH0sL09WnbD+0G7ms6c2JtiIn95PGsh89i9mQpg
         htCVzjNWD2G31VOp6Ot2TSWjMNVeezr31aLSd+R72QfEYMqoGjhus5ivcfNWaHae23OI
         Hc3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762446730; x=1763051530;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZGmeAD+s54GN07CXVStO6BNg5fZaJA+7jizpGW7KNys=;
        b=IHQF7ucko+5DufU5brWmOoqczJFMv5EykfQhX7XXvuZOqL55fyQA2upFafs+Md7hZP
         O20no4qr1lmMVG6uklYnqonF8i90UGe/kO8LQvVD6eEIaoqPQwCnho2D8aEFKN++O5Ad
         UmsznBWyASAp5Ig3/2Mc1oRbvcMtrUxc1wVHkeTe+1ZIT+ft/DNWEuUxnbm9jEAS2Gon
         jL3M3pqwknk9mjZ1o3pN5B7so/APfxB/6BYkiU4a/TP3sEBWI+D5O0EZKKNpy2AzKaMn
         L2r2fdhe+bb6qFJKJyPHjFeYhvi5xuEI1GlneU5/h7wMRR6Bfbxjy2Uge9jthHpl3zPo
         MOlw==
X-Gm-Message-State: AOJu0YxCKlUu49/TWhFV6tZsyBVrRHEFLd5lC9EqNDcmeyO9cVHrPUho
	BG9AMyBwA/JjvdKbPWCToiQeAZ1NFpuCfwFswPpswCnXOxdQexKYFwMlK8hDtPOYQg0=
X-Gm-Gg: ASbGncuH/ZlCfeF4WoLdw0+gpAUuj/LyaM4t+xGtnNjcGMP7XwLxNMB1Vh2jIzDbzuI
	YWzqPLvVLI1/zerKhc0VwtG+vIHSBSF3vGLnrg46DDGAxeKrPmS3k/y0u7R8hva6KfO28Be0GEh
	L4CwG8X8w0tkmGBfR0dnCRoPc080JzmjLs59055jYO1FONh5WysG7P9mLb3UADWA3zQBF4JvCOS
	Reu76vKvTd22BvMVIG5XQfC01FWGcIkxNAR0C6Ts+44+uxmq7I1yJ98tMflMdnJPk7tVDN+Ge+v
	ykCifWtFLjDb67kS6If6CLbGDbZLspD6R3bxSnryO6kt5BN3rOMBgs3g9687FLylRhHVxQI3R7C
	HAplafBDZhuk+1v4YVzaK2A4oUJSJbXcKRPw+tegyfydXyF2aOI7TAlzO0HilxoGecFKAvVOtZu
	lLC+7eVIWHk0qSePWr
X-Google-Smtp-Source: AGHT+IGZs2swuOBj8gaR/OaDywMJNFP+fOLD+tbBh6Eq0osdyg8SSOyQ8RqjagdO3Qncnx1PxLOCmA==
X-Received: by 2002:a17:907:3f8e:b0:b45:a84e:8b69 with SMTP id a640c23a62f3a-b72654e3240mr428405766b.5.1762446729945;
        Thu, 06 Nov 2025 08:32:09 -0800 (PST)
Received: from [127.0.1.1] ([178.197.219.123])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7289682544sm249625566b.53.2025.11.06.08.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 08:32:09 -0800 (PST)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Thu, 06 Nov 2025 17:31:56 +0100
Subject: [PATCH 4/6] crypto: ccp - Constify 'dev_vdata' member
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251106-crypto-of-match-v1-4-36b26cd35cff@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1804;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=kMWfmj/ptzyaxsCFocF8hhBseEl2zvCJsZs+GsRu/Qk=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBpDM1+eyCUkPULdaZ1GEkFUKEjOTPXhaUshCW+v
 bDMaEMH9XOJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCaQzNfgAKCRDBN2bmhouD
 18ATD/wOYnNM20X+EDtAZHZw28Ys+I/iX3FL+93RIP8Z1O36NFU0Pdnc1IaBpbIwpxB8DBEAFwL
 FVz7cxaRtVlvQm00WJYDzgtPUMnwtIy+oXsEg3Pn1PM5FLnR/RH75aJZQ5BzSrfujqt5KeFviO8
 7/po64dd8V9hsONfkT94WJxIKpc+B0wiAEQD41bFCVEGX74OBm0KgS46EGrPrkwCnvbe+zzKART
 6NMwNJXdR3C12R3Qyo0NvGU04v8hnz4r7pi9ukcrEfMIKG1WFxjwQysV3oxb4RIempXL2ij42NR
 T9wXQx1xWttCcvG0TTkaAJJUQsBB1qg0fWDWcL0kyZLWnAiqgo7kMhqdrViytj7ycapPBWlTpsl
 M+ihpiqyJV+W8RetM3K094JyPOELAnv0+Vf7yGKL9rvU3NkPmBC0OHy18SBKKSqSYNWSWdHQPEy
 by9w/XTEH+JhBPeWFtAcr7xptyC+QlSi0n2K3Bm/VTlVayo+dz6ul45SAyu6qkXPvqk61qwidy4
 5q9esGuJZhUn7k+BTNdRXUOk/PKs01CNGk933A21cxOvD/Y+LZ48WpLihyQyKDZRzvzHe6qGeCE
 uc3ctHLkBUz68GDOAitauO0S5aGCbz81dMOuATOamOeEgghsKNBCvPoaIFiB5hsuUtHEh7VueGC
 ekT0FmK9VnPvTrg==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

sp_device->dev_vdata points to only const data (see 'static const struct
sp_dev_vdata dev_vdata'), so can be made pointer to const for code
safety.

Update also sp_get_acpi_version() function which returns this pointer to
'pointer to const' for code readability, even though it is not needed.

On the other hand, do not touch similar function sp_get_of_version()
because it will be immediately removed in next patches.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/crypto/ccp/sp-dev.h      | 2 +-
 drivers/crypto/ccp/sp-platform.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
index 6f9d7063257d..1335a83fe052 100644
--- a/drivers/crypto/ccp/sp-dev.h
+++ b/drivers/crypto/ccp/sp-dev.h
@@ -95,7 +95,7 @@ struct sp_device {
 
 	struct device *dev;
 
-	struct sp_dev_vdata *dev_vdata;
+	const struct sp_dev_vdata *dev_vdata;
 	unsigned int ord;
 	char name[SP_MAX_NAME_LEN];
 
diff --git a/drivers/crypto/ccp/sp-platform.c b/drivers/crypto/ccp/sp-platform.c
index 3933cac1694d..de8a8183efdb 100644
--- a/drivers/crypto/ccp/sp-platform.c
+++ b/drivers/crypto/ccp/sp-platform.c
@@ -63,13 +63,13 @@ static struct sp_dev_vdata *sp_get_of_version(struct platform_device *pdev)
 	return NULL;
 }
 
-static struct sp_dev_vdata *sp_get_acpi_version(struct platform_device *pdev)
+static const struct sp_dev_vdata *sp_get_acpi_version(struct platform_device *pdev)
 {
 	const struct acpi_device_id *match;
 
 	match = acpi_match_device(sp_acpi_match, &pdev->dev);
 	if (match && match->driver_data)
-		return (struct sp_dev_vdata *)match->driver_data;
+		return (const struct sp_dev_vdata *)match->driver_data;
 
 	return NULL;
 }

-- 
2.48.1

