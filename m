Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794406654;
	b=qpXgnymhiuJRZbdC9AO4rNrdXM9ukvOwKmYxtz9rm2f3ymal3SE+QUdbGo/w0/wcf033
	 YHjz1W4HIAtuvZLrqA3iFWqfDoYwHwdFfxe7uyQbFKG9hTF9nMWO39iirbpJbiTXGYLzG
	 VoO4d1sLQFkEC2mdcToj8yseLeSJx53A3T/RxC+Caz1SZyy8Dw+kQjSRbqR3ghMXXdNV9
	 R1WusYAtCw+LLI/JzLmixYv7YekAOPp1TpVzzgA9Sv57DSa+P/Wyr7M+F/2kuUeFgC3Ek
	 g1xOOq13yWnqywMnZWvU6hjWXljMCTnZ39fZmdOl3NilExoluf5hkOhdWxp5tT0SUBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794406654;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=abnYs5U4L9bKrmw3WJVtrxPRARSoubCvJFVtGzfloC0=;
	b=tYhg1fM93JD9nck7w225a/EmYtsSbM+AJNSwitPgtVu/yblIWVmB0ZwQErWD6gMVXCdL
	 ULcvv/QWf8r6FeTK0FXx3iRyB3Bd/vBPX2g3f0bkKPoIdP50qVgCenI7jixlWJmGaXkUO
	 i0SwTFldtxOv43/hBX/qzeZVh4ntFnFLhwDhG32zdQwsRIIvzqe6tEcdpqza6drSEY4xd
	 jmHPLgN3No8SBiWtR+ZpxzYNDzRj+qS9QeqXmKQ7RsI2BkHDbPtuptTS6CC0hMU9xLUoU
	 KepDyWsY4r817pjt+LK32vPy7agDYYQ1Yy22siLWTd8+8zucq2gUSKgl7figG5iwcJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Q1wu5TCM;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UBfrJE19;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3998606A335
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:17:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3998606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Q1wu5TCM;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UBfrJE19
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABCZ2xl2001453
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:17:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	abnYs5U4L9bKrmw3WJVtrxPRARSoubCvJFVtGzfloC0=; b=Q1wu5TCM1g5WkJp2
	KJene2q4aWFyBkiTGgzMpVCZUUPFxk26z8Qc0+Vc31DdYDEtGYpSMQbm5gq58S3J
	L1ncYOKKOAzHeOa6/9aWzNbnRIXRwIpYrGT49FXR++9LhqllIs4Qqc4YMMuZKSll
	8HwuXjYIdkHkHbh1qk78TTjlp07epU37PD74ohErEhOYwV+bcPmgkB7hRFubWvx5
	NDn6g1yevlEF2RFiugMuz3oTfvJoOzWndShm2gsvkt22Uu8fbXgq+ckgOubnIvWR
	7AecN4DVZzKjcACtM6bzCLS5+bRBZsdF5xinTfPR+CQmpQ5B49CbS49WRl30cL6X
	F23o4Q==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hvdrh30m0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:17:32 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso6270165eec.1
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 06:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794406651; x=1795011451; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=abnYs5U4L9bKrmw3WJVtrxPRARSoubCvJFVtGzfloC0=;
        b=UBfrJE19stojvXAU7YUeRhPKeFIAXDFWdCs9R3G1XwCSWin5oJZPMeCCmgUNVz+Vx6
         c4s4q/YEDOivhxAOTeT/sv116bcs7x9FC4pjCrTtiDsYipiQFZEt3ry+LmZ5AlSqqxqE
         JOPO6tCXZqCFFVUbaD8+CMLPMUZ/SBgGk5HuET60dfR9Kq0tg9uCO52fm/LKewFWAxep
         99Lk0Lm73PH4VqoKYjDDRCe2QoTtukz0aLkquqM7Q5znH8X3CFNha8CVerVh5uZLWfBv
         /njCCGxKuTn4QLjt6E3YDDoRqIBbcZqT5dC1qhaId24/1eaTB8U3uJ0b9iLycqqFdp5F
         3zGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794406651; x=1795011451;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=abnYs5U4L9bKrmw3WJVtrxPRARSoubCvJFVtGzfloC0=;
        b=vAIa25r9tS1UJ44e2bk8oJq9KdtrG/CqxwFx5Z2wJZN9DCswE2TLkSEQC/+DTiSHu1
         h3Y/6ii8Mp3la4ea1yyVUYdMrGV+4XumbowtELtJNDCrQ2Q3DNQ7V/aULgPp2fE4F9im
         tz1gxaWc2Q2/reR7eUM7h+AYgkBdycwllAo5b1s7j+/uwxTCsHj1H/tIFvJClJATV3Gq
         /58tFD/I8oaWdATJ22neVPI47h0IRRFA2qm8PZrdaZZ9ayBisYVJTukD84wOZv6rraPT
         mqvhRo7wHSx2ULrOjtNTwabI6DCBrjn7Ucm/QI4ub3UKZntGkl4Wx+pG+BSeUCFlvKrB
         lGQw==
X-Forwarded-Encrypted: i=1; AL+hErHsMlptzS9fanw0Lll9uLUtvXwZYbEHmq61I4RjfcAKgAk9GbV3otKh4ZvAT+kScB5IMj0Lx/G0F0Kcv0w=@vger.kernel.org
X-Gm-Message-State: APuU4Z+BqMLsM7sHPuUQ36ufeTLTchdF6fAKmns8XSl5Pzfkfw+q3jP2
	B3vU5CMOVDTBYrF8L2HNDQ8TypD7FcqSSG0X679oZY/tCt5ZVvS02pMEssSaEB3uRqjRHiwxv7y
	LF0aoDA2eBx70/xg1kevfnHNvZJlSwWrCz1bqh+v1JhQM8rbIqqyDKFmAOIqp6q89lEM=
X-Gm-Gg: AYBFou2ioDuFpcdEe3NlSKrZxuHCg8ZHrxen0V3nIuWPCXdCiENYcu71HTM+C+nsuS+
	DkWtE5IX8R8WXyn5YkkKUqEec2RzZ5F9XSkWP02qvuF2OlhW/OEG0Pk0Vu6ZOwsWy/+Fb32WlWE
	8Uo/EHfID7VOe9Ywjx5krvAhzovLeIzmCDPxiYfmITLSWApiTzypHskGN56LN6EQtepCuZuKqmd
	8Cj70mCpaVNH9eKK91wQQSKjEEo/qOs2YiU+BDTYetUAFZl0ri2SP5uneWxlTbhDqPuF0GbqdEw
	LitK92TFimXTEzdUBpQf57t+d2BHCCWv5UMRmVGvMXFeIUf5MeSL8w9G/dKvHivI9hLRh3w0fxS
	YRlwTle731nFtBfnAKxdTfxWxkMcrQtOBvQokp1G196cZAKHrAaBH+tSnogFp935MUVfxAGFLiA
	==
X-Received: by 2002:a05:7022:ef0c:b0:1b2:611a:89fd with SMTP id a92af1059eb24-1b3c0376c9emr2495633c88.45.1794406650783;
        Wed, 11 Nov 2026 06:17:30 -0800 (PST)
X-Received: by 2002:a05:7022:ef0c:b0:1b2:611a:89fd with SMTP id a92af1059eb24-1b3c0376c9emr2495603c88.45.1794406650160;
        Wed, 11 Nov 2026 06:17:30 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b2fc09sm33747063c88.10.2026.11.11.06.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 06:17:29 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Wed, 11 Nov 2026 19:47:02 +0530
Subject: [PATCH v2 2/6] firmware: qcom_scm: Transition to ICE TZ agnostic
 operations
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-ice-migrate-tee-svc-v2-2-29d19f6c92ab@oss.qualcomm.com>
References: <20261111-ice-migrate-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com>
In-Reply-To: <20261111-ice-migrate-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com>
To: Eric Biggers <ebiggers@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Selvam Sathappan Periakaruppan <selvam.periakaruppan@oss.qualcomm.com>
Cc: Basant Kumar <basantk@qti.qualcomm.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794406634; l=10991;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=Pmb4MUn+uTR/v5tX3hXQMwdOTSqTP0Nj2WhJpwlwLmw=;
 b=zUWpKqbL5xLNfyVDZAOfcWbF5TnXjKWawJtSfb+GANBALuNeqZjC/8RiYq6IFP46w0FC1EW/h
 wdSksf2sOZ4ByMjJ4yemeiOvrDwWlG7gCN6k6dZk5+Dk6xgHaRXAyQy
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA1NiBTYWx0ZWRfXz9XlpXydxqjQ
 I/bv5MxPO562Uwn+PuhIP8ZwS2g4Z4iRE2b3Loy6mWAqyprtzrBLQLVtDdQlDzKghGgoYDcV359
 mmhp6hUn9tDNAHUrYQ5OpInTWJl7xgU=
X-Authority-Analysis: v=2.4 cv=PoQG/AM3 c=1 sm=1 tr=0 ts=6af478fc cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=XqWMBioEo9w5ZlPikzoA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: jZR-F5pa6fwxxsvG9B-tp-rHuZYHjX6u
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA1NiBTYWx0ZWRfXzF/rvL0N1cvS
 N4Es6q9xKsNbftbgZm4tSfc/bKsyDSj6OFLzsomzhqu22N78R/QPKOD4Y05B/M9aeItSgYZBt9C
 Lu2CR4Tq5G3m14V9Aunf9CIJvlhl5imST42cRF5rM2YT8W1CzB7yEqoJ4yfb/XZoQZ+vJDCS0jm
 pU2/eB9MAKMwsgNi0kcu8kAW36Vukp30QxWct2CXIIfOOEoX911153eCteqrLZ1rOEz6xbTct6g
 JSyL6eL8vaBCjV3BhnJuZY40vGRFwi/Wl/rEnyY45b3QLcVw9F6fFLSKpN94PCEwMUQNLbDq6kg
 EIfSdHLbPJX1k4GmHG9ZPVZxTJKMJLJCM94KreQujY0ilMzqZt3QKaMwykzT3GrYQTSpPBvv6P1
 UjMNQR0Xi1EzY1K+7tzIY/4yQKVBBELCAKCnuPnStItjqIzNxb/7WjXM6/vpDEupobLbXn/EwMY
 dgtDqrmhRFYfDDkTMEA==
X-Proofpoint-ORIG-GUID: jZR-F5pa6fwxxsvG9B-tp-rHuZYHjX6u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-11_02,2026-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611110056

Transition the ICE related SCM calls to the generic ICE TZ operations by
registering them with the ICE driver and wrapping them in exported APIs
with the same signature.

This prepares the ICE driver for eventual migration to the TZ agnostic
secure programming interfaces once the TEE bus based back-end becomes
available.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 drivers/firmware/qcom/qcom_scm.c | 131 +++++++++++++++++++++++++++++++--------
 1 file changed, 106 insertions(+), 25 deletions(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 43e250faea75..6b66bcedc84f 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -32,6 +32,8 @@
 #include <linux/sizes.h>
 #include <linux/types.h>
 
+#include <soc/qcom/ice.h>
+
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 
 #include "qcom_pas.h"
@@ -1397,6 +1399,14 @@ int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_client id, u32 offset, u32 size)
 }
 EXPORT_SYMBOL_GPL(qcom_scm_ocmem_unlock);
 
+bool __qcom_scm_ice_available(struct device *dev)
+{
+	return __qcom_scm_is_call_available(dev, QCOM_SCM_SVC_ES,
+					    QCOM_SCM_ES_INVALIDATE_ICE_KEY) &&
+		__qcom_scm_is_call_available(dev, QCOM_SCM_SVC_ES,
+					     QCOM_SCM_ES_CONFIG_SET_ICE_KEY);
+}
+
 /**
  * qcom_scm_ice_available() - Is the ICE key programming interface available?
  *
@@ -1405,10 +1415,7 @@ EXPORT_SYMBOL_GPL(qcom_scm_ocmem_unlock);
  */
 bool qcom_scm_ice_available(void)
 {
-	return __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
-					    QCOM_SCM_ES_INVALIDATE_ICE_KEY) &&
-		__qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
-					     QCOM_SCM_ES_CONFIG_SET_ICE_KEY);
+	return __qcom_scm_ice_available(__scm->dev);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_ice_available);
 
@@ -1424,7 +1431,7 @@ EXPORT_SYMBOL_GPL(qcom_scm_ice_available);
  *
  * Return: 0 on success; -errno on failure.
  */
-int qcom_scm_ice_invalidate_key(u32 index)
+static int __qcom_scm_ice_invalidate_key(struct device *dev, u32 index)
 {
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
@@ -1434,7 +1441,12 @@ int qcom_scm_ice_invalidate_key(u32 index)
 		.owner = ARM_SMCCC_OWNER_SIP,
 	};
 
-	return qcom_scm_call(__scm->dev, &desc, NULL);
+	return qcom_scm_call(dev, &desc, NULL);
+}
+
+int qcom_scm_ice_invalidate_key(u32 index)
+{
+	return __qcom_scm_ice_invalidate_key(__scm->dev, index);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_ice_invalidate_key);
 
@@ -1459,8 +1471,10 @@ EXPORT_SYMBOL_GPL(qcom_scm_ice_invalidate_key);
  *
  * Return: 0 on success; -errno on failure.
  */
-int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
-			 enum qcom_scm_ice_cipher cipher, u32 data_unit_size)
+static int __qcom_scm_ice_set_key(struct device *dev, u32 index,
+				  const u8 *key, u32 key_size,
+				  enum qcom_ice_cipher cipher,
+				  u32 data_unit_size)
 {
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
@@ -1485,25 +1499,38 @@ int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
 	memcpy(keybuf, key, key_size);
 	desc.args[1] = qcom_tzmem_to_phys(keybuf);
 
-	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	ret = qcom_scm_call(dev, &desc, NULL);
 
 	memzero_explicit(keybuf, key_size);
 
 	return ret;
 }
+
+int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
+			 enum qcom_scm_ice_cipher cipher, u32 data_unit_size)
+{
+	return __qcom_scm_ice_set_key(__scm->dev, index, key, key_size,
+				      (enum qcom_ice_cipher)cipher,
+				      data_unit_size);
+}
 EXPORT_SYMBOL_GPL(qcom_scm_ice_set_key);
 
-bool qcom_scm_has_wrapped_key_support(void)
+static bool __qcom_scm_has_wrapped_key_support(struct device *dev)
 {
-	return __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
+	return __qcom_scm_is_call_available(dev, QCOM_SCM_SVC_ES,
 					    QCOM_SCM_ES_DERIVE_SW_SECRET) &&
-	       __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
+	       __qcom_scm_is_call_available(dev, QCOM_SCM_SVC_ES,
 					    QCOM_SCM_ES_GENERATE_ICE_KEY) &&
-	       __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
+	       __qcom_scm_is_call_available(dev, QCOM_SCM_SVC_ES,
 					    QCOM_SCM_ES_PREPARE_ICE_KEY) &&
-	       __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
+	       __qcom_scm_is_call_available(dev, QCOM_SCM_SVC_ES,
 					    QCOM_SCM_ES_IMPORT_ICE_KEY);
 }
+
+bool qcom_scm_has_wrapped_key_support(void)
+{
+	return __qcom_scm_has_wrapped_key_support(__scm->dev);
+}
 EXPORT_SYMBOL_GPL(qcom_scm_has_wrapped_key_support);
 
 /**
@@ -1522,8 +1549,9 @@ EXPORT_SYMBOL_GPL(qcom_scm_has_wrapped_key_support);
  *
  * Return: 0 on success; -errno on failure.
  */
-int qcom_scm_derive_sw_secret(const u8 *eph_key, size_t eph_key_size,
-			      u8 *sw_secret, size_t sw_secret_size)
+static int __qcom_scm_derive_sw_secret(struct device *dev,
+				       const u8 *eph_key, size_t eph_key_size,
+				       u8 *sw_secret, size_t sw_secret_size)
 {
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
@@ -1552,7 +1580,7 @@ int qcom_scm_derive_sw_secret(const u8 *eph_key, size_t eph_key_size,
 	desc.args[2] = qcom_tzmem_to_phys(sw_secret_buf);
 	desc.args[3] = sw_secret_size;
 
-	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	ret = qcom_scm_call(dev, &desc, NULL);
 	if (!ret)
 		memcpy(sw_secret, sw_secret_buf, sw_secret_size);
 
@@ -1560,6 +1588,13 @@ int qcom_scm_derive_sw_secret(const u8 *eph_key, size_t eph_key_size,
 	memzero_explicit(sw_secret_buf, sw_secret_size);
 	return ret;
 }
+
+int qcom_scm_derive_sw_secret(const u8 *eph_key, size_t eph_key_size,
+			      u8 *sw_secret, size_t sw_secret_size)
+{
+	return __qcom_scm_derive_sw_secret(__scm->dev, eph_key, eph_key_size,
+				   sw_secret, sw_secret_size);
+}
 EXPORT_SYMBOL_GPL(qcom_scm_derive_sw_secret);
 
 /**
@@ -1573,7 +1608,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_derive_sw_secret);
  *
  * Return: 0 on success; -errno on failure.
  */
-int qcom_scm_generate_ice_key(u8 *lt_key, size_t lt_key_size)
+static int __qcom_scm_generate_ice_key(struct device *dev,
+				       u8 *lt_key, size_t lt_key_size)
 {
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
@@ -1592,13 +1628,18 @@ int qcom_scm_generate_ice_key(u8 *lt_key, size_t lt_key_size)
 	desc.args[0] = qcom_tzmem_to_phys(lt_key_buf);
 	desc.args[1] = lt_key_size;
 
-	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	ret = qcom_scm_call(dev, &desc, NULL);
 	if (!ret)
 		memcpy(lt_key, lt_key_buf, lt_key_size);
 
 	memzero_explicit(lt_key_buf, lt_key_size);
 	return ret;
 }
+
+int qcom_scm_generate_ice_key(u8 *lt_key, size_t lt_key_size)
+{
+	return __qcom_scm_generate_ice_key(__scm->dev, lt_key, lt_key_size);
+}
 EXPORT_SYMBOL_GPL(qcom_scm_generate_ice_key);
 
 /**
@@ -1614,8 +1655,9 @@ EXPORT_SYMBOL_GPL(qcom_scm_generate_ice_key);
  *
  * Return: 0 on success; -errno on failure.
  */
-int qcom_scm_prepare_ice_key(const u8 *lt_key, size_t lt_key_size,
-			     u8 *eph_key, size_t eph_key_size)
+static int __qcom_scm_prepare_ice_key(struct device *dev,
+				      const u8 *lt_key, size_t lt_key_size,
+				      u8 *eph_key, size_t eph_key_size)
 {
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
@@ -1644,7 +1686,7 @@ int qcom_scm_prepare_ice_key(const u8 *lt_key, size_t lt_key_size,
 	desc.args[2] = qcom_tzmem_to_phys(eph_key_buf);
 	desc.args[3] = eph_key_size;
 
-	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	ret = qcom_scm_call(dev, &desc, NULL);
 	if (!ret)
 		memcpy(eph_key, eph_key_buf, eph_key_size);
 
@@ -1652,6 +1694,13 @@ int qcom_scm_prepare_ice_key(const u8 *lt_key, size_t lt_key_size,
 	memzero_explicit(eph_key_buf, eph_key_size);
 	return ret;
 }
+
+int qcom_scm_prepare_ice_key(const u8 *lt_key, size_t lt_key_size,
+			     u8 *eph_key, size_t eph_key_size)
+{
+	return __qcom_scm_prepare_ice_key(__scm->dev, lt_key, lt_key_size,
+				  eph_key, eph_key_size);
+}
 EXPORT_SYMBOL_GPL(qcom_scm_prepare_ice_key);
 
 /**
@@ -1667,8 +1716,9 @@ EXPORT_SYMBOL_GPL(qcom_scm_prepare_ice_key);
  *
  * Return: 0 on success; -errno on failure.
  */
-int qcom_scm_import_ice_key(const u8 *raw_key, size_t raw_key_size,
-			    u8 *lt_key, size_t lt_key_size)
+static int __qcom_scm_import_ice_key(struct device *dev,
+				     const u8 *raw_key, size_t raw_key_size,
+				     u8 *lt_key, size_t lt_key_size)
 {
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
@@ -1697,7 +1747,7 @@ int qcom_scm_import_ice_key(const u8 *raw_key, size_t raw_key_size,
 	desc.args[2] = qcom_tzmem_to_phys(lt_key_buf);
 	desc.args[3] = lt_key_size;
 
-	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	ret = qcom_scm_call(dev, &desc, NULL);
 	if (!ret)
 		memcpy(lt_key, lt_key_buf, lt_key_size);
 
@@ -1705,8 +1755,26 @@ int qcom_scm_import_ice_key(const u8 *raw_key, size_t raw_key_size,
 	memzero_explicit(lt_key_buf, lt_key_size);
 	return ret;
 }
+
+int qcom_scm_import_ice_key(const u8 *raw_key, size_t raw_key_size,
+			    u8 *lt_key, size_t lt_key_size)
+{
+	return __qcom_scm_import_ice_key(__scm->dev, raw_key, raw_key_size,
+				 lt_key, lt_key_size);
+}
 EXPORT_SYMBOL_GPL(qcom_scm_import_ice_key);
 
+static struct qcom_ice_tz_ops qcom_ice_scm_ops = {
+	.drv_name = "qcom_scm",
+	.ice_invalidate_key = __qcom_scm_ice_invalidate_key,
+	.ice_set_key = __qcom_scm_ice_set_key,
+	.ice_has_wrapped_key_support = __qcom_scm_has_wrapped_key_support,
+	.ice_derive_sw_secret = __qcom_scm_derive_sw_secret,
+	.ice_generate_key = __qcom_scm_generate_ice_key,
+	.ice_prepare_key = __qcom_scm_prepare_ice_key,
+	.ice_import_key	= __qcom_scm_import_ice_key,
+};
+
 /**
  * qcom_scm_hdcp_available() - Check if secure environment supports HDCP.
  *
@@ -2820,6 +2888,18 @@ static int qcom_scm_probe(struct platform_device *pdev)
 					     "Failed to request qcom-scm irq\n");
 	}
 
+	/*
+	 * If the ICE SCM interface is available, the operations MUST be
+	 * registered before the SCM API is published below, otherwise
+	 * ICE driver could attempt to call the ICE SCM pointers before
+	 * they are registered and assume that they aren't available.
+	 */
+	if (__qcom_scm_ice_available(scm->dev)) {
+		qcom_ice_scm_ops.dev = scm->dev;
+		ret = qcom_ice_tz_ops_register(&qcom_ice_scm_ops);
+		WARN(ret < 0, "failed to register ice SCM ops: %d\n", ret);
+	}
+
 	/*
 	 * Paired with smp_load_acquire() in qcom_scm_is_available().
 	 *
@@ -2876,6 +2956,7 @@ static void qcom_scm_shutdown(struct platform_device *pdev)
 	/* Clean shutdown, disable download mode to allow normal restart */
 	qcom_scm_set_download_mode(__scm, QCOM_DLOAD_NODUMP);
 	qcom_pas_ops_unregister();
+	qcom_ice_tz_ops_unregister(&qcom_ice_scm_ops);
 }
 
 static const struct of_device_id qcom_scm_dt_match[] = {

-- 
2.34.1

