Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C49286D60
	for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 23:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758757116; cv=none; b=SkgYtolLSdu7vvpZku7v97RDJ1gBpsFA0RnWODDU4B8AasRgxRwM5bY1U2UxdVdVKx9ahhn6NNVIU3HOQk+fSuQNTVf555ANLvR+uK+WMYZ343YNOe12wmi9YeMP4Z7tFjbn7QpxPwNQMZk3orPWx3KRyr8ogLfA0L9Zbp5gAQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758757116; c=relaxed/simple;
	bh=h/M+YE7D6HI61MSGhGzdJ4IOvTB8zDpewv4W5jZaG58=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=QHjOvpvcrQ/Fc8XojBcZZwtHLetdQCW1JVMk9aqYuugDGI/nI9cHVJzNrvbMl6QF8V0pPbmh90ov3hXfmtfj3MZu4Py6bsQpQfx8gxKiUtcPDby8lSOQVd8X3Hmgdpqvn4G1DVwXvP3xTlHWlaKL24WtnFwkXSK4ntzH/s1pwOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NigyeFxQ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NigyeFxQ"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OD7EHr025136
	for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 23:38:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=0TF3HRPmEBLSIpIUz7r21D
	zVHSr1wz9ZwCuRBZA9gfk=; b=NigyeFxQRTSTldguITL38UgLud76gdEw0wfHEf
	fhqR3zYC5T1ILmMYV0Z2JtBU5/KGdOdXvdr1ujeeHrh1cxkAtwnG9XayJFtPCPtn
	MuubaxZaaWF1FbwHgR1VJmnD05HlkFZEnc1Xqg/3dNoHKT3KyDtMhzcGMxYdRw3a
	Q09SXRHgQ8l1gcIfkA92a4QmYQ81tTI8hrsZalQCXc4uULUM4w0A0g+Q7RPvdJOC
	Vg07SaGKEcMP9zHMSjxCILKQ8pA3C70QaYK1t8PkBhZmGjqexodQfp++wOoWhdOD
	MCoYfV42NB/3mwEAmZhIT3bVJiZka3PmFYL644XlPkyp1org==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 499kv16304-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 23:38:33 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b5516e33800so409528a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 16:38:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758757112; x=1759361912;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0TF3HRPmEBLSIpIUz7r21DzVHSr1wz9ZwCuRBZA9gfk=;
        b=X9oq8NaxT3J196dRbQ22UyNyZHUUlpSquTAfzZPGdELkhl9s7PyGEg0WmJZAdXWEFk
         MHzsmCQn10iXDWGDW1P3+lcWpQVauTtfRYmeIi1IOKmxRF553WrrOP106WJqbacPqIcr
         iba82Jp6P9kj8z3JQxYBvwdCMMw1boTSLymKF1vbSBwTW7hMCgUWMpd/Tai4Lcz9Dswq
         MrcnW98YCzf7FUQyVggS4u40CNHMJqG8L0FFP0SdnzjSGu2B4SekbvMTAxxOOGk36duS
         7LimGQ5Mwse5qS7/PKx+ERnyBAPlc3aSPHIezitpFQgA4eOOJ+secw6Iy6HSxsBViVL7
         wWgA==
X-Forwarded-Encrypted: i=1; AJvYcCX1J8OE6rkOy3RemhLv1GEO201MrI+4sQbOjgcP51nBy9khcVkPuLC/Ymb0cqfk4ERcuj3QiTnK8HW1iNg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYACrV8vWiqBDF4fSNIFeGdt/eroQX4NAKH9P1/ueVI/ts+Gtq
	NbBd/tHbwB9uqCWT2KDjRP1k16W7Y0LjJuIKwS/J8etzHDS87lq/tR42xcuxmPEZL9OLB//07Yh
	+cCW5baok7Ypg+v45ZjpuqpA0c5HEgSnbJTc58hzLXNrIeBMBkX4i1WuXzwWjEVoOaUU=
X-Gm-Gg: ASbGncvtUAEggR2gTy4Cs49vPyrF2i+8oLFVA87YTsgY3l0P0e/tAujkbLKt+NDAAVp
	2U9BiLBLNDughDnr0ZFaED2HsmmQ/EWDaughrJUPSUb0Vx17T2HciqkkSV1/Z0l91t7WZx3yg9e
	gIDC2SgLXuA942JAZwE1NdUdu9dDg/mtuaVD2S76/lQnVG+s8yyfznqMy3+eCeHlhhEDrtF6RtO
	vKXH7DWjSxZicOlRkBWuuHeW4pSVvA5SH3Ar2RdAx7spww0FBe/H2biVEq33Xiofj03Q1Y0j/wO
	816jhMtEm+W6gXsYymrfWpaOPAOuUNbFu6lYE+NuTGHNwoxSuX17AW7pB5MV6Yc905jSGrPE7eI
	jxeRDq9QaRe/0+8s=
X-Received: by 2002:a05:6a20:938e:b0:252:525c:2c2c with SMTP id adf61e73a8af0-2e7c7500160mr1824690637.14.1758757112402;
        Wed, 24 Sep 2025 16:38:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG27SNNEo7XFBRYDt8iP2aB3NjvPMLv0tyORjPFSP5krdWqSm9v+h+GvSXA7/UKhqgsODYJaw==
X-Received: by 2002:a05:6a20:938e:b0:252:525c:2c2c with SMTP id adf61e73a8af0-2e7c7500160mr1824656637.14.1758757111696;
        Wed, 24 Sep 2025 16:38:31 -0700 (PDT)
Received: from hu-jingyw-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78102c0709csm177056b3a.81.2025.09.24.16.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 16:38:31 -0700 (PDT)
From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Subject: [PATCH 0/3] Add Crypto support for Kaanapali SoC
Date: Wed, 24 Sep 2025 16:38:26 -0700
Message-Id: <20250924-knp-crypto-v1-0-49af17a231b7@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPKA1GgC/x3MQQqDMBBA0avIrB1IImLtVYqLJI51KMYwI9Ii3
 t3Y5Vv8f4CSMCk8qwOEdlZeU4GtK4izT29CHovBGdea3nb4SRmj/PK2ouko2ObRhCk6KEEWmvj
 7n72G4uCVMIhPcb4Xi9eNBM7zAuTggIV1AAAA
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>, aiqun.yu@oss.qualcomm.com,
        tingwei.zhang@oss.qualcomm.com, trilok.soni@oss.qualcomm.com,
        yijie.yang@oss.qualcomm.com,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>
X-Mailer: b4 0.15-dev-99b12
X-Developer-Signature: v=1; a=ed25519-sha256; t=1758757110; l=817;
 i=jingyi.wang@oss.qualcomm.com; s=20250911; h=from:subject:message-id;
 bh=h/M+YE7D6HI61MSGhGzdJ4IOvTB8zDpewv4W5jZaG58=;
 b=k+uJbL7n+ABJU0CdxxToAbgHkIkpiy7+s0NQex/HEk2EqUTeK0YRJRnpIER4U11Tu2BsNzTqf
 qPSJZ14jp0BBgwDp5BbSr3LVUgA5Xz6dsX3XYm3ER890/eeg0J7ndyY
X-Developer-Key: i=jingyi.wang@oss.qualcomm.com; a=ed25519;
 pk=PSoHZ6KbUss3IW8FPRVMHMK0Jkkr/jV347mBYJO3iLo=
X-Proofpoint-GUID: 0-yXXPdFDcb-cunnyPqjExNrrk465ogL
X-Authority-Analysis: v=2.4 cv=RO2zH5i+ c=1 sm=1 tr=0 ts=68d480f9 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=EUspDBNiAAAA:8 a=7VnHweOnuvEr4eq_jGUA:9
 a=QEXdDO2ut3YA:10 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAyNSBTYWx0ZWRfX8YxYFmqcobpR
 lr1HL3ej9WHnydQp9SatZZTkCrZ4rxEQn7zo/Afwf6VK5FlhFJ210yin0HSSvPwbnDJjgskDIGv
 Cs/1z2kD4rmBYGS34SXMoUIghzDjRDL1tU9fe6+LPhmnlFAuN6gGr6fmneap16IbX85Q2itvIFH
 bdJz3dtrQwtYuJW3pxwljuakIfOtEZCKhafbl+cwheQOlN6kAWgViKLatF36lYxi9IgU61dIG22
 Gx/Onq7Z0mRHHaKwTgXRzunR20b9CoNl6LBevwuQUHjr1SvjZJq52GnyaxMQZSkE+e0eFFN6HzN
 IemcL9JYGuIcBAbsnZWKT+tSUMin/i/ztRwHsBVZgK8qCUp1YQAPuhw6uVcRRhPc3hiU/6DRL3t
 yfo11a0r
X-Proofpoint-ORIG-GUID: 0-yXXPdFDcb-cunnyPqjExNrrk465ogL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_07,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1011 suspectscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509200025

Add Crypto support for Qualcomm Kaanapali Platform including True Random
Number Generator and Qualcomm crypto engine.

Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
---
Gaurav Kashyap (3):
      dt-bindings: crypto: qcom,prng: Document kaanapali RNG
      dt-bindings: crypto: qcom-qce: Document the kaanapli crypto engine
      crypto: qce: add support for QCE major version 6

 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml  | 1 +
 drivers/crypto/qce/core.c                               | 3 +--
 3 files changed, 3 insertions(+), 2 deletions(-)
---
base-commit: ae2d20002576d2893ecaff25db3d7ef9190ac0b6
change-id: 20250917-knp-crypto-07eb1383bfc2

Best regards,
-- 
Jingyi Wang <jingyi.wang@oss.qualcomm.com>

