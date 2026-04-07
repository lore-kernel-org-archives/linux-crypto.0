Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBB93B7759
	for <linux-crypto@vger.kernel.org>; Tue,  7 Apr 2026 13:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775569919; cv=none; b=omOZKxqYFtIM0LXLs7TWnsh7Og6BZl+4sybk3DbyNwaHPdDzMtqC1dPYxQ7CkKKsfIJkWpjsXZZd2ZXFAqm/a8+5nAYiR8N1YiOkjCQlMlInjmZ1M9bOd1XhwWzJksY3z6g6yxEnk8dK9IRSiD5ba59kVpqNfm64B+JK730U0R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775569919; c=relaxed/simple;
	bh=VKT6Lv6NbB7E+1kObG5zp/SNkC85+ekmkpxBJAl2+Ww=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=mXW8C7x2bcpToWGRutjBia7eDRDFLkW1txhcvXQZPkzt4mUhSKDCj7mjuuKXBTWw0dbV0C55uZfl6tGmrZ5dcCLFsSiYg5vImxCqi7VAY1LwJdTjAHtT70iq2dASkllRDxYuzFGyE1LzChT7hCPvQ70eTVLszrbR6ebNtE2m7b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Pwy2/zcS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=L0g/rxvZ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Pwy2/zcS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="L0g/rxvZ"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 637D3xkW493144
	for <linux-crypto@vger.kernel.org>; Tue, 7 Apr 2026 13:51:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=ZZgjNY3tcHCvGFXadvGPUU
	gyvBksPRO94RQTSAaKYmg=; b=Pwy2/zcSIMkd/gleQI+VNeIu3Y/Y3bBSWQx3z0
	jWFDd8/P0ktTn7KSs8XEZkz0kZLxwVIohFwdTsdrPsFRG/rlhl5TE/MDP69/b3wE
	R7pqVC9HSHrQ5J3GnlmYVj7CnVzWXQr+hka3X+EiQSW/5wr1JQ2/fRIbxxGfrhKn
	oqNwOatSYy4xwFzlwQaYHCyciHqyjKjne+3Aka3Swvdcdqz+q8MuJkLrHd+xDhEY
	8shuIv37pj3YDe6Xsl67vAitk80P93/pCZMRCO1fbuU6QoonxnwWw3ROgLUaldD5
	lmwo6cAYX53ME5TyLo+ojDLxNnM6ptTtUnUXTk2WNO5A/q8g==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dcmr8txab-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2026 13:51:57 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-50b274f94f8so97703451cf.1
        for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2026 06:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775569917; x=1776174717; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZZgjNY3tcHCvGFXadvGPUUgyvBksPRO94RQTSAaKYmg=;
        b=L0g/rxvZ4VOl3fqoby4HVWgHkyULV4gGXVPaYQTmYALI1kIS7BjCUWRDVy10g1XyNb
         ZWqD9H2Fuba4rb9h/pIYU78128fGO3S+kERCT+9a4XVUMtSrmDny2+Uybolhr+chRwH2
         /KmKN919204ppLmySZb8KL26iswDs61rpC6blEicdvn5ZnFw5akhNo/Hx7XuA53hwuPW
         Lx1XoCVUO5d84jy5T4d/nVMgF6Eh4vZKr8f+QL/7wLQM884KeCtpkMr5Fh9Yffy2gNZK
         UvcduiqAtrIsHSBUO2of96vUeiKyFWJIPSVG+UZtbMfaiTeh/J6PRTfwvOAE+En6oOag
         eb1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775569917; x=1776174717;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZZgjNY3tcHCvGFXadvGPUUgyvBksPRO94RQTSAaKYmg=;
        b=fyBNV7dzttdfTPwhxO8/v5wYkRnukk1/Mxlt6vZ8pw//cSQMd52ObB4gqNOSqjDdw9
         FoHh4fbg60NHxNv+olxsseUPw/o31brlnnii94KBVZHolwsDp0ksKMNzxLNPPgGG8kJf
         Mb48TkeaxVJNa6KBmMIhFS3L2RvOMLTiZPxCA+XqdKGPHorZQP7n4u1DH2ZoZxODQLF0
         SVNp69BRg6I5HMWUvP9xpOuwhc/EKLhc9Ny9RkMpYV6mhQ67ysz7eAMrIGOOldL8oNb4
         J64mJ67Y0GGZua/rXlKuIZQyMmvoOtIQc/6hDjImVkPaEMUCBrU9iVZVf3+uf8idvjwj
         jZlg==
X-Forwarded-Encrypted: i=1; AJvYcCV5tMABw5ZODvwDyj+nNUQEGOAAycuAkDJ78cHTtwOc2j5MIVXpgeH5MlWUe3BiNumEdqsEQ9EPDhJJStA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRk3PKf54HadJ/dNKm568Hm8V3YLOCL/BNw+tZBY5XQubKE75I
	EQGspdSXqIpglHFPiXC3lsfEEAhOMgoGXS5MYkeZAlk24mGFED5dhAMyvAJpoIVST1KMbfqInGN
	AjCcNUjwJO+hN3rmADOCzqN7PMjP/A7zZVJDmzSpZ32AJqCd95QQ9R9DrttD3jJOTDms=
X-Gm-Gg: AeBDiev2LkGEdaE1ZgS78n61YjwFHtRDFpswCA5WLdIQ+O8xqz0g2eaDTQ2h8zhjxXI
	RXzjcd/yzXQZyYsuMhHsmf3nz6a0RPNcQaOuU9DQnzhUB+VD+FXdf6LA+cDQbn4dxr82EFwQsHo
	yH162L0cmdgsILFUiOq9V1njVHkMLV1K6YX1Ae7lHcTKHzggQLw2YeZ3RD9KOtplfc7yyga4i80
	cJdoHaxfgLJVxeO0mmvnkKsOW1f5tasEXYlCoaum7JLNP5SImFLhDAq7InqbkvLAGIDTvTtPNwe
	8UtebKACNNM5tlMJKHRfYj81SbBT5vYXbRjR7mFg1bNNIi3oAyl/PnUHUdCpBHL5ifl/PgKd+Ji
	GLR6OhqoBLt//PCSiNm8el63x1EqrTTk1s1Hud/GsgwY4
X-Received: by 2002:a05:622a:2cb:b0:50d:987c:8174 with SMTP id d75a77b69052e-50d987c868emr68291481cf.4.1775569916671;
        Tue, 07 Apr 2026 06:51:56 -0700 (PDT)
X-Received: by 2002:a05:622a:2cb:b0:50d:987c:8174 with SMTP id d75a77b69052e-50d987c868emr68291131cf.4.1775569916187;
        Tue, 07 Apr 2026 06:51:56 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.219.94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4d2971sm49788420f8f.22.2026.04.07.06.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 06:51:55 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 0/2] crypto: qcom: Add QCE for Eliza SoC
Date: Tue, 07 Apr 2026 15:51:41 +0200
Message-Id: <20260407-crypto-qcom-eliza-v1-0-40f61a1454a2@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAO0L1WkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDEwNz3eSiyoKSfN3C5Pxc3dSczKpEXcO0NENLY0sLc2MzcyWgvoKi1LT
 MCrCZ0bEQfnFpUlZqcgnIIKXaWgBdO7hZdQAAAA==
X-Change-ID: 20260407-crypto-qcom-eliza-1ff193987367
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=605;
 i=krzysztof.kozlowski@oss.qualcomm.com; h=from:subject:message-id;
 bh=VKT6Lv6NbB7E+1kObG5zp/SNkC85+ekmkpxBJAl2+Ww=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBp1Qv1jJgjplYb7TmTJtxJiQtsNpX7WcgDH6jRl
 GSchI0Sm0iJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCadUL9QAKCRDBN2bmhouD
 1w8hD/sH2Oa6/pY06iBdTJBp/Dig2EFC3lTjVQ5XgVdWWvg+285IE5K1h3X/UPq9w84LrxiZyAC
 BDzIyYQO+ntjkq0lqQRq8uJ9JfNxQtzi2LY+Ud3TTrzeOKlNVajjPPyXUvoCAmtOwFjI9Tvlx6k
 WLGoKitsS4/FQJFTXuinlRrFypSLojaUSNIeXgNBB5E6d+EaCzGOR0Qik0cYIVDn18jQ2eFP2F4
 7hpwhYXMlk9vvgWUvYHhmf+VqJ8+3Iv4H7MkPye57QSVG8z0yitM7hetlXpml67mwYaAj/U9rZr
 Bi5fMMAjQ2xzMUyUqk4/vikRWHWmw2zsu5y1Rcg9ndO+Khi+QuXFh0t3rerN3q/BC/SOmAv/KYH
 FNFqv6kvBbjnVbKtDuxmS3+6L+nd+f2Yx6+7BeYEbw52Dz8BSFSWkLTzh43WKw6sKD3kY6XyEYJ
 +919D2RlWRT6bjg2Z7ZKMBJ3L06lEinwiY026jQYQV1mCnkRUOmxJEByRFAEy4GlIuyna/bDYaq
 NlKOtwg7BVUkWJg2WAmQiDiXyWCdD/sO8E6jgYQPswTL2mzQ+7bR+jHvEUXwKh1Tkh547IKpjEH
 ovd1n7Kp1HWNKeo8t8dMNb5gpL95c9GHill0i9awwV1HVxgBnSJLqKkYeD7t4tGQn1Cnjt9WXhV
 PyS+3HfRRQQeCBg==
X-Developer-Key: i=krzysztof.kozlowski@oss.qualcomm.com; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B
X-Proofpoint-GUID: 89QlFHFt42dPt-3q-ZgYBN19J9lboG42
X-Proofpoint-ORIG-GUID: 89QlFHFt42dPt-3q-ZgYBN19J9lboG42
X-Authority-Analysis: v=2.4 cv=c9abhx9l c=1 sm=1 tr=0 ts=69d50bfd cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=gOEeR9iKwsj33Yj5oN/cWg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=5M5WBOUQrjO2H3lggUIA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA3MDEyOCBTYWx0ZWRfX33ptM4+VvdJt
 z3NqG3F0+vWgGbTL6QIeuO0KP5Uo4uz6N5LRg+KOqWaXtLoHQiRrY+Vf9ldxIb6g9OHhGLXA83a
 8/bphM3CiVTpF0fuz9kaXmrgU/p2q6AMid6vSjpz7x5GlNJ/cd+KvhVMZUKMsw7gloowP2vlY3Z
 ftBCFvuEs5iB8WVbwxYj62aJw05cMyn6BsF6+MKw/2Tp+7KdaIj7+sC4e/bVrWA7tah2zR1ajvB
 /gyACKOdLdjn9TsjxK9W2eCq+OKS2e+7prXdfT+pnx8IUwBXqPvqOwuWzuW9CMrbMrHoC83TzDG
 j3BCR425ycnrwgGTCqHWV3SjtpEFfhk1VQkKCdFrSWLdeIsUh+SKVFZRITo3xzKYQYE9rx8ST8B
 pUZYxxVw7FHJSOXvPQLR0JXE8CU2bde7orikxLLZ4KAAsbi3Ax7nuPOIcjrk2ctVjtfPM0Oi0tO
 wVdIHwHsenxB6cgNGWQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-07_03,2026-04-07_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 adultscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604070128

Bindings for Qualcomm Eliza SoC crypto engine and DTS patch.

Best regards,
Krzysztof

---
Krzysztof Kozlowski (2):
      dt-bindings: crypto: qcom-qce: Add Qualcomm Eliza QCE
      arm64: dts: qcom: eliza: Add QCE crypto

 .../devicetree/bindings/crypto/qcom-qce.yaml       |  1 +
 arch/arm64/boot/dts/qcom/eliza.dtsi                | 32 ++++++++++++++++++++++
 2 files changed, 33 insertions(+)
---
base-commit: 816f193dd0d95246f208590924dd962b192def78
change-id: 20260407-crypto-qcom-eliza-1ff193987367

Best regards,
--  
Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

