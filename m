Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC572BEC55
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 03:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778557080; cv=none; b=Sm4IbA+OZBzVsH1GALfRCRHnM7vg4ixQlESETe5CjuZSQQzmb9l1GSCouHJq+7d3C6Jy3jkZAWAlscyWKO0mMEc3VdhaBcged5Oemb0AbzMw/YjkvSWyJXQnxQvrWBTBNJCXYpQ410CtzEMRmPN9Szn7OVRwB5vf9OsZBeXEgvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778557080; c=relaxed/simple;
	bh=evVlV5QhwdsHRVHassrrlpvsT6O77VZkUS8aHmvhG8U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jpgCHooaUv8ccYatlx0xS4geuC7r/zaMFHEYPdfrYNLMdLrsZuvbh4ZO2kG+tkROTjhvvk+PinsxjQoqnK5G0nVb2wM5VXIWXyOy87kMLtOoPvIsXYBUV7SKqc2jv6tKNzt74GSOHLSXkspDupDLQ+Ag6KjL+hfhmPP4JQrGbhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MMnT+jYK; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EWei9E0F; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MMnT+jYK";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EWei9E0F"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64BK6m24866755
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 03:37:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=gE84wqweCwZ
	bNXasDDRhQ76QGeX+FWtTrNkIbNe56u0=; b=MMnT+jYK5WvHqsQkin17MDBUQMj
	O2oIxpngC+mo8NmtcbC+CZz+74Dvn80gwIsVW61q15Fwc9Jgaqptv/b7l9yNZSAV
	jupPuw1hTY6eCgvBW0efAVR7hk7qbkG73kvqBviASKAh6H7MaXLpMwAsFn86UK+2
	LBZQUvYi9+q1aPp1AWkEuYZpe0j64iSksT95oRzKqwgR1xn9aKIS6aS6WMwpy98i
	2ulzYT1HJIee3YKf4uoQ3lilC6BihjN5hRj7h37S3M3CfIB24Q2ykj+Vyv9BXiU0
	3+PHhiIXtjsVpMdqwOMWjAj4YqKeGkT/8MXr+lR+5Y9fbLq48bL9NdQtd3Q==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e3nv292w5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 03:37:57 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-2fe1cf409a1so2860757eec.1
        for <linux-crypto@vger.kernel.org>; Mon, 11 May 2026 20:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778557077; x=1779161877; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gE84wqweCwZbNXasDDRhQ76QGeX+FWtTrNkIbNe56u0=;
        b=EWei9E0FeNle3yM21vC14rtKmepTH+b+t4UHCtPqgdqhr/Ue45RuYgsXcU2elfU2Xw
         ybLTOWG06Zmg22Xu/0y1PHGNbTojuKJ3mTRsv7maYF69vxYFvYSVCFsEpiOWL0zLKVdD
         1Etfn6v/TC4Ksm9O4WeP6DXSvGDlHyWgbDZ+2OqUyF45PQMZIilHbebX8tb/SlAxG1rh
         ktsyqq51fc1C2HnVCmNS4QQGZmHV4yKpZ2s24CXXxHLKrr9WQd4Y9nJ8MAyGzMaKdW1r
         IZtDOwih/1A/0OL7yVrbhK18SopcTAMAWe8ARJ7ChS8heXnLn9Z91Vy6sAq90w9ECsZx
         +88Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778557077; x=1779161877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gE84wqweCwZbNXasDDRhQ76QGeX+FWtTrNkIbNe56u0=;
        b=ovWRJwzFPWg4gZhugx22KF3E5ii86hrczO25g8O+esLryCeAM3io9ZQbWUWo+EYlXz
         ZiZXnlx1135E+kezfl7EnP9n4GLUn2G9Ul/sk5OylX6NSj8ZkrF1ebfdo4FHAC8oUNQa
         sAFvgTWZ/8GpCtwXrI4S6D6EmP9H9esi3vz5Jk1irLOp0Bg3SvImNfE+/Ld3g1m4dHwn
         QsYFtvSCrm4niQw5hqyOXehwQjPnVMb0yNsW9Ci6fyC+f2gTyFIIbIiwscDAUC8iOMLx
         DOnBsf59fPoD8dRZszEtWdFkqN7aYkCZc752EBygm3EieNUvk4ei8LfMgjX6WWQvFI/i
         xC2Q==
X-Forwarded-Encrypted: i=1; AFNElJ/Q/wjo6g9NsA7ytjj5rddruRWWQ5lNMjA7URQPnxxJ0Wgrq0pDezbD29GyvKapDopLWvdrKGoNswoA9pU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLiZ2jBq9zOqaxf/miMUWyui5AZEbOr2DKvvIJ4aDCvQbq0+x2
	WPfcaxCjaiQ+Zh2wNBUSkgYypNo8XIraOYjZOZ6foRhO/mcX2fFXHOsrgkpLyEo4QHCB6EGM14f
	LvoDJk0TYOkAln/jSTEQSSQhsB+SCdFAKu5n8/4zrcFJb9ENiNKWFpT/tiEE8fx5O/LY=
X-Gm-Gg: Acq92OGaPJp8zq8gZsP6egvHTE72jQQfTnKeNYF/EDSCmRRxPQO2j5CFEo0hb3VFcSH
	Xs7zA4BAShyzQ2FWiuOh7c8A8/6guIKEXD8AH3ABm0ohiTJ4iik0iMis96iLUwoH6uKDalMbTcR
	n9sTcmHiREmCKRs3sgG4GBOLrNPRz5JCLGHzXi0C67vqlIwuNHpbcK6o9oF9u/1rl88OXSzSMpU
	wkfsun8nyNCZrFoPwrjG+W85TX07hWJW9kePv3IbYSdAaGs/68MVhOH9uI/EXXjiRJXK/7GyDrV
	FRw9iuM/9Mk8AK2qvSsTRtSV5okUqtK4EooET4E6WJjJl4ZPK7qz0N0q6cwfljE2/Mhhatk0ADX
	3PDoX5RXP//0bjbjD4Cm92AQ5zUTxypjidNitTCLhkyDMc9aK2k69+v8VoJSMZjGe10yL1s8mHy
	RSR/57
X-Received: by 2002:a05:7300:7244:b0:2ea:e93a:ff9b with SMTP id 5a478bee46e88-2ffd5cbbb6emr765288eec.13.1778557076496;
        Mon, 11 May 2026 20:37:56 -0700 (PDT)
X-Received: by 2002:a05:7300:7244:b0:2ea:e93a:ff9b with SMTP id 5a478bee46e88-2ffd5cbbb6emr765277eec.13.1778557075905;
        Mon, 11 May 2026 20:37:55 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2f8859eb4b7sm16730109eec.2.2026.05.11.20.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 20:37:55 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] dt-bindings: crypto: qcom,ice: Add sa8255p support
Date: Mon, 11 May 2026 20:37:48 -0700
Message-Id: <20260512033750.3393050-2-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260512033750.3393050-1-linlin.zhang@oss.qualcomm.com>
References: <20260512033750.3393050-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: eWzQPL_lHXhq5Nxl6SoHwh0_PK3B-2Zl
X-Authority-Analysis: v=2.4 cv=Mv9iLWae c=1 sm=1 tr=0 ts=6a02a095 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=UuHxjPGgWbCNvu6MkpoA:9 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-ORIG-GUID: eWzQPL_lHXhq5Nxl6SoHwh0_PK3B-2Zl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEyMDAzMCBTYWx0ZWRfX2U3786NHE+ba
 +qp+Betx6OoHmYX31/xPn9OrB6pPwJeqwIrIKV23s01rotjoif306PFkHnEYFpkiA0b1+ruU++W
 QKU6XfbgRnj4BsYdmua03TtbBE8XkrdaiGSA4hM20ZS5nJlsNh3iTPCiAyI/gprM44KZSeiYLHv
 KAY/8YBQILG/nxGyd2hVaHEnoFWX2XkHfUiX5pRVv3bfzZS9kri9/Bg/U3kHLqqVOzt0kv7i0ru
 kuyokZ6zUJ3DDsB53/ey3E6dqOK2Fb/V3skiZ1nqBxE/zpr2+6cSarwJXollCL75DrCJ+439LyC
 Pl3nIralim7elHKVoL8wQxrRYl8PeycFlmbCTZgEHCXP2TFEAtSt0zP8oiHEmYUsC9cXzNWSmVQ
 /h0wbUXIyxlQwBmg/fcaI+3BNeNTCpnOUEfcHXictaoce4M0JdrqINxn7edcLxrq2yOjzUsuYo1
 OgQ9U6nR8gMmsuOBLfQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605120030

On sa8255p, resources such as PHY, clocks, regulators, and resets are
managed by remote firmware via the SCMI power protocol. As a result, the
ICE driver cannot directly access clocks and must instead use power-domains
to request resource configuration.

Add the qcom,sa8255p-inline-crypto-engine compatible string and make clocks
optional for platforms that use power-domains instead.

Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
---
 .../crypto/qcom,inline-crypto-engine.yaml     | 27 ++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 876bf90ed96e..4e7d9111d0eb 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -17,6 +17,7 @@ properties:
           - qcom,kaanapali-inline-crypto-engine
           - qcom,milos-inline-crypto-engine
           - qcom,qcs8300-inline-crypto-engine
+          - qcom,sa8255p-inline-crypto-engine
           - qcom,sa8775p-inline-crypto-engine
           - qcom,sc7180-inline-crypto-engine
           - qcom,sc7280-inline-crypto-engine
@@ -32,6 +33,9 @@ properties:
   clocks:
     maxItems: 1
 
+  power-domains:
+    maxItems: 1
+
   operating-points-v2: true
 
   opp-table:
@@ -40,7 +44,20 @@ properties:
 required:
   - compatible
   - reg
-  - clocks
+
+allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,sa8255p-inline-crypto-engine
+    then:
+      required:
+        - power-domains
+    else:
+      required:
+        - clocks
 
 additionalProperties: false
 
@@ -75,4 +92,12 @@ examples:
         };
       };
     };
+
+  - |
+    crypto@1d88000 {
+      compatible = "qcom,sa8255p-inline-crypto-engine",
+                   "qcom,inline-crypto-engine";
+      reg = <0x01d88000 0x8000>;
+      power-domains = <&scmi26_pd 0>;
+    };
 ...
-- 
2.34.1

