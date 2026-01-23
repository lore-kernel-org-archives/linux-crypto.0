Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E3136EA91
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769152402; cv=none; b=mS/PFEeGRn+6mh5remeXv+t0m0ufvro6vujOfHhH7S2HWOuUbFjLnG9PlwGY1fNcYhv6GKkqHtbcj5BZTsE6kepTfaeZOiWdT6aVNUfDBPmHYocEwgl3fdWo1LOEEIKdyadO5eawa/XENFwGIDXQXY0q3Xbd/b3EWfJXPdpj+/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769152402; c=relaxed/simple;
	bh=cNHo3PNjBHDjmsqWjGvKhkma+ZdF+SH0+vV+SWieu2U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gKIA3CiI9EZsh3cbKLMGS0se/l3F0dsfR/dc5D0S6E2oUeC+vma32CT/7DNpP9R3KrfJ4a2kvZHV9AzE2ugiqdl1cnGOchQEjddh+7bFk4AqaLoOq9u4UWKOJ+szyZDaow7ysjuld0/w5TPK5dlT75qpSJNGg97S7VuuhotpIic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PV3KlfBF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DN90Mnzn; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PV3KlfBF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DN90Mnzn"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N564983656158
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	x8J2N21wYRAOO5jWgvxO0OS/Ym6sx8s5Xttm19MqtkM=; b=PV3KlfBFXa5Q9qNM
	cSibrQ8ejnJGCkkvec9LmwATvhrENauD2mosJkzRKNk54StDIBmDHPuiZ2X+wT1O
	Y29GmH/KHieLiE1/MPdSezq9tE6thLEl4KsPLUDcfbqJQ6oYYN+KAEgSO/J3P01D
	b7qdtOGWHD7lXQVP07EXVnFvj9Ksw92d3IqMLUT2l2lDf3dFTbVhTBryDDUgy2N5
	mJvbpSSH0rYPvceddF8RVkoks1YbmnMd08WPlXQTgaoEa7DwBr90ZomjKdpL/li1
	5jAqgWi6JVOa9Eq5TDezFinEHFCA9/SuaWIjJqUjEq16NUHOffDjzgf4HUWq6+aG
	By8a9Q==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bv2hw8cyw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:13:15 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2a77040ede0so17867655ad.2
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jan 2026 23:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769152394; x=1769757194; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x8J2N21wYRAOO5jWgvxO0OS/Ym6sx8s5Xttm19MqtkM=;
        b=DN90MnzntmdjA/K1sSLYv8QcRUrisXAkQOjcZ/7kJZP2UGCygjFcl/wFG7KM/6BDzK
         /8TT6LpKZLPPjjIQScm6Q/RIThdcYjjEmzMrW+stxo59DmOBv3UARI9vbwP/eJWRgL82
         mhq/ncHXBvTAvjS6CJLsqj7SFc3SmJZhMM0WbqlugqcB7IsIyH3BsmOgprqetGgiPOVc
         /Meda+Sn6nARl/UxStUjDOYoJVRtDLcGDyOzwxDJ19gNk53ix/6b3swQVTJT7zpgS50w
         F8S/hQay0ikaKWBjnFsSYUg1RTyfM4UiuGDNly26tWn3PI3hfGpmaYgZ3OHLhAfj9HEG
         xg/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769152394; x=1769757194;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=x8J2N21wYRAOO5jWgvxO0OS/Ym6sx8s5Xttm19MqtkM=;
        b=p4GFvWBqcz6dhwx0sMu/jYmhlQob3AzmWg3kSVWAY9GWPKoq6UiXwCVuHSxmXGIS4m
         LrkR7X/S140pxn54E0iAN00PHIl9IcPmsvR/xq30FTFJlrMLOA7igCrcGqyK02mCiDTw
         R72xqvr+6UjbQlkFAtItrmxhbPYqswn/PFvOvIm06mOcULK3Amnezgx2Q2bcPQ8AyEMA
         R19lto6F9dWdLSg/Idqy2LXIf9wknnjWEuMlLhjVbdZZzJqx2NSs7tC2oDmHN8X8L4op
         kKU13ff6YI/TxAf3d3uQQZTvKta+XZUK/R2YFnxaBkF2vXJ2GkgmuH058fReUPDL0Wy2
         AUvw==
X-Forwarded-Encrypted: i=1; AJvYcCXnPsWWUA449HY7Swu6y0a2c4HVF2BRFk/lIvSZWXeArqCbINs9Pbqtf58sJCH2Bjb63/9VT9vqsE6Ozdo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTkmTR5/mMe8jpwyUkCoa4+TPT1E1WFl86Tb7eeIx+Lc3vqg1s
	wHvziA2Ls6Fx2w5SWo8x5de/EkZP3rRma1XlLbdkEODact9DSncp3yqfEiHLWH9jdhJQKO31r9P
	qIUutUrpcqAZclQdHUnD+nad2Bci9fzfamiT8jAqtUSdBl1lXN0GvpgrYnU5fT6pNZFY=
X-Gm-Gg: AZuq6aKKklTJ+g0fZdre8Ubifb3rvIOmQ66RT2lgTAUYttzhSTeZTf46SPV7RHyc3rU
	QUgdVolRHPl8EyjFljJqvhWbPXt40ycbWN3itivJfiERxC8uzVoUzqII4WfFZVF3xlKRmTjVDuP
	21+DByEQqcL/NHOpXvKoKp1GnYwfIO8V6v5a9w5Q5URgePrPPEFtQJjzK9xxitJS9q2MjluEgJR
	egNC5R1CSraF3e4xyiLgmSBNoYNCDadFn5JsVZfDqz44OgcZmErLXNLFPrzMkHI3Tsspbae0FI/
	plJN0RBLjo/tgq7VNd+k5TGqAp/R5iY0QY3U3TTkgHF6NKYh826h7FW5GcQTjxPg9it0YRscSXG
	NI6cxfqAPgco8Km0FyAYM7skNUG/+mpVv3D0=
X-Received: by 2002:a17:902:e947:b0:2a1:3cd8:d2dc with SMTP id d9443c01a7336-2a7fe773b67mr18799515ad.57.1769152394138;
        Thu, 22 Jan 2026 23:13:14 -0800 (PST)
X-Received: by 2002:a17:902:e947:b0:2a1:3cd8:d2dc with SMTP id d9443c01a7336-2a7fe773b67mr18799245ad.57.1769152393657;
        Thu, 22 Jan 2026 23:13:13 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802f978b8sm10979795ad.46.2026.01.22.23.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 23:13:13 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Fri, 23 Jan 2026 12:41:31 +0530
Subject: [PATCH 07/11] arm64: dts: qcom: sm8450: Add power-domain and iface
 clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-qcom_ice_power_and_clk_vote-v1-7-e9059776f85c@qti.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769152357; l=1222;
 i=hdev@qti.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=cNHo3PNjBHDjmsqWjGvKhkma+ZdF+SH0+vV+SWieu2U=;
 b=wAul7ry9YHFFJVMN0zcJYGfHOZox77ROpIHAPCTXsxDeifvl6A7aQR/sBAWQ2AhvBKs+XEXDL
 yE2k7JmL0hACBBq6JghCGwRx2x2ILMX+CgPOIZ1FfXnqjPkCaKIONEk
X-Developer-Key: i=hdev@qti.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-GUID: 6ePmMZlN9KezMxr2bV1Yb3smuQOABihl
X-Proofpoint-ORIG-GUID: 6ePmMZlN9KezMxr2bV1Yb3smuQOABihl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDA1NCBTYWx0ZWRfX0VjU2bErhKt4
 5iQWMk2HO4wPZUJb/8sI5Wc8RRo3xCd7BmtMPkpIX1db5F6nH+u+4zb1FXyHBk3u9Jxre0j6joA
 xmv6/zu0xYbg2MzW4w3KQamz79wv8r9wovx/8SksQynKucbCl6fmlKlYVtl3OV33vgvzwBWdJ/q
 fbaQAUs/FgluNXhVLiCDE6BroSaJdVqGjH5J+pXndaLrsE7xQoXOQYj9yWpnY5HAvwqSDoQ95zk
 rQyNKUxTpfanySj1+48DyVDFWRmvJTrA1UKkMx6ddczA4bcOoTWxQKxJQhLpjUf1h6De669fF+A
 fnlGIo/uOmPVuLJmnrJReuuJQH8r1sBEAS7N+i8tbD7+V5qU6274wOHalcFn/gIzeRM43PGVoYt
 fNFnb/XIdkeBPfep3xj0o0iJXtVwn7oo4lkXQDrk9aWsKdEGr4PQo3SMZK9J1YZu+aCdHgDwkT8
 6bc/Zouug2/2fPcuFzQ==
X-Authority-Analysis: v=2.4 cv=A4Rh/qWG c=1 sm=1 tr=0 ts=69731f8b cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=n08Rq-YSkjsL-2sbs4UA:9
 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_06,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601230054

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for it's own resources. Before accessing ICE hardware, the 'core' and
'iface' clocks must be turned on by the driver. This can only be done if
the UFS_PHY_GDSC power domain is enabled. Specify both the UFS_PHY_GDSC
power domain and 'core' and 'iface' clocks in the ICE node for sm8450.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 920a2d1c04d0..3d243e757fa1 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -5374,7 +5374,11 @@ ice: crypto@1d88000 {
 			compatible = "qcom,sm8450-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d88000 0 0x8000>;
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "ice_core_clk",
+				      "iface_clk";
+			power-domains = <&gcc UFS_PHY_GDSC>;
 		};
 
 		cryptobam: dma-controller@1dc4000 {

-- 
2.34.1

