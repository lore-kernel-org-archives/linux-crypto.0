Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7F319E96D
	for <linux-crypto@vger.kernel.org>; Thu,  5 Sep 2024 15:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725548962; cv=none; b=bZyzChBggcUeVm0hu+ko5SlPR4pv/Xor6UtqniEQ+f9uamnfDcwftXYdVyj9wUHtmLObXqqVfAU0wsdQTXCdYR7IbrMlSKiN2GdtnhrHVk4gY857YN04BEjQn5KHPW9gzZUQO+rG75DmP5x5pEWVSrTqAmyjQbSTehMtdpRtqzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725548962; c=relaxed/simple;
	bh=WLkEW3TQoHM0CaqvHP+UnEcZrNRj2Yf8ItE7bUlRtS8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gjn4tptt8GPyqfFhueaEWDk4JFdP2DPqFEbP44D4/KB8+1f5gesosdkhiC9RFVim/NsmAKZIb82gGbxne0E/yg633HkWrQdl/Wf1zduFnG5BIJL8FXwwZkUc3bjh6Qs+JFlHTmKj1pmfvuyNPHMJax+ThWnGTViGWwVEe6Bemv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=kMZmYw7r; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="kMZmYw7r"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2053525bd90so9153075ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 05 Sep 2024 08:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1725548960; x=1726153760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sETn7qpcDB4MO8FELll1einBheR1j7SuMJsqhl5kLhI=;
        b=kMZmYw7r31IZ5vUzT9lEpFsr64xE8JIG/f5ggMzZEwxcN26Zh/9xfB23GZyHVn0DS0
         F9YsLnfj+x0IHT3tHOcXHJt4EUzwEFd3+fW+LIk93bCQRYp1sLyu+GmDAXKvYvSSiZkC
         w3fYx1naMzzpdwkadNaexIEYOT3+33DbeARBU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725548960; x=1726153760;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sETn7qpcDB4MO8FELll1einBheR1j7SuMJsqhl5kLhI=;
        b=pRQRjwzc4UByvn8Lb10fD6PEUS5f+YlZFKRLF/E7ABXx/pD/GCfv0mii6EFY9DhYQm
         FiQw9ZFafzNYQ04HkVBNZUUbPIl2aq45p24oo2De3Xbb9FEBxS0i35ur4i80ajyoCmTF
         0+eW2ZcFNN/FsZWY11R94swclqIodFn20IsFBT3DUT43fRIVL09OHStDYjtl2S+gAZnA
         4/W3MiuwEkQ2BjD2aZJRwPR6OqqosHoSFt+FQ/qkLfzJjAm/INGGbh9u0E4ZY01I0FyN
         3j5jnkCcuEL0KBwYbC/+LFnfmCqZGilsJsAZ8ME8bmCUhuS8G2Fnn5uoxBv68oSTl7EF
         V4nA==
X-Forwarded-Encrypted: i=1; AJvYcCWbBrCyaDHTuNOHSvTHr1O0vMVuBiICkJ2HuA3Fvmsu1goU5Xa2la3bRtO77kpP8lShF5Dt/kAPl+3/l0M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8VUo+Bf8klZq3VQUB+bLF1gmMD4OLAzjdsrIPFwZSKaMcA6hL
	Hl/wmTLItJ4KW7GAvs92W6b2KWshB9gQISu2ERX1j5/PBc0hTkYE6VYJg4+fV90=
X-Google-Smtp-Source: AGHT+IFSNW87jp69oRBynFcp7ozKI+L/QlTrEHAUPupMO1ZJANWl5CcvIppe0l+DAhSA/H57Jt6CWQ==
X-Received: by 2002:a17:902:ced1:b0:1fb:90e1:c8c5 with SMTP id d9443c01a7336-2054bd0fad0mr206521375ad.33.1725548960470;
        Thu, 05 Sep 2024 08:09:20 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea556f8sm29779855ad.198.2024.09.05.08.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 08:09:20 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	robh@kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v1 0/1] dt-bindings: crypto: Document support for SPAcc
Date: Thu,  5 Sep 2024 20:39:09 +0530
Message-Id: <20240905150910.239832-1-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

DT bindings related to the SPAcc driver.
DWC Synopsys Security Protocol Accelerator(SPAcc)
Hardware Crypto Engine is a crypto IP designed by
Synopsys.
SPAcc can be configured as virtual SPAcc. The device supports 8 virtual
SPAccs. They have their seperate register banks and context memories.

Pavitrakumar M (1):
  dt-bindings: crypto: Document support for SPAcc

 .../bindings/crypto/snps,dwc-spacc.yaml       | 79 +++++++++++++++++++
 1 file changed, 79 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml


base-commit: b8fc70ab7b5f3afbc4fb0587782633d7fcf1e069
-- 
2.25.1

