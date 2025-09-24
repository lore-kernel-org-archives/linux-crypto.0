Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEA6298CDE
	for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 23:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758756585; cv=none; b=RbOxr/uHFOh6UfKUhRZsXvLJ+PiQBSJTXolE8vG7sH49H9amyxM2pL+Mdl14HuPaoZB6V3gx9zAefzykvfH8Chi3zfCaVYmsY2uupBhFOytem1pRT9usxWlFeOVKse/jb20PfFFrZPcfL0gPyZIBVnrj4NQ3n3CGDKFq/Bg+8y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758756585; c=relaxed/simple;
	bh=dLpFJCc/EEtwx7OwrUHxHCyDeIPr/4d2ASLJ9yfgGns=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=JUDm6AojTHm8BfhCXrbDN7fpsPdBmXS1DMChbEQynMbjkC/gA1kgYFYSQMZFHLz/vVlwacu1cxlZ5/YDwJLunzuLaOch3YwfTPyNz5SQMgG1mPtWI2cA+pvmNhKR0/YI9zcGSB9hjxnpYh0C1ggdvObFSYvJC8qSm7YLr+lRksc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UH82nX02; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UH82nX02"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OChZdY021646
	for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 23:29:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=DGk3gce8u7DliPm26Wasvh
	YNfNvU9JbJprdvIKtLVSU=; b=UH82nX02GR51xCYveDIirw/EaiOK5IzZdrkdjC
	RODv7dIPxaqluQ8RIu20ID2yYeJKIBYT0toki2u1/SmiHnz0ingnWAapKyerCnaI
	9CWATVSGal/QCeesOi9dc5MYqn3i64LskrN6l0tW2hiYps0ls2TX6Wg7h9BLxl/o
	strF6ND24+DvmQKa8g5U0pVv22f3xwKG85erJ1G7MOVGreHlAIcxe/z7JxsvNELe
	Gbh5CKgb0Mz3LrPOQU99AcyqgAMwPZsseRqONPipIYgAGTqGUg97a8nLn+bm2rNk
	Ag4M8IBn2ALM5GQDQDKS+ksEpSvwXTNhqcTK08OdiP+Wl2kA==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49budadkan-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 23:29:42 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-77ec1f25fedso579507b3a.0
        for <linux-crypto@vger.kernel.org>; Wed, 24 Sep 2025 16:29:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758756581; x=1759361381;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DGk3gce8u7DliPm26WasvhYNfNvU9JbJprdvIKtLVSU=;
        b=wuZjtkcNsiH5PKiGreq5ZYt9AzKHTRm0Z49X2zuTejs7J4ppJfIF0Zkcj8baGRaCzM
         rTxkc0Sg0IzS966rvXArEEQMs0vOGc2gfg6Mx/mxU3LAFLWDUqh4orx0+39hy3NWDLPR
         QpPoqW9d4GH7tO68aeu+zw4Mdy4g8O1g4PxqFnEZMOkVMA+JP3Jz+YAl9vXCwM9k6Zxs
         vEHC+SlHUDSHKm4cFRGmrjD78kxNVMrocCffy4hDGB9vxJULQxoTyNit3eU6Ejq5LRij
         AxTK/y7eQ7v5gVUswesPMgbIZYcWKug0QyzGNlOa+Yv/bHVuvGdDlfEC6YWYJ0EnLN3X
         B/iw==
X-Forwarded-Encrypted: i=1; AJvYcCX6MsM+/NsMI/5Q0fGVVDPyT9RAWBTdrek/zoQ2ZQbOTPfJvZtWMTkBuwgDjWx9fpGRFMNJgXS1V8eDzOk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWleTzxdTEkz9tTwULHzW/TwPYRUrUdE4OJorkbcSjq/ZtjTCG
	W0E/dPin2r+RAWmJRiuheB2u8HmDY9Xas08Ng8ce1LgjqoHGhfuNTUrwKyVyqR/YcNoava9h/ov
	djyVjF4P7uIeofjyOMTNlfuBfErDV/UOVAOzep/oJ1AUEh47gDnh8KHrwvnr9z9ulCKU=
X-Gm-Gg: ASbGnctraQ6lSnf7/8PjWCRGv5Zsg9z4ZnE+2vX5K3S7c5n/k1A5xvtDnFQaHcwO7u2
	5zYvy3I5mlyKSPBnd/P1sPlTeTKBKO25IZ5oyRzWvLnH2aJSmDvmMRHzo4WaJB4HAkToUcYOgAB
	kNPXuW6SmVlySUQNhLRCyG37yOGzEM+Yx96OsFmAKQ5NT9poqX+iG3VwIosK3wZQoz4rWmpqBcN
	PWLTrocXw4qQj6QSkLuZcApJnzStA7Br0JA+dePYSHxDODa3D1+hcfm6TbrQxS9PoFlg1ZmJRnv
	YysmpPNUzGvYxS+iDcMczNHFZAEzY817VLJUXjzUY2+ky1CdfbDQycAnGU/78U2HuclUyu5WaTl
	oD7mWueQq3t48Dqk=
X-Received: by 2002:a05:6a20:2447:b0:246:9192:2781 with SMTP id adf61e73a8af0-2e7d4373aefmr1558901637.47.1758756581568;
        Wed, 24 Sep 2025 16:29:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpJNtcS7y5GrDtPluqMk7tYcVWSS0EuXlQeW5IDR4Al68QrYkUCbw3Lmm1SotjNNcn8KS12w==
X-Received: by 2002:a05:6a20:2447:b0:246:9192:2781 with SMTP id adf61e73a8af0-2e7d4373aefmr1558891637.47.1758756581203;
        Wed, 24 Sep 2025 16:29:41 -0700 (PDT)
Received: from hu-jingyw-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78102c0739esm161256b3a.89.2025.09.24.16.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 16:29:40 -0700 (PDT)
From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Date: Wed, 24 Sep 2025 16:29:37 -0700
Subject: [PATCH] dt-bindings: crypto: qcom,inline-crypto-engine: Document
 the kaanapali ICE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250924-knp-ice-v1-1-1adfc2d9e83c@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAOB+1GgC/x3MywqDQAyF4VeRrA3oONXqq0gXc4kaSqeSSBHEd
 3fs8oP/nAOUhElhKA4Q+rHyN2XUZQFhcWkm5JgNpjKPqq87fKcVORA2fWzt01gfbIRcr0IT7/+
 n8ZXtnRJ6cSks9/7jdCOB87wApIT8s3IAAAA=
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        aiqun.yu@oss.qualcomm.com, tingwei.zhang@oss.qualcomm.com,
        trilok.soni@oss.qualcomm.com, yijie.yang@oss.qualcomm.com,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>
X-Mailer: b4 0.15-dev-99b12
X-Developer-Signature: v=1; a=ed25519-sha256; t=1758756580; l=1112;
 i=jingyi.wang@oss.qualcomm.com; s=20250911; h=from:subject:message-id;
 bh=M1JXe8NMDOcWKx9zu6HsUxOcABoSUntEFha+tvfKClE=;
 b=wWNsJ4nmhR8+IacSFrzATBl6fH0HEhwfBTUDN7LN2UU38R5MumXxhP3I9+2nUcVRtfAJnTkIT
 4VQPy9VlreMDqEKQRuDoFAZPCyz7QuqTOBvR8XJe81S4wp+amwdgowS
X-Developer-Key: i=jingyi.wang@oss.qualcomm.com; a=ed25519;
 pk=PSoHZ6KbUss3IW8FPRVMHMK0Jkkr/jV347mBYJO3iLo=
X-Proofpoint-GUID: 5K5qJw4Jb5XlTtUSjwW6S9ok3PaYwXIc
X-Proofpoint-ORIG-GUID: 5K5qJw4Jb5XlTtUSjwW6S9ok3PaYwXIc
X-Authority-Analysis: v=2.4 cv=Yaq95xRf c=1 sm=1 tr=0 ts=68d47ee6 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=EUspDBNiAAAA:8 a=_7QqrcqI5ktG73ApMXIA:9
 a=QEXdDO2ut3YA:10 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIzMDExMyBTYWx0ZWRfX/TfVtr8nKLa6
 ITvnJlJqPNLOUoruAV5sRJxhN9TP+oNPcxY5xnN8LGIWXbcQj5uO5BjhvCgvM3xqjCNj7rwH26E
 6mnrUsO6BEqyt0/4S0Y+T4TJ0MZFJ1N/ZA/tj6SZWM8MHTT+d9p8DxNqflEKtKyq4cQEa5FlRGU
 oMYiYTG8A67WZ4UUT5SxU8dKMmENZCoykxPF0uYg3gvWae6vm5aIIQdtjdl+9tbvlAGfDr6lXX3
 ih2d7kIk/kn9qsQvg9x8sV26u9ap1N/pPF+07YQBf25/2UJNlXWkOa9nCTYZ+hmOsqDGT4XrtiL
 k3GHfcLSKRAouRHVdrlcvrbmksBJc6fWS07SDg542QN/2K5jtrs3LE5XOFdOG4WWA4QBlnVd+Pa
 VJ3zRDuG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_07,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1011 suspectscore=0 priorityscore=1501 phishscore=0
 adultscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509230113

From: Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>

Document the Inline Crypto Engine (ICE) on the kaanapali platform.

Signed-off-by: Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>
Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 08fe6a707a37..c3408dcf5d20 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -13,6 +13,7 @@ properties:
   compatible:
     items:
       - enum:
+          - qcom,kaanapali-inline-crypto-engine
           - qcom,qcs8300-inline-crypto-engine
           - qcom,sa8775p-inline-crypto-engine
           - qcom,sc7180-inline-crypto-engine

---
base-commit: ae2d20002576d2893ecaff25db3d7ef9190ac0b6
change-id: 20250917-knp-ice-39d64824bc4d

Best regards,
-- 
Jingyi Wang <jingyi.wang@oss.qualcomm.com>

