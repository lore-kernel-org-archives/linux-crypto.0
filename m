Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E18387348
	for <linux-crypto@vger.kernel.org>; Wed, 29 Apr 2026 08:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777450233; cv=none; b=gZTJa6lNK0A3HwNWOTItaq+fGJQomSrS2iR+xFFfCnFXz0sQXrZwnv8xZz2SxOh/p1Yi65aqkX2n1EJL9G87+r+Yz5Y0dCL2dN7cQsS/vVTKWmi0kHTA88YaWlVrdt1rBhpQvLygirIHt/GEVXvQvMePwqGTfzRES7tOLbNpj8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777450233; c=relaxed/simple;
	bh=ONwliSsILV/OrmkQojPFG5YHrHzHjk3tsmEhrJD5QGY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GqbaEW8uvND/sY0tEXkXRBCIbwU2Gp4YSh/61XQeeYcVz4L6XUQK+w/NGkTMYzW5/+Kpm4D8ujrstuV/nfkbdf5wQUtL+M8Vl0GHlksSY87MpEOp0KWWFRwXlaC/ZVm1r+TyDKwhDwWs0OyW+4RUIKwFc8HJfmt77gAyd5OI3HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kXSm9CXu; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=EiABHpI4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kXSm9CXu";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="EiABHpI4"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63T3Z9MI1015339
	for <linux-crypto@vger.kernel.org>; Wed, 29 Apr 2026 08:10:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=zNEtTRHhsLDEYA5rua7jC9rsbB43fhK56EO
	ZzSeN9mw=; b=kXSm9CXuhgPwtjORcz1uNgQJhQWMsBpmNKaO6szQUWUIHtG+ydn
	srtB+NQELFSYLbF6/YYuVfmId9mo4JvxeCt6PiZNLFd/tmChG7d0Hniq4LfhE6D1
	j3QYWHOvSiD6wzjWCAd8eZofpoU+5RfJ9jn3kJe/SNMX4Na79TilCLkWDr3Qwl7Z
	wni1zOB3tFqliEzUtnu7+Fb2uDxJqVi6FxrSijb8vQic/F3Yex6TqQk8FdqdIV7e
	F1mSUUEhCDIHz7jzzEjKEbGA+azoMJnyjlJKvtki1m+C0AQbOP9wabyJIX9vs7FN
	hKvHgN1lC2RvcIaqUrtRKJj27DQjSLjKkPA==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dua7310kd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 29 Apr 2026 08:10:31 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50ea1a7a5d0so230084691cf.3
        for <linux-crypto@vger.kernel.org>; Wed, 29 Apr 2026 01:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777450231; x=1778055031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zNEtTRHhsLDEYA5rua7jC9rsbB43fhK56EOZzSeN9mw=;
        b=EiABHpI4h96Q4WB8jz7N0Mg7ow7ebd1z5E0795/8Ki7cs9by0ZbvJw5jJfnW6uP35t
         OAJMf8k1dQpLIb9i6x3EEp8s57JDwHmP00NWpBqtPVMgegXp3IeBbTqzTMgvNWABj085
         Kvh+xRBjCFrCPPbOb4CXv0502/gjF35mpHWvVKwUaOsymuQ3cHw9ptuWGKwHbMn+nS1T
         KWfHnJFyHv0Jjer/ev74nu66//uRzVDIhMk9sRwthr8/j/DTgWoN6oD850UaVFoixybR
         l8hWiTHqUuG1XBx+sAYCJpeK00ptiIPuq99W2EOcQWIUlNcse65m2mnp1J6HpsJ6R5Rk
         bOjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777450231; x=1778055031;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zNEtTRHhsLDEYA5rua7jC9rsbB43fhK56EOZzSeN9mw=;
        b=co0+w7E/UbBdJUEVK6XrHkAwytN16+F/M/RUpkcy4LSHMw2qJCOsQxxSohPL9cSXM5
         pww9XT7Q+R3wnsByzL5W3qSBkjOYwPfcpjQX97YfHgoykdEB9w+YvqfAeDtoK93+hNTf
         TELOT4J+sss/tlzpFVp+cYJbVABGpbpvWvVQoayKbPZq4aBxM0Y169Bram2OipIL6iNZ
         LrMi/A8c5QytxC19A5iWOY1ufGvQwktjbkWQHktcYrZzmdAFwKGHC+YvHKDw1eBtIjsj
         nxPFiIknYH8TU3qBZjDUZ1CzPi4q+avgOKRW5a+0JMsFjrxaFHhJ4FiVPmcOC+q5kMTQ
         RYfw==
X-Gm-Message-State: AOJu0YyGX64CK6HqPP74VUrngtleBUO1bQqTREyqROkAUM/EnITF0xQA
	PEIb2HXWHKmgGdbobSA5EckFO0ixyTjVtY0KdMAReXXo4FDpKVHAu5swpb9uKubfqqb328AscQ9
	C2dagWDYuHakqIIjnkc6BZgSIEzJJbV4vzBQe1+kOCdbbXlgpqneX9pi/iW7zI4vcy7M=
X-Gm-Gg: AeBDietKvK2oPLMJuT5j3GDSGKJcGPgEM6/2WHoYsJrl/O3yrL9a31itLTrkuYcGS5z
	XBjhXa/wrO1L+AOJvRgM2GmIzbDpGrPh7ZxXsbshk8UvasaDnMCSgAPFwjiI+lLODhg5lekofPm
	y5KyudJuZVhRpR2d3S+V2nW7dQ60Obta8V97hLZe+EdTixyTVXwunvMMNxF46EDjFtyBZUPUN7r
	rIbgh6+zCEGWXuGOicq+ReFW3FicnXgJPR6RaG9InxNSeUEf9mMLbVlHjPJrV7l4H2H65x1D+ql
	qUnK8SQwcP97wsKBXu2VkhXfR+mOSDhb7n4sUV5Ck9WIkDhgdPx2mtuquR2VDST86/XntR25KUK
	Cs+mHBbH9tfCUBbSuuNZAsnqqfG3lng5IiRtfPKHpUlATI7aZ8hfmdAFtaH/E
X-Received: by 2002:a05:622a:1792:b0:50d:7f66:dca with SMTP id d75a77b69052e-5100e1ab2d1mr93763291cf.33.1777450230892;
        Wed, 29 Apr 2026 01:10:30 -0700 (PDT)
X-Received: by 2002:a05:622a:1792:b0:50d:7f66:dca with SMTP id d75a77b69052e-5100e1ab2d1mr93763061cf.33.1777450230479;
        Wed, 29 Apr 2026 01:10:30 -0700 (PDT)
Received: from brgl-qcom.home ([2a01:cb1d:dc:7e00:668a:d11c:cbb3:a94f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7c310048sm12779205e9.22.2026.04.29.01.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 01:10:29 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH] dt-bindings: crypto: qcom-qce: document the Nord crypto engine
Date: Wed, 29 Apr 2026 10:10:20 +0200
Message-ID: <20260429081021.16380-1-bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=XtvK/1F9 c=1 sm=1 tr=0 ts=69f1bcf7 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8 a=4UlrLoyY81mkaXUxjREA:9
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI5MDA4MCBTYWx0ZWRfX3xlSh5gwj0dJ
 Mqb/e8jVoRqEBxgQtt7OFUNzdylTztbdsxrNHYLtA6yU2dLdn1QcePmX+NlU3HrIGAC35fqrPQR
 57ICS2bpOado4hv2gZG988B57wzF81kMJJ/sERXc73nj/1b24OseTMtUJNcvFJSaSs7BryPwyzF
 aM4oYtQrSpPiikQBP23waO+yVflfMzyqyj/gz7q7/JoiLw7U1dKIU3dK6O7/d63XtEyRMLTY5Om
 1j/aha2471eOUvujEVjeHQc5s97HbP1UbCqgrQ+LW6CQIx3L9xz7ybQ4JxHkxRZxHJ++FJmyl+C
 MXJhayWQOCg7d9fsRd1BHDIjyYSfh888EUicTt3tCGK0B8lMDFFoATzk1QQFLEwNR3+MFvH/dKj
 H1q9soOpvCPZKQ1Ye4Qhdsa6yllQnIRNzh2GINMI4OLW6EVlJ3XKn8vRYTCG6ZvvdTnIdXYrAHj
 RuEOUxla+EtLuxmtsgg==
X-Proofpoint-GUID: zmPV7005hTZjly0ocEQL_U9fD-BDWjfh
X-Proofpoint-ORIG-GUID: zmPV7005hTZjly0ocEQL_U9fD-BDWjfh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_05,2026-04-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0
 adultscore=0 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604290080

Document the crypto engine on the Qualcomm Nord Platform.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 79d5be2548bc5..d3af7706376fa 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -46,6 +46,7 @@ properties:
       - items:
           - enum:
               - qcom,kaanapali-qce
+              - qcom,nord-qce
               - qcom,qcs615-qce
               - qcom,qcs8300-qce
               - qcom,sa8775p-qce
-- 
2.47.3

