Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184422;
	b=rbWcS7esgZqqI/gweeHUU6NmCzGEuHfN4Qlmd5uBPLTkGVIFYBHXXQ/NvWolqYB/XNIC
	 VbDhuhssTaWIqn8N+yn8xcrHO0bfYJOG+MIualyO0UQQztRZqOwf31+5yJPnXZYjg7q1Q
	 a3eL0CfOUnsRzbXP1ghjldrToqz31N6sG6akgglTxq6459SKKeBYX9rC8FjTNTuz7OSrA
	 jOEDyRlSh0GJsAuAVdgQWdw0pQMGY9aUGOx3Mn2iejPj5rUVIUXnoBDCtXxGGicfIsF2i
	 eIlA6biYIlv2k5iNOSOus0bNVrtcQpNtnAzateU4qT7eJKkDrmMgGgXHpjGBXNzH8BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184422;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=r6Z+1pNGTBfmPrEnFxF8VVutZ1rF2maRRdQm8+3OOLA=;
	b=odm9n5WoocMdsw88oPv1sbQ0RcrFgExMIiE8HtkfjsWfgZpWp0kL0IpGhPYzJbUc7p0w
	 GRKBruyANW9HV/XdJ+pHv3G7KSYWb9QPO8CAAImFx3b+0iZxhId6jen/ZpZ4k4ehMakZA
	 jQ0V3C2R52DxozcF2AwUD6uCWMz96mSptRTU1bSJ3tgUjayYwSLE/bg/RKYRLpRx7NXEG
	 ARKBcYsQ9pgratwmVlNjjLSiG/btyFu4kcULkTcjWPlnHZPQtDaJKpMk7VwbEUglIsiy3
	 F/oUA63stmqYpyzhCH5pFWgD7gH1KW77hBzOXNkCUJ2vu9lED1440GQoIsrEnoME6Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="uD/fC9fw";
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA521606D81C
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 00:33:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA521606D81C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uD/fC9fw
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a20bdaf39cso3337955e9.1
        for <linux-crypto@vger.kernel.org>; Sun, 08 Nov 2026 16:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184420; x=1794789220; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r6Z+1pNGTBfmPrEnFxF8VVutZ1rF2maRRdQm8+3OOLA=;
        b=uD/fC9fwd35e4pRCBo6Ir49OZrB2lX+E5PGdQnHcUkYxiqu2ZiGRETZ2zJmW8sZlTd
         A5/c2Xw6hipV3YiwOTPc6CN0uAO33PQjgwXUPiZreZzu4FdcrszHSfLcFtjRZOPT3itQ
         xle2xxFDmZmDqyMCWSs93UsfOpeLxSN6ue7xOrrEm/NzYT0xzZK/eCHB+h5f9jiXpkxi
         ypgX50w+AjK0hyhr8W1Y5z3Zeklf121xyaUU04Mnsch0HJVE6Dc9AjOAXq0dywq2opUJ
         SUXNk4QGfcfXnyUDSGqSEEHPKlnphwjmf7JR4/7BbHKuz3djlAWOEVbyJKz8FiaAylH2
         4tDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184420; x=1794789220;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r6Z+1pNGTBfmPrEnFxF8VVutZ1rF2maRRdQm8+3OOLA=;
        b=JL7W2CbApkbEzSarUOEuEaPcvxeeH5mUXFSKiyShLLpcNKYVSS427QHOlnCOmhq7iL
         Gb5pgbcXKxiwaV1q4E366EGywuwQGoE0VaOp65ccoUIPlAjOOnTHcdbBc3n8sqFbCpql
         T5H6gMwah8cz+38/dfkUFKUMPpSAbs9UrKsrOuC8kvI69JW5m/EvWFc1QUVxXdsozSvf
         m+bU1k4dFLBRwJzQoZ6XqM4T+3nmsVpod+O4SWdVAyRCw01G/dL4CnYl2xMKltteZEQ/
         QEipPOGtpDJ4FArVyrFzdPBOpxEDeK8D8Toy3/X/aIge3jgCLswFWdodc/5zSD5NC3SD
         aGww==
X-Forwarded-Encrypted: i=1; AL+hErEOFk50R2JziC4mV165I2qqECaCMWKIOPaf4JvjRWe7xUU9Ee208YAwWbEcXxElcTkfOme8GaUzQAyGZuc=@vger.kernel.org
X-Gm-Message-State: APuU4Z8Nwjw7P9MtgfiIU7T5ygwwSSCDl7L8N7/g0y937KL5ZyaJaktk
	WNIam3Beb2j8ia2fwsw8d1UnXJ+p3ir0g75aZDspnqdoUJ9PJEP8gwJj
X-Gm-Gg: AYBFou0XactYXAjeW7UE3dVEIVkjn32GpJHCY6mOmla753OPam830/fdrR8WrrnxM43
	lPVhaYeQZ0kIrnpU93kF8VGwzlSsr/MKH65+pjt0oKrBJdQpPI7dS9iRgfSvFufeik+vUAKJn9/
	86NsCCO2fAzQCBiW9CMWNATIGmmv3WS3cC/ZvYhIu+BXU37kV+TTx777OyhDJMAZIy4xI+8WuJ4
	jjhkQx4HzWDGR9dvoURIpbHh98RvdkDAj/w/M52cn07K5zdbLmGBNqOXV6afs7qgP2pMOxzf/kA
	OFgiZ8RbkC15RYrGLTfZIimTcxmZeeqx5YDHoO/Qnp68FzaOT8WMHgUg03c7XRMRASlCkWNFvct
	K+fhmtlN2oVxixYxkNLz2YKjeWg50MoaO3UtbeQI7H7Ntl2iCCVLqi31/PxHWRapZ9d+tMDOv2b
	6Sr1ooZR/V21eNwyY39BlBjVq+qOiHDhBGArY5V9HQZFPxYSGi7VRek5rRpwbtBQbqZv0SYMG0N
	SA4IiwJ7tIx1iUCYabhxhMMbUeSMvF8eiElAp8+gXt5fpB6+MqDPS7Cb43T9Gi9f53fUjlPojJB
	uUSCIsCf/mWFhc3SX+FyGzGp1sXXf0YKBslqt7sgGdmrda88P/TpABWk9+1gkw==
X-Received: by 2002:a05:600c:5253:b0:4a2:a3b:7aa8 with SMTP id 5b1f17b1804b1-4b94d762eb6mr47593435e9.3.1794184420329;
        Sun, 08 Nov 2026 16:33:40 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:33:38 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:15 +0000
Subject: [PATCH 03/17] dt-bindings: interrupt-controller: qcom,pdc:
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
Message-Id: <20261109-halliday-dts-v1-3-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=840;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=4hUtXzlXhIrBYYJFfDKQPQ3vEIzggE85cdjdS9WjQ78=;
 b=/Hr74fQlfTdpftwl6fj+vsUmb0ZD+laYeVxlhFK0akfSM/Zr+bIuUmQJNpniQW71Vw0S+OnBe
 X7HjWxQRJOhA4SO/MxeQgQ2JNwAjEDgqTYH/3IGyH4DzNXVVHXtyQib
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Power Domain Controller on the Qualcomm Halliday SoC.

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

