Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794487912;
	b=iRCkqW5sQOwSr90OBjO2xy3dqp8lj+nxvCk924SlT7AN8evL7j4lkiOMgMOJIIB3xsia
	 GlM6EfqiZFcJoRPYZTC2ul3GeMYzNvcAyo2QjyTpUIMIB/KuzxDQ8HsKfjTLMEskd7QZj
	 g9g4MftnW9jmjspdJdDnbS828tlmJqHW91+XZA08bV4OccXMbYffYm8mhhkT6mNyBdBNN
	 OOfbK2BVkfWwHN09KWPOt2odIqRaRF5JU4UbDv70kaymlIhfTJe9W4wTzAd2Cj4DwB7oh
	 5iRoxGljQjkkJJLuFO7qpUS4Z774duJOQwaMQ5JFeYlGAWmH/3vNzbftQdtttvTShuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794487912;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=Xon4MxyvfV7RksGi/nZjGymYtYhAhYgMqriG4HzeboY=;
	b=pEi35lNytg3HVkXC43PBVbIGgcRqpA/AB6/+irDzNG6kPSEKdrfzOh1nExRhIY/HMK6K
	 thggDvpYcF9Vc/YvWOcI0snSrBDVF6s14LQ8xAlJmEzt+O6OPrfJIGWqHS3y3XhZWyPit
	 Ei0NhUrU2AY1G+gWcaKllhUUpR5Ph+/AtnvfzjnIIk7mlDUyxvA1nsiEW+XfOSaPsdTYr
	 T4twxuJl+iNowYdkfQCCfBluoebTRcSB5otLgdTgjxTviDEmTEnPImJeimYh+71eOhPjm
	 wiRIHCzniBdtSLuzgdJiLJ02/H/6icFWsUJSqinJvuYuwttfE2nIrcyp4MpQqLcG7xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=VbRs5i+1;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KmFryWxt;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ADC606A336
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 12:51:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55ADC606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=VbRs5i+1;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KmFryWxt
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC8qlji4149469
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 12:51:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Xon4MxyvfV7RksGi/nZjGymYtYhAhYgMqriG4HzeboY=; b=VbRs5i+1+/PtZ9UA
	E4uuAhmEG7XRPSBXVxphmO9LZEF86BXyAACeumnvnU+2S47/gjdwPTaTI7ohSV+A
	5OAXUJmog0c+ULJBs4SKDeyMuZFkZd+bwxtrgRFqIkXp7oZD7wPCUrOw3136k2gS
	mdN4Qa5xvJZZgl/zFOZ+X1FdK37wh812F2JK8JIgUSLPsimpcOHzUBZgJPLou0lg
	Bf65oSOEkEp9QgH9SEN6mm8qutVbW3yU28b8jimwtVErGmJdugurqcHAAOfdezxj
	JOH4bhADL9e2gDRLh5cqXMPF4nqsgCTSIjWnku9OExQvCK0I8Z8T9jBav6TIXJYG
	HbU28A==
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hvxc63f3f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 12:51:51 +0000 (GMT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-860e65f42a5so3256815a34.3
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 04:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794487911; x=1795092711; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xon4MxyvfV7RksGi/nZjGymYtYhAhYgMqriG4HzeboY=;
        b=KmFryWxt0ppgR9ha5R9psCo19GZT94mu1GCpaRj+YrbWVazIvU+M+KSyXeUKiNko1W
         wejQtE4bC4Rlpr5zhG1UI2heEP7Hgh8HFFFdEu4qsM51soaDGwUgPjsXfvJQ0zDyRLCl
         ZwkNEuOT25HuPAQAYsFiRf2R4knq5ceSF8QyRvLvp715jjABjBWd6BbFzzoUCAALHYB3
         F/StiNWj7vlh03WlPRu3cAjA1LuK1aMGenAaM3vzZxsen0HOOQyNtS8OfJ/bbs3LJEuE
         /ENcsmF5qDKzUKCEKIesrZBEtLJo3SbpqVp/oz8S3GxrKqIreYeVZoI6CbMUCCt9abye
         Romw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794487911; x=1795092711;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xon4MxyvfV7RksGi/nZjGymYtYhAhYgMqriG4HzeboY=;
        b=ClMh3Jw/j2nWWs77yso91E5MDaaqWf2CHVhKD6zMFVdaHyu1FInSvzh/oc/+J77I3U
         INIrzGXmRAkMW6V6xPEllJFElvhRo/UFGBa3u/SYxsNKkuKfX0G0EwZtWbIPfJDdINB7
         vNA4A1oMO0wZYchE6x2z1RM0t5ImEatSl/5t8LdwtBHM7wz7jmA/CCKAKVJVcPdVXIDH
         yHui32D6DaHLDw5kr/Zh3OxbLShx5fMSCmZU7+5+P6ctz/PhDazDxNclnLeStftsgeVJ
         P5Nur3FSrEJvW2eQkXUSYAvmN4RRXOUWzd1zKDVrqAekuS6kXpylmqvpFMShnnlh4E/U
         5udg==
X-Forwarded-Encrypted: i=1; AL+hErFEHGXQfSv00ilfABTqWoLzn6r8Mb+UasvlRaVds8sYzEgELZaM/LOVqqN3mo50ZordGuLVFlExeFA1ndo=@vger.kernel.org
X-Gm-Message-State: APuU4Z8l8ay2m4d3B90vHqyNWWRdr8/Em4kTjhI11UbG16oCXo1Mh917
	o/B+Oy/8fZnoP9BJdd+t1A8ienzBToVvOWLg+4/VM9OCfiFeyxoeSDGL7knxUEKKvtQPfVCY593
	ZRTUZeiQ9gUpJ8LhXGbBXWsds8/I7MS0/6J3pOlFDlgCSW04KUVJ6xXY7I0FDtgq2MYQ=
X-Gm-Gg: AYBFou3ZH1z79LDwyQhtchpvSbvLpP8LEz/uvC6DR1osjJw+IsFttC0zPmJx+OGG7cO
	O/mSpYTh4FK8YnsC8wIRKE9gwkD9CGaHznyggIO1/d3uzcYsjQUJtuvmPMw3wBD/9fYz52QLupj
	ybj2sdIV5OW0ojuAoBUuXUUHV9XpXqgpnUH71JPAXo91fjAEC+lHgp3N60YPuiLqb6CaqzuS6cg
	WlcIF4yilrw9UZTgiKV8PZ+6LGY9yq8F68tqWJRqZLDej0GxUzNH6BGJmzzEhXCxlfk+acrC846
	qykQ8JEqxCSJNwaJ9EOGEnwM0UQl5R+YEKP44SA94Hjg0r+ylNeZtbhZ65zLlaMD3ni4KbGoBg9
	8xl6XeHXQPVYHqY51//62xsJsX9acDCcgyGOa9WhIZa7fXxF784+URmwvaX+YbrsJIXUglc+tMb
	tX/pUFhQ==
X-Received: by 2002:a05:6830:906:b0:80c:d34f:5f5e with SMTP id 46e09a7af769-860f292723cmr7032488a34.23.1794487910659;
        Thu, 12 Nov 2026 04:51:50 -0800 (PST)
X-Received: by 2002:a05:6830:906:b0:80c:d34f:5f5e with SMTP id 46e09a7af769-860f292723cmr7032459a34.23.1794487910241;
        Thu, 12 Nov 2026 04:51:50 -0800 (PST)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-860dcbc7eecsm7608191a34.15.2026.11.12.04.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:51:49 -0800 (PST)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Thu, 12 Nov 2026 18:21:08 +0530
Subject: [PATCH v2 2/2] arm64: dts: qcom: shikra: Correct QCE node
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
Message-Id: <20261112-shikra_qce_fix-v2-2-2ce112cc2ccf@oss.qualcomm.com>
References: <20261112-shikra_qce_fix-v2-0-2ce112cc2ccf@oss.qualcomm.com>
In-Reply-To: <20261112-shikra_qce_fix-v2-0-2ce112cc2ccf@oss.qualcomm.com>
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
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-ORIG-GUID: iGSW5RNOZqCMoo3OM8-Yd8_EZZO4jRni
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA1MSBTYWx0ZWRfX5wkSxxWwWTEP
 PScAq3to/xlUlZB34wzI0LV8xdaIB1wJr3QpcQxSGxTL+xOy8u/abr7mfrUr9n1Jz/tT8t/WACb
 G2DMju/hakG/LU4ACZZ4NFrLODG4+iIPzeduS4ZvkEwTMoNrfe5Kmc/nv1vrmctBV9dcRp+SPOD
 /Z93Gl5nEVgXfy2yO3lcbQqCoeOr3fAkrlvaFjvREk10R699DjHLdb5PKRfnQBySqvpbFj0R4vZ
 73CpJGr6YQ5TYDPvIAbl+2hR6BVbfjkjuzDz3XlFBXNJcbDtIgxst1btbROXt4agTIk6/fkB3NK
 KxA96zr6tMfQDuX+t4h3+sK2JFQLFC0vMcZqJDynizoNi18ZZYhHf0d/TvyOL/ES9fb9Q9xqa6+
 60TntG7G+p09eu7fs6O57uVuPg+33M1zv8t8CK2xNGw56PU5Tix+sooTfKB6z2KAjRS6sXRMlUB
 Bu8hIghriHU6dF2zl6g==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA1MSBTYWx0ZWRfX1WCAVcp3JaCf
 0NC0C4pj4gfbdgsI5NUXrD2oh3Dr3/1cJTRNYvtlDlXMc80wJEXAuT+VfwEAY5n8521MHsv0h2P
 g5mtrrMQlwsVu8ORa3jxc7NlIa0gNqU=
X-Proofpoint-GUID: iGSW5RNOZqCMoo3OM8-Yd8_EZZO4jRni
X-Authority-Analysis: v=2.4 cv=O/ysLx9W c=1 sm=1 tr=0 ts=6af5b667 cx=c_pps
 a=+3WqYijBVYhDct2f5Fivkw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=nsAWE0-7qdAvx2JcIW4A:9 a=QEXdDO2ut3YA:10
 a=eYe2g0i6gJ5uXG_o6N4q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 malwarescore=0 impostorscore=0 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611120051

Shikra QCE requires an explicit core clock, which is missing from the
current configuration. Add core clock and adjust fallback compatible to
match updated binding description.

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

