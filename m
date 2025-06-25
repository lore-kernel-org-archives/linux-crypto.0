Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DE42E0B64
	for <linux-crypto@vger.kernel.org>; Wed, 25 Jun 2025 09:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750843400; cv=none; b=VpD5lvaRYY/ZuLMkn+PLeojG87xCJMM8KI/DQS40CLhDNt6SViynTO5jQsxfg+PHso5nF/NQ0rksJbElNqC3srm+u3Y/zRsolPiYuN1QBp/Bw0X55E8xDKME1pJWQVgu1NXH6n+JSxR/SS2QfE0e4O86Egs+rKtTA2PnYbL8hls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750843400; c=relaxed/simple;
	bh=kMLBa8XpPsXDlevy1KezXuXVxIBGJ+gP0d2yYQ8HaFg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iDsrX9hRbgnStMrL5zZj5nf1ac69SuhHKgLV4zBaSZ3Oeq8WGXJ4b9HUPFXdotnxYHOMjUvTG5KvhqxBK3+NwiQxIsGD9mYWDENqRMl+/1x29lgf0oEhgZUBqB+Itmnir6qtl+xFWeFCtXBJlpTsKemx5ldZX/1aN1Wlb5/+G6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=SALde4YR; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="SALde4YR"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-607434e1821so9291637a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 25 Jun 2025 02:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1750843393; x=1751448193; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UOHLr8D9V4NN9mFAr1BTUycpg0tsYamgkXBgt1W/9eI=;
        b=SALde4YRCJjksmuc6U8y+xUk9jyb2O/Ii0opn4gsCd6/TCvaIJzKRlprrvC8XAb4Dh
         lLLqcrU6IdVaB7uKOgnQCoz6tLsOErtEotkc5+92GRKVUYmRtJ8UvB6jw3kKF4sHO855
         EF1qkh3M/wcp25k6AbZLNoE4DzpKyUDdQ968CBjuDhV1TLQChy3EMlQBqblE3L5wekPi
         tmuz8wAMnfVwwXSsq+vLczJjZNYWOUYhtWCYyruEU+3Ao6xitWLT9wDpv3L0iWvYFhDF
         gB/FFzSc5GWOlq25Y6ZarYNLQXG7N8fZHinVT0wSeD/chjzZqY+KeDnzN9VSFAHRNv9j
         nn1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750843393; x=1751448193;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UOHLr8D9V4NN9mFAr1BTUycpg0tsYamgkXBgt1W/9eI=;
        b=L3QRLqL0OY+4MjTszIBlVDOYDxsh4AQ/MBddqQ397hZIgDh9GCbU2hT81dimepqg6i
         o3bf1A5OydiRZkYe8Li+bVryQE3pHxlXrCAkJC+HzrvepDK9WY8AKn9OyO6TKtWBzjcu
         OyI2ECuj361mxUqged1H4Qc4K0mq3zAovyze1/uFJkUs7UocivmCikOXAob7IU95NGEh
         UvIwITDUJdLs9Kn8NUK48NLcw+2SfTj31bBbEOeajE4S+W+2/8lm+i98nO22ol61LVK6
         1DU3H11AlMmqT7JF8KmFnWIApUQC2apzlATF7/0KxFy2+WP4VJ6j010kccFkYX0S89Dm
         MmMQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/IEo4v9XEZcqez2OT/ASQPlVuGV5hodUjz5ak+Q34NM5i83YekBNxOhue96XV4cOb60tUXFVDAUMZYj0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXuQGDDvbP0o+OPKf+DrdBpBGhm0KyVdAkijNmH7mpTmJhYvI7
	EoH9K0hltoCU/jMr74fnttDCswAuQXh0Vy5VgsEP7eaHet5rL7uP1jKakbNRyTjM7Xk=
X-Gm-Gg: ASbGncsFhuZXV4Sm5i2sD2hu/FObS1OmTKuMPl830KvdRUiD16VOI5am6ITB1Rvfq2u
	KMMybW/TpGNbcaylRfo9pxoO5O1JjB3sOUs9t2BDLHXGbQDtGjDjeEM3VymT1W3op80PJDY5W6c
	fctxktG7gRZXKJDPNkn2W8J9OfLJEuZYu7jWrTZw/9uHh5b5JVlsgFeNYT9M39hrRdI1mq6tb/U
	q+wnKtOUizOwvetJKwzecICu5DC5o03DNOamwap2l1KDRdfo/SxDgnk2x5mYQMTFoef4PMeceUJ
	3nDEbTVdNzEBLwpSi5+5OOGe/LxPC9AJD70PzrugME6l0rBUNO+QZfN9+4TlRFHxnlAkos2z9yI
	vQ2BqcbArY/3z0wPiW9Ez3UFTlrMW6XJn
X-Google-Smtp-Source: AGHT+IHB94tY24lAu3oQO4eGRW4BZuV+A/oDZCQK+b5Z9Mh+mG0nksh62lt/+F3W7DxAhvn4P2IzDA==
X-Received: by 2002:a17:906:d0c5:b0:ad2:417b:2ab5 with SMTP id a640c23a62f3a-ae0beba2300mr176480866b.60.1750843393322;
        Wed, 25 Jun 2025 02:23:13 -0700 (PDT)
Received: from otso.local (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae0aaa0a854sm270277766b.68.2025.06.25.02.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 02:23:13 -0700 (PDT)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Wed, 25 Jun 2025 11:23:00 +0200
Subject: [PATCH 05/14] dt-bindings: qcom,pdc: document the SM7635 Power
 Domain Controller
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250625-sm7635-fp6-initial-v1-5-d9cd322eac1b@fairphone.com>
References: <20250625-sm7635-fp6-initial-v1-0-d9cd322eac1b@fairphone.com>
In-Reply-To: <20250625-sm7635-fp6-initial-v1-0-d9cd322eac1b@fairphone.com>
To: Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
 Joerg Roedel <joro@8bytes.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Das Srinagesh <quic_gurus@quicinc.com>, 
 Thomas Gleixner <tglx@linutronix.de>, Jassi Brar <jassisinghbrar@gmail.com>, 
 Amit Kucheria <amitk@kernel.org>, Thara Gopinath <thara.gopinath@gmail.com>, 
 Daniel Lezcano <daniel.lezcano@linaro.org>, Zhang Rui <rui.zhang@intel.com>, 
 Lukasz Luba <lukasz.luba@arm.com>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-pm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org, 
 linux-mmc@vger.kernel.org, Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1750843387; l=893;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=kMLBa8XpPsXDlevy1KezXuXVxIBGJ+gP0d2yYQ8HaFg=;
 b=mdr+a+luUjX7AFv2DO5FQDsLMYgOBVUahwjTho7Ooy7Ze3zZt8tNJoSuRat0p8SJ/e1grPELu
 6pVuw/hE3yPB2VtbzJkUjC9SFW/NHJPRSwLMfmGq3pXJPW/wvwZrJgp
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Document the Power Domain Controller on the SM7635 Platform.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml b/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
index f06b40f88778929579ef9b3b3206f075e140ba96..e809f50734bc3136a8915a12a1a1cba2bdb62890 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
@@ -43,6 +43,7 @@ properties:
           - qcom,sdx75-pdc
           - qcom,sm4450-pdc
           - qcom,sm6350-pdc
+          - qcom,sm7635-pdc
           - qcom,sm8150-pdc
           - qcom,sm8250-pdc
           - qcom,sm8350-pdc

-- 
2.50.0

