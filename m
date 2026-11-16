Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864406;
	b=TvfPlqQMFN1L5FuWdXRITS4UPH6nL6wbIrZRyPwVwGIiHHTqhV5RuPt035qRuaOBM/z+
	 1X5j1gtCABndO3foHTrUa62QL6qezkKKZ/AaT5tvo6RxOyleKnZsZIHLplIMELkztmdW1
	 AKFRGrObA+LW6FLQoBEIcgYEsZ/zOlksn4wV0E1DQHWExo66+lAgHWM6qdfW9zgyeF6OB
	 tcrdCOPGMF2JqscWcoX5zDiCBAo5BsqqTYg2D9OoEg0wY06VfZqOdC4KZW/NhOiiIsgdB
	 fToW0bMn3wVWew+KEHs66upxZgQQtsXc4lw1kAcuEJ/F0R+EM3vKVeTScIr4r9KiqBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864406;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=dpKnhnsaRxCp3BhNS6dMqX7R85atmEMYETrpv/6MbAE=;
	b=wyx7MzIVx+3yFCWVzyTcGl75cQvbXWXIK2Cdf93u5Fem58/2256bRVyugNnuTThoRg61
	 tLSv7XpdvI2WRPyHcvxY+K8q8UGLO3eIzWwMx+Os9HlssEfpwJCzSzAt4z5RrWdJ6d3P0
	 K5okP2jxB0AVei5CANHI8QPzluo6HBwCKLIkwNONUw41ZarPckRtSdt6yIuFW1PZNLgLo
	 Lu/Rg/B7Ru55SuxC/97OTbfGsPfIWcs9NcFeDkGdeajRW4I70ZF7YOSWXbPMphY0Edpc+
	 5scWrGB5VgATGYI2wZ+F25Gw+2ousl6K6EeQY+xZNsgAYnToSL+kK0HX7POWTAzXc8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=I8xDJoNf;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4DC606A333
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 21:26:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE4DC606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=I8xDJoNf
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb6ba3b244so15977105e9.3
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 13:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864404; x=1795469204; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dpKnhnsaRxCp3BhNS6dMqX7R85atmEMYETrpv/6MbAE=;
        b=I8xDJoNfZaRem9zplTnlWWkiwNtJLWG+95Fkcj3/f/c0VDhRKNKMbw9CXBZAkIBDQu
         KDi7/92PC3BzuvcqK70i6KVaw5/vQRoUZV88eKUrBui/wN6PXFES7rCc1jTGUFM2zsx0
         Ym/aViCUG/uj7Th3xExXkYUMx4rwKh1Gt8dwbBMciok2YHaViaONWVDgji4ZkirXtbkF
         r7M5mJAf0zQmkErxe4iAIG+Y5CG2v0otB+0lyKfhR9hiBplgFEKH6QXgv33zgqv91kCN
         1ltycZwiQftZ4czJXOw725iSoIdwqdftqpGJ4iR8nG1Yk1waUYBsFZ6LFBD0taF0zsRF
         iJJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864404; x=1795469204;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dpKnhnsaRxCp3BhNS6dMqX7R85atmEMYETrpv/6MbAE=;
        b=Q/RFlb4WtZw+daMBZ2TwEBIuAQyeXwBX16lU/2gp27CQ1LUsZbw0r3Q8/rLSYZ3/aG
         +23tPanIYwK/MHCIr6By5t4pRv2Ng6WZ+DuQxThCrfq2J80LRTw3y279xRHNqkUui675
         tZCfZu1tSFtlHNGqkj7KyzZJUcQlpsX0bt8zLlId7AI7xC7w3FwDE1IrVUq6W6LiXZ4L
         Xf3fmvPP4YxmKcKx8cxYaq/38AFU6l7PLXSUZ8uvVpN0nGa7rzQ3dbpWtCcJSdFfiv/6
         OMWe0ujanxptzM2LQo8dXlGZelR8jy+rsMMD+tpPtfGqXhk2o+J6jCOxaB3waVwL0acl
         OMRQ==
X-Forwarded-Encrypted: i=1; AL+hErGc3+uPKKPt2ENdRZFJtjOXRcdOfI7NekqoHVhzCzEaYS4F6bYylGDqbh3hkp5bItFz8JlncUtv5b/8U+8=@vger.kernel.org
X-Gm-Message-State: APuU4Z+jJ1YufJ0VqqX6Ve+9aK0qBHadImdQKmaj/KBqH2VyxjSjYYEY
	RBqq6tEn1GX4oIia3BXMINZV5fwWVmbNDv89/1dXnEjKGmueD6cePLZ2
X-Gm-Gg: AYBFou0ycJQbLgcWWPZtlI3P+rtnN3BzGFjHUweBHjNNeijtaHdfNFSdtUwtnmbDQxj
	Oy0hCc05ZUWMEYFq3QJqgWH72IM7HmHka6yG2lIV0xoWNSIBBupmnz7zGVjWr0OxqnKkPAw4Y9S
	xKsj1qyxRHvaVeJuS5NDDSH0yU1VxT6raESLXb8qOPtJWfsVTTBz9R8lGR2XhxASGerJZ01M0W5
	D7IZog+6rwTfWjzXfxNNg65B8Jlj+tlk4k5dQkHqDk8+dJa6e7bBFlXbAW54ZmZyK6ExIIDIcOP
	XZbWhfPDzUhTOJFejVN/gsI4MEmyZL9uwc+gHDtnmr4yHNZIw+H+biLoSJA93FxYjfeYv4+N/82
	5LNoxM1F0Ih9NG3BTZu+UGiGfYtOW7tIyfGQuofNeT5umtsZhUv2kbsKNRdgteac48pdTNbJ/bH
	SjBGFNuEtOePqewjCPaKtNDOwPI6GJWZ/g4ox+q9rIBPNAHE/v3Li/ILMei+H3SKdlAHqrS6I3Y
	e8F0lZH7K24fbX8NktNqAlFA00rr3OeaXSeKufHCm+jkpejZF1l/BVg0ehGxRPOW7goDZvoSme2
	3nrCCRNRD+UE3BdjCPKyBHEFXWiDlkpkVotaz/Ji
X-Received: by 2002:a05:600c:6994:b0:4bb:647d:dabe with SMTP id 5b1f17b1804b1-4bb647ddc1bmr178719475e9.3.1794864404416;
        Mon, 16 Nov 2026 13:26:44 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:26:43 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:18 +0000
Subject: [PATCH v2 02/16] dt-bindings: power: qcom,rpmpd: document the
 Halliday RPMh Power Domains
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-halliday-dts-v2-2-2c92438c6c46@gmail.com>
References: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com>
In-Reply-To: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Guru Das Srinagesh <linux@gurudas.dev>, Thomas Gleixner <tglx@kernel.org>, 
 Radu Rendec <radu@rendec.net>, Lee Jones <lee@kernel.org>, 
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
 "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Wesley Cheng <wesley.cheng@oss.qualcomm.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Amit Kucheria <amitk@kernel.org>, 
 Thara Gopinath <thara.gopinath@gmail.com>, 
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>, 
 Lukasz Luba <lukasz.luba@arm.com>, Georgi Djakov <djakov@kernel.org>, 
 Sibi Sankar <sibi.sankar@oss.qualcomm.com>, Ulf Hansson <ulfh@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, mfd@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, 
 linux-usb@vger.kernel.org, linux-phy@lists.infradead.org, 
 linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-pm@vger.kernel.org, Stanislav Aleksandrov <lightofmysoul@gmail.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=1076;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=2tteAd38AfHrvk8Awl3RAniXNSdGBzL0LwEwE8e7LoI=;
 b=zXzEFbpmrw7cpK4pILHkAa2JAONx4e/NBSRGU4M7PF0mG2S7il3dQ8oQ1GaRjzlC45Rh8Rzj2
 +R95I7vK6fnC+0EXJojPOiNt/4zRdqb4EXf75+xmDMH2zxxqkWubFgC
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the RPMh Power Domains on the Qualcomm Halliday SoC
(SXR2250P). Its command DB has the same power domains as SM8450
(CX, EBI, GFX, LCX, LMX, MMCX, MSS, MX and MXC), so use
qcom,sm8450-rpmhpd as the fallback compatible.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/power/qcom,rpmpd.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml b/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
index 8ee1c25a7c9d..663baae9cc64 100644
--- a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
+++ b/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
@@ -82,6 +82,10 @@ properties:
           - enum:
               - qcom,maili-rpmhpd
           - const: qcom,hawi-rpmhpd
+      - items:
+          - enum:
+              - qcom,halliday-rpmhpd
+          - const: qcom,sm8450-rpmhpd
 
   '#power-domain-cells':
     const: 1

-- 
2.55.0

