Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864435;
	b=NZnsehMtNwQ9Siiyl8R3m/CI7gDb14UX/CBN0zTokZEHt7gBtKj3AsQCrVFOdv2JmkaT
	 48+YP43QNQhL8/s2kQUAZexsegyhlnDFCZdhhRHEGK3ILrhaQGLFF6Gc8P1gMofcCRxJ5
	 8EG47TvJy5U/U6c+OUZIais6Ul1QgclD6/gHMte8BDh5EVZgDGqDaciQLsgKeIoCzYMvM
	 OpssI0hyHvtAi3jT0YeFjjJRYccSJi5njUIHkVn4vstUX3QgwgACPKBENYoAf2cogf+Gh
	 w2iaHjh54xoHNxkuk3O9iel0kAPMLydLkJCTUSxkottuWGKfMfWapnMJ78C0NYJmZGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864435;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=3GDSoMHQsxRWl9RceBND7eXD7fNs4JK2UCz+AN9Gniw=;
	b=UQHKFl0o6HZBMW0LAUxhppAAX899zc0qsOMrjPgdMTVXpkWf8zNrNlAwbnak3k7mHkKS
	 iRt1allRdM6kkRzIOAR8tRFe8x3fr1MpW1/TAa/Rf2aXRe3ZR37F28XcIKloqLRsaKrPn
	 40OiO9z2nDJfQJK3dPsAc6+As42C1whC6qh8d5t1xOudKKAhVuFVivvExDL1pf3LQkrdO
	 cUDv/uOav8jEi3LjF7oyKfZz6JIu1Mh9jFZizgdI0HqaxwEadPOs7hl7jNz0dMwm21VL/
	 zL4jE4uEffaLe2zNRledD7o/tTQxMokYJWURdp72zcfUaM1lA2u7Gf8DbGr6ZwAMOng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P16DvILv;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0D6606A31C
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 21:27:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F0D6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P16DvILv
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48e10a70540so2204740f8f.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 13:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864433; x=1795469233; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3GDSoMHQsxRWl9RceBND7eXD7fNs4JK2UCz+AN9Gniw=;
        b=P16DvILvAkJjX6pET/OY1y6yCbL6KHNvFmQ8Vc5ms2Nh4pBtOsH5swOYSMdfoItM4b
         t5MUV5RS8EsfFWLaJSSS5E70h3/UCARtpvqtPXICi2MnbVDPa95XtCUmcFtAYjMi3iD9
         sCZvL8DZRUZv/G7eI4SHBKPuYPPoNAExEKI30EQbOIauyxIQR0kIV/+D532rj4kB4ZjR
         LbaVAAYCUUzAIoRJt6nlQejAo2Qj82puHxbZwDW1Fa8tRWYcjQNNMrBV4t0c64r9Bq5k
         XxoBse3bOdVc5KRCAVJVYP/0nrxUtbAZayRyyja7hKGad0rPdK7UrkQNvPW9f3BimHA9
         xUYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864433; x=1795469233;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3GDSoMHQsxRWl9RceBND7eXD7fNs4JK2UCz+AN9Gniw=;
        b=vS2lSDsDz4Hum6+QY5eG6FX1fjbqcVFl2rTGZHgyqzt2hR4wUySOpBtbQj3rB/wskb
         ArXF1cou4zbmeZK7lpvtXfCXFQhomPmSkTxSPOSlbNJH+MNW4cRuFUz/h90hcMjUz1QH
         mGKvYfJs91gHxSPyPa0akm40mlTGDKtISEiutBrsU4lO3PcQBpDL6cyRBTB71U0rJcGw
         gIFnJwcR7B6vkUEKUXpoMAX8pOaD6m+Ew4sWsr3gc0McMii3b78jeQTk0peMSW7pGc5I
         KmQdi/s2s8dwrXYtiHsmG67dZg4YFE5q92Mg/fuhMnCZOhxnkOdmmPVGHPffN2YVIHZw
         H51Q==
X-Forwarded-Encrypted: i=1; AL+hErHPmzPSk/El9pn+RNY8iyf+DvNkQWboYPRn7CutcNhGAGucqKzHTz/CBhW2SZT4nP1egh5rC5uPeB9e2Nk=@vger.kernel.org
X-Gm-Message-State: APuU4Z8nSIQS9mjSmLj9FR/MCpEl/wkvud1+SgaqNLP+7c3QOaJGkYRp
	F88YBAVlwvwVGqMDWVZyLSuSdAqDxnW89Z3iqjS/oPxplHZucVV4wKPX
X-Gm-Gg: AZFdTZfQuNSN1gEhnBfxm0nLfXhW7MzEgrkvNpwKMrNBSFwrfrME/on4az2x8SvMIPV
	c288uADQhyIyjwNVkh8M5vgAL9nwUYU8wcVQbHJs+3gPDIzSIP4+U6JqpYT8lbUYYg5uHgF5wo+
	A0tYUFxkjaPCvmnuKp4dILcPHzkUgBlu6YznoLbnsjt46oiYbkWJNQGAFGq+771W5878UJoi7FV
	VX8zPrkuX6FQ/WQWZr0UuIOxxF6vhsVZu9IpgmZLHWQpgdWzjohaHZsvJvyZQW0OIOfV6Oq4uzf
	6v3yFE3AkSHkHBz8yefbsGjgxrOnbW4DIEhDb1VKprFHJjsDWI5qCEFynEJtR/rbf4BKRgDlBon
	67A1DEd+IpQyOBsR2DvzX0S8s0UUsn/rN+zckHSclwxKMv2TboPipI9vclzEzWGj3htCXuZ6J4P
	sIjaZHue7SeTkMvwwN416MCeek7MatZQJWFvFy66FjddmhawUGdJ3jARTlU/tNfGtMxlsKQkWIh
	m5bLw4bHxqhoSrfWifK8l1Z64luki7rBpWxXUBd0SRUOjoPJTEsGLROv9GTlziSXD7zfIZGFnXQ
	wOSuXTPpOTzMjtNW+bi3Kg0yk9rSOPIkc3EybkAT
X-Received: by 2002:a05:6000:610:b0:495:5c83:51b9 with SMTP id ffacd0b85a97d-49c7467a893mr27328310f8f.50.1794864433590;
        Mon, 16 Nov 2026 13:27:13 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:27:13 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:22 +0000
Subject: [PATCH v2 06/16] dt-bindings: phy: qcom,usb-snps-femto-v2: Add
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
Message-Id: <20261116-halliday-dts-v2-6-2c92438c6c46@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=891;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=iomST/Qr961He4Ne7crBcxin7EtHuKLr8auNEsY1c6w=;
 b=XlBnHuuXKSsmwBoy79zd7CM/aQS0V4vz73O5I/ykrhOgY3nFJG4rnY0qnm4zfFTA5sK35VFT6
 GeLVT3WztE2DdDA/hh0iSPFr/rHt5tVJ5B9S1do1YbNU2FqHh/CJpdT
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

