Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792597435;
	b=nGGxLNsX8gM1rG2e449R/5nNV2vg5jTSqCrVJPG3u7JS7eer7bBEx0eQg5lAJdwcwRFv
	 AztbXYLsDmKx3q+GtU2EMRzyotd9cKzJiVhbbc8r9o03je5fe+ducU04b3lK2sOIZGZJV
	 HY2F9jVsk9faxG5bBgqoILB//IS6rVA9JuzxYhtq4S6Qpy8WXU/ERGXrByLZH1rOPEaqx
	 21WfTpev4gyQiQdsr8lJPD2pZhuZJH/z8mw1OUQ2la4UKRZeUSLozwuzW31OWGtxhcbGA
	 RGqCQQHSoVq/X9n0Urkd2sUNIgEML2rKFtX6lbtDTKBpWh9c4KWxBBxlnMp7R5ah/lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792597435;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=e7HiGSi+eBAKzHRlGvLoZKtK+8pEADviMUVKI4usKj0=;
	b=Wblov3e2X8InYVSTtLrqdwIqcH/+Qt+VlnqHePFChbYKWl6A9lRtLy1u66QA6YnlACX7
	 nw7hGxKro1njR19EvpfzoD8M6POo6udatErhkbfkOk4JtwFYcLEfBGOuA/67fAvaVMYeq
	 DFeRHho9QpWevXnvkeqoRCwMLfMGdLhdTXuBa4xWNXQ5kk4yTXhPdOE4KlIleRpvNIkYk
	 swMSEPXzpVNznRvixvGwJk5Q3lbfIOItGDIQUtBuypXQYVJra3L3/8foy4o95H5kyxONM
	 vuutAweRVa2FSPWAe/bk/iPSPx5AGKwh2E/9U8TAd3x0EfV3SrKdr8EC984uaPiUvkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=BegaPk5m;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OdJfXM9q;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FBA606C071
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 15:43:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3FBA606C071
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=BegaPk5m;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OdJfXM9q
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LFU1wP4158405
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 15:43:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	e7HiGSi+eBAKzHRlGvLoZKtK+8pEADviMUVKI4usKj0=; b=BegaPk5mCznUwGbK
	URIVes/UB0VI1nKH97RcBzjxTWA4Ma27Q6abc/xNRLxwSqJrb4Q7QEPVhnrFXtDm
	fAQmn+/NG/rA/5aQcfiKm5wqfm5Hi4+VP5F0oiZxCsj8rW1//UewQELaPIO/jU6T
	LbvATSTvAz/+PC8XcbJzGSR85/su63ERJAAo3vS7d0Bg+7XxHO16DgBj4GhU9Rop
	YPlJ8TL435w3mB+P3QTLamJ5T5jZbhsgCgk7/+LU8wrC8YuRQD+FG94d8/hZ+WeC
	JxJtrNdKBp0sFLMOdLuuRpl5gBD6vgIKBJ9oRO0sudXWudGSvW7SJgTOoGnVQaCE
	21m4xQ==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hex5q8ncg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 15:43:53 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-155a75f91e1so1102751c88.1
        for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 08:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792597431; x=1793202231; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e7HiGSi+eBAKzHRlGvLoZKtK+8pEADviMUVKI4usKj0=;
        b=OdJfXM9qwKdOogQZugI9qeSgybxnMtCvBj2gzU75B36HUhMzW3FU6qaS2bZMgZcw3t
         EmdvxIp3kSO2D3hAUZmKtMIfbws/sTfMrliEkcERPmbzI6mXnC7MkG6PWH8xP5Dky+Mz
         y9npqd5Y7S0WLjG6LNWFsQnw0GoV+bDNhp/aeqEa9LdF4URZJp/zhOgh0RWr5Gx1zUc0
         Rvh4U7vSguuSElbqOmCL9+DbI7b3CnyKNDIBPMxSeMx2eUjQzcKo6b5wfYE6J1GM2Js8
         9ONDWEnYFYhhlF/tveyUqkwwYPWiLC1A1Bws1uoFgwtT+Xxne4CR/uCdb4UyXulFYuNK
         gMvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792597431; x=1793202231;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e7HiGSi+eBAKzHRlGvLoZKtK+8pEADviMUVKI4usKj0=;
        b=jtGl1WTcLctB2plcdR4O7MVYXLK8v4UVMlNST+mlePuUXGT52J9+KCZMoHCjYWPN3z
         cCWei0mUBpzC7HI8UtqP4Iq4DB+nPYczfLtzaB6Xa9lDDN4quvT0D5QnTZ22UUjEIWs5
         AydEG1M6oS9R+MCZfBS7vIHv1tg5jUbimkGYxmhiExrW+X7W3jSl9yt//0jXhAYBVrLH
         wyDx14Vqh16G+jMU/QYG7zt/pg14pDYb4Y0I3mqixvdyiAuY3IqtpgKhjz+vQSJjROEL
         CuSwAtJq/mngGJso1UotYI1Q6Svk51c9WEmLl/cQljH1wbENkeR1Mqzxg3BFLpPL+Ai1
         WsCQ==
X-Forwarded-Encrypted: i=1; AKwUvByjwvI1Dx7p4S34qm62QEW3nrpS48iBNMvJI3tX7fxYrvxa1tQ525GTi/n1SvDGwQV5He9JaRXj6jNsymo=@vger.kernel.org
X-Gm-Message-State: AFq9FYJXa6Z4z+ZJUuGBLoVPpPnLn8c5LMbVRPMrPSytC4FkHYfO9W5t
	vxTKOBiDt1fiQYzrxp/9SJA/+io0NavChobY6yaAZ6nC4nBor1+yKmsIYg2xOmy4Fs5fl5/q2I4
	Jwo0qxlLYUbzCOF4HBg4gAMQ8NXzdbRIDIxnjlegh/jQXhuZTjp+9OB9d/GwXVwAvxYY=
X-Gm-Gg: AYBFou3FZFR4Mrqwz/qGoWTi7me3wQe0moluY7/mcGBzuE9TBA/ASQLX4EaeWZspp4L
	iv4jU+rL3EBUHcHAnBniAN7FvgaZA0YHvzlo/9Jq7cNHZC06Ivx3a0mgGs9not/U7YHupoj4caG
	WVd5tNqi1vE3M3S1QifrpoRK9v09Fd8Xuq9vWToZFDsI7CGli5SRq8fkPQgGLgpocdcJEnEKeSt
	IEc6KRlxKG/kniB0YooglJ3N71bO2cllXlpspezaBsMrD0Ljh4NDCQHVslc+3po74odCfJExH1Q
	EPT9a1OLfnFkCWXgQRb6TSl/5zY/e/liGGZ1NrNE/+/uYCZcbu1/2GL4DSyp/OKdgeTbFo4wikb
	Q2ZIWBrMzdnzUOH3beqWgP030
X-Received: by 2002:a05:701b:4210:20b0:159:f192:5290 with SMTP id a92af1059eb24-18dbf218391mr6806057c88.13.1792597430856;
        Wed, 21 Oct 2026 08:43:50 -0700 (PDT)
X-Received: by 2002:a05:701b:4210:20b0:159:f192:5290 with SMTP id a92af1059eb24-18dbf218391mr6806031c88.13.1792597430250;
        Wed, 21 Oct 2026 08:43:50 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1902f96dc4bsm7937768c88.0.2026.10.21.08.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 08:43:49 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 21:13:11 +0530
Subject: [PATCH 5/5] firmware: qcom: scm: Drop exported ICE wrapper
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
Message-Id: <20261021-ice-migrate-tee-svc-v1-5-b035be7aab0a@oss.qualcomm.com>
References: <20261021-ice-migrate-tee-svc-v1-0-b035be7aab0a@oss.qualcomm.com>
In-Reply-To: <20261021-ice-migrate-tee-svc-v1-0-b035be7aab0a@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792597401; l=10444;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=vaZC/5EUswfLlBTapWjQ/fqR5EMZBzDkoGZAoqbtT8o=;
 b=al1RIRAzrlNsUBRsfVI8KChV9dCMpvFmWrcivh2ByRKvHkcb+VaXcduD5qPhnvKQWZfSpL5jL
 eihRtkRMr7/Bdp2+VgBRKL+lU62Nl1ScdwAk7VF5/X1LNkEgkWLEQVA
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA2MiBTYWx0ZWRfXx2Bh24dAxMW6
 JXrjFclt5sOav7KJMcd5s68p/ZcVOn25ipII04Fq5vPAGxxuGQi88QwlAm4DtxcHjuVi1CaqCur
 8R1eleq7ebIvptrX8uW17Z931M48WxM=
X-Authority-Analysis: v=2.4 cv=eJaGH3p1 c=1 sm=1 tr=0 ts=6ad8ddb9 cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=F3QbZBHQcOWnaqSeXxkA:9 a=QEXdDO2ut3YA:10
 a=Kq8ClHjjuc5pcCNDwlU0:22
X-Proofpoint-GUID: kj_xTxEenVKU8kHIOtrbNjscp8khbU0g
X-Proofpoint-ORIG-GUID: kj_xTxEenVKU8kHIOtrbNjscp8khbU0g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA2MiBTYWx0ZWRfX9+qqMpPsvbsw
 E8CFKi/bpKUYCe54oCS2Qsx9rqTj9qZc5vpenAuLKMeogdd8RqptxWfk5L6TVNXZAhZVYwzFRfz
 +GNxLcvVrnssMap98+XvSJ6xraEAqw+l07dM7R6OPWsAyk0MOnT8N/b/fSR5kOQSIKpeK8Up79X
 EW7MSKGA8jG37qqWnkLYReWJONvIbMukTQS/6gVHp9qE76yP2b/hB7u+4GR34Fpo3Dh5JDY28ef
 KNBJ4WM66y+wjcWt4pBdC+2rdcjmUoW1DyuSPpi+gEDMc9fsztNUihLJNsmY3Z14oVEw01kAi/6
 2J7fCPHknZNcPI6Bu5RBf5uXSY9oVc6g8x7j3sX0NROU5/cZD9vtg0ckl6cCk1ppOD+i4QLFBsc
 Ku6t2VsTLohPw1aG+pDNKNh8GwJTQV6BksPJHPXfXsQzAeMDeoVym4EX7CMuGdn/puPEI/04KUv
 AW/rq5kaV0LC7ObcbbA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 priorityscore=1501
 adultscore=0 spamscore=0 clxscore=1015 bulkscore=0 phishscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610210062

Drop the exported ICE wrapper functions from the SCM driver since the ICE
driver has now migrated to generic ICE service which allows re-direction of
of ICE secure service calls to the appropriate TEE (QTEE or OPTEE) at
runtime.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 drivers/firmware/qcom/qcom_scm.c       | 110 ++++++++-------------------------
 include/linux/firmware/qcom/qcom_scm.h |  20 ------
 2 files changed, 27 insertions(+), 103 deletions(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 9aeb2cefa77a..2d2a4715a0c7 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1405,7 +1405,7 @@ EXPORT_SYMBOL_GPL(qcom_scm_ocmem_unlock);
  * Return: true iff the SCM calls wrapped by qcom_scm_ice_invalidate_key() and
  *	   qcom_scm_ice_set_key() are available.
  */
-static bool __qcom_scm_ice_available(struct device *dev)
+static bool qcom_scm_ice_available(struct device *dev)
 {
 	return __qcom_scm_is_call_available(dev, QCOM_SCM_SVC_ES,
 					    QCOM_SCM_ES_INVALIDATE_ICE_KEY) &&
@@ -1413,12 +1413,6 @@ static bool __qcom_scm_ice_available(struct device *dev)
 					     QCOM_SCM_ES_CONFIG_SET_ICE_KEY);
 }
 
-bool qcom_scm_ice_available(void)
-{
-	return __qcom_scm_ice_available(__scm->dev);
-}
-EXPORT_SYMBOL_GPL(qcom_scm_ice_available);
-
 /**
  * qcom_scm_ice_invalidate_key() - Invalidate an inline encryption key
  * @index: the keyslot to invalidate
@@ -1431,7 +1425,7 @@ EXPORT_SYMBOL_GPL(qcom_scm_ice_available);
  *
  * Return: 0 on success; -errno on failure.
  */
-static int __qcom_scm_ice_invalidate_key(struct device *dev, u32 index)
+static int qcom_scm_ice_invalidate_key(struct device *dev, u32 index)
 {
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_ES,
@@ -1444,12 +1438,6 @@ static int __qcom_scm_ice_invalidate_key(struct device *dev, u32 index)
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
@@ -1471,10 +1459,10 @@ EXPORT_SYMBOL_GPL(qcom_scm_ice_invalidate_key);
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
@@ -1506,16 +1494,7 @@ static int __qcom_scm_ice_set_key(struct device *dev, u32 index,
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
@@ -1527,12 +1506,6 @@ static bool __qcom_scm_has_wrapped_key_support(struct device *dev)
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
@@ -1549,9 +1522,9 @@ EXPORT_SYMBOL_GPL(qcom_scm_has_wrapped_key_support);
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
@@ -1589,13 +1562,6 @@ static int __qcom_scm_derive_sw_secret(struct device *dev,
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
@@ -1608,8 +1574,8 @@ EXPORT_SYMBOL_GPL(qcom_scm_derive_sw_secret);
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
@@ -1636,12 +1602,6 @@ static int __qcom_scm_generate_ice_key(struct device *dev,
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
@@ -1655,9 +1615,9 @@ EXPORT_SYMBOL_GPL(qcom_scm_generate_ice_key);
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
@@ -1695,14 +1655,6 @@ static int __qcom_scm_prepare_ice_key(struct device *dev,
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
@@ -1716,9 +1668,9 @@ EXPORT_SYMBOL_GPL(qcom_scm_prepare_ice_key);
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
@@ -1756,24 +1708,16 @@ static int __qcom_scm_import_ice_key(struct device *dev,
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
 static struct qcom_ice_ops qcom_ice_ops_scm = {
 	.drv_name = "qcom_scm",
-	.is_ice_available = __qcom_scm_ice_available,
-	.ice_invalidate_key	= __qcom_scm_ice_invalidate_key,
-	.ice_set_key = __qcom_scm_ice_set_key,
-	.ice_has_wrapped_key_support = __qcom_scm_has_wrapped_key_support,
-	.ice_derive_sw_secret = __qcom_scm_derive_sw_secret,
-	.ice_generate_key = __qcom_scm_generate_ice_key,
-	.ice_prepare_key = __qcom_scm_prepare_ice_key,
-	.ice_import_key	= __qcom_scm_import_ice_key,
+	.is_ice_available = qcom_scm_ice_available,
+	.ice_invalidate_key	= qcom_scm_ice_invalidate_key,
+	.ice_set_key = qcom_scm_ice_set_key,
+	.ice_has_wrapped_key_support = qcom_scm_has_wrapped_key_support,
+	.ice_derive_sw_secret = qcom_scm_derive_sw_secret,
+	.ice_generate_key = qcom_scm_generate_ice_key,
+	.ice_prepare_key = qcom_scm_prepare_ice_key,
+	.ice_import_key = qcom_scm_import_ice_key,
 };
 
 /**
@@ -2905,7 +2849,7 @@ static int qcom_scm_probe(struct platform_device *pdev)
 		qcom_pas_ops_register(&qcom_pas_ops_scm);
 	}
 
-	if (__qcom_scm_ice_available(scm->dev)) {
+	if (qcom_scm_ice_available(scm->dev)) {
 		qcom_ice_ops_scm.dev = scm->dev;
 		qcom_ice_svc_ops_register(&qcom_ice_ops_scm);
 	}
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

