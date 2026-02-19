Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5144431AF2D
	for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 09:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771493979; cv=none; b=RlpkfsyJyuWddUuWNMmoTDneTXWGGL/yilKgioYfQHdgdKJvg/ptJ/5kyYPi5xznfJGHP4GZZakizvy/zsDR8+gNMoqAvUWWGHYr23vwHOLxz2KQiNbmXy/JRPnJYOIoXc2ICPoIDZwiIPxiZql2xDbjoGOAJwM5RV3gkDvdD+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771493979; c=relaxed/simple;
	bh=FdQaUHaIKGi8PX7kvnxnJG19Dokd/6H2sRexB/vQ9cw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pW3JMdPIXLz7CnPHk49W4rkXIrkgzBAVQEdcoJwCO6jSqXHoPOAmd0SSzguectkyG0flXK6Q6BZ3q3NmQJjJ2Y5uo93LhwfNqi/x9tQHMCZnXJOQUZMR5A8G27fkJTcPc+CYRxu69ZBIk/RZ/4fJs+p/AH3ZB2rILBx5Df4BI+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HB9PQt1z; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jby3DwdE; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HB9PQt1z";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jby3DwdE"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61J6DE9p421065
	for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 09:39:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uxM27KGWub9YOvIskp1G0Jb2ZU0MzfIFZFqQpkv+G8E=; b=HB9PQt1zsqp1Sn/y
	7SgyPZcRkFPJJOYU0ZdVMprNiMhj9Vt/23BMYurUsB1EGBRsyUDKOaGr/iboqtw5
	N8nBcmr15jqffwfYmEmzikhqEal9f/22hrHiU5mmy6FW6MnhqZCCdmJOhRhPkTwx
	2pyWN5QM8fDkILKv2jceqWPiwuJqjA4Qgv+a7Zc+o72CERO8wYo/+Vr8PhMclHFl
	O9ppkqjma23+B8cX0MgVNKWUfI5++C6u0zVCAX4ZCufKGx47AzF8f4HrWP//QWIT
	6FziYRxxRIPZKERTLQrJW6K0hisoBnIuiSe+3qErYXWGoxESUT989AsydstP6gWp
	aBFUcg==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cd76e3yag-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 09:39:37 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c6e1e748213so488222a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 01:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771493977; x=1772098777; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uxM27KGWub9YOvIskp1G0Jb2ZU0MzfIFZFqQpkv+G8E=;
        b=jby3DwdEdRx5GgVpncDNK2Z8qKNMb3PVAbM91u0vcq0KfYxMaa+cqXDYhs8mi/YsIu
         DfwBKUgPEhnwitIiTIfm/nOjMOQla125QVjPbzZPZlv/pMaPc33VwY/aIkH0RyGee0jo
         EXE1UCnSDxXU9/nZwIaPB/LjMynOHyyK/dmz7B2BraYNXzVETmBOiWuQMIYwd/pdFo+J
         uloeEIJBNu+hclKMxqE4oyU+8TdrDeaqWD2n92mNImCB8z3qJDwEnx8Xee4sTskyxNWV
         saYufVoBp0ydFgabxIJ4dOcTb35XwZvfzTq5qdH6egMpFDlm3J4p4cdhgnJiUhsoBNmH
         /CFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771493977; x=1772098777;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uxM27KGWub9YOvIskp1G0Jb2ZU0MzfIFZFqQpkv+G8E=;
        b=FI+Eni+FIeCFqTyDYmKIZWaYjevF6aptDDXmZ55ZmE0VS4EjBrlirzzv74mJRMxJnQ
         H6TDlUM8o0ivwBnIajw0Jeh92+VzfuIo/M5Q4Yz4c1NYefYKkvchX42SwoOyarT8E/GT
         Ogg2T+e5zfTr1MSOP4wNCxVpBL+C5eHlkC7G5yiCej0BEyS65zpr+HkRkVB99gYLS1jg
         NZRSvIQyDALH2eQy8U02AgsqW/xVancB4pME3TgpKNyH96xc0m33qjUAnenZl07prM85
         jd1pO0/NMMhs7twBXx4GMbPBxbwj0IKQoMciXF5bFPdouMYctcPgDMx1Oj5q/Zu6n7VP
         Eh7g==
X-Forwarded-Encrypted: i=1; AJvYcCXAC9mzfkSePtjz0/plGe7YK03QE26NCzmp+TDDeBU6h/NETXN9Os8WbZ6pfLuNiifSaojIdA5MB84zfjY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLWYnNT/bTZsc+dcrVljon6TJMzhM3gY2edPhVw3829onqY2hY
	uWn19XwVxlLGI3ysGY3wx9lj8GqNY7CHLwXjNOD8/dPffPj1jVPJaQWPdxEqjksHDPLCjkRnoA1
	kx6H+bUiFMsyMKMPAmvxP4uiQULqst61+QhtTY/b8V/4l9MGqdWJBM5acpYs5dvZpHtg=
X-Gm-Gg: AZuq6aK+S70cWJAulmLq5+8lcDDAUg9ObKMH9CXlSAL3Rcj47YZQA+39FZG7OWODK1m
	a40G40vGzO+INlav4HGgdxhHPFoDXBZTSLvYGCFaevgzURW7yXM+NdUuXwvQK2aoGAcFne4eMfU
	ruxuM8hE6vsN7nMNLGV1gci4UYSsrvRzG0eRCO+P619hl0uWsQLb/POxfWTE+DcsrfENw6p7Lep
	M3adWqB6gKhBQmDb4Gmr7kXoADc7Am+L+wrXuubJPAkq24ku5EmRcPd6m75CqB4EgTS9rNhlgoW
	J8BK70PdF6JlnGAuGmfATM4IgrqQRc3gCfmzmuB41xlaHTZGQFepVdwCpJNUAKav2ktmYpdHQ7c
	/gnN/My9bBCPA3sASo9xmUL3YQf8nb0R0bBPr881Q7YKHOT0uxV7BQqlZR3w=
X-Received: by 2002:a05:6a21:3991:b0:38d:f2a1:a43f with SMTP id adf61e73a8af0-394fc31ce77mr4241398637.42.1771493977070;
        Thu, 19 Feb 2026 01:39:37 -0800 (PST)
X-Received: by 2002:a05:6a21:3991:b0:38d:f2a1:a43f with SMTP id adf61e73a8af0-394fc31ce77mr4241380637.42.1771493976568;
        Thu, 19 Feb 2026 01:39:36 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6a2ac83sm17710250b3a.12.2026.02.19.01.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 01:39:36 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Thu, 19 Feb 2026 15:09:15 +0530
Subject: [PATCH v6 3/4] ufs: host: Add ICE clock scaling during UFS clock
 changes
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260219-enable-ufs-ice-clock-scaling-v6-3-0c5245117d45@oss.qualcomm.com>
References: <20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com>
In-Reply-To: <20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=OKsqHCaB c=1 sm=1 tr=0 ts=6996da59 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=-RVjIYUuWhs3u9hRN0oA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA4NyBTYWx0ZWRfX353L62l2vSKW
 ICN35Cds0QsgKE7HJWyHv0zODZRDtv8h/0Zn6l0VimPewDCcAPDtI2AcQ4IHORG+OSVtrSVraIv
 Wo5xECQ52xucdgwu+/4lbXxOhXcHSpyJDxJKo5tG3j/vEkLwnMrJ/IEKtQOJH9v/2qL/5w6t1DP
 05B057ZVa+h0OPR/xTb0Zi06+3C0vxlBpjCofghps6jFyDbJPEw41w7M1aAObLXSxE4aPKIpmse
 kVq4zXkb6rbFDmA5tLomnbVxwwfRqnnmol0DwurNZiUap+3p/dV6rYKo6iprPT+J9h//sW3bHIm
 ZNWrmdqEJNVxqTjnhUNx/xcXiJcTAobKcEVIKHo4jsL9Be3Akc1uJ7f4b4NmILyrmiW8/EKfkmA
 o/39OGL7lXhTpkVXl5McMOqTGmStO9wrKv4cXrs3oJDrSC6sbqKfu1ljvEEVdgXTa5iZs9xYeFE
 KxZsi60GHdJhFcMIE4A==
X-Proofpoint-GUID: IxYcZ50WwKrcsdWpH75Xo6zQ36n5JLXy
X-Proofpoint-ORIG-GUID: IxYcZ50WwKrcsdWpH75Xo6zQ36n5JLXy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_03,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 impostorscore=0 adultscore=0 suspectscore=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190087

Implement ICE (Inline Crypto Engine) clock scaling in sync with
UFS controller clock scaling. This ensures that the ICE operates at
an appropriate frequency when the UFS clocks are scaled up or down,
improving performance and maintaining stability for crypto operations.

Incase of OPP scaling is not supported by ICE, ensure to not prevent
devfreq for UFS, as ICE OPP-table is optional.

Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8d119b3223cbdaa3297d2beabced0962a1a847d5..d85640028b567d2084683f237e3110c682a08ddb 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -305,6 +305,15 @@ static int ufs_qcom_ice_prepare_key(struct blk_crypto_profile *profile,
 	return qcom_ice_prepare_key(host->ice, lt_key, lt_key_size, eph_key);
 }
 
+static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, unsigned long target_freq,
+				  unsigned int flags)
+{
+	if (host->hba->caps & UFSHCD_CAP_CRYPTO)
+		return qcom_ice_scale_clk(host->ice, target_freq, flags);
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
+				  unsigned int flags)
+{
+	return 0;
+}
+
 #endif
 
 static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
@@ -1646,8 +1661,12 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
 		else
 			err = ufs_qcom_clk_scale_down_post_change(hba, target_freq);
 
+		if (!err)
+			err = ufs_qcom_ice_scale_clk(host, target_freq,
+						     scale_up ? ICE_CLOCK_ROUND_FLOOR
+							      : ICE_CLOCK_ROUND_CEIL);
 
-		if (err) {
+		if (err && err != -EOPNOTSUPP) {
 			ufshcd_uic_hibern8_exit(hba);
 			return err;
 		}

-- 
2.34.1

