Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864446;
	b=yAc3pH6EYjYY+TL7PlnLUuGEv3crt3kERVQEru7MvAP2NOsiVIny6U+YSTeeCjALV9Xg
	 oFokIJPn689+8xoCWw6zOQRU6IvGgTJB+AIimu82k89fGnFKb0Slu3LmpUmFUHysZmPDj
	 cremcWBqEkVXDQHxug0RapUz1exm9M7kJm9kAz7Mg23R3Uac6IObjlVNiYzv+Wo/p+m4j
	 c7Fc+d5PzqCMO+MQfhk/2qxxL79/IxV+Urn/G8k7Y+aRcvfnVKL5A+lXvVL1qtNilYAFj
	 nZVJBd1Mj751aQFRVMP1K52DTWfk1s8sz3efuneZG3QcjaBZm8OA8o7S7VEsFWp/SaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864446;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=s/ljkdQydKv0eJnuPEQK47y3qmQ4duXo8otCxl59TOE=;
	b=DrNWFwgJFI42rei1viMO4GudaUicKmxosLa3OqOSOj4TfTNH+RHw1UJaFwGL7t+NYVPW
	 qOdrik9yWFYZY8eK1bSbBxB79t90CPlrceasdvFmQTPLgpssg3qIa1UGQFaQT/TdL7ii0
	 XDiyNZ15Ok+PRW/qgsiZgjt+r50g+I2kWldUdYSfQXMc+QMNSbBHli5PSHjO5ShtQXPy4
	 62x9wOknxS3LOy1PBlavAu5iPYGUZRHItm2tBsC25+G4hzu20yEK9SZQN2r9XPjiFagD0
	 mX2W1cVuSe9KEJ2EDx28OSzFC6kjyKRe6nZ8OYwx7AB/G7OpwNGMMP8lE0wmQj1O7Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iWmpHX9v;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DFA606A888
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 21:27:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74DFA606A888
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iWmpHX9v
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4bb6c7b6dbdso21062255e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 13:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864445; x=1795469245; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s/ljkdQydKv0eJnuPEQK47y3qmQ4duXo8otCxl59TOE=;
        b=iWmpHX9vy8zy4+SpuLwYiHLB3ln3/7sZipWq17iQxZemFskLqrf+5u0LQFERvFgOg0
         YGm75sawrb5dvvPHQL1E3tnBDx/3Lj9iGKAvXpNm6bZ7XZPo570BE2i9caMiY5IKS48b
         yiBmD1KuJl1DrDWRRsqVTXAG16CMeW5eB5GXQT6VgA4c1+z5l6oZ5HSKUqabtHjZShkT
         48NHibHjglieodvDk4cQu2TecbGkn+qDMwsDpIC4OxFmZTkuOj8+6GxuMUQCtCSsIVCD
         HuGkdrxWUd2eVnv/PV05xdTNl8Q6L1L49LNERTuDgEIO5Ltu94W6gpd+G19oZ0m2OntX
         /SZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864445; x=1795469245;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s/ljkdQydKv0eJnuPEQK47y3qmQ4duXo8otCxl59TOE=;
        b=d07me1gbxUdnWjW+vZk1NBsR4AiZ61axFJ+UcFkW566tn77eTIjnhxZV4h/B0SkYfF
         x+9S0MWvA1ZSix4diIIDQZFLj6CDl0VGPT6sKbOPIF4fs/8lxooFs7qHLrbYtsdr6swl
         ZDyBGqfj7l6JcSm5LWselK0FosApMEsXgFBEGmcDtxjYm81ZNSH3ifRJQHXZRQkbKofT
         nV7LbK2LlpgYkpXEK2+rfZAJxJWSbsz+x0PNq/cxx9OCZAwcKOjc8kGLTsc55xr4l3YR
         ycA9dagQnCwb+QV3LQY5U3IhiLO1e1bNAvMhvHTKVTSOyC0DdODdNsrlYN9kDXO13ODR
         QaUg==
X-Forwarded-Encrypted: i=1; AL+hErHUX159inUs6pzzJ8JmCeiRbg/7tKHMG/FrfeoXygSyDcoYCFRmNYdPg7Mzq2kSPW3AYiVCbDMaD/XMOR4=@vger.kernel.org
X-Gm-Message-State: APuU4Z8RpgO268Qtc+0TIdmYBxjKQTwa9Tjzuptd5W46brkj2IUkiRpN
	JPrAqUF3vYerJHQhPJXHLVESgv736j9+0BstdmzulLvfgrbzOZmi2yrd
X-Gm-Gg: AYBFou00U0j/56hIxLg35wbQtlBDr6LE/I7hDMYnMC3kFgmrxSzWDyl4FZqS5JgT7zM
	7SsspbskjBlz+7Begk1PV7zD8yjFFbmOUFPqu+ePZy43Rx5pwPNd3RPU9VCCxbs7NHi/qDXVgxe
	DfRXNb2kPgIPSzAuunO3V+GXh/EQFmXhq3vs0yvSqkyp4fS/iKC1yrDf5g0WQQFLWZyyOoEwAUO
	WW0eFH9w/BV33l6SylwacJ+JxJuDpaRKoHuQyb8ifLfNuHck+k2qTfWb+fBb4i5t5b+ZzWcAwuY
	onkxFz/VLTa4E3IaJ6RBfdpYGC+m/n6/M2EosF3Ux5bm8gnMcpSaP5Th75yKnyP1M+BcXY9CoZp
	tLfSHKqe163a17YsikIPS/aH8pcJeL7sD3mz5bRAIa7ie8q3rxQG9Gbl+ep/v6lC6EWYoLXviVD
	ROBnSW1uDLQvKyCcteTwo7Nb6VXmPpxbED+vsBA1t4qEJ9EnJ7rOgZgx/nf7yI850fuM/ukWgbY
	DsF/YBZOaDP+A9olVTomE4rqpN3QWx7I0j1sX2R/ROTscaAcqvAogdrSbSNCIrC5Iot5wkrWw0X
	8GEp4lMmFC5EgLjI1FSg4aTCg2ZK9T33p+loWuUw
X-Received: by 2002:a05:600c:6548:b0:4b0:c1ae:829 with SMTP id 5b1f17b1804b1-4bb55a8d621mr184234605e9.30.1794864444941;
        Mon, 16 Nov 2026 13:27:24 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:27:24 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:24 +0000
Subject: [PATCH v2 08/16] dt-bindings: ufs: qcom,sc7180-ufshc: Add Halliday
 UFS
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
Message-Id: <20261116-halliday-dts-v2-8-2c92438c6c46@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=1028;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=e5+pG0dDXEqC2bp77Ez+oDydvwUzWtL2BPwcLeGQJvE=;
 b=gD8xOm5xZ9FtfmXv7b9AItlwRATNEZobnHQBfav0fJLpw18USQbXaJrBNVYJ8htSmcNjmMoiY
 oIwuZK62UjeA39gKapnqrq7NNerfrM+Hz5ecpQBWUPf7UaNqv3Q7sGR
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the UFS host controller on the Qualcomm Halliday SoC.

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
index 3c407426d697..5d1784baddd7 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
@@ -15,6 +15,7 @@ select:
     compatible:
       contains:
         enum:
+          - qcom,halliday-ufshc
           - qcom,milos-ufshc
           - qcom,msm8998-ufshc
           - qcom,qcs8300-ufshc
@@ -40,6 +41,7 @@ properties:
           - const: qcom,ufshc
       - items:
           - enum:
+              - qcom,halliday-ufshc
               - qcom,milos-ufshc
               - qcom,msm8998-ufshc
               - qcom,qcs8300-ufshc

-- 
2.55.0

