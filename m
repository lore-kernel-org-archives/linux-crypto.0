Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795578218;
	b=MHTOAwFOeswHS7M6J5d6N9TA6GttGvSc482WhlBZaIK2DRqb1GVXM9alM0CIJpYhCtGb
	 vORTBV2/9kyocabROmzoNiUKC4s/Bj7/y3/+SCVdn453sPm7Mmrwnq/Bdw7xJehtV8wye
	 vxIrCAYo0ofxjYjgc0MigclWP1AyZRc/J/rkITdFyASQc4JPInqIw8wwLV9LJA22BMlZv
	 DVf5IXBW+cJA+mZbFvzd0+6E14p3cquqiqe5JQwyHNKMbc6X1bU6DYh2lkMT+Q2SKSBEd
	 JlJI5xs4bj8hfz8Ow7zNGyyFpC/q4Hl+HxDkjmL0tNd8XI+nLjunJEN6D/Nr28ml1CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795578218;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=drwleRdoQE3pkKiq8NvL3TA0ZreOLUUT7TR68lPFDhc=;
	b=YVp2bNdB+N+AixyjvXuRwp+I8z9vPoMiRY+VVNs0x88+sXbqxzc9gsHo8UzEMUWRZBc5
	 jIOSA/c9OE2FSWthHIZwDwYmQkkpweU1LyRiGIX9rkr0omfdvq5iwd73if35F0n9gPTiD
	 lImpOMcs693NBGYThGF8l5xWXPI1G7/FC1WPc9DhNJrJthqiiPGNUyOutZagKkrDiC1Pp
	 VtOXVtfGOf0XO0L5K3F/woVC53tPTt/THLs+smKx1kitCnXI1axAxbW55Cy1sHrm1Pp6p
	 +iIBnu5IPyM3NjwdtH4JY4ERIvTV3IZPg4MOg82S7WLAoaXeJxxZbaGiPPaHTEZCI9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UHm56pzM;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB55606A32C
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 03:43:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EB55606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UHm56pzM
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so41996625e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 19:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795578216; x=1796183016; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=drwleRdoQE3pkKiq8NvL3TA0ZreOLUUT7TR68lPFDhc=;
        b=UHm56pzME5QuJjhiAlkwHOpYeDJa6yB0YSYI1bvu1L2C1K/b8c8JqZfqvQO604D27u
         kbijntCdsTmXmZuyEXTOb3UWjibtttn9sm4yIUhv5BWWR4I4ZkBHypc2EQoj8gClP2kH
         iWlUwFG+ksAX8PfuGzyqwgPWimGWoKbwCaHODUEXgT6GTXr7IYQf2wZ866+zITCViM9+
         cWdmBvAUOA0q46kcT5cB45N/Ty+c6kaDy9tabJMeqja7JP84/DXzhEmYtOJHcJix8lMn
         ap6y5YurBKaiszdHFCygN5ro1OeYnibVACzFSOUr4CNcobuqzEvh4D1LFkTgVWGuKHY/
         cXww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795578216; x=1796183016;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=drwleRdoQE3pkKiq8NvL3TA0ZreOLUUT7TR68lPFDhc=;
        b=WYGcfTfKgPS/fZMJxb+agFCmqMVibkOzuAYjy7JO8GcNJ4oQQrgUrwTJ5tl52vhMUg
         q5YHtCcFAOZsNhWfS1cp9h/y/iPnuK/hWQwsw/+Oeekxw/be3RkP8cCKIqmbfw2EwsZn
         0pDP4r2hP20xKfuEA02Hlmw3xkZmnoQXL2keEOW2PCcwoKePOc9pwxRjym2XziHs66i8
         VH38NoH65b1Ok8FoYYhN0w+cERH5rXCeVIFKjkcxL0NLS+7PJYD5wotI3FVTmOIiolCQ
         NbWcoA9l4KEvdV2Gfh/9nwu84JANcQTbWh0atnMhgeoY8xx7irHbxFfwKD8+gwXhHrrn
         bHEQ==
X-Forwarded-Encrypted: i=1; AL+hErEjNzNEjiE+n1gD4RKOHZexSEltQTpW7hJtHi54yjM6HBatLI8Pk2ZBDU2J+JuRShpENYnT3y+OMxHyGic=@vger.kernel.org
X-Gm-Message-State: APuU4Z9yD+KC11MHNMIydTdARNxKWmLkFUKb7q0AcBv4Tme9yWlCHr1D
	xB5w/Np163mffR2pDycANl/22zAjkDWw7GK4niZp1mWthLHlsLb1Nhd/
X-Gm-Gg: AZFdTZcoNqj3QVU8qJ5JENzzZjaCJmUsLJpNScCb9gWmRnUISC4rDsjCCsP6hwccGBQ
	VDCkAJbdQYhhCt/BmyrLtcal/WDyMXznMLNJJdsThqOdfnGgVWileXur78myBa6oVfZ4qu6wzoM
	rbZoAe1JZKh9vHRLeq8G3XKgOOPtxlnV61NtlnYX0S/8AGvDOLdSluFjn631xL9uFGmdMtdxNud
	cfaanfh4pfQV0BmGgaInSD3bqST6B1SQcW0y55cw0vavtMlWPaQIykazGfL+oiV7QfbvPAlpd2w
	tOC8BRKP4/iUumCNWv7GMD+hMswB9d56CGxNscdTpfc4N/RmZ/xe9BHN6o8rwkpw257HTDNUW8W
	QD9CDATMP2vm8Bs9CA9d9pml9rPPbEcWhyNb7KsT3+HTQx7/gURiiRRWQjem9+bOTsFGE/tLWEW
	VV16rl3UKJHvI3vTffwU7upyyL6hdjatWskWQcBjp4x1kLw0l4VZfLQdb8T5Nl+7xo2vkI41HGA
	+awDfwrvTfkorDizDVx2YKdJzS1Ys6Mjge3iqqnLhWxyqJOEdc+1UCdNklJckoR1PupB58xznR3
	D7I4yOTHYPU2XqtJ8u/YZCXM2Xq285fbwnLLKQ==
X-Received: by 2002:a05:600c:1d86:b0:4a1:fa27:df7c with SMTP id 5b1f17b1804b1-4bb88922972mr346329005e9.34.1795578215688;
        Tue, 24 Nov 2026 19:43:35 -0800 (PST)
Received: from [10.32.31.239] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm391107925e9.0.2026.11.24.19.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 19:43:35 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Wed, 25 Nov 2026 03:42:57 +0000
Subject: [PATCH v3 01/14] dt-bindings: interrupt-controller: qcom,pdc:
 Document Halliday PDC
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
Message-Id: <20261125-halliday-dts-v3-1-5c8311c0b70b@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795578204; l=910;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=TIEe9N/cyAzKgpuoZBtDZhrBfZnBIMsVZBId/jMf7sU=;
 b=h6Yv22yIDPhl899/gQR/dzgzFCiAwokqygzx53AniCMssmz68nf3bAUZ4boIxRmClQQzRo206
 0Yy7j0zKrrDAxm4EozqJW8b/LA63zgVJosiVzUEWd1tTWYtwAKtrSzc
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Power Domain Controller on the Qualcomm Halliday SoC.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml b/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
index 8401d3b48e0f..cf20041e86c8 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
@@ -28,6 +28,7 @@ properties:
       - enum:
           - qcom,eliza-pdc
           - qcom,glymur-pdc
+          - qcom,halliday-pdc
           - qcom,hawi-pdc
           - qcom,kaanapali-pdc
           - qcom,kuno-pdc

-- 
2.55.0

