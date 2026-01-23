Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4C725228C
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 12:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769172502; cv=none; b=p/HOZfFX7pMWVbHTD1KmxjPgMgEKFT/TEwPZTIUW7NdIiEkeHlt+UctTO3u0ZQVDHZAEvQJDHhxiMRSoimm/dfSvkSF9lR6jilByYh1DE1l6guFk0sMsyUAmI8d9Bw9Yt/lMx5oZBQFV0kbstsyPMU2/kgY3RjHFuUYdMs2z90w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769172502; c=relaxed/simple;
	bh=TPS6X9I+JJ4ux3s8ub0w37/Il7hwYL37igRWramUsNM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=mp4qp+ygXEvsREmsQfBAzZB0CIWhexRi0+rzo/NVkjajzU4Sb6hsZ+2eMSDsYCBrwFs9qnNS2L3bdXurlRd2HOfgrI8SQCsEz7sY9oddvCJjytK3PBslCKNd2NzH8kZ1hypc2m6wE6WpdnN5MJtWicFrsAnjHZIakljgNhPmAog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YPkU7lyy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ajdaBrl+; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YPkU7lyy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ajdaBrl+"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NB1tjm3126310
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 12:48:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=+I1sCtj+G7JfI9TPLgcj5K
	s6XVbBmyka9AQmGoyQyyE=; b=YPkU7lyyLlH0PTuKO8LD+8wk3m62cFHxhydYls
	T+NMpQ72VQsrZj9mQWoWiAZWYTftTitzPdN2Q35ej3O60eWr2e4xhUxTCZKfkdtZ
	1ZZl1zlWZyTAtInab9L1hCI42xKSMjc+9gOhZF5OsMqpRK0opcg/3oMznI/ZOs1f
	+4ke3uJioVtcTnn/ytiNuanF3ZksPZuLUPHuwr7yUwk3wohB3ygVocUSbbsq5QfA
	/XmAMivXWwR4igtptgM+m/lI3IPgL4EVwXOUOVVGrBE13cfE0f6ZM0MCEKF/j4ut
	KGo7GSmB3SK96GQX0dfuzvK48F94fgTMBBTh8Y1995TUmHMg==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4buthdu78q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 12:48:20 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-81e81fbbb8cso2282558b3a.3
        for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 04:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769172499; x=1769777299; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+I1sCtj+G7JfI9TPLgcj5Ks6XVbBmyka9AQmGoyQyyE=;
        b=ajdaBrl+9dLIuhKLQrOjzvXtr+fHavVwL0xkEgO6KYUBZifEnH98ra4B99VXXWpS1N
         uvG/TXCiBzqOnFYNxcdF9ZGEixY4MvogANLKgoyWiXw9NcGPxiMPYQcHpHc78IhmTQTY
         279Aa+mr1eaoMlT4i0VPbTgyZJyaT/0AGNhjZ4BDF/UlIOq8ru+mKslnu9g5ctIx5HZi
         wT5g7eDuNYSSWD0MSgUanJwduvG0Z7kz0ijV3fY7VGhk5upzBl6M8koHqOI1j/SwaViG
         rqWb+vdhyaW7eCTDs0e3uPfubmFa7qFoJ6zoIk2i0JZH3DnYgl9OKvSAGv4Ixw2NswL4
         2Z7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769172499; x=1769777299;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+I1sCtj+G7JfI9TPLgcj5Ks6XVbBmyka9AQmGoyQyyE=;
        b=BsPzHpDR/3vieOcDBf9jAk9bRjd9kTtKOMGY+1MkLLdOjnVPLLkLKi7EJZ23zAg8lh
         3hiA+Mo0KPdLquca0yafX2LxTv9tAAE0lKYdPlwV6ErFl6GD25cWXlM8TKSt0myPWMHc
         fln9h4KhjbedqKpVdsXOfkfwWsl6XeBJLUTplG4vGlr5zAKs4wye9spZ8+kG2zvE5/gR
         Lri+XprbXFgd8HqLvZ83NPwzAvTQV7MlH9ByxXmHe/9jUpEMbrkezQSPNNrcxYrtE+X3
         Ls7iZwVT29VOvjlJD0EheGqke2+wTFay9R+QWopCIBozmfZO+s0pg8FA+SRIZWUsjey+
         Y0lw==
X-Forwarded-Encrypted: i=1; AJvYcCV02wnuatCqF/YqOF0k7wrz9AGS2axt03EmrRflzP0O/gmJAGmQgs34svMYgu24Z7xFSpNxaEdpiDjChhg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPBJ8EWCIliyYHwXmYmfbjLO6WDZuKlxdMpRxbms4UypKbdzuV
	s6ar9HChA4jPCjxdtyNoV9PCzptEw7X+QygSPwM15LGKGOHUrsRthh1/Ogj3LPb0Wyg9fh2sb9+
	lbj2hkh3sIAgZjFlKxIYWbrKHkQJIkeByQknflJM9icp2boZZXMcmM3wRJ0sxH1FcvKtT6avbUq
	4=
X-Gm-Gg: AZuq6aJM2kptuUNg6C+ARfHFt/TMJJn37TNOdjzY7OFLt9gadHSiz/nLNul0+BP8RaQ
	G7UNJn7W+qlCzINv0G0wqCcHdSCJm6IesgD/CIQgLnxff05PDZulKPLMC3YKrHcNnc2UwMXc1Ax
	dRBz0vocnxtriaIjAwojCq7mJ7iBu0b2Uwy730FDAx5rXzjbyQUomI/6eg1hI+57dTSQULf/Rjl
	iKX8O2GpyRy+abbHIMGYIR1ZKvPFojpfQtPExb8b0xxQJVpH5D5nCFVUH9sB/Frn7JBzoR0KxeH
	eilKdFflu0bx28HwyBJ9UB50sv76/nczJxp1CN1n/x5QZ/f+rEV/fdZvaQysuDoaKu3hSPVWrwf
	+2k+34oAW1bCFuudLYzQ4Xwbr/peSZPCBmHqA3h9b5/FCFj0=
X-Received: by 2002:a05:6a00:3318:b0:822:f928:fd97 with SMTP id d2e1a72fcca58-82317d28ea4mr2300812b3a.22.1769172499095;
        Fri, 23 Jan 2026 04:48:19 -0800 (PST)
X-Received: by 2002:a05:6a00:3318:b0:822:f928:fd97 with SMTP id d2e1a72fcca58-82317d28ea4mr2300785b3a.22.1769172498606;
        Fri, 23 Jan 2026 04:48:18 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82318645fdesm2191919b3a.6.2026.01.23.04.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 04:48:18 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Fri, 23 Jan 2026 18:18:11 +0530
Subject: [PATCH] dt-bindings: crypto: ice: add operating-points-v2 property
 for QCOM ICE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-add-operating-points-v2-property-for-qcom-ice-bindings-v1-1-2155f7aacc28@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAAtuc2kC/x2Nyw7CIBBFf6WZtTdp8e2vNC4oDHUWAg6k0TT9d
 9HluTm5Z6XCKlzo1q2kvEiRFBsMu47cw8aZIb4xmd6c+sHsYb1Hyqy2SpyRk8RasBhk/a31g5A
 UL5eeEMeYJPrmFfCBzfl4vQQ7eWrnWTnI+x8e79v2BfsjaL2IAAAA
X-Change-ID: 20260123-add-operating-points-v2-property-for-qcom-ice-bindings-e4e27598fabd
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDEwNSBTYWx0ZWRfX7cy6bjeRTld2
 Gj8rCneY4mBePyUPcceAEYFs3OWmB3jBUzk9SoXjgDVX1iQ1X0yyIYlYrCciOEi/xBRnt2nunZi
 KOmScKQz4OFTEj7GGkFdmGbUK4QfGLy6O/X7X2WjeXB3qnpOzjyC+lX4IfHIWv813zd6hofjXPw
 HZ/h0Tv+liKkW6OneQQN5lpH+stGPuaueOS2AeQYDUG8cHatJoFMBcYnCIxuhIg6xv9OIpr19cI
 tp361Lno8WhmgoOE9a7BjQ554C/0VlaWuoe+xChlmCyt6BxYOZfKVx5QXhmd/oGfw1Ko0vzFwyT
 NCPmSpV2cVxhhrn5Wp2nmd/mzAPTZMx3HNZU6uhREad/WA00bDB5L9hNJxGYyz/zJQt346kfX9f
 MeEBue2bhp92JuhhIG1wFOxLS1tjnpoIP2n7QnAmA8/M+q1VYSb8tepSu9gZkcD1UR3MOkMfsHl
 qOVul8yf2hbzfkKKv1w==
X-Proofpoint-ORIG-GUID: D3TldOs0bGY5vlBqRv0ggcMYHdHHhhsz
X-Authority-Analysis: v=2.4 cv=XauEDY55 c=1 sm=1 tr=0 ts=69736e14 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=nchbEs_9QIawOzQC_EQA:9
 a=QEXdDO2ut3YA:10 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: D3TldOs0bGY5vlBqRv0ggcMYHdHHhhsz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 impostorscore=0
 clxscore=1015 phishscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601230105

Add support for specifying OPPs for the Qualcomm Inline Crypto Engine
by allowing the use of the standard "operating-points-v2" property in
the ICE device node. OPP-tabel is kept as an optional property.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 .../bindings/crypto/qcom,inline-crypto-engine.yaml | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index c3408dcf5d2057270a732fe0e6744f4aa6496e06..0e7844e64555ed8b4350f0e18bdd20fb64f2ac6b 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -30,6 +30,14 @@ properties:
   clocks:
     maxItems: 1
 
+  operating-points-v2:
+    description:
+      Each OPP entry contains the frequency configuration for the ICE device
+      clock(s).
+
+  opp-table:
+    type: object
+
 required:
   - compatible
   - reg
@@ -46,5 +54,21 @@ examples:
                    "qcom,inline-crypto-engine";
       reg = <0x01d88000 0x8000>;
       clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+
+      operating-points-v2 = <&ice_opp_table>;
+
+      ice_opp_table: opp-table {
+        compatible = "operating-points-v2";
+
+        opp-201600000 {
+          opp-hz = /bits/ 64 <201600000>;
+          required-opps = <&rpmhpd_opp_svs_l1>;
+        };
+
+        opp-403200000 {
+          opp-hz = /bits/ 64 <403200000>;
+          required-opps = <&rpmhpd_opp_nom>;
+        };
+      };
     };
 ...

---
base-commit: 46fe65a2c28ecf5df1a7475aba1f08ccf4c0ac1b
change-id: 20260123-add-operating-points-v2-property-for-qcom-ice-bindings-e4e27598fabd

Best regards,
-- 
Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

