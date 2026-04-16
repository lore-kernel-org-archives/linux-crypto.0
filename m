Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9735C3BADA3
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 13:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776344864; cv=none; b=JmTayJcwKQyMNaMuVXxOIZVwwaHz0ymJ+3zkYksI8OqvnCTIknXV/valRwYvzdjljswKmIhJgIujjWGwpUjVr28oZYqQjNQoEzPb/eAwA2s+iVKYSoUyeGoJMHcVBu10MrVAsa1Cuv/7hV3Vd1n79l2DK0ug56HjQGNTWggtNdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776344864; c=relaxed/simple;
	bh=mShqz2LMKwbtHeVqOaBAu5htLUyQtdiwxxmQtKd8+i8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Gd6+/MADKe8AaDeig1tFIbOnoNC6qW9K4cd9vUYwgv3KRMg9VeLImn+sqSwNE4cwhNd/8fpNNhglMAfC7UvrPyk84H3N2DB3H4OaMUpYqiH7xicJCAMwXhYXIniY0HGGpVYtr2EyzbKVk1NyhET0PR/jQ9I65MlIOA7mb54cCxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pn2CM67Y; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cTWl51f5; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pn2CM67Y";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cTWl51f5"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63GD1HGD218900
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 13:07:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UKaAroiUFfoD71Cuw6J0zx2snzlwzrwrTDDWD+/pN0E=; b=pn2CM67YksImvZ3q
	kKANo5vUejPQWCDcNARZgJe91tum3kz5quB52XdSKaSXU70/SJndA8uaOM3yI1aO
	TfPQdsAUM/Y08S9LLnwPMSYhN7q+odVjzT+I/RnEq46CZYSYSHcTFDmrdAgHNf0O
	/28nG4tfswMy+IAj9eHE9qweReSFsO0bQJZBBGTQG4GIHy3lLGP6LXEMs7BCKYwY
	SZdNt5KpXsVspdTcn0WEMltyWQbQxQiWinHz0iJZ9b7J9DxbvAB2RaYKaW0xINUb
	/EU5GBn3iAFvSZhfcjwe1WqDa+duYLewctrBAohH3hyz4GdFagBX+yyHihzO8FIA
	pr32BA==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djtuyha5p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 13:07:42 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-82f504f6b75so1963395b3a.1
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 06:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776344862; x=1776949662; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UKaAroiUFfoD71Cuw6J0zx2snzlwzrwrTDDWD+/pN0E=;
        b=cTWl51f5T3i3Nkx+6BqoGhQrI1cfN2HsJBwqfIn9Ji+y0H3xm6LOGB4OP4Iop9mx0m
         D1zF7iSFdcFjXeZgIIvYx8RZ2nUinVHejOnk5OES1wUzXxlUjOftOfTNSaKapG00Z7JI
         SYJfW+tBgyPfRMz3IvIBAHbt+rHGsnTOdkQANwWl+QO6lhZWBAT/fE8S+RzupnQiqVFM
         C85seBTM+x+qjxuEPbU2tnnp3bvMhUFvIs/Mrve3TZaPG/K3rsSFivuoQMjn9XtwYgpx
         jkX2V5J2tQFPHUYg5u4TGHycCFFjDkXs7va0IQPRpV8+DaKljYgkXr6XHzqsWodJJzNh
         B/sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776344862; x=1776949662;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UKaAroiUFfoD71Cuw6J0zx2snzlwzrwrTDDWD+/pN0E=;
        b=h0VMq4fOzgL1JHPL1UO/FVB8y0LkUqh4OcRlK/1cFjvPfz26txxv7YyzLeNy897FUc
         ILWbPr4G74ITGucNGoX3rXqhnTE0e59e4dsoWlF7Lwj2k+62Y4XGMnQt15cahwPlXEOs
         5+y3mvPNNzqTPDZQ/zW+rRXDFWq62hyExYkrMfZ2itFr5y/OrX319kbmNXWs7dw0cTOE
         l0F/+gXabJW3M+lrJJ5dZz4AToCKsUwQpfR2CULmtHAyuL8yOvQVYjP0bDCzS1G7Trdj
         1VNtpBjnOBmJv+KiBr1a444njQaeJObzRTND0gV4Kdbdx2Ws5GIm0KL0cefwwWKuv2H8
         2rxw==
X-Forwarded-Encrypted: i=1; AFNElJ/W3hSOWSYRSBNg8oQfVjA8XbjC5IE6409czTuWMq9ydC7cRpTZCrI+0ArX4M6ib3Xk1+JfHvI+BaKV6T8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDWTygNayHCKmUJISEZdW8QLXjt/rOQ/1QKa2uToDMbHPXHtAn
	1fEEY+1ZoLaR1yPKjZcSEOZYNomJB+QEqgwuVpZWIsnLfW9jAUlz4Sw0MQu/AHkIDYnF6Bb9yfc
	LQyUKeZH8EseNRK6rkP3EqaSx2S9eKX65tSwW0QoBK9mq59ZFOygL3Zvp7jNaAdEXxtQ=
X-Gm-Gg: AeBDiet2/ZePlJ6gKjigTh7C9f505ZWKorr/6PkoUCCCxSjCF+HG5oj5FKOjjL8lbrl
	BEh69l9qlTs/AwRk0ewGAxdj0+90Rc+pXPYSNZ336MzaKhu6r2PbK2EIOzH4CCAGiSNEhh7Fybt
	opxWuEh8Zhzxw6KjnhY8M105z5vhZ9e7HL5yDtTUT3ppdf2RdHZruf3uLAl0YPPa8QYAkvkg54K
	Dv5ZExZRG+3hepTHRjMhP3fKJyetnLfIFfCxQIypdNfPsGmHBB7uz5HU8/YEP+83YEQNaDMmryE
	3LnIcbjoJWSO6xIuQxjP73jvt1Zf7CyqTo+6xCy61FN9vfnJah2ypAj7ICvVBpZeTMaUPv+ubJw
	utGgtjdNXmDg08MZc/ZdVVsKyQQ5Rxlw4eudw8aUzWYiCUqbsLd3GmwIjvQ==
X-Received: by 2002:a05:6a00:17a7:b0:82c:dd31:b84a with SMTP id d2e1a72fcca58-82f0c2b03a3mr25624166b3a.43.1776344861608;
        Thu, 16 Apr 2026 06:07:41 -0700 (PDT)
X-Received: by 2002:a05:6a00:17a7:b0:82c:dd31:b84a with SMTP id d2e1a72fcca58-82f0c2b03a3mr25624130b3a.43.1776344861095;
        Thu, 16 Apr 2026 06:07:41 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f67449c3asm5383605b3a.53.2026.04.16.06.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 06:07:40 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Thu, 16 Apr 2026 18:37:21 +0530
Subject: [PATCH 2/2] arm64: dts: qcom: glymur: Add crypto engine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260416-glymur_crypto_enablement-v1-2-75e768c1417c@oss.qualcomm.com>
References: <20260416-glymur_crypto_enablement-v1-0-75e768c1417c@oss.qualcomm.com>
In-Reply-To: <20260416-glymur_crypto_enablement-v1-0-75e768c1417c@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776344844; l=1588;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=mShqz2LMKwbtHeVqOaBAu5htLUyQtdiwxxmQtKd8+i8=;
 b=r0wbMGJ8eYygyPdwRWkPSMTKA9Z7ogUpwaNN6yK9Hxu8LMMe9GHsmpscWwmg2DdaTRv5e3BtP
 F8h/YebFK+VALaT8aZJXo+wKQytjRu2MAZe/AvTgS6TlPsOrCnds/Wj
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDEyNSBTYWx0ZWRfX4jmCtoQIspjQ
 3u0NfEVuZiF3pFkLwxPmdmyiLJ72kOzhcAM8aH9WGM/fasQBsvWY2a89MGugpc1zmVpubHNJdUY
 ME9NavZeuyE6EX0jyO9lbvW8gQb72+Xho+FmJikbMgUClsZdA8/8baNjSSxCBTbW8d5Np8tEZ5s
 SiMclBS2M7UyMqGzY05HZwM24yso1IQ9Jo5V/hma9wzh8pT41GO202uePWzZZRwDxB4Hrzgr3wt
 hC/Eh4y1PPGx3wg6H9LDorp76vnzb2O3X0bmbSVghpznhwrd110UcKOBABdCao2h2V/gnXbeNhr
 N1oq2P3GyAtklks6d5l27oNO3KTOzHMGPVgJOdH64fRkuc/KLxyW77J3knuXgsCsUvy1B5PVQ43
 +IB7icM0e9hHzy83eRgvIbbINDEOBAUikk7YG5AjCIx2R7VhiNZMZraS1TYbMuX1TW7hfv6NGFQ
 LPtElKL340FZKVqSYvg==
X-Proofpoint-ORIG-GUID: OpBa1Mumr6H2PGjayUFcC1BZ9W5nvxWO
X-Authority-Analysis: v=2.4 cv=Ipgutr/g c=1 sm=1 tr=0 ts=69e0df1e cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=lRx-OlksSAv_QJqe_iwA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: OpBa1Mumr6H2PGjayUFcC1BZ9W5nvxWO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604160125

On Glymur, there is a crypto engine IP block similar to the ones found on
SM8x50 platforms.

Describe the crypto engine and its BAM.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index f23cf81ddb77..e8c796f2c572 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -3675,6 +3675,32 @@ pcie3b_phy: phy@f10000 {
 			status = "disabled";
 		};
 
+		cryptobam: dma-controller@1dc4000 {
+			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
+			reg = <0x0 0x01dc4000 0x0 0x28000>;
+			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
+			#dma-cells = <1>;
+			iommus = <&apps_smmu 0x480 0x0>,
+				 <&apps_smmu 0x481 0x0>;
+			qcom,ee = <0>;
+			qcom,controlled-remotely;
+			num-channels = <20>;
+			qcom,num-ees = <4>;
+		};
+
+		crypto: crypto@1dfa000 {
+			compatible = "qcom,glymur-qce", "qcom,sm8150-qce", "qcom,qce";
+			reg = <0x0 0x01dfa000 0x0 0x6000>;
+			dmas = <&cryptobam 4>, <&cryptobam 5>;
+			dma-names = "rx",
+				    "tx";
+			iommus = <&apps_smmu 0x480 0x0>,
+				 <&apps_smmu 0x481 0x0>;
+			interconnects = <&aggre1_noc MASTER_CRYPTO QCOM_ICC_TAG_ALWAYS
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>;
+			interconnect-names = "memory";
+		};
+
 		tcsr_mutex: hwlock@1f40000 {
 			compatible = "qcom,tcsr-mutex";
 			reg = <0x0 0x01f40000 0x0 0x20000>;

-- 
2.34.1

