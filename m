Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA5141D132
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 09:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785232491; cv=none; b=Syo2Q3GnZ1v0uI6EdWsZcb8GJqSBa+mxrydImIpCIGnJTMtvzzbSVBZQqvCZig0LB0Ji/sAgq4NssF5d9MqszHHkKnRHwAL1Lnw6hfSyyBHBbp7p7r8bb0OIP8cKGF7H/MgS0/qqMaanswbzMeQKPjE1dvDuVkZbE2pPNsfvhEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785232491; c=relaxed/simple;
	bh=yxdMDGe4hqsABM+DAQwDlohqgSwvbxMyQNC7/8TBowU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=k0ECGKyQO9mEETzvTJPOX0tpNljKPffJ5EoPgXQ//8iJbA07mDoWPIdmhJnGYVdwajFTQ0kbN1QitLG+neolydhKB8XYB7sQCT0gH5Fz8fGec19vGzNwJaphi4N0AMtFbbQ4Hgr2DlKlJetcmiLs1S0441R3yUNrArA5YrjFxIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=m7mAu2Jj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bESh9jQm; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="m7mAu2Jj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bESh9jQm"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66S82STd2027073
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 09:54:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0paKyPJKJDwSyPTxWpyRHk5gL75Zl0fsNngFur5DKMg=; b=m7mAu2JjW4OKYZTp
	PWC1/fiOuBb8Lvk9wehxmgiaOnIOpSg9ZVOr6OC17YYGnS2UUV3z2VHM6vbG43ME
	0OA2rVLGE4QqPUI7riI9S0HFbUR/GU+arGJRi1VGjKZbILvt5BiAGBp0GDAQYOLg
	UIEE4AK647TdrWAcD7vkOgzAKju1CNSyg94NiiW4tslJJ5pZArPdhZa5S7qCJzjR
	Gp/rG70bz/ykYGHAF8wvpz2tO6lzYPGdZ4p+5OtxYXlcLrfb/SEKOP4WF/qIPDz1
	Y222sBMxWW5uwYQ3X52TINRYexP+5dVhoHESHzUkgYSrj/ShOZNvWR5Yp6129Fm6
	vaJc9g==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fpq9hgt42-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 09:54:49 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cc5faecf01so80265425ad.1
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 02:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785232488; x=1785837288; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0paKyPJKJDwSyPTxWpyRHk5gL75Zl0fsNngFur5DKMg=;
        b=bESh9jQmzNG1cFgSw7TYparpijrYjMkaD6G+DaiKmT69QEoB/ZmZC+jE9e/gBWroGl
         MvKsAYHVgBSL7FTC00MILWbmYpBUMlQBnCwLHle7gcqYvp4JtdTEO+Nf/23jkEjuiC5/
         9h5E+DPdacm+DSnKl1H2N2gHXqMdFsdSfqlAQhlkKU9+cuoiuWC2G4JqBxyIDhQeFVjs
         /VlA5NzvZ7PFbqU3gtGQA1E2uco2z/6RWIFayhkXQwrn4ONnSL8c1u2+CSpKbiGkvMW0
         MooTN2WmVaakojKXRWmxburb4tQfOtewHJVNspggRQ2qGOus+UwYEvMkeLU43LtVQuW2
         jm5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785232488; x=1785837288;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0paKyPJKJDwSyPTxWpyRHk5gL75Zl0fsNngFur5DKMg=;
        b=Mk4YbHQgOXtpyZ3hhjxQ7WMOM155TWoEQLWXHvV2j0WbO7DhzKpv4qxYw+sRGh0McQ
         KCqgCp4S5eZbhVw2HomZJdfG5nHZdjeckdMM4FFrghKU6nOp4wqK96nv4DwmEl3jCW+p
         x/7o2abWF9Rcxi+yjHBNbnsO2RS5tDuiHvF5rTUyQ04CPbJNFzVll9axGyZHUeuupBTb
         EYWjEhCV/IKB0Txbc9zCT7P0uhjVG4liR5aMZVlXm2Z6JnbWYZSTpegvWbvxwySebFa2
         NKBBdQyAxgDNm043pCBRkkL+U1OxIotfYi6yKejMQzQO+oH6g+2UOsuP+3Iwr9UA28j/
         Mw2w==
X-Forwarded-Encrypted: i=1; AHgh+Rpv7TLYY4AK/l/I9BxgE2SZIJip1hZHk7K9i+/KCxhwifYOagi0OtwNvNuvd0P5bP6sPb1XgJjVD+eP4xg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCXKJP5qxnPeYmyPKBKEGh7x/WHeooFVQXBWITlppjdN8A/QGq
	mvBI4XRIeAfIDEN4NKRwgt2EHngy03uWiffujBE/8zfTqaT8Lkt/eWS2u+ainvlu/P5HcSO0o6y
	AvnHcp4p378vvWTBACV36Oxdqw/Jx0YUOVQvYMogo6EfEgFxxb5GaLO/duU6o44ib+ptYHb6Tpg
	g=
X-Gm-Gg: AR+sD12yawOBI0pyWUff+mJMR3FF8z8bstMi84n4VhvvnuDyiHt/6+wrCBWmCTj/mig
	6RhWTU+7Bv9mEHAZzGpueSBI/z1ynTFwG1Uz5M/O/6Wr8AIcW6xaC3EOmAKHbj04C2/e2FgHn0n
	600aUq9dLOCyBkVQx0l1yAPzO8ArDWRVZ1pMgqXuhWdAMpqH+jlHx7MZ8+rC8fyxJepjj6mMbn7
	sohOk0g5bOJ/ClLGiDZX1Mdr2Oo+p4+l3URs6MxUAXe2iYARz7ffR1zmHAgg/dqhygkXbYUrBiN
	oiZ8W13QrPxA+R5uaMwQnIGaXJHmQUAXcNEK877DZcDb6vEdmH67Z/APaF/Kc7FOkZh26d4ebPY
	xUZqKhIjbbjArGfbUcAG/Cqb71tp2XH+IF+JgNmQrGTFvjgQ4A81OMtB5zQ6Dc5jXJXddQw3OqQ
	==
X-Received: by 2002:a17:903:986:b0:2cc:f5aa:9513 with SMTP id d9443c01a7336-2d015ade332mr18688175ad.10.1785232488273;
        Tue, 28 Jul 2026 02:54:48 -0700 (PDT)
X-Received: by 2002:a17:903:986:b0:2cc:f5aa:9513 with SMTP id d9443c01a7336-2d015ade332mr18687825ad.10.1785232487827;
        Tue, 28 Jul 2026 02:54:47 -0700 (PDT)
Received: from cse-cd04-lnx.ap.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d00599b631sm20264945ad.42.2026.07.28.02.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 02:54:47 -0700 (PDT)
From: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Date: Tue, 28 Jul 2026 17:53:55 +0800
Subject: [PATCH v3 1/2] dt-bindings: crypto: qcom,inline-crypto-engine: Add
 x1e80100 support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-hamoa_ufs_ice_change-v3-1-293c7c6c2ae5@oss.qualcomm.com>
References: <20260728-hamoa_ufs_ice_change-v3-0-293c7c6c2ae5@oss.qualcomm.com>
In-Reply-To: <20260728-hamoa_ufs_ice_change-v3-0-293c7c6c2ae5@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785232480; l=1016;
 i=wenjia.zhang@oss.qualcomm.com; s=20250717; h=from:subject:message-id;
 bh=yxdMDGe4hqsABM+DAQwDlohqgSwvbxMyQNC7/8TBowU=;
 b=lcgxVhGrW/Xe+YiqxpRzROpocls98xyPKH75YDZ0JuQok2jtLFipSKYQkD673VfUY1/5yEBbE
 NdfeHuh5gkOBpUlufd2iPu1juVX5zUb+w4OWwXMPbhxQsPVCwIfvz0n
X-Developer-Key: i=wenjia.zhang@oss.qualcomm.com; a=ed25519;
 pk=Of53/+6KgVgPh1R/xUMTbXVCnBiHTmHby8ySh2ShLtw=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDA4NiBTYWx0ZWRfXxmp7F98oUgtg
 Xu7SG4o2HhQwZZ7LHmRnkH2PIXHMikJutYAJn9DKb+npyHOrls0zXXCBoiWL0UAUT1/Ls3BfOLP
 KLX4PIHtFVzBOOb+mzs+dyDqYmgOdGQ=
X-Proofpoint-GUID: JgDE2u8d6QjVHmZ32JnVBttkoHiuJ09S
X-Proofpoint-ORIG-GUID: JgDE2u8d6QjVHmZ32JnVBttkoHiuJ09S
X-Authority-Analysis: v=2.4 cv=Aa6B2XXG c=1 sm=1 tr=0 ts=6a687c69 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=pPHeIUNF4Eh_DPPJXOMA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDA4NiBTYWx0ZWRfX7vKHx+rTpxlD
 Iswt/FsHQz6XsWKMJ4vjjyiklG2TuAs7bjRAXSi9JnB8rlhTtvy4KNvNVnw+eJbzUbN7j6aR4r0
 vN8I8IVKx3bVVo88i3l/pyUPdv5NLwzqAbTuQjjRQLPAWnzKBkRS4My62/ap9En71Uemp8v4tXd
 SgCBXH9qlikHXMjHkVpHrJpu0xY25oBsWyqeia+tk27tseqBj5iLfAh+jeAfDoQ9nucFaiBZahy
 by/pCJaRA4GquRs0dc/J2lC0L6ITgnex5qxCHIqKO+LkCBxC76BDJ9MfAriLLkmICd0/UPy0cmh
 v5451uQW+4QEtnJownUUZbFXqr7PMgzZ+Mmo0Z8fmcLJqozWwg36DamxZy4wMbms9tGViLcHA6N
 8VaS3Le0VvzIpJGm0FRLK6fX8uEJ3Aqm/c50pNKmCKbtUNM8xxcdO1C6WbgiqGZYvbh2LzzhP5v
 acHtMY+/ThcRh62+qQg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_02,2026-07-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 phishscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 spamscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607280086

Document the compatible string for inline crypto engine found
on the Qualcomm X1E80100 SoC, used by the Hamoa IoT EVK board.

Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index ed2dd99eb1b120267a20104b4d1cf27a347542c9..23bf98c2b9fa0d415d248d9dd145f16bce961fc8 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -28,6 +28,7 @@ properties:
           - qcom,sm8550-inline-crypto-engine
           - qcom,sm8650-inline-crypto-engine
           - qcom,sm8750-inline-crypto-engine
+          - qcom,x1e80100-inline-crypto-engine
       - const: qcom,inline-crypto-engine
 
   reg:

-- 
2.43.0

