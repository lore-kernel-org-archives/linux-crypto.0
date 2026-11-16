Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794819649;
	b=SQr32UMTkkdqSYEEtrfW0jJDlh2ASmnJLw4yZU90YB1HUWM5/uLnO056OWBinjvKKoJF
	 TyhwfEL1V2uFiFZEqt+N59uNbGE30N2CEFCZ+gtldBogjtw4LzYB+Wsn2xbrGkXW3aRre
	 bcGHXyPyogvmVg7ofjDWUjeiKKt5ubgGHI9bdG/x21DSJPBMWkiaeVJycDfEae/RKyBcW
	 yNsgkLRiBxhiPXAmgeMgfX1eYfyJet8YXWjrxXCbr7sBNFUWS9ldxfH4ugEbAFpY2PNB0
	 epOu93qodNZbfuFazNQOO2OXwZUyDhtZ+ytUZ77cMlWo9Sg9hwjWRnvaL4gyhE5AXCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794819649;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=27K4feh3qym7raUaYT3JRfhq3pYm6YbJC7Kd12Fe6RM=;
	b=y6sIR47Vw094Bot/3kBHNotsNVWGwOj4VZJQJJmXkC4gL6pe8dQMnIyl8ACJdXnTc+kZ
	 X3RW3+MYunT1tn5eMu4d+YuIoVHt7iS6nrZzTosItNfuk13dL4dKrHag8Z8udGl/R/081
	 C6AuYTIgJk+HjwaN0CTCMtQaLQqmKkJTVvKYRMrCU+9c700VCOYjCBGEParxMBeZqUt1a
	 00YeNp7hh2Q3qdzFKJeG3CGYKvqBYhHKZbZifQoiD+yreuHFWoiqxNj2iQwjQKNYUhpJJ
	 RAKAGB6TElzMKxE9pPCz9Fce3N2MELk+YmeZwA10SLFUROdbvBSzRq6ZX5qhKqmAGgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=cuBHWLza;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dMfyRuuf;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13F4606A333
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 09:00:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F13F4606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=cuBHWLza;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=dMfyRuuf
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AG7etiF524919
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 09:00:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	27K4feh3qym7raUaYT3JRfhq3pYm6YbJC7Kd12Fe6RM=; b=cuBHWLzab3S9cxil
	GCu+NrSE5S3uRepdZc7HL4WnbmISgetSMWzwctddIkA5FAcrvkOI3iX1eoKoXSd2
	g7uzdgCDkWaTG0YTXkfRpXF0UBUdx0bDhsqraqY6gjMpzPy3giTeA7y/OEhgswcL
	nwsM31/sMC1vgmjY4PcDa5s9zcSDkd9zJa0IdcoSzOjyFOi3ggnMd2rEBteBacm5
	iFuY7YRF2nNR66aJosdJQx5zm3y7qGEWtBauiyXvJ8I4WbUMbYS0CrriWfUaIjCt
	BtSGNICVZeL5FsqvRPo6j9fVLjsnEnDCXLcbT2E+IWI1OzauOVyvVodQi1btnuUA
	BPbejw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hxhjqns34-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 09:00:47 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3b17b31c3beso3025090a91.2
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 01:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794819647; x=1795424447; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=27K4feh3qym7raUaYT3JRfhq3pYm6YbJC7Kd12Fe6RM=;
        b=dMfyRuufJHLH5ntW7Dhy/WqrbG/w6yhOEwxWuoBirjBIHWUwDbsiF1THECRG7+jx0V
         8mjKmFgRguCoe5ILsZufW+D/r8C8ts5u0lztgTsx02ruTbReha0zRV7BEI9j8fWlOclP
         pb9CgbLp6jugPcWZtZjf7agQg+LGtR7Z80K+6Ff9QgX0riW0d1etkLu9X4fcTUnTv/Do
         ak5loPX3+uBEv2NP0IVYVxCAfT8meTRKmL3LfPU5BkLRBjMO4OiUsmQibbyVGnPgSwGN
         eCZBXE70Wv9lQoG5zX0WbOOBzsRbhzcYNZTbI0yZQdcCzMgnHG8+5ZaQAYmK1s5X3sah
         vl3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794819647; x=1795424447;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=27K4feh3qym7raUaYT3JRfhq3pYm6YbJC7Kd12Fe6RM=;
        b=dZGyqauUMpI+bgTffSrdQXkPvLAH01QcrzW/24ApX+xIJDRH3S9SzSmzn+i8pf2erC
         7E1vAxirRGfIPwr14FpS/4ogjLtLMdaCMdphFsykNLsvA8nYbKWXBA487iGcmk2mJbyH
         2MIteFRJB6AaTDGVzjkE237Zynine8oBMO0SPtCgWRDaqtd0uv/VploZJReR5QkbIx9N
         F2I6eO2gfwjzf5VwHq7J/sPrYnuqhg4EMc6iADr1HEi+zf4R9TF1DBJoAhYxy8ZWolsm
         SZtLUCzv7w0EryxLvQlx4veNKoRjhWug73LQLt8yK5bCzV4Z4jf5us325IAuNzqUMebd
         r+sQ==
X-Forwarded-Encrypted: i=1; AL+hErFa5QpkVGZ9EGxux9m4mQap0soAHvYJ1A4HDNUpImcpXvEFIm5CHTl3tpit+KSH75RLadZtG0yHZS80Tk8=@vger.kernel.org
X-Gm-Message-State: APuU4Z86ufumn/UlVp4jo9L095Oby9M/J6497T49WvQuVxwZ3R6ixcDx
	s1ohz6WDOm8Uo5LYPTVLqIx8PVl37ppzrF/1h+Za6ThRynJ16QG6el3sAFHS0YbGkd+Cx3QZndK
	0EIW15kZxlOvCoHnEY/nvMoKoFWAGAtZZV0bQUJyDQy3qe+G+t/e8ZWmwD0y4l3QlDfE=
X-Gm-Gg: AZFdTZf872arjpQK+V8Ty/fRhGSa7nfZV41NQ3C/N9U3QnQ7ldxLDjVtl768XLY6v0j
	qXuoYkEsQxGgbnG5V9r78gcFwNsorwxuemKDhbyvVlui1PjU+Svae46i02ym10C/z0NI7xhPXVO
	8A4R0WB89enPz2psPvI+hNBenUn/WzxqM6O2homQj94RHQAPCU2W5JYQVFjrciNRZQ4/fS2gnrr
	HnlCBjLqvZl9+5O017htnSA+e0hyJKnDrDosl2P66bqAhBNPsgcJnxBR1/EN5dITvaEvmLGRuDS
	harqsNwLtubG3CrmGcRfw07rT5QFM3XK+sUE1GNZyOpXmiq50bjSrjpX/jQfqM80t4EHX/1DEam
	u0fU0ke3ruzt2e1Yq6XKTVbyHuPAm/vcx9xOBcAUNYFp+Xe8wr1548Ii3/DaM8Fa42ZTgHYldhv
	DmpEZgLzo=
X-Received: by 2002:a17:90a:d883:b0:3a4:b74a:795c with SMTP id 98e67ed59e1d1-3b1b09f3b50mr9345821a91.16.1794819646674;
        Mon, 16 Nov 2026 01:00:46 -0800 (PST)
X-Received: by 2002:a17:90a:d883:b0:3a4:b74a:795c with SMTP id 98e67ed59e1d1-3b1b09f3b50mr9345778a91.16.1794819646038;
        Mon, 16 Nov 2026 01:00:46 -0800 (PST)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1aeb3d2d4sm15916632a91.7.2026.11.16.01.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 01:00:45 -0800 (PST)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Mon, 16 Nov 2026 14:29:46 +0530
Subject: [PATCH v3 2/2] arm64: dts: qcom: shikra: Correct QCE node
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
Message-Id: <20261116-shikra_qce_fix-v3-2-9ae31470ef48@oss.qualcomm.com>
References: <20261116-shikra_qce_fix-v3-0-9ae31470ef48@oss.qualcomm.com>
In-Reply-To: <20261116-shikra_qce_fix-v3-0-9ae31470ef48@oss.qualcomm.com>
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
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Authority-Analysis: v=2.4 cv=KelHIgYD c=1 sm=1 tr=0 ts=6afac63f cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=edzx39f0doCTOIfZxx8A:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDAzNSBTYWx0ZWRfXzNtfQhsq2eXj
 /4LGt880aDnQ3/hvTEj4Zr+pc8qVBS1BOzLNnSzrjootatF/NjWjnFOYuuyLlsc5tSowUxJgOv7
 tW6OrOPF2M8tmmt3A0bQ05atgsMVPKE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDAzNSBTYWx0ZWRfX4xkODnDF7Fqw
 GoCqszUW4UJdySnPEgjyxth46O465J82E/Nja0avJD0pNLhvFUowk77JfeUEFGyj3oSnQAJBDua
 vpDmMnU0wGJFYUYGPF0pTj18dqhK4vfspQJLOVmco0PxJ7BbA37coSMsdq3c06g9gxy1xxjLCtn
 cWDP2B2kRcwZ6TlC2Irev8IddzMhU9C0rziTVh9liHbn7bHorKbu6YMN7tvBjQrcbfyfxa7Ruol
 wbHD6NbZhHxwiq+2VJGiYusnuGvs5NbkP4b0nvBovO+vkaDIAG0Hdi2JshWstU2KqyLs2pUGdnU
 YWM0r8a7h1eds7WCgMHHPgVmZeKqor5iO3nYRJlOr/N0fvVXlDDPRMpwhYeXKM27cMVyUc3tMye
 pF4IV2b+lxy7goCgrZjeetkOssge6RFK3/R6Zw6dH6EKMGmEd984pVaBdIeMPCUddO/k9t+0kUh
 AE69rHsa6GFYTmgrwdg==
X-Proofpoint-GUID: V-CBuR2izGiNVZIrTtHYlzMldy1kiq8j
X-Proofpoint-ORIG-GUID: V-CBuR2izGiNVZIrTtHYlzMldy1kiq8j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_03,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 spamscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160035

Shikra QCE requires an explicit core clock, which is missing from the
current configuration. Adjust fallback compatible to "qcom,ipq4019-qce"
and specify core clock to match updated binding description.
The crypto interconnect path is already described by SCM node, which
votes for MASTER_CRYPTO_CORE0. Drop the duplicate interconnect vote from
the QCE node.

Cryptobam is controlled remotely and its clocks are therefore managed by
remote crypto subsystem.

Fixes: 099cd05d200b ("arm64: dts: qcom: shikra: Add ICE, TRNG and QCE nodes")
Tested-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com> #on shikra device
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/shikra.dtsi | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/shikra.dtsi b/arch/arm64/boot/dts/qcom/shikra.dtsi
index 0a95ad5a5582..d5f0ef863173 100644
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
@@ -1219,9 +1219,8 @@ crypto: crypto@1b3a000 {
 				 <&apps_smmu 0x96 0x0011>,
 				 <&apps_smmu 0x98 0x0001>,
 				 <&apps_smmu 0x9f 0x0>;
-			interconnects = <&system_noc MASTER_CRYPTO_CORE0 0
-					 &mc_virt SLAVE_EBI_CH0 0>;
-			interconnect-names = "memory";
+			clocks = <&rpmcc RPM_SMD_CE1_CLK>;
+			clock-names = "core";
 		};
 
 		qfprom: efuse@1b44000 {

-- 
2.34.1

