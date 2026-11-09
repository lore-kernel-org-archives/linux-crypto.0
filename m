Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184428;
	b=Ru3sZcOZrpYATeS0sukuYcgflXFJiF23GCs+RnhGSHQGNbR1vYZpitZU0mKn1w0yQCfo
	 Ub0JIE/YhVif38D4nbpyp/x9aTqI7jMqbnTF28sq+Px/dtMWuZT6FFk67/RLuSMX9jE2c
	 sH7s/o+GaA0VylrQ/RiIwwO2l1sx/Ftm35nRowC8/lC4/1zLF2gZgD0gsE2Ujvitl8Fdi
	 GDJQN5I2ROox+O5z2YrT/jx/ymLXg2FBmiO3tSGq3tsbnmFuUDlz6rdO/tC6+K/BrIbdh
	 5Bs7j6OeEV1i6tP1odjKMDtsRcKN4/epkymKhrhhJXWvMksDds9icoVKFfHktRotjWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184428;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=PkFPVfDx+55MAHBA3oCOcT0HjrgdVU03z1VGaEKFF3w=;
	b=4WGGiJuP6TuNYQH2Vclh46EodRyR1YX0eEtc1ZWKj7pydxuPZsiaCItriG7vIsLe6M1P
	 ESu7LX7zcN3clY0GtAzTM3SstlKzVH5t2fkaprgIN56s2zk22r93e4VMgMliqF95p1537
	 Kf7Frm0M4RKG1DUs1DMmFp8zDxtKjPnKs6KG/y9e2967igUdJXZWlg1HNBBkTHlgQWcGd
	 g9MiqOIvkWt5e3gMOFwuGXgVCY3jPpEOgazOKIN2ii/E254deMlod7SHGBCBxB6h0Fnnm
	 uYOfI497MWt8PD88IOqlr643YiT2lMdJlncfBYkZt5SSTArypD1hxjhviiyYD+Ebh3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FyDzKlyt;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58B1606EE83
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 00:33:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D58B1606EE83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FyDzKlyt
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso2456275e9.3
        for <linux-crypto@vger.kernel.org>; Sun, 08 Nov 2026 16:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184426; x=1794789226; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PkFPVfDx+55MAHBA3oCOcT0HjrgdVU03z1VGaEKFF3w=;
        b=FyDzKlytNlxAxLxC2gOdtwF1+dCkfYwbnWO6d6oPLIvthh1fBT5kqIqv3qhAxjwF+S
         PFR8nekUaUaUbx6CeF7ug3qsqKHwR/kTO9V1T4Gh8dASycorY7RcdrnLPeG1D5Txou55
         xgDbR4iPItBw5wvy3bOWz0Iyu/+OIfpLVhUWEPhctXpoFJ8gpgnVrNIaGCrAUOL0ZPyt
         NxOLj8n/xATQtJPIEPyzFjU842UmMjHxhCBNhBfhWuqVNq1zEGFr9t43gIXHmKQ8IbKc
         HMtuRXvOTX5bhQuwRu6FbfL0UoFdw7t7IXKyKMYwATRvVboP24aPvmrx5uB0BcbSe3Hm
         TZiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184426; x=1794789226;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PkFPVfDx+55MAHBA3oCOcT0HjrgdVU03z1VGaEKFF3w=;
        b=HWGpPAjliArwYpIqPdzlobkxdomjMSEiADQZD03TckOn44rwH2M78ynT5evlr7vX1f
         +O+0u/vLF1YlbMQU5vev9Drb8BAJdcuNAcYTNXeoU/p8R7r2RLCMYwuvjI33bHRPHlZW
         +OekbhBulW1FwA60mSgWen9GQXFWuGy3WDLYXJT/NYqH5kTzWcLnzjSwkr5BhcS9I9ct
         3/PArfA5gDW2I4DsrpqGajv7QfiVnDJKd+vbrJCV/Sx28nPV9aLBRCDILWCHuzSnQDC4
         BdUj1RrAiklRjiWMamjips3iWrd7RDAyJw9ixpeQpyoeG7+iMkUhz+Amcx1L/wxKM+Dt
         V1Eg==
X-Forwarded-Encrypted: i=1; AL+hErF8IovhuUppsThrR8aRoqRZLRSkaFDL7Uy8WmFEQ9ZtNrimsWzGswyBTi+UXuUr6S6YpGdvi3OqNKAPjoM=@vger.kernel.org
X-Gm-Message-State: APuU4Z+CnUQ8yPscCbKNNBYOxn46XsB8pkXXrgEMAFhvW7krX0YfFGEs
	ln70VyuF9jcHifaBVR8ScIKsja4lHEODFX3RVC6GlLCH02ubJIu8JSBd
X-Gm-Gg: AYBFou0KeQIeJeuBr4+2PCwiVN353aYEKtiQN01xnCD3umeRxN0c9n2aZIkBFCmBoNK
	tYxRcyjhQ8Q4AfmoCa+/y/hFbNqTxf11FRWe2yMig9JfPMTDfkmllX22SpPfVzjtub+6N5zwHde
	Ak6OUC5IyvxnvptkEpfy39w0wtMvM1PwPO5bAWj637QhwGZRqveYgcivvxkoEJ9r3RhR2hlbJJU
	Ngme65Wf6Icdc/3VIDdagDGIASVmFViIPo1XVRiZCBUO8tjUlSmqfdHzG1beEX/jNtIdq+8TZAl
	goiaCXmEqkQ+pzqA3F9ThmUAAxzYbsBr5mJ3GL1MtHwHLpzqoExgpvZfKKlLmpd6SV8WKnGdSH8
	hMeRe3LNKWBRQHJnVW/PIJie8wr3BD8eJXGVs8m1bCgMH+F6HP/JvHq1yfMvwg0UwI7eiczcIEk
	7vY70s/nxIBqB2zOa3MDoGsspxeLDFH5OFWhtIq+JD6RyBjKO+2O/u6lr7Z/bRcndW16FTKipHg
	Zg6EIn05uNl/xVkHrygARsnhF8jrvlqjzIp4fo+vn8WJ1Gm+SpGoKEHEt9CWx9VdSLeEkVJ3utP
	sLineM/fKfQimcluSN6Bu0fOs8NYxyFSSAJhcA6d
X-Received: by 2002:a05:600c:3e88:b0:4b0:bc65:b9b5 with SMTP id 5b1f17b1804b1-4b963c8809emr43372595e9.35.1794184425700;
        Sun, 08 Nov 2026 16:33:45 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:33:45 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:16 +0000
Subject: [PATCH 04/17] dt-bindings: power: qcom,rpmpd: document the
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
Message-Id: <20261109-halliday-dts-v1-4-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=1003;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=el/mD1li+25cayhCgWCSoEmU7xbrdbDdv2bm0vKCgf0=;
 b=AAbKZuaWziyLaKTlH3TAQLDLLUPJbQQuUGnW2/exeZlWjcPjeJvTUQ3Mzs5Xy0Jsi923+4Jy6
 HYpQrlT+Y7QBXM0fnEs6fk3DZfReSJNsf74HPnCiwzI9V/RMLtbXEW8
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the RPMh Power Domains on the Qualcomm Halliday SoC
(SXR2250P). Its command DB has the same power domains as SM8450
(CX, EBI, GFX, LCX, LMX, MMCX, MSS, MX and MXC), so use
qcom,sm8450-rpmhpd as the fallback compatible.

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

