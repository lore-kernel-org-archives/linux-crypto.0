Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122C2369239
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769152402; cv=none; b=q61TfbCF0rSSrRtNtqQYRx+DEVIV5nIUeQKUWvxnNgC5bvXnk6fRahnVta3K4WfDVVvHhSQxEFGWle1jGuiDZ14PumYY8JIAPJwFqf/jBbN+J+UCim+6S1SkVKZGWKDheHBE6IWfG/pjxbrUwMGugyczQai3LqyJPZUDGBPh9A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769152402; c=relaxed/simple;
	bh=htBjb49w1NMJvju0Z9x0a6d5PVB8917gPx9MATU+Z38=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lzznv9QU3IXi5yJK16jDccVVbfwaO7il9aRlIGjvpbS3MDo5cXce4ak46OW6Kt7Nx3zDgePaToYoolZA3+1bGidpUNeLv6DHH93GaXrzRBeEVL/smQCHJ7bO1qaMiwfZqsIeW8u/HLsWm5ER0k2qk18NBVex9bmu9VlbBekozvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MzFSXVnl; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Rlxh5F0L; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MzFSXVnl";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Rlxh5F0L"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N6mvgw3705227
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hevsL1VFg+Wh5R3ZA/I+LrCo1Rf8Ew/DU+wBbrRMIuw=; b=MzFSXVnlJHjlKO7E
	rNZ4HPsQqOJ5YV5ycWJvMJQNlU4HJpK2EhkChNy3WW7C2xpJVu3Lu07Lcf07Qk1F
	reYtGxqxOxLcEkJO2Ng1zQ2JQjMu8XmghRiqc2hIEOdw0XPRIm2TxuF6W9jM2w7Z
	Sn6TfJPmY3qZwdofB7tiIShgadM/9VuFoikgHEOyxXVV8CXmewK6EYgRHHU8al/G
	9I8RCfnqAtF8uc8Rsnf7CYukTYqa6p8LxAVSJWcdRAXdjGFcDEWSE0ayJJKs8LtF
	H3b5Sl7NmKaz/VYricWmqgdwRlnAq4z5FYxNxeLGBiIDe6Bkqu5nNBJLvyJxqIbl
	dWR9Iw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4buuaysqnu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:05 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a7d7b87977so15332575ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jan 2026 23:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769152385; x=1769757185; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hevsL1VFg+Wh5R3ZA/I+LrCo1Rf8Ew/DU+wBbrRMIuw=;
        b=Rlxh5F0LLJYhclNyEoKiR7Q/kkL4ph5stmsjjey6AcQZJEzA5hcT4iwG7aTQjwpieg
         eQoujKK73qOZeL3p918lB817AFgHYS3GGceHaB/+J4Yic123JPLJXZTERmaf6M6ZyuMa
         ey1N3C0NhvYhG6X3luZkZRRLKoKzRTK3I33m+eLm65o7u9/U8dvxxk6DVRZ1j+qCRDrV
         n88IGZxmfH6/S+38aZUy6QPdXBchH+SdLG/RAWly1cvq55OL+LG/D5XH5UEo4Jm48k7n
         b9QXHLE7adUoWn1l0FpdkoddU9tc9MvopCIr7QYlT2sKNiUl8ni+lZNdiODNd6z+JuzS
         VD3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769152385; x=1769757185;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hevsL1VFg+Wh5R3ZA/I+LrCo1Rf8Ew/DU+wBbrRMIuw=;
        b=a5XO3GKaXceWNMIweMInrdJWa5tN/Y1xADmaE/ehdGsH/tZNy3eCdRCa9BFJEOalk3
         5sWJZl8zqDUVkP/DALl4AFThrFvDak+aLPWlalR4uuTT6NlG6WyvDrCC0LsRZ24zOQRW
         +A6hxMmr8FDAZJBkJHJdxdyZpUPdl+1DnSb5oAOSDhVrrzyH2xOtDQLa/x666GedHuMo
         Oky5ydPwy2VbqMEGJ/eoFatH6e0urYA3AZVu+PhMp/fcOl6eVAfNIN0K1sCcBJSAaH7e
         kqt8AqOggsVX9doYknCa8jtIiAavlSO/wOdDxyn6XETUvC7LVXS51zMDiTOzBZq+m9Em
         VUQg==
X-Forwarded-Encrypted: i=1; AJvYcCXDqe++F5uhfnCcQrSo3dKBnRi5v4+GDtPsLhdy1OXQTlgfti9itOx7qfVgedF1w0S2K6nlDAkRjGEuD5w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCaLF/TUxGD81O9E+qoEVNfafA9zI46tP5AJXNpeOUrCdpmpiN
	FG3XEmtp33rK1khRtb9Nh8wlxYIZdvuowEre4P9ZG6VL6dYWvXutbqQF3Gk7fSACNIduQyUj27O
	Y/lB9IxrYdQPxJH3WsQOUknWAVa7jSo5od8bePttihELubOlkrm3nEMDIprI6Kz8J6bo=
X-Gm-Gg: AZuq6aKrUkl0LTDpvtgmWqrCE2dFaKgk0f02eCIa4LVlELaGRDi6fMeNpqOnoFsEOFe
	pKcTRhRosG6W20J5r1eCVidxN7Zr2OU+aXFKwcuJtb1nkTCyRvUbGFJ5L+xoK3sUna7QdtabZ73
	ud0yjE42LFT4GzBnQvMTO6lPhvmnX4GcD3O6nCEFGCpM4lUKuOjOTQd6ybb7XpMvu59JAA+GtVO
	6yiz5ChBkYzjuKm/2fhkDFgyfSCk5yg6wT5VGiAfNqKPjAkbIWkqCZSr/czfCydJpc9H3YfJQeC
	zb/BqioOQNcjdIllcUXlaGOmNy+IluPh0XSn4hZKwFMbl3dVK2b12qcvRm8evGW1NPrONHrmscv
	vXX9zgeG9hTRAegDgT4vpGmS8G+VupqeCwbM=
X-Received: by 2002:a17:902:d505:b0:2a0:abba:a2f4 with SMTP id d9443c01a7336-2a7fe444ed1mr20134825ad.2.1769152384852;
        Thu, 22 Jan 2026 23:13:04 -0800 (PST)
X-Received: by 2002:a17:902:d505:b0:2a0:abba:a2f4 with SMTP id d9443c01a7336-2a7fe444ed1mr20134515ad.2.1769152384277;
        Thu, 22 Jan 2026 23:13:04 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802f978b8sm10979795ad.46.2026.01.22.23.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 23:13:03 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Fri, 23 Jan 2026 12:41:29 +0530
Subject: [PATCH 05/11] arm64: dts: qcom: sc7180: Add power-domain and iface
 clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-qcom_ice_power_and_clk_vote-v1-5-e9059776f85c@qti.qualcomm.com>
References: <20260123-qcom_ice_power_and_clk_vote-v1-0-e9059776f85c@qti.qualcomm.com>
In-Reply-To: <20260123-qcom_ice_power_and_clk_vote-v1-0-e9059776f85c@qti.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769152357; l=1205;
 i=hdev@qti.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=htBjb49w1NMJvju0Z9x0a6d5PVB8917gPx9MATU+Z38=;
 b=poeVN86LAsa32iR/mwIDJBgUpfDHbxDfboDayFuiMNefBfkyhwod4UjVOV3P+YjAEDEo3718s
 bJ2V13Nr1GOBl99jMn3je7VVgZ32/FNi2Uc+fwdadI1tgZzN4zMrtDZ
X-Developer-Key: i=hdev@qti.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=GP4F0+NK c=1 sm=1 tr=0 ts=69731f81 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=n08Rq-YSkjsL-2sbs4UA:9
 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: y7cBf40IG8BbMI9hwbrjnvEG9A4yE_iA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDA1NCBTYWx0ZWRfX0RvgOr6WwcHN
 iLt5ag3htVW8LlGXbIVuwTVPAUpJLrpCOfacQGHc8zXZ91REoXvqXwe89HuPoawTRu2HjUV/4Kn
 4yCx+p9bCkxBizwXDmrZdEvyYQUb6Uyax5DXPxVI7AvMBKNe6JnAKzGDK3xPLZHUl5b4L9WwkDJ
 AAY1Z1RPIPlHLmxs3qZ1ZvjKuZIv8uk7bQwOAXrTjgUE3hk2F2Wd6hTJE5n7HTDtQQ/siA0ivEz
 LgoOTpijXPqDmHdmFqORNnAD0Hb/lk5ZWORE8AwLxeOcFxtV31ZzyM0Gk0rVnHwpMzAHSjWlT77
 SHBhWm4y/sHa1eILitt5ZxxsxqC4q36h0vTzYijqRRFhdOwgCF3eK9aAb4+za9o8YUWHti/dzDD
 S6QMth5U8KcIr/kqDhV7dIUMyVf6P5PajEnHp226Plo2gbdf1uECV1rjl5MaQjl5Rbbhh0U8HxP
 /Lb3v/7q3BXmoRgohnw==
X-Proofpoint-GUID: y7cBf40IG8BbMI9hwbrjnvEG9A4yE_iA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_06,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601230054

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for it's own resources. Before accessing ICE hardware, the 'core' and
'iface' clocks must be turned on by the driver. This can only be done if
the UFS_PHY_GDSC power domain is enabled. Specify both the UFS_PHY_GDSC
power domain and 'core' and 'iface' clocks in the ICE node for sc7180.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 45b9864e3304..74eb895cf4da 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -1605,7 +1605,11 @@ ice: crypto@1d90000 {
 			compatible = "qcom,sc7180-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d90000 0 0x8000>;
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "ice_core_clk",
+				      "iface_clk";
+			power-domains = <&gcc UFS_PHY_GDSC>;
 		};
 
 		ipa: ipa@1e40000 {

-- 
2.34.1

