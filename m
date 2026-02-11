Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93506366DC5
	for <linux-crypto@vger.kernel.org>; Wed, 11 Feb 2026 09:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770803298; cv=none; b=GAQWTTd2VWPCmlAyIElbX0QrcPxY4C/WzzWeGOmBXdLnMGbyaDp+GgfV+XJYRsm20Y+cQLiZa4HtT9T4cBZmoB28sA7focecgD/b8kDEMaajvXq0dIfVrzxMfyrNPdOBpA91AKOmLGUZz60xjQxmNLST7i9jE11g4lHv94lZxrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770803298; c=relaxed/simple;
	bh=ErJkRgjBn3kKndkizVQHXkQsIRTnMx+SsxhZmXO0g4M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CHtO8rJ+LSLq+LN6NjM0hS3fk3MOGqO7DiMx8+4w5rQmwgoUc83BVOrzK4jEtnJ40NkTlEfm12rwryKnCV7QJN7t4SADikjoQPUOijOdR3n/EkfiM8Jdi1/aQW5XhoyZEpA335yEWEUMpSlf2OVEbb50ub+rgUkw3N95RRcRb+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=H/Ac56Cq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YGCS2E1J; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="H/Ac56Cq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YGCS2E1J"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61B58D0k4013638
	for <linux-crypto@vger.kernel.org>; Wed, 11 Feb 2026 09:48:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TsVRt6v8DspztJLCo2JToFVZCJzTWengupu9/MmG2/c=; b=H/Ac56CqqD9ny6nO
	sFV6m0DbpMQZbIyeahh+s5P10jaay2+Vk5ESk5ASNCVw0abuT4pZ2+yLfNXF8Hit
	BuTpgyQFjl8VxvkoJRgj0dRcLGq5+vbfRoC5Fi66tR909+RnHGWfOxumxYGMrI1j
	IB3G0/Zt1obrrY4W4qtchJCY9GhUyn1FHsGTm2ts2lORfmfYM9neBO9Dmmc8xM4H
	NV/obGSGx3THDn0dd60sWNZqKWiGyvZZdsO0L/mMBZSSYP/5Wvh96nWClmxXNmzD
	il5LuqS2ARn2QfBlsmZZs9hwGeCFMf2o+POUtT8/Ei9wNLoN4esoJ/WNNIicGiI+
	bY+TXg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c8aadagxr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 11 Feb 2026 09:48:15 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3545dbb7ee6so1524537a91.3
        for <linux-crypto@vger.kernel.org>; Wed, 11 Feb 2026 01:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770803294; x=1771408094; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TsVRt6v8DspztJLCo2JToFVZCJzTWengupu9/MmG2/c=;
        b=YGCS2E1JQ8IWd+yPcsKtLK1cxL6MvLHvBE7JbZ3XcziuaLYC0Y7nrw1FlvXaVGSuui
         k7Umxki8NwuAXUMXNYC0Vo/+m4pFCmL8SajXIth0A89XeaUq7j/X51zvrtrSg8L4hF9D
         Di+yt7PLVUQmTMO9WGM2/M2LFZK2OyTP2wiG+vqRd8gTHLXoTunK6ajM30hBuSkNpBT7
         EPiDL0H7J+CTT3wFddmvE+21UUEUdYrxsBcmxY/ve7wvJHSnAn3+Q6Fm2ORG58PcZ8yy
         fhf+BOySNtib3OaDFxJjVpXU6zM9210/4RPOsHOTCYD2gwhVt5CXTqxbsHoJjWumf4/d
         0yMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770803294; x=1771408094;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TsVRt6v8DspztJLCo2JToFVZCJzTWengupu9/MmG2/c=;
        b=uMpy3SGO0LmsQVYUx20MqtnvQAPw34mGlbacctAj5/jB9crPtWgBjKB1JN/DkSbYtz
         FGgjHXu77fvyYhypzIEONaiyKQqpXnjic8BuOO/ja82dp82hzz8NeQckjaAXUV8E6u6A
         uNXFyMa1fvscdsK025DEAK2KPp31dSl7Y7vSwaxMXqd4GZ7yBsAxuNS436MrlxKHcGY+
         0GsDVl9Agb0TdKnaSRg6LWe3Cjw4fNQcU+wjm75sSLpMtRDyngxBSzdIIyKd7/ApQtk+
         Jufrxvl58buAjjwnApt20WEYakOngtZ19hNPuJ9PwyV7aV6G+2xnumaExLSH0CUMYYvq
         1VVA==
X-Forwarded-Encrypted: i=1; AJvYcCU0VxMctfrB4wiaU3zsCB2wTSq37DeMjYZavLeTkmV/k44HygOhgjTAhNi+VMNM5EbaKmFbEhz1C3/vwcI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI6Hj5vdYurI+Ekm8P+mgZvhimm/G2GZXL2jO4yPmWq6IpmXK3
	xn0leFETDEMhdypH6sK/iWlI0LuZx3fLRjh2FWE9qbARoo4tirtoVN7f9cXHxzmZmnhSK2jo6sI
	260jam/n14wsY6wtdkQPvAJTt3WX4L4Er8/86rDMELXCwdzkZBrzvVZ9T0bFXn1UDuCQ=
X-Gm-Gg: AZuq6aLGMUaPkAUMLAFBV7XWEvvggUjWtVJGHoo+1jmVl3mdtqXoib+wtiN8PXDgS8J
	1bypBqiJNHASdURAfOK+9q4D9j28KZ1V47IuWe6G/8GJAA09le0tiEQTI4opJlbX34Vu02NOqZ7
	j95W0kjoTzErXz17+I1PRvQtGhhsntVm7sI7naz69wJ4F85EW106fXABpp7LTlN4oAR0YePUrg7
	QrYYxJkHrD1gVPX0KZ67vaSmGzk7McT0Lz2tApMI9gFWREzxzYGyFvpjFYNgwLLdVwpg44kD7F9
	xNf3Iyv03BFL+qwlo1paE2Dl3cuktehulnVZ72q0GkG1e98fr7ACJxszqXffi1I6yknpSSxRyjh
	+eYsFpA5k0bEUvZbEH/nInM/CVPw4lWQBR1UfHpkpGI0NqGUoL+mZMCH7eds=
X-Received: by 2002:a17:90b:2750:b0:354:c3a4:3a2 with SMTP id 98e67ed59e1d1-354c3a40bcamr11698248a91.29.1770803294432;
        Wed, 11 Feb 2026 01:48:14 -0800 (PST)
X-Received: by 2002:a17:90b:2750:b0:354:c3a4:3a2 with SMTP id 98e67ed59e1d1-354c3a40bcamr11698226a91.29.1770803293978;
        Wed, 11 Feb 2026 01:48:13 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35662f6b84dsm7526640a91.10.2026.02.11.01.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 01:48:13 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Wed, 11 Feb 2026 15:17:46 +0530
Subject: [PATCH v5 3/4] ufs: host: Add ICE clock scaling during UFS clock
 changes
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260211-enable-ufs-ice-clock-scaling-v5-3-221c520a1f2e@oss.qualcomm.com>
References: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
In-Reply-To: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-ORIG-GUID: s63osVAjeJLkaiVUHVet4-wUzTbkQWOQ
X-Proofpoint-GUID: s63osVAjeJLkaiVUHVet4-wUzTbkQWOQ
X-Authority-Analysis: v=2.4 cv=OoVCCi/t c=1 sm=1 tr=0 ts=698c505f cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=6u5mSuNpuy9df7-r3awA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDA3OSBTYWx0ZWRfX29VyzogGh6Rv
 WRdjhbJfZU9sTaVoqFYd1+wfLssLyicpObMU3DpRIwE6TJeY4Bd3xpdALduoATRJVoeMki7QYiZ
 RHraiv/rAKLZRqo5xKrAQOrLUORFu7D1i+GMIJybV35MIQvEtOllAw/MH8BSdWp0W1j7plfHcmY
 Oth8B/ynWutvHDMB7/mGyyCLpJd3XEZVTrJT2O42HRtlYuo9xCNGQig5LF9vrABK0fQQw2fy2UZ
 iLpjMvFTS+6oGJbZRCyPh7jW9VpeXanmwso8wrcdiWBxpW7z+j4UwUSktzBYyapJtgb7yI9eCxb
 VL/4SUb4mAj3ArqngNUDRDBfa/SkSnveFSPOSV3dfn+4BKaoMdOTt6ExvPRa4of4E/lUvz8OBwG
 G5662EIHvJEaCKRPDC+xC+1TW5Bs5YNh/f81wr+jud8qHimQoTFfZ1xLqmOoJ7uXvVeNDoP/Knd
 DekNLaLqd9SiOA7rVbg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_03,2026-02-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602110079

Implement ICE (Inline Crypto Engine) clock scaling in sync with
UFS controller clock scaling. This ensures that the ICE operates at
an appropriate frequency when the UFS clocks are scaled up or down,
improving performance and maintaining stability for crypto operations.

Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8d119b3223cbdaa3297d2beabced0962a1a847d5..00cb9cde760380e7e4213095b9c66657a23b13ee 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -305,6 +305,15 @@ static int ufs_qcom_ice_prepare_key(struct blk_crypto_profile *profile,
 	return qcom_ice_prepare_key(host->ice, lt_key, lt_key_size, eph_key);
 }
 
+static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
+				  bool scale_up, unsigned int flags)
+{
+	if (host->hba->caps & UFSHCD_CAP_CRYPTO)
+		return qcom_ice_scale_clk(host->ice, target_freq, scale_up, flags);
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
+				  bool scale_up, unsigned int flags)
+{
+	return 0;
+}
+
 #endif
 
 static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
@@ -1646,6 +1661,8 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
 		else
 			err = ufs_qcom_clk_scale_down_post_change(hba, target_freq);
 
+		if (!err)
+			err = ufs_qcom_ice_scale_clk(host, target_freq, scale_up, 0);
 
 		if (err) {
 			ufshcd_uic_hibern8_exit(hba);

-- 
2.34.1

