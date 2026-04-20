Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF563783D0
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 02:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776653864; cv=none; b=IkB+4TCOd805o3jPKHsyKFNzFA8pj7B4qU/tBcrU8S5eN4p+uBmF1DWa0cP+KGcG4qFt88ictd0tFFBjoyWESbtNqhjMh5HVZ/YaXA21RxX+bZuEfcY4UtQgDNHSqHuHozpoIxyaCG2XKYckirDp/yAR1Kor247Jns1AsWznRrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776653864; c=relaxed/simple;
	bh=9dOaVE48Hg/Z6lF6josr/LqHefZ+NYo+hszbsN9lkMI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AaRCCjaHGhGIf0czswKAQAdVo5OmyjYjlA/mMaHviVXXEzjA4XJ5wECXZTme7mSUQ6J17tO3ZsEgCDmGS1dmILv6a8JIw/e2Nes8/DyvIvVHwaCD9wroJt27q7InWbAPqi2/oiW5/u/BOiTVNehzIzLIusgMcTO/bsUM6sd1OT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Bfl9yydF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=R3Od2MBe; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Bfl9yydF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="R3Od2MBe"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63JNke7J2292654
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 02:57:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=aVmKcB2K7HMO18UqcPnricoqZOY6WNlZ+jF
	5oHV/nMY=; b=Bfl9yydF/gqkmIK5iN4VBoxfLJmWF4sPg6doDjMaFM4T0Il5qC8
	XaiuiURyKrx4vZwnk6L6ZqprsLGaIWE7VnpQ84pXT4jYrvnduhTHURgKP8vruZpC
	uNiE+ggKdmFikebv0ybjGPpHpSvvXKmKRLLuhVRguQK9ZS5Ld3FAWt0pk9buqV+E
	pLgOc99mLElWVdvnmYywhmVWVG+oJxIsuE3D6niyyvuyeOrMKqWyojK0X22s3NlP
	TmYId+ISTd8q438U1FWZz2jDl73jxqYow+E1P3JtGWc2lulo9UIjcsS4q0XHGU9l
	0Y2nbBiEOSyUo/BAHeOgwyEUNFm2K3RDRVQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dm34hbpnk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 02:57:42 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b24a00d12cso26328195ad.1
        for <linux-crypto@vger.kernel.org>; Sun, 19 Apr 2026 19:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776653862; x=1777258662; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aVmKcB2K7HMO18UqcPnricoqZOY6WNlZ+jF5oHV/nMY=;
        b=R3Od2MBey0Ok5KmfGoDgkD+O9wk9soHxufzbYDrSrQG7lD17HJGxFQHnr2zf2PnRUx
         CBX91hUY6AOt71u/hwhD1ad+S1slN3GW/U936lwRo2SK4dBRilHUopbQ9EDOyeqGeKLH
         OQK5UF1Cw5CkPepio2iF9gqQpAUqFH3BHc675QPJVYxu0hL/JOXKP49070eRf3rDKvjM
         sWARVEg5d3JFZaeGVYfkMyDvUN3Mjqcev8rIw8EJgFpnOeYsoPrR8r/tnVBtfv8h3tZf
         MlQfiLs5ysuWkdFtjsVWsATE6i9WksAH669gshfU6RckJq/ZTnhmAZXtgPdkp4kaCZYf
         LEAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776653862; x=1777258662;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aVmKcB2K7HMO18UqcPnricoqZOY6WNlZ+jF5oHV/nMY=;
        b=dTJ+aJy5KfgmVJE3wKBVagCZj0CxXh9yKG5VsNgjQXy0pWx2Q5BjUUoZQieStfezrI
         brKnK99Q4boL2fOyKwyOZR0hF28pGcasWO62YJTpZ8DtlJEkaDNRuIqQkEPquNmzeguv
         adWz9IjIJoJVwEv49vzrLFOlfoIAjgUFqAnJtuTguP7/KSlfNBNnqrjBVCwrkAvQJeDP
         lwoDHFg+U8jTj2WlERxIJ9gI7zG7DpTrykmVk4CAe1YKRQGUkU2K/nt/lUiOnNFh/fG0
         CcbIG17dTDSorO4JYCgnptzJX9cwEqBlk6XgIFVMSCidtlqbnYTM7xVL5Vggdhr4VUjx
         2FuA==
X-Forwarded-Encrypted: i=1; AFNElJ+pkG6OxbxxQGJ+HRYxnDy5GTH2ijqO3aYOFOqzh8KHLWjeolX/exRtNqabxF/LsmoEovqFlQh0L4u3gdE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRQiuzgVQnIyHcffngxEsjZbCHmbXqPp/noKfJJXkJxfwWQ/X8
	GzPPcJGzZ1fy9LPodIXO6ykPY9PMW5junlLO6s+miWUT2aIYUxTqsNOWq1s9aZ9C+g7ilQv2LlL
	AL/99aSsU7jy59MrLSr5+lAUCtb+x81lkfoLzpMLSX3pzjnF9i5Kbn00ac1hnsk5N04o=
X-Gm-Gg: AeBDiesJM2U/5xO09/ft6PI+S1958IZJbQBVD6GWOameEVoWqBK22SzO1joh/zAYKI6
	AX4p21/HsSyaM7MGQLIZZ1AdgDLE+KAQFj28RL+Y6senCzhnGQGWqgK659SMaCWV/JtwIolp9j8
	fk/2IPgBTBMQiRdyo6/MIB/cOmWBO6EU3ebUFKqJzjeeiBfgkg5a1anxcmOiC8xr2/U3CU9jchy
	nBGgifB+vXgKDBuc7tWWcu4Cp2DXwBQTIQvPggEnn4WKdZCls851XAf6QdM9nDJR/VB2DwPKAnx
	auMuqT8oMgQRJl/1xwuSFc1GyLJzonIzhRAwUPMLc1ikJVVhiU9XcLMatbHwbEghBvlq2exdH2u
	kCkMlSLL/JaEd9sEiFpwqf03SESagE5Nz3YqktR4+yojeWPKdvIl4ae5cT7sWJP7s
X-Received: by 2002:a17:903:1a45:b0:2b2:65db:8c5f with SMTP id d9443c01a7336-2b5f9f4f562mr127496595ad.27.1776653861511;
        Sun, 19 Apr 2026 19:57:41 -0700 (PDT)
X-Received: by 2002:a17:903:1a45:b0:2b2:65db:8c5f with SMTP id d9443c01a7336-2b5f9f4f562mr127496315ad.27.1776653861049;
        Sun, 19 Apr 2026 19:57:41 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y.qualcomm.com ([114.94.8.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5faa2f129sm80865365ad.29.2026.04.19.19.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 19:57:40 -0700 (PDT)
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: crypto: qcom,prng: Document TRNG on Nord SoC
Date: Mon, 20 Apr 2026 10:57:32 +0800
Message-ID: <20260420025732.1240525-1-shengchao.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=J46aKgnS c=1 sm=1 tr=0 ts=69e59626 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=Uz3yg00KUFJ2y2WijEJ4bw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=TDQlr1YfmYFMKhKHBNIA:9 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: F88BQOEGq3cQHPaM3oafXlw29S2_Q6Wu
X-Proofpoint-ORIG-GUID: F88BQOEGq3cQHPaM3oafXlw29S2_Q6Wu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDAyNSBTYWx0ZWRfX9bNCoD9zi0RZ
 iNltL4uKK+jsjQXna4r/y1+YLpJBcCy7/WJcsoH5764hkOMf3IQ83ArQypArzf2fJfDLgJTh3tM
 Wa3x4iScn8g0VrTpGc5ueBswofJEQrR/OS8uwnZJF3tbSZfOf4TH8NT66HbrBd6jDVYJ9Mhms8q
 oHXTcbnQYpiNaNgh1FZ++RXGBTyUgHY5wRW+xN4Gd2xryhXytLnGCidjq0VMf3tDYPxr08788mi
 iEKcj6h82LvmKkKoV6HsfFh4WQTSI1I3Zz5t3vjUf6i/t8TMi4at5oULQ4w5J7rsWmqLZ672f//
 X6OYHnqvGWYAr0ZyalnFr5di5u1c2S3r24GIitktFfEwALaCXarpof+JLo3TFUiFU7vUozXpv2o
 HEG48VWAbS5SSrmq+ePuHJhm5Eby2XJrlGFPyOrci42NplBlCLfhs0/lFYVPSFLXclDV+ABGkuK
 8y3uOmyfaCzZeLeK9AQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-19_07,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 priorityscore=1501 clxscore=1011 bulkscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604200025

From: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>

Add compatible for True Random Number Generator of Nord SoC with
a fallback on qcom,trng.

Signed-off-by: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index 41402599e9ab..1362a8b748a7 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -22,6 +22,7 @@ properties:
               - qcom,ipq9574-trng
               - qcom,kaanapali-trng
               - qcom,milos-trng
+              - qcom,nord-trng
               - qcom,qcs615-trng
               - qcom,qcs8300-trng
               - qcom,sa8255p-trng
-- 
2.43.0

