Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794184415;
	b=hBMTVm92MsnP9eoR0TNLUBCeNRBqAnwcZOorOeBiPso9xzYpsy9YAhtqmVBDN/6qZDYS
	 /1yasWpgdcd+SDiAeN8/qsexj0gDNk21oTEWNyNqb/gzROGJpUWum9t0yxvE1JG+eos/J
	 AFN0LG9zcSKEv6N2GQElbRb84JQVsbYotrgqoQCmXYMf/0sxdfjo7OG041HD+ejgtCoj0
	 xg+ngMwFWZrEZfKRe6VUptwompPVmpTJhLKBO5L+A/JYom1s2TJzW/6SdnvTeE5pet717
	 sXnwkLxkbpb41wzozgAwHKL9/O29pMv9+I+/beruR3mwy80O4Z3gHzVE/WwJTDDdNOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794184415;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=x3Zvaf/6knxBP4r88bzQVxogNYmuURJ/Z9N4FNNEXXM=;
	b=Igc5OPntHXAA/IDXhJmnd1ak/gHAFDl71/wctr+V46/Pi5tuNbjAuj78koBlEP4Yq6VI
	 w7PyqN8z2pWBEjRbp7cfw4Vf8rwPpEfnqnO5C2qRS7maixmSaX7Sk+VhZH71cl9rwuxa/
	 ZlqCiTftJTwB00LyWkXnCrzJz8HLNMJrcXxdEcfcTkIPuR1ItXwki9lySwRSUlpBmJuqz
	 dTjxfV6tMICh5vlq6Krni7e08ltJW1TZkMLjh+wHbCzfgWOARR4BWm5xUnhuePS2NUaBx
	 gtIxj6QTr7vQP5+645mzfPBEZ0EnxUuqtiJqDJnCqZYgYzXzIMpbMeRi9otdQBuJSyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="DVeB/ILu";
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597CF606A321
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 00:33:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 597CF606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DVeB/ILu
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a2072b9832so1968355e9.1
        for <linux-crypto@vger.kernel.org>; Sun, 08 Nov 2026 16:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794184414; x=1794789214; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x3Zvaf/6knxBP4r88bzQVxogNYmuURJ/Z9N4FNNEXXM=;
        b=DVeB/ILumBTLtGhAnK9SThmzeGROX65vDDXvaMLZaeOoYlcOfAZJzCyt6um5mYfHDv
         Y3VcmUpi6VTDyzOrubE+TKxzkEzeV7DSAlF0WPPNZOCE3moVlSnmkE+1qezIdsBohAmP
         a/93IAhud+Xk1IuhtXMMbD/9JTprYk8GiRs8RDQKDOz2ajUzeKy1jt8xEeKQ03ZHTNjl
         KWqIgDs77rGbxNx92twtTmLWRqapsVjV3jMP0O+gf6wVsaSd0oWYgtJXqPstZO6rnlkr
         fdQkYrgvqlA/v1Pb5mWvu8AR3xbxLkneLZ+FWfx+DKb2+C192KWMt4IWysE3CQA4Jrx3
         3R5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794184414; x=1794789214;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x3Zvaf/6knxBP4r88bzQVxogNYmuURJ/Z9N4FNNEXXM=;
        b=iz+r4f4iHmUgmCmDn41QTLJ3Ofu4rldeic1gMpdG45EHB7x+RsBT4IyeR7oEbhje7q
         nM+Nhj67IngQlMX12p8AqrUp0PeA6W453xePfI9psypT9O8s03W3NyYVnuTUD7j7P84j
         JjFioATM+D3JmHeugtagAS5WDxWkEgPfYPQq59d4pfOFCRHY6z+cRHpA7ClFiOH/o0HK
         oClwy7SCh2Vb0f8X6SMblEBy5dFihh5Qmql4HHkpAHMD0sNHe4yIFllxpYPG+fNdmI9Z
         izWN/rWBmiGWsP4Bn8rOX8F+NZ/7zyVaFBtpqwXs+WgK2MASISaQzR6/PCPD4pnLGosb
         fRNA==
X-Forwarded-Encrypted: i=1; AL+hErH/tl9c8sukR+tOWoX5UvYsOiPEe9D41eH7hNu7z2WUHu+Lu+qN6sNop83byI+eaZqnU2bRrWFxzhWq9eo=@vger.kernel.org
X-Gm-Message-State: APuU4Z8UJJaOaCK+nXN5VP57zjn1gWjWD+4OjdyztiTrTcQCLwXPRflm
	5LTFoP7BL6882YrUY4InF1X/XSqfpJh4Hsv9xnvDw9irVSSdjIfrZigR
X-Gm-Gg: AYBFou3/5/1jZTOQkhz7aIl/SuQpXxfu1okvh1Ckxf+yi1MQeUj3Sje43H/QjPJDAdp
	o7NsIowT8Kqm1gYBn1blwpojeP5oiu0mPztcvFJjmDvymgHA8CuWhbdTX+Bo8eVhYjXUmjFC8vE
	78aHdsjHEwBsM1aa9bS5n6Vb3znUZEJJhje01y8c4bjv9Lnsk+7s7vAwE2CajUw72bLYvDAVoli
	2TNUkD6SaTZf1PFi3kK0Plzz8WG4VEUiTxXCD5FBANLyDkdh2lZUQo+OY1kKLhMWhkTcRVcL5ST
	8Ym6w6suYJtBlsX9ry8R8fYBuVYVE9jcfbnZYByfdUITcsI20Bmled2e/ikGvF5QDQU1HVEk4vA
	zXTo5dhl9HQrI6wKxV4LxU1PDZqLelL/3PJpe/LOWkL2T7Ux0rbPxGoEYv8hPCrbRdJJj2a+nDR
	hAirVvAYH1BN98RbUJP1W7f+yuQSPXidSIy0SVTdUwej44g7norplvmNsyLmHh/KCGGfRStKhH/
	NXb5kTLKhf9V4CNYBzZ/bwTeQd+JyA7KBNdDSGjGrFxeAAG82SB/2nsSBAAT6340JrWxCtJetof
	RVRxjVpHtF2u6eIUNMVmIUlx0nBcMHI26lVtPbu6
X-Received: by 2002:a05:600c:8506:b0:4a2:10f9:37db with SMTP id 5b1f17b1804b1-4b963c664fdmr50119595e9.7.1794184413846;
        Sun, 08 Nov 2026 16:33:33 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39c8asm6541675f8f.7.2026.11.08.16.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 16:33:32 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 09 Nov 2026 00:33:14 +0000
Subject: [PATCH 02/17] dt-bindings: firmware: qcom,scm: Document Halliday
 SCM
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
Message-Id: <20261109-halliday-dts-v1-2-289114ab8197@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794184395; l=1033;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=mntziyVI6wQ2kSkSteAmiaUttlX3LQ+YCHknAe0v+s4=;
 b=6KLs+gQMEgAdwwaI8XXKZHARhr4EIqJqXke9wpzWMnotth4jMEZlLGfBGwMvNoTpcE0tKCN8v
 aRJBBJI0d5iA+Opb629gN3RAQt1TeYIjZdEvW3ChlNmIbJyjVXak7Mn
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the SCM on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/firmware/qcom,scm.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/firmware/qcom,scm.yaml b/Documentation/devicetree/bindings/firmware/qcom,scm.yaml
index 40a267c54b00..fb3da66443ed 100644
--- a/Documentation/devicetree/bindings/firmware/qcom,scm.yaml
+++ b/Documentation/devicetree/bindings/firmware/qcom,scm.yaml
@@ -25,6 +25,7 @@ properties:
           - qcom,scm-apq8084
           - qcom,scm-eliza
           - qcom,scm-glymur
+          - qcom,scm-halliday
           - qcom,scm-hawi
           - qcom,scm-ipq4019
           - qcom,scm-ipq5018
@@ -225,6 +226,7 @@ allOf:
             contains:
               enum:
                 - qcom,scm-eliza
+                - qcom,scm-halliday
                 - qcom,scm-hawi
                 - qcom,scm-kaanapali
                 - qcom,scm-maili

-- 
2.55.0

