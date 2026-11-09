Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184441;
	b=RjG+PZUSeBfTFG9AEL4UVXdVkAoQUmd6wPUpS4I4A1JYb1zvdLD8JPG7k1UL39AO8XcO
	 5WKstnUZOezLcoOGSImS5A/6ASUO7eQsyYPZgismygxzmhEVv/qLGRIvh4NqD54rS4Z9M
	 JDWF0+A91qoWVI1y8Z9VAKwKPhrQi9M5hfE2HCVgo/UlQsE7Yf1dP1yyD61U2mZwB9+es
	 i5BYSuONZAUkpFlqNeqQJNWbSYgZOV3oXo+GROerBb9Td7h8FSwThN/3wjOejZ5Z14Vv1
	 Yjn+CJzfiakvpTmGBFoJPSQXCtCOvgwpJ6ryF9BoFT8a8d1FscEs7EmxWU0lcT5KD7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184441;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=ro51FgAwM27DOCsfxJX1DqcXySD2o72+3qO5nSN9dQg=;
	b=yqUz01CY5av+MCzxDfDCwVqHtq8iYyMtn6DiNf6/+skSLWelyl1NSSC2VY1Ddel23tUe
	 yuqtgY/0bfCFjhWlID89PT/hR6m1wdmHdMkCN5OBT2zCnDuXyfhKbNfWm8Wkq1AnmVL22
	 gNz6XuRepbCZxIjlkQhWDYbCNE3lxFswKNCxqLqdSQahYG+52GDBgCvRAkIYelValuH6z
	 fHa+UVEoXM3SbtDU9DfXkwukrUm6raJPdAlK00amLTzqWZyCDfY6f8k8zbuM5OdVGCJgV
	 z5hPnJao8ZQ5p8VyLtIGA+i6iNOxNH/zZQZ30cn/5YNtIRWZPOAC/MNlgxeaYxANbAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ULEuYnxb;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21106606D836
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 00:34:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21106606D836
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ULEuYnxb
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4918c2d727fso134244f8f.3
        for <linux-crypto@vger.kernel.org>; Sun, 08 Nov 2026 16:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184439; x=1794789239; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ro51FgAwM27DOCsfxJX1DqcXySD2o72+3qO5nSN9dQg=;
        b=ULEuYnxb9uEPYMVwaCZFAhBSr3XRRf7x47G6eugQCaMON9WlvKKlg8odFviJChKVQz
         L5ivnacejg1JFvAECb3CXO3G4CGlkXkRUf5nvRqM76uVba7f3AbCgFEyfN//93jXlobk
         RRpUD1wxP334PPruCEBCm7XnO4U67yem2Q++cYePF+tA6Ll3cXA7KHUYpVW7bHGXPv3W
         01KWH5s+I/rChWyEAC4I/nugfLSJhWg9sy7NvKigj0oOHHQWEH6RZ1gw31QBj3pWz3YO
         YoqU83BPVVunbYylhg8fGTfC+v6UuQYbRsQ69PfH+mnbpLdKnjMRZknNIjNiF3iaLp2o
         JADQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184439; x=1794789239;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ro51FgAwM27DOCsfxJX1DqcXySD2o72+3qO5nSN9dQg=;
        b=vXvsMXsgfymMVlM79kyqJIIhl4ChaOMbqrwNYSUQdc9gg/XXNfXcdhsVNP7Sf+k3ZP
         Dcn3oeC3SQCni2QQ2W0GJbAxBdVw9nYzGzPLNv6Xl3fww43r29F73cMrVv/3NxnxWkG9
         BoOavHmTb4jEDMCI8CYQryjg9w8qCjoqa5+hDCEQR/DwI1E2XcNrEJywu2PQuQWDwFfX
         izbMvFzast1jELDm8jblaEcbYuyEIgG1KoaYgdsvUjQ66ogQEoFTkVDfm8RjTmPgmbZt
         /IEVNwGQcxkYxzSiONJeBrR3WZPa7y76YwEqqGSAByhDVHB0fxrUKUoIZUpYqGQH7J6D
         lFaQ==
X-Forwarded-Encrypted: i=1; AL+hErFqNFRxGAjTgadyevkhyIlCZkgloqdJQ64wxdDHsWamhm+HAP3MvdsiAJIO6kGXOqCjh6I2ppI1w8+qu64=@vger.kernel.org
X-Gm-Message-State: APuU4Z9pAE6dCr0V1bYClvpeAOGOtp7N9obgz3zLeTC1WxbtCscw8TP3
	4N59kxR15Wo1kvRSjnCQPUazX955LPmamQGMcHIsqiH9bw+cjwnasCfm
X-Gm-Gg: AYBFou3mHlOfqt8gd3XB+3J6AExHXzTLTrQY1SHa79FsKzeDNsOGfcK2HUdtXzeIPtw
	MQxO2hljL4mwQRqoeRHFq619wDAgagxQpkQ9VjAZeIBhzEByrVpFeFUY1ZPnwr2YdA3p6YxitId
	EM6GFEss1TfYGBc2LZSqiVtFei2nCBYq7aiusK334qa8n7pzK4Qkr5n7nWBjvZ8wKuYykEvYTsF
	5Ylql9jXx//fXl8ejRYlFWEaQumi8Gp4k5Vi/8lZ3pCKgczRo1j6fVsek2zwTgDpiDB+RWyyPcf
	5M06MwrQhMNijR6TBAtdY5gfClW8RgdUtx9FE/BXTHkFMgLY59zepnphVZNuSKrMY5QUsAyCok+
	YWRlo3tc24lSxevJ/z2vZcueZR6qVnP3eGIRjs1wA4iPU/s/Hx5ABQ7A/JZIHl1zqQrLuEtKeaC
	wyvlaJGyTj9CA85bFq8ko52TTWGSAVgIsFGzJLyg8gPSX1GpbnR3+qVm9qJjyOqh6OmwgnsD7kX
	yX1GeqUynQFiPpgJpESyPwd4WAEUmrpwnRbQ/VyiIJSgLePJczdfpJzJYLcAa278HqK9bu+dTHt
	b2uOigyIKiCm43D7eYH8KrrGTTPnF6XmznbWe4hvzX0uODlGkq97CFtKZs18tQ==
X-Received: by 2002:a05:6000:3c5:b0:493:2376:81b7 with SMTP id ffacd0b85a97d-49588ecc152mr4851434f8f.27.1794184439552;
        Sun, 08 Nov 2026 16:33:59 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:33:59 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:19 +0000
Subject: [PATCH 07/17] dt-bindings: usb: qcom,snps-dwc3: Add Halliday
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
Message-Id: <20261109-halliday-dts-v1-7-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=1289;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=cCyX7eu7E67i1+mb+zFb+/V3MZ2Z8Bvs+BbDvfy8HQI=;
 b=HQwzvS1g9UbQKH8v0/XpwTYPPGyIcJ129Y8yti74NjNwgnbgo8LwZJmaOxKeuHMuvgkZ+EP/2
 IP5h1J7SLhzC0/e/TSquB9CwBZEDq02qBgUbIWpMHDatD8Y+sZaCkxU
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

