Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419FC2264C9
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 01:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331033; cv=none; b=rfuG395okPlrnm6od7/qPG1QdYg3DWnda1O47sxmJX00sswaFl8G2URaFl7goFZ/HY0osJG3TY37BibjfvCayZOy5zBH4fqW5B2BEc/R4bQviI3pZMW9ghnAT5FUB/XE5jDVY/3q0oGweily4G8/odW2Z4Ts0wdrovGGug4X1bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331033; c=relaxed/simple;
	bh=xhCXot8hsmFt2DLcSKtSiw4vNTASFIkZ8KLq7GSl+P8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MGsOWvtTkW71SJdowgzBIXQI7YxvEnW+rwLLXlJipo4RQnSYn8db9e8f7fb5sg/MnksG1mnQ0zWfV0kPk7+9SMTpoqo3+ZvlomEH8Q1jcIMgBJutuqJFNrLOKtQbAp7V2BqUz8SXV9OTopEyCCKJpfrqUpom15iQ6jDCt3Hw1ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=TKDHQREs; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="TKDHQREs"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-477563e28a3so3078795e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 09 Dec 2025 17:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1765331027; x=1765935827; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1N0IBwFgNK9lNAZzgqz99M2zuZW1zwkUP1bnHP+9GJI=;
        b=TKDHQREs54sbkjIhQkuFn/XV6kK+54opSLZ6QEKOAU5/EbEJ2CZTvKFZ8x7Cw63YEM
         k7rXeKv01RwL8bSnW6aKACEBZGLkZspsEGtiFumr9SkkUAtSNR2BxyBPy8oLJnxe9tDT
         4mzITkCSGwMNHrwR6vIA+V+MamKRLq5smB5EnbslbX5XQIh+BcsfiHLPf5UOG7HtMY/F
         p1nb37fs1mHyp98HeRV3h1dmcIAdq62loFtp6G2PVmMWhcHGEsVptY11sEVQ+KzzGpzC
         AnQoGjGyyd171mH7fBbh9SY4KorjMHVr89t3Lj9J4NXw8ZAOmHPZD9TpZ9XppEH3AArL
         3Few==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765331027; x=1765935827;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1N0IBwFgNK9lNAZzgqz99M2zuZW1zwkUP1bnHP+9GJI=;
        b=loS2+mv4Om8Sguh/Neqkhywpak3sySqaGEXzafQ//ivgExBUkWM2WCSTx7dmSjLfET
         uN9SC6HkuimCR4Jm8te/81CRTjEPu//CH57r6vqt01r0wVq3L7SAdwcLuQ5SrV5ppw94
         gNp5+eA3zDdZILvtnXLdjlAU/e5CAdj9riS7fONUyM8skxxFTLcqC+Y5ygxamEf2umUs
         KEvKCdDFJs7w8zbaXep8h1K47JrbyOw4CvB6tJZ20fskyw1d53BPwiWJoOIxHcMjYXYV
         q/uGPF4QY/OPqe3lWOqjtcUqPILpZ6UcZzj1WsBEsjow6TKajPrSl2I5FRQJ0FAqldxj
         F0rw==
X-Forwarded-Encrypted: i=1; AJvYcCWrn67usJfxxSqUDDXU1hZi+/ngMaI88wjT3dKvdIio0WSBWzU1J9Ihuu2rX/NTQwHKRED63l/MUqtNzkg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyjKxBFVbs1sWJcOYd/9Ua6C4Ig5WjI/HnO+44H43SWZGrveak
	PALcLk6iFl12CmwtRW6jWr9mNuw7SfQvCZsnOJKgUny6SmUYaCrc2BTd0RXgYrkoCUBW8ryMt8d
	ZFJusmUXMlw==
X-Gm-Gg: ASbGncuj65DhL62Zd6HNhRTFUsUtbkq94H1uPtBl2ORPDlPxFYPJpPJ77mjo0yrm2Mp
	VFuJhrPdpvqty79GuRygdMV/82Ttpdy9Hu5DyZYmx6tGwRlCQEX2K0XdVHtwJFb1hal1EphFBa7
	DHA1pFLFqbpvPhRwBNFPMWEmEFzweYNUhVadIC6sdRvxi3n5REoCwJjWca+LCHWom7JnzGRq7Hc
	+nc5pvPKQ1f2PEXtwEi7feQE0xUTp7/B0MrU/ixAuLDPALiowafJjbuwZ5UnhfEOD+QX19PQLGc
	k9GDOUzLFAi3kMHmEgj2bPtyyt82DvUInycUPaFh5p1Frcryve3mwKcL2rV05vNOtTqtE1j8II2
	85tls7eKiSdHDVqgsNw6DwkGQ/Jjz2ae2ctsKStP6t4hUOqTwwWOZmY+pjU80sBkUTG1UM5dv46
	rhNBQWwkZl1o9TAsZjBJXlv+Tom30SSURfj7iA2l7s4FmAgOj5mA==
X-Google-Smtp-Source: AGHT+IHIpDjAlaX67+EUBebH5WfoD8XeTaU8Q1moEvenJxA2sXGjjcYDyHTWr5ZiRpqzWMTjThGA4A==
X-Received: by 2002:a05:600c:4341:b0:477:14ba:28da with SMTP id 5b1f17b1804b1-47a7f919251mr23649585e9.5.1765331027253;
        Tue, 09 Dec 2025 17:43:47 -0800 (PST)
Received: from [10.200.8.8] (p99249-ipoefx.ipoe.ocn.ne.jp. [153.246.134.248])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34a7000c984sm705234a91.6.2025.12.09.17.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 17:43:46 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Wed, 10 Dec 2025 10:43:26 +0900
Subject: [PATCH v4 2/9] dt-bindings: crypto: qcom,prng: document Milos
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251210-sm7635-fp6-initial-v4-2-b05fddd8b45c@fairphone.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765331010; l=921;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=xhCXot8hsmFt2DLcSKtSiw4vNTASFIkZ8KLq7GSl+P8=;
 b=uiHgbBzSh/cvk/RRJg9TS9wPZ3NQ27X91ICPemjxsmFWX4ZAsH6iHP01WgSN8lo1qZwesg/1h
 kEnQZwCIdjIAGmxpMUxDCitqwcrIBDFnbc/XAkCmlbc6L36YYyelCEc
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Document Milos SoC compatible for the True Random Number Generator.

Acked-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index 597441d94cf1..a9674e29144e 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -21,6 +21,7 @@ properties:
               - qcom,ipq5424-trng
               - qcom,ipq9574-trng
               - qcom,kaanapali-trng
+              - qcom,milos-trng
               - qcom,qcs615-trng
               - qcom,qcs8300-trng
               - qcom,sa8255p-trng

-- 
2.52.0

