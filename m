Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C7B33A70A
	for <linux-crypto@vger.kernel.org>; Wed, 28 Jan 2026 08:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769590033; cv=none; b=cHaZjHMe7cGNmxQXdwesNXD1gAgkHsLyB3u1Y8fGNVbx1C7YuDUt+1f9XOJDAonWsO31ek/7wxDmZWzGN3pdvXfA4a+FsVlQgfSqUcxNuh7ZJhzYj8pnMYlPewKhfz9Sh9eywkB+sI3i16FSN4nu4/ts3Zpm61MGCP3TdaTUrj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769590033; c=relaxed/simple;
	bh=ylcz5FSDejXLscrAzKaX9+cbwcLqyVwvsZ++Oq1bUtE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=V1+n+xfN7T9/fR9UlCfeEXbbmAMaJUTH15/WtvjYIyqRFh1PGn9WcBYTUkPEHb3+L2/wireVO0ti7n3wad2HQtMGk9ySNRLQBb2MWpgSrrKFsWrx6J3DtCKigdtpkPhvh8KAkmDbYU2xUECTfCXNJiLV4qZtdxK5JAHsLL6kttE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fkaihsyy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LD3FMtPz; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fkaihsyy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LD3FMtPz"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60S6jqVf2942958
	for <linux-crypto@vger.kernel.org>; Wed, 28 Jan 2026 08:47:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MPGRifHCQwcqLRDHjnRCAFVn4y3dD4oL+zZhUOGVvhI=; b=fkaihsyyXn6cSOWg
	HvofXbDd8+zxLp+NKwQRTAI51shtN1eoItzJpU9+a1Eja53xJButEQu3iAG4PB3M
	C3+eqsFTy1hMTkHwqDpF88GmEeD+UFEd8Qd9/UuqDxRADwVNOZnqsTcTcKnM6bdV
	GbOahVf27EFYvJLp7wSd1gqJ35gcCiqi88Khs93lEHnNvXCaTH0r29MVqgcI2ai0
	3scenD0ISffObqO0ZPW22s2m/tYFbPtiNKRGKxdjboIY3rsbOhTs1sU9Wn/vxZMR
	gwfc5lJTQpZxDbr0fzXvdgwMwBZxXaOk9Nob4ciCDu/Sj0ulUjWDCJCe3t0LLapq
	SF7EqQ==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bydfk0ch7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 28 Jan 2026 08:47:09 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-29f1f69eec6so67600235ad.1
        for <linux-crypto@vger.kernel.org>; Wed, 28 Jan 2026 00:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769590028; x=1770194828; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MPGRifHCQwcqLRDHjnRCAFVn4y3dD4oL+zZhUOGVvhI=;
        b=LD3FMtPzabhyrp6UW/o1Vmhp0n1+SuQl3cx/x13Ww4KxzUq/I56yyRbRYLdcUV6GFK
         3D5agtmk6LXZ9lCZj8Jnk/0JcmvhlnCu/Q9SXq+GEXas9djQJcm+w1NnCPtFg9rvY2Oz
         sDLKUasadGN+MTZJoDiT/ZedpV5r4sv1rsz7PA/3xDXcYgPO9S62z4LL6o9OP5Up7ojL
         iFvwEbVocKqv+W82wNqNk+bEshl4zj6hCY5FcvMSeQ5KcqPmCxkO4i3Ttik4kKToBEn+
         s7YXmfcTB/WrY6WOCDiUQMTktxEayuYuvIysP02tjhGJtONvhH2u7Ndd/MaylegoiSXX
         I+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769590028; x=1770194828;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MPGRifHCQwcqLRDHjnRCAFVn4y3dD4oL+zZhUOGVvhI=;
        b=YdzLNyqcDoU2MmaKOJBry+U5v2prwYAirBIU6a1Goob4l/o9Ba5vRacHRM7oogTqv6
         htdZ9ViHh1UEi3Pu0krjrQLhJjZTuZjScJOw6h4Hu2ou/AQfbxKpG2QxaWf5twJY8b4N
         zzmr3mbX6dKZpVvrrAagmVAdQ444mvBggZcLo2yy7esMmmalWNs5bJ6SRM7dACMUnwAu
         8nJORUD74jJhY7e/mXMaZk3CWPVTyRHxD9fBW74/xURfwzsFMQxBE5UMr8zjRBgNrhSR
         cRqsEDdZtUsfeWTICcvHcQMoi98lw3Wv0d8M45WgSSe/DvMq9/UZJlKNkL7mNgfXJh26
         8x4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXDOskHwPonCtCKh6TtY+eciUOyhVj0MfA/Nbw/yfmuRi2NGyJvq6d2ckRuLV6Cc6YbyxjvwJA0LGnHd5M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDQYgGhU3nZCzJFAh+Zn2n/rC+u13rzAsaqZ1/JWn8cpAsNMN/
	yotg3mgTJCXKQq7iqNyc6/bw0M0wrxEFk/p9tGElvQFbiv7wc2eCFu0JT1pRsWT46QXc+HR2rYS
	XrQIKyWR+AcfD5Vv4dqR8fhaADqVGAn6gTnj59r9+iduZWzp4cGJ1H0YZlJG31BzxWKw=
X-Gm-Gg: AZuq6aLjYOXFjtsZ0+NTPUM5KmYU+1CbBJmbhx5Wbh3jWZE8+0BPvVohuYa2zzlNwxp
	LKtp9CZleWG18jTkuDfExDGJo/sA0o6CCX6ctZh9BQ0mCVK+9gHPj+D+/9wzm77yWG+u8mwWzv/
	EQ/6YDaNChyJqEybL6QES6QIvRzzw9lTFZwKqwQ897VIhWXE9XXEwfqIV6mNiESKt9g/XeAmZL1
	u1K1Nh7K4u6RNsHqvNP7fia720hb9KM1bYRXigwTbZRlclkxAYqTGAng1EUh/uwpjirIXfyUmvR
	52tRPTfRrFCRzbV13Ukyv3Jy2r0uMB93k2DRevtn4XYdZ6Hq4Ep/b2PnxoYavHi+rWHkh4eJ8nh
	yRL/8Stht977/FU7n2MYNsoXxJlCS1Sss9pNeAmgpdU/F/FI=
X-Received: by 2002:a17:903:2f87:b0:2a7:ca82:c198 with SMTP id d9443c01a7336-2a870d2cf70mr42149045ad.6.1769590028048;
        Wed, 28 Jan 2026 00:47:08 -0800 (PST)
X-Received: by 2002:a17:903:2f87:b0:2a7:ca82:c198 with SMTP id d9443c01a7336-2a870d2cf70mr42148815ad.6.1769590027578;
        Wed, 28 Jan 2026 00:47:07 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b4c3b1esm16263075ad.63.2026.01.28.00.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 00:47:07 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Wed, 28 Jan 2026 14:16:43 +0530
Subject: [PATCH v4 4/4] soc: qcom: ice: Set ICE clk to TURBO on probe
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260128-enable-ufs-ice-clock-scaling-v4-4-260141e8fce6@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI4MDA3MCBTYWx0ZWRfXwseh0T3UzA7t
 g91WMg3E4nE3UPmbFNRAQFidqx3MCs6yNX5mYApbJ3Rpo0skwHe9g+PKlm3JOooGJl0OmR85PnG
 SZXJuCveL4j0GZNa3uYaArx7Z84NPbWCU9PEaTXygfOFiBGpTGcznOKGOPuFgKERE2XnOYqpS60
 9C4KCiIerLnfg/8hMlo/cJExX+d2rgR3v68lECF1SQp6ibYks2Dl1GVUsAeBXCMUGw7JTH3rEwv
 IpSgb4W3t5MRULAZAzdDtrbyy/V7NlCQN9H4/m8aJaz2Qg+VX4WU8yO7A+Cd087EqAGrfqTuFgA
 TnBZDJ2A7hKqzotgHck8ARWAersVgPd1t2g0lusgTnPrgjwD7dJdVshfDFTbUg0Yxa6zQtUJntx
 Y5bEDHABCKcGWs60ou2vZjw0MG6d1Ab9FFQUh1zD/vP6JfQv9he+7fmKDtDVUdom5m0sZVHPV6S
 Mwm4kUMLpNixMk0oEiA==
X-Authority-Analysis: v=2.4 cv=XfWEDY55 c=1 sm=1 tr=0 ts=6979cd0d cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=u1bwIIJuvd_SIhYoViIA:9
 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: wO1Mt0QsB5-4y0Wgfye6TgEPogFpNZhf
X-Proofpoint-ORIG-GUID: wO1Mt0QsB5-4y0Wgfye6TgEPogFpNZhf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-28_01,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 impostorscore=0 phishscore=0 priorityscore=1501
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601280070

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

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/soc/qcom/ice.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 90106186c15e644527fdf75a186a2e8adeb299a3..2b0e577fb4c9ed9b746fe70ebccb45da9c52b006 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -689,6 +689,11 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 			engine->max_freq = rate;
 			dev_pm_opp_put(opp);
 		}
+
+		/* Vote for maximum clock rate for maximum performance */
+		err = dev_pm_opp_set_rate(dev, INT_MAX);
+		if (err)
+			dev_warn(dev, "Failed boosting the ICE clk to TURBO\n");
 	}
 
 	if (!qcom_ice_check_supported(engine))

-- 
2.34.1

