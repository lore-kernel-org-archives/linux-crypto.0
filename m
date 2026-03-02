Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A26358D14
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 10:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772448588; cv=none; b=UH/dkCbTmUat/0aENI2CTSKCeONVgwjRNaTuQorlBQcvpxZxaWJsCK2xCuEfmpEG+cDJOurhm3QuFdrFj+rrz+SaR9sJ4gHOlRQSQ1g6J7PLaYHnSYIGgupZHiYVs8tJ+yieRgRJnrgahumN/TI6RawqlXe79IqB/FHkRcQIoAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772448588; c=relaxed/simple;
	bh=mfM49L/JlScpAh1lc54xaOqcbMJKZaGfYSNwP9nyX3A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=oIESgQx+XuLTHZPjwDg9K4NfXUsDld33hT8VPdFcJYPZpi5FOtzAVPtvn5Q78qYR4BXULS90EoitRbC5hnVD3d8qwLD6U9x24M2hgHP2Kgr4wD3Sk8o3yUQG7PJhyY8dtkJwXMKA5eW+i8eRlqmoogJUvaA6X6OJS1hyxyVvB3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eypjoJ99; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Wu5y/lhY; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eypjoJ99";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Wu5y/lhY"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62287K6n2258101
	for <linux-crypto@vger.kernel.org>; Mon, 2 Mar 2026 10:49:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	i0apK8FaEc2TmE79ix1tcZBYr5HjYS95uAnJxvBt9u8=; b=eypjoJ99/d3m/sQh
	stSQWc9+K8/8zThn+VYW3AaX5nIfxYtWBCKBsbFEzebg0hQ5zKFLRpZDUftH2Ys8
	XGEZhiGXCZoNpiumxEOvDbEohmuR9t1kI+xO5JWYUYkVJ3ic/621UHPS8iTUCGH+
	jNWwzFbBqwSsPj05OqV7Ok4feeL+pKvKxYPo24/WOznhDoBu0k0uQLPglaYODOvF
	zldvNJeEzb3HTr9RfJOZ/pUk5ycak5SJavjRHY9rWOGIG33mNdaWK1Tqu9BfDqVi
	gegqYEToTM5kwg2f9oG0MmSrY18+Q4QD86wZt6thapkLcKLDxDwQY2VXlhTB6P5d
	PPN78w==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cksfd585u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 10:49:46 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c70b75aea3aso2484701a12.0
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 02:49:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772448585; x=1773053385; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i0apK8FaEc2TmE79ix1tcZBYr5HjYS95uAnJxvBt9u8=;
        b=Wu5y/lhYUipP1mT3fvSQj2EocdO7r65lGzNIVoISxIKgx8LRWLVX+M6ZSFBKcLjQ8n
         ykY1E8E8Q5X90jcSfGPejeHrY8n+Ix7OG85G/O52UNw0l7hmK+146mPxFAkFHBWY6Z4h
         hJHgH3x0PEQiHc4ordeOr7U79k9G9gD8ezsN+wdfX6s9uauSd4Vvp6D4tenizopuGJKQ
         6toZmWDlG3wk1CGov7LgYNGEu9dtCjgMJkNg8oqNX4/3VyA39HRVK14uWmz7A8VE2Fzj
         JyPCbisHcWuuhKxi6zUjDsNst5C9fVbLrCnfYRb1M6Ct0CY3osJJkHF2Buvw4CYJLDjB
         YFJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772448585; x=1773053385;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=i0apK8FaEc2TmE79ix1tcZBYr5HjYS95uAnJxvBt9u8=;
        b=YUu4xPeJinsuM+KYwjUKqkmc6Rc1vm61R5t2t0NcCqaKXR2onmuCSU8U3DAZvdNiaP
         g2TJOuTvcaJIJrm6EN9N4oczxciBy9pkAacu2izhuQZ3ampZi4b8ipuhjfSLOFq4PHpg
         Zp4QnzY/pezRf0In2MzdY2UKpVLbqxwDrKLN6unIUq0p0jECHACh/JnUtfyZu0hJQkRr
         6i6K7CKJ45fOn7CcT+hMbwVSEOdQ2L22RG+62ZygRSq6r6/FE+AqpNacZZZOPTm9dEii
         NAgtqAToisWxmGDGWXCedHmbZVKSTaVn05bo5uTxif9Mk9cWHsSPQZE7a/fHg7AZLtjR
         MMdw==
X-Forwarded-Encrypted: i=1; AJvYcCWqTMiQvroElAB8pkeHZObqBrhPZzNioYf5lSjQJIzZv3HSD8LlsAcMuZh6+xsigliRU81kFE9D3Knr4rw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywg8pJk7Lp5SwoefZdKWrfxjkSq7kt2dzoY0MJpsd5RVQgYm4Ok
	xm1wC3FM/ZMTpmS7u3K7aCmIAqbOyMIIBeDzIx/y/R8aTh2eYEgqS8RHcf158zy4yM4sFFu0BJb
	5ST60h3AS2rnqxLjnkwPZHuHHCqUnFrJAGNcnJtWena0w6sTdjbdfHJLsLUARgvil8kVFZxEODM
	g=
X-Gm-Gg: ATEYQzzy+tAtk/I0fTPes1TPMhfemMnEISYMesxQNiHyjM2oUHW5N2nZJondEFslrr1
	clLAsnVBoO9xY+1hfmJ4AxiH/B4KZoVQhL1Tx8jRTdfJRJURYsGlA6FXlTdpqLIePCJfwUT5nNY
	D/edAK4m072aWQ7TfsPDGW1zcH+hVpsorIbTfTWrepRUslr0Cb7uzwTTyx1TkE5B3D+utcsBJZh
	5geAGRk8LDKuv5qjJnx1yNtgPKHZ+Ih0zVXaGwHhs0tdpEPU/lUm71mj42qDjNpaj9mbGVh+AKr
	DYvG69U0PM3wifX1NHJKCTUdEbic3d6WM0VD51etELzj6Sdfilvn7KL+dtZDjfUtHrDwRZrVfIG
	c4C1EPmVBEQBn6zif/UJQPcrk4c++ewtYg1w7C95wACDp+cnhyH3x9iZAB5o=
X-Received: by 2002:a05:6a00:b42:b0:824:9ffc:256c with SMTP id d2e1a72fcca58-8274da07aaemr10122578b3a.43.1772448584802;
        Mon, 02 Mar 2026 02:49:44 -0800 (PST)
X-Received: by 2002:a05:6a00:b42:b0:824:9ffc:256c with SMTP id d2e1a72fcca58-8274da07aaemr10122554b3a.43.1772448584299;
        Mon, 02 Mar 2026 02:49:44 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8273a054b49sm12225956b3a.53.2026.03.02.02.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 02:49:43 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Mon, 02 Mar 2026 16:19:14 +0530
Subject: [PATCH v7 2/3] ufs: host: Add ICE clock scaling during UFS clock
 changes
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-enable-ufs-ice-clock-scaling-v7-2-669b96ecadd8@oss.qualcomm.com>
References: <20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com>
In-Reply-To: <20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-ORIG-GUID: QENipOP6n0kIh00DiTTiJO5QEArlTXlw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA4OCBTYWx0ZWRfX4WvetiEAg2cP
 bVN/YsUIuLHlBOPMR1K0FRjTZmqSswC6lVpg+YMqRxCTghfwCazXvPG5CTTQFkDJN02+zbCxRt8
 zFxCMeHk5/FFu4D+Kh5yvoxrUg4v/Jgq6g7H/qudLE5U7/TCplvHiLxyXXt+YVjtAgcRwwOBoaG
 P7KBYJZTQoitv327no4xrLLbsRgB4Xo7J2Kz7u8qUE6K3XZpsLF6AlZTJSxe6P2laN95+KKeAOC
 lXjsnl6aJ3jT8cz9qFpSyTFbj3DTuQYDL7O7W5leHc0rlbKRXjLfKCraqslmplULbrWI3CUJaga
 NbddZF5ZKAi/J8AN8hy7v8Qg3tjuy2Rr7C2QGRYJxDkbUmAvYfHvQbRquLsizkunJHLsxKY0jyi
 20apujFr7pWZl6/8UdGIuMAlNf1M1pZ04IDeUQIK4+ua7CeuFxvcfFFlkI4BAeUkbiZoKEVE3tr
 XTE2tT+WaW3X+K6IL7A==
X-Authority-Analysis: v=2.4 cv=HKDO14tv c=1 sm=1 tr=0 ts=69a56b4a cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=-RVjIYUuWhs3u9hRN0oA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: QENipOP6n0kIh00DiTTiJO5QEArlTXlw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0
 spamscore=0 bulkscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020088

Implement ICE (Inline Crypto Engine) clock scaling in sync with
UFS controller clock scaling. This ensures that the ICE operates at
an appropriate frequency when the UFS clocks are scaled up or down,
improving performance and maintaining stability for crypto operations.

For scale_up operation ensure to pass ~round_ceil (round_floor)
and vice-versa for scale_down operations.

Incase of OPP scaling is not supported by ICE, ensure to not prevent
devfreq for UFS, as ICE OPP-table is optional.

Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8d119b3223cbdaa3297d2beabced0962a1a847d5..776444f46fe5f00f947e4b0b4dfe6d64e2ad2150 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -305,6 +305,15 @@ static int ufs_qcom_ice_prepare_key(struct blk_crypto_profile *profile,
 	return qcom_ice_prepare_key(host->ice, lt_key, lt_key_size, eph_key);
 }
 
+static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
+				  bool round_ceil)
+{
+	if (host->hba->caps & UFSHCD_CAP_CRYPTO)
+		return qcom_ice_scale_clk(host->ice, target_freq, round_ceil);
+
+	return 0;
+}
+
 static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops = {
 	.keyslot_program	= ufs_qcom_ice_keyslot_program,
 	.keyslot_evict		= ufs_qcom_ice_keyslot_evict,
@@ -339,6 +348,12 @@ static void ufs_qcom_config_ice_allocator(struct ufs_qcom_host *host)
 {
 }
 
+static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
+				  bool round_ceil)
+{
+	return 0;
+}
+
 #endif
 
 static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
@@ -1646,8 +1661,10 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
 		else
 			err = ufs_qcom_clk_scale_down_post_change(hba, target_freq);
 
+		if (!err)
+			err = ufs_qcom_ice_scale_clk(host, target_freq, !scale_up);
 
-		if (err) {
+		if (err && err != -EOPNOTSUPP) {
 			ufshcd_uic_hibern8_exit(hba);
 			return err;
 		}

-- 
2.34.1

