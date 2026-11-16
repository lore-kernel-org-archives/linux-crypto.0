Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794819644;
	b=Y/uimAdHwooDkO15h2QBF8VDnjPs/ew+TjcmgKun5JSlb5lFQESR1BcfNeDLUuRIrEvl
	 TIZyEKwNR5ROCpMnnpUvRJLSAGcVE7cSAhakrYUDG4WG73wsHxjuyJjiWwdhkJ7ysPL0c
	 8Kkx0x4rkty8P6lh8GC+FPfLOGk9JEYm9QBpC6x+AxAYOxAtI79VESWRokEGgPHDd2p/J
	 QWhN87YOkurJ7h9ZRI4mC4TT5AMyTtDxXkn8auXYCNxKmcaJH8dJ8zMGi0CasvJ6iYKON
	 oqm/TQORv6hNQSg88ZoX68hPynY8fiOa2LpetL+u5+dLXDQyI7Ff+jjsmtgJ27rOHBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794819644;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=OULLp22aGXDMcQrmAmyZ12HUIraEW6K0uNHbN8KXWEw=;
	b=0tt3KnMo1vlQh3gmIXsPjO0Eu1+FT428smytJfn9YN9s9hm0BbM/H+1KdJXLvSxkgfxz
	 etSVa8Qr91Dcq1rslQwHIgcKlIsldqNLimZtm9FdOWE/HvhUKn85fJhGtAEjJUqibiKRv
	 eqCK65Qn5KNRZI7KxT7N6wq0yJvESq99BqTfaNgvaYCwYKx70mOkYrKbI4DdwdiVhxTxv
	 DMlQNGxZMk9dQ5SS8qsJCnyNl8wLgTndYT6O/azUbTQcCEI6KEIy1sgB/xY0HjWKLxtXn
	 Hw1JmyXCQmVs2TKRL90GsE8856JqBv0L/ufNx86i0PUICfqYBzvRXjWgiY8rNedrZRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=iS+2W1yH;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Syy5B9tl;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC15606A32A
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 09:00:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DC15606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=iS+2W1yH;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Syy5B9tl
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AG7exqk1633035
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 09:00:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OULLp22aGXDMcQrmAmyZ12HUIraEW6K0uNHbN8KXWEw=; b=iS+2W1yHU1a3LWo8
	j1Pzbonj3Gfof/aae8Ul9LPmYnCD4xJEJjKCwdfUNa4sMkQGKVqrmiHaN8kO81Sc
	7Xk4BIl+1B2zXj2nwaCngF1fzmiX3y32HhVH1mt1t8rxqPiGYZvl5EVBHTCHOdyW
	YfCtty0PhYPgkoTyQXpmOayOhyX7TXi9ifw9yqtkPTqOnX1D9A+zkXXHFGUqyYE2
	FcoGWwTBuiGDbAX0AWTxe0RUlh4Bd6qlBOGcPEN7BunJuz1aLRx4S4jtvl3EutrG
	Ymu59zxfyRpjhb6er82c/OshxYNRtolocF+8mdSs6k1neZYONmEq0qhmlSoc/1zO
	FoN5wg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hxhmanm28-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 09:00:42 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b10afdf947so4095525a91.0
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 01:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794819641; x=1795424441; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OULLp22aGXDMcQrmAmyZ12HUIraEW6K0uNHbN8KXWEw=;
        b=Syy5B9tllTn/0o1LAH09AYvSk2lXAu/DRCBfdZYDegWSI1V1UemfhIXxl+nIJ4sGgX
         encTz0JiHHX/q58ryBrLdG+S/boxYlXUBGmFfAzb5HJL7WoRx7bTs2zYMrjD+Oh5vEKs
         dKuQlwXMQOiC382f7DsfsJchRgJ54NORvJ4W8GcswEEK4X6Ny7OLbJr1RJdvgM+9FatP
         hg4RPmwOy3iEB3Cx8G8af6LlDBD5g9L0crRLuusIkOrDia8EBYTdRt7OvzZWXyX2oCH/
         E7u1tCDB3qYgFQ6XZyZeh632l/BgPqYUfXxA4+A3TRgpVzFd3CaClHAHcRf8fPP8kRXF
         NtKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794819641; x=1795424441;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OULLp22aGXDMcQrmAmyZ12HUIraEW6K0uNHbN8KXWEw=;
        b=aCYth8kLY+gDSRAauy9JEbtJKleNZq30HtmK72UXmzK0HWTYWzFnnIA4uTCAnVLJh8
         QUkmbNgItkzp4ovlPQzYhVHUmlwtIuSgCqTNWgGG7P8VFyevcgqDqnZjZxLDsAI52JZn
         4AhE9U4kooucUkJJT+1sekpCcorw+v/euJP3NVUjabSViBBDkF83XZGVUORy4ASoHX1W
         EjXjBo5rg15Ord/DyN/7ilMqQLYvfCTSkNVzG9Rl2xlUfe6n/OjYVRtZGPQRURFw3TWX
         qd9TCPxrDf8sjfldCXLO2rqEARti6AbjtQaEVNL4LrB5NZwR3lkBbuTGDNWgksjQHA21
         6d6A==
X-Forwarded-Encrypted: i=1; AL+hErFobIvlYcX1+fBqQiuTP8/Ze6yG01qFfjtcTcDhfuEGdvvAw5nIB443APBPWwGyPHm2sbr7BnXDvqmUXCA=@vger.kernel.org
X-Gm-Message-State: APuU4Z/QYtBbdtO3uuI4No2Q1njkFYiMsEZlhbYmJ5X0pxADTVgAdXbf
	z6uTFf2Blyg7xQBEd3Zbmmqgqc9ABian/qxfL04bRa1ypDLItdczd2EY+L93+Y9Rfqq35fFXjDH
	4E8VyGHDOxUHFi89AsraCS6/soZitDNzY1CapzdPz2LVxFQvuQyFZPOMQzCteZYGBSXY=
X-Gm-Gg: AZFdTZcytd5pu+5cUmHTHPQcBS8Vry3fEY+K/5uX6lmcU9taJ1tlESyLKBriOaIfohn
	qAfax7Nck3uqZvC61C7/GIfI/ZSysk8uXseCLPdCdE1JjanSHF7yTxbSrZY6MCnSHpPrV5hS7BU
	drfamFTHYckl2+WTk5k1lx9GuEo9ttjY5E6fo7NGml1nxRQF2OvgZvpmIvMvIoAKp+ayXi8AiOw
	zlFzr12V3MigyjSAt9fnTtsIE/EZfUdJh+ueKAjAJGBPYJ+R71tWo6XcqnFXh1XuxcIicz+KbUO
	5jtoPTcACPcF38mr2fKDpmFB4rKN5c+OdB5pqmf4LgdYu56JMLf5n8pc+83xWdFIUMWOtBzF1VN
	Rfmbp8M1W279Y3klA1hAjZVrFIZD/2+mRe/xpgsnao4eV6AYSY79yqjvqdkEOhIFnfS/RjjWue5
	1YyoKfuQM=
X-Received: by 2002:a17:90b:4c02:b0:3b0:a413:dd8e with SMTP id 98e67ed59e1d1-3b1b0da3e56mr6453707a91.43.1794819640722;
        Mon, 16 Nov 2026 01:00:40 -0800 (PST)
X-Received: by 2002:a17:90b:4c02:b0:3b0:a413:dd8e with SMTP id 98e67ed59e1d1-3b1b0da3e56mr6453665a91.43.1794819640060;
        Mon, 16 Nov 2026 01:00:40 -0800 (PST)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1aeb3d2d4sm15916632a91.7.2026.11.16.01.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 01:00:39 -0800 (PST)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Mon, 16 Nov 2026 14:29:45 +0530
Subject: [PATCH v3 1/2] dt-bindings: crypto: Correct Shikra QCE compatible
 hierarchy
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
Message-Id: <20261116-shikra_qce_fix-v3-1-9ae31470ef48@oss.qualcomm.com>
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
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-ORIG-GUID: nmsT_W6kByLvxKw_b6e1wGXIxg671lAv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDAzNSBTYWx0ZWRfXwoOeFUNcpXPx
 OU2c3N0lal1O/8shw+D+MEMLx1ST1qFJNQXf9Dq6FjBe/55r7oYH1V/GkzcLlZjQ33u653tKaf+
 qVSi7FDMtqo2vjVuiInP6ugn3eZLzh/SJSmIEDQKrb9m6Szr+dIwDrIZNXW+OJCXIy6uVMG6IKa
 oIlsVmzqSMrd5xHL1LcBC5xWgZlZy8c5ZZ4yXbyHI+zqwjdTUdjMzRY+Q6CMIbw1SQ2WU/9JVxB
 zxM7eDl0OXc87pUfkwXXSswHU36smqxr3QYR3jPFfCUmfCYKGcZJciE3yGv/PhymOg/xFgWhwjE
 KFRISU+2xnVjNAeOX4YVGfBMfiEudVGMeUYs8UYVHDEOIrSme4QSmKEUuv/lFR5cQdz3Mgt/ErM
 949qLrjG2gm5JSM6IKFtLZqbpkXnrig66EQfUN7zmoKDq3cV6GbVRo0P37ttS1Zp7wak+2WNMmr
 rGF38bjIPq32imYApRA==
X-Authority-Analysis: v=2.4 cv=NdhzRGD4 c=1 sm=1 tr=0 ts=6afac63a cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=BEl7XTdPtaVR2fHMDO0A:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: nmsT_W6kByLvxKw_b6e1wGXIxg671lAv
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDAzNSBTYWx0ZWRfX8TVq1p0Brxfe
 ALWeOdcpj91zN/rDjAMBqkjEg+Dvz8FhiPedwwNKIodl9lXxsTB9M3VzwAwhioFYWdeiVq8DFqy
 yqFL6U1QEiEg02VvTX4kvsi5g0obI3M=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_03,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160035

Shikra QCE requires an explicit core clock, while the existing
"qcom,sm8150-qce" fallback allows the clock property to be omitted.

Shikra follows the same QCE clock requirements as QRB2210(agatti).
Update the Shikra fallback to "qcom,ipq4019-qce", which requires the
core clock to be specified.

Fixes: 45834ff95a6f ("dt-bindings: crypto: qcom-qce: Document the Shikra crypto engine")
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 5a653757ee75..fcf725bfa36b 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -39,6 +39,7 @@ properties:
               - qcom,msm8996-qce
               - qcom,qcm2290-qce
               - qcom,sdm845-qce
+              - qcom,shikra-qce
               - qcom,sm6115-qce
           - const: qcom,ipq4019-qce
           - const: qcom,qce
@@ -54,7 +55,6 @@ properties:
               - qcom,qcs8300-qce
               - qcom,sa8775p-qce
               - qcom,sc7280-qce
-              - qcom,shikra-qce
               - qcom,sm6350-qce
               - qcom,sm8250-qce
               - qcom,sm8350-qce
@@ -133,6 +133,7 @@ allOf:
           contains:
             enum:
               - qcom,qcm2290-qce
+              - qcom,shikra-qce
               - qcom,sm6115-qce
     then:
       properties:

-- 
2.34.1

