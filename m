Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8FF3043D0
	for <linux-crypto@vger.kernel.org>; Mon, 24 Nov 2025 17:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764004153; cv=none; b=oSBu7HhsSDBv5NfVRL+LHYZCQ/UQNRNlvm46kpqWroySeZ6muBQdIxy+/VYMyCIx5f1QEzhnyOCswV6PdJP7ZWY5DihXL6PevHzIewelJdZyBoyisxbiU8Dj0HQBHdR9j++0J22KWmMk1w0jIrHNYCNzmOUWObNeTx+UqwKVVR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764004153; c=relaxed/simple;
	bh=ofR3ihwtzlWlypMj/ZJqBpSefmnA44XUKBt8ZlrNmIM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tEOoruaXViItbV+5NQPEq+SoTWtIvBMpTcz6DWGGWnkaKvOSrcrL3FYTMBG2pRPYNvovW9vmydXmMZpnhNcy3bh7CKTh9wpmjQc5A7clvKtx7R33FMDMKmdIFcJE3QkejjERfE710Ncj4J3qVIOk4YuZvDjKygTHpdZHXDOv89w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=P9Rn9uoo; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=I145VlTq; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="P9Rn9uoo";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="I145VlTq"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AOFuKEE776425
	for <linux-crypto@vger.kernel.org>; Mon, 24 Nov 2025 17:09:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qXj0dS+IAKlzIFNGRz3FAzPlvCUIBa+JNmjbJBENYas=; b=P9Rn9uooJtoz27w8
	vtVjrcjkW2gAZDFHj1zzUwU+BccBU3iehAOgqmzLFC9rngZy/94ykk0DXygEBBU/
	4gSaNojDuv5E1cVBCUEVZ1t2Q3qlxXgIJPTZUPqayF0fzRSj4REW0X+2s0kvnSuf
	4u3By1Hr/NS13mpY5nhHPqa2hvMMis0V1ytbwUtrFPdNHeK7wVvXVJB8T5o4eK4/
	1JyVEMLBSbTVU7NiJuWZEaANRAKSumr7snaPaUB7vdl2HYKs1czDfekPnT86l7m4
	80iV8bWisrRFMifjo5E8djT23FFmwAgFAw9RFmcEzjoAjz2jE2F/jS6ctT2y6W/2
	ZxFc9Q==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4amr8s8nw3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 24 Nov 2025 17:09:11 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2956cdcdc17so47897315ad.3
        for <linux-crypto@vger.kernel.org>; Mon, 24 Nov 2025 09:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1764004150; x=1764608950; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qXj0dS+IAKlzIFNGRz3FAzPlvCUIBa+JNmjbJBENYas=;
        b=I145VlTqoMf2c31TmOpOwI0vusjscoM500WMpw2rcjWaYF+d4qmbqDnSCCtn6txkGe
         nC2AGb86F6wgT+o68DvHX0Zv6kSKRhIGSacxqGUA6bZwf9s8hqJfMyJA111k6ifeB1xR
         9gnpt1R8IHlT3NtsRcVMvR6ActvMUnBi6VLgjKoGZz0jcs9BRQKm0yiFJqo/IB0pG3Dh
         EI6YMwyZD95NfudKo5kKjNQHHIt22sLLdClJRQKIfjiODC6Pw1IJrp8AW24VLpkjafLl
         Ha5eT2CB5MA7ChDY0g8s/C7+agbTB/sh03Fc3X3M99rnAWy/pNNuCtMiGeWRhbWGwq95
         uKlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764004150; x=1764608950;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qXj0dS+IAKlzIFNGRz3FAzPlvCUIBa+JNmjbJBENYas=;
        b=KteS9G0aNBkqvxjNtrgrvI9MH5TsnMdOeSLK0TJ4tHQA6krQyu53PLC8Cphhb5rct6
         2eZ19Yr2nXozAn9vJcAwb2mkh6a0Qp/uOQksQ+j4TRKmzo7aw85+6G0l65AgdoYy9swu
         xr2ADi4V68kdwmD7e4L6rhCV8GbYB5sMmKM7pbQzRcgLWzOQKkAHwELNaRumcIgHRi7t
         LvoqtjwQGHB2B0ngNI9/ePajy+a20H/++i6bPmB9dotfgBB7/dOPFC47hu8BiXnEUjbj
         02H5la50l3WknwwQtIRJMZruqr5xAeoOCoF1Z47jXqPJEcoZqjOmEfRAXONDgEa3pizj
         5zcw==
X-Forwarded-Encrypted: i=1; AJvYcCUZ/yS8p+kqkVkkx+DADYvwnlfG3238RSyMvDjcQmwYVo4eH4rAflX2LQ2RyDbknQOLT4/A7oVFt+UUvEQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLmOEp9ylPtqu+0pHD6omIolIwaxhEryReB2KfvGirB+CFaZtM
	Khd6HaWTNNgZS0H6UkAYY0VsLKlz4/UsWgfu+jsPSz+ZqNPFAlN0QFJa7HA6V5Ds1hU4t6UZeWs
	RDYjexGt0bapyqg+lkmOqFZ0R5Up88wc8oP/SXp5IT7NEtt34Nsf2uiCXOsFI4POlCMM=
X-Gm-Gg: ASbGncuDSg5hwfoTSN0gTfxjUTy3BTd4qRtX8g0WQa78Cf2hb3vj8uN2BkTougjOshQ
	jXy0a3n2dfY/eFFx2WKkjQC6mnHYZrzbYx6ty2yb3vaet3L2bWtgNpX3QI2Fu7H+Hx5q+gwCsnM
	buoIpPXiBQjnjBXagMfB8KInb1ug7SDQtEytSNGUSjVySUUtQAsxA9rBA4eCBM36Mp2dKuZjys7
	QMqKzaCUdshFJv92ARUYCVBa2OQhvixINx2HDnLRt7v4xtanABjAnmhmJLEQYu4kOg9ZZPTXc7F
	HOpoqcPbi/jatxnBnIA7/B35xqYlbiDmxNfp+WueXRCj1H1mc9JnmOIW9Icxah3QNbYCR5VHWyM
	/c6uiJ2RS7kkfDSl13bfIueyg1KU0QZBssL0=
X-Received: by 2002:a17:903:2c9:b0:298:cb9:6ff2 with SMTP id d9443c01a7336-29b6c3e3f1bmr125395705ad.15.1764004150066;
        Mon, 24 Nov 2025 09:09:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFbDD2EFejyNXx7KyZ8WflHqAuidxisctS9ZRCxozEEZI/rIjSILkiUYUK5QQsyPm/0Erq5oA==
X-Received: by 2002:a17:903:2c9:b0:298:cb9:6ff2 with SMTP id d9443c01a7336-29b6c3e3f1bmr125395295ad.15.1764004149544;
        Mon, 24 Nov 2025 09:09:09 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b107effsm143949275ad.14.2025.11.24.09.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 09:09:09 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Mon, 24 Nov 2025 22:38:50 +0530
Subject: [PATCH 2/2] arm64: dts: qcom: x1e80100: add TRNG node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251124-trng_dt_binding_x1e80100-v1-2-b4eafa0f1077@oss.qualcomm.com>
References: <20251124-trng_dt_binding_x1e80100-v1-0-b4eafa0f1077@oss.qualcomm.com>
In-Reply-To: <20251124-trng_dt_binding_x1e80100-v1-0-b4eafa0f1077@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764004137; l=818;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=ofR3ihwtzlWlypMj/ZJqBpSefmnA44XUKBt8ZlrNmIM=;
 b=6aK7rN5rBS5D6rNIRL0jXwFbmQNqOp6NjeuNq5yPThMUPdqTY3WJm6VU9vtSi3xxPkEzOeaIv
 vV7qjufcr4JDHUHp3gbVsrD8ZBuSCl3CIujBBANC0M6yS9ktUIwZquL
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: -D4a66mSFT46XyZRfUJUYYUf_PW7zXSP
X-Authority-Analysis: v=2.4 cv=KP5XzVFo c=1 sm=1 tr=0 ts=69249137 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=75mWG-WH9mJFzEGoRSkA:9
 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDE1MCBTYWx0ZWRfX2v64XokEITF4
 prlK+Q3/VBTFasV79ELMr1YeLpHilBCQy9/9KrGyuHBFfPZwjiE7baYighvoMXRCJMbz35jaXME
 S7uaXQC/Mu8daV0bF0tICFH3fojNV1QeJ2ErpxnOsj4DlNp0qPix8F76mnXa+kc7yXxsAKm1rFh
 58UmFimXT0KnAMh/IOh2JgOgd13B8E4PXKGNnYr0nZ/BMFYHHg9Lo2TquH/d2ZbMZV1LgaIycGj
 5EgwyjtMLEIWr9bL0jfZWPDcnu+MhbssME6Cm4+Q01q8L11K37jAXOnScGhAnUbtvVT/cCqbyHy
 r2pcOQyagfl4Yc6wbhw6483wlFIysDRA8G1HZpWve7k342xGCpjlbu0/G8i2ehljyGyHjEBSMqT
 6HSMkCFASG+sQnoB3sk2s9lQz2hLew==
X-Proofpoint-GUID: -D4a66mSFT46XyZRfUJUYYUf_PW7zXSP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_06,2025-11-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 clxscore=1011 lowpriorityscore=0 phishscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511240150

The x1e80100 SoC has a True Random Number Generator, add the node with
the correct compatible set.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index 51576d9c935d..c17c02c347be 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -3033,6 +3033,11 @@ usb_1_ss2_qmpphy_dp_in: endpoint {
 			};
 		};
 
+		rng: rng@10c3000 {
+			compatible = "qcom,x1e80100-trng", "qcom,trng";
+			reg = <0x0 0x10c3000 0x0 0x1000>;
+		};
+
 		cnoc_main: interconnect@1500000 {
 			compatible = "qcom,x1e80100-cnoc-main";
 			reg = <0 0x01500000 0 0x14400>;

-- 
2.25.1

