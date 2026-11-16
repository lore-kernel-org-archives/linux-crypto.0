Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864441;
	b=KeH4PJ+jgW7TkG8hO36c7kIe/ZV39CWzDtfiqUFzxFMFA01RE3NKoSjywUhndLpiTAEE
	 NZOLjW01CAXQFuUNTmiPMEEj+8NKlXSdWoiWe18Oh3A4xM5OJic8OGUPUVH4a+lm/tDwF
	 jv/jIhrawpBaQO335ecGHp8GQQAa2DbP0pSHdGlGfNRIaa7/BFBL/VATe4K0DzciSVLoY
	 NK8CHqH9t863mRECNtTbNLBQ3LCXr6HvURGcV5NGg+pfpHiQIJq5a22iaunqDFJ+Xwf2P
	 dIefVAZeVdL6W4WuG6QKQXwZgtGt5nNzrJULqUZN9w3S6qQXfVudXmY9IRQ2NUvmzTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864441;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=w98VdCA9EtnwfzZZ4SHf5Gk3YVXSBdJ/uT/O1NuBZJI=;
	b=g6tYuZY84e8ZDuSmp6mlYMXze/YXgEDjjzMjcxbssYZDXU331YCaiEn237U9rnd5tLH8
	 CQfYWudBxUvDFjIdRbDUm6Bh5EzcwHUsabMyiJnNkCPRxexgLrAfsHlMujeGdVKqwn1x5
	 uiqJRlA8+cljXsHkyD3tNF4k6JKFWFnWjrm5TKjarwRQ2QYxtuFj0kDq5agVEFdl/Mf6C
	 JAhw6/nBIFYbaNxPH5x4DCKneYuufUqqmqpuucC71G40ysXMavkfEFj6+nTxgsbG+AEz2
	 dKrzTCECbyfNkxdWNrVrE/34pwAvYsYINQZa+NRPWbGxKEUxpAOicS91HCSU84pGNSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AG9pfL7W;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4328606A329
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 21:27:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4328606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AG9pfL7W
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49d05d51553so22763085e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 13:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864439; x=1795469239; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w98VdCA9EtnwfzZZ4SHf5Gk3YVXSBdJ/uT/O1NuBZJI=;
        b=AG9pfL7Wd/r6/98cIDo+nVLfIVZ9Px+zjsXE5kwL5C5mXq0vvRxtAzXqCOjP57c76/
         QDAdB73QojRTusWajXwvXLflOajjTrRtPUzzN2iBmylVD9h5CuWtCva4RFTGQ3WAXdqj
         QUPHfhV8R3R6+D57fWZz5PoRdD7Zh4aEwbeRy6IRy5hp3spzPFQuezFUatlivFZZIhX7
         UvyPXGEihmkcLMT0slqp/7SwQoAyDHmifQcdngvOwon8ytHUPr4DHYsG+dXREzWIOZZf
         o6twMtZmZHhO517aRhzfH+NpS/QusUvv1lm6Ilz7LGycETpzHg6Fbdmdyo/hrzPzp1uj
         QbbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864439; x=1795469239;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w98VdCA9EtnwfzZZ4SHf5Gk3YVXSBdJ/uT/O1NuBZJI=;
        b=m9Dq/Kj2RN4FfMpsb4odX/vwjSXG1qUZsWmonWrgubbjLR7alWsGZHcSBy5rl/eGPH
         ChANDESxRK5YxOkWk5HIMiNJj6ato4pjYdncwiXuRCtffX7Bd0thlQGm402rENkjZaGB
         zlHuJlaBlyFenH8tHwT5AtMQHmFCzCsAEtLLojKpoh8cV5BYCV1n0m3fG9Uq3J4HYId1
         dGRBUqeJfAB4jJPhGUiI5UFd9/8ZlANN6UoFb+Nc07t1FlZlKHQyu+S4xhkyL0qgHZGr
         EIzANQo34EkyuoeyebkcJb9GxB89QiXxTzwP5Q1b8O93334pYAt4vMxWtt+S3sc2a7P4
         sTsw==
X-Forwarded-Encrypted: i=1; AL+hErGrglxF66bw+wsHNRgXYoSB8yI9taZtVsMKL3zNSyICxSviolgcN+zXYd+LcVOP2CXKhImT8Rtj0I0zTz4=@vger.kernel.org
X-Gm-Message-State: APuU4Z/26T7Y0ilyxjUamvAeik4LJHM83a1uhQx/3BcFUWfooQZOBiGH
	+Z3utzBRa1XbQxpitL2T/uB7+OTzrqgMyHuiPr/8iqL6Z6MMU2ZZ1exV
X-Gm-Gg: AYBFou2ChOzzMAZe71QtA8MDCENJR4AV7jaCYXx+vECQTlSc/QVIZEaYVxVT8+a83m3
	Kj5c1JSMluu7LxC3342Ue8d3R/kTvKSQWtwzaUiRpD/SiKBXagYvPVdzdY9a2Buc8Jq1/cnKtdB
	s3Bb8zt2z1INj/qB2aFzg9FhJ/OB2X1L0SJb1TcIbnmLDrMD28x/xIyReJ1lb/vhjl5BAuK9K+t
	8Cnd0PDf/iL49jti8WLSD1eE7W4rOOMug5p57fjPMpnyDk+aT+z9gyNaeK7cwqlWvn6hhD6ba7x
	coKOM5P52QxnscqSgPH4RblzjPjU5Gy7097lQTajuMPiMCwnXIPuJA8IWI2dGzX0n7QHrbh5aHI
	fxCdL83RK+b1w/9JojTLy1D4iCDtCBbYcxIDYIO8LTyI4WSMpFKmaSrm0Imyfq5jEDwpJJjbetE
	qBwnyAhWv/xZagRQLBw7hw56EebQFfP2CdnzmtfQGfEfLuSOPD/DnYp5Z0GIIwtGbLRZRjWPNIP
	XoTwGU1JFbCBNfzJZK5q5oNs0OUDsrzECG9CU+LSUmLYMkIoyFJYc7KdfCPUmr74jW4AYMprnuy
	fq1vYCiFM4/7l70xEnVvp270ApjjNdF25ZTZBO3k
X-Received: by 2002:a05:600c:3487:b0:4a2:526b:d410 with SMTP id 5b1f17b1804b1-4bb55a4f1b4mr255653315e9.13.1794864439353;
        Mon, 16 Nov 2026 13:27:19 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:27:18 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:23 +0000
Subject: [PATCH v2 07/16] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add
 Halliday
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
Message-Id: <20261116-halliday-dts-v2-7-2c92438c6c46@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=993;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=Os3dtyGi4Umq8bQ7AEz34h0NK9e+Ws6GY42XJz6qujA=;
 b=JAnPagjMpge0X10XiR/LbxFcl9vIwvXlY8rdMR3b7TnG2zjS5Ef/3pOUFBSYZcopY2HJ+t+/s
 qtEtnXV/IW3BvhWLgk5yEo8YJikc5cpwNQrDqesXNsRHoPh2k6l5Th3
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the QMP UFS PHY on the Qualcomm Halliday SoC, which is
compatible with the SM8450 one.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
index 10435a0b5230..a42bba9b550d 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
@@ -28,6 +28,10 @@ properties:
           - enum:
               - qcom,qcs615-qmp-ufs-phy
           - const: qcom,sm6115-qmp-ufs-phy
+      - items:
+          - enum:
+              - qcom,halliday-qmp-ufs-phy
+          - const: qcom,sm8450-qmp-ufs-phy
       - items:
           - enum:
               - qcom,x1e80100-qmp-ufs-phy

-- 
2.55.0

