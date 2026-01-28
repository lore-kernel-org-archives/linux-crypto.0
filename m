Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E74833A9E0
	for <linux-crypto@vger.kernel.org>; Wed, 28 Jan 2026 08:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769590026; cv=none; b=Hf047TY3agFqYK+CNR6COLCief8TRRGZRtnHKUodVM2tcGGgMXwb8beukMxvN1pQ4Es5kR6JPRYzCCC66ZsNWbR/2TzwoJykOfxBrpwSrI6oL/bXlZOgFGvOGwww3IyNK07oKlCYMzzzCKzmen0bgtgoyKS34CvzRcsszjLs9xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769590026; c=relaxed/simple;
	bh=e3TRfsvo3h7etqIQP7dqbHgjd/404D3QWc/LuJuSsiA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=L9rVDqLEKpqF2ZBl44wO5k54lcLBESFAPunU1A3sTEo7xyEv8QKcB5b/iB+7E/Z/vhHCM5s+CHF4nYqQRQBaV7oPMpuCQJnlByLtrOBNL9W3/rjILEoDx0t78JMlVG6CwPEGQIW8flYwNOp6BOmFV4mcXjmU/2DGlu0zaSc08eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Nil4uXHc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YgUU5H0W; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Nil4uXHc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YgUU5H0W"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60S53uEN3353212
	for <linux-crypto@vger.kernel.org>; Wed, 28 Jan 2026 08:47:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+peXoFtKe85BwjRu+lZhP+ZBRPDUzqAfBEqGFaDyxhI=; b=Nil4uXHcabl/djks
	KozDwTq+1ko1tTPjsRgqoIClkS0+4wyY7M9SnBZSxra1N6cuyTjYqli1AxmVPopz
	4FPueqd/79OCjb8lPPOya8iXmvFcVmGrjrYdF97+2qITJnv0BFdKNyimwo9XNVHa
	pv6GcANdkmHpN2Jaa5o3UGEYkJIsRzORC/Met7oCU0OPLF8PHwa8v5cHp8cU8A5k
	Us5fwS8rXpIrd56JGhftDBbpIW5DmpYeBjYiadr9hpmFysUTJ+UUHpgDvx7dYeAZ
	hyJtqJaOkIh4r55zqfMgugukJU3k0mrtLZ/Y9/bl3ZpeTtJdnTnnZ7VkTL2qHWNm
	TjhWzw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bybyv0nq6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 28 Jan 2026 08:47:04 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a77040ede0so65457375ad.2
        for <linux-crypto@vger.kernel.org>; Wed, 28 Jan 2026 00:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769590023; x=1770194823; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+peXoFtKe85BwjRu+lZhP+ZBRPDUzqAfBEqGFaDyxhI=;
        b=YgUU5H0WSQCGurv3Ib+gc77AJZZRa6ih5eTB6Z2YvhcsVVjWyNpbKm5OhpbUfXcYcI
         w1CdQjUtLKeMa8gEIVj6hvvheOPtA6YBpZdFJXvtzHDgevFvXpEZulPXGkd28wYdN8re
         05+3N3rzR91t3VqE0ArOcaB7rutgx50KyvoeJcGCmWxtMOq8NwTfHkhV7X88GEKiXtH/
         uZQTSHLcJNTHqCLZq+iS3/LmY0R2wg6Mrt0vwtbVBJ/t/Suwx8CV+Pa5iHuC5BzJybzI
         JgYc+CXR9G7joiAU2PgN4OsQTOK0gJ9ni9yGI/fB94jpPHNXRVPGnzno+/hXhenBC5ic
         iTxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769590023; x=1770194823;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+peXoFtKe85BwjRu+lZhP+ZBRPDUzqAfBEqGFaDyxhI=;
        b=KVbyPxjJyKgdVfZ5uZur1IYsfXHTdnOj8KXak48zMooaeNgG+JWHJ8P/SHwLI6lvXK
         S37X/vC+tRf8yfGCg7BZ9KdNkFFCbcSHjpwEY4ApD0WUllQy/1v+oqYta+wvkaEGOaqC
         bHIEehieZVa3cKEJJ1s+kSls41OpPq1pA4ZMsAoZOvsIb5LPa3Xr197ZWSZ1DzMIc4gb
         QIZJPK6Lj9o6AEbh/AxINVRYCbg6e2NoN40pWxUDCb3QIayPR2V0cvrpM4KD5yxGJ+no
         d+jg0cCzRlE9b0JJZu6lPfQbajXFRnGFLy5IEZ9yv4f5L9g+yFM7M8amLUZeWUnGsddL
         iHfg==
X-Forwarded-Encrypted: i=1; AJvYcCWT0OaKtjbpwbbMM3ezenjXyOrfKtLZKKnX1OQQgX/+8fLRtiGWOfO3I83IIbXl3WBx6Zu2MSWDQCmBM/I=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCx6aCoEs1TGOHgMaz1U/fHARJLkjYx/X6PHy8CDyLtVkMBuQO
	K3n+N5b7512XzvM5Ge83VBf8QDQftwg/99bSko75nS/hgVqA8ANwWB8Ft1+abtptcfNfOByjUiZ
	WGHU2CnzkXimq4Ug2Vi6RQMsA8ql4ewmY6n6G1Wn4oOvsPZHCw2WHI4I4/j4u0zXWMKg=
X-Gm-Gg: AZuq6aI83BowBWOEcKSNwJq8SbbeCJoBEApnZLn/bL4zK9Bb/n1XoOeZBGpQdqRtR1U
	t4fCyGnY1u4VqnqljSOfiyxNYxLjBcyg5bukegFdWopDFLVQWBjMW3wz8dknoaLmlvDzLC/BrOa
	9ezQUoRtTeXq+s9fnKDJWqYhX2bDxAFF4bmfZnFbl8Pmq3y17Dj+9qr5CNGZOMl0v1NYw/DYtga
	Cb7fnDDXCO71AsC0Cj5HDuPMGwOOla8bs1d0kG95FjozGFWuMf4qvvieuio3WLmDalCkmPqVdP6
	+saYfNCmeIzYxEdRDzCrfCsbeXrEIek3LzXYGfFN1U5TqZqj8YSJ+lNmZK7ubKoBAsZ/HxWMWmW
	BMyMtNcOJL76GLh3+O3lKeSWzulYkIOI3Bqr6uV7WaSItHuI=
X-Received: by 2002:a17:903:37d0:b0:2a2:d2e8:9f25 with SMTP id d9443c01a7336-2a870db7621mr49442005ad.33.1769590023169;
        Wed, 28 Jan 2026 00:47:03 -0800 (PST)
X-Received: by 2002:a17:903:37d0:b0:2a2:d2e8:9f25 with SMTP id d9443c01a7336-2a870db7621mr49441725ad.33.1769590022629;
        Wed, 28 Jan 2026 00:47:02 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b4c3b1esm16263075ad.63.2026.01.28.00.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 00:47:02 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Wed, 28 Jan 2026 14:16:42 +0530
Subject: [PATCH v4 3/4] ufs: host: Add ICE clock scaling during UFS clock
 changes
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260128-enable-ufs-ice-clock-scaling-v4-3-260141e8fce6@oss.qualcomm.com>
References: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
In-Reply-To: <20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com>
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
X-Proofpoint-GUID: UG_MIhcSpMrLqte2nO5ctxYxBzxSv_O0
X-Authority-Analysis: v=2.4 cv=ZZ4Q98VA c=1 sm=1 tr=0 ts=6979cd08 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=lzHOrk3F_0XHYG_XrgYA:9
 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI4MDA3MCBTYWx0ZWRfX9ze5fdJM4LZc
 PdSL2rwu6mAEA5QzDvO+NiQxw1jf6tW3P4fEQjzqImUtBpmhs6c0vLEOClIEtdqqKBkztMeH0gf
 YW8ZHhmx/TWpl9ZTN0sj/1WjHhLsfW/VJir9QC8U9/a5hXUpDbYkrSPtjjrP8VolUZjtOKaRiNs
 nhG4ALpPInu4/jFMAImS6WxhjmjAIKvIWchJzkU2GgOPP4S6hQw/wElmJnWgEDLSVRkSTKvA2D1
 lb6VA/45GlHqhXe156mz30XSf87d75mbBJ9Vq0mcwSNOfOWxkYzDIgaV23mMXK41OXQpCy8sCvZ
 WMpUJfldF1/FdMwReQGc5zTbi3H62lB3RCnhfwyN6cWGTEWzgNQDcIU2VBml7mgCvfu+wUMhkyp
 Uxilc9/7QfojX7OWPlsOvX8m1fVW1zr6n+cd1v2npVFf2r4BkyZ4KPW8NR2Ka2sDaIwCjEuixWT
 4YR8XSix/Q7zIqR3jrw==
X-Proofpoint-ORIG-GUID: UG_MIhcSpMrLqte2nO5ctxYxBzxSv_O0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-28_01,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601280070

Implement ICE (Inline Crypto Engine) clock scaling in sync with
UFS controller clock scaling. This ensures that the ICE operates at
an appropriate frequency when the UFS clocks are scaled up or down,
improving performance and maintaining stability for crypto operations.

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

