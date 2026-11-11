Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794406667;
	b=n4ygW6ZEwWsRsjnygUSgoOBsFxV5xwllUDCpPE0m+jercEOG/JiH87qrLGIFBFLMEWlH
	 BXaVCFK8q7VGgbNNDco0M4ISMUXes1vqJpklvxgCpOoiIcSpPt1HpB9Z0/dl3PuWyZdZw
	 z7pVskuzW/s3blKvl60Xi6cCfZ0TbtRvjlDT2qqyl2+QhMLqSISFki7+Er7u8jVP+WTxa
	 a2JW6ED3Tka6rXz7G/5+ysGBx+X0xkC18FRExSVlqvpjqdfhN0VytNPnKAGYF9EQWBBtd
	 udFiCvRuBp/pJwvoq5kJckBoSHZjJFgdnx0e5ZJPRCl9NOe4kpIfePko0huU114tg1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794406667;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=HhRoZyukr7bYFeRhMV71r6ms8s0PMJeU4sBttnMmwac=;
	b=pbwWZH41aHKrhoMFMKeN9J3zlSYQsrtCKn0B0+cZUxYdej2ONPWwOYFT8DGjZnj7sFMz
	 sh6V3DJz/bIVE4tTshhanQ7wukIGplBl4Z1E34y9lbTdnOQ4N1gjPBiUEqaXGPDAnvIfw
	 7+6wex/j6xXchLtDPTfwdF9tkwWWp8ZMHZ7msoFU6DGnQtnzHkooQxORMqmDfdQQCW3uf
	 loBOiY4wKR4xu++nUDpCiAPdroos3lbwD5iGfIZaUCzrkKn6636s5VMfL1ND6pSti+Hv8
	 ZaDT0wy+11EZNUgmE11X93xrXbb3tCpR7ivv1eU0xfDVrOpuygZKXwuiPFEpuLkK5FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ddexLkBy;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=g9tSoF5C;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71310606A885
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:17:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71310606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ddexLkBy;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=g9tSoF5C
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABCZ2xw2001453
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:17:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HhRoZyukr7bYFeRhMV71r6ms8s0PMJeU4sBttnMmwac=; b=ddexLkByWfAtSnzT
	zBGdqas71W4aJJ8+f3UGgLZltK13cHbXI9XtJ8/YevWV1ySParxm1AO8Qy+eGRCk
	RKUiG5q2t3c3iWMPY+x/GZZLfF5hqE8mQUaazM9BmqtvRX8NYPqauBCj2VRHFeWc
	AlQdA4NlpurQMa9Yydgh9uEZvG4gdnTu4HSU8inRk+dp8FFbRMRB683KtH76Wcim
	PsQIj+6F9t4+xqkVL/vFlIib/xgi9INtpFyek8bswN4hJyWD5V/Nf9wwDbnR4pJa
	3wDwdlNSyAX5T+Z05fpYKSIM/JeTeViNvvY58JSuJZ9J4ZuZm76hsam3vQxoLo1V
	KrN/cQ==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hvdrh30p7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:17:46 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36ecd5db581so6103026eec.0
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 06:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794406665; x=1795011465; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HhRoZyukr7bYFeRhMV71r6ms8s0PMJeU4sBttnMmwac=;
        b=g9tSoF5CezKTnat9PAxczXODP1X9a5SrJWKiuRDe0z8+OYNHOjnBvBRgfuHlX9a1cm
         qRxgXApEc2DCFaWiljRwGKdb0drHoshjxvPkxZeiVqCCyWFDi74UDuIsgl5l/I/JKCuF
         fBtIfQ48mioLfWA8tD8g648rlnD36SAeddlYaNKbYOuxxpChOlVNh4tL5IjHTh1pUw41
         PC1VvPoVLxSpbVoFTtRuIcbDXokrLnzs9Z2htCaPNjXse1wpkYgb4a2eadyVvFWChx05
         IbI2GSgJmaJLGw1R4Gwlmc1hsJ9a4vDne44DrYmZ8CsNyYsJyZFyxoDO4mqSjLkRskwu
         7Hww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794406665; x=1795011465;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HhRoZyukr7bYFeRhMV71r6ms8s0PMJeU4sBttnMmwac=;
        b=2bYhCNuPqZc6XJfsxMfZ4nK91aGVr0aUG72cezhurDQfJqIVVDaaCRc4nLbTT9mCea
         yzEwZUJRJZgt7fdVAi7bATxoWOso4eY6cPvvyziJ4H+hQofGv60NGDLmfv3nWLpdHVBa
         9gKQrVxbxe/Ww+g7XT8RjFthbMRDTD0AZ8jY9QvFzFKpBHN5Ath3luLD1hhK/IP08Svy
         vGrEKkjiDexlYRTdivPkUhNAmgYjNlsJdI2DSflXW1rXMREgxPnnMrS/FwWm1zWR592H
         0zuWmT0ch4pgtEi3ESWQ38g5y41HSCFH91Uo50xI81yuhIfqteWeHP4Wb6mNKVyaSQKN
         35vw==
X-Forwarded-Encrypted: i=1; AL+hErFCnrmcdF/E0jGFKGzYoRfFpXP1GEC+8Uwu92kV1lRQ4B7jmMuF3E6qbL+UIbyRVVvzwpZroCGiz3t3Xas=@vger.kernel.org
X-Gm-Message-State: APuU4Z8lrlfINRSYM4Us9SxUJoSiVgw8el8QfFVZJJj8LNtmb+tgnkIi
	R0I5RV7FgTb5xtgo8XB9QZWwumGTjOQ/+R6n2XIW8U4kiUzpM0AalcOhEN5PRnrC3MRJ/dik6N3
	ci9O/eUSngDhl5vq5zEOc9/1fhkJsuqCl73IUz/vdYgzAtJyzYPSGoVHVUEIvYn4rISw=
X-Gm-Gg: AYBFou0P1KBRaXwQE/Ep/C2JQoePdF2q2vZUUsC/lukgDXou/j7ZFTZTQWrZfNoJ7bL
	0sM9kOfvGqOBlk3D1JlsAWvVfIpqvsxR6v2TExP2PZwYXGNQz4ILLt4ZOdAzOfRi0DuSYmSuI8T
	W7DJmHu+LJfCxFxbl9EYGeGNUsD9eXBefibYWwPUyHX9fbPWNr4QJgiSHh+PVWAga5zVYM7itCJ
	icvXq9A8eihqYDrLiguPEbwLfm+5rm4J+579j469Y1AqR+Esbpjjnolh53NT0jbnH9V8mLmK+US
	94u/x3Z3SChICtw4WYhAnANVCgVSnmQ/gXEUNuoOcByk7fC6YtjBXaUgDzXfY78mL6n2NM5fDAY
	ChBZA5y9evoS5k+7hbP0es9uqh8iRrmWxnkE0KLKdOek+Je4QzSwKs8MyH49eT23ahFDOtZWJ1Q
	==
X-Received: by 2002:a05:7023:a4b:10b0:1b2:60ab:1e9d with SMTP id a92af1059eb24-1b3c034aabamr2518781c88.37.1794406665329;
        Wed, 11 Nov 2026 06:17:45 -0800 (PST)
X-Received: by 2002:a05:7023:a4b:10b0:1b2:60ab:1e9d with SMTP id a92af1059eb24-1b3c034aabamr2518752c88.37.1794406664670;
        Wed, 11 Nov 2026 06:17:44 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b2fc09sm33747063c88.10.2026.11.11.06.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 06:17:44 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Wed, 11 Nov 2026 19:47:05 +0530
Subject: [PATCH v2 5/6] soc: qcom: ice: Migrate to the TZ agnostic ICE APIs
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
Message-Id: <20261111-ice-migrate-tee-svc-v2-5-29d19f6c92ab@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794406634; l=5172;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=qCnIYHdcdZa9tT9loLAe1P+MQ3/ypMPb3+Zoukl5PY4=;
 b=F4GkVG10NXqzfMwaQcRMHQozGvxXbfvPeyfh4EledV/a0ni62K0y/XVsCIdWdlufsgponbfwi
 5QwbkJo1iFQARevmUYe+JxXAHyWDWfQ59sFArCM3NCGP1J32w/wC10F
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA1NiBTYWx0ZWRfXwoZlkFdbjTAZ
 G3CTVFbvXHXHpu71fyX9NWtnUJtgUQcGfBxm3eDRd8FXfw5Dj2pvTnOGVBCIbR17S+e8XcObBKR
 mzJ8ZXCO6EeRhJgg3IR8rcon0PIqMas=
X-Authority-Analysis: v=2.4 cv=PoQG/AM3 c=1 sm=1 tr=0 ts=6af4790a cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=zftoU6j5KQ9PehORJHMA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-GUID: lbgx-twuQ_pu4xRLuRmVJBaveMaKnPtm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA1NiBTYWx0ZWRfX6T9MyzJuRhtl
 czVHFtejbBRDqdZw+6Ad/K1XyuBoVYtYvng+ALQFERhpelGCxciqdpV6MGc0EoY8WFArAaFRJz2
 2jEaN5VjQSI5CQe3fgJin9PkC4C+vWQthuLljQpCt+FBxEjwCUuFWoyl0k5gtPJhxdEvFKMRRwN
 Yk6MCnnfcFavdGhklQeDA3TmWi9vlMpTSfl05BDdTqd1WtQ6EIfA1VttPIOWO3V2C7CNzqIXxra
 8Ub5KvwJ0lccsLZZjP779HmZHNczJSIcDAQsLqCpFQPgttlx3FcQRpaNJ7GSLxaCL2PXvS0x7Jg
 AVpwi0lk9+IHiJ6ac9Y+XzPJdsmx6YSnYBJ22xZ5eNVD1QRgTc/P5s08FDMDjcWJ2dCK35d+A8v
 k1wOaOR4X1TCznonGjLkLgAMBoV4wrG11xp7ZodHrTUGne7DdesBZDE70aEv2AsN2AaHzYUyeMd
 BXYhFBnYweT3oUCQaAg==
X-Proofpoint-ORIG-GUID: lbgx-twuQ_pu4xRLuRmVJBaveMaKnPtm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-11_02,2026-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611110056

Migrate the Inline Crypto Engine (ICE) driver to the TZ agnostic ICE APIs
which re-directs calls from the driver to either the SCM or the TEE bus
based back-end driver at runtime.

This makes the ICE driver agnostic of the TEE firmware (QTEE or OPTEE)
running on the Qualcomm platform.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 4844621b7497..9bab177f7ce5 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -307,7 +307,7 @@ static bool qcom_ice_check_supported(struct qcom_ice *ice)
 	 * advertise support for raw keys or wrapped keys, HWKM cannot be used
 	 * unconditionally.  A module parameter is used to opt into using it.
 	 */
-	if (ice->hwkm_version && qcom_scm_has_wrapped_key_support()) {
+	if (ice->hwkm_version && qcom_ice_tz_has_wrapped_key_support()) {
 		if (qcom_ice_use_wrapped_keys) {
 			dev_info(dev, "Using HWKM. Supporting wrapped keys only.\n");
 			ice->use_hwkm = true;
@@ -483,7 +483,7 @@ static int qcom_ice_program_wrapped_key(struct qcom_ice *ice, unsigned int slot,
 	struct device *dev = ice->dev;
 	union crypto_cfg cfg = {
 		.dusize = bkey->crypto_cfg.data_unit_size / 512,
-		.capidx = QCOM_SCM_ICE_CIPHER_AES_256_XTS,
+		.capidx = QCOM_ICE_CIPHER_AES_256_XTS,
 		.cfge = QCOM_ICE_HWKM_CFG_ENABLE_VAL,
 	};
 	int err;
@@ -501,11 +501,11 @@ static int qcom_ice_program_wrapped_key(struct qcom_ice *ice, unsigned int slot,
 	qcom_ice_writel(ice, 0x0, QCOM_ICE_REG_CRYPTOCFG(slot));
 
 	/* Call into TrustZone to program the wrapped key using HWKM. */
-	err = qcom_scm_ice_set_key(translate_hwkm_slot(ice, slot), bkey->bytes,
-				   bkey->size, cfg.capidx, cfg.dusize);
+	err = qcom_ice_tz_set_key(translate_hwkm_slot(ice, slot), bkey->bytes,
+				  bkey->size, cfg.capidx, cfg.dusize);
 	if (err) {
 		dev_err_ratelimited(dev,
-				    "qcom_scm_ice_set_key failed; err=%d, slot=%u\n",
+				    "qcom_ice_tz_set_key failed; err=%d, slot=%u\n",
 				    err, slot);
 		return err;
 	}
@@ -553,9 +553,9 @@ int qcom_ice_program_key(struct qcom_ice *ice, unsigned int slot,
 	for (i = 0; i < ARRAY_SIZE(key.words); i++)
 		__cpu_to_be32s(&key.words[i]);
 
-	err = qcom_scm_ice_set_key(slot, key.bytes, AES_256_XTS_KEY_SIZE,
-				   QCOM_SCM_ICE_CIPHER_AES_256_XTS,
-				   blk_key->crypto_cfg.data_unit_size / 512);
+	err = qcom_ice_tz_set_key(slot, key.bytes, AES_256_XTS_KEY_SIZE,
+				  QCOM_ICE_CIPHER_AES_256_XTS,
+				  blk_key->crypto_cfg.data_unit_size / 512);
 
 	memzero_explicit(&key, sizeof(key));
 
@@ -567,7 +567,7 @@ int qcom_ice_evict_key(struct qcom_ice *ice, int slot)
 {
 	if (ice->hwkm_init_complete)
 		slot = translate_hwkm_slot(ice, slot);
-	return qcom_scm_ice_invalidate_key(slot);
+	return qcom_ice_tz_invalidate_key(slot);
 }
 EXPORT_SYMBOL_GPL(qcom_ice_evict_key);
 
@@ -604,9 +604,9 @@ int qcom_ice_derive_sw_secret(struct qcom_ice *ice,
 			      const u8 *eph_key, size_t eph_key_size,
 			      u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
 {
-	int err = qcom_scm_derive_sw_secret(eph_key, eph_key_size,
-					    sw_secret,
-					    BLK_CRYPTO_SW_SECRET_SIZE);
+	int err = qcom_ice_tz_derive_sw_secret(eph_key, eph_key_size,
+					       sw_secret,
+					       BLK_CRYPTO_SW_SECRET_SIZE);
 	if (err == -EIO || err == -EINVAL)
 		err = -EBADMSG; /* probably invalid key */
 	return err;
@@ -627,8 +627,8 @@ int qcom_ice_generate_key(struct qcom_ice *ice,
 {
 	int err;
 
-	err = qcom_scm_generate_ice_key(lt_key,
-					QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version));
+	err = qcom_ice_tz_generate_key(lt_key,
+				       QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version));
 	if (err)
 		return err;
 
@@ -654,8 +654,8 @@ int qcom_ice_prepare_key(struct qcom_ice *ice,
 {
 	int err;
 
-	err = qcom_scm_prepare_ice_key(lt_key, lt_key_size,
-				       eph_key, QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version));
+	err = qcom_ice_tz_prepare_key(lt_key, lt_key_size,
+				      eph_key, QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version));
 	if (err == -EIO || err == -EINVAL)
 		err = -EBADMSG; /* probably invalid key */
 	if (err)
@@ -682,8 +682,8 @@ int qcom_ice_import_key(struct qcom_ice *ice,
 {
 	int err;
 
-	err = qcom_scm_import_ice_key(raw_key, raw_key_size,
-				      lt_key, QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version));
+	err = qcom_ice_tz_import_key(raw_key, raw_key_size,
+				     lt_key, QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version));
 	if (err)
 		return err;
 
@@ -696,11 +696,11 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 {
 	struct qcom_ice *engine;
 
-	if (!qcom_scm_is_available())
+	if (!qcom_ice_tz_is_available())
 		return ERR_PTR(-EPROBE_DEFER);
 
-	if (!qcom_scm_ice_available()) {
-		dev_warn(dev, "ICE SCM interface not found\n");
+	if (!qcom_ice_tz_ops_registered()) {
+		dev_warn(dev, "ICE firmware service interface not found\n");
 		return ERR_PTR(-EOPNOTSUPP);
 	}
 

-- 
2.34.1

