Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864452;
	b=32h2aGIvcozGaTFfl8/tjCZjJJ9c/9LH6m5pDYLWJ1XMNo4V/FSC5YrdOc+KSoOf3qDP
	 BBBw9z0bjLl//LE457w6J0z7/csXaqLOcTuTdItGYZG4wfy4ztSxKiT0LKR+57WdOgVru
	 0yawBbPoNF2cJwWBCQnu0l/XiP7XGyZgm1Qf5d1zedgCbDzD3fpjp4dD0WWUo6aw0D5nL
	 U+PSRNdRJ1AVxAJgx4tz+2bfNhlpYbY3AeeUSdNcyxxttqWSKkBe4fqxqiYjVe9XP6OE5
	 58ifbJ01E4rLn8iCjxQEa5KwE1zF3uXhf54FQV8UScL1VedIjxWLJ96G3aCmA4TReGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864452;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=UNI0IawohcjDnjoicCHviRRe2GFEz6OyLASUQR+3Ovw=;
	b=DIpmNFwcfZh8VU0YM5YqknuhWWZ7W/LSrlmi5CdiNdSho6F4DT35ko2RXmUeRoLqQJQs
	 m1ZwMKLns8eLY6wydd0eVBDPeZvSLh7cBJz2NGQuAPOsFV/17W44lUHZOzYevN10p1zs8
	 l/tG+DL3i2Z4DKwRCEc22UPEruy0y0JRnDZDvTXKLt8t50mmD1Vw3x4sm2DG1InRbrtJd
	 LjoVXngyzQI62Y65mm0WSFDe0IJhaT7Xcr0fgk8MYSHCagSwR8/+JtGmG0IN1PK+QHnz8
	 Q5Tx0vBo/dFXT9frmKBG0KSLN36YWnqU7pv2Mtr4rkgsvzswcL64vVmJAqYT8YxWohw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Pe94GAJI;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EAB606A335
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 21:27:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7EAB606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Pe94GAJI
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso4246219f8f.2
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 13:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864450; x=1795469250; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UNI0IawohcjDnjoicCHviRRe2GFEz6OyLASUQR+3Ovw=;
        b=Pe94GAJIWEr/y+mRBwb7Iog7Ajds3LL8wRIVBH/8xPQNrjbBDNlEcQCn+p1QOcbrOV
         bH70aW245d90T1wUfTfa0Sb1xipFO0e3BL/QPMT4jfWcMzOuboVOx66DzI97tdUkpVn8
         em63v1WpvLz1xDjpzkqtc09ikGmguqMkXF/iBCSCrH/7rvMJVikSjBvdeaH+nfm2b/iW
         Hjkp5FslDnjSyufprS3LahKBu44fJFSHmzAIkvAgbVTvZCwJLs5vDW8WjGCFxFP3mws8
         5H88Pj/ByqUxoJReDfmjknbzv2qH6Xj3kHe//wfRUbrzreMGjXoGLArpiGQAfFxpX0lR
         wpAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864450; x=1795469250;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UNI0IawohcjDnjoicCHviRRe2GFEz6OyLASUQR+3Ovw=;
        b=qZlSRGkxKyUa2+H1kMN83nOk8lBQlZvbd0eesSDh0eSgndvDlkJBiVeCxvYo9wdAlt
         4ZtAn45LxU+AZ0jX6W66Ia9glFOk27I6pfx9kOSJoO+RhuDMMVUhWwhWnaBOsljQzxWL
         X3UoDUgkZqKeHEeH0ugbwXnuKo1s5y+H2Lkz5fCSLGOH/hTisqrHbpX2cU8uDonMjrKX
         Oi4MlK5Z0M6i9t4/Oi1fh72eCOfEOygDFikuEieFaPR5Oz127pok6ITiMN6GDSjh222p
         d5yJWmAnsTNmDI4/MQdOFjnYTcRSQM6uGJxxc0KKuJCulZi381fc6X/rVsZ6Krh/xSNk
         yQYQ==
X-Forwarded-Encrypted: i=1; AL+hErHEg0DWA8S8i1dh3cyXWW/UQ5XLTRy2MG0xIsr8UEsKT30y0NfBktAGWpPfIYiOzMmsnE39YaGRjbGvbd4=@vger.kernel.org
X-Gm-Message-State: APuU4Z9DPH+0K0yuo3WLRCzgoRNs23l5x8BDxmwWT8M5KZTsCZ3QK2vY
	Q3EVxIAp/oS04xamD1iErYMXTkrytzxWFR+kPu281Ib+O90D8U0pRxYI
X-Gm-Gg: AZFdTZfaWCdVLIKF/Gjd3PLTohHR+/0L+bB00/RwO3rTTuwc30lYtvq2RN4l8XQj5zk
	VAdRjxWrW9dIoUx6Crh4ItKj68IF2DryD1YGnMLqDyvqQRMSLenNCIQpM9mJWPBStYUM3m17E/g
	owdYl+izOj0uCEkTQy2pr2Wv7RvRtrYBNzQPzJheiqXiNtboLBGh+hv/E6TZjL7Lf8JWFPQDxJQ
	8LdcT7QDPLZrc6XaoFVrUGkp5fKfqxVMI4QEq2xCKiQSDd8imkdtwE/WDPzk82f+gb7c8RidWLw
	EFTAM2wPmKaSm7jBgjQzryc2DhPiVFiQsnjUyUZm/HJ5x9YOpgpT+HVA0DrUvRdx4lRUrNOMBAw
	3/nGisUJm6Sdxq3+00O2vyK6s+Ab2PICW9zpYlKnzr3dDBpa4CM1OW+vr/r8SG74mFBZwhsS6Xh
	54rU4KEVgAR/3mTtUoRRiyQaoZuzG+Yydu/IqnPefbMM0XnVgmLM/A+6FCUCmDPLuR3UAECMamh
	aJb+5dbwOtAgXHCuo8AE2xApBjy93m8EKEgnakscj7qnbQoWcdYplnKNw3JxUD05dDwoNoH/GWh
	bCfZ32nDGJ8RY1iGM1lfi27Dn+o510cVQoK0kr++
X-Received: by 2002:a05:6000:1a8f:b0:4a3:8b21:51c1 with SMTP id ffacd0b85a97d-4a38b2152c6mr1214677f8f.53.1794864450317;
        Mon, 16 Nov 2026 13:27:30 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:27:29 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:25 +0000
Subject: [PATCH v2 09/16] dt-bindings: crypto: qcom,inline-crypto-engine:
 Add Halliday
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
Message-Id: <20261116-halliday-dts-v2-9-2c92438c6c46@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=921;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=LNBr+b73CKCaJq+Lcoy2dBwwEKE3EuPIoRzvD97HKJ8=;
 b=Oo5JC5eiOukaaqszf2JD96qfK1gjo4Z88L7lhFkJnmKZtf8EiRQqPApokWBgoFrRDRq84oEys
 dN0aV0Wol0LDOOw0PtPKsKDeYZp8RCTw6bkJAf6hQZCCV8VanxNS3ZJ
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Inline Crypto Engine on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 23bf98c2b9fa..1512fd1d7471 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -14,6 +14,7 @@ properties:
     items:
       - enum:
           - qcom,eliza-inline-crypto-engine
+          - qcom,halliday-inline-crypto-engine
           - qcom,hawi-inline-crypto-engine
           - qcom,kaanapali-inline-crypto-engine
           - qcom,maili-inline-crypto-engine

-- 
2.55.0

