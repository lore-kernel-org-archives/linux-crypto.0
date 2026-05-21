Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6E03E9F7B
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 13:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779369510; cv=none; b=bqwc4tTqEkY2g6oLGAQFoohWGqir/32HCbCwwFeFl5Vp9Tgwy8hbQQAR8sqKVayTa6WtgvGFz+GJy8gQa+DUGcpp142s36hCNNv/0RF9RrblnVPQOVHSHGS0WPlGOUM7crsYq8pN8yPV5UlKhMMnDvRxD9Nqt09Dqt68Wdf6Ls8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779369510; c=relaxed/simple;
	bh=9DP4WFKs+knnsj8ZwN72mVO6jMAGtfHXV3DJ3PDB7UM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sfx9bN042ydRcAtOuoaGRdebzsROHDWijUIyYsuz0EYOAh5gXDgC/Aimf8pJHTvT9n3aWp5WUfY+AYqThYWCl3RWfubM9Zo3FlSjUZ3GoDuZrXuIL6lry1N2b4rpD1pd8nSFWbbgdwmrAm3x/yQafBHxafiker4HJYDnSX5v8g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iiytZrnV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Jred1Qy/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iiytZrnV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Jred1Qy/"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64LAXu0r818850
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 13:18:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qft0FFiZAPIrfw/5RUm0iFHVPnU1lPS4nRA9O8uAxwk=; b=iiytZrnVOPfSTJQd
	PDAaog2NriTLs9XGkmIrDfo6YuTislvWrv7S2lzZ0N2kGCoGyDlyE0jjy1wd5dMM
	KDOegblQw1R4jSmTBidtUd6E1tn/4/IrN+72c5/hQJacT7d6OLITCW7t666Q1mby
	Q54RANrcDKSLJ5S4Nh9s+xdEDKbGeBYfO1f8YEShPYR8o16FRDqKoCuNBWzg1rq8
	YekZvsMEt3+Q09ES3sT78g2hbzwgAVfYFeAc+i8pbDVOD02lNSXseN2v0poF+fGD
	hfHbQS/vpFt2F6uf02k0Pq7+/TAXmTqBdGhStViSHykAm2niS3IyOq4KPkObYCrT
	pz00iA==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ea0dkgjqt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 13:18:29 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c82ac893940so3025868a12.1
        for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 06:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779369508; x=1779974308; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qft0FFiZAPIrfw/5RUm0iFHVPnU1lPS4nRA9O8uAxwk=;
        b=Jred1Qy/Tc8FApe3ZHcOwJYrXSsKIe2vIfUAwohskHXE4uyhIf/mPUsr0HhN/Gg/Ro
         fCVPEs/8WJstzaJDQkm0XRw9hcSzDWYJi9Rv6c+EAdUWtM+z9iWUPUtekJcogKnsc49S
         WSQeEldI8r4hGz6NNknvJ0MfGufPmryY+GLRziTf4QAgy2X28dsIdEbXgCdZeOxiR/TA
         LqQ9g1Dm5DWIR9mreJjfKJvjmGip1l7ROfS/FMiqx89tcQFXUfWCdM7j5w0R2iI+hCx6
         hROzXaHnBzOiC/tlNP6KMsBKZfvakubsyCZc4kBxwhSkAb71eTL7bfxSq+D8Q9hTxWvo
         54Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779369508; x=1779974308;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qft0FFiZAPIrfw/5RUm0iFHVPnU1lPS4nRA9O8uAxwk=;
        b=nhqETKEm2WXEYLzHbjAVFOcshh/Cy9raLa6K1sUaeB3Cb1fxkvt5zjXz9Bbn6p1AJN
         RN1J6STGO81KI7IN+Ol3HQXxrFuN7+zEc6hkV8roFRUlVUcvtl1GK1DpSvCB1hLao7R4
         X5IkFSjmivDSWbExR7SVT77BecgEKps2o+uGpQ7UINhmX3yOkZoHev23R3rN7DuFlRbe
         9a4IdyyE2MjqSAjpM4GO81APGPMBMfjivfnx1tRJ5LiAdUjYjMZju3qaNk/EU3BteLS6
         MiC7abTOJ5I/TWybX4pe5QowGM9G8vQ5CnUCAZpNPF08gfQgJggqD1EAdpxt64uhF8Rx
         yXcA==
X-Forwarded-Encrypted: i=1; AFNElJ+NQYsuSSW1WuTbMdorHziOCMRBrkyqxgryOedTO6sXfdE4N61se+y/yUghnqBg3B0UtJ6cO2JR3ZWE+Tw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1bopt+pd8qTGVgx8H7htRbQZxOvZtaqowAqcLZKoGEGSpO4kQ
	lXvRn+j2FkXUB5vlXsKCpmgxZP3KD40G7I2Ifk/a2nggMq08YdyuujcjLmHBhzA22dysOyWMdyS
	o5/tmcolyGXRxuPNodurV5BrWQY2pBiHGpCObSc4sX8nZ9EXluHgKbqExxapVsmg3sEg=
X-Gm-Gg: Acq92OHOQtfHiAIM7XSaHGqi7NAtbDO+OiDidy/Y1S1moivSqq8l6U4SwwlvpZmjd/R
	vFZsCxWmHx1LFQ1z8HYfXu+JIIpdAi6MaTxsjw44wP2mee1VeZmI0G008DmtXZ1qgB88NIhmXgu
	cBc/3iC/QYSE65xhj3SdgI8AqQDs+ERb9eAKMIUNZpe/WYRRmIGrSHmhtOGncvvKULwA36M2JnM
	LpZ9VpLxKcuxnr5grSj0x6kskN96iY6vbjBOPujopbfS3matVkGhffBFzzFRZ37MfsVnnCYmoD/
	h23oCSO6F4+7pAeRlX33sCcLCVXN6fquTUQFA0GCdjBWdxDKdymLX7kf1dAm1GKnyqJ0d12T8Bj
	Lot9AD7UfcGMFBcCYwKb4RsCAIYWEOcWe/NBnapd+vOG9/qcPOfUp4q0=
X-Received: by 2002:a05:6a20:4307:b0:3a2:d79c:416c with SMTP id adf61e73a8af0-3b30874bfcamr3376061637.32.1779369508314;
        Thu, 21 May 2026 06:18:28 -0700 (PDT)
X-Received: by 2002:a05:6a20:4307:b0:3a2:d79c:416c with SMTP id adf61e73a8af0-3b30874bfcamr3376003637.32.1779369507771;
        Thu, 21 May 2026 06:18:27 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84154e22f1esm1687731b3a.47.2026.05.21.06.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 06:18:27 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Thu, 21 May 2026 18:47:11 +0530
Subject: [PATCH 4/5] dt-bindings: dma: qcom,bam-dma: Increase iommus
 maxItems to seven
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260521-shikra_crypto_changse-v1-4-0154cc9cc0de@oss.qualcomm.com>
References: <20260521-shikra_crypto_changse-v1-0-0154cc9cc0de@oss.qualcomm.com>
In-Reply-To: <20260521-shikra_crypto_changse-v1-0-0154cc9cc0de@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Konrad Dybcio <konradybcio@kernel.org>, Frank Li <Frank.Li@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Andy Gross <agross@kernel.org>
Cc: Harshal Dev <harshal.dev@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDEzMyBTYWx0ZWRfX7u6JmS4DdgMR
 xgtX9wkMdW0TBYSPVTufaM1MpvZGzqJ+3xd8sFXCIaS3n/GamaZlYBCpdaFgnawevGT5nKLY/7x
 mawojVtrJWQCwHJxDd79slkb93QRQEV7n6w8zvo69QMXcTr4m42HNzQbIkkO2ttnYWKmwB6KOTW
 57aejk2kQEPz5gonazV10jAaD4UB3m03CGaIIrKOjygcfvW1rO5gYtgk5Ysyeu5u6FYcuOY8uYM
 HVwXAmXBjxPAXRBM2JukpxBrijhx4A3VCaY+O8GXhTTspcsPuHXxbeegNM568+if4Cx5yhi+vde
 yI4aEuttN6FHipC5QJT2He7ncU2OskmyO4Tu74G8S9KuqmTp8tmDjtcEHnzAPBK22buRibyxKdS
 o1ttgiyG5Cwh+MYwolVSecIBa/GIU2IYU/Ag9tl/CPr6ObANC3pxXjd/qn1gZVNEranr5vLtlQ7
 Eioz+F/+ZpGxf42YGig==
X-Authority-Analysis: v=2.4 cv=aueCzyZV c=1 sm=1 tr=0 ts=6a0f0625 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=Pn01LGb3GYlZyOwDGgsA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-GUID: NO0B1BmqF7ljnBwYrl1JvEVDJWWkLpmH
X-Proofpoint-ORIG-GUID: NO0B1BmqF7ljnBwYrl1JvEVDJWWkLpmH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 adultscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605210133

Shikra bam dma engine support 7 iommu entries and not 6.
Increase maxItems property for iommus to pass dtbs_check errors.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml b/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
index 0923fb189ada..e72adc172af1 100644
--- a/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
+++ b/Documentation/devicetree/bindings/dma/qcom,bam-dma.yaml
@@ -48,7 +48,7 @@ properties:
 
   iommus:
     minItems: 1
-    maxItems: 6
+    maxItems: 7
 
   num-channels:
     $ref: /schemas/types.yaml#/definitions/uint32

-- 
2.34.1

