Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795578223;
	b=hICG0681TLC7djnC5I2J22N8RKZTru4AzndE3CH/vf5dXuqydMGL2i1IhS58F8nXeeS1
	 vt8tPo3qdevIEEz28obkA9r9N/UN3UyGa+kf2+7PD3/0V1aS2a7CHHYJhllddCkCbbYjd
	 6Ve/z0M0hd0IAPi6T9JUjjXW03tHeDwLd3EOFoUDJuu/N9FK+EWtYx+TQ2cNcBStoNqQi
	 qca5SZhwWBrrInCo+tLP+e/6eTCxd1hjOB7LazVR+8+qh6/aOLgh7K5kP563fZq9Q+hn6
	 5i88MkTpMa/2iiiLh0yjKL3Dotg1TjwkmLwp4AVLzUBt7IAeNTZNt3YLXjLNMou3mSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795578223;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=dpKnhnsaRxCp3BhNS6dMqX7R85atmEMYETrpv/6MbAE=;
	b=eNjkjLIQwcbnrpGhVguvhzczldJrD3Xh9B0SiUlh/MdQlGfrkYnFZzRp+2RVRfr9BfWd
	 YJ2Sr3SG9OAfTDXvCBXpy0ekMlnl+prTK+Q7LQJkgKZsKEuwAnUt3FfL01Doh5PXF49go
	 p8GbA8uvX+lIQEQ/se5WehJQCSOLz/tR1DynVwvMi4fun8kIseWi9ylqYAPXp8igq3lOc
	 jbA7hF/8re7Ktg9Dr36HxveaLBhR5lPEk/lAvf/l5QUXMA4Kel6GP7dIsaazoa4EReI6r
	 Z6081S3bSU2DBUkulqIESzQ5yrWqrXq1uy1iFW8Rxd9wNJjV3mziellTEB9LpvAcb1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0gL35YaP;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBAB606A327
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 03:43:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EBAB606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0gL35YaP
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so35707915e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 19:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795578221; x=1796183021; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dpKnhnsaRxCp3BhNS6dMqX7R85atmEMYETrpv/6MbAE=;
        b=0gL35YaP581fK3jcOJPups+fF9Bbf8JIZtZt5mMf57n60XTFjn4kYofnxX068yiYH5
         FuQ0yvkMTBi4fEdB55IabfGWqM2T63H29uww7lNh8DHLTv1kOBJPGaeo3AMOqMSSU+X6
         3LdUBD9U4cj47O/R2+eBKO3iISBcpxscvMpW/pqZcRplromX81Z3/RuRNnC5/EG5rPmk
         BQKfdN7YeHa+gsvJFgUsSAByJJs5MW9Pda01hnPON69QF8pF0jxAMkykIR7oUfizwaCg
         kbnLzik97Yu5Gv5WsFhSEW86b5D4gcno5s7wlSNmKItRT/jR3gKoc8KIJ8tUtaqOPD+Q
         iaFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795578221; x=1796183021;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dpKnhnsaRxCp3BhNS6dMqX7R85atmEMYETrpv/6MbAE=;
        b=HIocjWHLoSpu9k7RH0jy7nZXMWxQG3cIdvjcb5+CQaJuRfaMoAxuJJRGLvZKgDy8es
         q7939GxH8KqDuc7qOuYqJTPQuJkqELgFQL58/Jjqw55fQqUTItmLBiKehV8V1ccWhSrF
         Y1hTKLP7ArEYKHRhJSCm+ohywqwax01SDRseROqPZob0604QF6vXNh+7E2dsXDBg2Htm
         q2zVLo6BNpuC2GagxiYh7oKdcR93KFui2XR7yN6v+zwWgp1MPXVrMvt2A+IcCRMLI6U4
         nb4XYsW1s9e81zjwdHLQXvSY3WALW1FRAiZz+FsmcPepPjJRO1xUfsEqXKqdeP3Vrp7A
         59yg==
X-Forwarded-Encrypted: i=1; AL+hErHu0x16gzPxQdG7qcPqbhnMtuhNk2eqVzXSRrBcoOugIo2yLotiunVpJvy0ketKB+RUrpkGm5v0kNySSJA=@vger.kernel.org
X-Gm-Message-State: APuU4Z9y5Jt0kX35Affdl2s3ztb/xRlw6sLi4NgeUULAhFIpJEPLO1uf
	g4FCo2J9BGF4cu8/8f0DtYWncIaRTXmfYwdpcDJzHP00tvz+f9iIi6KK
X-Gm-Gg: AZFdTZcLoCBhrUpFz3p4QjemY/oVJ0yRRlmOCtOnh3u1A0PM6vVCuhLeXAbZgT/bgII
	5EqHSoaXH5uxe0o1xjPDLOKxoItdaa2vN6mEV4sbl2sisntpGeOVAaAX2nlZqjfX4wd3Sa13q8M
	ixhXuIWb0/jxgSua2nkBk/Nm6RItSiAY63SNe6cz/rj+araXXlxsE8b1bswKNW+Q2+UZ+UycYxI
	pHmVVdio/p343UmVEgEIoUwSGpZUxIEdvc/lt+oCcmVdaT5uOeVBZY8HjEvg65NtSpN/JFcMpb4
	n7WZp2W4RZPVt7T3dm6QqaLp8rMTrYqXUtI1b8RV2pi/nMwYy7EMWF8IyKYGK1zzgoRbSrUvNXQ
	3kcm43PcoOgyvj8peLogy3DgeCzTb4pUHXJsUtC8OB/d/gL4PSzds56hXzYmO9eCGX8pe+1/8lJ
	z3HEeQM5xhlPM5Xmlsn2NbsdUcmoW70eT5cg3shL+sZ0ntHpXEixM7hofwm/HcZC4fQmAiN9s9d
	PD/SOBzeJbtRCRTYY5urQXO8rUIFujwWq+p98BRZ4O2Q5LV+DNDDa0CUOuI6DKntAyZNicObYYq
	ijYlt7CU5AknjH8+1wrk8XwxTw7yR8sxVrInow==
X-Received: by 2002:a05:600c:34d0:b0:4bb:6a5a:7839 with SMTP id 5b1f17b1804b1-4bb889428eamr328092505e9.34.1795578220699;
        Tue, 24 Nov 2026 19:43:40 -0800 (PST)
Received: from [10.32.31.239] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm391107925e9.0.2026.11.24.19.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 19:43:40 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Wed, 25 Nov 2026 03:42:58 +0000
Subject: [PATCH v3 02/14] dt-bindings: power: qcom,rpmpd: document the
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
Message-Id: <20261125-halliday-dts-v3-2-5c8311c0b70b@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795578204; l=1076;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=2tteAd38AfHrvk8Awl3RAniXNSdGBzL0LwEwE8e7LoI=;
 b=5C7/JmmmJaij3ZDCjC7taKHJ7ftfQrXNJKeux4QbuaH+Zgcx8qkDlh+sISv0oWyhLHGJ/5oZb
 fvQPpset2HKAWFH7uV37/GtdVaAFBb3EKxSiKjnd+R0Yi73lf00uJQF
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

