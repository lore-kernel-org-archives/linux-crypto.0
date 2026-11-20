Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174229;
	b=MVni7tNEcVV11ILZ6bcIvq0Wrz7qoouF3j47oKhrTb3uYh/5//V7Yy8dGB7zGZl6dI6P
	 UzKgLb8MH5XOm+axBgNFTcr+gKdHs+mxIUURad9l91QAvsfApvS/gzLx3GbuDLvX1gZ75
	 +idlYzyh9FfdnYb+gQUTWfp8agCmJRUfLt/Rlf8k9PI4sSlYMKa43aF0neVeAtsoY/iz7
	 QNuBU5K5NASje1D5LM0FU4qEkP2QjGf36hk8+pgDmoSfjEYHGCmcJ/P1qniMtueTPnP9b
	 Gn/4YTwcxffdZZvHtzWkzHOLy0ctv/6FKBE1JgbzPlnCt+l0+VfLAGfnVGdO1w1iemg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174229;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=sygOK0V8Vg+nVjbZjD5jOaJ4Wu4SYL3cH3HKafImClc=;
	b=2eNuPq1zURpJeBjSO1oGlf0T9cEBm4aJSGnXN66MXXGYx9KX3COmq30QyETsvdHa6rQG
	 THt/C4wBP7H4zUi3j4CtO8Uahynaa5C4oD6o3WcV7V0I21L8N+GDO2yPt08eC3U7ejCeZ
	 t1IXIVWGG3+qVFDxPzZQ+iDAlLgpmSVsUWzzN+xWFCl0w8j0nJZ96inkjnbSgTe0/yuTr
	 lR3eu4lvcXC4U2gQUU+cp6gCcpQPhAKwXuJdaOFNmQelo8MqrH6jHId7AWFtGW+RwlZPV
	 4FuK0FlLKybopL/2OXS00V8KjiXup9h9Sw4/QqW2Fdxua9I48Y26IGfLB3b0XbCiMGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kH7d9WyN;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="eayJzm/6";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64D5606A334
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 11:30:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E64D5606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=kH7d9WyN;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=eayJzm/6
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKAkfEh3107604
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 11:30:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	sygOK0V8Vg+nVjbZjD5jOaJ4Wu4SYL3cH3HKafImClc=; b=kH7d9WyNV7ikYQ3U
	UZw1dG2n7DD/fTcifeIt9Sgw7yIa0QIDghBW2W3lpb15UDZNHe5bN3N52JGVaK7Z
	scQAFu8d+bewhV42tqiYaIo4kAWfWNYirZLcMSB96+2SNdQ+5JrdCQ+D+GE9uYtc
	LDdDA3IQXW1vExf/31m+T06uQj1fYkF+wtMk36hi+lHRF2P2A2pVlfiQYNjf5Unz
	GXqvtp39DbKgm9I1KvBOE5+pIzIX82r19e8U87MATK/ejV/sAOE6ligskRXBKVqy
	Q3o+j3yPEjMKhRpx9UzKHQJU0JkMVrf+KsxYHhHzFIhrnYcj35nPOO2QYm5IbaqU
	nFeNrQ==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j27au3ek8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 11:30:27 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2efad644688so8236395ad.3
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 03:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795174227; x=1795779027; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sygOK0V8Vg+nVjbZjD5jOaJ4Wu4SYL3cH3HKafImClc=;
        b=eayJzm/6VOlgwDR4WGLFs1SuE855+P7Haat5Lh+nVephxop2r+jy0N6jYACaXris0i
         Kbc4zfzArGVmY+8+AHhEZP0rQZ029/Lcmihim8DX+UxQVfq1Q/6ZdH/XReF0oXG+rplJ
         yvBS1q036LTcJ/J8R1VLG5jXVVxwaRucUvVcVJEbP7Pvp2EgmPZYkIUeprVTUxF6mtx4
         MNAMFjyrjbmsvv9knIeHwBPGdh1oPC6Vk5HnCyr33joK3a9IUNa91bAYgZfL9ODvLiz2
         YhpoFyzZ7ef0IIUwvOW3ZZ+uLmrYAwvwisR/fxoT+ng2q78r3SaG8VTlmwqBlibk+v0/
         u07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174227; x=1795779027;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sygOK0V8Vg+nVjbZjD5jOaJ4Wu4SYL3cH3HKafImClc=;
        b=gIrS46N6VkXk2Q4j/11FCNt6ul013tHP6OSvFq5v2BI2d4mnKYK2wi7edJqAvTre4G
         h+y8OfyvIGJMsC06aUp+yYJUliCh20Ab6E9ttUzwKG/R1yU/r/fwD82nZEL6pVJmBamy
         YQmnGSgahWeH9rJxGnWMtJLOO3tKwMjFCaLwfEjD9vmgF/t0vDn+Q+BIjOp+ZSIeHGv9
         e5KSjlk3UpcOxWUAPfnDH1g5Ei2rKU9AuEKZ9UjBPdApgr1R8q6ZHXsgc5v/XrFOdpMZ
         RIZJSvKvu/ViGo7rAn4lb5URzyX0gMA4ewbfI4PLRV34rLHM3ohIUwRx8mAKObWX5UTq
         HdcQ==
X-Forwarded-Encrypted: i=1; AL+hErHW+vPAOzhbIFJqoS3EmjKE8+dYVeaKpGwVrXdOnQMMS5tphgjhuv1nhQuyvadNrLo01UA8qaAo0zdTCow=@vger.kernel.org
X-Gm-Message-State: APuU4Z+I3wSUosQR4jQSN9nGR6jUQbuz0xSyLxYn8FSrAa6Z6n2f/Y+5
	b/m45cjVRg/IF7hhg8uvlSjwtqa1Dxxsoi149jq0OtPScIcT+DX+23gFDmy+YSLBAkwAx9alBAP
	a8y0ikbSVaRM4SPZuVSiwb9JdHup4CTZYDjBdLTqPiZsVru8ZrD0vJC0LiW+7ce2Q6Dg=
X-Gm-Gg: AZFdTZeUrsS96VV4Kwc1jghFdr/f51zcoN6XVAXG2vg7MVGNCOQZPIeHwRgmeTvdYsw
	GFvsS7mT2rzSo/h+AxrMt/ETV5cd9jVIzMS8RPmR0ukKThI5zjkSiETgOPXMnCC46Ts35UJztlI
	vjibccsrrnp2bXpkRHG5wn5aceDh2hEDoQEyhDCYZlRsyjtVODy48L0x+gMSSdJGccfWZmjAnCE
	eT6z9Jx691pDLuJWFyE0AgvOx2V0O/UmgbF1axI0rG7hTi6Zm5v9bFxy79NxUDEMLzbPLVLYmnQ
	JBgHd5T53bAzrtY08+UswqMAJxz9ZFFIpCvzcS1UFEY0d8X3Qu8LSMxSf7RL0J/kr0sdfBXbXKh
	XM/Cd2kpXaOoRG0PkcwwtFyF3oOCimEyGfdghlEseNy66QOQZnlCH5YKxcXf8RVLFT3rLlumwxq
	oone7ObMM=
X-Received: by 2002:a17:903:2283:b0:2e2:f2f9:b1ef with SMTP id d9443c01a7336-2f03f1b9a56mr32036885ad.39.1795174226649;
        Fri, 20 Nov 2026 03:30:26 -0800 (PST)
X-Received: by 2002:a17:903:2283:b0:2e2:f2f9:b1ef with SMTP id d9443c01a7336-2f03f1b9a56mr32036575ad.39.1795174226220;
        Fri, 20 Nov 2026 03:30:26 -0800 (PST)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f04f6049dfsm2751245ad.19.2026.11.20.03.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:30:25 -0800 (PST)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Fri, 20 Nov 2026 16:59:53 +0530
Subject: [PATCH v4 2/2] arm64: dts: qcom: shikra: Correct QCE node
 configuration
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-shikra_qce_fix-v4-2-5249e31394ce@oss.qualcomm.com>
References: <20261120-shikra_qce_fix-v4-0-5249e31394ce@oss.qualcomm.com>
In-Reply-To: <20261120-shikra_qce_fix-v4-0-5249e31394ce@oss.qualcomm.com>
To: Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA0NSBTYWx0ZWRfX4JcXlyn05OAH
 Nyk4Tb238b1rfAu2HSPEO4+mQvfYICP+ZFGocXjBn4QpmvVtXahK2FgC37JqP06qi91E6no1glO
 TIILLucn4ZVzLqYtSUFVdVUb9Ar5gxtn2hoIvvzJ2S+8N5nRkXI124tom+8SVjLw54XsCAsg061
 iqkiw99fYeoHL/rcWQtOtEHbt+23HwgLdMS/dYmxCUtE4i3Ex/RQV+Dkj3m3Q6ZWX1fj1nfLNcm
 /Qy+QbAhaBdjS9PaZNwvWvj/cg0K+0PUFPKZuNV6yyxCVzESfgn9j9FxIqYeOrrWM8nIAzzfkcN
 FETcLACdZL6AhTszutMdj2/WypjANCOziSTRtFSwI6kcZROY2n+QQOqPnb4TF9fd42MfC3NZrLQ
 Wbkvn89AJJ7LIlDGkdOtQdnO+S3+189Kkizf5R6Qp3k6kyksSVsfAaZxWW7WLJRfRFtLiURl5jf
 xs7uMx5uDgi0z3ZpjjQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA0NSBTYWx0ZWRfX3qjjf/T0dHat
 xr8sHLSJqVqlcSHNpDMD4VLytTgb4W4IxSWvUNl9+Hm9BpCjIiq7ig6UmFDEDvrSvsJj7mQ3jGT
 kszfTrh+4IQThU0SdvXQ/61G3ecFfLM=
X-Proofpoint-ORIG-GUID: MYE52lnOOJe9Z7xzrOo9DnHwfHZeJfCj
X-Proofpoint-GUID: MYE52lnOOJe9Z7xzrOo9DnHwfHZeJfCj
X-Authority-Analysis: v=2.4 cv=KuHYSmWN c=1 sm=1 tr=0 ts=6b002f53 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=nsAWE0-7qdAvx2JcIW4A:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_04,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611200045

Shikra QCE requires an explicit core clock, which is missing from the
current configuration. Adjust fallback compatible to "qcom,ipq4019-qce"
and specify core clock to match updated binding description.

Cryptobam is controlled remotely and its clocks are therefore managed by
remote crypto subsystem.

Fixes: 099cd05d200b ("arm64: dts: qcom: shikra: Add ICE, TRNG and QCE nodes")
Tested-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com> #on shikra device
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/shikra.dtsi | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/shikra.dtsi b/arch/arm64/boot/dts/qcom/shikra.dtsi
index 0a95ad5a5582..bb9ef1dcd686 100644
--- a/arch/arm64/boot/dts/qcom/shikra.dtsi
+++ b/arch/arm64/boot/dts/qcom/shikra.dtsi
@@ -1208,7 +1208,7 @@ cryptobam: dma-controller@1b04000 {
 		};
 
 		crypto: crypto@1b3a000 {
-			compatible = "qcom,shikra-qce", "qcom,sm8150-qce", "qcom,qce";
+			compatible = "qcom,shikra-qce", "qcom,ipq4019-qce", "qcom,qce";
 			reg = <0x0 0x01b3a000 0x0 0x6000>;
 			dmas = <&cryptobam 4>, <&cryptobam 5>;
 			dma-names = "rx", "tx";
@@ -1222,6 +1222,8 @@ crypto: crypto@1b3a000 {
 			interconnects = <&system_noc MASTER_CRYPTO_CORE0 0
 					 &mc_virt SLAVE_EBI_CH0 0>;
 			interconnect-names = "memory";
+			clocks = <&rpmcc RPM_SMD_CE1_CLK>;
+			clock-names = "core";
 		};
 
 		qfprom: efuse@1b44000 {

-- 
2.34.1

