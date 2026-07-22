Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F0647DFB6
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 09:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784712446; cv=none; b=uTaJRGiOMmpLYlbPCNHhTDwQzW5AGkC833dGmGsX55zDIKyeGiEMeRgkoLkB/WwdW+YpQn3J+IsLvOObMYAkmuYgkBP9iUjZTbwCwGqsrgNIahSymIomV8mZd8HTiPFkzkEv7uPDshmTzyVwbuxhSg8INhxhHOM1HTYYF/h2qPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784712446; c=relaxed/simple;
	bh=ucguCpxbLoqpQk+XkZyYa9zl8lvCdskfB7s868tjUho=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LtWqzxdOsAM6Uf0nKaJmVpsquB33skCKYxkT/GY/jW1WFbDKnNsILoZxT85iVG3af8aXP+sRTQ+Osa3FSHnqrZYLBevek4F/aw0V8i3c/ufM5s6+3CcHWj8DA+dJ5jmAVA3f2AJV5reKW25Dw4FpMzjySIqhu1JWB5StlC79mxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hxa1+zYN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FQdtSCTQ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hxa1+zYN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FQdtSCTQ"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66M8x3gQ524020
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 09:27:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	KvsphiUTv1IYzvNQ+L1erXBxMCXBfQ0d00Rz/ByFdTc=; b=hxa1+zYNAgFeq6FK
	PUG/wAZTMeZRqBlpMcL4KehgeAj6Jnqy793nM45osKv4s7iAGllmQS3pP2B3+OYf
	IXfJvJ1suGly1B6HplZZ36+8lmwxSUvyz3TUx261cffAP9LUhTlG3pMp4OUpVDAV
	OKhhG2V2V1ggZAUhbwkCLzc1/ovHO4b8FiBMgSxt4kMMx6zb/AoLmIf/ttVlHI4R
	XvbKQpjnpbkxlyQAWGNkqAxYISSEPRLNjDO4S5yLkI5IAhnxWV5JyX6TUoViJKFn
	YQKsuH1hEXZObIIX2HjbQTi3tSiRlg4UadUIl/MkSsh9zJClZeB0ZYiA7Pg48HEb
	PeCsFw==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fjrtt0pac-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 09:27:24 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8484f26852dso8707234b3a.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 02:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784712443; x=1785317243; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KvsphiUTv1IYzvNQ+L1erXBxMCXBfQ0d00Rz/ByFdTc=;
        b=FQdtSCTQiKoVtrIvM2tdH1KFHoSTU3UgcyDttnf5ROlv62mmYVHsTE7aL+MP3pREpE
         KhbcuXfmnvjrayy4rHOjKezV6xw8lEPprP3LagJCaLnVxyZ1kvG9KLlnendXIjosXg+A
         wsZ9VzDqY4yi9EP3NsNBZP/ZAaKVYq5lK5q+UZNnVAwqwDFz1RJI3wOYNGh6gGIWrh8u
         rpmXBDQwXAYt9VeTEEgrSLWvPZxlESrq4M8iqO9Bg8NpaGA7eesXAjlFhVwMarm+MJ6D
         w8NCATTGqqlUYD2T+F9WpQf0XKt8bH/lyWX+Nn8RUWgc0KTu43rNXFWiFyBo55vbG08n
         z/kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784712443; x=1785317243;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KvsphiUTv1IYzvNQ+L1erXBxMCXBfQ0d00Rz/ByFdTc=;
        b=Z8s0aRfTb32pAJaCKOgOlZBJOo0ZiFnjpF0isnmj+ZsvBoeiOGDIY+PlRGGgluGP4a
         rFAhSoH7Hm118B45QmkYxMaw3AqYi/CUOOu/5MvaETIhQaSJLA9EdBf6ZxY5/RHSz0Ig
         vAcXRXb9FjOupkT5xDXJWxEjMVBy8rAIbgYVQZAyIjKmtVz3WDyxMMC2JYnGUF9imtMz
         m5BVf6PsXsC3qEnN6Q2sRfMYpsXza6LLqhcTdj+ZR7fUyp4lnWLxOes7TvGBMjrFPh2e
         ehVe2aLZRBsP69Yo0bz8Tisjo3jD77GvI9NWSUGEbupbguLp9bcDreSxnhI5EL4atlZ5
         4w9Q==
X-Forwarded-Encrypted: i=1; AHgh+Rrc8boBoT9uu7n/61NcyaLpCdULh4Ln1S6hj8zKyHL93P9IB6dF2mnzLGYDKuCMfHDssBjDzQxgXJRy3A8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw84CiyedsuXzUdQS0/tsXWMtjFrxiRIb6V/aqCtN3t+WWtBtk3
	Awk1y49sDOvLVKKGG85WZnIUN7H2dPMfGmYi11WFzekcB+EVF/oh3EmFr/RAknDBX84ARFhxNJl
	aCx+UL8h66t9JwulYG30zlE6p2fNq+dKIUzalJTQVXs+hs3P0tVtbzSeVMIodT2wTyew=
X-Gm-Gg: AR+sD10uPcSfokPTx29AurNYeBtPo6lWSrZA3NG5dSJ61Zlh79lwQBzumLYvlqzqo7N
	Ec53D0V6mGr103QxToEB2ofLA/tzhhhpGTixDPO1E/pyfK2jAx+QElLRyfNizc4bRoUqXCc1qb6
	JNnXss0TTUscTjwXFkPDS4jz5gEnYUVJsWG6f9uTZdYv8M8Y2TqBfnYOM0aLpFXhniPaO0MSn1p
	E6mVsvwjyzoKKon46o49+g7DiqFEu51sCF3kiqmdRJVS8ioxZv0EEvPrRC3ACL0DmMMJBWW78Ay
	RDQ35+nFlLMFI23xum6MUwB4z8tu/cdNLROtZkowOUfRc6oLIzQaZLOoJmP3MVt9kkp30Gj+tgl
	U2Lc99AMA8Xni6QOaUt/Qq8ByRyLqoDK8YDO/DRzRKmco7uS6uXTN6qka/P6fvL1/hgbsHlnBSw
	==
X-Received: by 2002:a05:6a00:8d2:b0:848:2c2e:c79e with SMTP id d2e1a72fcca58-84c292634f0mr21693854b3a.12.1784712443332;
        Wed, 22 Jul 2026 02:27:23 -0700 (PDT)
X-Received: by 2002:a05:6a00:8d2:b0:848:2c2e:c79e with SMTP id d2e1a72fcca58-84c292634f0mr21693826b3a.12.1784712442900;
        Wed, 22 Jul 2026 02:27:22 -0700 (PDT)
Received: from cse-cd04-lnx.ap.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbb8f18f08asm850677a12.21.2026.07.22.02.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 02:27:22 -0700 (PDT)
From: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Date: Wed, 22 Jul 2026 17:26:29 +0800
Subject: [PATCH v2 2/2] arm64: dts: qcom: hamoa: Add ICE node for UFS
 inline encryption
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-devtool-v2-2-d7e609ef7388@oss.qualcomm.com>
References: <20260722-devtool-v2-0-d7e609ef7388@oss.qualcomm.com>
In-Reply-To: <20260722-devtool-v2-0-d7e609ef7388@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>, kernel@quicinc.com
X-Mailer: b4 0.14.2
X-Proofpoint-ORIG-GUID: 8aT5nOM4UEIGk8yTYvZ0VAJMfH8uYrXV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDA4OCBTYWx0ZWRfX55zlOo86FyO9
 qcD6xkmRkfbvqPVXiEe4CcfJ5ZWa1rzhMKWBhFJNnXO9c9vwkLkeWz6Q3D9nyw+MIwCczK0vSUw
 OlltIv0UFzGJWKOleIYWQB0s2QSJqyN40Q8Sy8iZpJajwCl/U29evzCbIcy5EKZymwOW2Jz7Zf+
 Usg7bOZ+9BkrGnvIHPezFtAUinsmvDydYtzCuBHLPASbtrD/WKuTnMyE36tzrjrM7NKBreWHtx4
 YYLYWiRj+TCxfyypqg0dLbzSAdv2lLz6k+x4y/2C+d3IitG6uzDPrZX33Nex3+a9gMcrUkNjaT1
 f4Ie8QM30d4FDs13A+umyH5WTL+See/x3eHTetolWgxkAeaoiURrR7ePDZdG0WBpF4g5+x9Qd2C
 uWulPevAzRDpl84Es58dAQFEsrGBYSg/VI5Xw2Zw0BLpjtuOYHUpw1v1/UeQNinEjT9rrLxiCvw
 bAQdeyyiUeQHhF89TZQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDA4OCBTYWx0ZWRfXyK3wYvMrG22O
 oGAqsacIHVOh+wAz3AaWS83rr9H9whOF3WBI/SIpgv2P09lzEG0hQM1t9DL4os/2x3mxeO62zQU
 SpZetHM5VbBHRM30dLrctaK9zJ1UguI=
X-Proofpoint-GUID: 8aT5nOM4UEIGk8yTYvZ0VAJMfH8uYrXV
X-Authority-Analysis: v=2.4 cv=V8lNF+ni c=1 sm=1 tr=0 ts=6a608cfc cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=7g7wA4PAc6ioHu1SxIwA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_03,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220088

Add the Inline Crypto Engine (ICE) device node to describe the
hardware-accelerated inline encryption for UFS storage on the
Hamoa IoT EVK board (Qualcomm X1E80100 SoC).

Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/hamoa.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/hamoa.dtsi b/arch/arm64/boot/dts/qcom/hamoa.dtsi
index 0840eb2f884f98d76442fac7888ed49a07780898..0c9b459055d720a528a319272161d1d7446daefd 100644
--- a/arch/arm64/boot/dts/qcom/hamoa.dtsi
+++ b/arch/arm64/boot/dts/qcom/hamoa.dtsi
@@ -4176,6 +4176,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 			phys = <&ufs_mem_phy>;
 			phy-names = "ufsphy";
 
+			qcom,ice = <&ice>;
+
 			#reset-cells = <1>;
 
 			status = "disabled";
@@ -4221,6 +4223,17 @@ opp-300000000 {
 			};
 		};
 
+		ice: crypto@1d88000 {
+			compatible = "qcom,x1e80100-inline-crypto-engine",
+				     "qcom,inline-crypto-engine";
+			reg = <0x0 0x01d88000 0x0 0x18000>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
+		};
+
 		cryptobam: dma-controller@1dc4000 {
 			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
 			reg = <0x0 0x01dc4000 0x0 0x28000>;

-- 
2.43.0

