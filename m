Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E7B311C3B
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 05:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765345034; cv=none; b=Y8h2JLYgoAOiT8WK8n/7rPcFA6JA0Rr9emwzNN7Mjytpi2ggDpgzWBT+g1KM2uWFbR4PAUb5zh64GRqrcLzyMUqPF8apO3B7ckQ/raIOpwwsDVX32fAU2egwVpWd+Zm+22Qje9kW24TT7QBXsk9IFV4W5XEl6zObq3mLMg74tS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765345034; c=relaxed/simple;
	bh=tA7rSWjOklQFAL5MqnFh0aLMS/Kqq/abTUJ7uP0yas8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LKEQod16UTxrxS4C/KvaRVkPeFUeuB3eAWiqrQKpAqOwi4s+N4vrcLtcvUDiO11EBek1RAoirdvljnHFNHth5MN2DKyccFFoGc7rtBUvUZ5E98LSOqzsNov1EN6cIbxAOFnL0xWbRn7AKc849o+2wVWXwHhRsms8s6QNWZUiLDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LFJ7xJ/r; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=V+ekR7BS; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LFJ7xJ/r";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="V+ekR7BS"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BA4Y73H1967841
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 05:37:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	NEL68xIdbSe0Bko1W614HTi5iAYgcxCt/fdYmXWqPwI=; b=LFJ7xJ/rNZrMa93B
	ONqVDbArfegKXidTmWYThKw4PIpfgViPWI4iYtQRtXbb2OipYDp091fzmnxXFgWN
	0al9XGnfmdvTVESk1rkM9SVmXMmXapJz9z20vkNBodUitifLF2rvOtFMzjjEa2gS
	+h9czHB5UW0Zserb2E3wpYypUp5yrmv8tf8rIOfEo5jhwlnyfWak8sb4DOWC60um
	yA7BtY7rNGJvb5F89Olr3aDb1ttAD7nd8uszjbyplQCzQulbzHS7V1bYN7/4lhlW
	92iZWlLQ72X755q/YzVtzXaHdgAX8nKhFhwTxPucspvNzHBxqy57Fxrsfzr9ZfkP
	MLOoNA==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ay1xwr4nj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 05:37:05 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-7ba9c366057so16588070b3a.1
        for <linux-crypto@vger.kernel.org>; Tue, 09 Dec 2025 21:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765345025; x=1765949825; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NEL68xIdbSe0Bko1W614HTi5iAYgcxCt/fdYmXWqPwI=;
        b=V+ekR7BSG5C4usoq23l7jFXG1YKmcW8oMTm0TzPVv7hD/ZdFNpMW/WLLsvDNll1NQj
         G+doyEIgFBnO0pQvbdRu1dNCEJ267wCKEeyZXewpD/fCgWk6kEc7QRvRUMC1OFpQaQzv
         4WLuO2I8DfcluqmOF9BMXizSuso5U4kq65NMklmkk+Xx+PdXJE0r+HzKvS/AQyJjVqS9
         Ltgz91klmU41UDX56spCj+clDZ4SQ9OIu4ErfF+3b/90b+FHD7fAMu5OMtI6pbq+Sczw
         pSVaFm8RF+lOs+p1K5QhDzn6g7MH6rDki2M5bB2eUl8/ltHGuZkYK1uEfRtCRUJarvj2
         wLNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765345025; x=1765949825;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NEL68xIdbSe0Bko1W614HTi5iAYgcxCt/fdYmXWqPwI=;
        b=lrx2LUxuuosMwiIFf4Yqa0E23+UUHKdrF2uzwl7MXZqVZVoN1SMI8AOKQBg1becZyz
         Pw9BqqM53EbppZNkysbfXqOkRcRcn2u+VEfH1lBgS8gb4rM+JNtU6/VVRIWIUVdJCyjJ
         hsqGiRPKghUukRmVIfp8qTZ/kQX8Wvap2r0Zw2f0tQIAEIzXImXjvQlD5C0u+Zkr0GRw
         YQj1vPOFBOp13FDlb6edjh4w65UN7DyYK9/h+4UP3nqsh4+OrktOuru/rOxYHEGaXGN8
         Ej/kGk+KQf9CHXTIDZbxUjD+7Na5WBLHM+/Q3+jOG5+aFX3Oy+6xh4P0Q15ffke6CrC6
         MMtg==
X-Forwarded-Encrypted: i=1; AJvYcCUUynsE2XNE9BBzrYtRN0aOc0YowXNCf/HnVgVqKeUoY4MlgGySxO1heA/ENHOXKL/Bz9wNZHEkpjTqeQk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDiVPg+nFi6HLqIsLGDOyhu1zdTme/jhlz7dYv8fCQQzQMCpX5
	0V9n41VvtTjcUpaf6Bm6FGprnVnR9jj2i71XiYGyOihAw9e/R9daoqZRBTwKOE9mFEZwLv9vKcQ
	vOETU3r6RnFZJpNuKvsP8ouIcbQtwN4/C3XIo3kD/OQgokisnlUcT16MgG+sI80gfg/0=
X-Gm-Gg: ASbGncsTDfjXN7N6BAn66iYeSAL966jY/nTN+a/dI+uScpuLivYElKb6DyMorYWaNEO
	zFS+ZGL1AidZshUpQVf0g86G+fiIkvwchJ5Xu127JBrnRFzLqZn2gvbPf8m+5+adUuvw+fMwNd0
	PZvdqPpIvly6KCcVOq3yUSOQglC58id3vgo3bs7wdIGuVuz4HfK/4Qiu8qESXmy0dpQYPUn2qQ6
	EOzCxDJ729M1/eQjoNciyfOBeCIAPPo7ezdQVEMyOfr6lwQuEI1TgIsFAEm+VsMsWSnx0JAxLCn
	Gzu74Telsu+UUnMnKwNNSj7kOd9VNLh/FqI1timQ4k18i8yL4W+t1+gHxV4QN0XWb5V/QRY7L8z
	0uFg0nG5K6s/gI+2jeVIorrtwVRJVjGPPqBY=
X-Received: by 2002:a05:6a20:7f87:b0:34f:ce39:1f47 with SMTP id adf61e73a8af0-366e288910dmr1122323637.38.1765345024716;
        Tue, 09 Dec 2025 21:37:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEjZECPiNJQXVyw4EuZv83OKaqeUlW/PwVnHPb4uhx3Ws0ugaJSs1BWZiGywBrRIWSyWb34VA==
X-Received: by 2002:a05:6a20:7f87:b0:34f:ce39:1f47 with SMTP id adf61e73a8af0-366e288910dmr1122292637.38.1765345024298;
        Tue, 09 Dec 2025 21:37:04 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29dae4a13d2sm169256555ad.9.2025.12.09.21.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 21:37:03 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Wed, 10 Dec 2025 11:06:35 +0530
Subject: [PATCH v2 2/2] arm64: dts: qcom: x1e80100: add TRNG node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251210-trng_dt_binding_x1e80100-v2-2-f678c6a44083@oss.qualcomm.com>
References: <20251210-trng_dt_binding_x1e80100-v2-0-f678c6a44083@oss.qualcomm.com>
In-Reply-To: <20251210-trng_dt_binding_x1e80100-v2-0-f678c6a44083@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765345008; l=942;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=tA7rSWjOklQFAL5MqnFh0aLMS/Kqq/abTUJ7uP0yas8=;
 b=WKRc479l6Rwbw7btWzYkd2eZMj5IzbQH3IELDW8yhRqpIBhWJoFSXze31mw1VBX6SH4wiJgAq
 dgVXz3j2legBmt8XoForr0FdpHj4MlURw6xb0ETVmXBMkI9he7koxUh
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDA0NiBTYWx0ZWRfX2aEyLUoxPR0y
 5cBtoUHEV4xbDoYe2mYMZ+Wd8DEUvy7c4mE4bxRkTlx3jbatJZ/NlwVXlI+JA6X7mvvsbB/24fu
 I8/nU/1D6SSEqkFr61xtQrUoV2BwC0peYGAIBczhPeEzLoCKxXV24TRjusE2+l2qu5nP7UkYCZc
 cgeGb3pmlSasmdls/4hQHBSGzXC9b8OjkjnbxLc46mR1lLA2PRA+0nxH8waAB2LZWkRS6FFdQjT
 acYBDY9wUGqwoRWPfh0+Nb8OpUYcwUz4XBoQranuXErt6RZFh6vhy4o57kHDnX0fqktE11RK0jW
 YWaQAYfJLQkEYhx45LELzawuNVc3GbR16om7oOunC0523Frp29l4gvf6QPwWV/czoNUx/d15WJV
 OkYSUW/DxxuNW99OkOQQGAoLtpakFQ==
X-Proofpoint-ORIG-GUID: R-EMa58TmjDMreBsx-MCW_1RDIPEHddp
X-Proofpoint-GUID: R-EMa58TmjDMreBsx-MCW_1RDIPEHddp
X-Authority-Analysis: v=2.4 cv=F/lat6hN c=1 sm=1 tr=0 ts=69390701 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=75mWG-WH9mJFzEGoRSkA:9
 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-09_05,2025-12-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0 adultscore=0
 spamscore=0 priorityscore=1501 phishscore=0 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512100046

The x1e80100 SoC has a True Random Number Generator, add the node with
the correct compatible set.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Tested-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
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

