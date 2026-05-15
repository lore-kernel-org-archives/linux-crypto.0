Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C2A46AF2D
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 10:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778841997; cv=none; b=MomQMYMUohltimOzIXeOHzlexkDm/JEmDpY8mT449m7uLk1DAADAU963IVMcCj/Qre0nYpQz6iFSDHgDBZ0DL2v2b7gL/NS175BYSWS4K7si40EeTE4P0Q8aVbDSBHb3rVHo8O6p6y30vJ8zcqNAVk/Q+LMCFyEdB07cEhB/EAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778841997; c=relaxed/simple;
	bh=RvUqiWlt1Ergu4NMH0uwjjsce6vuybjCzM+VDSmAESU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Tu7EY/XoeB81jLP7muq4WXVxhwVmQmd/e8RpcjZSU/XZkqX0AsORQPmzUfnaoi3f1UULYOir1KPVeod8ZNnfAfZpj1t0KNHW+fn6sVCNxnI47dI5DvuH0gTN3MHZ9nw2yTEdqfsAXsEqhMM4/aw0FEKqZH66MY8re12ho36jCUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XSFDzNx2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Uxy6c68U; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XSFDzNx2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Uxy6c68U"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F5U6Tf4008246
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 10:46:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xhsrID1K825RqNqJYg3J6AtzbVLQFOaNS/VEzGY3CqI=; b=XSFDzNx2EAt9otdF
	jLH2IsOwbxjwAn29icuutrWK5wmKo5Zuap0yz+fyNqXRdFMiOKpnIdG/LAGKiSAF
	EcUr/+h+xcXrQUG+XwAzWTUzNJq3qlpws2rEgyZO4JUs2le9TcSvAtKLneGhQevW
	MTyrIZqIWlag3rNoLDRrBEszxvq21SSUX+juwvdk53nwb+pLIZQYL0vYcQ8Y1Of8
	dtfqrS6VCJQe8x5ueL61Anr6nszWz3zYmMY5qdNDK1gSkr3boot52NnVSmCHg9v2
	ZT7o9met/8uIC8qsrBU/rZLC5ihSesScA6mL/WEpoRlFpaq5e1vBPxCGu63sMJgT
	o5NwBA==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e5m1stwpe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 10:46:34 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-368b01f8adeso5570010a91.0
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 03:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778841994; x=1779446794; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xhsrID1K825RqNqJYg3J6AtzbVLQFOaNS/VEzGY3CqI=;
        b=Uxy6c68UIzQgsl88ZrdPerSxxavLm80/YTDc6X2v+qJchROY7Bf0ndE9uJGo2+rVpU
         avYAliqugeuobEOm7gjukYMmrvFb1EQLaFhhAlC/zQuuwOjaTEAsOK2AM8S8QT0v8D9Z
         nqD3Zd3Agk42iFShVWyA97m6v9zpwZ6ec9hCxNyyOnF9dgJHjni3yJTrK2mQbkj5VxAa
         TMKgw0Ad5fBlQxGQHe/tna920o9oQfUwNKgh3YjodTb3PBbytD22F/fEIWSuW6tm1qEf
         yaGTF6EMAH5ZPKgvjgHTkm+27TDMYxwApICSuRtxgiXLRiKeHcemCiT/otD1GvhgtCp/
         HMxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778841994; x=1779446794;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xhsrID1K825RqNqJYg3J6AtzbVLQFOaNS/VEzGY3CqI=;
        b=kFTFAX7Gysbiv7j4mS7UAuNOHjxwRksbdwo+kzk9Gi+lxeIDf3mT9ucfzBT32p9/sO
         CahF+fwUpBFMKBes9epHLVRN1cWCThVoxncns9+7n72ZcNtldUCnoelT/gqR/4Wmhorc
         iYJeNrEv4PFu2DyN3txyuxnG9XvVqOp/dpxTUnSepJZwZIhC4Ozict4ts8GOSsFT991v
         /B1NK8qrWhEw6MVWIhiNKpHYCsttNhyg5p9YGR9P9MFjSkQzLD85Z5bcqRuv8FCV0cBm
         BBbvHFxqJL93ScPiBn36gs9nJDSRpIJRrEiOBpzLjbh6jQsyjJg4n1gXrdEzZXFY5ZKx
         FO5A==
X-Forwarded-Encrypted: i=1; AFNElJ9Bb+A0Nmcaz8+HYrlSuN+NmJqoRIvESYVXgK5nwIZW9BGjbNUs/HasErd+JqkSRiDDZkUDZdHDa5YOwtA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0U5E969YcDWi9HoWRzI7edODBIrZ5LZi9QxhksCuNOF13mL+s
	uHJJmOvdtd0wUAdU8wc02YUTuIYxrLMz+Twu1o8VMt6Bv0j7jxFCXbiuIcDsW3VfXNLzvslD2b2
	66Y2+tdHdfqx7z5TXZ7puKSsg9LGVfrCAe3i6CUmWfivl1ife4yPNZqRQIzsq7FcZmVU=
X-Gm-Gg: Acq92OGtb94y7ooVKUby2glriYLI4n9k6Yp8dsh71cSuUGDWVH8cKSOXEk2wXe8Ujqi
	mECo4axLqnxMo+2eHUnkLhM+Yyey+f+A9Jo07BW18+9eMSf5KqqLp8rSezdcPsLvc6qgNvSLdm2
	JRIbQEu4tIj/FQUiIU+XO7kLNrstsdi1iypdPhhMY+TKxtQQQLxCr/RbIMQ8quBv4/4ygbvQrqh
	x7cYKTG4K53zRhyr9cKZi+gdefRecmg8sEwKUpVMy2sQg/vFyyNiCAiskLM/JMhRN6ukgxZ/gwF
	Mqmozn2oDSV5ksj7B8Ht0ifVQU56chlIooNrnZ3kuDvJOpk2ms0jWR/CnJiGCUs3KSSni7r0zKH
	LZxxaIEbZwUhRoTNJ3CAVZzXuw7Z8Rzo3ka1z4Wf7F4Dp3xifiEWk6mY=
X-Received: by 2002:a17:90b:57cf:b0:367:cb53:7438 with SMTP id 98e67ed59e1d1-36951b75d0fmr3702498a91.15.1778841993945;
        Fri, 15 May 2026 03:46:33 -0700 (PDT)
X-Received: by 2002:a17:90b:57cf:b0:367:cb53:7438 with SMTP id 98e67ed59e1d1-36951b75d0fmr3702457a91.15.1778841993393;
        Fri, 15 May 2026 03:46:33 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5bd5f2dcsm55839755ad.13.2026.05.15.03.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 03:46:32 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Fri, 15 May 2026 16:16:03 +0530
Subject: [PATCH v2 1/2] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Shikra ICE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260515-shikra_ice_ufs-v2-1-2724a54339db@oss.qualcomm.com>
References: <20260515-shikra_ice_ufs-v2-0-2724a54339db@oss.qualcomm.com>
In-Reply-To: <20260515-shikra_ice_ufs-v2-0-2724a54339db@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Proofpoint-ORIG-GUID: gsRDxoklFbOWjTV-W0R3bZhh69AZUuS3
X-Proofpoint-GUID: gsRDxoklFbOWjTV-W0R3bZhh69AZUuS3
X-Authority-Analysis: v=2.4 cv=cZPiaHDM c=1 sm=1 tr=0 ts=6a06f98a cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=twW8G0p2hbz0t8568-wA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDEwOSBTYWx0ZWRfXzF510sppvv7r
 tdBy1SmHVM0o62bYc60QS/PuYEL2vL5MtjbmTk7kOheyA4MPX1wqqPi7/X5+iyJHcvTAKCMXNys
 X9gl6EJv/dh+DA3C4iJZLin9s2RYBRfHYsmXue+37aDqL42n5CkUT3nhFEhNfCTzNzqgRWffstE
 s2fELb7txS9sK00UtfagtQOS4bgjAk8o4k08BfGt7Iqfq+pZri4cMoUrzkH9ESlOrjOWpkR4SyV
 Y7927+zfbZYTIiZ3a5q2JttVOIzB2zkYx5+v6Rn3MtwSJZBM3jQouVvZ6qkYtgYIDcS2oEDkl0C
 XBzbK/X64JiCMQP4ScQYC/K3h2KiMltCVBpl+VJ8lVGa3AwNBBYVrNgJh5O5D9A89NXYwIKg8jy
 vW0Czh4g5AnUyTpf52lvN/tIbkwKs9SS7BADgqcVrGrnzHP/rfUmMQTRZ+UfiSzTGtjRtcURisP
 oB6MSacKYS+bGEr3dXg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-15_02,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 adultscore=0 suspectscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605150109

Document the Inline Crypto Engine (ICE) on the Shikra platform.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index ccb6b8dd8e11..c0b083da78bf 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -20,6 +20,7 @@ properties:
           - qcom,sa8775p-inline-crypto-engine
           - qcom,sc7180-inline-crypto-engine
           - qcom,sc7280-inline-crypto-engine
+          - qcom,shikra-inline-crypto-engine
           - qcom,sm8450-inline-crypto-engine
           - qcom,sm8550-inline-crypto-engine
           - qcom,sm8650-inline-crypto-engine

-- 
2.34.1

