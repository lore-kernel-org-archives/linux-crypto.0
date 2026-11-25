Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795578238;
	b=0QJEGB75WBtN1ou4exVyNwFHtBhNC5Qn9WRRmcs9JsIVG3LutWJygiGKjDeBpiOhsI0F
	 NtaXvppdUHsxRn2IVmpUSvtbyShiAks/xNlgd+7fxBnqrOBeci7XNBsiN/hGdDdo2hyk9
	 fLPxS/FNUKeO55YJ4ifWfbmm5YrsG8S7bpdCF4VymfNRHTYYY/R10ryzhmRKGjKMn+uZa
	 n1O0Ms/xD0i0TGNzEp9wpPetm3kANoTrJkutw/L3WIfhyF+MMTLsejahS2yP4vdqCT58u
	 jVVxH/jDXO8sVCRqpSy4RRo2iZ8KVkom6cY307RLvltbo64ynHT/7wjUfGhdwoMnUsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795578238;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=oXtG7unj8KPVo5ZHcswWaKsEJQuS7Y5YiwYYtQMu/f4=;
	b=vfUpv0PdVHxMhXkdtLTd4ck+ffHvuUrIX8P0Xs1ZwNnCqOD+c8jbzEENvZZMosuwitRG
	 XIi3G9Opnwe98p0/UT9Ys93koW07Dmh/9jEuKm8/gvz6hQBqLUKEgPy9hOUAgTbgrNeSM
	 OnA3GNrXi+7VMJI6YL1yPKmMjfowlxdb/CyGLenxMTFX8PdNl+xkaR9uYMHFi9p+6Snyc
	 5D2Qzvm4TYBOLVl37g3jsOGMgeXkDIMqQcdrM0m+OF96L9GorevVaTobDIi8ctSn+vMxH
	 w0QjuNubqWYziCL6q/lXkM2XDkGsJSZhn/xoYlzcKSwFRHDH4PbSpyrvHzNnILWSFyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dEBczsA7;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E08606A32C
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 03:43:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7E08606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dEBczsA7
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb9d8e8e90so24201285e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 19:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795578236; x=1796183036; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oXtG7unj8KPVo5ZHcswWaKsEJQuS7Y5YiwYYtQMu/f4=;
        b=dEBczsA7Csa4wYdE9zU2ZWCuv3c+lNyP1g6pcCOAtEbnMrJGhamzSdETIVfCY7ZagR
         kX09bl2bERUvo5yj+3/MV0BjBkSARjKlcB2IH+M8y1FiELtNsF7OrcBNCuj9GZ92sJUi
         Ool/Njo35MxX8MCXscU5+lEkX0wMN0iAE1HgqVRhGboodpHuVjgFtUR4qggu1dQycR3d
         L/JwWOYt+d4dZNxOcOHnHLEvjr49y4nklFPyI4Ia30AuczVcHnVqCD+J1JCrA6pb1nSw
         SknxbrCq9BsEdkeakbZLckjVjTdpyHmCg4R6qiYzmIYtSqlHBgi77W5p/Q+PWI0CCX4j
         TS5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795578236; x=1796183036;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oXtG7unj8KPVo5ZHcswWaKsEJQuS7Y5YiwYYtQMu/f4=;
        b=vBK7oHicQFEapOsEwi5J1t4GKEyR87yLV9kK1opBg+mg84BIwf/QuVVvMnc9lH6Twc
         35hqDDtSjXTRmLBtP5ahygYLXWdp/2Pv980ylXjq2BWOEVr/9xoQpt3Bxfg/RX5lhKrP
         +jscn4x6g+iK5Pgf+rP/amyZTfNeDlHv3zm32P0YoO9zoOTqCaUMWAaHSscu1D1Faj8q
         bs+Ue2PgCLulWWsBBLcy4zGybGa9R30yrzIMgSdLVVRDvalBqI8s/3CY8odTRcH8wcXH
         4bmaEVgkN0d5iUzJnYpwxlfLEAZYLCyXTRiYj+ASBsiRCrNoxMYjyt/Sym4rH5B7OvYp
         /FYw==
X-Forwarded-Encrypted: i=1; AL+hErEJHN4at1fyUEt+zpR+jLoFYLcjqeGp5wmibFqBAn74qGC9VI5NPmQ7+Gj+RTuGbm2xa1mELCLFOllAE5M=@vger.kernel.org
X-Gm-Message-State: APuU4Z/87bQVUIsBXFzre7pK+/GoZEah9M4l8rr4P22NNFKoWpm9FoWW
	0R01luiZFfrw7vhlMwseq57qUk740afXs9WJZkMhQRtQJ0I1jP5GTy1O
X-Gm-Gg: AZFdTZeEb5Ykm+wJAylW3Sim5eCUdJBQMOAOlisMUoJil+O/fB1mvk7rGIm76Kv/TFq
	dy1/sRlUK7ZjeLX0qH/0mAH7hgI5bWM3X7a1uyYGtcbL1c+xwRNWKSkbaElvkHQzirDFqvKpUyd
	SAskjBJjb1wg3hAxPoJGxqt2bn43WitdZ7RF7YF5evg/4QM8VMBuWPuGoJp/puIrfvQKyWveInj
	Y7oUihwxVH+AGcpwY6eGj6hkc325B/zYfGmm/JJmPOn9J0b8zhV4iCxgpPAIJG078einjrk8aiF
	/hj+8HgZovZyo4Vcr/TlMmZdYVZX0v3Sx+3g7jUOAdVaT3b0lBcDwo/p6hH24Xc185olidueDDe
	W/QbeSCgPLs0e4DCXATV2Ce/SR1RCsKkw3n9CarQSO/vBX/0qDhVRkRB5VSQbUvUmM9KpJWsraU
	4nd/udlpnUatcKAeYJOCbw5QcBl+U6Piyc+Gnt4ZZD+f1dy+uGWoRop1I8ki8hUkFFEPiXeX6k/
	ynFWftg4bPfR+1StgscyfH+Xdf5e9uDlRV8KGJpei0W8wd8vs8WBluq5MZtWgSy3nO9ompmpfKG
	vChXLHvsmc4L7oIwhKkAr9kol9rFvEkow+EftA==
X-Received: by 2002:a05:600c:848d:b0:4bb:6687:5386 with SMTP id 5b1f17b1804b1-4bb8880c7f1mr352610575e9.19.1795578236299;
        Tue, 24 Nov 2026 19:43:56 -0800 (PST)
Received: from [10.32.31.239] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm391107925e9.0.2026.11.24.19.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 19:43:55 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Wed, 25 Nov 2026 03:43:01 +0000
Subject: [PATCH v3 05/14] dt-bindings: phy: qcom,usb-snps-femto-v2: Add
 Halliday HS PHY
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
Message-Id: <20261125-halliday-dts-v3-5-5c8311c0b70b@gmail.com>
References: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
In-Reply-To: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Guru Das Srinagesh <linux@gurudas.dev>, Thomas Gleixner <tglx@kernel.org>, 
 Radu Rendec <radu@rendec.net>, Will Deacon <will@kernel.org>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
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
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 iommu@lists.linux.dev, linux-usb@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org, 
 Stanislav Aleksandrov <lightofmysoul@gmail.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795578204; l=961;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=vc+yCVm63yJiTEyLJCU/ghFkRJa2TidHkMEEWzw/3Gc=;
 b=Yg/VSr0scUN51i9KpRAWHfU1hj3WxUg4RAt781FW4PuuF2y193VAPyf14yap65FpsWKVde5Xo
 6se4dVNbdKnCzQeUFO8eyXXWtGTKy5TyIr8La1GZjrp2oxL2C8sTpHU
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Synopsys femto USB high-speed PHY on the Qualcomm Halliday
SoC.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml b/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
index 661759b25064..8ff1db4a1d79 100644
--- a/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
@@ -22,6 +22,7 @@ properties:
           - const: qcom,usb-snps-hs-5nm-phy
       - items:
           - enum:
+              - qcom,halliday-usb-hs-phy
               - qcom,qcs8300-usb-hs-phy
               - qcom,qdu1000-usb-hs-phy
               - qcom,sc7280-usb-hs-phy

-- 
2.55.0

