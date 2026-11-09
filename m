Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184492;
	b=olPnFrbLFS/U7f+wb5T3KQKWNlWQC9/ofOiqqGQolzrEmlaNYT1SkF/JeKbsOjvAWNt+
	 aEvLtF4Vb3jk+GnqG0lW095yMdpL4xzg2coaPTJ5cglVuToFvWvImzTjbyLvIldgLyoHX
	 uD3w0r3vrZ2AAcR6g+/5kDKAZypbJ4wuPLoJABnQuxitZ/D2gv4wIUQ3tdKUp69cMf42V
	 HQ4x/A85iOS+KH9hiLlNqIAwugAFMm007hkGWHgOyMHTmQdvEbev7/tdfSz1Ac0LIYLg6
	 w/cgK96F77+3V47sDDnK4m1AkMPR1wBSICY/utprlnv8UrvDKmWG8I8gmiQ+AddwnHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184492;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=bqalaJtZ5/g9y9/6SBPqjpN1E4M1h8fqL8PuTjv/KSk=;
	b=bUu3trT429EMPJJtFOy6FiU7TpAgql9xgCvXDxFtng2PvMsQQBO4q/3kAt2HzNKWUXSd
	 zv4PLr7oX62tFIIIH8VTce8FaPjDj1tEDgR1RZ3tdflNBINpgZGn0A/y6HGa3Ch5iK/dQ
	 2sQ0xwN5+nWCpPk/SA7guyL7K+ah0UiqXAPZu0Xd+jJWnkxkxsbGup3gCa0AGciGDSt0Y
	 NX270Y+XhvYG6RWBdINwWLgVAVLJpQEPp2DA0olwoJ25ZOFjBH7Pivp34JoLGOTahGxyi
	 VHnsOCH5N7JaUxfhpRigG3OQJalwNlPNB0CTwXmyvhSbtjZED97QulJVPbTwHroBYTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=E4mD95aN;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C464606EE98
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 00:34:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C464606EE98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=E4mD95aN
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a549cd7fd2so2796525e9.0
        for <linux-crypto@vger.kernel.org>; Sun, 08 Nov 2026 16:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184490; x=1794789290; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bqalaJtZ5/g9y9/6SBPqjpN1E4M1h8fqL8PuTjv/KSk=;
        b=E4mD95aN6utgtguVmche9wruQufBYUmPr7se0FjMNh58DsSqVSMujoYr0keBmRpW8v
         uWQWheuyiSWXxKez1vN9DHsvkz3dIxygT3PejUT5UR97F27EKdO7WTr8MwR/DYX5j7If
         J5n5+NU+o62GTMTKrKJF4U0oIX+yriKVSodOXqH3bAcyiqaL4rHDO9eNXyjje0tgioF3
         kJjFsybCFmRigW6JjznYVc4hYOd89F4ZaDco6gDgRFm/z6xDqoQPjP4mGVKFK2BAHaN1
         NUR9o08rR/2JzDfKTWO51s5/9EiaI8Jvltmy1OQJ6WmNNyfpZkFqT0xbMVSgVs34YbYY
         WCmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184490; x=1794789290;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bqalaJtZ5/g9y9/6SBPqjpN1E4M1h8fqL8PuTjv/KSk=;
        b=kmzS0WlVPZIotrRBGdUQw168WJ8bml7miGaftpGMgwJEWn1K58+N2+RvYI4tyLKzbq
         QJtMSv3FKgw4QI2rPn8qigZTdIpkkW54BQkNYI4TkSU6Q5nCW44Zn3dWHT/pNGqYafvK
         hR0/ZVOnqnp3SXnKVt4TROZmBPNyXVEXTNPp3XwJxMCp8oo6TrQ8Ea8R7pD6wN93Ki3W
         PX3cxOEcfOHlo5kYIFq/jLB67onguGLlnBpilwqEA3WwNSKdjKgIDVux6rJ0ugt8cIf7
         e+kePd7vWEEH67VNrrs9bI9zfa9dv/ICGr7WxOjUpkRD8U5Njbq0S7KA1mU9r3SX7Y/J
         /j2A==
X-Forwarded-Encrypted: i=1; AL+hErFQGUqXjJXz8bCxwzsLo0t4l+pi+WhRPzFvRsYuylLbcDVbKoc9ISQGEB376c8nuXwD0QHYhBDX2u4Zdp4=@vger.kernel.org
X-Gm-Message-State: APuU4Z+Y3HSc5SiuVTIPN/jwqcBLzBZ42rpLgrC9GHffAvSrA2mogDZM
	AB5URCwyn4u8zp1XWmVRn7P7ZIZH5nVPHYfaezNwcQKZjlB4yHc7nZ7D
X-Gm-Gg: AYBFou3NCiMIAkY0MCTNrhF95pOFhI6nshf6/DJhQ99D9Xo5u4ErIb6h+cYJGmxdg3k
	8nAHlhfP8MkLVDWV+boVh8WQX2psSZH7G+Y2kTNnPUd5rb16KgQPFa9kqYSZP0Kk28dVKTyBB9Y
	ThYRF87xplpqCfQuJosw45P2Zn+DD2SY24hwbQwVX8fB8WTlJDj0aFKsiYpQXgAMEuaoyyXRsMT
	xbf3OofGsTZ5j7TO/fvwDYvzDb870w6ZhukJ5IuGWUiad8ZsMWTo6AnX0qExUoYsMcFfam/l/Es
	bZMMt4QzM+IpjUPfVFhbTwrUJ0x1vbwWSDbvXF9LQogMBLlJET3t3FAlk92K/aEv0sOTU/ZXdtq
	cr+RkCUO/3R5K3EDAc5nZ/XGQjUk9B6ySouqlX54/gspoVs/KYEpcuALofYK056C3/k2oYPPNq/
	tfhLmuZq5w5r7TuIE3h0QUZWMhXG/UoOtot7zWvzOFM0cKqtLO4lgEqv7MwMe+YsBkatLvGuaLT
	PraTd5VThjgSsjgDlGfXIWx7aglIZd8JafqJZlBDW8+0WJp40AHJSdl4CY98ojrwTg6L7bq7vRf
	L2fteLhjjmcVvs8pf4Ap+zr9kJ/kAjvsb2FcJw6w
X-Received: by 2002:a05:600c:6218:b0:4a2:1002:223e with SMTP id 5b1f17b1804b1-4b8205955e1mr111833455e9.7.1794184490117;
        Sun, 08 Nov 2026 16:34:50 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:34:49 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:27 +0000
Subject: [PATCH 15/17] dt-bindings: arm: qcom: Add Samsung Galaxy XR
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
Message-Id: <20261109-halliday-dts-v1-15-289114ab8197@gmail.com>
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
In-Reply-To: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
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
 Sibi Sankar <sibi.sankar@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, mfd@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, 
 linux-usb@vger.kernel.org, linux-phy@lists.infradead.org, 
 linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-pm@vger.kernel.org, Stanislav Aleksandrov <lightofmysoul@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=822;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=GR/L35KkjRTQHIwoej6N0ZVQiPJDeokJdA0dH1/xcVk=;
 b=+pMC0hU92qIlScFgbvyLG0yeciXJR70jYMcQsgbMkAruvtq441EcqoAR24w8+H8PddfDvxdW7
 NeEMu0FiaHdAmbbpArcsFtCmr29OynUnIXhIC1Struq0XQSLzW/yMcu
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Samsung Galaxy XR headset, which is based on the Qualcomm
Halliday SoC (SXR2250P).

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/arm/qcom.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
index 121ca557ce1e..b96ee339956d 100644
--- a/Documentation/devicetree/bindings/arm/qcom.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom.yaml
@@ -94,6 +94,11 @@ properties:
               - qcom,glymur-qcb
           - const: qcom,glymur
 
+      - items:
+          - enum:
+              - samsung,xrvst2
+          - const: qcom,halliday
+
       - items:
           - enum:
               - 8dev,jalapeno

-- 
2.55.0

