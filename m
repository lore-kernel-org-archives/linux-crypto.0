Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792662735;
	b=xHZZDF/mu8awSjye+LkywFyM/AeVTJWh/x3V+UpP+ea0a0bl3LKtAGvTnf21zjo10/9c
	 mCBzWihWkiYThyzFjtYyUujkNZdNBwr+m7/Dsr55wUHAuNUHLlaGVnXdFhXD7XrzdTn81
	 B+Ca43yWmkPzYogWWfei+Tzy3Hw/ZZWlc7y1/SSDHiKMtZtMZfNwgAluBqszAm9gsmJ/1
	 /3JjHXQEOQ1ZvxnoUTCgibuDHmiHmuQWGUtK3er/KxsBt2iNoCqZbd6pIVhsQ+GEsBDXJ
	 6k6+p3+ul1K9yXDcrk3pB9nYbEnATXat+5N4U+TN4t62dHHZpHIsJwAoZ5Tf8rVjBDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792662735;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=LYt9rd0NfUvWvMCN389zamkO3Dpz4pDQJgC5BLvRDzI=;
	b=b5BmfF1O8wPN0e+kNhikvt1PLi/ZPhTA1NokTOlXoYMAEb44pp+fwGvPrpUhUM1zR5Wo
	 xc+tPLXCYY5zQv0cf56eq2Fu01cuUqRSfnR6a9w7T0lxgOoUO5n/frnvIfSQxoQe033yy
	 d0ATdvajaS39yPBqQTXckdNDgPgdcae/CzPmna6dsXUtR3XhTtb7xYWIjLJMqoeh7Son3
	 BCXjJZP3Y59oGzvnwEsHfr/1G1Evk58TVRk7GxpxCSdy5Mwl2P8ULJvlIBmy6K0qAB7mJ
	 Y/f5xSwC9kTXIsIdhuSEpfwxS6C2qOd7tvxK6W0R+PdO+0BiobxlXId+vCCGdxSCieQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=V7hWSRu9;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=S0nZXerw;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC6E606A327
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 09:52:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CC6E606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=V7hWSRu9;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=S0nZXerw
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69M9k0Cg3396592
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 09:52:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LYt9rd0NfUvWvMCN389zamkO3Dpz4pDQJgC5BLvRDzI=; b=V7hWSRu9CGmPGUBC
	bZyvP3ha08wYeCIRvaVAPf/Gf0eROu3Z+K5s+mYmzYCcNhtpkElunwVNidvyEcPi
	MIUcxkQO/g+NQo5gc8XQ56j0TSEDKn/cUx1F0V/yqj8Zx+T1/T/y8CArBSPKlEdv
	L6l/yTVBr54ftOBjtjfq/ekDUhtwAlQm8F9anGn8Nu9e9H6MPALxkFwHiRefp30c
	ZsUQQINiFPylOoeuUrltHHHsislSUuXdAFY3rOz7yfSzwLpAufNChre5xP1NUCkl
	PZ6rveCA/3Ab3nzgeVEZhKC5tOvJx3BS7LNetHjJhglvgMcAYj/0xt/OeMR0lS/s
	rCgZaQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf93asr0s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 09:52:13 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso3157667eec.1
        for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 02:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792662733; x=1793267533; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LYt9rd0NfUvWvMCN389zamkO3Dpz4pDQJgC5BLvRDzI=;
        b=S0nZXerwXws6OKBZcUgBzInHxXP4VFvZwXGQn90ulcWdVZuI6xhjVVUdP06YYAQEMJ
         fmlPZAJZjY88LUThaJxdXfTrdcl+rSczTm5LAUGQ9RggnRNQ0WJsCjITBGcDRGdGQH99
         ndNTQKbkDlqPWOEbocYjiMrPBsuBlgSa/6iNOhgt6d1aUTKxPi6/wvE+R9mvfZTvhzCq
         +ngDZkRMJEwV7ZKB7GWRp+XIjsYyPKgNy6pcu6ofEGOzptWhWnVfgKKdBDMWXG2UiyID
         8cFS1rVV8VOKB6rHj4Z/R+jKWC+x/IRv+DRbfy8lYhiEPT4KtoRssLt6tKvWHhGKbtTe
         uswA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792662733; x=1793267533;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LYt9rd0NfUvWvMCN389zamkO3Dpz4pDQJgC5BLvRDzI=;
        b=gu5zmtvsunPC2h24C+w8ocnSlZ8yd/5xUm7LjjenB19urIAFctd0BC54VNeeS5G+cP
         RA2eO+sWANIMjjJ5gVx92Nj5tUjaUsbPwR048xiPgEzqKZp2rpPNgN9Tq41k10ge9GWp
         loOrxZ8VFgyqS7t96RlEGohuFHJ+nyppCyGvqYLMwNBrffHbjcdwZA49IuJUhwKASf21
         jYp/cD8Iyh5LBQEwyCmmiOJCYSdEprlk5LPFFlkz1HP282eczhJwIVT9ib+CfxWaGfRu
         ePsIRkd4567FZ2Q3L49MdVfPhdZbPuH3oU5YQXAA0L0VT28v7la9IMhl1g5eREdPWM20
         fJ7g==
X-Forwarded-Encrypted: i=1; AKwUvBx7DxiCE2LBM8wybXXTH/6xB1D5PU/fIsmEyUYzTeeytDDTjMItNqrfmJzdgOVT+p26U8kyIiwGyFtHy58=@vger.kernel.org
X-Gm-Message-State: AFq9FYIxtkuQgEHSNL7/uUQKZ9kywJ30B3oX7vegy3TbgPojBicprnVv
	wz0HrC9zaAkvRPXP/mNTpIeRMYDq2VvpiNIWh/qMjulh6e1St34VpfuxB73u9S57RohOXx/eeRD
	kguTU0gtcuzWkBBV3oRv0Ftt2iQ4WMQuFdIHswwd6eljinXfPDRSsum90anVsu+uyBqc=
X-Gm-Gg: AYBFou0R26ZthJYtuUX+Jhh0fdwTWkNyVf4sQWdYHkKNXotTqTyrFqrXsZerFogCLrw
	Gz6QD4IlopiBlxKnDz314wdgxXtzQjKLslcb0FAY43hGGoBn0GwlhMLyLCYXY1/sXw3fe1hWjb6
	tPOaoQgj8oSxvdmYAcRp2olZIFuRqpic3QXnSNisaMUC39z3u1c6PSciXqc2JYGWYteeiShtadg
	miQhLeonGBP7zELTkO1K3LuU8zjFpexruuOUiMEwiSnZXdwngr9OXojdbS2OzqAgolR11VLOvOh
	DGuEiauzk/Wcn4Oa9B3FkLJb0p5hG981WS/vZ7nT/mN0bDmWS+CGRJZuTFMXjW6zWSSF2BJHeKC
	rl35av/U1tSYmvX5Bda1JB9f6aH4saCTq
X-Received: by 2002:a05:7301:1885:b0:366:703c:5ef8 with SMTP id 5a478bee46e88-3674ce2fd08mr6635028eec.7.1792662732849;
        Thu, 22 Oct 2026 02:52:12 -0700 (PDT)
X-Received: by 2002:a05:7301:1885:b0:366:703c:5ef8 with SMTP id 5a478bee46e88-3674ce2fd08mr6635001eec.7.1792662732279;
        Thu, 22 Oct 2026 02:52:12 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3673e153519sm15742170eec.3.2026.10.22.02.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 02:52:11 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Thu, 22 Oct 2026 15:21:51 +0530
Subject: [PATCH 2/3] ufs: ufs-qcom: Enable ICE before enabling crypto
 support
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
Message-Id: <20261022-qcom_ice_pm_enable-v1-2-f7a84086c651@oss.qualcomm.com>
References: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
In-Reply-To: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
To: Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDAzOSBTYWx0ZWRfX3QGyoqwxnAiK
 gcYcGR3NLwpr1fWzSzSq+8gI8rbYAZYUL4hzmSBaczpOQZPYneOXwMB12SO0GXfNw3hT4Yu502z
 JdBVtNY1kN9R2c+8MZNtN2W5IrurkjEKMVJ3ArSwgJ7WomD3H2sxQA7bX8tbVqcWaDnmjGJIpFD
 A6PkA7/OYJFkWPVCN4FMboK8/tFqGQqiCXU33kZfmXJkKVm8M8fjpeWpXh5KBu595h23XVHb9O5
 gvhzr1jtz6I5THa3lpMcR/jzw3WlA6qc2jTqpSK7+45uHr4g7mwwvGA6x2vXM6TN10/9FFLTZ6u
 I2UxJbqDlmxmICSUKHPc2oFSX8xzpWBrAX89O97o5qdJNXbbKLYFJm+2lDBPbC7Jzm9OUZx0SSJ
 q4Vk4Uj5i7/vAuXXZvbBgld/2QAwyk3jpkAk/3OlQQMgMQN8K53t5w/RizZgytvUpeuezTqm/JV
 yd2e+qHrsousWIOywyg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDAzOSBTYWx0ZWRfXwFxfq0+9TEi5
 PkXiaNEOUMJFIWIM4wOmtriJhBpw3yWEQpeuPAPJ96nJBNR97XU2a2D+q4pD2h0fx1WVHBQEZHd
 IR1hOeDHFaBeWEzQBzpwCq2fp2dvjvg=
X-Authority-Analysis: v=2.4 cv=QPn91QLL c=1 sm=1 tr=0 ts=6ad9dccd cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=poJO1rpmugtNz4m0g9UA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: fMIujM-OOxqMK8El4GZH7Gg9-t0I9HKx
X-Proofpoint-ORIG-GUID: fMIujM-OOxqMK8El4GZH7Gg9-t0I9HKx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610220039

ufs-qcom currently exposes UFS crypto profile and sets UFSHCD_CAP_CRYPTO
before enabling ICE. This leaves a window where blk-crypto can issue
keyslot programming calls before ufs-qcom has explicitly enabled ICE.

Similar to MMC, UFS also works today as ICE clocks remain enabled after
the probe, but it should not rely on that implicit clock state. Once ICE
supports runtime PM, ICE clocks can be suspended after probe, and
accessing ICE registers before qcom_ice_enable() call can fail due to
unclocked register access in qcom_ice_program_key().

Enable ICE during ufs crypto init path to ensure ICE is ready before
blk-crypto can issue key programming calls.

Also call qcom_ice_enable() from HCE PRE_CHANGE path once crypto support
has been enabled. UFS controller reset can reset ICE state, and the UFS
core can reprogram keys during HCE start before POST_CHANGE.
Re-enabling ICE in PRE_CHANGE makes ICE ready before reset-time key
reprogramming and for any later ICE operation.

Fixes: 56541c7c4468 ("scsi: ufs: ufs-qcom: Switch to the new ICE API")
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index fee9b54ba5e1..7e5aa4573e0c 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -158,13 +158,15 @@ static void ufs_qcom_config_ice_allocator(struct ufs_qcom_host *host)
 	ufshcd_writel(hba, config, REG_UFS_MEM_ICE_NUM_CORE);
 }
 
-static inline void ufs_qcom_ice_enable(struct ufs_qcom_host *host)
+static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops; /* forward decl */
+
+static inline int ufs_qcom_ice_enable(struct ufs_qcom_host *host)
 {
 	if (host->hba->caps & UFSHCD_CAP_CRYPTO)
-		qcom_ice_enable(host->ice);
-}
+		return qcom_ice_enable(host->ice);
 
-static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops; /* forward decl */
+	return 0;
+}
 
 static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 {
@@ -188,6 +190,12 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 
 	host->ice = ice;
 
+	err = qcom_ice_enable(host->ice);
+	if (err) {
+		dev_err(dev, "Failed to enable ICE: %d\n", err);
+		return err;
+	}
+
 	/* Initialize the blk_crypto_profile */
 
 	caps.reg_val = cpu_to_le32(ufshcd_readl(hba, REG_UFS_CCAP));
@@ -318,11 +326,12 @@ static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops = {
 
 #else
 
-static inline void ufs_qcom_ice_enable(struct ufs_qcom_host *host)
+static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 {
+	return 0;
 }
 
-static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
+static inline int ufs_qcom_ice_enable(struct ufs_qcom_host *host)
 {
 	return 0;
 }
@@ -636,12 +645,15 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
 		 * is initialized.
 		 */
 		err = ufs_qcom_enable_lane_clks(host);
+		if (err)
+			return err;
+
+		err = ufs_qcom_ice_enable(host);
 		break;
 	case POST_CHANGE:
 		/* check if UFS PHY moved from DISABLED to HIBERN8 */
 		err = ufs_qcom_check_hibern8(hba);
 		ufs_qcom_enable_hw_clk_gating(hba);
-		ufs_qcom_ice_enable(host);
 		ufs_qcom_config_ice_allocator(host);
 		break;
 	default:
@@ -660,10 +672,9 @@ static int ufs_qcom_fw_managed_hce_enable_notify(struct ufs_hba *hba,
 	switch (status) {
 	case PRE_CHANGE:
 		ufs_qcom_select_unipro_mode(host);
-		break;
+		return ufs_qcom_ice_enable(host);
 	case POST_CHANGE:
 		ufs_qcom_enable_hw_clk_gating(hba);
-		ufs_qcom_ice_enable(host);
 		break;
 	default:
 		dev_err(hba->dev, "Invalid status %d\n", status);

-- 
2.34.1

