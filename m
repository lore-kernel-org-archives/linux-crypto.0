Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC78918A6A7
	for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 04:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766465316; cv=none; b=MrUmRFzHaoaWQdwW5/UchxMH2rMjD9stdSG38O66pZnxHKAuHICdQybzuOH9nZxplvt3A3X/9lBvRW88j5MUgf/wR9Kao2YmABy1EpPjWeVCMI3OVSHg8ZPpT903KrkLbKcC9EA+5b/E0v/DY41GQkyoAiuAzq5xv3j6O6QMkng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766465316; c=relaxed/simple;
	bh=PRWqacErAuVkZ5mVuCicUhRqNrqG/P2D4ExHm0KFJ8E=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=mN2exlEMiuxaUtN+qntyahkYh8Ihpw7CRzh2T51BJZIBOJ01dlb4HJMM6USlHUaa/iGAr0j5bFkNuQ1WGx3psaSUX9v9oZCJ8Uyv3FGVlQ/EnJbn7wU6UYFeAuetc750wezkn5+9hs97WLI3C57IHW5P1Stue3ppr4NiN/sNoek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iiiIF65i; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bLnB8VVI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iiiIF65i";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bLnB8VVI"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BN18vQf2748768
	for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 04:48:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=CnQJJz52kuSTXUKlllQP0m
	a2xu0U3XtAFEMdNnPP4j0=; b=iiiIF65is8xZIXiquaa6c/Ak/ztww9mlZJapCt
	RY3rxxAchnDsP5VWJDU4+y6jHh4eoP2rYJQZuHhx30OCDfHEosPEjF9Uu2ylgZF8
	FgMWyUozFjYMkFb1QBI4mjLL86RcOfSwlmkTTfJosIGXPrQHXyKAnxJHQWTE8FMy
	CIKPqQQ5UVYvVyV6l9+QaNDF2UPVZKVZkdLiLHbQMG3bq/QmMomPfEsntH82JTiM
	I8+6PfQDl6EbMeq9f7Ir+v3rdZRQyOGhpfcrc6T4Kbirh3jW/NUaRGmlT/HvbBrW
	R0jSbp5N9XsihLruL7ljvPSOIazhUlmpqbGbuWvMBDep7AZA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4b7h5crpby-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 04:48:33 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-34a9bb41009so7098599a91.3
        for <linux-crypto@vger.kernel.org>; Mon, 22 Dec 2025 20:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1766465313; x=1767070113; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CnQJJz52kuSTXUKlllQP0ma2xu0U3XtAFEMdNnPP4j0=;
        b=bLnB8VVIpc+8+bZHyeoD9IPwBBHFevOZSD+JWksuZA4bV3GG48Ie0p93YfbVaLglB7
         rCaY1ixeVQ1JkGX9DQFFDFgS2BfrtaYdTZt5IVtPBvttg5eVg34MehCCfuX8ECznEbrs
         rHZFCBVt7Yf57gX43pgOi2MBpfJ5cDnchQ/lvYlzT/1opwaeRROUmP1fVdJcsVK3EUxc
         E7kt2KeDUQU7hnRse7FFxKPDQNpav5yj5Zgitf0QA3hqEip/lSI3dKdVbvFVVC/nFQaN
         RIgEJgynNmJ6jzdOcs4oljQUU7zgZgbJoEWhtwt4p6o4okirAOBG8C3UNAFONbuKCtJV
         SODQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766465313; x=1767070113;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CnQJJz52kuSTXUKlllQP0ma2xu0U3XtAFEMdNnPP4j0=;
        b=K7t44PAhT6WGkXBpLuLLPwjpQF5x0CxUEv07Nb4dgMCL/3FKo+32UnqWAhv7sEPBt6
         /uz/T0PejkZQxLmGUYd9Jb57vHLCGkCappuCLCUznXbxqtMjwEmHch3EzCweNR8GmcLC
         T1Cw5JqR/Fx0rzokUeokRHGTh/TRHQMUEfPev4Eu2AtmLzpmgllF2FjQRRAGKJuiOc9A
         206jAn7Jcg6GL8Pft4qZWCl6p1x1GmYw5WUPl8EUNZl+1G5RMnpXYjgYkOtMfHkKuhgG
         2vDThgSm6+FZDxr5JaMJF2lkRiJ2Q8adZ3R1VHSgd/+4uDXNVQPW9xdckyetVpKZM7l9
         nEng==
X-Forwarded-Encrypted: i=1; AJvYcCVh8imVKgmDKti0QCvhtNYduX/71TYVpsUH3T1r/cRSAMybENzKsXkrl1m/hetUxYhz1COmaGUZP36weFI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7rt9UMn4sBLfEpOeTzrxcHgns+D+I9sop7KgGLoylq7T+p9U/
	BTkOyW2jtbggJtoTWYLZt2JzEWUGIw6ZPd49QSvRw3Yx5XHC50X8BYc6wF8vAc7WtlKy3Ie8mZp
	8bumdAZfPkVjWXzTCLZbh/3Of7aUt+sBeTYqRQ5i69OYXlI3+962tlipN6e2nb6j/Kvc=
X-Gm-Gg: AY/fxX4lnQWBuVJ5y1ANb1ADN+sAZ/Nnj0D+Lgns/AZK1qw+LK/lvmoFcfhv5Rl9ks0
	0jRNAKtNdOwrlcMH63zqbZ2qL2RLsp1qxlg8u0H+qbE++LRo2GzntsoyiupXclDr8Y3zEGis58j
	UqfnRBp7CZJq/Xobk8IjH6fYe3Z+V8V8mh5Iut6BuoOixBdWa1904ypxH37PRD/vcs8x2iwPTSW
	CBa/jqo1mBWVNaHYM4J6vtrtIuzsdKFpoOueTgpEhcHD++EYNdlYr9/aH6uBlpd8PvCUZ7Fi2Kv
	RnSsFUETagrMZgnyqtg4qg38bBZTJBQfuPKzb/LSRbbHdOZ5MFu7lTz6aGvfdcVKQJv5h513tZ5
	Fxv2MJzziVXXaHFy2foycBWCoaRKQOw/qgdQ=
X-Received: by 2002:a05:6a20:3ca8:b0:35d:154b:227f with SMTP id adf61e73a8af0-376aa50087dmr11690641637.45.1766465313133;
        Mon, 22 Dec 2025 20:48:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFxgc/ah+HmBQqe5kMRWJJ6rxp9ceCG3iI3aU4gGDxGLJjCvLvKaCLeuMckJWjGJbMrUm1obQ==
X-Received: by 2002:a05:6a20:3ca8:b0:35d:154b:227f with SMTP id adf61e73a8af0-376aa50087dmr11690623637.45.1766465312667;
        Mon, 22 Dec 2025 20:48:32 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c8d10esm111316245ad.42.2025.12.22.20.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 20:48:32 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Subject: [PATCH v4 0/2] Add TRNG node for x1e80100 SoC
Date: Tue, 23 Dec 2025 10:18:14 +0530
Message-Id: <20251223-trng_dt_binding_x1e80100-v4-0-5bfe781f9c7b@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAA4fSmkC/43NQQ7CIBAF0Ks0rKVhAEPrynsY00ALLYkFhUpqm
 t5d2o0bY9xM5v9k3iwo6mB1RKdiQUEnG613OfBDgdpBul5j2+WMKKFHAMrxFFzfdFOjrOtsXmf
 QFQFCcM11C6ZiwKlC+fwetLHzTl+uOQ82Tj689k8JtvYPNAEmWHEtjSQGiBBnH2P5eMpb68exz
 ANtdmIfjwL88Fj2WC2MYpWgxsAXb13XNw4TXTMXAQAA
X-Change-ID: 20251124-trng_dt_binding_x1e80100-94ec1f83142b
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766465308; l=1434;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=PRWqacErAuVkZ5mVuCicUhRqNrqG/P2D4ExHm0KFJ8E=;
 b=NxAMZEtTKGzUrLUWle1WE9SNVWvGFBXZyVE9i92ViYOgu0lGxZfphEJd5BC2uxRusmA6Gs4Up
 5Jfepzys9ubAY/yDu6QPuTaYboagtmd3BfJ91pdTswtIhwzuvki9MRD
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDAzOCBTYWx0ZWRfX1P2Qi2b7K/+1
 zlBYtTO6mRlPy8Z+ySGgzxgLMSL2VsHQFqlSHtv9qx5rbbY0b9TY07fXKmNhE+E4kfBthrVx59F
 /cYbjBu0V+giuwLNUU6eirjY8NhP+K+bOCah4i5IdzJjL9zmgmPgkLscQGDPmAMta6gamjSrOvh
 voAERZMwGk4Y6h3+Sy5BaWSL4vbanRAE0YajDhEOhNp8O5NLywA2NUiUW7IWeaTu+QHSWbKtzUS
 gaq68dCcuOaGvo1VllPWmX8bULpDNQZoazdpbgultZx0XCaxOKf2mpUwXMNUMD+ENHNRmHYSqiR
 AbQbqVo8MfJr2Dp32zLih2aFFhVLpm02pvE1O7O+n6VVjt4aWQXhQdhpCx8j+GDk6iEJX+Fh+9x
 0mvuqnO6TahavsQEiO0MD4GEdrAfp1IGC65LyRnKVNjImPhdqP0W4WWItG6xpPKN5g+vB3dqLCp
 kx7VyWpPT6Cht53UYQQ==
X-Proofpoint-ORIG-GUID: 1DhWMtc8epZT7gMZTrFkw3W1dIxNQtpW
X-Authority-Analysis: v=2.4 cv=LeUxKzfi c=1 sm=1 tr=0 ts=694a1f21 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=IPSJuUApulekZfgP-9QA:9 a=QEXdDO2ut3YA:10 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: 1DhWMtc8epZT7gMZTrFkw3W1dIxNQtpW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512230038

Add device-tree nodes to enable TRNG for x1e80100 SoC

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
Be advised that patch 1/2 of this series for the DT binding schema
is already picked up by Herbert in v3 but not yet available in the
latest linux-next tag next-20251219.
---
Changes in v4:
- Added leading zero to the node address, padding it to 8 hex digits.
- Collected Reviewed-by tag from Konrad.
- Rebased onto latest next-20251219 linux-next branch tag.
- Link to v3: https://lore.kernel.org/r/20251211-trng_dt_binding_x1e80100-v3-0-397fb3872ff1@oss.qualcomm.com

Changes in v3:
- Removed Tested-by tag from DT binding commit.
- Link to v2: https://lore.kernel.org/all/20251210-trng_dt_binding_x1e80100-v2-0-f678c6a44083@oss.qualcomm.com
Changes in v2:
- Collected Tested-by and Reviewed-by tags.
- Link to v1: https://lore.kernel.org/r/20251124-trng_dt_binding_x1e80100-v1-0-b4eafa0f1077@oss.qualcomm.com

---
Harshal Dev (2):
      dt-bindings: crypto: qcom,prng: document x1e80100
      arm64: dts: qcom: x1e80100: add TRNG node

 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 arch/arm64/boot/dts/qcom/hamoa.dtsi                     | 5 +++++
 2 files changed, 6 insertions(+)
---
base-commit: cc3aa43b44bdb43dfbac0fcb51c56594a11338a8
change-id: 20251124-trng_dt_binding_x1e80100-94ec1f83142b

Best regards,
-- 
Harshal Dev <harshal.dev@oss.qualcomm.com>

