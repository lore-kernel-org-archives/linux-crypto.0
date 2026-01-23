Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BFC364E98
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769152399; cv=none; b=kx31L4ZVR+/gk5/Sf5Vzp2QifXN4HjN8F9IyypMIyrdcRsAjq2PwwquFpJIdJ/xvFdRB064aOg8h9qQ34BplzSWhu7uaYlQs/WE8v0iBERWvIfYBIz1KYA/2WxiiDxxs2jEllleuDdMqCBEsvw204Ehe+0RMBVUXqq/RMqcj1yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769152399; c=relaxed/simple;
	bh=y5OhV5IZZ4cD3XJwqbL5xsBPAwLjd4WvI2VkiE2j1E8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=s28CXNhA3GDSb25HouJuzC3/uSwOKK/Txh4HhHoAMbo1Iijm0o00EZYPHg/W/4e+JAnUaL6NaJmwebPC6x+LY7dJkdxxn+TgOh2hRJp4r+5ykTKkRmZyKx9gP0A8rEXvLkjsZFqDWPoaMLSMxV/66XKQpJWRcHi/rGDlNWpOeE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kl7iLzcw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GtRMSXEv; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kl7iLzcw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GtRMSXEv"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N69ldI2910302
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:12:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	NQjs1FmarwM5vchbBDR+me6FCHg5gu3uiOgQdYFOa/w=; b=kl7iLzcw3E/VPf1F
	VluIqBySLg20siFCPq7A6OUcl1/zrN/R2832mHVTUsc47/WQo1FnHiGjM6Vx0PDR
	RRArge2rliGlU3AfnJjuuM9/Mo5KBhxOsuqUeb8UVymNOvKqxTe8SGiuoPN69M0/
	diOAK6wpwaDd574Y/spj6jefZXw4VtLtTtUl0IF+9RjWbeM3dnG754bzt5cYBEvJ
	AI22WKe1yAAeXIBZ9lHnEx1wUWhtZms+tv0MjkQ24yYgG1nvYdbyz9xECXfxg1xz
	OLWC3qyjzsQDy535XVOnMFZXNEC+0Tz+/4JGeWoUdOFAAfDcZeLPOkY4ik868y+Z
	WFVkdg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4buvs1sj4b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:12:52 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-29f26fc6476so27173235ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jan 2026 23:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769152371; x=1769757171; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NQjs1FmarwM5vchbBDR+me6FCHg5gu3uiOgQdYFOa/w=;
        b=GtRMSXEv8Lm0EE5EQRkCydNrLiH3r733qpaim6oTrv0T3EpevmkKv9UI9utZeqqh/d
         zuUx2z7N2i8IWx49gbKoW1fzZ+G/g/pxi4DhAEg5gIYDkue3CbYRwX6mbMDuoPEuh1YJ
         2JVuXUdd3najdcdM8uGwmJElGAEDoUsHQCIJErAJklQVd6bKXprPkVN2lGGIeA6S6mau
         HYPDn9eiQjkrojq88lyjhdWPi3uJT3nDGpny7ft/sMWRh7P6/G6fzsFfbWVn89PFDWji
         97tEEJEqTofE55AqfZdFRAyVq7ekbts79GKZMi65EkYFnh2H6bE7VOufcLaXmlCz4L1D
         kbcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769152371; x=1769757171;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NQjs1FmarwM5vchbBDR+me6FCHg5gu3uiOgQdYFOa/w=;
        b=f1XKibvyyUJPTS6FJcl6q5DF53e85yjOsL1J+F7rkOVXhXshqvr/s4i3ic49/7eRBr
         qJT3oOPxKZD0iI1SJm/c1NZIJgtVlmiPpDC4tiUX+1ZQg3fHgjqLo27WCt5+0HeZyQmG
         U+evGNfOIXFKZXj4UjhNd5L7VasAiCQ2GlFGq/pymiTJUDEspzwhtRDBMmi5cb/ReVpu
         t8xjc3mpOfXpiNNnTyQjO4dzBxpjOTnkmYor6yi97RxlPgiQ1rQmUv2ShKbneXkstSYI
         PunkvZzvvvOVJHEGvz8tpNAHSuYmlTbQ28tK9cysdPmlGBpFbH2JuDDreHd6rszdgTw2
         NT6A==
X-Forwarded-Encrypted: i=1; AJvYcCXzFzg0o5fWVBvWpuCN4NJQkwDD0vUHsXlxJxc1y/eXNFtpmBqSF66zNkf3XmUBMUmPx1aoo0osMTUC6VM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkiLb9q5AKNlMM7D5WSw2q+Cy1QEH9WOGJFqs1rNNFO5n4IDws
	XGyA+uVXsTP7ddaQn2u/xAobG0dF7qMLHVLrHP3GtKO+9OIiqu5fHhpifL4j5AZPTBNU/ev+9w3
	funzxfBBEVVI5jlB8WUFzk6bwB/wQfonM6amJznjmNbL5Bx+uS7a6yU/DuB6RBhODC9hADJwz8j
	8=
X-Gm-Gg: AZuq6aJhg1tRgA0LD4tf0/RFX9NIEPeyOOUop+WMfLMBFxQ4lEfuPOedLhtqYmgb76A
	NDVi054rmeBN2bVgQSouhdpRzn6jHs+cmkqT0rHE91MXwBeu+r7EV+sVtDRPJF5wt+Ol0erEUfn
	EY2JIJjDswAQGlEeu5MyB32m43IEdaC3DDhMQWwnEmV/WfY2/j7QVRaFX37LZOc37kU2gTbEN3U
	3Uj28yRNQV51yv2tzIrdUHwUwZcBUvhVdMoUXfU1bvogKAnKMf2uSxgE0X/BeSXR5bwWz0yQMgK
	xnp/lGaqpCP1O47FSCbbj6kGM0uD/Nap3gTa78uLs/2NqAaFQMV01uT3Tr4HAgxjnTZsWGd1j/I
	P0gzt+GHIn6TUzF9opxRUxj10aQ9MscTaegA=
X-Received: by 2002:a17:902:e784:b0:2a7:9592:210a with SMTP id d9443c01a7336-2a7fe61a635mr18596175ad.33.1769152371040;
        Thu, 22 Jan 2026 23:12:51 -0800 (PST)
X-Received: by 2002:a17:902:e784:b0:2a7:9592:210a with SMTP id d9443c01a7336-2a7fe61a635mr18596085ad.33.1769152370561;
        Thu, 22 Jan 2026 23:12:50 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802f978b8sm10979795ad.46.2026.01.22.23.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 23:12:50 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Fri, 23 Jan 2026 12:41:26 +0530
Subject: [PATCH 02/11] arm64: dts: qcom: kaanpali: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-qcom_ice_power_and_clk_vote-v1-2-e9059776f85c@qti.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769152356; l=1198;
 i=hdev@qti.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=y5OhV5IZZ4cD3XJwqbL5xsBPAwLjd4WvI2VkiE2j1E8=;
 b=ZpGsig9EG/I6gxF+u/H78n7MpylmybmMXBSXtcZAYrl1aJj7A1j9flgX5DV0tXJY1pIZ89kbY
 QxpdF1C18gSDwOFlCmHDGNtZHsziliqw/rOS/POfkpTvQEKmL6nCgqd
X-Developer-Key: i=hdev@qti.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-GUID: KCMueNe_T2JnrKIHxXHtkKmEZkElJBBo
X-Proofpoint-ORIG-GUID: KCMueNe_T2JnrKIHxXHtkKmEZkElJBBo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDA1NCBTYWx0ZWRfX81JlLhZ4jDkX
 cP95LsjgxZplznyOwJ/+zdqb81L8IPyRlfM8EZ4QDv0sMywN2zAhZBnyjyA92kH5oLEax9OnVtN
 sT1b3sv6wrZ1zC/xE14BTkb4l+9F1Yt3X58QC5pcORbi+tiwD0wiQoYj6OCwLQ2mlgYfKywwUG1
 ZgmUNbAOHnjskvWgee8QzZysyPsOFFTQdEjP6k6FgW4b9/S+lxo8yTMUaPdtrz2v5gvN+S5fr0i
 RNXidnjfAq5VHT2e69jfyrwdrYVwNr/JYoyeFFtC9y65qtb5HP2IxC0+v2hL2Lmqp4xANo+Ime1
 BeCF+uSS3U+YnkTT6j50LEQfggVP5y3v1+wwvhL/Q9hM3uhYT5VhIlAqjm/Jq1weUo2TR9p/ALM
 Ec6j3Z1EoNyQ+0d/j2GccN2yyNrVtzES9AYg2AIzzlG02ylD89E8aor0X9un89E76wrQFXKbCYj
 i7USPcFGZQEdhf1757g==
X-Authority-Analysis: v=2.4 cv=faSgCkQF c=1 sm=1 tr=0 ts=69731f74 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=n08Rq-YSkjsL-2sbs4UA:9
 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_06,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 malwarescore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601230054

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for it's own resources. Before accessing ICE hardware, the 'core' and
'iface' clocks must be turned on by the driver. This can only be done if
the GCC_UFS_PHY_GDSC power domain is enabled. Specify both the
GCC_UFS_PHY_GDSC power domain and 'core' and 'iface' clocks in the ICE node
for kaanapali.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/kaanapali.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/kaanapali.dtsi b/arch/arm64/boot/dts/qcom/kaanapali.dtsi
index 9ef57ad0ca71..7dea93d80636 100644
--- a/arch/arm64/boot/dts/qcom/kaanapali.dtsi
+++ b/arch/arm64/boot/dts/qcom/kaanapali.dtsi
@@ -868,7 +868,11 @@ ice: crypto@1d88000 {
 				     "qcom,inline-crypto-engine";
 			reg = <0x0 0x01d88000 0x0 0x18000>;
 
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "ice_core_clk",
+				      "iface_clk";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
 		};
 
 		tcsr_mutex: hwlock@1f40000 {

-- 
2.34.1

