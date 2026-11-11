Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794406673;
	b=JM/veEiyjnfoQg8qvuNA5kYdusa54TN2VN8jVUsZZoDVOPbHT6PvaqPn4erojA3/aoIY
	 Jd8QsShRmqhacYE+vyOaHPuu0HWZ5/yp3xcZoJTpHia+6m5haeoiCDRn7eoI6KorUfcb7
	 4Pty0qsW5MLhyR6/K9I1eRn5UEOrEfMd9vSr78unUXurmDZOEKejqmU8Pbr/+lbNhKp5w
	 gROtGY8DRduLIfVcZzEn4yblZdr0wFKv1aEO5Gt/yVw/NqQD23v2nRaVdFPcfWO9pDd2m
	 YUwOLsGmJULr/Z9BARD97OF71bWSocpR14NbVB8R9m1reeAW/VHW6MygmTyfgHMMwXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794406673;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=/YBRtnGmpBB9s0CPG0c3lmE8GGo5ap9/PpQQReA+vmw=;
	b=R//FBP2htXEoUY/g0yJz3IRyAWejMSCxu5oNrwJ3NHKio3dOc9J5AHEb7tY69sQOclfg
	 45Qcz8gh7TzoQ1xmJki4o2Ps+t6pFIZ+p85OgYDJfP2BwJ5rlKIEys+85+1CAJrr0u1Ue
	 43MMQ4fcmxGFG9w/2LhlnraE4VD4nLBpr0jH/thYsak2yGS48RvV5gWQYrMD8c0T6w/tM
	 9OFFp+8wYgMS755c7VYL6z8nvrFKIuonWpzJZaMbpky+7lxaTakmKliBbFoqltFMr++Gf
	 2Br+c47ywJZ0h81+DRBvjI88RFEv09uvE4h5r/P9gBnsOQLl7v472jLiHtzY4xgtmeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kscJ5hR6;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=b5+pIDPH;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7674B606A8BA
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:17:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7674B606A8BA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kscJ5hR6;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=b5+pIDPH
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABEHZCv2556560
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:17:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/YBRtnGmpBB9s0CPG0c3lmE8GGo5ap9/PpQQReA+vmw=; b=kscJ5hR6kPSqu6er
	qiRfnhUyid+QAabDm+0Rw4sKvsSgSlXGvni4ItUI1Kb2/xhuik/GF5Yj32JbpQ0q
	XarSZX0kkxFAIyMyCgvBliphwozQO7v0Cdm7N0BVhHCpTnsCcOmvGcBJn4SYYsK7
	oNaSPSXysZ3LNoqa14dDBcMzHdg0alM5ltDcqBre7DPUfH3ehQTNBTTNWExDuPl4
	AVrIzp9kZdRHRxYDuZSQczt+qh74uXJjZ1V6vLqOW5FUBTqT4vst3IFSIquYe1bw
	JCrmq1FJbZpRK+f35o+EmNDOhRjPiNBix0r74a4rcLkCU0fXw3IQBgWtw751IpOy
	pfaYhQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hvdnmb0ft-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:17:51 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36efb506f29so5733134eec.1
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 06:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794406670; x=1795011470; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/YBRtnGmpBB9s0CPG0c3lmE8GGo5ap9/PpQQReA+vmw=;
        b=b5+pIDPHwkEZraf7xRoaxwAAFj22si6808/UcmC7Lo27yCcDWTkmg62+8ooG55+80O
         JirQOCufzJcUUdQzGC8hb4VgaXGb0DxZGENmXkn/e4xvRy3YE4YwM55m1p5N6iQYQLXE
         VEzBQk5T5pyeW81v5aoguskZMtm9xVCsxpdo7gFowWsAzLG1Ck2BcY8Y6+xILqt2oK2g
         Nt7tcGwNfXSr6vTkFQ9td9M6a3E7OGavL7U9LLBCdvFX+IjMqWs4JZepsr+QEXP+FyaT
         DstpiUWG1YcO3pIddcwa+4Km6DYBH/osDxKHVz/6OvJiAIbZYTx7L3F3Ocbid0/zQNwn
         CJ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794406670; x=1795011470;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/YBRtnGmpBB9s0CPG0c3lmE8GGo5ap9/PpQQReA+vmw=;
        b=yYfUfv94xQEOcYsYbk0xyCpTPNxcM2UkigipeeUNAP/OIa4qsL9EzJNWFzg8x9r35B
         KnLigj37oWJ3oUh1xyBEBzMCnPVKq65WpaJLkaon+py9XOJ/d3126iqC+P3giDw/W5LA
         5T0hSaZm5HV9Vr7O+WXoLV4FSLiGssmhzL70ney5Vxhguhd4Q46QyXlypMlXFamOegQm
         jmhUacM2uwpfyR2UJqy+dm3lTZWNmdOBWaVDuACUR1bTvz7cycE/skb8WckeigeDrhMq
         hvp+upSxDMxyADm+31pSXW9DtJVzzyIu/jHp3EfiMco89cbTwsZ1gYtYc2dbTuahyVxb
         0R7A==
X-Forwarded-Encrypted: i=1; AL+hErGEnZhzOOfAtoEX3Yvfsi7QQsjfnI95WBXUh4OvOfD/jVedYZ+KAWnB5Km9NX4De0MkoSNAzBm8a8bPINA=@vger.kernel.org
X-Gm-Message-State: APuU4Z9bPNTOExuGCo8OW0ZPd2j+jQOcUYZz1I/Hz08mtJeRk1zWHX1g
	IYiRS/SoxHte8FLmEtuIGao+soZpTIWU77fQNzVeajM1nU9vreT8ThBAa1C+YtJWpPqdrdPkFKI
	HXkz4MGyJHbOkcwruox41oOQMlJe6PSzIos3emId98vsdmGc8Qc6ReBzv1IyCJsOY2Pw=
X-Gm-Gg: AYBFou13xLODmEe725ag1rZeVlwODH4bQNELxcOqdlnKM+wJkyjcO6x2zw05b5tLhtA
	kGCMNFFkElzLIAHcC3IZFWVCl1lm8AIOHdyFRpBYRWUmbc3VpXEKOThuZJKtoLbU2iJ7KPiEl9S
	KN7NUKoRYKLZHRPIRrb8JWTYNX206fFFMcO+/3bc5IrIOB4ejDencrreWYjHYKEHCMT37xHYyy8
	qZU/mQaQpQMMXKLNHL1QWtvvlP7etO3caDK1QaZApxxEmW7Kwpug/OLu/mm30ImxH+MOf4bhRlL
	QjcEb2HtbQd51s153AeWliUiL9XBBxh7RurvdgvpLstBacUZIC8DDG3/R8srz9IxO8/OpsSxUSP
	WJGcVLCSWsDfbJxr0Y5YP1RU/emPHqBbf6LLajCXKSPxb/zlu58xZKmY6IO/o6eOXaOVjQhC/6w
	==
X-Received: by 2002:a05:701b:2603:b0:1a5:52f6:db9a with SMTP id a92af1059eb24-1b3c030e887mr2858749c88.22.1794406670137;
        Wed, 11 Nov 2026 06:17:50 -0800 (PST)
X-Received: by 2002:a05:701b:2603:b0:1a5:52f6:db9a with SMTP id a92af1059eb24-1b3c030e887mr2858715c88.22.1794406669493;
        Wed, 11 Nov 2026 06:17:49 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b2fc09sm33747063c88.10.2026.11.11.06.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 06:17:49 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Wed, 11 Nov 2026 19:47:06 +0530
Subject: [PATCH v2 6/6] firmware: qcom: scm: Drop exported ICE wrapper
 functions
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
Message-Id: <20261111-ice-migrate-tee-svc-v2-6-29d19f6c92ab@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794406634; l=10826;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=fCrgNo/wtyjSv5o4RCovHkPYaFuetOaaEpqw2NtaGHM=;
 b=YmnN0Lia89sQ0GHCXp5ViHe1pgl+mLExglxv5U7eXcxaMzf7JttD2h2UoI942LofFDHxsBhtU
 Ivg19f7mjdvAm22iGz5APGNHsmSNYp9QaAFtqONgcU+lXxp0xevY58r
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: g-U7R6-CX3xhcfVTmMVbW2tgeS8eWn2-
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA1NiBTYWx0ZWRfXw5DY7BKT33RF
 OJGkBZ3N4+d/Y07ax1ys039ANTEKti/uqJ65jj5UDy3/6QKIxP0ip6hcnWKR3QQRwfvftlgoL8m
 GAJIAnLstrE/WnUIoYnztVAB2Z3EXEY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA1NiBTYWx0ZWRfX1cSriFwDgLU0
 stPHnAn39gw3FtKBV3EemCM4U0Kk0YLhMIi6TDb7i3iyMbJuVoFLS7eCUECW2ef6/NG2kD1X5Xj
 rSlzm13/QYaPdfetcEX7X6tWiYTFRPQRXuKTINLqNj3Jz9Zgkh6ACR0aCY5rKvKj1KImjWcdWBL
 NvQH+58rUzqF2c8vKFWsXZkpNPFHqcicjnAKaOsl1Nivh21L29sqCKhKKAb1tvzzCYMWadQCOGm
 OfKBjtC+mU1x9/+hLcB3E2cQl90yosQAjlTfexESmQ48WUMYHLo8TsM/W9OlIeEiY8B2M7xK0XL
 V1kd3dn1kLgcy5Nvr8BTFR7jFBfu7JRwcUHKYy26JfHXDYH0bJEQICqocO1GJRNv41FEfbH1tGu
 HIDPB7DSsiTtiYhLNXA8E0RyBNOm7fYyCi7EI8Qh6F6si0EUMdgogzT+ATevd1fn5P2jXtpn/LE
 SHkB5olusSsT1NTaS7Q==
X-Proofpoint-GUID: g-U7R6-CX3xhcfVTmMVbW2tgeS8eWn2-
X-Authority-Analysis: v=2.4 cv=MpzHeGae c=1 sm=1 tr=0 ts=6af4790f cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=F3QbZBHQcOWnaqSeXxkA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-11_03,2026-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611110056

Drop the exported ICE wrapper functions from the SCM driver since the ICE
driver has now migrated to the TZ agnostic ICE APIs which allow runtime
routing of ICE secure calls to the appropriate TEE (QTEE or OPTEE).

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 drivers/firmware/qcom/qcom_scm.c       | 117 +++++++++------------------------
 include/linux/firmware/qcom/qcom_scm.h |  20 ------
 2 files changed, 31 insertions(+), 106 deletions(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 6b66bcedc84f..277334f71178 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1399,25 +1399,20 @@ int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_client id, u32 offset, u32 size)
 }
 EXPORT_SYMBOL_GPL(qcom_scm_ocmem_unlock);
 
-bool __qcom_scm_ice_available(struct device *dev)
-{
-	return __qcom_scm_is_call_available(dev, QCOM_SCM_SVC_ES,
-					    QCOM_SCM_ES_INVALIDATE_ICE_KEY) &&
-		__qcom_scm_is_call_available(dev, QCOM_SCM_SVC_ES,
-					     QCOM_SCM_ES_CONFIG_SET_ICE_KEY);
-}
-
 /**
  * qcom_scm_ice_available() - Is the ICE key programming interface available?
+ * @dev: The SCM device
  *
  * Return: true iff the SCM calls wrapped by qcom_scm_ice_invalidate_key() and
  *	   qcom_scm_ice_set_key() are available.
  */
-bool qcom_scm_ice_available(void)
+static bool qcom_scm_ice_available(struct device *dev)
 {
-	return __qcom_scm_ice_available(__scm->dev);
+	return __qcom_scm_is_call_available(dev, QCOM_SCM_SVC_ES,
+					    QCOM_SCM_ES_INVALIDATE_ICE_KEY) &&
+		__qcom_scm_is_call_available(dev, QCOM_SCM_SVC_ES,
+					     QCOM_SCM_ES_CONFIG_SET_ICE_KEY);
 }
-EXPORT_SYMBOL_GPL(qcom_scm_ice_available);
 
 /**
  * qcom_scm_ice_invalidate_key() - Invalidate an inline encryption key
@@ -1431,7 +1426,7 @@ EXPORT_SYMBOL_GPL(qcom_scm_ice_available);
  *
  * Return: 0 on success; -errno on failure.
  */
-static int __qcom_scm_ice_invalidate_key(struct device *dev, u32 index)
+static int qcom_scm_ice_invalidate_key(struct device *dev, u32 index)
 {
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
@@ -1444,12 +1439,6 @@ static int __qcom_scm_ice_invalidate_key(struct device *dev, u32 index)
 	return qcom_scm_call(dev, &desc, NULL);
 }
 
-int qcom_scm_ice_invalidate_key(u32 index)
-{
-	return __qcom_scm_ice_invalidate_key(__scm->dev, index);
-}
-EXPORT_SYMBOL_GPL(qcom_scm_ice_invalidate_key);
-
 /**
  * qcom_scm_ice_set_key() - Set an inline encryption key
  * @index: the keyslot into which to set the key
@@ -1471,10 +1460,10 @@ EXPORT_SYMBOL_GPL(qcom_scm_ice_invalidate_key);
  *
  * Return: 0 on success; -errno on failure.
  */
-static int __qcom_scm_ice_set_key(struct device *dev, u32 index,
-				  const u8 *key, u32 key_size,
-				  enum qcom_ice_cipher cipher,
-				  u32 data_unit_size)
+static int qcom_scm_ice_set_key(struct device *dev, u32 index,
+				const u8 *key, u32 key_size,
+				enum qcom_ice_cipher cipher,
+				u32 data_unit_size)
 {
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
@@ -1506,16 +1495,7 @@ static int __qcom_scm_ice_set_key(struct device *dev, u32 index,
 	return ret;
 }
 
-int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
-			 enum qcom_scm_ice_cipher cipher, u32 data_unit_size)
-{
-	return __qcom_scm_ice_set_key(__scm->dev, index, key, key_size,
-				      (enum qcom_ice_cipher)cipher,
-				      data_unit_size);
-}
-EXPORT_SYMBOL_GPL(qcom_scm_ice_set_key);
-
-static bool __qcom_scm_has_wrapped_key_support(struct device *dev)
+static bool qcom_scm_has_wrapped_key_support(struct device *dev)
 {
 	return __qcom_scm_is_call_available(dev, QCOM_SCM_SVC_ES,
 					    QCOM_SCM_ES_DERIVE_SW_SECRET) &&
@@ -1527,12 +1507,6 @@ static bool __qcom_scm_has_wrapped_key_support(struct device *dev)
 					    QCOM_SCM_ES_IMPORT_ICE_KEY);
 }
 
-bool qcom_scm_has_wrapped_key_support(void)
-{
-	return __qcom_scm_has_wrapped_key_support(__scm->dev);
-}
-EXPORT_SYMBOL_GPL(qcom_scm_has_wrapped_key_support);
-
 /**
  * qcom_scm_derive_sw_secret() - Derive software secret from wrapped key
  * @eph_key: an ephemerally-wrapped key
@@ -1549,9 +1523,9 @@ EXPORT_SYMBOL_GPL(qcom_scm_has_wrapped_key_support);
  *
  * Return: 0 on success; -errno on failure.
  */
-static int __qcom_scm_derive_sw_secret(struct device *dev,
-				       const u8 *eph_key, size_t eph_key_size,
-				       u8 *sw_secret, size_t sw_secret_size)
+static int qcom_scm_derive_sw_secret(struct device *dev,
+				     const u8 *eph_key, size_t eph_key_size,
+				     u8 *sw_secret, size_t sw_secret_size)
 {
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
@@ -1589,13 +1563,6 @@ static int __qcom_scm_derive_sw_secret(struct device *dev,
 	return ret;
 }
 
-int qcom_scm_derive_sw_secret(const u8 *eph_key, size_t eph_key_size,
-			      u8 *sw_secret, size_t sw_secret_size)
-{
-	return __qcom_scm_derive_sw_secret(__scm->dev, eph_key, eph_key_size,
-				   sw_secret, sw_secret_size);
-}
-EXPORT_SYMBOL_GPL(qcom_scm_derive_sw_secret);
 
 /**
  * qcom_scm_generate_ice_key() - Generate a wrapped key for storage encryption
@@ -1608,8 +1575,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_derive_sw_secret);
  *
  * Return: 0 on success; -errno on failure.
  */
-static int __qcom_scm_generate_ice_key(struct device *dev,
-				       u8 *lt_key, size_t lt_key_size)
+static int qcom_scm_generate_ice_key(struct device *dev,
+				     u8 *lt_key, size_t lt_key_size)
 {
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
@@ -1636,12 +1603,6 @@ static int __qcom_scm_generate_ice_key(struct device *dev,
 	return ret;
 }
 
-int qcom_scm_generate_ice_key(u8 *lt_key, size_t lt_key_size)
-{
-	return __qcom_scm_generate_ice_key(__scm->dev, lt_key, lt_key_size);
-}
-EXPORT_SYMBOL_GPL(qcom_scm_generate_ice_key);
-
 /**
  * qcom_scm_prepare_ice_key() - Re-wrap a key with the per-boot ephemeral key
  * @lt_key: a long-term wrapped key
@@ -1655,9 +1616,9 @@ EXPORT_SYMBOL_GPL(qcom_scm_generate_ice_key);
  *
  * Return: 0 on success; -errno on failure.
  */
-static int __qcom_scm_prepare_ice_key(struct device *dev,
-				      const u8 *lt_key, size_t lt_key_size,
-				      u8 *eph_key, size_t eph_key_size)
+static int qcom_scm_prepare_ice_key(struct device *dev,
+				    const u8 *lt_key, size_t lt_key_size,
+				    u8 *eph_key, size_t eph_key_size)
 {
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
@@ -1695,14 +1656,6 @@ static int __qcom_scm_prepare_ice_key(struct device *dev,
 	return ret;
 }
 
-int qcom_scm_prepare_ice_key(const u8 *lt_key, size_t lt_key_size,
-			     u8 *eph_key, size_t eph_key_size)
-{
-	return __qcom_scm_prepare_ice_key(__scm->dev, lt_key, lt_key_size,
-				  eph_key, eph_key_size);
-}
-EXPORT_SYMBOL_GPL(qcom_scm_prepare_ice_key);
-
 /**
  * qcom_scm_import_ice_key() - Import key for storage encryption
  * @raw_key: the raw key to import
@@ -1716,9 +1669,9 @@ EXPORT_SYMBOL_GPL(qcom_scm_prepare_ice_key);
  *
  * Return: 0 on success; -errno on failure.
  */
-static int __qcom_scm_import_ice_key(struct device *dev,
-				     const u8 *raw_key, size_t raw_key_size,
-				     u8 *lt_key, size_t lt_key_size)
+static int qcom_scm_import_ice_key(struct device *dev,
+				   const u8 *raw_key, size_t raw_key_size,
+				   u8 *lt_key, size_t lt_key_size)
 {
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
@@ -1756,23 +1709,15 @@ static int __qcom_scm_import_ice_key(struct device *dev,
 	return ret;
 }
 
-int qcom_scm_import_ice_key(const u8 *raw_key, size_t raw_key_size,
-			    u8 *lt_key, size_t lt_key_size)
-{
-	return __qcom_scm_import_ice_key(__scm->dev, raw_key, raw_key_size,
-				 lt_key, lt_key_size);
-}
-EXPORT_SYMBOL_GPL(qcom_scm_import_ice_key);
-
 static struct qcom_ice_tz_ops qcom_ice_scm_ops = {
 	.drv_name = "qcom_scm",
-	.ice_invalidate_key = __qcom_scm_ice_invalidate_key,
-	.ice_set_key = __qcom_scm_ice_set_key,
-	.ice_has_wrapped_key_support = __qcom_scm_has_wrapped_key_support,
-	.ice_derive_sw_secret = __qcom_scm_derive_sw_secret,
-	.ice_generate_key = __qcom_scm_generate_ice_key,
-	.ice_prepare_key = __qcom_scm_prepare_ice_key,
-	.ice_import_key	= __qcom_scm_import_ice_key,
+	.ice_invalidate_key = qcom_scm_ice_invalidate_key,
+	.ice_set_key = qcom_scm_ice_set_key,
+	.ice_has_wrapped_key_support = qcom_scm_has_wrapped_key_support,
+	.ice_derive_sw_secret = qcom_scm_derive_sw_secret,
+	.ice_generate_key = qcom_scm_generate_ice_key,
+	.ice_prepare_key = qcom_scm_prepare_ice_key,
+	.ice_import_key = qcom_scm_import_ice_key,
 };
 
 /**
@@ -2894,7 +2839,7 @@ static int qcom_scm_probe(struct platform_device *pdev)
 	 * ICE driver could attempt to call the ICE SCM pointers before
 	 * they are registered and assume that they aren't available.
 	 */
-	if (__qcom_scm_ice_available(scm->dev)) {
+	if (qcom_scm_ice_available(scm->dev)) {
 		qcom_ice_scm_ops.dev = scm->dev;
 		ret = qcom_ice_tz_ops_register(&qcom_ice_scm_ops);
 		WARN(ret < 0, "failed to register ice SCM ops: %d\n", ret);
diff --git a/include/linux/firmware/qcom/qcom_scm.h b/include/linux/firmware/qcom/qcom_scm.h
index a0a6bc0229c4..36b87be82804 100644
--- a/include/linux/firmware/qcom/qcom_scm.h
+++ b/include/linux/firmware/qcom/qcom_scm.h
@@ -46,13 +46,6 @@ enum qcom_scm_sec_dev_id {
 	QCOM_SCM_ICE_DEV_ID     = 20,
 };
 
-enum qcom_scm_ice_cipher {
-	QCOM_SCM_ICE_CIPHER_AES_128_XTS = 0,
-	QCOM_SCM_ICE_CIPHER_AES_128_CBC = 1,
-	QCOM_SCM_ICE_CIPHER_AES_256_XTS = 3,
-	QCOM_SCM_ICE_CIPHER_AES_256_CBC = 4,
-};
-
 #define QCOM_SCM_PERM_READ       0x4
 #define QCOM_SCM_PERM_WRITE      0x2
 #define QCOM_SCM_PERM_EXEC       0x1
@@ -86,19 +79,6 @@ int qcom_scm_ocmem_lock(enum qcom_scm_ocmem_client id, u32 offset, u32 size,
 			u32 mode);
 int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_client id, u32 offset, u32 size);
 
-bool qcom_scm_ice_available(void);
-int qcom_scm_ice_invalidate_key(u32 index);
-int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
-			 enum qcom_scm_ice_cipher cipher, u32 data_unit_size);
-bool qcom_scm_has_wrapped_key_support(void);
-int qcom_scm_derive_sw_secret(const u8 *eph_key, size_t eph_key_size,
-			      u8 *sw_secret, size_t sw_secret_size);
-int qcom_scm_generate_ice_key(u8 *lt_key, size_t lt_key_size);
-int qcom_scm_prepare_ice_key(const u8 *lt_key, size_t lt_key_size,
-			     u8 *eph_key, size_t eph_key_size);
-int qcom_scm_import_ice_key(const u8 *raw_key, size_t raw_key_size,
-			    u8 *lt_key, size_t lt_key_size);
-
 bool qcom_scm_hdcp_available(void);
 int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt, u32 *resp);
 

-- 
2.34.1

