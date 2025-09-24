Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84FC2C236C
	for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 23:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758757119; cv=none; b=p+imoRMHez1/GKZMJWDPzCo1L06aAQgFVhUtN5qwPGGWFSGkEUCl4uBfCXlvkCNZEVC1rcP4DDMemtkoVQdD3I+Cj9Vahe3O7Fs05qa+levFJ3ZG0qJtcxLJXLmZYCRZwmhqLFVZKYZu0pt+9QsCJMq60VqhtpxZa3waR2ptN4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758757119; c=relaxed/simple;
	bh=F4znCHDFQQeryr3RxZUYIcYiRyQiALWXHxg8m2aMkAg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CIpJOYOAMUR11mFTwsi11JDKQe9LkFS/8OfBNZOSo6JhQAVnmz4v+dvv7QNSe0Df6lv5rtAzj3xvlmt8TM8Ee3J8vIUo0BG0Tmnq/pLiV5aST6cy1s6jJ5mZOAcAD8BKucNnzSpyYZGdhXy4RH8G6IF9FEUm0XzuQrQbuw8rJ/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EKlGrUgs; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EKlGrUgs"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OCgSAr027848
	for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 23:38:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	s1aAF5rSae6ugXFLKlzHjE8diZkKaXKz4SQv2iuHKzA=; b=EKlGrUgsuL2NYpqh
	SvYmz6GzHcrZ1hZUFZyooBpPwX+qabuwHGLHk7BD201WmuCHgGszrxYAs/aRkTij
	vXxVYgd97fG9dBPpwrBdJxyufWeCd0Ql2C391gOHUm5QjX/SyCExiz+zmgLey5EL
	wqJegkq6TZqLDVCEl2uz3beCuDOlz6xi2CLP0dmiFN4UQUjhH/i3kxG7hp2M/9wU
	4doL5vu7Uik8DpeN++LhSVMJOkj2zmx+R0ZCQp/xyfN0xeR9ias71GQvNVpd+N/A
	PADkNnqvOvD5mfBBpmQScsFZsyNSbAB69RiPzOAMLHJ9VE0OE88SRerbkDZxQK51
	Zy5WFA==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 499hmnxdes-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 23:38:36 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-77f29f473a2so286006b3a.1
        for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 16:38:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758757115; x=1759361915;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s1aAF5rSae6ugXFLKlzHjE8diZkKaXKz4SQv2iuHKzA=;
        b=OYF4bC5Tomv/0c4uT5MzjkbHO+/qE7p4u/LCmCeYLMAciIvfLeaU79+H0Ri6J5hYvc
         WXX/XFy9O7P70Tg/oe+iJnZLXuhNsz83UIx3leLC92m6WK8KlxrEOKqWJea5tfbTxuuK
         9sQQRCHvALgIdvzAwNt0wnLX4cUAsmO3bOrC3v1u2ltAND4xPKxt2LIbHV237cMl6xZu
         npNRCLpLWXEZo5XAEVc1Emon+a5MC6ZxUEruka/InaeEYHpgXopRLw7O+q2H6so5o1i3
         5yTikiyKUSY4q42hnPlFBVPV5K5q9riK3laY72NFixGKzPs35AyCpfyeOAw5yC9o9X60
         VHCw==
X-Forwarded-Encrypted: i=1; AJvYcCWnd4SYsgPEk+is5dvZ3Y+QFc3B+RfysjGtI00scKWHbciAwUxdp19TXTF2KL1I3qDfjyJBj5FRiiD8fKk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwL2groGmrkP6SJbP1kHsAog40DgxkHBlIcJQZe4qMBL3I9E7Bb
	kdPwOx3+k7QYHddJ30Dbn552i9EDIo0CaxEQff79zfeAIb+Kt9Jj9URWHkJQi/BkJv1cpB3EuHZ
	Qy42i4ccK5izUPoTFJ1EQaI+8BfXDdWJLxR24nj8YFC4bgCAlpedh8dndNqOdU6QHi4I=
X-Gm-Gg: ASbGncvbk8ugeVayCuJLKdnofAuxlrIpJ9Ue/ASHcCClie8I1vgRy9Bx/qKGig38M9a
	j82BA6eFmVRdy0eUUguw7+MP+FRhC+Udzxelqvy0bkrQgCB29Dl65pvSYeR7OdhCwwQHYaccN5u
	Jd0wX/Uwp+S5u6oqhnepjlUVaSJjDxa0ow1STNHU+/Mc6JvUiaI0KJ73+vU6Rl1NxBovcyIgZ+L
	SYe8lp/0eK8dE3BPmO6i2l+3ZH+poKJiNtyblEJ48SJdp7qYVINWKTcTAOEOUKo6XXBuoheUtM/
	rp8KKZuCIM0rmEJB7zuH4EKzUqQ6iJJ3Fmq9WPXvdpIa9ZYsBEZi9fTOqwHIGJVFoHU7ZyjRL+u
	SMUSihRRV304XGIk=
X-Received: by 2002:a05:6a00:189a:b0:774:1be4:dced with SMTP id d2e1a72fcca58-780fce3b007mr1898906b3a.9.1758757115284;
        Wed, 24 Sep 2025 16:38:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEnsto4a+iHjLgM5EoL764lndboVFQuG4IWUK0ulnCQHO170g5R+E0rOP+YBHKKmKYAzn5PBQ==
X-Received: by 2002:a05:6a00:189a:b0:774:1be4:dced with SMTP id d2e1a72fcca58-780fce3b007mr1898871b3a.9.1758757114853;
        Wed, 24 Sep 2025 16:38:34 -0700 (PDT)
Received: from hu-jingyw-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78102c0709csm177056b3a.81.2025.09.24.16.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 16:38:34 -0700 (PDT)
From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Date: Wed, 24 Sep 2025 16:38:28 -0700
Subject: [PATCH 2/3] dt-bindings: crypto: qcom-qce: Document the kaanapli
 crypto engine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250924-knp-crypto-v1-2-49af17a231b7@oss.qualcomm.com>
References: <20250924-knp-crypto-v1-0-49af17a231b7@oss.qualcomm.com>
In-Reply-To: <20250924-knp-crypto-v1-0-49af17a231b7@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1758757110; l=802;
 i=jingyi.wang@oss.qualcomm.com; s=20250911; h=from:subject:message-id;
 bh=Hs3MTutgTJMawPo10U1qCQaD7MHAVehm01p62n0kfL8=;
 b=1gRerEIHxFVQS8l19SgcIoNEiqA21x8U0jVM6V4Io83OoBFbdquBSV9NqGkCzEXQSZeAoF6Rc
 zJY2EBu2MVeBvIT9IUqQDrFZuvdNtqq22VoIwgQi+q7PZP5lueXI401
X-Developer-Key: i=jingyi.wang@oss.qualcomm.com; a=ed25519;
 pk=PSoHZ6KbUss3IW8FPRVMHMK0Jkkr/jV347mBYJO3iLo=
X-Authority-Analysis: v=2.4 cv=YPqfyQGx c=1 sm=1 tr=0 ts=68d480fc cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=EUspDBNiAAAA:8 a=UTvf6Pk5Os8-KCCN1KUA:9
 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-ORIG-GUID: hfBpzfYbKbrTpBxOLMTJRMBdJF0g5YW8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAwMCBTYWx0ZWRfX/Mf9uwUaNQHk
 tKE0uAIImVkO5hSGY5Gu27jfvYFZpKvM5T0/uBPG7EBGKZmOai9HMgGV5aS8aUkgjZXonjO2wpk
 9DYNwlK8xIgYMEMxsuoJOKazZ2aIAi97bO8DyFDByJYgzAb+Xdz2of7eC/9AypD7UU8To3slcFK
 EyyvDmgSpcLqJhRM7seiHoOCo3GPCq8VsSRel+O8uyNJ0NeujOfbjYZ/f6WlJaYyVERkjgY4S7u
 gkH5KbGPBoiqJKmuOtikxtb+aAdnfVraOd4eK9JltLtBxJlsYhiJlhNrpxrlIkoWGbpW9G/cH6y
 0bt4oRg+TTAhI8eF1MZ7W1D88GaF+KE1OYASPkpLPQxGqqKHQnF56pBsXzz/eMigs8tgZpfD8zo
 2KOJgkSz
X-Proofpoint-GUID: hfBpzfYbKbrTpBxOLMTJRMBdJF0g5YW8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_07,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 priorityscore=1501 phishscore=0 adultscore=0
 clxscore=1011 impostorscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509200000

From: Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>

Document the crypto engine on the kaanapali platform.

Signed-off-by: Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>
Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index e009cb712fb8..79d5be2548bc 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -45,6 +45,7 @@ properties:
 
       - items:
           - enum:
+              - qcom,kaanapali-qce
               - qcom,qcs615-qce
               - qcom,qcs8300-qce
               - qcom,sa8775p-qce

-- 
2.25.1

