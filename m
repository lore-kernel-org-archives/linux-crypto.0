Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864457;
	b=S+iQgin/r2MJfBAbKwXPUhtrzFdP0CXcHjFPSeEQgjYcN4p11Vc0xnCdmJkscQkzcl1k
	 qVYRheYOI2fT4H6tDRz+My7fnshTOy5h20aQXQj/fdnKfIH3XIbdWfCwnxATKVahtk4oq
	 PU79AlqiyG/v4Rb2+Dfo38R8mvD0bw/ijsZZKpz2Qctvqo0KA4twd1Yb4cPmd0zosL9o7
	 60rvA9ctb/1f+ef6/sM6oe12NG3T7+p81oiaSsOBHv1t8pSlPm06g7la7/S+HGRb0gmEH
	 /6HTkYT7oIUcd9v+0XtwBL/G3drogERi1ShJ2RP+8Pa7n0zgIzEIMe8z+znnQ6XROjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864457;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=bHyunwqhqqpQQZSm8FsYLG0nPatLuBc3TvD/xVa6m3c=;
	b=vl2cdbSJWFL90B7RWAY66N3EGYsZXsbjLKPfGwX2sQh5VrTYL82NRdf0aEYyMB4K5b+h
	 DaDRTA7TDlxCh1VN5pV28W/V6vIogsmT7HHOXLOesi4aERAGprgzrNZ8r4ZC109jOQ8AP
	 FuktUIiT8WK32/6XeBmnyu0FnC1YQDyHBHGwLOG6csZcBh3s8j0/NjiZjSItQT7Q82dZk
	 iaIsZzukpoQ4xmo5DEUU2FFaRoiIopSs2OaizmXsDbSGuOWBWzAkxUk4w5dZzA9kCxgA0
	 LZrRFHyaR8/62AgjJ4zC4galBDDEDzzlgKWURKx7wT6w5dpl5qx4LPlpB1/POpPeDzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aEwrHomr;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69546606A32F
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 21:27:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69546606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aEwrHomr
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48e46e449e8so2963204f8f.3
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 13:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864456; x=1795469256; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bHyunwqhqqpQQZSm8FsYLG0nPatLuBc3TvD/xVa6m3c=;
        b=aEwrHomrXoLkAiILddo3V8DFgxCuIXh9nv9z9CGp99Mvv9q7rqS8WWfJjEVZyPKHzl
         BJcrzkqstHqVy4gz1/y4oTWYkRx+2g14yun07x+dBnVAXWbxJ6Pi8XR06lfkxtBvqCY9
         iLfFme7fheT+0AavzMAdfuk0LNIbBb4A/fuWyckPSLx8IQoPwrMmA2E7Ut++Patm8fWZ
         5Z3yyawCVkfdeHckJNnYoaWNHRgUbs68NL4nZXkxamHwG2zmOimO4uoTqxyi0KJ8H74v
         KgRMh5LPcsoko2D3/7aPeGtRlw0wksD9UiL+6PyQMe8GGRsHDiMrNoZmXU6ZdSAHjYHb
         hHyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864456; x=1795469256;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bHyunwqhqqpQQZSm8FsYLG0nPatLuBc3TvD/xVa6m3c=;
        b=kcGnQMwtImqZ+EEk4XKBf96j9MEzpji6mhmXTGHJvh1F827DbyDsHySMyHyMF9FCdu
         S6RsEl7tJ/W3X2pxC8BguwH2EH4JQSYM/gxjjq8QSGwDWCYxHgmWaTseuG0QkQYd+E9G
         n8kWRNiH7Y2EfLhwnHablbqZ6iBZt6NZ9ur7IGfYnlVvctRERxFBYvyvSw+i1NPJdcZY
         RF9wIop1+j+V8qrYSD4NCTRUzXhRqg0uVRNTJAKaZtT/d0zfqzaQObFOZFlHmhndCxep
         zZpvYKeAskcJc9xVvwemr0/PVWfttAdalJnMEaz7JULxcoBfChg2vXB2GnRSbsde/lTe
         FOXw==
X-Forwarded-Encrypted: i=1; AL+hErG8fJWB8tKuEGwSXeUZ9ZVEGNK3pKjYM1Auvepn6a0ZqplMSuOQtkfy3v5wJkR5dW38xCEODioICd5ltoI=@vger.kernel.org
X-Gm-Message-State: APuU4Z+UZXMAZt9JphA55BZ7EyfaURKQ782o588Aom3Fsh8jMHS3FssM
	UxylPkLbON9d9U4rZoZGzUDgkf2D2qjiUzAQqDTcmqaAqI2035jxj1aQ
X-Gm-Gg: AZFdTZeU1kaZ0i9+rHHwqkDlEH+7Hr+JoX4dOvOt3+t22kHfq1LmbpMc5cCNzWsIL+R
	qKoyrMqi4+ey4B8IaJjaOxEEDv/HPI+RC19koCEdQlidsFGI4PpS+qKX7XmoISmdfD/L/5vI4xK
	ZIbXg6NaQZMzXA1UQAxCOQX5sMO9GhLumTDfOrGABYsCCZN/e73EzE5M5sSuTdZ1a7M9RJRBt3o
	qhKStk4TTcIQ8sMEES42nxse0D/MhnB0W/f/f4SrWD/RQ59hcY2DIQfnLfA8cS2WTmhJHKmOJKn
	O6mzeui+BrvNx2bdcDfX+d/Ismm8bFSuGQkkE6u+X48n+Gk02tIbTD1ai0ehx/PBYzyrJtVMnNE
	mOEikT/VvpJ3vzg98TcXWGAXxHGqQzJvBNKc44HOLoxJagCW/6ZvvSsQL8nX2b41QsTfYhqZwEM
	4a//T39QgSkHkmQzaoO8st5Y83kk4l/lOU2LgxVfqFHiSrDizUXwruEOPVSnbMFkrEKZTfz4gtM
	IqEcgl5fHuV3vHtsCiFCRz28lx4BxguEk752IjvycFLO/Dnj2qzvK5E7cUSz7pEI3OnogEsthZA
	cTIG4D4AqqNL1iraDm7rMp1KgPkih1y5THDBmzVZ
X-Received: by 2002:a05:6000:25ee:b0:490:b23b:802d with SMTP id ffacd0b85a97d-49c71d475ddmr22315194f8f.37.1794864455894;
        Mon, 16 Nov 2026 13:27:35 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:27:35 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:26 +0000
Subject: [PATCH v2 10/16] dt-bindings: thermal: qcom-tsens: Document the
 Halliday Temperature Sensor
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
Message-Id: <20261116-halliday-dts-v2-10-2c92438c6c46@gmail.com>
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
 linux-pm@vger.kernel.org, Stanislav Aleksandrov <lightofmysoul@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=829;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=QaX1Uqhi9JFBTyniSmrOqgkrx65fb+cn/pSnBpltl3Q=;
 b=9cBm/5Mi8IeF1ejOwJZWQD4SfyJ7BWDjVcE5y5kBsTodKh6u91I9h5To2Rc8ArYF4KPYJAO96
 griT0U/fTv6BDQooM53jxYIwB3vuzMj024ajCLGGuHNM9Pf4WE6Noed
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Temperature Sensor (TSENS) on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/thermal/qcom-tsens.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml b/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
index c78074fbcecf..3b440f395fe8 100644
--- a/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
+++ b/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
@@ -57,6 +57,7 @@ properties:
           - enum:
               - qcom,eliza-tsens
               - qcom,glymur-tsens
+              - qcom,halliday-tsens
               - qcom,hawi-tsens
               - qcom,kaanapali-tsens
               - qcom,maili-tsens

-- 
2.55.0

