Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A8F31355F
	for <linux-crypto@vger.kernel.org>; Mon, 24 Nov 2025 17:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764004145; cv=none; b=Jz0FWlJA+9q39eMmTmE5kMJG0/oc9uxop7gtCac1NXfJPQr48uDGbFESC09K2ZZ+kqEgQkdQU5g1gyg3Uk0AkmFx9PV3doXb3VrboLcWUw4kYq22RTZ/rKV7bZaDuhNWSptB9Lnur+95r8q9oqukjsRLLQBuB+2iluKFwJAR/gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764004145; c=relaxed/simple;
	bh=GEZkILBQcZuFuSsamTbUDcv0GlYXt84BAbmPewTcedI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=GBSmLBNlpuOzXPaZhYsl/omgLCV76+RaT602VAyZAbX06t0XtnpZLuyp5Wi4GY83YcYFTSvppSJjxwPEN8Wjlg6rts/ylRbzIbULyqtsud8JZ5Ndn1EN1cn+yA2gVJgccrX9+uYTLi4r27FKQ+Dgcs3YR2Y04mGc6jYmAtXRbTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=E2E9pH8g; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Hdrqmdvv; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="E2E9pH8g";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Hdrqmdvv"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AOFuq0s365361
	for <linux-crypto@vger.kernel.org>; Mon, 24 Nov 2025 17:09:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=nTaVdnsOVRgvHNDCJYfyB4
	IZrgcK8LINikYhlVDs7eM=; b=E2E9pH8gGAo/rOGaj53YBawMLhuI8QuH/D6bUQ
	lL4XkXOG5XMO7m42XtJdpkXXl1F549Ak64vXMDKStIjejuXAYn6ZFPSGFj3BM4Qg
	/UjoCRMiDfaQUwoJKvknqsZcsKueJSpqANac4mv6O4VNSbV/7quXsiVDS1cAHhRD
	sKkYanzWV6c9+C2yOFHEFxkm0gzXM7d3/ZqSalmx2ios76WiK5kn8kC89IexiZv0
	c3q9hwG6P0Omv8DpJi7o/Iqf78bx3d1E6pgwZrnK+hFLMhQ2EMWYIuNn4TgkeKSw
	jaEHSqra+WVCB+QwPi7dRNCn8q5NFPzlr4hFcmzELRK29Tkg==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4amteb88cw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 24 Nov 2025 17:09:02 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2955f0b8895so55270235ad.0
        for <linux-crypto@vger.kernel.org>; Mon, 24 Nov 2025 09:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1764004142; x=1764608942; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nTaVdnsOVRgvHNDCJYfyB4IZrgcK8LINikYhlVDs7eM=;
        b=Hdrqmdvvpo28CXbITqXxG6zxIJhuqqAwB6yPz6gnW5CllfeinJgxbvaXVwzZVc1A7O
         kPVHepIGPxZilyH5tL7C7MApbcGRkDtPnQXHSB8xr+Wv9NV+esSQ4o8oxOm7Cl3eMwRw
         IMVqHAlrhrJaTAskSgNVgpQepCSt4S1opcqbUgMmLUQ+NvML1OCuXS1EtBQXgxavPrH8
         QaB1SM1uOlkzjiJslX1yohaTIE/tyQPZgbyiRbpA/A4uXlQlZ5ro8ihDU/3yXMP8+uGU
         LE/fE/niI5s5RjEnbtL+9wFDvc1hodYDZisI0LAJZFK7J2GkpQCYJc2KvSIeCWUipymZ
         yH3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764004142; x=1764608942;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nTaVdnsOVRgvHNDCJYfyB4IZrgcK8LINikYhlVDs7eM=;
        b=APF93KEOZdyRM9FSUX9JqvQ9bWlkr5CnE8+yS6C5eE5oPGQCoOKneOytfBJw04jVQp
         3xMRrqupCx3rbA0uDZImdPUc/O771EVKJyyXxXFh4mIVZl/ERgJVnTq+IsNCHaELw/yN
         lXKRnRs8JL+4UCHDv991aZEp3/PJ0QykWXl9FZWVRXweEe9odT+rF0i9RgJ80jBHdrYG
         FhXg8vLjHukew4oasTSUqIJCn/+ivBY08JD0KNpEZeTid7h4MczQzCzLUV+9V6iTfUKH
         5Qxp8bi/AhCfTHPqJJCKs7Czcimfqn3PEEsqmlWWRWc93Xf2DIbxi+V9K+0vf3dGx7Nu
         U07Q==
X-Forwarded-Encrypted: i=1; AJvYcCVBPBjXuTmvyOr+AQAi756z2ZRjmN7Kta7XiPj6kL6Clm6qcgnHjpZUhonHi0JMPEfPkbebdIgDoOkipc0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwG29lSJidt5BXBcvNqlg7s5yYE+zfaWjCh8ReLzBx5p7DVKBP
	No3YiYtz4r9xI8qkZcHcFayvLnTTiS/44Oiafs2oHLoxP0dojuPrFfbT0mWB+0IiO3YsxVBoXxi
	BE+npg+dNXY24kSA0WC8u6iyIx+clHdow8WL4OI3toZ0hqJQ04sBvcfye+0tgj1oVARE=
X-Gm-Gg: ASbGncsMZREHD0A+5j39zS1BdncbRXcww+fsnIoGfsyMyqi5nFcDVW5zGYwy674RnEJ
	nj/NlBynRJ92n3iLm5SRvhBhOI2+fwv6fSyLCBJWY327OV5SWoaRJPyKViqj3zO98WmhrcqPfBV
	WxTr3vJH1jNUI9wkX40+Keki2lfJwYKgKw/LiPL9AAh99yBuDdYxAo9HdxVl+61fewzJM+WO9Lm
	qysapgeD1v862/m9fxhzyT7lve6iqoYKWvROt9NM4VWoydztoM/xaISegSAkPVm8k1SY+EieVuo
	0g5Qyggn2d905g1U09S7/8CE7DhZIUIg3t1drrHWXeO8BJVQCD3aROywmIRPzoyl9+qu75nF/F0
	O187cFre++HTTOSLl/zDOeQq0madRIMK83lU=
X-Received: by 2002:a17:903:2383:b0:295:557e:7468 with SMTP id d9443c01a7336-29b6c00b02dmr140316555ad.28.1764004142109;
        Mon, 24 Nov 2025 09:09:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFprP6rxA6/T2c4BwZxvgggU1iahHX7R3rpt90bPcjZsWL3XHIYeUVXg4tgCLb6TIFSE6gKzw==
X-Received: by 2002:a17:903:2383:b0:295:557e:7468 with SMTP id d9443c01a7336-29b6c00b02dmr140316175ad.28.1764004141639;
        Mon, 24 Nov 2025 09:09:01 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b107effsm143949275ad.14.2025.11.24.09.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 09:09:01 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Subject: [PATCH 0/2] Add TRNG node for x1e80100 SoC
Date: Mon, 24 Nov 2025 22:38:48 +0530
Message-Id: <20251124-trng_dt_binding_x1e80100-v1-0-b4eafa0f1077@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACCRJGkC/x2MQQqAIBAAvxJ7TnDNwPpKRGRuthcLjRCkvyfdZ
 g4zBRJFpgRjUyDSw4nPUAXbBrZjDZ4Eu+qgpOoRlRZ3DH5x92I5OK6YkYxEKcWgacPddKiVhZp
 fkXbO/3qa3/cDZ4KccmoAAAA=
X-Change-ID: 20251124-trng_dt_binding_x1e80100-94ec1f83142b
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764004137; l=599;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=GEZkILBQcZuFuSsamTbUDcv0GlYXt84BAbmPewTcedI=;
 b=bHOePMxySrpnBKqm1UMiYIn/NHf0e2w6to4onexOLo6gutSKTgjyDZ70ChhmcigO5wvs2b/Y4
 U+vgnJrP+WmAdqJjAoVJj+9AMX6Uko4WAUnsCCecsxTXfAq5846jAUp
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-GUID: HfpllQDoBczlwOEkqBz4wPZj4e0R_533
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDE1MCBTYWx0ZWRfX+tua358QS2UU
 l9nb5bl9MfIhpnIoTAizaQqdGsBi6mP1VFRIgcC5eTs19VLN4G7KjVu0L+evgHuuavuX1vK0daM
 Em4ajzzoRXU3H6U0nxYhxfEqBUEquUGrXQz9GcclOikXKclIW1tp3dd35aQHdsDCxqTjz68zQjp
 KxC1ZOtBSmk1eFmeHGa6xdZfBs613C5fmPvdbinSWJzYQRJ8GBc4qIVQtg0QITvlhNDLxrUmP0t
 O39bK+ZOA8KctOHjBzCPo8+MQT8+lczQnxnP9EDOwkcJtg/frFIu6tgP9i0nKcSslfY4+6AMrV7
 nBAyvPjmLDWuKtlRMF4ijbq48EGY74hezmcFvdxeyv1D1hwogRRLpwo9BAew2gt03TED20DzVNY
 WV5fKHL7SBzvQgsPeDRJW1xPyOLbmQ==
X-Proofpoint-ORIG-GUID: HfpllQDoBczlwOEkqBz4wPZj4e0R_533
X-Authority-Analysis: v=2.4 cv=d7f4CBjE c=1 sm=1 tr=0 ts=6924912e cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=6ZNt1lSE2E78l_tYFJ4A:9
 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_06,2025-11-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 clxscore=1011 bulkscore=0 suspectscore=0
 adultscore=0 phishscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511240150

Add device-tree nodes to enable TRNG for x1e80100 SoC

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
Harshal Dev (2):
      dt-bindings: crypto: qcom,prng: document x1e80100
      arm64: dts: qcom: x1e80100: add TRNG node

 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 arch/arm64/boot/dts/qcom/x1e80100.dtsi                  | 5 +++++
 2 files changed, 6 insertions(+)
---
base-commit: d13f3ac64efb868d09cb2726b1e84929afe90235
change-id: 20251124-trng_dt_binding_x1e80100-94ec1f83142b

Best regards,
-- 
Harshal Dev <harshal.dev@oss.qualcomm.com>

