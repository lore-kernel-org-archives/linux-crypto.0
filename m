Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792597428;
	b=lMlsY3punWu433DI8l6O1zD8mJoFrF9ERKjX9PE3RnUSL5+ab24CXjtkKSonPF2gp4XM
	 jNsLqaRh6CqJQuFKEkSZqKZWFnJANy0EkAXkTvpmJMnsQv4MW7UbDAtni4R2LPiTEF8jO
	 phghq/NT0WJViPoAWjQFcSBlMPOZvnBQMpBdI3th9m4WXigVXw77im+3WJxsoHuU01EoY
	 vT5R1X3JhoNFPgKQYfVG2nmRzTyq2ZHbjF9Vro/58z2kKUu10EoUH8bxqXGirt2Zt6WeJ
	 baYEoqEnrX3rCdb3mBNN7nqon5FzmTHrPpKyTagVZKVFAKV0egbga1JnQL2rJrTGOIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792597428;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=ZLWd/oX18V9jLjSX18NKFAoygb2L++PIgsVFAZj+Sws=;
	b=WqvUukEbaPB7/mwTbQXZwKIp+otZgjbA5N+8mBbdKWqnWlNyLBNvj4WTy9otdOF8eh8k
	 plw+BVwjtLTMVocn0JkXrID1dehlpKfuBBUxjN9za7gA4txbhLr9kIt6MBNyKVysDMmkM
	 S43o0nKPKy9oGfkzuUjZmF2xRxC0Z/Q5m4ASitDmNUpFh7Z0MDqchRvUeyA/lKbj67D8t
	 fk1t4uEBsQizPmDuPaYQ25flHa8Z9SfdTDqJnCH56eE21oWDXI0rSfeJWC0uafmX8v+rL
	 vOGI8hcJxdJcuwFKhkROKLtlrEJZWCr/Z3IC9JcuOFSWS700CIlzaxAlUsvwHKV6NWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="MOJoRxa/";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=CnpYvUZH;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7A960A260D
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 15:43:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B7A960A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=MOJoRxa/;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=CnpYvUZH
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LFU5gc2102390
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 15:43:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZLWd/oX18V9jLjSX18NKFAoygb2L++PIgsVFAZj+Sws=; b=MOJoRxa/gFS9MKEO
	Q6ZlB+mB/8FFJTi9hgIjaiykmuEAU8n8T1ZUU+60omqyF8OShj2cZUZM+77e0H9R
	Bfy7OVtN6UctT2RPCsbIm9wQfTP6vf4HNF3DMHWEZ2O39IaR8lLoEAay5EhiLn6E
	Y9pYOAkbHS3jNuCoesjjOd1EFqcAxMbJZ88PfYq9iJLIOZJ50WViMsTu9mqVYQ1L
	1YlV45ACaF4v1DMVk2mOo6P+s7xb8pYfNTRlZ9ZfjlwkbJ3j2kBdE/B7at0pz3Is
	4IWns6PeVDUUNNxoH2gBvjr0AeMSzOUZyLNgL2ybeHbrqDK9yDV21mE90BV15ELT
	Uk52pQ==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4heuhuh9n0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 15:43:47 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36696c9f55bso914604eec.1
        for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 08:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792597427; x=1793202227; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZLWd/oX18V9jLjSX18NKFAoygb2L++PIgsVFAZj+Sws=;
        b=CnpYvUZH/p6FNk282YTkVLB03tzXILA7P8cAxjDpBhdUQOfRAOcl2UX7uYMbAyGoCQ
         h2s5nJ5ObjHB1YfF0RV+Efz+0dtlC0IKLkm4imKdr08zD7hz7RCiuF2IerjU33kPHCrR
         qb1PHfW0s1L0md2eVKzZ3y40GemUxWKxgSv7PqMz+9x6ue8btN2prvGniC0ZCu+pDpXx
         iHUD2SOGElihazZDtQM3USsHp4346Whqfjirw5boFoUCwzd2lAKfUGWyuiN2FuL8+6nT
         /70ORXn/ucC6jgL+7dU9/7Cmj/3tofO6cfhZb3GQ+ezRDz9QhNIX1DpUSP8zpgduRM5l
         3t7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792597427; x=1793202227;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZLWd/oX18V9jLjSX18NKFAoygb2L++PIgsVFAZj+Sws=;
        b=HN5HecbZ0Ij3QYrotPN6AveD8xw8uK1PzQ3DEeQrQ1uvQ6r0dNTzMW0Vc1J1hAf7gR
         wcgYedg+Ez3P6gKtbMlkbN+bxz/lFo4NCt7TJRKsFHp2kjrpAUX0kmdpQ1enllhSmRfJ
         8JKM8bO6QKJ7N3ajoBB+FGVHpXtXAFKMyvdc2I0Ti2hPMx5o9kunsR7i+cQlZgkebQcD
         GhEMvH2unbwe51uemrGB5meTDz9aqhBgjUhmjZJV6OQqBGLe0uId2kMdrruXaxcL0N6E
         F5rkA5VS06fkHx/KInhTMm4wHc+HPlJGJup5h1uJjoJoFEDFbkpJjYEIh+reniScQbib
         dw5Q==
X-Forwarded-Encrypted: i=1; AKwUvByp36+Drynu+hJ0cqAA9E4sID06c/iqj1IoW4yphSZsH8qyMIH3k3I439UuGYPNFK926Ifr8To5qAPa2Kw=@vger.kernel.org
X-Gm-Message-State: AFq9FYKPcb61WiMOfZ0W58v+/sp75ktg2eKFQlEBQmEPeYND/Mhi9ZZ5
	ZoVEYfbtdcpyHhswRI1iVjJjWyd+H3GGu1pXqmQczSwDOR3zDh5ZeNwi9xJCsa3gPKeKkT+StUu
	Iw4TwDFqRWiZ29YiSMB8OfE6/NbvSbxsuuSqEcrEanrE9nOpPFHOfuB8dh74NbJrHta8rDWzHfI
	Y=
X-Gm-Gg: AYBFou1uiI0Sa9gubB0V5nacBYcsL08W6e0ffj6gbV5Z5oi0xz5sbvDiWf1ZyHfghOX
	3dPpjlykEvdaWxeAjjBiZm2c5FXpY+U2eMkgLlBgtPN9RxCkkCqRvic9/zcZDj24LnI/L7RMeqB
	+mblCIubLG5ZR3ZWLb+zH9rjpiAC9/zz3uOuM2r4yU1bxv8N7Nbwh97qSMPUbF75L3EKcsNFqlz
	wCGsMiBUVkt/sk7y/DCe/Yj3BNxH5ap6YkZzAt2jYBJRe8NmIsdT8Jr5Wd9KlPuH/XUCQ3IRcJq
	akIV7uVpub/CGwKjr3/bOsjh4Zn3xKGl+s+ql25bnJeiuaGShotC2Mo9vDXqnHiUqzhIEf4En2p
	pJ37z7wBbf8ZNe8Qj/0cHIWcj
X-Received: by 2002:a05:701b:2802:b0:166:f097:6f10 with SMTP id a92af1059eb24-18dbed4c47cmr5963925c88.11.1792597426086;
        Wed, 21 Oct 2026 08:43:46 -0700 (PDT)
X-Received: by 2002:a05:701b:2802:b0:166:f097:6f10 with SMTP id a92af1059eb24-18dbed4c47cmr5963882c88.11.1792597425270;
        Wed, 21 Oct 2026 08:43:45 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1902f96dc4bsm7937768c88.0.2026.10.21.08.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 08:43:44 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 21:13:10 +0530
Subject: [PATCH 4/5] soc: qcom: ice: Migrate to the generic ICE service
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
Message-Id: <20261021-ice-migrate-tee-svc-v1-4-b035be7aab0a@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792597401; l=5281;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=+jNoF4nSNn7Yf6UxxTwa2YXwE8gWaW0+Cv1ap5fH/wQ=;
 b=Bz4X6vlOflWQsqEMHIZ+6+71ELhtmKTb4xX9ZL7PtoeTcrbbPN/rBptEqXWLrPhwgM46yjRtQ
 whk++DOpC2JBavv3FIN7kko7Y4o3NtoRuDSvRhB11mUWYOp+o7YQjub
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=d4JgWhjE c=1 sm=1 tr=0 ts=6ad8ddb3 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=zftoU6j5KQ9PehORJHMA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA2MiBTYWx0ZWRfXz5NAd6aMRxIF
 5laf4640zPeU00iADceAJiNSw3LMT0cO90UnH34t7NCNLfuLUrxDacdY9m6XWF7L7sAPuX/bcoK
 KdC7LCH4pI07uoPqONL7NhR67ql9dKw=
X-Proofpoint-GUID: DUhaK7iRnxDE65oN0YTwbdyUYycbR50j
X-Proofpoint-ORIG-GUID: DUhaK7iRnxDE65oN0YTwbdyUYycbR50j
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA2MiBTYWx0ZWRfXzHe0gaiLrftJ
 LHPRA0pHoUiJB7OfZ2qiyaFRpgzhhRcbhpAkMnnW7Q+zFusZsBAsi6yMETKVhwfd44AIiNF4b3t
 e7FDlfBs0scw1y1EMLM2wXSA8z4u+HwLVR7+u3Rn8BD0QEp3YkPEpbOfd+qlvaHiuRi5qWFJ0Qo
 oqJUfEIw/C+Hc76XuGU+Cmiqw4ZRQkKC3PTXhl+3YLGsbbd+pNaINIFjDdDI+txP31qajbPOheS
 +LO5ha4y7EFEBsLq5y3qxtDFiW5tlQGc7togBeSBTRT3fxN1Rd0TBrTP6UoAYR7nW/29uVpB8M6
 AVHH8hoFIRJd7d5Jv6JL0lDP+Dez8fm81kYB/dyqAPlhlTFaQvrUUH8UzHtKqiVKMQPOTIDREZB
 nngT5iMnKdaqLLg9BVDT/giyolV2Gfi3ny3+Rnmadi/A2x9ey2iiAy77GIqhlOHaLGp/HAi8Gct
 0MJ021P7YwpX94JR2Rg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 suspectscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210062

Migrate the Inline Crypto Engine (ICE) driver to the generic ICE service
which re-directs calls from the driver to either the SCM or the TEE bus
based back-end driver at runtime.

This makes the ICE driver agnostic of the TEE firmware running on the
Qualcomm platform.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 drivers/soc/qcom/Kconfig |  2 +-
 drivers/soc/qcom/ice.c   | 30 +++++++++++++++---------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
index 535c8619197b..f68973efcabb 100644
--- a/drivers/soc/qcom/Kconfig
+++ b/drivers/soc/qcom/Kconfig
@@ -295,7 +295,7 @@ endif
 
 config QCOM_INLINE_CRYPTO_ENGINE
 	tristate
-	select QCOM_SCM
+	select QCOM_ICE_SERVICE
 
 config QCOM_KRYO_L2_ACCESSORS
 	bool
diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index e256595b9826..c075cab6f7fd 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -18,7 +18,7 @@
 #include <linux/platform_device.h>
 #include <linux/xarray.h>
 
-#include <linux/firmware/qcom/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_ice.h>
 
 #include <soc/qcom/ice.h>
 
@@ -176,7 +176,7 @@ static bool qcom_ice_check_supported(struct qcom_ice *ice)
 	 * advertise support for raw keys or wrapped keys, HWKM cannot be used
 	 * unconditionally.  A module parameter is used to opt into using it.
 	 */
-	if (ice->hwkm_version && qcom_scm_has_wrapped_key_support()) {
+	if (ice->hwkm_version && qcom_ice_svc_has_wrapped_key_support()) {
 		if (qcom_ice_use_wrapped_keys) {
 			dev_info(dev, "Using HWKM. Supporting wrapped keys only.\n");
 			ice->use_hwkm = true;
@@ -352,7 +352,7 @@ static int qcom_ice_program_wrapped_key(struct qcom_ice *ice, unsigned int slot,
 	struct device *dev = ice->dev;
 	union crypto_cfg cfg = {
 		.dusize = bkey->crypto_cfg.data_unit_size / 512,
-		.capidx = QCOM_SCM_ICE_CIPHER_AES_256_XTS,
+		.capidx = QCOM_ICE_CIPHER_AES_256_XTS,
 		.cfge = QCOM_ICE_HWKM_CFG_ENABLE_VAL,
 	};
 	int err;
@@ -370,11 +370,11 @@ static int qcom_ice_program_wrapped_key(struct qcom_ice *ice, unsigned int slot,
 	qcom_ice_writel(ice, 0x0, QCOM_ICE_REG_CRYPTOCFG(slot));
 
 	/* Call into TrustZone to program the wrapped key using HWKM. */
-	err = qcom_scm_ice_set_key(translate_hwkm_slot(ice, slot), bkey->bytes,
+	err = qcom_ice_svc_set_key(translate_hwkm_slot(ice, slot), bkey->bytes,
 				   bkey->size, cfg.capidx, cfg.dusize);
 	if (err) {
 		dev_err_ratelimited(dev,
-				    "qcom_scm_ice_set_key failed; err=%d, slot=%u\n",
+				    "qcom_ice_svc_set_key failed; err=%d, slot=%u\n",
 				    err, slot);
 		return err;
 	}
@@ -422,8 +422,8 @@ int qcom_ice_program_key(struct qcom_ice *ice, unsigned int slot,
 	for (i = 0; i < ARRAY_SIZE(key.words); i++)
 		__cpu_to_be32s(&key.words[i]);
 
-	err = qcom_scm_ice_set_key(slot, key.bytes, AES_256_XTS_KEY_SIZE,
-				   QCOM_SCM_ICE_CIPHER_AES_256_XTS,
+	err = qcom_ice_svc_set_key(slot, key.bytes, AES_256_XTS_KEY_SIZE,
+				   QCOM_ICE_CIPHER_AES_256_XTS,
 				   blk_key->crypto_cfg.data_unit_size / 512);
 
 	memzero_explicit(&key, sizeof(key));
@@ -436,7 +436,7 @@ int qcom_ice_evict_key(struct qcom_ice *ice, int slot)
 {
 	if (ice->hwkm_init_complete)
 		slot = translate_hwkm_slot(ice, slot);
-	return qcom_scm_ice_invalidate_key(slot);
+	return qcom_ice_svc_invalidate_key(slot);
 }
 EXPORT_SYMBOL_GPL(qcom_ice_evict_key);
 
@@ -473,7 +473,7 @@ int qcom_ice_derive_sw_secret(struct qcom_ice *ice,
 			      const u8 *eph_key, size_t eph_key_size,
 			      u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
 {
-	int err = qcom_scm_derive_sw_secret(eph_key, eph_key_size,
+	int err = qcom_ice_svc_derive_sw_secret(eph_key, eph_key_size,
 					    sw_secret,
 					    BLK_CRYPTO_SW_SECRET_SIZE);
 	if (err == -EIO || err == -EINVAL)
@@ -496,7 +496,7 @@ int qcom_ice_generate_key(struct qcom_ice *ice,
 {
 	int err;
 
-	err = qcom_scm_generate_ice_key(lt_key,
+	err = qcom_ice_svc_generate_key(lt_key,
 					QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version));
 	if (err)
 		return err;
@@ -523,7 +523,7 @@ int qcom_ice_prepare_key(struct qcom_ice *ice,
 {
 	int err;
 
-	err = qcom_scm_prepare_ice_key(lt_key, lt_key_size,
+	err = qcom_ice_svc_prepare_key(lt_key, lt_key_size,
 				       eph_key, QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version));
 	if (err == -EIO || err == -EINVAL)
 		err = -EBADMSG; /* probably invalid key */
@@ -551,7 +551,7 @@ int qcom_ice_import_key(struct qcom_ice *ice,
 {
 	int err;
 
-	err = qcom_scm_import_ice_key(raw_key, raw_key_size,
+	err = qcom_ice_svc_import_key(raw_key, raw_key_size,
 				      lt_key, QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version));
 	if (err)
 		return err;
@@ -565,11 +565,11 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 {
 	struct qcom_ice *engine;
 
-	if (!qcom_scm_is_available())
+	if (!qcom_ice_svc_ops_registered())
 		return ERR_PTR(-EPROBE_DEFER);
 
-	if (!qcom_scm_ice_available()) {
-		dev_warn(dev, "ICE SCM interface not found\n");
+	if (!qcom_ice_svc_available()) {
+		dev_warn(dev, "ICE firmware service interface not found\n");
 		return ERR_PTR(-EOPNOTSUPP);
 	}
 

-- 
2.34.1

