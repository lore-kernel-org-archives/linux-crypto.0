Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864471;
	b=WibXsWltJOeKFcyUskhbf5LN1J8HFVTy2xr2HdQkEmYxmUXfMp43uCDMl8+dUFZW/GHa
	 GyppctKTauXYtJ8InqIMz50ZdmIoxhtORN7YtCV5/7tlMUIvxeq5keou3yehH2qyylO20
	 67+/oaGw35tWcUcmZ9hkygCKPMqez581f06OzPiDENjHVyWSbYpKvS/JWcn3KWz/KRXwM
	 2dVUvxr5PdFwE5Fk9igmECpUMesfLzZO7APEhehei6MiYHK3Pnpn20neTpqWBkkELZ1ky
	 l+zMPO7Xl4rlwvzgqEr3b0FOMOuQtFFdHU+uuuPxWk3GW/DPijS1infLb075WBQdF8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864471;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=71llwBK2g5L/3aP4XIqqjFuJzuH96CM6TuERsII1mR0=;
	b=oWZMuXbmx7i1vPqlDRg/BGOb2HWMaVk2vlXY+m7kGZArg+70ao9PIqZTOoZDpkd0rAO1
	 r3fLBrEoJK6nS7vgtwmZGBTexUpiFoEH2ZH3dgvHhBVKFovEvvf6zfuC7ylR9VqoOLyzI
	 zTeHFP65BC6a8mnliO5p1SR6Bm6vpkzS//gMiO5AwRJ3WXvOX+ktoK9Pzjq8p+W63AuuR
	 iFFltP81iDdbWAHtmgExOlhCTYb4hvvvKRUKlHAlSp+FP94TYCjPXNLf4eZHFVE40NJcn
	 2wMisc51dQmdcMFQVJyE1Vtzz77e+olC6tmGpnYMEBgHAKsReZf4QomvxXnD3mIJbDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MtED5PjB;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D1C606A322
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 21:27:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0D1C606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MtED5PjB
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-49a92144733so1592758f8f.0
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 13:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864469; x=1795469269; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=71llwBK2g5L/3aP4XIqqjFuJzuH96CM6TuERsII1mR0=;
        b=MtED5PjBAUUX1nqVGeH4O2AqQAjGqMw2pZItkYtDZ5VuJIZvXrHDLRfGKUVRSYLhp7
         SadZH7H7v/4qecL7/xx2hxUwP5FH2yzEb4U1goYIN1px1JLPzYcbJc7lIrXIsf/wUUr9
         ldEtI2Kct9DtBpn9tXWr/qn5WDybofiIEEv8VD4ie80R2GT3qTq7ODRV/NuWeMXgnwb3
         PiMDYdzQuEcQdcwInEl7C5imlPaeMrmHswtQT14y31JumH5ZADHni9BebTh0lCs7FRak
         9U2NHqnAUtq8m5l+s2JJLL/33S6lQDYaM8x7ZoOjmFVDpE/S52nepPydk4iJbkjH5CDk
         UlWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864469; x=1795469269;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=71llwBK2g5L/3aP4XIqqjFuJzuH96CM6TuERsII1mR0=;
        b=ZG78TWzcLqGIa/MgPLTlWiAXiHwJEXn/ieyHVUGc/DsAL+KFWk80VuZT8ZjkGbNHiJ
         8N5kU/4FBU1osbgU75n4yXWY6xP6ay2sUY+O7RTa7qt/KMDjkJswG5VYruCrqeUJo8Vm
         YEPmtaKBOkaluBooADDfhQ6Vp5H+pMVzPhCRoWA0VssAXCGvVCrD4JYCx2aHvY9ZRdLh
         AX3KH8mpNzJEd3OtlFxv9z/1btvdfCj+PObIjJkLDqyrB1e7Gynh9nvCIF2rjV1HKcCd
         UTcsa8v7Z22tCIGf/3cwmpYQ51DERq4ocjjYgx0gp36tHEI6cLU0D2x8JNZx4nydhBYd
         Tdyg==
X-Forwarded-Encrypted: i=1; AL+hErEyvmSA2XUeoaMjt/bBtDHI+3UXZ3/zk+4kOqXK/o2u1f0kDmSK5QwV5KYt/Q7XU8PAZZshuoLWf5R3J4Y=@vger.kernel.org
X-Gm-Message-State: APuU4Z/yZI7mqx0KUVvsArV7dW2GL6h0pwuVY+lxomyUaG5eDBLcw76O
	8ygwGFdmiUbfGCy72tO62eo8lMcoXMG3efS5kpGZ7F7HrkhdUgOS9rl0
X-Gm-Gg: AZFdTZfPxKLVk0/xZD9+zUTMH7T1wB1bg0Cx9HL3ls1CztHNGMNVObPz8rI9Y1gv3Lj
	dz8ziBKSSsvnPNxHcznJ0nqZuv5v7XFzVfDxsXlJcGNNUxaxbqhHfHqSm8NXZEE2bMSd92CpXkM
	C9S+Vy8Uk4BQGaurOpTCZQ2JMiU+lmr0iVNpSafj/TSxc9sRSOoZ2IySnqhs/D54mSalB5irUed
	ZIpKzjZ0YJIbjWeyWKV5+jpx02fL41Prqx+y+We3ZYWfxcQ2UeS2kvaE8mfFQGO3hZ12822Gz3J
	aeP3i+JHtlhP/l7NngNtDHJLHUeCu9aEl7DOGZNsumESyN6XkhsYSvsD74ICVrNmgU+KTUZnG+y
	Die5LSn2eng+v+9+PwChz0BdA+ho9aEP266+frH/vREg/iREijqPqds0AO7R+2I+X4uDwHxXyyh
	O59GdqNh2pDRLDxsTEg4VhH8v0QcTAN5v/aM8dcgUIizojexfSL+fT2eWjjX138fGbHuo4iD/ia
	XMQixSZjpIvY6QcHgrMw61tE46jHBFo95CBYEWq8POHl/UM0fYtO4PuIhnRs27LPF6PLGgRuebi
	MXcC+o9Ds5RiTT3kYh304DlFcdYxUKcuFKqDshpc
X-Received: by 2002:a05:6000:402c:b0:491:4e13:fde3 with SMTP id ffacd0b85a97d-49c712ac654mr24445384f8f.13.1794864469242;
        Mon, 16 Nov 2026 13:27:49 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:27:48 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:28 +0000
Subject: [PATCH v2 12/16] dt-bindings: arm: qcom: Add Samsung Galaxy XR
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
Message-Id: <20261116-halliday-dts-v2-12-2c92438c6c46@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=2338;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=8VdPKIubIS5rrskEMQXxsc4CH/xmK2NlYtvs6kfcSuc=;
 b=t9apGIuBdbCgnaj0/1UJjnpEZvArnjOHWwiMxnYe/9rnq7pKBOWl7S4p0La1YJLjWlXweFSEs
 dlcpSLrFw/hDB74P8wfi7SGdvZuxbRKq1frXt0fWIbXohJzyyH4p/WF
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Samsung Galaxy XR headset, which is based on the Qualcomm
Halliday SoC (SXR2250P), and register the "halliday" codename in the
SoC naming convention schema.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/arm/qcom-soc.yaml | 4 ++--
 Documentation/devicetree/bindings/arm/qcom.yaml     | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/qcom-soc.yaml b/Documentation/devicetree/bindings/arm/qcom-soc.yaml
index 179aadc86a9f..9d392329d437 100644
--- a/Documentation/devicetree/bindings/arm/qcom-soc.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom-soc.yaml
@@ -30,7 +30,7 @@ select:
       contains:
         oneOf:
           - pattern: "^qcom,.*(apq|ipq|mdm|msm|qcm|qcs|q[dr]u|sa|sar|sc|sd[amx]|sm|x1[ep])[0-9]+.*$"
-          - pattern: "^qcom,.*(eliza|kaanapali|kuno|glymur|hawi|mahua|maili|milos|nord|shikra).*$"
+          - pattern: "^qcom,.*(eliza|kaanapali|kuno|glymur|halliday|hawi|mahua|maili|milos|nord|shikra).*$"
   required:
     - compatible
 
@@ -42,7 +42,7 @@ properties:
         - pattern: "^qcom,(apq|ipq|mdm|msm|qcm|qcs|q[dr]u|sa|sc|sd[amx]|sm|x1[ep])[0-9]+(pro)?-.*$"
         - pattern: "^qcom,sar[0-9]+[a-z]?-.*$"
         - pattern: "^qcom,(sa|sc)8[0-9]+[a-z][a-z]?-.*$"
-        - pattern: "^qcom,(eliza|kaanapali|kuno|glymur|hawi|mahua|maili|milos|nord|shikra)-.+$"
+        - pattern: "^qcom,(eliza|kaanapali|kuno|glymur|halliday|hawi|mahua|maili|milos|nord|shikra)-.+$"
 
         # Legacy namings - variations of existing patterns/compatibles are OK,
         # but do not add completely new entries to these:
diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
index 7ffa4f69987f..2a77382a9f25 100644
--- a/Documentation/devicetree/bindings/arm/qcom.yaml
+++ b/Documentation/devicetree/bindings/arm/qcom.yaml
@@ -106,6 +106,11 @@ properties:
               - qcom,glymur-sip-crd
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

