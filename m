Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6978B3BAD81
	for <linux-crypto@vger.kernel.org>; Tue,  6 Oct 2026 11:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791285264; cv=none; b=O+wOaJmrJMHuN4owEftTMiSNGA6ARiCXkzCBfPHcaKPtGLE6dPVm3ooVE3gwK8bd43TOsrRwCd3+AZVSj0A1dAfz/qwG0Ae+P/aleqkaRViJmzZdWNMwqCBpU8bs5Sl7ONAopa6q+wMgJuCKN+P4IS/80N/eibqtF4dIDvlUrbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791285264; c=relaxed/simple;
	bh=y2FohgVugKHcRrwqSAgDn+CMIOQiCYuOFRGzU94UhdQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=HSijWJ3OeUiHpYBqkCu0oJssCeA4ixzuzXt1YXA2a5/4zho/iX1BiEYoKzUz7o6z6mOw2VrmZ3IGrNYof8HtXjeE14fO2Yl3pTXj0kaBzGH4UeFLDC4FFXE72fEVv1kLg2zyPIRSnAJ/SxPIg9aaIFCpfxiXAPyfbKrDBWbWYfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=O+Rq8N6V; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jtOh4Jyl; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="O+Rq8N6V";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jtOh4Jyl"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 696AReoD1581156
	for <linux-crypto@vger.kernel.org>; Tue, 6 Oct 2026 11:14:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=/Pfmq9lmoce9UQap1hkT3q
	E7NyxlVsRLj1bFCy4E4gQ=; b=O+Rq8N6VhXndwfhf7k++0wdmAUqZ7x7cbxhvmd
	bB3irwOLtBxugrhNhiKFAq9HhLMNWrfiJgjQCgtqAVN9kGWiAmk1v6WheewnmWOE
	xo9rsqKWwieve3uYM9UGrcNQHgl1ZKQpm7X75XZPdfbRHcLtv+rst3I/ZcmCCxjx
	ZR4NiLZBXU8a0KTcsUF4kPMRfPcGxQxtWLywpW9moV/nCI9/kFxIY8ng4utPtY2t
	ielrtBrI6S4tKE5ppmtTtKkEjU3oEPkNoJT6qdYrJ3bOBJQqUyfzqtjDGndn4Jsz
	jxE9v7Q8OuD7bbVsK5Xg7dJWcl1f4dJ/iL4UCEcERzV0dIoQ==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h4xc50bh2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 06 Oct 2026 11:14:21 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3a4aa263a4aso2827481a91.1
        for <linux-crypto@vger.kernel.org>; Tue, 06 Oct 2026 04:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791285261; x=1791890061; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/Pfmq9lmoce9UQap1hkT3qE7NyxlVsRLj1bFCy4E4gQ=;
        b=jtOh4Jyl2J9S1w5Zpb543L3X/GyrmBv885RRFWPY7AfQ5l5J6xwa9ivr8g4qF2gGei
         oGWo9aiF3UrYe8TIleJzvJt3bYEjkjTwFxnJErM6rUOXppDSEiuXUQ9PvEtRt0kFhWCp
         4ibxNnBau0H5Izgb2trIeB30pW2yFllJqAOHrXFiR59ffHsPHMSYiw3fDRMJvpeYy786
         UjKV7n3zopU2LdCiAKQnVW/z/iiPgO+ABA4s1eWMnZO9qk8ieT9vuegbCK++dGO8pjSt
         1pAtJkfh0ErpR76d/zszSkF5WRTiWOKGfHQs1JwIaxy0A2x04iVgYQspTBNeKHD5CZYX
         ePtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791285261; x=1791890061;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/Pfmq9lmoce9UQap1hkT3qE7NyxlVsRLj1bFCy4E4gQ=;
        b=1i1klQU9y++tx6u3lOeBbFYK8r5ud2vJXATqsmtDWEAU7b7NuFusuCxUr+k6G/9bdu
         /GwB/pxE7EAlAXxrES6hMu92ehKzHnIdhIo+NKpHXhS4Q1cqVjRJ0Fowb7WaF1eabqTM
         VkBnIwYAqvbImGxTedwdwcNRVUMm8PU1gZC5G5mJO4Idytx+EiP0wiaoyIB1Z75G5o0L
         5vb8cKtzd+qGJDApEScxm35axNHSlr3RF1kev7VA05cuUX+zo54LDclsJTfbiiBHgUE5
         G6wne9uS76nfsLsV0UXlC3aDSh2h6j4l56Z76i2xLkQu4qahcA7t0TAUBRMeRd1RF0yn
         KINw==
X-Forwarded-Encrypted: i=1; AKwUvBxEmHYmcctzNn8C46lZRtkO6Os3s+NN7BjRkzv66OxXJxXyoshUmpfSYjiX5DyBY71SI3Dj1lRlJQV3a7g=@vger.kernel.org
X-Gm-Message-State: AFq9FYLkaKkhD82Kb1ifZD7UmapcB2132JJxNzvvf1yaFLeu3ZsLdi3D
	ui+Ez7YEDNufly7CDXP2RYQJS684zjhgQrO0ifdIkE4hSwS4L71mKGSF3szByEjZ+sfL/e4LC2P
	qsF85xGjWL9e+xY2gAJbLApxQmmlUQSfTdaRe0GOoL/ingxmuY9MM3NRD0RorZTFZMpU=
X-Gm-Gg: AYBFou3bXhAvU2zdE6A1k4dejA4l9WjTkXBI8XXvymoCa2SgBur3lM4xr90jnmBHKDb
	yqzFNeIF7ZdruVUvDE8f6RzL0IQGcgC/i8CIR4s4XuXoIZAqtzDpR9O0uBJrRPiXulx6SVECfeV
	cuRfgrDLm1g9nXUA/EPfgFfhQpjWD8YPeHiEeDNiPtsFcdD8iPrv6WNEaUkHqId3M1HLV9K54LI
	UBJXFzNlJ+wcoS8YTUABnQOTGDY+/XRgGj1xkD3Z3lc5WqWZuktAt58R4uVWjJNpAetz0smo7Uh
	b+t6X97+pqDMiBGhHATiwdZgWlTenDLK0zmR7XvkFIinVGQcmZnrhFu18dB6yVSIiYF7F8glN88
	lDwuHbIi0yzCx5qjRy+c7mJ/rKSRR/Fyg0A==
X-Received: by 2002:a17:90b:1c0a:b0:3a8:5fd6:cb6 with SMTP id 98e67ed59e1d1-3a8719cc85fmr937616a91.0.1791285261001;
        Tue, 06 Oct 2026 04:14:21 -0700 (PDT)
X-Received: by 2002:a17:90b:1c0a:b0:3a8:5fd6:cb6 with SMTP id 98e67ed59e1d1-3a8719cc85fmr937593a91.0.1791285260472;
        Tue, 06 Oct 2026 04:14:20 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a853cde769sm4306838a91.13.2026.10.06.04.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 04:14:19 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Subject: [PATCH 0/2] Shikra: Fix qce configuration
Date: Tue, 06 Oct 2026 16:44:02 +0530
Message-Id: <20261006-shikra_qce_fix-v1-0-8ac54d81edb4@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPrXxGoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDAwMz3eKMzOyixPjC5NT4tMwKXSNzgyRzY1MTc8vEFCWgpoKiVKAw2MD
 oWAi/uDQpKzW5BGSKUm0tAKFsiSZyAAAA
X-Change-ID: 20261006-shikra_qce_fix-270b735479ad
To: Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Authority-Analysis: v=2.4 cv=X5THu2Te c=1 sm=1 tr=0 ts=6ac4d80d cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=0oWdxScfMXRn80FIiJQA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA2MDA0NCBTYWx0ZWRfXwEsos10NS4GS
 5NpKrxfQ2h6wiHWPjT20YV2ZFkS419825dCNSc2snCVgdwB+NtZ5KJvsyX24kHncX294QBIMKS0
 Yj3M5Wv9eDaqqaWyYFc8Jxpkmku4mko=
X-Proofpoint-GUID: kQ0XuJz2xy-zf7uHDYp9hBGPL_WWAlPZ
X-Proofpoint-ORIG-GUID: kQ0XuJz2xy-zf7uHDYp9hBGPL_WWAlPZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA2MDA0NCBTYWx0ZWRfX6j8c9L6Slezb
 yFW5GrT6M+8cDW3WVoYmC09K9k5I3nyb5mTEPvYp6iJuhuLI15SDiqTKizS8ez/EppBocvoIYO7
 sJ383MopfqfhmHaWjqosy8JkxTnDEWwQxbWi3iuwNR40/3dlyXhoaOpQiD0zORXyiaJW27mqMlz
 tBJ2ExTDiVEbowc56i8ZHdwRC7b0u8xZh8P34n9fQMvg+4kqJSkNvD5ldeC8ViT6UTbz4jR3u4K
 LrFAzpyfHDoDtlzObgsliCarEB1Gg490je1pJYTOqJO5tVtNz3e+Zz0IvUHohQG80HG858T9ocV
 njPrXzS4nd9p91mBKhcEMpTLDqp7le4Uo4fl6KkNARGkU442ZZJD/MpAs08IL7xhl2x2ashleDH
 YP/kX1EennKECz038d5uhVrxl0Uwb2MrkCuxQlS1Nrr2inoPSDrNwWw5e/2jKZD0ILRd+9CKCYS
 xVIQXuZiRfXNjx1EFXg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-06_03,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015 phishscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610060044

This patch series fixes QCE on Shikra.
Shikra is derived from agatti target and QCE was using different
compatible configuration.
Also, one more reason to update QCE is, clk-smd-rpm was doing proxy
voting and crypto was consuming it. With proxy vote removal, qce need to
vote for it's own clocks explicitly which is already being done for
agatti target. Adapt same mechanism to Shikra QCE too.

The current qce configuration will still work but this one is more
appropriately describing the hardware.

Validations:
- Qce probe and kcapi_convenience.sh tests.
- Correct clk_summary output as prepare_count and enable_count are 0.

The previous patch-seriest[1] was sent to an older thread and with feedback
received, submitting a new series.

[1] https://lore.kernel.org/lkml/20260907-b4-shikra_crypto_changse-v6-0-0676f61894b3@oss.qualcomm.com/

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
Kuldeep Singh (2):
      dt-bindings: crypto: Adjust Shikra compatible hierarchy
      arm64: dts: qcom: shikra: Correct QCE node configuration

 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 3 ++-
 arch/arm64/boot/dts/qcom/shikra.dtsi                   | 7 +++----
 2 files changed, 5 insertions(+), 5 deletions(-)
---
base-commit: bf1ee2bd5c2da8992f33c8950ef194aaff74ed6c
change-id: 20261006-shikra_qce_fix-270b735479ad

Best regards,
--  
Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

