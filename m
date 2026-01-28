Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F1E33A70A
	for <linux-crypto@vger.kernel.org>; Wed, 28 Jan 2026 08:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769590017; cv=none; b=nWyx5dRff2ZG6i2PTKw7QnO7HqdlgOKxE4XdtCKjqGaZvq+A7nFS2LpuHd6fWmFaemtHW99nfXjKOlhJz8v/UUsdgWXVTP1KaPE+lRaJJu6STuAZ2ls/hgQh4+hNNR3bAFpjllqWOis6bzdW3XKBNB2V+wWcsZI9MdBM3rnEmbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769590017; c=relaxed/simple;
	bh=fmj74JXS7b3/5JPwnhbm6Z+ccfNWzkm0zWwsIkb9dMc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JCj427pY7WT0D5rMtqfvmTFaLmwfjldZrIeGlvH5l5p0VhMRnyiINF+RsAd57Y8IP0FWnviqy/dzHVy0L8Ew6dY//7u22jsmXnZ+FUpUNYjj9GJ5IQBg5BBEtie4X569muHIg8AGaugpB85y5qjtLwkBX8+TMt8BozHGTqFjds4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cNxQ5JfG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MHef6nz9; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cNxQ5JfG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MHef6nz9"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60S3VkPx1334166
	for <linux-crypto@vger.kernel.org>; Wed, 28 Jan 2026 08:46:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yfXxaOd9plb61s8TF4WmKmUfjZnHFbvBpCT+9AAgBMQ=; b=cNxQ5JfGTdFsguwq
	a+yQ6WlBN7RzFzTRD0tCyWzIPX4XOzNr2G9Y4oAvQpogqQ89P/TdJSu97PQ1P8zA
	ZLg3qx6lgKzK50lCuRKoHVnfLgENZbBSlUEzExeR7CX3VZd0Lm7hoXs9PFNvOwbG
	f+IgP9yqMZadQAXgsk0e5vvrZLLwAU1qirkRF+QpZPI6p8MM1SKf57Yvpb6pY48+
	0SPNhno2fW0eIGnrRbjCVcwPFbj7WMUOOrSkizVgIPYdCYrAjk4dAMlDC/wismbs
	aih70PHfzdVQnhGGbUVlkRyZyvOo8LD2xXuv4Cg1LR/MfT65+eDTa4SJMqvPGyoE
	uIpBLA==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4by1dftq9p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 28 Jan 2026 08:46:54 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-29f25e494c2so10873165ad.0
        for <linux-crypto@vger.kernel.org>; Wed, 28 Jan 2026 00:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769590014; x=1770194814; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yfXxaOd9plb61s8TF4WmKmUfjZnHFbvBpCT+9AAgBMQ=;
        b=MHef6nz9ORl7LrxJlGd6mWaBw0aEl1L/34HamipXeGBv8v9noqYOqepBShMlCmeVD1
         TASHCfTVLvdjDJGB3zwcv1HnLZ/WwUR6xvgV8Y2vvwWlRs9bdDL3wbWWNtjtc6duVSzR
         oFI6ekQn3xrFNmjojibMOq52RUb3/t5vNiMKz50Qf9iqpc8h1lqHLD9c3+3lkdWHK2E2
         KFkM7T6+LD+8B9BBNB9VdzIhtbZ6q9ef1bXpE5Vb7FycjbDRhTzlYmPIxy5dSN0trlkI
         XpFnEHQACjAL0d0ytPhX1jIitPve1auG79/Cob6fgcJ2q6d9Mti9h0qMRJMhMEyHQi+L
         m/wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769590014; x=1770194814;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yfXxaOd9plb61s8TF4WmKmUfjZnHFbvBpCT+9AAgBMQ=;
        b=ec12FSqmWhfBZcf57VEkU2qJ/lHz45afcYvhtqsHr6cUGukbwo520FXdWqJsl2VE2A
         Q003M3Lklixgd/LCnONYvjBHVgNsp294xW5Qfm30Rq3geueCgHT5fVpmUxClKWdKnodM
         m+LAsXB1Rje83pLRulzl4Q0uTS/JA6YL860wRU6WwHZCPAIbG65gE4iJonVUeadJhKjG
         d/EVrB9tl3BM9XHu0E9qmNQH4VvTgif8lOtTXBmk27XZy+h+QkEd1sturPBXyH/ssCxz
         RPe3F2bgm21xSqRnMdaRARuZm8QrB8FhDyOxBENk5lRzp2BwZRXbAbTPRNO4SGzAqj0J
         X+bA==
X-Forwarded-Encrypted: i=1; AJvYcCW6/wDZO4p9C5SzTtsKjxxlJEdC1uDiSsCFPGHUYnx0KAcBs6svreb6a7NSSryDH7muK5iBk0HvX30pu1g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxyle/DIZHdgS3fC/aT9TR68qmvvEZLl6XXDby7h2loinwOVRbN
	7JKZWHUfCOsArKljsE01XHlb2p0BY1WZ0MiZFpvdwRGlGdpNnZL4T3QCR+JUsFHnbWxEu+XznoK
	eG/ryUhxKVW25IB08z8/qO1SM56Six4B47cGcqI3IWUod5PMaP673Y6NMHFMcz4LDFyA=
X-Gm-Gg: AZuq6aIjZaPbRGlb2s5aBoYC258RV0CYA3RrYDTgU5Mff2O6kGCV/sN4ZonmOjmybE8
	WXavv9ltKYbDvfdLAhNO0gP3EUJe93uIAYtpz4X3HVX3u4LIG/CXPGtaYhWryNsnhDburajs1Ma
	2htM8bB0vrEJp4sNILZ2FKYaS674JzQsZz5WniyDfF8A9mwDFeFawJHfC37JthXIVFu9/PDjkOV
	FjhVQVZoz4YfVaXWDqWqdH0IKcX645h5MB5bJKzYWae7AiXIS37rKzmBK7aTRGk/lGvAhel6SRx
	j4BD7a8Q4YN/c9vOyF+pi1qZwiUYcVg2Bd9COGSm9jPoh2XygzhlyF5MT6vibPKy2B9KMT9Bp8k
	ykx2Fl8h2RnZ+gjAN2nKd4cdZN7/GdL7m5vxvTfv/vXPS/0Q=
X-Received: by 2002:a17:902:e881:b0:2a7:8486:ef13 with SMTP id d9443c01a7336-2a87134ea8fmr48957355ad.29.1769590013397;
        Wed, 28 Jan 2026 00:46:53 -0800 (PST)
X-Received: by 2002:a17:902:e881:b0:2a7:8486:ef13 with SMTP id d9443c01a7336-2a87134ea8fmr48956775ad.29.1769590012783;
        Wed, 28 Jan 2026 00:46:52 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b4c3b1esm16263075ad.63.2026.01.28.00.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 00:46:52 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Wed, 28 Jan 2026 14:16:40 +0530
Subject: [PATCH v4 1/4] dt-bindings: crypto: ice: add operating-points-v2
 property for QCOM ICE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260128-enable-ufs-ice-clock-scaling-v4-1-260141e8fce6@oss.qualcomm.com>
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
In-Reply-To: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI4MDA3MCBTYWx0ZWRfXxpA2YYmCrxtF
 u0ECln1ZibKNlvtP9ZZQf8loUEbwkR9WbmDN91MuRrY3Bkq7WpgugMrntQTJ66IBxpiUvAHW/O/
 wTs/ehLh2tyNVJ35hUfJOcGAVkvZmhEg/A/PlIXaPtJn7gmUAOKfMb4PJYKdMkgBAxrPhPHClYv
 BxI7GKI3/wJctrP3Hr0pidlQ9IHd/32aqGavvffZpTBBl91vyT8gv7UHvDBJmdaQiaD0GXAZdl3
 6dBmUAR58tx/Uf6wp6cyKOs1OAuf4uPSv3wZAaV3cY4yD5QT8CeguZRWKZO5NqUw4rOhXVZP0Nr
 x2yA4ASowgKPTn14jF3BSopryLUurH0bXeL/NgicBGIiTlNDFHUsTYNoTqruuGiPMz2URmWk5S2
 PiYU5Xx/A9iRdWjToXxO8H8BENpTWjAIgNgXD/j4NdgQEiaNeuRvgivOraAp0NFIa7ZjluQrA1P
 WtDXg4VVUo43zQaimjQ==
X-Proofpoint-GUID: h77XAcB-jddsriivZ4pxioMWHK_FYuv1
X-Proofpoint-ORIG-GUID: h77XAcB-jddsriivZ4pxioMWHK_FYuv1
X-Authority-Analysis: v=2.4 cv=YeuwJgRf c=1 sm=1 tr=0 ts=6979ccfe cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=nchbEs_9QIawOzQC_EQA:9
 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-28_01,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601280070

Add support for specifying OPPs for the Qualcomm Inline Crypto Engine
by allowing the use of the standard "operating-points-v2" property in
the ICE device node. OPP-tabel is kept as an optional property.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 .../bindings/crypto/qcom,inline-crypto-engine.yaml | 29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index c3408dcf5d2057270a732fe0e6744f4aa6496e06..1e849def1e0078feb45874a436411188d26cf37f 100644
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
@@ -46,5 +54,26 @@ examples:
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

