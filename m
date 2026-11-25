Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795578227;
	b=bm8y3iYXBgt1q1u85J0B4CWkKbeW09VkKnhUrqBgRtx4Ssvy3x2vr+xi7rZ3vcyf0R4m
	 NkdV3DhaE1iQs43DGRvaYVzvwqTFppag0YUUC7w8n9LJ8PxRZBGEmhPJXwqDRvzk6vEC6
	 jDAWhiTqkAUq+drRc3d4YUCiizMmig19V0JzITVm6JeWZIXgdLqbRxp+Sbc6jF/wo+wa8
	 pAyDpSqjZFdZE1KQE0zeIuZCbodIo3o84A1udPLcxXTLk+62x3yOehaCuhdUv5igZw4PB
	 UlDJE1KCjTu/l9lAtM5WRcW6r2a2Bpi0KHxhFXZIEAnDk13VSJsLX9YqIrVhQbLv0/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795578227;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=LnAQsJm0J9tjLLptwYNMgJxavVvbhamVp2XrX/3IRso=;
	b=zKULF9mbBq6XIBRhVP3WRpjUQM3gLRQm6Q/RbYfIGnuwHZWJhA2b3hyqVGKAb0/iD0m6
	 z+kgxbSoyVM42OCFIycsXYk8OEKnEj3gP5Ayu45tfxr6q6Mqtr5irLkGye/cybymSnCo4
	 5NRK1q0nYYfwus0n9fekFIWQ7ZYykVm5f/0dOKzfpebNv8L3UU6HkIEVZYrCdEzAN0Gla
	 YL2WBa9fC1iPnW7meqriI8RQEmTzjG39d6Xhk79YZU0ZKHBx+b9s2meDvqETKqXkDPGfn
	 mKEOxmyYIYh3ihtHvI9DHG/yiGhXF0NGC0qJ/8Zu7XPIj5RKlvVvf923sYVYskl1V8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0aAO2IER;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D08606A331
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 03:43:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23D08606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0aAO2IER
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4bb6c7b6dbdso48749165e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 19:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795578225; x=1796183025; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LnAQsJm0J9tjLLptwYNMgJxavVvbhamVp2XrX/3IRso=;
        b=0aAO2IER8kB/PZ8lVTz4ay0gUM3UnHZ/vSUnCLSG1JyAoz5XBu+KK21LecUcxMVVPv
         jsWMrr2ej7wBkGLSf8knbqOSbMCkQdfrO2H4N9ahqoxf9PkhuCMk6yKJ7aDsuw1Sllog
         n2h6BpZ1eYdLP/1TkWg1m7+VsZgy8lsZOcBvobJ1rYYRa+rc165fSgbxd2iwaIWTmohp
         xI8SWD8A92goVkdIoTQEWJCO0+eeww55ZY12t5skqCSUwNhKBJmDg8DwQBPFg/USKm9z
         q3u4ku2M7AyMbCbVEsn4NWbOtiIroMB03dZehtwAeTejOqd33rkDhsXaDj0ZB3S0ZgJ1
         veug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795578225; x=1796183025;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LnAQsJm0J9tjLLptwYNMgJxavVvbhamVp2XrX/3IRso=;
        b=0rX6wRe5R2UQueRRVWAAd2jZj699mVyYE5aodh+p2gUEN8LE29o3yn8C8gE5Pnpycm
         lB0cES4r4JweIo5FJhDX7WCXXdIY+abIbpDYLyiNttLuGVckmfVllJsp4N5onWlM/11J
         vkYlf/TRFQR1M39fnp8TvmKdQbJBiZ5xfP32PyzH9umnJtWanj5cXZOS/xPO9itepM3p
         ft8jVarudQmzN/dCkgXEU4OZ9K2vOjdJd31BrhinXgmSn3ehDKOVyP8ZMFb3on+P6Knj
         Kgkgwl6VoDztECk9flXd5sIQk6nJM5yycooQn07IzawO0NENgUmOyxRMsUJjebBlu0dF
         0TZQ==
X-Forwarded-Encrypted: i=1; AL+hErGRRsChNXTlZrRY9bA1F9mDzukwIfhs2K5XK9ZNJ1diX1coPmLqqLarVQRRowMV/5asEm6pa38pGmSG22o=@vger.kernel.org
X-Gm-Message-State: APuU4Z+H+5FqMF7F3gVvxe9TwOpyMPiocQQVuPQB2hXDxLdmLntOK9zM
	1PhSDntuJufof557BG4jX+MGSAax+wEkyC18KM5YzCWhqkkB7NxqXAcP
X-Gm-Gg: AZFdTZf1JfoA2uuZ6W9Xp88o2hbMTslbTet9Qh+qte8nKo4Uo3ynx1qRrX1+t+XAtuL
	Hql+c9UbktbHdG5dpM8F1rdT3kHXkKbJWSzjZiNHNR0ICj2zhFPfOVmSnbdG1JR5Fr26scWFtad
	M0wORvvBjOwKHcv6bL+HhbDvZr1/rCQVrYemyYgpE9HTELGpFBxJ8sps9YJKe55FdKq6rYQXA7z
	hWZHpQ7i8IF6w0yChBfIrGwlC3AhS65m3u8PO88EQlhkLhOqtcNSx8XvdF6qZ4CPhkmnOoBLSlv
	PvVcBg30ltjXud4RwJhk1bCRZrAJiqf+dKetIGvcs8sBemP+PMIpESBmkzx9QG7Z8CZvMk6Z3Zb
	OLlrqAkChJQPUwPXDaJ4rrQ2gpJ6PpRR5ZjduvuPYgn8HfRJ/5Fjp36xIUYA372okSOpR7V+VIj
	CA418SJ2WeOx+pf0u7dSTBzNjj6EunlmgHZXJYoYhoGX3MwmH9miQlRtikczStasPvb32LaT5Gy
	PSOG9IKerJnL8Plp5NuEI/DFVElo/0tdi/AqEHrMZOWr46LWqrccvkTjwSM+VJvSdagKJitUkWb
	70PY0bbTKIZU8JB2nmSOzsWIOp+Qx+db3lwx2Q==
X-Received: by 2002:a05:600c:a087:b0:4a2:5267:3cd4 with SMTP id 5b1f17b1804b1-4bb887c9fbamr346060575e9.3.1795578225601;
        Tue, 24 Nov 2026 19:43:45 -0800 (PST)
Received: from [10.32.31.239] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm391107925e9.0.2026.11.24.19.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 19:43:45 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Wed, 25 Nov 2026 03:42:59 +0000
Subject: [PATCH v3 03/14] dt-bindings: arm-smmu: Add Halliday SMMU
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
Message-Id: <20261125-halliday-dts-v3-3-5c8311c0b70b@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795578204; l=1185;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=48k8tRM2Ds8B2KdX/k6MNHyKgJdAqOSEc8lLmnEqak0=;
 b=xCVPapQpg3IOzKVtAOHGmXsvfGx4fLaMkQfgRrvbjtK325rtMzpV4avhI4qPqmiTdlTgkoLxC
 dBxQBhGhobHDwrnWCUlsJvGEoN9HKps7J2KipZyJFkE2yjFIhJECBv7
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the SMMU-500 on the Qualcomm Halliday SoC.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/iommu/arm,smmu.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/iommu/arm,smmu.yaml b/Documentation/devicetree/bindings/iommu/arm,smmu.yaml
index 6748351c7812..925afa8cca8d 100644
--- a/Documentation/devicetree/bindings/iommu/arm,smmu.yaml
+++ b/Documentation/devicetree/bindings/iommu/arm,smmu.yaml
@@ -37,6 +37,7 @@ properties:
           - enum:
               - qcom,eliza-smmu-500
               - qcom,glymur-smmu-500
+              - qcom,halliday-smmu-500
               - qcom,hawi-smmu-500
               - qcom,ipq9650-smmu-500
               - qcom,kaanapali-smmu-500
@@ -629,6 +630,7 @@ allOf:
             - enum:
                 - qcom,eliza-smmu-500
                 - qcom,glymur-smmu-500
+                - qcom,halliday-smmu-500
                 - qcom,hawi-smmu-500
                 - qcom,ipq9650-smmu-500
                 - qcom,kaanapali-smmu-500

-- 
2.55.0

