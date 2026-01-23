Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561573563F6
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769152371; cv=none; b=MQd4qkLqggA4zewgB+D6j1ARISPygpaM2DNPlCQ76+bOcNKUxAfoaC3AMp6jxF4vARKaaCckex72/e0X77jTbpjYgGWfDkzpE5pafNCeOb9cc5Fmr0WJBSxgTDE5YzF+XL2RjLHiof7NGLDHHlk9SYEeYCOPxyeJlFUOLl7SMlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769152371; c=relaxed/simple;
	bh=oAm2w1B3wOADUYdbdnTyko05ceBRrrkfGqHAPNZJ7nY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CR4PyKtGNRwuRHJgIyX5ZyJ6tCZdON2jqz9zaxKvUgkEK4wv6NDvBC0vrqhACG7SYdzLFEsN0OYQqq5+tHOuvxzNXlfNc8BmRivdLDcXQPZtgFi8wAUyznC19Ytx68S15PoxjRE166hNYLjpMjGSBgCt90rXtxnah2ayNbpgwb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lob5GiHm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FWD8/D0Q; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lob5GiHm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FWD8/D0Q"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N4WKOs3677922
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:12:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BlCzppJMP2kP25D2fk1iMHsxDptOoAXzHriXIuLywfA=; b=lob5GiHmioZXDSJx
	nIRqWYHQidJZCY8Uf/IO1b/ryEUxkDAF3aqFSwA0YsNqpoCRZmEo+WVqwQtkOmVY
	8aOUgNiEVW5x0wVe7pZ7w3BVy/g1Z8YL31J1s1zxr3u3tUVs29AWZHeYQP1KOpMb
	0ukf6Imdp73OtzRvhaG+Wau2A8Pb2VdL9ArMBsJ2P864vkdx89ROsGn0ryBocsvO
	DAdWp2lveZ7pHJ5DBPQpjz3GtKXhAogxgc8PrvhxyrzoUEyVxlZgN9qG03YU0unY
	FXGy4HqGgBphGsrVrUzOW+Xj+yrRKYti7raTaeALLH/B+F+anNlOs7vUm6ySb6mk
	UoGo7Q==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4buqyp2ena-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:12:47 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a0a4b748a0so36672595ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jan 2026 23:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769152367; x=1769757167; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BlCzppJMP2kP25D2fk1iMHsxDptOoAXzHriXIuLywfA=;
        b=FWD8/D0QXXc4ycD2SRvZ4vm7FCbPRZZNlG+u/x5x+Xwj2B46ifmBgzxJ3KkLsa1wr+
         +g9pizAujq9DNQSH3r7Re6nIkw1/5QiJKnGkF0+HovNF06QKLbPXU7i+VSmO/EInFpIq
         wgt8yPn2RelUis2FIVcU2CglEJW8oSw5TyyUx3D9vTddTQBFjrv6JXe63uworqGd26yf
         UiQBstGI7dsO+A6r/2ivW+Z4M+20tBJu7r/65ImUPYplsZIXK1BHxql+pLlkFO3cjZq9
         n0uVVRyYBDPN+GxkObG9WmBX2lL7WnT4tbKLX4QQWz9DhaDA57u2KcIcreIqRaDp7vHg
         adPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769152367; x=1769757167;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BlCzppJMP2kP25D2fk1iMHsxDptOoAXzHriXIuLywfA=;
        b=uduRQvDUXvRXQ762USDQ08CJn5QspVCTepDtoE78d4fZT/228KPvrtO+nOYUeByWd2
         7hN3a434b0XrsXceImiT8rtrhwkD//0Fv5TLTtgdEaJSTnUOpcFcdvHNYJ+5tWKHdyyV
         asgV36G5dfXqxuvO0kabVzywAitZUlx9/08bhhMkQH7VEj8MFp1JOFRWpU56HKCA+ZJ7
         y+QaTHKvDKK+9VTOC3ds+2xq23KWBcAP0I0G+As+dmwNaPDFgcrUnsPPNqqu0D6+D7KE
         P/2rh13lloIcML7bgSSqggKdCuy1heRuQmBQkUBwcFM+Sog+QB9Ce0r2BUq49WNWjFe3
         BwsA==
X-Forwarded-Encrypted: i=1; AJvYcCVDxJQX3HCEkmWhWg5Y/ZM1kteZLGbmNior546DhnahgbFqqBGXqw2A7DSJAqp0FROHDQyRNb9Q0MQCrRg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb2BZo1eExiATRv9XafS2m6PERSUrO5rmz4gvpBm1DFMabfWt3
	GNc6Bm0bfKs3vvpOPdlZJmKOnoo7yUvU4rFKMj4S+VL+4ZxZNK/+MXjJfIOlN8KZSgupmT5mxTL
	9YAp8KZW59eKW0bZkwYkyA/rMuLPfx5dXsgQdzlxrPeQlr5sFpS3RUSy22ROHuEbTdYE=
X-Gm-Gg: AZuq6aL3T4vjx1yCxWjFKOx7lIM4owHp5giF8Nu52rrqA7MfrJRIYJHEJXKXhqwa5FW
	9KnHa5ODk9vCZu6cbzfdqurRap/uKn6CnllP9Dh1Of3b1M82CzBWQn2kWPR3l9Uc4zjt+MkeDqG
	EDxBmtkyX3+UhAq00JZRRgyjkUkfwU0FGA+kjRKUyOcnipWQABoY0xGmkXpfDXdzDsFm8CVTOUQ
	MuA7llCYjR9JSzCK8zH1jIKgBJbWMId/XOE7kuDCwwOPSK3/mTXqV0QtWQGj5SEQ9HYAjg0dQAr
	Yh1RH1tkm6O1DZYF1kEL/Q5CjeROtVg8Et6yak0dr8GspiCo9cx8mJx5nEl/s0fBBJXoHJdN3YL
	+WckU1CVYg21DcqgCM8eRS8sxHSW1p+RI+Fs=
X-Received: by 2002:a17:902:e547:b0:2a0:cccf:9d24 with SMTP id d9443c01a7336-2a7fe56c13emr19221835ad.16.1769152366464;
        Thu, 22 Jan 2026 23:12:46 -0800 (PST)
X-Received: by 2002:a17:902:e547:b0:2a0:cccf:9d24 with SMTP id d9443c01a7336-2a7fe56c13emr19221605ad.16.1769152365987;
        Thu, 22 Jan 2026 23:12:45 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802f978b8sm10979795ad.46.2026.01.22.23.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 23:12:45 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Fri, 23 Jan 2026 12:41:25 +0530
Subject: [PATCH 01/11] dt-bindings: crypto: qcom,ice: Require power-domain
 and iface clk
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-qcom_ice_power_and_clk_vote-v1-1-e9059776f85c@qti.qualcomm.com>
References: <20260123-qcom_ice_power_and_clk_vote-v1-0-e9059776f85c@qti.qualcomm.com>
In-Reply-To: <20260123-qcom_ice_power_and_clk_vote-v1-0-e9059776f85c@qti.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769152356; l=1661;
 i=hdev@qti.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=oAm2w1B3wOADUYdbdnTyko05ceBRrrkfGqHAPNZJ7nY=;
 b=T/bav/N0hNBenIP7BI5+XtgsxqIv5HNC4FE282RJr750Tb/TiID1ROJflYtef50laUb/lOj9/
 RCth3S1QhAMB+3X1lPuoVXooQtg9Sf8EX4NoGzXsgcGsjxn6YI8gePf
X-Developer-Key: i=hdev@qti.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=RMy+3oi+ c=1 sm=1 tr=0 ts=69731f6f cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=fZJ9qQ3NMfmE2mB3PYEA:9
 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: J3k9FrChYf5NxE21Ay771HA1IL2oGz4W
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDA1NCBTYWx0ZWRfX7VTbtSNlKoqS
 voHwjLq3GAs25j5uMAlkoGM6t+AJi/twKphbPJfDQmCe/3sBbNPXw7vtnpiXwMEFFdkANvJ2vrg
 M87Y89Y/LIrW59RsNGxjnq+dAe6Kk5ddhIBNfaax44TY3a4ojwCo66a0RyX4O1NWHFnQJkTUW93
 NgRZcuiljeS5fMs5zRFqqx9l+JJ/LeTPzNDtOQB4t1zWKg74oh/vd0WuJ9l9l8rjOFoPEhxrAsZ
 nPfH9bqfArrPGXine7s9bxSknqG4SQXp1ZllhZbkQssk7e1P1DsdrM764/bsYmFgYUivRsJajmy
 37uc8n64f00aq7FVHmnCqTaMrzksE69c4za50uktlRO7AQq8COcjw/5qb2hMWqXdNvGYkivR+Pj
 F6FUPeXcOBgBSpyGae1PKqiNFJHCg964TgfoK77d4HCTQ6RS20a+i9KYOJAzjP2FZh3WgHcrAjO
 Te+n4gj4mAirrPAorXQ==
X-Proofpoint-GUID: J3k9FrChYf5NxE21Ay771HA1IL2oGz4W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_06,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601230054

Update the inline-crypto engine DT binding to reflect that power-domain and
clock-names are now mandatory. Also update the maximum number of clocks
that can be specified to two. These new fields are mandatory because ICE
needs to vote on the power domain before it attempts to vote on the core
and iface clocks to avoid clock 'stuck' issues.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 .../bindings/crypto/qcom,inline-crypto-engine.yaml         | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index c3408dcf5d20..1c2416117d4c 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -28,12 +28,20 @@ properties:
     maxItems: 1
 
   clocks:
+    maxItems: 2
+
+  clock-names:
+    maxItems: 2
+
+  power-domains:
     maxItems: 1
 
 required:
   - compatible
   - reg
   - clocks
+  - clock-names
+  - power-domains
 
 additionalProperties: false
 
@@ -45,6 +53,10 @@ examples:
       compatible = "qcom,sm8550-inline-crypto-engine",
                    "qcom,inline-crypto-engine";
       reg = <0x01d88000 0x8000>;
-      clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+      clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+               <&gcc GCC_UFS_PHY_AHB_CLK>;
+      clock-names = "ice_core_clk",
+                    "iface_clk";
+      power-domains = <&gcc UFS_PHY_GDSC>;
     };
 ...

-- 
2.34.1

