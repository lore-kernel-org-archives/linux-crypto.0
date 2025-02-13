Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB6921128A
	for <linux-crypto@vger.kernel.org>; Thu, 13 Feb 2025 12:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739450237; cv=none; b=n48BZ0QI2bBt7Ocry9EauCKJ4piSi2CFo0nirolRbrEEj8McVzX4xCd6HQf0FhnN9/Q8kYqMTUBMvxnwxtZJYtd88I525e6mtVMeq84LYk5eux3QYgKdSlHuki4U4/8G4QyxFR+Ek1P37W2oseigWYXl9BdLPL71Wf7QHxSz8oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739450237; c=relaxed/simple;
	bh=fW7sAMZGzRYFL3koODOtSKxG2i5kLbxepRPq763TAis=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=jbZrt0d1z0qpm58tqqtN4njYbrbc0ZsKW3d7YEJFX58PftMWFiCqvU3KKNmQw8VAO7JJ/DWqSQ6hOF0bx94B92JvyEXS+AFnGzmBAfs+rZyStBmLZ7NBA7x53TxVxzX55OigjH3sClWk+fdHHr7x/1J0skca5Axw/+6leDsOx7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mhozXbqv; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mhozXbqv"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4361e89b6daso5669325e9.3
        for <linux-crypto@vger.kernel.org>; Thu, 13 Feb 2025 04:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739450233; x=1740055033; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7TJDPbYKYTh8WSIk+sYTlBV8pwulu5n/wnEdfyFCUrI=;
        b=mhozXbqvvMzdCLQqxFj+58mnr1s/1m5HGlN4V7bbQK/nRrf8H2WM7FfaDunJpUsWon
         z9rTuo+NlacAOg/ilr1m3L+KK4Loc7HopJms4QABqx1jNT29Li1bQ3XnvbuN2jVKvdQ+
         16TXEvCufIDNmLy4qiGKVbgb4txhi5+vIpYNpcNwxvtrR+fDQAsnANbJCYmcjXhTF8vG
         T2rah8ZAtfq2ftzJMxYQghOlIH0arL4YOMgHDvSAK40xY2wTA/o+miqmlyBYeOOLYj6b
         9/KUbEwt+chalqSqe1jqd8F7zBq0t8XA1GwR/UrbzQ/6b66qhvO/l+pKDTaQgRVmSdME
         wQvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739450233; x=1740055033;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7TJDPbYKYTh8WSIk+sYTlBV8pwulu5n/wnEdfyFCUrI=;
        b=GkQMTm7zhAGWz1rS4bYpjbkXzVN40jAQHO/CPcaCFxbgeXwIjy+AwgQ0jN8KEITBMY
         5bzioJE1yauY+e9R8rt4DZKUU3Mq5CfJ7pGVDlEQCI5v28Fq+rZiRoNbxr5Sd4ejqV46
         nhRlPm/myjDvhWE4MN2MVxzYwuZ7RFsbAphhQE7BEu3JACU3xlQrOAT+fQyBNRc6E7LZ
         Ilt3AFB9EFFoTg+zrMgoXW0JsDhEu3mCHbCmjGmAYwui/plqNF82LtNkD7qiSDhEDFlk
         /JnnxyqG6HC/3ocketu0HriTITb84ilP1MD2UdCwJxVPDSTBRfoeNCO190JRJLAtmfXM
         paDg==
X-Forwarded-Encrypted: i=1; AJvYcCXietN5StGDYZPYiUHqYXsstibbwEwqMwspsS15BIk9diKUpHYEGjaRXs7bnmK/bPq+ieiLYK3WLyfuh24=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiI3rc4jKu2tjwl3gQoMK+pFHn4/czz3zul/6O+s9e37C8+Jyi
	v/MbcBiEIAD5sWY0c3igAq6TLP2Caxu5N1kRcmjHZ0gO7dCJL3F3xl8z0TDIUtg=
X-Gm-Gg: ASbGncsBQuCHH502tBB/TcogKkDgPJ23XNRjjKyQJZGTxo2uKMTb1uaf5rwuKrj15Q3
	1yHlaQza5Tzkv/Px9Vk6Te1GBEyPFrDRcribdzOjvDiCUIJKa9XnxTc9UglfMRrii+Qsu7iruoG
	QxMOoDMDJgQmR+rVnKMHeergt3fxgS154cvIwrzKiEGh7s4FsQ+uCOTn7phTX9SMqUUvqH3gRx+
	5eH27+DFbYqPd4bSxCg63pq1dfUjwSfYX9MKOqR5pdUuMH+MAP98wgRzbRo6DBqeQvsaWpbU1Da
	Gnqw9uLsRxNeOUc=
X-Google-Smtp-Source: AGHT+IHCnSIDPuuaeLeVFJyMSspPK+FKiAXgRR0sKtkEv2sUasQGTaTDJbYx14VE6LnD8+r1DExYHA==
X-Received: by 2002:a05:600c:1603:b0:439:6003:8ac1 with SMTP id 5b1f17b1804b1-43960038b11mr34177115e9.28.1739450233560;
        Thu, 13 Feb 2025 04:37:13 -0800 (PST)
Received: from [127.0.1.1] ([86.123.96.125])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a1aa741sm47161495e9.31.2025.02.13.04.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 04:37:12 -0800 (PST)
From: Abel Vesa <abel.vesa@linaro.org>
Date: Thu, 13 Feb 2025 14:37:05 +0200
Subject: [PATCH] dt-bindings: crypto: qcom-qce: Document the X1E80100
 crypto engine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250213-dt-bindings-qcom-qce-x1e80100-v1-1-d17ef73a1c12@linaro.org>
X-B4-Tracking: v=1; b=H4sIAHDnrWcC/x3MQQqDMBBA0avIrB2YSQmmvUpxYcwkzqKxTaQI4
 t0Nbj68zT+gSlGp8OoOKPLXqmtu4L6DeZlyEtTQDIaMJcMPDBt6zUFzqvib10+L4M7iiImQ3HO
 YODrrvYX2+BaJut//93ieFwxE/ChvAAAA
X-Change-ID: 20250213-dt-bindings-qcom-qce-x1e80100-0897a1f85bb5
To: Thara Gopinath <thara.gopinath@gmail.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Abel Vesa <abel.vesa@linaro.org>
X-Mailer: b4 0.15-dev-dedf8
X-Developer-Signature: v=1; a=openpgp-sha256; l=976; i=abel.vesa@linaro.org;
 h=from:subject:message-id; bh=fW7sAMZGzRYFL3koODOtSKxG2i5kLbxepRPq763TAis=;
 b=owEBbQKS/ZANAwAKARtfRMkAlRVWAcsmYgBnredzuhOx0PfCHwYpuKRbzHl5QJnhG8uSM+zpk
 K3xJEniYsWJAjMEAAEKAB0WIQRO8+4RTnqPKsqn0bgbX0TJAJUVVgUCZ63ncwAKCRAbX0TJAJUV
 VpNYEADGwFG5I95EljWZkGby8HB2fYaHTw0zMFf0IZ7940Kn+aCEECtUQY4sOe15R6q5ez+TmaD
 b9LpSCttPVAnoK+e4WDvZkYyZRGJdBPyxZTff9raXGpDR2/LptFnyAw6xbJjKPB8clDX5rQzSBr
 w+bGpGaPGk5zwkkIxwUWqPfMqXibCLadauy9r7dCxylQf/lasQIN9wDaS/dPzGjkSfi6It28Qms
 h+rk24sxs6iUigfti3scl0YCV26SPMAu3dJbDH1JW6OLJTDE7lS8R/mB4hk4HCZp/xdrP/jXxjB
 d1JJ+4n0rffwqNFf/AxoFBdqUWC1mRoajBtrZWgJPs0MP9rrVrwOCNC0510j78AFPoQG3iByleW
 gG2ld8ITyJcicpBdGjvHPvEYO5QcYJx0xVlexhPSBTJptWTo3Lf97bmC8FHT699R47A/buvRfr/
 aSY2xu8/bWToRhUCc9UGBTi5CsGKMFhHvoHe3sJ7F3d33eirQPTJomrAeuU044bKpSbXeYCPE+/
 fCmB7Uu7xOhXHyu0iJJqupevlfMlb/l9m4LekvtpO5QaXj7LbCGLdbhueiBP1TcLLt2pe/yD2R2
 N82iPVR7+ycDuXnwyQRje8heY1VtxmN61+FqoFgCVm8nEq2XJbZSsYSmU2HdbXI51/Equ6ArtHJ
 FFp49f6WbXc5fmg==
X-Developer-Key: i=abel.vesa@linaro.org; a=openpgp;
 fpr=6AFF162D57F4223A8770EF5AF7BF214136F41FAE

Document the crypto engine on the X1E80100 Platform.

Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 3ed56d9d378e38a7ed3f5cd606c4dc20955194f0..3f35122f7873c2f822772e091cf61814bddfb892 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -55,6 +55,7 @@ properties:
               - qcom,sm8550-qce
               - qcom,sm8650-qce
               - qcom,sm8750-qce
+              - qcom,x1e80100-qce
           - const: qcom,sm8150-qce
           - const: qcom,qce
 

---
base-commit: 7b7a883c7f4de1ee5040bd1c32aabaafde54d209
change-id: 20250213-dt-bindings-qcom-qce-x1e80100-0897a1f85bb5

Best regards,
-- 
Abel Vesa <abel.vesa@linaro.org>

