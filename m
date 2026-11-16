Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864477;
	b=kTP6tY6WY0zBL/bPTyGANB+qGIC39jhSLEs9zJWLASxYCjgCeYn8FqhJMMRKDCNm8C2y
	 4REpUh/LjMHsKgpvo9t04ioaWdSLsiEJ9buf5GoO7Zf5LMF/1NiuKmf2SpdVZFjRFdpQl
	 hWLIn6SjqH3/jGgOSR1HCkfHrZTqeyC8jYruJfVybl25mLtJDSOdlpQgJKAQGbMf89JgL
	 dYY3+MEKsq+KoalBRVyVvQZhmusrVnwnLQCBNNUo1CQMEx8YoFh+krdEpXqEt+cLyXSs3
	 LO4+Ut+tKTrfGpvrpgbsK/oPnJkypVX1nD33VPHvYuyjKNtOpFNXd/krztSGdknk5/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864477;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=mvVvlwCzdjoOARGkeb2HfQeJVG94oQ2ENGfT6+oUCwc=;
	b=f0+kleLFdYG2jcTGh4yGZmgzVTdCZi1crxPAeKx7bIUbffEJiNg2tWHQ0/C4nLDnYEok
	 wCGyD55HOeyCmxAhqzk428pkRBUw89ujB/9UNydWd957d2+RcDQgs5APG5eMUsLCD5Ii3
	 oQ4SxEQMG25n8LhuwUmqKOWbzhugRGrB+ls0ULs68BDmm5dl75z7X7moMNimMvA2g0ZI4
	 pZDrKtM/jNqhJoqc5nL6vhhs8pYBKayEunUqVUNG+rAGl7F4RwY3LZ0BzQtmS0s7dVuAm
	 5VewwfHq/MIVMtW+tRuzjoTaBQSKlmfmiqBrhoh8I+V7oIbD0Cgx5CMVAl2RIeSbiSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FPpD0dIS;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6DB606A335
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 21:27:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D6DB606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FPpD0dIS
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-490d59c3edaso194016f8f.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 13:27:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864476; x=1795469276; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mvVvlwCzdjoOARGkeb2HfQeJVG94oQ2ENGfT6+oUCwc=;
        b=FPpD0dISyKSAsA/OfXo9aET02c5v7IUiKwrzM7OGBDFvjMvTZoNbDoYV4Ex3Y3uYhp
         Y6vCQ7xir6up1dfUVLJ23VAaalNZ4uISwqpeaXPNkJgGz301zcyyvNP+hYTj/McltQK2
         nHoILFZ40kLf7wxINR1Pp7egTSiFzWLEp0yKng4RRniW+DeMhQ4V0omBbBAyczu0GDB0
         pjCabrcA7S423UTuSJS/0gDXZklx8OB2tDXAufmuhZv6NgJh9UmOymUt4fRkyObYF2WD
         JPvPmLCEPG7sKQ2EBmwHpk+O5gd+zkO28V1bvTe+aAAB0Uos9QSDOxduGncYaIIXzqk2
         6qEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864476; x=1795469276;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mvVvlwCzdjoOARGkeb2HfQeJVG94oQ2ENGfT6+oUCwc=;
        b=yvY+K0w1KBJ4yaYSFCICX0REeUNfnVEgrUMuEkccBMYl7ruThRkO2yZmSfyTO8hDhf
         abFNqGUeNf9vEYRZq8gnAY6ek96bdTO/TSkapHDxdnMJ+V75tCzEFbgTV69HNhXdbVYb
         4EfgeOPAQh7+OGDtFmij6VGixzbjRAaKg2z/8Euj1bId0La3qzCjQQodA1sIcB+9eAeR
         P62eF6jhynpVzNr8KMUyQv/ASF1B8eBgNBvUGuasvd9YVzuayrowyp3QT8+136qkDp85
         2IQ6rX5sY3KKYvtjhikKWFsRpDG5pX6MoHNahdFnX4uN9DQu7ZnccbuQ+KWN6wtOj28C
         OHvw==
X-Forwarded-Encrypted: i=1; AL+hErHlgotP6MntB3kMGP8hNd71Z3tvFBtzQl3ftPHjfrGBJMKns8tGP/fSduyk6jcgiYZSxuFQDYVQh9rxRB8=@vger.kernel.org
X-Gm-Message-State: APuU4Z8CfisemQYIMrnVSSZdDiKTkxIy4Pm+hyVwiGKYNeW9nGE8BvGv
	YJRTfCbxlrsurTS6PLZOGOmoC9xxE0hgd77+Tc/kh2YlwjMTq6g99jwU
X-Gm-Gg: AZFdTZcr8a+HXWh7Y/4b0KAhQqConsMdcJB42bk/iMaYLDReurg17DLRfzAbYzqmFDX
	T9uc2MlBLqDtAwOI/7NbsX7fKT+w8JYO1HifiAWvIjKnqrY5T4MsWtgTylwD4DMK6y7smK4Nxq3
	395m0fP3JpuuHqE26dM+vY4r1vocv0BMb1VN5s+OGsnMvuvpUNpfum904ICOwwLrIhypQmO5Q52
	F0SPCMTGWrIVAhOIUlTGZ7RbplkcNmDB0W3dbcUx2RbljKg0wP+uNI1jE7KD51zN2GbM3zx6yMK
	2DvtR5fCn0NDaBz20j5UMwW6irejR/8kH9LsDHzHlt92NQvRJXh5WTQ4tuyrwOgI8489ZKlN6jF
	mMzyllZnlDUT4184xUKsHiNv12k6VUa40Ry1shXZV0popql5Y43vWmbSxHCmzJuRn6Y0AM8CVTV
	M/kZjh/Nj0y9N66yIoOW/LaVH+Mbq/22jpwJocCU/QhJx5rExqDoTpcQ5L9igg3T2ek9h1OOWFK
	rBBgja+PNkAfvBnLBOwerZ/GvVtEsPd+bKaz/idKHhJGMGdaKgDrvsN6OCXfkFlRZRtbPqAUF/E
	EX38l8DkyZRyGzflkH3G4EPc0Hx5Xt+LOnewI7Ga2Xjv/rycsKhRQsSGCR+rcQ==
X-Received: by 2002:a05:6000:4706:b0:49d:8ce1:2652 with SMTP id ffacd0b85a97d-4a36bd51c5dmr1648244f8f.1.1794864475624;
        Mon, 16 Nov 2026 13:27:55 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:27:54 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:29 +0000
Subject: [PATCH v2 13/16] dt-bindings: arm: qcom,ids: Add SoC ID for
 SXR2250P
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
Message-Id: <20261116-halliday-dts-v2-13-2c92438c6c46@gmail.com>
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
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=746;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=wp4yEFlEeRirWebvDUNwJG87yvgwIo0fuTVgUjPIFVg=;
 b=c3M0oozAyWICul1zqZyYV4A722e/xl51QI136kZKSBBz/N4l9sptO65yuOtgNCZsSpOrbqAMq
 sRMLJj/ahy6AipZ7ofcwU1aakgIIwxaL8YroDdkKta3ZC/C45UuYvvM
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Add the ID for the Qualcomm SXR2250P (Snapdragon XR2+ Gen 2) SoC.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 include/dt-bindings/arm/qcom,ids.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/arm/qcom,ids.h b/include/dt-bindings/arm/qcom,ids.h
index 135297027580..cbcab632e01c 100644
--- a/include/dt-bindings/arm/qcom,ids.h
+++ b/include/dt-bindings/arm/qcom,ids.h
@@ -288,6 +288,7 @@
 #define QCOM_ID_SM7635			636
 #define QCOM_ID_SM6650			640
 #define QCOM_ID_SM6650P			641
+#define QCOM_ID_SXR2250P		649
 #define QCOM_ID_IPQ5321			650
 #define QCOM_ID_IPQ5424			651
 #define QCOM_ID_QCM6690			657

-- 
2.55.0

