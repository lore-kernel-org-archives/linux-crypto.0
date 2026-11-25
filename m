Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795578260;
	b=Oivg6frx+JB8g0l22p5JvOGGiAfQhpsia+QmAXwTx9T8jUQINc3anb9Ltr6cuqdMwKXi
	 Oojtjpytm/lYX5m9T+nQba5ACMqCRTRrjRE6qxrahGYSW44JO4pcquIvJQVWOY0cmZE+R
	 Spn5WeBty7gyhuRYNB4CZQzyinhDA/siKktoeIpa6m6EKHTsS2hIJB1DasPp3g11Wb80i
	 dWB+FLFBYfcf+EzSHDkSA/h32o44U6MhGZQofPiU2Q00yVfTqe3pPXaIt6j/71rUbswHJ
	 L4ElRMD3FWlkm0QH7vCTJRxE7m1DaccnURiQeRel1Ft+gtN1U8ldlI9yukxELrks2jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795578260;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=W2b0VXMdCxwEqSCTP3OlO/X4AxL36r2Zoj510JVt9mk=;
	b=eosufXKax/n6uprQ9W/e0N1a1seinipn40/+pYQ/OuerbIZ0CD29QdY2ZujZ87q3tUlT
	 MVfew0IjeQOjNsfeIvHn9whGkU2ZsP0n4r24iloj4bfa1TSjzC0KQpuLykvOuLY08fngk
	 AKPfFmerDMjAQJ3alXoOe2QNz+s1WyGPV11tx6J1cZwSz1H4xRFOPrv/96kqZ9Pfx1sab
	 rShVmAznmHx2TqQCJ4E5L6SQzyvMHa7ewBdQ5KpxQiswnCvthVIMxpOo9AK1Ia0WNX5zB
	 ems4b6yAxuxXv++Pq1VfPCbszSswOLPcWpSr6UdXXGBy9u/FKY/kSxiTNUVtXMGG/vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=laYSzHNN;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271EA606A32E
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 03:44:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 271EA606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=laYSzHNN
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4ba013938d7so48473875e9.2
        for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 19:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795578259; x=1796183059; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W2b0VXMdCxwEqSCTP3OlO/X4AxL36r2Zoj510JVt9mk=;
        b=laYSzHNNApvR6hkCfW91e7FyeGAkAKidR4abU+y7ghA8I/ig+rBp4IhezAN7BpYWH3
         f5Y7CPtN4xV7uJPIaE56Gva0Rp5GUYs5GwSqRjsJcJVv2f1+wmo29KWJzeu7eCxi6m3c
         9Au+o4hVYVaxhe0/Cel8skNSDR0POHCdew23VxzftD2vmyoJQvIikRA1VdEp4QXuCv/m
         hlsnWVQEES+Dp5ga9WZt8jZfea89OqfZ6LI28tB1H92eEcyOEQQHudx52eC5tBgRnRjh
         wIhDoX2puuAC+T+JmQLUJsdgugRJfZMB50IIm48HMGcA99AvePM/gHhJt3ufW5ZrcdLd
         r9OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795578259; x=1796183059;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W2b0VXMdCxwEqSCTP3OlO/X4AxL36r2Zoj510JVt9mk=;
        b=BAIgIZKb2rmsSdxogRV8QSwsAkkDvNJLtxgahki6rnUO2JBifOqiWDItDFOyb77G8f
         zTH95LjZD63Q6F+VGeh2r/nOuFrhxgs5e//Ly+6ZyCTTOSnHceLwJ/xzAKoPcXyYHT4x
         mEk2AY6ghVV51tTTBD70BiWLSNf4gLYnrZ2WMcel6UdHoZwM4CSSdzPAWQ6EvcNtMegc
         83LPmF6G6cCIwSn6CHcwdyhLz8JvrvUFNrLH8ILn6a2khFmA/pvH36jmOONBByj3wnak
         f7BKXZOayESITatx529Bp1aaY71hHSU61USvEp+B+5N75N9pcfdZljEfqP4nUG1Fyt8K
         eYEA==
X-Forwarded-Encrypted: i=1; AL+hErHh2Gq9n5Xp/Y5usqpSXdCc58CYWMRRGfuFaLucGJ+7GBcSM7hvFeljLYhBnP5JYqdpp0DspI6xVYt7hVs=@vger.kernel.org
X-Gm-Message-State: APuU4Z8IVtPGFS7zKGqndwbeVMxd4Q+6S+XxvPLZZg+RBXyHZrTWzvB7
	H3+Zy6cXrSSvZStUwqkvDrYIXV5gw7s56VJHS7y9KwSBUvtLKrRRd/01
X-Gm-Gg: AZFdTZd3PLtJIPz53lom85jEhoaiupTBRkUCld47x2cbD5hv0ZNBrSDCKf8CJ3kJ8Pg
	0wgS0PVmD5ZQp4VP5rOkxJxUo7tQrfgFxTxoLtOcgtI7M/pq7JRuTxFW026HUGzLQa0Lg83KpKM
	ZiUkI0NuCBbJQiDoLqUZHju9PWuiG66mr/1Auu00ckKdgi0YMyQuoR7wfeQpG3mYE7gIN+i793b
	UXxKsKPvP5lAtxkh7VrkYfRWWX8t4krR3vvhSSG0VujbK9W6HDNgAT18LTv9MSk5qYllemz0Qwg
	Ar65ho8jkw3I53iyK8c8CnHVC5R+ZWmlkGpHcd3lZ7ZBXL6AZewBuS/0p/JAl0jD2fdrmWdzDRp
	Y2O/uxP/Ml5dukLe3Rxx0NlNv73YwxU8n70aXal1arymyadc0vaqoiiMtG6596WNYf0ojcuhItv
	MlP2V0qh+1eB0mGB8cG1xc+a0+QuGRVX3DU+XiVkkni6khE04+Lp2+EhJriC6+Ab3TaY8Ux59XL
	3OIJkDzBsQS5wmUHxUhsLHGYt4C2VwhNpB2jP2b1iN0UVPERMrQCImtijevYGlKZJZ6eipavX5e
	eUIU5Sv21EHbglugKo1lx4jU3iEqnFELWgzebw==
X-Received: by 2002:a05:600c:b85:b0:4a1:f720:74cd with SMTP id 5b1f17b1804b1-4bb8892ca5amr333720795e9.24.1795578258707;
        Tue, 24 Nov 2026 19:44:18 -0800 (PST)
Received: from [10.32.31.239] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm391107925e9.0.2026.11.24.19.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 19:44:18 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Wed, 25 Nov 2026 03:43:05 +0000
Subject: [PATCH v3 09/14] dt-bindings: thermal: qcom-tsens: Document the
 Halliday Temperature Sensor
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
Message-Id: <20261125-halliday-dts-v3-9-5c8311c0b70b@gmail.com>
References: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
In-Reply-To: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Guru Das Srinagesh <linux@gurudas.dev>, Thomas Gleixner <tglx@kernel.org>, 
 Radu Rendec <radu@rendec.net>, Will Deacon <will@kernel.org>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
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
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 iommu@lists.linux.dev, linux-usb@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org, 
 Stanislav Aleksandrov <lightofmysoul@gmail.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795578204; l=899;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=Gu7LEPVBsHDlbEA7f0+bCh3HrNIpvCrq8874bMnEMyI=;
 b=LwuvM0V2lFpMa4PY9K99qzfFeTZgXvTT9zRsWf5xnLCKTkxZox/BBQLcveRV+2SwtDIXcUnAz
 dTyT3erZvMTCCtObEN8DKkAXoSDLM9Igo6aZR3InSklVdITD6tCjFp8
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Temperature Sensor (TSENS) on the Qualcomm Halliday SoC.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/thermal/qcom-tsens.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml b/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
index c78074fbcecf..3b440f395fe8 100644
--- a/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
+++ b/Documentation/devicetree/bindings/thermal/qcom-tsens.yaml
@@ -57,6 +57,7 @@ properties:
           - enum:
               - qcom,eliza-tsens
               - qcom,glymur-tsens
+              - qcom,halliday-tsens
               - qcom,hawi-tsens
               - qcom,kaanapali-tsens
               - qcom,maili-tsens

-- 
2.55.0

