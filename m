Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458043EBF34
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773130018; cv=none; b=pcKvEN7sThtBjIJh9WOi4BlVQfW9uVkpUu/0xka2zTQljVdWI1npPNdx+huz86heR+g3SkegjESDr7i2cmAi5SJCUmNdxYCloOu2BEpFyG4GNm8wySEvkN0kY9Z35N/GiviU6Hu7IIcJor95lVxws0fxGq6bq8jkrCvkZM2l7fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773130018; c=relaxed/simple;
	bh=Lnqx9aNGInN2dRJmGZpQf0PRaaOxvX3KhhTXbK0GgTM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hgSmhP5/zxwps4uKpFzZFAiROPk3U8yTDitp06IRrh8SOuvw60nQ93cNPv6T1d4sfNkM3KdgMQTIJ0u+3o6Q9a3Q7w2lXXzd+tmGdPyxv5OaKAoF+Nd6MM7Qij5q2HHPH+drL0xj8N/h4pCIBQqwTaCujqMKbSRAbL3vxHRdHQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ay0LGaz3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=d9SCkwtb; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ay0LGaz3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="d9SCkwtb"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A2EETC3754559
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:06:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	m0pGDZTp4WihSPiCeJZx7i+DZ6ZfB6hNJXG0xF6Zo5c=; b=ay0LGaz31eWUlN9z
	JU/eIjq4edPMWNsDiBoVCzs4CzK9TmkCc6detdPyAtYJwroy1E41JZw1BISxO62C
	xTeH8XT0gQ9Nad8Bxh+csNBoQGTxkpEoNr28v5fth1g6il9tahpTs50D5ODJ6SIN
	gWqNOV4vbvi3HyUSVxyA6P5JqdrVzaruU4mqcEWOogDyT293NjoFEPz9ysy+fPaA
	wakEi53xk0bScLIuGU6wJHwk5JJK3MEvntbpxG7X0nJ217i+sPjdIOaAp3sa0uRC
	9+iKih1k8rk9a1C1ABMyBlKBueTz6mV7UPXIkFjDJzxy5aGV8/6enZCjktPlnWvc
	96pDhw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ct477j51u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:06:56 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3568090851aso72754530a91.1
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 01:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773130015; x=1773734815; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m0pGDZTp4WihSPiCeJZx7i+DZ6ZfB6hNJXG0xF6Zo5c=;
        b=d9SCkwtb4dLTwCEWDUZVnWm2aPGl0NSI6qBeGngYbXn3MOPKk4BAZh8jn8XrKq7qy2
         G87U4EhYfMpnhr5tdgO2BZaJhjVhoZar3FeP3sJuokxysO27NJrFEboonIpWDxkmu0IB
         ogRgZ5lzDfhvrZ87AlVxfU7jR7oJWOS3QAysKz2wY235e3noURXTjDTVCKcQQeIhKkeC
         sp5D0BIzeaXPpFIUk9Y0G3DeQ0Rkk2qVjjF+4okZ65k8EPtf97cVEI4FTwpSDcMdEKIH
         QK63PPnN+31pQlfDOANLLQC19b3z8xuHeUpBqs6qrWWtwDzHI4+8U2V6KCkM4H9NoaRa
         D9zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773130015; x=1773734815;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=m0pGDZTp4WihSPiCeJZx7i+DZ6ZfB6hNJXG0xF6Zo5c=;
        b=CaRK7Y4rx8E5a5KCtpz3JuK7hsKaO5nhBSfnx3m1PJrV0XirtHE2/xt3cdjnfo1Iwh
         kVq3txnDpI3V998DfmyRagYAzBICSrqljv/dBCdGFHwIu8mko52pRPh9iledV+7LMrOu
         NOKcrivz/Y4TyuaJh9qkWSG+2MbzXfSso8QIqSTvb0XLRFIYuoL+1iRRlQbB5Q1TJT+5
         2BrkQATm8F/3vYEQlnoRm364OSIJG2qTaiLn4OanlwXbTej74MQrYb8GLoiOplh20VVk
         9969OgkhXAlYXb1nPhKPPigIhfofkGX8KdrCSSUHACshOo7+mtnCIOH6f5ASqTV5FioV
         4pyg==
X-Forwarded-Encrypted: i=1; AJvYcCW/dn8AQf9MOcsqv7dXFf3PRM6j08JcZAqDLjv1LKXpcnLKjc34P36EgMJSNKZ3FyCxof1uxXCFgfqnloI=@vger.kernel.org
X-Gm-Message-State: AOJu0YytYkfDBGCLLNzRTJNnfpZgVJRJTZ2Z7Rb4jUYDzIQXnLgpBYkZ
	i3OnhleARbCLqDMSwvGN4E9jogtHSxz01WzUZyCkHWnIif2z4DzDcQsCZw7srDh/FwTCY4NC/v+
	4CPZcxfvLQBNQa0EshS/q0mGL8wMXp+oLiJe43qNEd3lCLwv2p39PDSukETU2JwZgEJ9WEWX/zO
	A=
X-Gm-Gg: ATEYQzxOpzE8jtmwU2NMzEJWQzI6ebIB4p/mtQQ5UbzEvCbJU93COLSWirMeBoqmP/g
	Gd0vV2o8VSD2KKTx1HI9vKeyqjM0cZYg2Fh2viJWHYJGw29KmzW3hZ1BoAr3DpWXTuwjLNJnmUt
	GJQ7vbp8kR/eZWUiECrgSVGslUnkZpUwKBPoGvIfg+0XfJCMwcbXROmw+5Nuh3BrGE70nd9Visj
	KpHuVaNmDPGu9+RKfJ8E5VntPi6D+V2s7g/KJF7/VD+VW8qzqxt9pobl1UNQaKHh2j/8VHvy2HF
	l9lwCNRsYKjAzJgzoxsEvPKROYnu3kL/ls/XhQktEtY7kJ4ZL5asnBSs/J7Ec6hbz+zePeLCkas
	f3kZgbjcUjxQxsNEbECaOGlEI1GKWRfa+UJWOnxNz8tvOfMo=
X-Received: by 2002:a05:6a20:3d8b:b0:398:95b7:c409 with SMTP id adf61e73a8af0-39895b80d85mr6429296637.25.1773130014724;
        Tue, 10 Mar 2026 01:06:54 -0700 (PDT)
X-Received: by 2002:a05:6a20:3d8b:b0:398:95b7:c409 with SMTP id adf61e73a8af0-39895b80d85mr6429246637.25.1773130014138;
        Tue, 10 Mar 2026 01:06:54 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e195c40sm11121969a12.31.2026.03.10.01.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 01:06:53 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 13:36:27 +0530
Subject: [PATCH v2 01/11] dt-bindings: crypto: qcom,ice: Allow power-domain
 and iface clk
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-qcom_ice_power_and_clk_vote-v2-1-b9c2a5471d9e@oss.qualcomm.com>
References: <20260310-qcom_ice_power_and_clk_vote-v2-0-b9c2a5471d9e@oss.qualcomm.com>
In-Reply-To: <20260310-qcom_ice_power_and_clk_vote-v2-0-b9c2a5471d9e@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org,
        Eric Biggers <ebiggers@google.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Tengfei Fan <tengfei.fan@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Yuvaraj Ranganathan <quic_yrangana@quicinc.com>,
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773129997; l=2173;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=Lnqx9aNGInN2dRJmGZpQf0PRaaOxvX3KhhTXbK0GgTM=;
 b=zB8v6AEKKRzJnSbCHN+ZFKKVEp3mSGm7eQ+1lFMrA5Mxnhz9gY0/fUSSZ5IF0IneoEOHAUHb1
 n5JxF6wQ984AOw5p+uFgtseY34FaWxhVVJ4giaKNk+DPxYeLJM6b/6H
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA2NyBTYWx0ZWRfX28483qLpUfKZ
 p71R3OxtTOfGEXVYuHNNALwQi5qP0S1eJ6GlSELtGdGM+3XtfcByPisf/SludpPAo/p9zBroKss
 gsVo1qEPcE0PsJJO8MGe1IKywaBuXGUTcNL7knOv77sNeY3V5fYIaW31pJoLGBpUm2UvHHzteUx
 2zmd5UuMSThm6SKlfgb52a4ybphl1HJvkBzWQn8wSY00kzzTySmKKTPRxur1fYUny0rjhpXr9jC
 wTy9HzJRowErYMHHgUXBlZw6GtYHAlsmxHoQdG1D0wiLbX5UBl1S/KYozGHFtXWTsg2kj1d+/qv
 2QvhF0ZgHarGx6UFhkTRYtq8YVSL/yLyPQaqsBDw+I3iKJrrZi4mRkZVeGYhiFsttyJDDzoLUx6
 S1wK6Kgk2dtdWuHG0cRmYwPANviTHJRJboBf7ugs11fWlWkSGcHczMvVDdfwQbYEze3V8XdO/H6
 t4KMacH7oJdbByUeYig==
X-Proofpoint-GUID: AKfkMGX_TankJgnkyJmu3rdxM9YRzFPw
X-Authority-Analysis: v=2.4 cv=KLxXzVFo c=1 sm=1 tr=0 ts=69afd120 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=k5GuLpEFyUPj9kim_VUA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: AKfkMGX_TankJgnkyJmu3rdxM9YRzFPw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100067

Update the inline-crypto engine DT binding to allow specifying up to two
clocks along with their names and associated power-domain. When the
'clk_ignore_unused' flag is not passed on the kernel command line
occasional unclocked ICE hardware register access are observed during ICE
driver probe based on the relative timing between the probe and the kernel
disabling the unused clocks. On the other hand, when the 'pd_ignore_unused'
flag is not passed on the command line, clock 'stuck' issues are
observed if the power-domain required by ICE hardware is unused and thus
disabled before ICE probe. To avoid these scenarios, the 'iface' clock and
the associated power-domain should be specified in the ICE device tree node
and the 'iface' clock should be voted on by the ICE driver during probe.

Fixes: f6ff91a47ac57 ("dt-bindings: crypto: Add Qualcomm Inline Crypto Engine")
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 .../bindings/crypto/qcom,inline-crypto-engine.yaml       | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index c3408dcf5d20..d9a0a8adf645 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -28,6 +28,16 @@ properties:
     maxItems: 1
 
   clocks:
+    minItems: 1
+    maxItems: 2
+
+  clock-names:
+    minItems: 1
+    items:
+      - const: ice_core_clk
+      - const: iface_clk
+
+  power-domains:
     maxItems: 1
 
 required:
@@ -45,6 +55,10 @@ examples:
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

