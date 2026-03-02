Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9DF359A68
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 10:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772448593; cv=none; b=CPb56yQ6bkt3yLj65AjlKcMxRdZwIfTBj8qSdmqejCB/wMRHZTNJ0yQx1uRr5UCuBiOHv0QKjwGEvBrfhlWhvncPKLYrulEx75eckcGUEwzUN0AnL6UuLx6gB1L9wmImXcawCgEshc69tJ2fM+DYUMtCJchr9s/7K71d3gtl9Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772448593; c=relaxed/simple;
	bh=tV2XKwtZB21b/+DGFlVdQBnOLHKaB8Bee2EUNXJwBb4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Dpgoq6ATGuovTAZPppqZ2KLClVhX2B23ylpsjTCLG5y7Hv/JI/n3akQuZLh4/1SqU5Ai26DhwVw82OnbKMGAk90pL5/fhkWaHXevUCHS9hw3K1mUHIlWgJj2ty8Qdgs7zhMBT2zu8O96eZhRLUxQUbKGAPIdNBWMEnk8U9siEQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=N7tR3bi5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QpDWJvUs; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="N7tR3bi5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QpDWJvUs"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6229K7ki782945
	for <linux-crypto@vger.kernel.org>; Mon, 2 Mar 2026 10:49:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1iZsdguDErODmBIQ+5meyHtMgbiaL6kRcm9eWC3B+M0=; b=N7tR3bi5aTTbex3N
	1d/VEdOMvGltqw9SluqlBHJ60MHqzWGBNWW+YYQDFaWIsCl5sXQsJnMjElpdXvej
	md1uVC/XZhRKr5QpYWcn1BvcVd7P8THXc/uKjHiFukOh7J19pdCiObuko4hfddAv
	o2giYjdWlXrfgx8sG9LZJ4AdVgppTsAqbr8jyHlfEqiRUMeigcQ4aqFJ9DKzgBIn
	yZFbkTjoxK+qKvt8g9RTTZWilKvkkdzLV6JoxS2Y6bGOLtZ6s8gfa/+x8O8Uy2OC
	+Edo03efNLth57vAPlWGcPEfaY77pz3os/yv3OBiSn+2MJ13hJKwVQoM2iECXbZd
	tfAw3w==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cn7u00apd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 10:49:51 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-824b42b8a81so16741016b3a.3
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 02:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772448590; x=1773053390; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1iZsdguDErODmBIQ+5meyHtMgbiaL6kRcm9eWC3B+M0=;
        b=QpDWJvUs3+gvS5wKYvwJ3v7o398bx86vgManFKjg8rHyz6/usEgGKB8jHuDAmC+ubN
         ODSluNPnZpcWNOfnOTE1vMijIng3ojox+FEfuubN4VCPWqrexaocFeA6YPNrNQIt6tB9
         SiFgYB87vwgY+gxE/9fZrO6ciOGYeKeBAf70BuHkJvA6oF11plc+A7rNFErsXuIH451n
         W4a8ObUreGm/9Ks1VaxeiCtHGZ4Otoo2kz9kxNP4SNzwCr3FEkAKCld7CcFFX+RfQk14
         1EO5FA7QS47qo92J7Jm+0ScbntxZrS4pg8IeHYkNWTPbjQUR3uClPSKrbR7F4csvsqpc
         MJpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772448590; x=1773053390;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1iZsdguDErODmBIQ+5meyHtMgbiaL6kRcm9eWC3B+M0=;
        b=bRJpeRSQ8DhjMW7UEeZD3ZvtUKFR9wE2FfBNLzqFQc2R2IG4biRS6jvNr8n9FfXQ3K
         s7QJmnG1zma1hbiBozFzlwlxtINwCln4Hia6RsvW6ni+Ba7WITCKljWkq8woefVNvfmW
         TcN8c67yAhu3FzYSLt8IC1upuejej0g3u6BTT/DI63pFp6NEivMXbYCTRvADaANiXyQy
         r0ySzALU9l5vmPKzPhSD0h2oBwrpr3UnjwitVG/J40WF0j2WX6bBSorHRaI1wZKa9kbg
         zt6RTcQthNDPPUTkiG0fwGe9ULP5o1TSB4nlbQViIZzrQLCXBGFEYxi1VvolsLJ4FLHP
         ngxg==
X-Forwarded-Encrypted: i=1; AJvYcCUMHtlSCIu+GpHJ2+PyaVxiLtP4C3jImB8KeVmfev6d3YOR/ckziZvkjD5o0/GVxMM2lchEtX0zhzukAUQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2X+tmN98J9eB5rNxCgSTK30Jca8b7Mxg26h+h+vg7yy/aND1V
	6CHWF//1ZTs1KwbpV/qJCnM5bTR+SZcIQ8yR7ai3ZIU9446sBkXJONiCoiFXLgF46NvIZq+7CdY
	AXepqHFJ3RZlQ+L4EeJ2Q6JUywkbBjxUcScYkyc8q3ahYoHdDf7FNgVex5DLanga5pPw=
X-Gm-Gg: ATEYQzzLu+rMcvouz9z+zdXvw2F+EmfYctvBgVCUURKQ4cLhI8ogtS1SI3GrHNmA4GJ
	bvtaAilj/sKPxmWoG96A5j5w8gvtOdbL7EsI7v13EHpi6TVySCv5unuenyiJV2GU4o5Xeknt9/4
	EqwDhFHypmQ7HbJYk1yMU4eF86JUuHpgY03npNbTNkhCqRTSvj94C6JJ/lYNqM9G6nOvL71XfQk
	QxqyXbZuHZFjCguQJYsNRLIWS/4f00TK2+ji92aF5tIqCeOdSC18//Z8hJ8AqrKLygs7sZFjM/B
	2az5CsQcjBRK8HVjbrOsda1wPwDckFib/VPjoWpkPkct7SQ4YJlZG9xcHduuBVSDCKM0Mn978i5
	mN0s/WrC/UvOHsArrSk1fO3w6tg+QcHja2nIYPzSZmNPKC7GQ3FzXYqdS5YE=
X-Received: by 2002:a05:6a00:3390:b0:824:9451:c20e with SMTP id d2e1a72fcca58-8274da3a28fmr10253604b3a.59.1772448590370;
        Mon, 02 Mar 2026 02:49:50 -0800 (PST)
X-Received: by 2002:a05:6a00:3390:b0:824:9451:c20e with SMTP id d2e1a72fcca58-8274da3a28fmr10253596b3a.59.1772448589947;
        Mon, 02 Mar 2026 02:49:49 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8273a054b49sm12225956b3a.53.2026.03.02.02.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 02:49:49 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Mon, 02 Mar 2026 16:19:15 +0530
Subject: [PATCH v7 3/3] soc: qcom: ice: Set ICE clk to TURBO on probe
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-enable-ufs-ice-clock-scaling-v7-3-669b96ecadd8@oss.qualcomm.com>
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
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Authority-Analysis: v=2.4 cv=GMMF0+NK c=1 sm=1 tr=0 ts=69a56b4f cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=u1bwIIJuvd_SIhYoViIA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA4OCBTYWx0ZWRfX3xGzHFBzR/1d
 XeUo7UyexpNfjAH7ASrJmG/nutq7hCX8PBG3ctmf3NV56mSjfSta6W/DVuRWsllMByKgLQN/mCr
 GJ9A1a5ByuMlSolUAL/GYbO3c5IwMuPSpzgAn0E1XUSeSDnoQ6oc0az2rYxTdpgooVrP+42ulcy
 Hv9IQYPPjqBqb4ni/CM7ws2XQGveOj48N7Au2IqfROJH6saCzOVZFTqiKmM1wk+rUw0WceYQe2c
 JODoplGS9BlixL/cEiduAT8KaZr6Rwzo8hCHDjyhOV7r7/+w/lGM37MYg8V27aCBNOEtoh/4yLQ
 kXOHO8fGolLgIuMqqFmg0KQuFoq19ZvuT3PQJd0v29bHC5cLiHdjpkyARzRxlXDJqpt0jHVN281
 /POo+SHxIdpHwrZpnNTHQkjLvEylnavCrBQ/VuonXwi1JQjbyU3HyNbEIGIdJDJS32HLQFjdkWh
 Yg+yii7mgnoY7uLLmJw==
X-Proofpoint-GUID: jaD-3LBYqpxGeDvs0CoBWa4gdFI2EYsm
X-Proofpoint-ORIG-GUID: jaD-3LBYqpxGeDvs0CoBWa4gdFI2EYsm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020088

MMC controller lacks a clock scaling mechanism, unlike the UFS
controller. By default, the MMC controller is set to TURBO mode
during probe, but the ICE clock remains at XO frequency,
leading to read/write performance degradation on eMMC.

To address this, set the ICE clock to TURBO during probe to
align it with the controller clock. This ensures consistent
performance and avoids mismatches between the controller
and ICE clock frequencies.

For platforms where ICE is represented as a separate device,
use the OPP framework to vote for TURBO mode, maintaining
proper voltage and power domain constraints.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 7976a18d9a4cda1ad6b62b66ce011e244d0f6856..e8ee02a709574afa4ebb8e4395a8d899bf1d4976 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -659,6 +659,13 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 			dev_info(dev, "ICE OPP table is not registered, please update your DT\n");
 	}
 
+	if (engine->has_opp) {
+		/* Vote for maximum clock rate for maximum performance */
+		err = dev_pm_opp_set_rate(dev, INT_MAX);
+		if (err)
+			dev_warn(dev, "Failed boosting the ICE clk to TURBO\n");
+	}
+
 	engine->core_clk_freq = clk_get_rate(engine->core_clk);
 	if (!qcom_ice_check_supported(engine))
 		return ERR_PTR(-EOPNOTSUPP);

-- 
2.34.1

