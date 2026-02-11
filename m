Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70155366DB6
	for <linux-crypto@vger.kernel.org>; Wed, 11 Feb 2026 09:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770803286; cv=none; b=nyZZhPwY151cvt+UTgLiacPCoVWq3iDm16bqIGP9Ca0WA3pXETI+YMPyC2TvJCtoA1HzFQVM7c3LpRhOQ937FkEsxoYsTojgoHnzhQdq0ou3QppbP4F2/6zrZhBlIo0PDZj90/NMNwYPlDmOaFrpSCnZHdz4sE5SnOqT07RKUkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770803286; c=relaxed/simple;
	bh=A9DBiNP8iL9dR4Wka9rYBtFBrkJpTxjiScTy9/hyWFo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=daT3twcinYX9fNmR/4KgoLgxMZd9nyDIJzeUT/4n16c80QwMrpSDsvPlVlq3DnA6VIPN9vIQMZ+pzOisSjJj9ALPQ6WnZYttP6yZQPK1gtmh7LA5/u1z7VErRnYljfp1A83zT8pOefwhdOMyjNv1PUplkbjZyPy/w2WtUxyDUdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Bs56DhjY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FRKuPkRT; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Bs56DhjY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FRKuPkRT"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61B2qU393204323
	for <linux-crypto@vger.kernel.org>; Wed, 11 Feb 2026 09:48:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bJF5kOcx+0z0jZVRbBhfjrP6SosQxJ8NlSFELd8k49c=; b=Bs56DhjYDyPDgFsE
	MeU5w/OlDVv3A0fJtiOs9sOZhI2FbRs2YC2nRw7E68N4lDcgfb5+N3SIW+GNCy0g
	uVRYfdrzYStnojBfqwcGGCAxZrDiGGYYaTVvATif1qkpxzkjFFLrqx7uTWheJRcG
	SIig9OyYPI+qdE/1pLJLKvpm05ufIs7lbJMWtQGgUPEQWhLA5ta/9czZKtGDRuIg
	tZDKudRt0y/d6SGsAtn9nv3VcwCnaoulklDIum371hO1TKgtsvm1ZTZBnof/DbW7
	1kOYjdrBM/PF5QdF5gZmcDJfE5mJ0+auqqxE9Txl2Yb69RKGnqVdT+F0JtN6pC0t
	z22FhQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c894g2rmr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 11 Feb 2026 09:48:04 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-354c44bf176so4483734a91.0
        for <linux-crypto@vger.kernel.org>; Wed, 11 Feb 2026 01:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770803283; x=1771408083; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bJF5kOcx+0z0jZVRbBhfjrP6SosQxJ8NlSFELd8k49c=;
        b=FRKuPkRTFdkhOSShs0E4qHZe/kTtDNuEcgN3hFAfKFd4gmu+qNCiEkuW/ktnowdQLY
         QfFYULSWY6im8k0CC8Gb2Kn1gCAzN5t9fHZnLxiXeY0r5PWfBdGoh64nfG5FhgQLDzrf
         4nRUprA0VnsLbWeMPmrCk2EmdCeP5Eep5qGYdhug+tXBDJ6Dbc4mHxx9xdKXMnoptBkl
         SJJjdlA4PMg+y6/lEAIH2ySmqz8DeNTA8BcWoCkVOa86pyZPikxcUbmE8FzsWvIWCwjg
         f0raOc9At3pMb7S93hqhpQAjjfqzxsOObyyynMtNo0Js2gliZpNdTlODDKsFR7Kxj7TG
         8wdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770803283; x=1771408083;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bJF5kOcx+0z0jZVRbBhfjrP6SosQxJ8NlSFELd8k49c=;
        b=J5xyAuHR/2CQEqn6lKHVLfobXGxILt3ILM6ZhisrLM9mo1fGs95GXIsrnHHepVupG7
         wDyoUeLRLFKTIJvhc4AbBqhcIJFT/oYOAdDoI9+P0sMCSZOMUupQNGab/a+td3eqxDIe
         W4R3ChUx6EGrw9iN+oTQBOMuWHnYDfrGVIssot+G84OWq0ikXnn7jM6b74dfa1AQEW5u
         Wz0W7J0q+9aWe/6wUw/zOxoFeoHO9MGPs9bCSFpQgo+xyLu8LSTJymqL36zk/JvUXo0p
         w2imB0YqcQSuO6HUXpUUOSHk3SqiZ2f53geFcI8xif7ZzcvxJDlIFzliQBDZ3OlTnrXI
         uEZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxzXDm+KEoenO2xhgEqOJL8gEIo9shTdp+YzJYIKy5+RF3OH3DixkA+fv19Eby1KKewduvZBpdMvWel4M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwE/VBUtDi2y8nEdgzHlKTLz6u51iXpg9SE3ckzQWPIljbiCv88
	DW+PQuNm9w4vDw23exjypf3GZZFh2+sVNkvYOG3qV9iDmgsdIIfJxKD7q89TmybB7SnHplZ4p6Q
	Xc2NvewLMtgl2Pi0Yyf6cruMUJdrcwOnEAHqcJCN+RF6i2kmMgEUAK5btVkUASVS3B5k=
X-Gm-Gg: AZuq6aIKV0d0xzWEoT0Q0/iNVOUBlk+m9rwVlFMLursUcp/OI20nundawWGUho6sJPH
	X8HZZVK50om5dNC7dTOLsA81DNBLepyDRX3aNXoJnET2fGkigphQYWh6JnIM4ORb3MWSAU4Y+Pp
	Hd15Tqu+z58Ou0nsW+S4sJbfA+f2Wficc7qGfAFnwAoklOEIF9/6ex24ASgry+z6LBAf6JErECd
	lhsoDM7N3mGuctd1FAkRlG5fpXIcD9LEk0YhgaffR80Y94/7qoTyFrgUP3YEZenG7bk3X9xmu5b
	pTOigWweMwxj81OYIAfTG3Lgsf+vjirn148qDcBsXetjlFV22ZB46gvXTvVO8SmdL1hXXD4XHl3
	LGcxgEaAkB5ySNWGl9u4vnmk+pTgCjdqXy9EkVGenM9opT3mDx6ehcJeacF4=
X-Received: by 2002:a17:90b:5285:b0:354:ad98:7d1c with SMTP id 98e67ed59e1d1-3567afe23abmr1943058a91.11.1770803283394;
        Wed, 11 Feb 2026 01:48:03 -0800 (PST)
X-Received: by 2002:a17:90b:5285:b0:354:ad98:7d1c with SMTP id 98e67ed59e1d1-3567afe23abmr1943039a91.11.1770803282848;
        Wed, 11 Feb 2026 01:48:02 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35662f6b84dsm7526640a91.10.2026.02.11.01.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 01:48:02 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Wed, 11 Feb 2026 15:17:44 +0530
Subject: [PATCH v5 1/4] dt-bindings: crypto: ice: add operating-points-v2
 property for QCOM ICE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260211-enable-ufs-ice-clock-scaling-v5-1-221c520a1f2e@oss.qualcomm.com>
References: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
In-Reply-To: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDA3OSBTYWx0ZWRfX9ETDRcycqDPU
 JysfZ4MsQMG2LUQmtx6KpYhXlKbK1iu2wFp399hTZ2Hcqs46Vcc/ZjWpAKoGHvCt5nhVrV+xGBB
 brB9eMZtrXyIvLel4hPOrTun7DbZRJMOWyuUGnbUhs51HQLrpfo/IRNq5nhxhFtGvHgOLSdD399
 KHmu8lDpl8U42aGoakSnXt1ek+dSR/HWyS7LDV+r0KtunfE0P5Psv4eOjBW/Zufvr8S4IOyVzto
 ibuEGJLqWCJqpUD+OdmEtWxozni7mBByGXi1lhAaUx3ldMJtQ3tOcpCYnZd3L27j/DMTxPyFRPH
 Z4Ev6slp9YDzbO9OJ0+eWXzxrzbDOETrcrHnzvswadOWMsavSMMNDBQL12E8xuG8nqgV/TLb27B
 8F5buyH5dkZ+w7xPHFooQ4EJB2lMzW4d1o2Wtg6RksMCjKuveOVab1eu3NfQLJc2aKOiJ7QzXv0
 ukSvG/moMHZLv7qZR3g==
X-Authority-Analysis: v=2.4 cv=R64O2NRX c=1 sm=1 tr=0 ts=698c5054 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=EUspDBNiAAAA:8 a=QeJYPjCb9QSwVUWzf6EA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: 0gl42wXV8_7f7n1R0tcYh5SBDVkKUuZo
X-Proofpoint-ORIG-GUID: 0gl42wXV8_7f7n1R0tcYh5SBDVkKUuZo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_03,2026-02-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602110079

Add support for specifying OPPs for the Qualcomm Inline Crypto Engine
by allowing the use of the standard "operating-points-v2" property in
the ICE device node.

ICE clock management was handled by the storage drivers in legacy
bindings, so the ICE driver itself had no mechanism for clock scaling.
With the introduction of the new standalone ICE device node, clock
control must now be performed directly by the ICE driver. Enabling
operating-points-v2 allows the driver to describe and manage the
frequency and voltage requirements for proper DVFS operation.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 .../bindings/crypto/qcom,inline-crypto-engine.yaml | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index c3408dcf5d2057270a732fe0e6744f4aa6496e06..50bcf3309b9fa0a3f727f010301670e5de58366f 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -30,6 +30,11 @@ properties:
   clocks:
     maxItems: 1
 
+  operating-points-v2: true
+
+  opp-table:
+    type: object
+
 required:
   - compatible
   - reg
@@ -46,5 +51,26 @@ examples:
                    "qcom,inline-crypto-engine";
       reg = <0x01d88000 0x8000>;
       clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+
+      operating-points-v2 = <&ice_opp_table>;
+
+      ice_opp_table: opp-table {
+        compatible = "operating-points-v2";
+
+        opp-100000000 {
+          opp-hz = /bits/ 64 <100000000>;
+          required-opps = <&rpmhpd_opp_low_svs>;
+        };
+
+        opp-201500000 {
+          opp-hz = /bits/ 64 <201500000>;
+          required-opps = <&rpmhpd_opp_svs_l1>;
+        };
+
+        opp-403000000 {
+          opp-hz = /bits/ 64 <403000000>;
+          required-opps = <&rpmhpd_opp_nom>;
+        };
+      };
     };
 ...

-- 
2.34.1

