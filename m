Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B4422D793
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 01:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331038; cv=none; b=mC1g0tOP5haMVAOKWaVgpYY12If6TIFZVlMHNd6XPO0hIavE24JazGrjJ6nEGcLVuelD3cLRI5KxAgC//khZapyvnaA69fT4cXtwI+iLUEXUIJ8ztTZjHZow469I7sX7B67Zd1+ZPdLVCedW+XLHLzw+qHRY9nOO5xHvT9Qt9qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331038; c=relaxed/simple;
	bh=64R8FCiMEBBuwRxLEqvZs1seDkt/c99ioBjBkZyRvHI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LwlcYiK19BwKhn/IDrOfDROUGa6aPGgXF8wuEYBwH2UfW9uGQngEcbPRHeJepjYz5EYp7baNvalmMUrj9y5hFC3v35AJ5soSpJq8HW+Qma0NzjRwHgeLw7jF7DZqQaP0WHSO6DP/7Tm0qt2bOHOvpzyFlSj7IPbBchYFwSykeZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=Im6H2wz6; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="Im6H2wz6"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-477a1c28778so77930895e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 09 Dec 2025 17:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1765331033; x=1765935833; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fRkZVQo8Cy9rpkzUUZawgGrEURlfhJDKheEKuiyOhG0=;
        b=Im6H2wz6ZpCbSPMSItjq5MXhQRVhes/7SiyWlZRkjrpAvWuL5ZD/t1NP5jAtba8TaP
         Jky/oGbEW36YV08lAlfNlAbptgCKC9qmSRpfSfcVeeimYowD3bDB6JS5UuRFXIrqlZWq
         knIwyMg8raKGjClldjYIStxpJIFGP+gNrMwcmE/j4iRiTd0pzwrRGHdOQbjdz3rehznZ
         czfFjkdi1N7LIDRFtBSCi2gVUzdCSdDRpO7C9FdnHLtW7BGySW0wJEMTCN6ULWAYyQCe
         z7QajDfr1IO83kM84VSvDktSsVp7EBwaZXwTCaqjz8cbaaebZZLc23EpNF4a0Q1ucOkP
         aUig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765331033; x=1765935833;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fRkZVQo8Cy9rpkzUUZawgGrEURlfhJDKheEKuiyOhG0=;
        b=mdqVVrLIG97yxd3va316BsdUnKIKaoTNFBsMfaE5ZP165bCvISTBFRm8M4rxgPHZmw
         a890mtUv4C8GgYdCMQ+oxAxVUx8ISQmjrGQxGw2JnBVjPOKIDhaYcRMZSnmkMPey37a9
         82d6C5eT+z1gx4thT6B8og1dzU0mdkCYB10fPKCzPsenIxk8etO9W7jKFeaxDGQmC7dP
         VnGOGzAa98ZtI7ucXylCSANBIUxI+sUujvRBREkRfkN4YovA2ctT5FcjdBQgoyJddxza
         jceTuZeee4ZougyRj4sODKbpRSXIxLBc5sWnisERxc9/UKP81Y+kkDIrBihuyftW4mGO
         b9Ag==
X-Forwarded-Encrypted: i=1; AJvYcCXLocXccju4vb6yZoa7KcwFNeHvPjEgkEkpDwGNfq4edhctdIowRp03p5DLz+00fSTDkp29uKoSKjPpj3Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcfEjKea1cYuxZJxfUoX4pwHbNosSrBSJctJ4G57QIH3sXO3fZ
	XvrH1OTMnHeErH1gez/dJwn1ij2VSMeJ3scn2xAZkl5KlA5SiwcxslLvuhYkRlHae1fss86AVd/
	qjYvs6Th5QQ==
X-Gm-Gg: ASbGncvIMFKtIYchRfH9+h0NjqmXExwZIf6R+rJJHDapfSNLJDqHX86aOgH1oQS2x5c
	pUvTs7cpwAQnB1/Z4PZ2+fizHSJsbGPu0gpzbVGb8Ip1qZFSTopECKTpnB6fFHdaeBoUlf2U+TO
	HXrkdQmT0CJgcSOL1A7s2k+hiAPpiFWquYh0MIrtNmH8eHe2N8D7jLK3y2HG9h+0fEZQhUeojAr
	TnEyoudwBY9SBFQrzlIZhR+4A2trdQ64F9Jo7ZJC0klfABE5mfX9wZ1KNqWVIVSIbYcAXfB5+nC
	qD6wlBayjF3N3MqZPEjIwyZD50csKzt9uyKkcYvUdfMsoWPwIGerQi4Eb+RIJP+LzwJTkAeUjAm
	ro3Vm3QO1UVwDRe/AyW+C4o+Mv02Dy7xD798Frcbru7Ik3T2GoTXC9p2YGz9l3nkAqkfmp1tc9v
	bSUmwyxJrNDbGTD5CPsJY+r3yeUClEMuQk0nnGxjWRn+r6zA4P+Q==
X-Google-Smtp-Source: AGHT+IEqEijBe4vhE35mjP/G97WmH3BU6oTyIW6Qj47gs0IT6FwNpkQDR5rTFw4LpB8j9mZgSjrgaA==
X-Received: by 2002:a05:600c:548f:b0:477:b0b9:3131 with SMTP id 5b1f17b1804b1-47a83745633mr6952945e9.8.1765331032968;
        Tue, 09 Dec 2025 17:43:52 -0800 (PST)
Received: from [10.200.8.8] (p99249-ipoefx.ipoe.ocn.ne.jp. [153.246.134.248])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34a7000c984sm705234a91.6.2025.12.09.17.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 17:43:52 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Wed, 10 Dec 2025 10:43:27 +0900
Subject: [PATCH v4 3/9] dt-bindings: qcom,pdc: document the Milos Power
 Domain Controller
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251210-sm7635-fp6-initial-v4-3-b05fddd8b45c@fairphone.com>
References: <20251210-sm7635-fp6-initial-v4-0-b05fddd8b45c@fairphone.com>
In-Reply-To: <20251210-sm7635-fp6-initial-v4-0-b05fddd8b45c@fairphone.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, 
 linux-pm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-crypto@vger.kernel.org, Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765331010; l=902;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=64R8FCiMEBBuwRxLEqvZs1seDkt/c99ioBjBkZyRvHI=;
 b=mS3y+bW1cfkBNdq9xXjZsHMDg9KgFcK33rSnqdmmReA8YaNj9DNz+pBy+zfhLNlKKb8jKt0Dj
 9TE9ZpjTAS1AbioGTNl4NiN0f/N3jL0VZ44slBPjbpXyAPv/MTK1/BH
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Document the Power Domain Controller on the Milos SoC.

Acked-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml b/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
index 38d0c2d57dd6..0c80bf79c162 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
@@ -27,6 +27,7 @@ properties:
     items:
       - enum:
           - qcom,glymur-pdc
+          - qcom,milos-pdc
           - qcom,qcs615-pdc
           - qcom,qcs8300-pdc
           - qcom,qdu1000-pdc

-- 
2.52.0

