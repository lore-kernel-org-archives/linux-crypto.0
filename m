Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9387E2BDC02
	for <linux-crypto@vger.kernel.org>; Thu,  9 Oct 2025 06:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759990778; cv=none; b=AJtw3r2p55bs3ZL0/2pE4dgVuzjFdECVUfAoTkEfD/xPqdsvLKwb2cywTT2Fw7kfaZqco8TKcycHhzUiDWOzyOSR9v7n2Ak4aNKSC+yUeIdv3hQRV3xRXMMoLF0i2g0bw6WlgWkBPItcav2+iFKCchoMGtZ4pDZ++jJ46FH8P+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759990778; c=relaxed/simple;
	bh=oj3ZGY6/IILJHtVhKA2pv4u2cYCEUcRJUrt5ILBWwaY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LN8Xubc2VOmm52ayL1USHed3Iqi465Uq4LmrNy18bC/vdx2CFmhZxJOXXEIFoZqR7S+cY341faES1Gn3H833UfImouFkdJ5f6W1rCZwzDOKktW3F5CFIb6MhXxnl7q7dFfJLe2GcIlW1avy7Lnpb5AtH8d3umPKza2VuWA/ZmzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=L6vUhfmK; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="L6vUhfmK"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5996EQan029796
	for <linux-crypto@vger.kernel.org>; Thu, 9 Oct 2025 06:19:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mKq3yr9dCGurHHla7xpzo8tVBMxkbqg8w1/ZkAGSJww=; b=L6vUhfmK/kuMOSQ/
	12D51qQOvUVVgKtQvZL8CUrNFBD8aC57zU0NNY9V0jZLOh7RWd9tiY2BXUixtyxv
	Ftel022nfyjLoCfNrUZ4rAuJPq91t/GxCmxoNEeKQCRIm7mZ2Z9IR7Zp809TikfN
	kcuyMN9xTOuC3ZWxlCnjI7aXH4M1ZxMrdYrY0dXpTfjtraQKmGmK9pSXHzlBIlVw
	3Z/tEZ2rLRYHxTmykUIDhLKwzyD4uObx8yi2s+4Nfx0i1VUhH4GECTjwldOa65wt
	rYNBsnXD2iVQ7ENz+GBvsLZ2GCUj8WtlRghJT0hJBD0id/+BGYiRjek5K1F4lzvN
	enlm0Q==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49nv4n9pcq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 09 Oct 2025 06:19:35 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-78038ed99d9so1279666b3a.2
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 23:19:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759990775; x=1760595575;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mKq3yr9dCGurHHla7xpzo8tVBMxkbqg8w1/ZkAGSJww=;
        b=S5FctfcVCc/hEPgDiSqq5VgPKcidY9zFbUubnhIwqijJPYPhZe4L5s9/Sa+uff0Mhf
         +7vc5rDtgtokGBAckb7yi4NxcAzPIcS0D8L3Cm++Ux/xod9XtL6BEdQPQbI8EkJ3DfsN
         VdSXvGaE1shxFWOPxOPzMQRdtZLcSOBYYVDSbz59GN81P0jTjKqfbl08Q99PXLW8laQe
         bO7vBEC6s4RJQ7WolDs/lqenN/tnvxQzv+6EXLb6ne3FAFtHAndH+TCS9zrF3Mb3Mb4W
         TbqqAuRIvrB2pVW5lfhIPHiB0zl4XHjI05AT0zxVaz9uMsCDTOrhKUyq5K0B9Lh1ogJY
         x7wg==
X-Forwarded-Encrypted: i=1; AJvYcCVTbJI/BjhrCEVaJ5MObpC15iUDontbIi+H++2LE5hnAWo0NpE0KfgesDHZT/S2za3cxmGAA531nWo+N4M=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywxcj47AAryndtjO9LS+s1rZyQTJVb1xzmVvUtmFjdaqf3Oqp3l
	Vx/uRG/kpZkJEtcaTIvcbuOKJJaPLlAZUyac1EuymVgpobnFwIgH8XFmUerwD/s6HfwZqPGWQ+V
	hROr2aH6b+33PKREb/A/OKf73zLjC8xWkErk+DcVgYdyqhwZ44Bg6xoB8uCb5Y3RqxZY=
X-Gm-Gg: ASbGnct4uFD5XYIyO3P9VYE7CTD//M8L0A+f2fwazd/q+PRPbxASjGIzq0HghkdJZsg
	izzONy1HDke8ikYh02+2JHrZZIFR3WKXdYrVO9jCQENnBDk+J9QgObkfZnWNugNw1/2kus/C0yL
	0V3/nXK/yZLFnpL09SWmjqPtiAdh68SQvNRRbMwwuQxTA2joiXnkNfwXjOObM7xRy+fGDEebdol
	EgjqDtTy9E5o+JkO5IqrO8X/NPmD5XCgua3hPu90hudNvzXQ8vKZH/yH1agi/SQ4NgbM0XZl9ai
	VBF1Kh4nd4vwJg9mDqDhWiPGyv+HMfdbnHu0h68OLxFl+UGIl1HwqkH8x65sgBkInd4IX9OA5yj
	4nt2cJDI=
X-Received: by 2002:a05:6a20:1611:b0:2fc:d558:78a6 with SMTP id adf61e73a8af0-32da84ed6b9mr8614515637.60.1759990774874;
        Wed, 08 Oct 2025 23:19:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHkgqFYMmy2IRS7a6u6Iwn0slDhgJRib+1JAT43YjU6dOCmUekP/T+l8jn1xHIvBWMdRcySFg==
X-Received: by 2002:a05:6a20:1611:b0:2fc:d558:78a6 with SMTP id adf61e73a8af0-32da84ed6b9mr8614477637.60.1759990774374;
        Wed, 08 Oct 2025 23:19:34 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6099adbcbesm19239671a12.4.2025.10.08.23.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 23:19:34 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Thu, 09 Oct 2025 11:48:55 +0530
Subject: [PATCH 5/5] dts: qcom: qcs615-ride: Enable ice ufs and emmc
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251009-add-separate-ice-ufs-and-emmc-device-nodes-for-qcs615-platform-v1-5-2a34d8d03c72@oss.qualcomm.com>
References: <20251009-add-separate-ice-ufs-and-emmc-device-nodes-for-qcs615-platform-v1-0-2a34d8d03c72@oss.qualcomm.com>
In-Reply-To: <20251009-add-separate-ice-ufs-and-emmc-device-nodes-for-qcs615-platform-v1-0-2a34d8d03c72@oss.qualcomm.com>
To: Ulf Hansson <ulf.hansson@linaro.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Authority-Analysis: v=2.4 cv=ZJzaWH7b c=1 sm=1 tr=0 ts=68e753f7 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=EUspDBNiAAAA:8 a=FZPswq4iDIBThNNNJiIA:9
 a=QEXdDO2ut3YA:10 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-ORIG-GUID: aNRe2-OElL9MXHU1xrvYWVYpb568S32d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX646ingN2uExV
 BNHH4lsWsR1ItPhlqybxW9IaRVgPGuwp+vVjZ0yv0DcIieqNxDCsc3KVbz8bUsPGrx8rLB0L3vC
 M7kB/L9eKdi6/i/s8oiZruwjrxmhnuU15LIFdBahE3eqokk3cFGFja9kihZvxgamalHbKk9ftwO
 PnEiCZs2j/Tw8uHn8tH6c8e0ufWeJo9V7dZE4yYYRT69FFl+cxSYXbBasoK0rmjjbUb46okJmA7
 JwCj9nO9RkES+fe6DMSIUuIt6mRRVgai937yQZ7604vBPujHPkWx3q/OxMZJDwY8tykWi1O8+GV
 zbrmDXI/3YvN2omER/iiyghnXzxdqNvxBlE6JnxaNWHGUSttNMazML9EO84G3ojWmxh41PwIOax
 G3m3neGEMGMiaSThn7jtMs4zuTYsNw==
X-Proofpoint-GUID: aNRe2-OElL9MXHU1xrvYWVYpb568S32d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-09_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 suspectscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121

Enable ICE UFS and eMMC for QCS615-ride platform.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/qcs615-ride.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/qcs615-ride.dts b/arch/arm64/boot/dts/qcom/qcs615-ride.dts
index 705ea71b07a10aea82b5789e8ab9f757683f678a..6e80951c4159fd1fee2f737e0b271a9abaf82a49 100644
--- a/arch/arm64/boot/dts/qcom/qcs615-ride.dts
+++ b/arch/arm64/boot/dts/qcom/qcs615-ride.dts
@@ -288,6 +288,14 @@ vreg_l17a: ldo17 {
 	};
 };
 
+&ice {
+	status = "okay";
+};
+
+&ice_mmc {
+	status = "okay";
+};
+
 &pcie {
 	perst-gpios = <&tlmm 101 GPIO_ACTIVE_LOW>;
 	wake-gpios = <&tlmm 100 GPIO_ACTIVE_HIGH>;

-- 
2.34.1

