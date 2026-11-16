Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864464;
	b=jskamym4/Qz7cWV2d/I4gTlpBqidMtsvX97wA3puseWnccTkuQ8NOe5AJcRvhuWsl5BC
	 r03ui6TSMe573T3yEkR2bSk3RiRtttBUYpQv+NKMyBWP8WWF1zdT3kk7nASTZ2QYalt6P
	 XpvfUN1cTIj3Yap64Bb63N6Ihoc9cvXbawd8epPldKwIHkiYIGOvGmorc+0od9XIr0MLa
	 5N7hPir+GGYGWYoHklloqUXE4DiEtbkyEOsKigk64n8jSptnHrZ5Ynf9tCoN4SQXVxn6R
	 hV8oxwVNoNUCzATukVLZKXpqqOthrCA8IKrjtKkSRqrheNPzxXRbGQh0Xc/3PtykM5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864464;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=+ZKraDRr1i3pFiLzoYIEWaHhHBRYyhj/gKsvyx4GUpo=;
	b=a5unta4XXad9gm/4LGMmrnQbeJMr9wv+oGW12KvDgVzGlhEjCkuez1rteXZzzqL0jwUN
	 eCXkQFTsAjl9b/JY8+ItpyOKcOZmkIaQ/WkOtKo9wollyJpf44vvApN7wAbSkGFJwdLyv
	 wR1MuIe3w/FwnsCEQuTRN2FAYdPVgreOXbl3qE6KKd7uCuPHzSN308Dk152STCYWMTNM/
	 jJvk3R9r1Z7Sjmh1oY2nWVYxA8FFTkJOJe8AHn3xbBtiVIFz9vXscEFCpOpxHidAyNM8Q
	 s7CMohpvLGHgB+6mkFuvCRHXf4P8SAf+6dr7gZj5jeZpr+VSqXATQdq3vqphc/n3ZQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jfokKnjC;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347D7606A322
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 21:27:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 347D7606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jfokKnjC
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-490d59c3f0aso1607785f8f.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 13:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864463; x=1795469263; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+ZKraDRr1i3pFiLzoYIEWaHhHBRYyhj/gKsvyx4GUpo=;
        b=jfokKnjCoBhGXval+BtxxMIEBcJuEILgvyGX7VwyLu6Emt86PG0cHN8zHavEn/go1l
         JnXO60BdmcgsdTFaKXKwOqVgTgnKxvxwuDZdga2JS6GdbOlVDW2WSZOvNyIBuw0tf4Qv
         RAvGWInSs/2O0ObHsKhseNZU76QAiuroYJMR8Mfw6u/mKdWrlCyyVnQXsOqyb/6w+Z0i
         Yg0nO/MHmkz/gLvmULkydyzWvLIWSx2UfOxq9KIjYxFsMAxV32ihPcPbvWf7DuMidRCi
         vSW74NEJbetjLwGeeuNOhALF8E+VDVV0qaT8Cg41pI24K0Mkon/0zMakEo/amjlR1J/B
         S9sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864463; x=1795469263;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+ZKraDRr1i3pFiLzoYIEWaHhHBRYyhj/gKsvyx4GUpo=;
        b=PRRanDQdhLnRhlNYHPhDK60aBLEGZBnB3GAnpk5C8eGidc4w1mLWAMG+cBc5VXHcLD
         tvowb1Zw7j1UeEfn6j/Yf6owWD3KrdLHOTjqt5f9Y0wXHGAzD3ggWVnyd5366RAaAIa5
         HIbLTU6RzSWSwznxmKoZ1OFzwlDmcqpASrtVYlsv3m2e42HUOfIfYLRFW8n2BkRbIV51
         LIY5mdVN65+13VHZI/YfM9Ib50gNIlU4P3D7qS6gP+PUo0gcTmMla/ssdu6/s//C/Lw7
         mDNCIkSEG4L7NmDOiEFN9269LI/FE+raHtwmKzmzRCWz+f1RajbMfq61JazW+thj3nlX
         quAA==
X-Forwarded-Encrypted: i=1; AL+hErGFl23UmmfEbEO90IQ0vpl+v/HYK/kuiVbRwnK/P3yOHlmVzJhtKbR+JegVTepodK2UznXbFl8tVu2BL9c=@vger.kernel.org
X-Gm-Message-State: APuU4Z84MKmm/G91RRvCjGbv+rOs+ixsv1i0uFb0BCLOv5ONpTIuwCSw
	0rIbaVf8IBENZn4MeCL4ba74UmO9lyMuL02arzkGJS9jxBUnEXSuRZI2
X-Gm-Gg: AZFdTZeLRfmR334QvdAm55RqEvlUOWyVYmt7l8BHolSUPL5//C9mGauqCTrY9yvoAjA
	RLpNPqgCfgUhBV9/b8wSOOOZ70ldpdXLnr+DtzYZ+JEgfGXHdFvKM7hkHTX5nymG2kXiJDyyHg2
	ucG+g6Ucwa1Mf0dOgoTtlgXDc2U+KJiuX3+1Avvz7qgVvbihCjqqM4NAEWvvEmgVeKL8CYXzMVM
	TJK52CJkLtyeIwpaAW/PE4hA0VPofWx17FdopnpHp7n9spovjTN3o1lBMUGEd3hySQu5deBG7tY
	bdedqhR1Ded2XSmAaNxL5D/q6xKfoqAoTeDfKIrnWO2tKP3WPM8p+Kp0jZgGQ1pb1N/gYQj20se
	EfjC5vBtGFuehfUUmfbATtWLyGL00/tzKFw7HSP6Ps1N8MioZ0ilNYgl1bPA01H3NMrJvTiJtJR
	vKYYFM3XEDRNpavTVU//g/YVCW6aPR8d4g3UF1Gmmv1GjLcULiVJQuCZQdHyUuWOFiNQkupQtgW
	VXGMpSccv52+uxvxim+7intR2bpi4r4oQ6flpn1PVd8YG5N/u/ViKesAhJyhDLd0Siibpiywbli
	au9oZ73vYd5X6GUM/OiwzYs+2nUsDXhUwRiZMKC9
X-Received: by 2002:a05:6000:438a:b0:491:36b3:22c with SMTP id ffacd0b85a97d-49c6e68dc41mr30686056f8f.1.1794864462819;
        Mon, 16 Nov 2026 13:27:42 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:27:41 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:27 +0000
Subject: [PATCH v2 11/16] dt-bindings: firmware: qcom,scm: Document
 Halliday SCM
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
Message-Id: <20261116-halliday-dts-v2-11-2c92438c6c46@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=1106;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=OQO+LwEeY64jVYcmV4r5bBUUpcSQt6/n4JPVT4Z/sxw=;
 b=lNijzEKQlyljkWzaxIS9zrys8uC5qiwJ2YpuyG3Kr+5tC+QMb+R4Db6kOwLBwj0GYnOv/QX+7
 5U/HlbRtrBQBhLGehnhSLzxDVWEhcpke2OLw7yIeYTlC6a6mrQFU5kI
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the SCM on the Qualcomm Halliday SoC.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/firmware/qcom,scm.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/firmware/qcom,scm.yaml b/Documentation/devicetree/bindings/firmware/qcom,scm.yaml
index 40a267c54b00..fb3da66443ed 100644
--- a/Documentation/devicetree/bindings/firmware/qcom,scm.yaml
+++ b/Documentation/devicetree/bindings/firmware/qcom,scm.yaml
@@ -25,6 +25,7 @@ properties:
           - qcom,scm-apq8084
           - qcom,scm-eliza
           - qcom,scm-glymur
+          - qcom,scm-halliday
           - qcom,scm-hawi
           - qcom,scm-ipq4019
           - qcom,scm-ipq5018
@@ -225,6 +226,7 @@ allOf:
             contains:
               enum:
                 - qcom,scm-eliza
+                - qcom,scm-halliday
                 - qcom,scm-hawi
                 - qcom,scm-kaanapali
                 - qcom,scm-maili

-- 
2.55.0

