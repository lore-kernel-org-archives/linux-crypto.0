Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864429;
	b=eVJB7GOOK9tkRPVS8gU7t1qi+TDrkfhlpF8cv+qqeIPMAo3KXf7JMGd8IrdTn7GOjX3Q
	 dMocsJN6xUew3FD7ZzfWobii70h2ePAwslb+JIcg9VRgq9HFGlOPoWD0/Yd1Mcq2OkC13
	 KahCleGnCbzf09KGh/Xz1tWZ1TUjDMXqf4XH2DbkFDEte4C1V7RizBcHUasYPY1Pr3wef
	 rEOkrX2hPdFFsAErvf6722iBhA56EQjKkVca86Ip7/skKbHyNBTe/EECy5KR6sfdMwT89
	 AZAPjxbUsddsMrstwQQLisNMN5iR7hcAGkOtOFnftVsPXYlKZ4ODOO1Csq40H53/eXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864429;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=ro51FgAwM27DOCsfxJX1DqcXySD2o72+3qO5nSN9dQg=;
	b=a9Tqs2cxMAQ5IAh5fKBmMGnAVBqb/FIA2gnwiPIhl8pBUw+vtrJ+xOH/eVMvBbfdpuci
	 EOa7Di/qXpp1m/6x34E6XF6HRYTLgQF0FvQsE5+2PNKBwOjCJQuz41vqhhi/IylVGto6v
	 lwGK+bFB4fA7lnOJbotnFRmACokCTxNMc1Mk3CROmUia4uUZ9GcF48uHQPkqg7acPQvOk
	 I5YCBzrYg2ckIvUldCu4pQYRPLaLSpbNqi1sR7VAJ8BXr/jf0fHH3BoatRiT+vaH87fY5
	 IOovfz9t0NjLMUppTh5OH59TV/649fcY30O/KM8vAjRFqFUQqOs+HNxTesCs5ZHAc4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MxwUmdGf;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73040606A32C
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 21:27:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73040606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MxwUmdGf
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-490f38e9688so230646f8f.0
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 13:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864427; x=1795469227; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ro51FgAwM27DOCsfxJX1DqcXySD2o72+3qO5nSN9dQg=;
        b=MxwUmdGfyUtZntWN+dJoS07xQM0pQ+yVQaLKkkqz5GCWi49NfYHKbWARqZKhmg5l9P
         xd2SuFAw0lCCpffBXvhmGo2xZ9cKfJTe4nfCkkB9BpB2Ewjgp1tqMuMhU61bgBaeqDer
         UroYO6LTJwf9ez7KYEQngDY0mihFGBiJsqVzaOOYNpC2W+5MvHXboThdP/oLwUGq39Rs
         z3V0OzRqMtLQ8bMsw120HXUpxzOyVHbrTE5sD5sy3vWlDMJF9dGPmPZfIctKxwRS7q/O
         Qo1H+zS0NL/QScukZH8Xbrny5RwvwyeLCvlSK/QSvqJ0ZDVKOmrNlWLe6r9KV52N5Qpb
         /zUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864427; x=1795469227;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ro51FgAwM27DOCsfxJX1DqcXySD2o72+3qO5nSN9dQg=;
        b=xuG9oUDU/0Zgq6joBdK8FomsZHi5VBLFFBlYx4SeaTMSDye6L0Mdk9LkOKhtd5wpcm
         OwyUUAwjQORWt0ml5bCHUS5WZVsS+DR3W6RjtgzrxTa4LqHIX5CuJR51LCIU+HQrPU8Z
         /Et+2+YOHgJ+TLutFtfeE2Ei3wvPHHocT+uvDRY1oJeEUGuV92o2S54mGhgUk2O3QmFj
         L+j91lcT1Y4IEWkyM4rc0SqwgaQbYIebNw2OhbLs16uBC/3dDil4ju9R01m+s7wG3LOd
         zvTnZXThOSjyvjIP0tV8QqtbEEFybmhTEnSYJihoFo5S75tvr52Av7R4U29FO7y/uAnt
         C+rA==
X-Forwarded-Encrypted: i=1; AL+hErE5XzFeZpQPQiaYL6Q2gMi4OiCbCzqTsXCCQeEAxfgtCD4tr4qYrY/1inQ9w9Qz99bypLAkJxafA27un4s=@vger.kernel.org
X-Gm-Message-State: APuU4Z/rUz/6osVtK8PDOSh8czlTtRb0ken4LjoukJuh9/V2o1otMOeB
	q13OcoW8owFQyoxuI54FsD/0yG+PqMyPfhtQSHeQyYxJkUWtQWHjuV0B
X-Gm-Gg: AZFdTZeULWgtwH4EZlo2ASHxfyN/0g7bYaICVEXMD2pDOR8Y9jH6KMSGBB8MSCNtuCY
	fgeFdGIuALbtM1j3Mp4tMDTeWrYwylvhnSKS9aX2k5L+44fDYAmiMf1rblqg8vDxZ2xTFj9CFsz
	FRS5Qwkf0KwCDZ0AB3RRlUtcTKFc3Dp4yenMUu7lVbYiiLCrrMJ7t/q+dVV6KJlwN2x0Bv1/VUy
	XU0GQKBhetfrNxCbWkSd0acLZQfvvDdYruJVz06exRmzADqupVzoMrfky+QTOa8v5fMpu8ONlzx
	x7/keEjRbApyJult2J0pDP/hQdIV/IoKPp2SgeLfaOQ1BWw6CUbwy5FDY2THknY7OB3UsXWfzWe
	RBIKfWiLALlhDIiXp/phX3vFZIg3DkxszWsLnvR7fFlhusUoRRWyBaRQrdU7Iyt4LrTKZQCvvTc
	UHCbkWAAQzdBFbHGKc6/lpoAxJMDnnB1HtdEcYPp8MliYLzSBwq3tHIJbIqZjyhHu5zb0qqe/Mc
	FVdCQuByab9TLbNfUVOudBUUfm3yJsRq0tsuoY9uWEfZtrF66GhEh3JatFFnnM5px2bWjh3wxW7
	+ShJL3j39ufYI4Ci7kbR4JIJapsaUU7NrWyg/m9BoQ==
X-Received: by 2002:a05:6000:4a01:b0:48e:7833:2e7b with SMTP id ffacd0b85a97d-4a36c30c79bmr1458441f8f.1.1794864426917;
        Mon, 16 Nov 2026 13:27:06 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:27:05 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:21 +0000
Subject: [PATCH v2 05/16] dt-bindings: usb: qcom,snps-dwc3: Add Halliday
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
Message-Id: <20261116-halliday-dts-v2-5-2c92438c6c46@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=1289;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=cCyX7eu7E67i1+mb+zFb+/V3MZ2Z8Bvs+BbDvfy8HQI=;
 b=jodb8KTCYJuS0IWgZE7KB4t4x5w4vx+XqSva6vd9XaFcHbRLapvwh0kujvjIVh3aEijgselYV
 FDfNsOtrAj3APDDTnmVV1I35ZxWejVLlN13Q6QOSjvxv3VTGu5EUwMp
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the DWC3 USB controller on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/usb/qcom,snps-dwc3.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/usb/qcom,snps-dwc3.yaml b/Documentation/devicetree/bindings/usb/qcom,snps-dwc3.yaml
index b77c02c64d45..7a8b72d2929d 100644
--- a/Documentation/devicetree/bindings/usb/qcom,snps-dwc3.yaml
+++ b/Documentation/devicetree/bindings/usb/qcom,snps-dwc3.yaml
@@ -27,6 +27,7 @@ properties:
           - qcom,eliza-dwc3
           - qcom,glymur-dwc3
           - qcom,glymur-dwc3-mp
+          - qcom,halliday-dwc3
           - qcom,hawi-dwc3
           - qcom,ipq4019-dwc3
           - qcom,ipq5018-dwc3
@@ -209,6 +210,7 @@ allOf:
         compatible:
           contains:
             enum:
+              - qcom,halliday-dwc3
               - qcom,hawi-dwc3
               - qcom,ipq5210-dwc3
               - qcom,ipq5424-dwc3
@@ -570,6 +572,7 @@ allOf:
           contains:
             enum:
               - qcom,eliza-dwc3
+              - qcom,halliday-dwc3
               - qcom,hawi-dwc3
               - qcom,ipq4019-dwc3
               - qcom,ipq8064-dwc3

-- 
2.55.0

