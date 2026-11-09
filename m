Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184447;
	b=lAeD/MJRLlm4iCmXyCi+Le6JTv1osXlFAPSBk0NKNuuL0lVYqPrtlN6XQ2csJJSQiigS
	 fCXJ+7jY0Vky50QD5qFYzJpl/5wVfzJS3plW5qB1rAsN9qB1em8i/XXTu9N+eOhLVIMez
	 oHl4WsnD46vQUv0IT6cqotzGNn1Y1Eb7DMOKBtNnHZf+vMv+McNOZNZblWmVopB9Pcg+5
	 YieQ/jRBJXECob4RSc6+NxMT393jqxXLLixSFpM2Gfs6ZuzXMOo3YAKmT8izGu2FH25Pu
	 1peYXD1FZzmQg7QRPHYUWXJs7DIGG0+XNuwEZDg8sW0qv6LKqNXQ1yf4zlDPyD8MMOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184447;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=3GDSoMHQsxRWl9RceBND7eXD7fNs4JK2UCz+AN9Gniw=;
	b=NN0k5gCy6Fhnmu/Hue+GEc6U+K3KRijXLIT7h2ts6PUHQt4cd9NHQ3p7ki5X5MqPtabu
	 s6MbWnhDgFOr11zW8PQoGpO6aH9Yn3ey7jn1LlpeSaHVP9/3mIC7gBbWrYWwkGHlehH1l
	 HDDV5Mu2VQayzEI2iKNMO3wpqMjMUV6faHD4V2hVMWQOWc1U5SZutwDCGeEKJeV+KWPbx
	 QfUm+PZKFfMxyX0XO8iOM62EHXlP8or92W5/wDuLLlAd7CnxRs31Qan+jae+s/GafRg7X
	 zvmPj73HDGy4hHAc3SL6Wvb94BjXy5nslIqj1M/6euB+8kp7HMCCOQPnL7JR+HsYpbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qSlqzKjX;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2434D606A330
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 00:34:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2434D606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qSlqzKjX
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a215e64962so3545095e9.1
        for <linux-crypto@vger.kernel.org>; Sun, 08 Nov 2026 16:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184446; x=1794789246; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3GDSoMHQsxRWl9RceBND7eXD7fNs4JK2UCz+AN9Gniw=;
        b=qSlqzKjX/7sPDCZRvmng2Fd7M44NFkTn1QnTKlon15ILFRt36QNjsrqLJYYai8FaJT
         xqdBUzCmut3CjikZFdWRXcM18asXALumcNCoDZ8wkDUy/vLNU2Yu18uXCs9ENs9OPJGu
         nTOZcCyszK4wAzAPo3RgIbwzygxedCHuazWjHdx+F6NUU18zcCBMt/igNH+VXF7b6oYH
         qlTinMkSbUjNgaZL5pqDSb6HsOSqrLuMpY53PyfJXRmWyJcmK2xZiyNp6qhlx0aMWWyk
         XD5wvPWvs0D8+P9xSygLy6qITW/i8jKmud5s6HzgGS2nR4vlHSyW1pd61/CmzpTA+ZFX
         bwfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184446; x=1794789246;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3GDSoMHQsxRWl9RceBND7eXD7fNs4JK2UCz+AN9Gniw=;
        b=Vsmje0wy4+7K7/y/KCi+xjQZ9HfBkzIOBVP9F2BmGDgVKEjfaYocZGMfLwlVzlbgT4
         CINjey7drBNKDcOnWjuUdnsev9li4blv+r5GJhmr0Cg3vTmLJ4g0neUG6xqWcGJN2SFV
         U15oAHfbYh7lWt8sfUUMxDXhhkvqVj8rE210KZtlVyi9HBz7+Dsgi2c5j+yyz37tqHRw
         yN9WRjS2szcG2oLoMdFEmQ69XBWEcUB6rWTjSPpMESTr/og7QBhORh1aJhUWBnprOT6p
         46sWvwXMvTwJraAYdrB8PiDtpbwZfb7NrfgvTPG0lS7PT4RpKp6FIGm4g9yZvJJ+Cqsx
         TNsw==
X-Forwarded-Encrypted: i=1; AL+hErEDEdzvjq8s99f3ffI6f1buXUrV95Fn6gda+gNUsRn+YrCgzUsp2opN/3J8yEkK0ZIVM+A7i8aOCGoT9m8=@vger.kernel.org
X-Gm-Message-State: APuU4Z8ssQtM6hGE3qPpeQYRxIWqhAZXzs7KP4/e7+wcA9iD6bedmhQp
	U/y6IiMRBtn2Ip76HcFbR3fQ0Mv3qeiuNnH+Cv7rKdfdaM5uAAVgypg7
X-Gm-Gg: AYBFou2XYfx4/DSm5FDVi2tSsJmKPkxrotQqs0rZRKQd5QhW8ZKR1LBMbdSa8KWpUNo
	BaBDxAij2/Qgh/V7TtAMf9tWyCq7SspEDHvQT4CWEzFvoj9qnIQJuPqWwIAf2zD5YPf9FP7pENM
	FNutQe+H8Tz9GQeXdaI4oIdhMWor9o/azgbaS/SJRvmqgUVhVttYi/9LIieS+J+9GsVUSjOlMRg
	s+2q0o+G18ZKgrnqgDvsIrTYgBLYhOyPVM88X3qhdjFGcLZnzOTj9jchbz8cLFVLPPJ0brX3qNt
	jiQYdpIXYadnAopLGfWkFrMkF9qZKMG2xF3g9DxJGanviMObbV4rxVWPkX36Qw42TcVWr21qnrq
	PAKYd3an5Tu8ktvdgCRkEUh7hGeL7G7GxjPn475M6EDCWI0J8gA0w97WCQnlqjk+44p++ojXNee
	RCXRGCNIhr+Jzwxb+vzg2tvbY1ECukpYQ5DnlMkl+uxlGajd3D6zBTbfvy5xrEtqiPNmEh5HT0L
	moVpA4p4XdP4Omq+Kjcmj65qgKukQgZaNS3e8IYaw8KNEQmxnghhzb1TpRgOGz4zZFyQYBWfdFj
	QfdV6++wQwU8p52sHwsp66hl10v0sVUv76CQKYSa
X-Received: by 2002:a05:600c:a010:b0:4a1:c5eb:b445 with SMTP id 5b1f17b1804b1-4b963ca3a7cmr51069905e9.35.1794184445733;
        Sun, 08 Nov 2026 16:34:05 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:34:04 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:20 +0000
Subject: [PATCH 08/17] dt-bindings: phy: qcom,usb-snps-femto-v2: Add
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
Message-Id: <20261109-halliday-dts-v1-8-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=891;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=iomST/Qr961He4Ne7crBcxin7EtHuKLr8auNEsY1c6w=;
 b=4DxRuDlo3Sv6o3VM377FCKNLzrNNMHf6FsM5TYa93t66FIlBhCp/mgcC4QeOncc3ZgmuRzx3Y
 hjxDAxOeJv2BA5u50QEvvg0b3XgcZ1hYXm30qFoJ+yx+NwOICn4vuuC
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Synopsys femto USB high-speed PHY on the Qualcomm Halliday
SoC.

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

