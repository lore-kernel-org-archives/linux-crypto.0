Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91E3364025
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 05:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778823760; cv=none; b=a5ibApsLXdIDOauIraK3SJPf93GEWwdJSCPwPBX5DPQG0XsMJC+kL7Cvjg74AH+fxJfEwLEgSiXFmrLD2gv4J5GjJkaE3IYFzye3egdHQb5RaznpFQKi1NH+SSRPo1HYLt3ATL4h6wNH61wdYSj843a8N4fnlYs7Hk2DabCpDus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778823760; c=relaxed/simple;
	bh=Uj71YxMd7CP0/+rQajvUXPXNAzpKdvAdtZ6sztvIkfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxFPGwEP1x3PJupjBFBIDzQssgbBMPB9trE18Ata6B1o30jm4xFfjC46XIbkT52OiNQyv7uiA/3OxGrHa/vdvSw3lyo1HI/oPv29kgRm0BaigxzTAHQRL2UxCWT6v9H3ThO+S/37sc2xdfp1cQDxn7rMUBO3wRAQXt4LOGvB4X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TyccnjCo; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TyccnjCo"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82f8b60e54dso7121892b3a.2
        for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 22:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778823758; x=1779428558; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0S90v3cSnC5Da6GOQpoJCPTnbSf2YszUbZPGAtd7qaM=;
        b=TyccnjCo4ObKyoBHeWWN0uDjXxbjeo7qEUhVMUXhuS7N342JBrsNaAwA6mG4BKLzrh
         UA0AhBDlvKPTZjGeXFIDUICBZAZDDruCD2uwsXsu1DORDIc+JFtsbJQjBHa8dexqap5T
         VRR/a+jCOwc+UdR3L3UoZG0S6XUllwzUzZMf4JNQMI9sdXgC3czHojU2H88VS1q8xDTu
         2Cc4XuQ//QpXgsitNSPiIWbiejqkjMtwywab7QK5HFHGQyZRfAT5MOLAD+pXaMfGL1jM
         LF1COegvVw6wAZ79+jkDrg1T89TgLx5V8aaHuk9WTJHLUNAlDQM4NzGJzoWapa6MN13M
         T/Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778823758; x=1779428558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0S90v3cSnC5Da6GOQpoJCPTnbSf2YszUbZPGAtd7qaM=;
        b=ng6TxiEaiL4wdMnxuMaM7okeK1C0IcXpxV1ZM3kA8neklu7ImykfmSXcUIgHcAfbcq
         oeySwarZ4HXy4mM2LKQZqZajqWe1NMtAIXKkFYInj/QJyq9lpaI/6t1Q84M9LbsIb3Br
         nUA6FDIhdyz1WIXVYZZR/ThGtEhyqda3xzI/LXh10H0RMFJIAXV/JL4meJrax8XkK0f8
         W7AT6RuYWyKtQTXKa+FfeXbYsLpmycg6eeddtTTeBEuTW7tRjkmD+Vmc8WxZynYnoVbg
         FJAR3NiFDcSHvrfI5mw1cZN9F/g3p65XhlR8HrU5IQyHHHQfldXUNRc8uWgr98LE+T+x
         su+A==
X-Forwarded-Encrypted: i=1; AFNElJ9kDTlLlwBqqUVJu8GsfKkwgaUwvbL5uKBgq0nhmOfrBuVpEkfLauvly3v/ifaY+wzfPgt9TL/FI7NgVGk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+42emyKV+6Fky0RqTzwCAVlDLfjWBcfuUhOPf2PejwHY9DP4g
	cAM6h7y2mPTwHKCTz0qsP+Z5rtffQibtjZXR5eIPXdORaqWZtItt7kQc
X-Gm-Gg: Acq92OHIvN3J3mqIvDZ/Xj6smwRd9zGVZMwcHacCs1dVEjMc0oaM454cRylWq9HEtR1
	JER3hSQ8oXp5Skj+olv3VBCAS/XYWdGzet2eyWM/+IClQz4SHxF3WtVKnkYIwuiCz5raxepGzed
	RC+JE54w0ah3nu3d20uE7pi7Wcn8rYR+z4GF2f0YcEBA9FGxByTBE6t8iIMhXXoDS/6CSFWxr8X
	dsQM0B0XN5Ao7hrsYGvFmkXu79e2M2qV9NG+9x9JzZ6G1fFxVh5C66cODnv1MJTNmavSsK44tRh
	Wx0aFa8Kkv0otuPNU1QrFAP1BafDTqSmlxiuO5P2DLUVp6J3tvO1gR3rUESzjO+26bsZPv0ojHZ
	O+OLNOvd/a1KhIuSIl9btnW4JlI4E9R1bTiPn42zhgOfi03eOy935omDSnFGUEa8JXylC7OXn0x
	HQJeGbaGZj3Rcss9l9oROiF7ypRs/HeS61vG/9Clgs49suNRn/9z4/yNMPeDWLAeP3cIaQqkpE5
	8yCYbXWSUZy353HPGs6O7/ISoQ=
X-Received: by 2002:a05:6a00:400a:b0:835:cc47:6fe7 with SMTP id d2e1a72fcca58-83f33d96b70mr2736897b3a.30.1778823758064;
        Thu, 14 May 2026 22:42:38 -0700 (PDT)
Received: from harrison-Surface-Pro-12in-1st-Ed-with-Snapdragon.wework.com ([203.117.161.34])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f2b9bec8fsm3106116b3a.33.2026.05.14.22.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 22:42:37 -0700 (PDT)
From: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
To: andersson@kernel.org,
	konradybcio@kernel.org,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net,
	neil.armstrong@linaro.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	jikos@kernel.org,
	bentiss@kernel.org,
	luzmaximilian@gmail.com,
	hansg@kernel.org,
	ilpo.jarvinen@linux.intel.com
Cc: Douglas Anderson <dianders@chromium.org>,
	Jessica Zhang <jesszhan0024@gmail.com>,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-input@vger.kernel.org,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH v2 2/7] dt-bindings: crypto: Add x1e80100 inline crypto
Date: Fri, 15 May 2026 15:41:47 +1000
Message-ID: <14cd42e3d3af4b2591c9dd8dffde11ef18666751.1778822464.git.harrison.vanderbyl@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1778822464.git.harrison.vanderbyl@gmail.com>
References: <cover.1778822464.git.harrison.vanderbyl@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add compatibility string for the x1e80100/x1p42100
inline crypto engine.

Signed-off-by: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
---
 .../devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml    | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 876bf90ed96e..a338c4a33e98 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -24,6 +24,7 @@ properties:
           - qcom,sm8550-inline-crypto-engine
           - qcom,sm8650-inline-crypto-engine
           - qcom,sm8750-inline-crypto-engine
+          - qcom,x1e80100-inline-crypto-engine
       - const: qcom,inline-crypto-engine
 
   reg:
-- 
2.53.0

