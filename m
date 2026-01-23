Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7AF358D14
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769152365; cv=none; b=l0SOOlOsAPhS+DUawAMwbGnT1oR7HbIlRd5qvIrIDCuTGmjZa2vlV5FDMUZWfJphw5neJrJP/WjFX822uby88rDiW+HU1VTfGsazDt1Ln+/EGdjTijsV8YJYsBkAy8CMEhn99yG4AvBo2Nk51N2lN2OfaMBotCCUAYPVyUHjJjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769152365; c=relaxed/simple;
	bh=7a3rjjm5VjPLHcbmM4PkplaRtIC//DdRJKgmUrnWJu4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=m3lYG4axsM8pOb27DVEFari78AgFwRu3uxIte+vQDnb4KTAEj89AsM2UWxOWh6xm9U8f84nEfA7N3cME94Ks+xGfgxOU4Z8LY0degJNd9wPMXcqvFfnCiACL7SxHNAVz3VZ2YoBuQllY3KXicwk8bzvtxy6WkcaPzyqTkS+KKFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eWRTRMWb; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ylq7OGny; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eWRTRMWb";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ylq7OGny"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N6AuWS3704258
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:12:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=baTKwHC9taAEbx9mWDj+YW
	/cnahBV4YzjX147+KjL6M=; b=eWRTRMWb/QPlWfnKC/nH8RCGNVlsgi/TzCD2Z6
	ot0jr73NrZNySlQFS0bk/5PUm3VNc/LVl4qekq4MeQswLFBkaeXzY7rnv2aSyI0t
	2azKtfWw+G3+6NCoDEAmUpJ6JZymDO/OjuIQObvI6TTSqjb3lBDwWszvZhHmdBqf
	FhlXW6xINE8kTtoUefUw720e2fVGcsvEcDCii/Uh4+3e9Q81vm0okmVOyrRagc15
	0cJ0FN0EOHGEzcCSzmASN9JgTyGYECI3cDu+iX9zXgE0R7MPQE2JCUNKKJr25/dw
	dNs7d7/wl4cQ5PzAF/wQDKO2Adgqz3zX/1QKGIIjKXKXUsPA==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4buuaysqmr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 23 Jan 2026 07:12:42 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a784b2234dso20010615ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jan 2026 23:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769152362; x=1769757162; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=baTKwHC9taAEbx9mWDj+YW/cnahBV4YzjX147+KjL6M=;
        b=Ylq7OGnytq9+dA4gZrJoj3bX0DA3zUPOFtaRVsqKHHu3DiBO4Vw1y44kPXDyvrXvNt
         rPUE1IUZlPF1SyDLfqKnJ8wlduBMJk0nl6Wd8dxSyXakqZ7CfQw5R3j4W7VjDPVdzXaZ
         GUR//RprZJqkEp5utVb8uwy20zWFrep8JejmA1/IQEbfKweKakdd1RxkLbYaWQV5/t5J
         RVOSwXmzeZhRK0/xUxPeUmmMkLrInG2naJA7Q1px1IlDmbLNqIJNzKOk1aFWnk1qveNK
         nqcXzL2YQq6D7tiPp0Vd0Mb3YPGN1Mi01jXiO93zR9hei68ezSnE8m+pTEndV1x9SAhH
         c3tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769152362; x=1769757162;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=baTKwHC9taAEbx9mWDj+YW/cnahBV4YzjX147+KjL6M=;
        b=JbYPVucQqzc0lvFv3zbG7HH4RzA4FB4x+zrLsDNc3ie9eMvG4VZ8nNxOTrkv5TAubJ
         K3/axNnBYT1IMQFAQqbzCJSA3bV4vdtHY12wPrGqBCycTBb4HgsMWKNhns5Jrpgeqsar
         /VZ0k5nj6ZZluxAjfXOranG6wYarAzTLufbtwEea1vXvAUPM6NV/fibbPPIBfitol9ky
         FD638KljU+N0hO+QgyrqXdgXXTn9NlPy5HZ6PdrucA3SPPUre7O62drfTuSaR/uorMQw
         iwSp58Flxlzql9P0RFspUnfIbIDPHXXVQgk6Xli7tARnc6FlGZtEKy6/Lpzn8kMwqkvm
         5dFw==
X-Forwarded-Encrypted: i=1; AJvYcCV6gNM7rQS4KbSG65sVQKhO3eeT1+S5PL4JOIhSpb985HU9TbEu6vAuLtG46zmf50Dlfu91Ucfq5bVWOqY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJQSOdzGXBq82KRPf8g6JYa1sn7boKR8d/QZ8n9gJHG9fQTzB8
	BAMadGX2yHA0y2dto+0MX32B1oPbY4FXY1Lox7RA6IpNC+/W7VmoYDPzajuHK06AkmuOoX9FgXy
	1p7rTeJwWm7bwd3O8UY/NPq5yW16q918YJxdjBAixORjqwPBHf/i0ZbHPkZ6iO/8l+Rg=
X-Gm-Gg: AZuq6aJRjxARiQADRxCpr0UwoPfhDDBOM6GHRgahUjprfAWNi8qtMuGhjEsoOR/GPKM
	Qu45pTGn5l2otVV/2cAOblkxLexYEfiirZymjvf11p8uSw1e4hrykeSFtTQwGiE0Nu2j8fD/UPT
	xuw4vn41OBJLALw66Kpd4wGvcr/ZFZH7xNPr+j6Ld43xZm9Op85plpVwShLXWOmJ+aCzGffSOVr
	3rK4swoTAu7c3T32js7KMNcsG6nfIJ28qVxfSNUMm+kFqb+xhkY/J7T1Hg8Zlj1bcDfcmLNPd0e
	XkATI/QsmCtvBoBWgT4/w0TbD/tyIL4eFCFaq7U67hbPWyGh5WWODHLqUQrCIYT8nDcluQjhbZt
	hSYd1q8ZgnTqsABcHUIE292HRtjHlRjGpgOI=
X-Received: by 2002:a17:903:2f48:b0:2a5:8c95:d823 with SMTP id d9443c01a7336-2a7fe44aad3mr19129895ad.10.1769152361921;
        Thu, 22 Jan 2026 23:12:41 -0800 (PST)
X-Received: by 2002:a17:903:2f48:b0:2a5:8c95:d823 with SMTP id d9443c01a7336-2a7fe44aad3mr19129725ad.10.1769152361493;
        Thu, 22 Jan 2026 23:12:41 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802f978b8sm10979795ad.46.2026.01.22.23.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 23:12:41 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Subject: [PATCH 00/11] Add explicit power-domain and clock voting for
 QCOM-ICE
Date: Fri, 23 Jan 2026 12:41:24 +0530
Message-Id: <20260123-qcom_ice_power_and_clk_vote-v1-0-e9059776f85c@qti.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIABwfc2kC/x3MQQqDMBAAwK/InhtYo0bar5SyhLjqYptoUlQQ/
 27wOJc5IHEUTvAqDoi8SpLgM8pHAW60fmAlXTZo1AZLjWpx4UfimOawcSTrO3LfidbwZ9WaZ4t
 132BlLORhjtzLfu/vz3lerbKiRW0AAAA=
X-Change-ID: 20260120-qcom_ice_power_and_clk_vote-769704f5036a
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769152356; l=3081;
 i=hdev@qti.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=7a3rjjm5VjPLHcbmM4PkplaRtIC//DdRJKgmUrnWJu4=;
 b=KhzvfAniH2+Zqb4SoGIG6ug8zMLxSbyXfdnD4p98ww8G8/p1NFygW6R/HrfApdpki2LrHXI/b
 ng5tPSkgKdgCp8Qv7gBHoeUZ029f46RmtZSulTjUBOUnjfhMvaIyHsu
X-Developer-Key: i=hdev@qti.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=GP4F0+NK c=1 sm=1 tr=0 ts=69731f6a cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=g2SMA5Qby75y8d18gdwA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: 64QryuHwQRfvVtf2GG3D8YehLHhJCOf1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDA1NCBTYWx0ZWRfX7wYcwxofMiLJ
 105btjgjf32nmeUkMzw8Ym0KRISIaFtKRJI1k/yk4/tQeAyXjHoIO7w0/xsavh92yPArYgIhsoe
 d+fDVLOZqo6cRBtynoYHOkP9aFBdAQcA6qCp5o7pjlnBlagTTZvOFxR/rtik/cwKPMdh/T6Nqop
 evoEcj8TbspbVsPq99fZErHCsHqTBMxE5iYJODHQWAi/3Bw47Jtb2EZRq+5oNA0UP6+sx6m1CK8
 qf/jmxpvsqGrAjwkC6qADhUm5cfwO6AgAM8IkUGARtw6OWWT3Ye17fhWIROfTknAxBLwdDq6qNp
 nocuNfQd6+Ig3p3xr0/yRbSVLj3z7LEFtSHVYN4N5DB7a6nIaECsus4uAeQZxS7561fvYBT2rE4
 UGyi7TFDl7FdKdpQBzeydS1RVNKZHhq02L3T1Fq+w7FBpx/khV4ppq3UNgE/yDIu0mgiJQ0mnov
 BZI6xwnLqg07sbqViyA==
X-Proofpoint-GUID: 64QryuHwQRfvVtf2GG3D8YehLHhJCOf1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_06,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601230054

When the kernel is booted without the 'clk_ignore_unused' command‑line
flag, votes for unused clocks and power domains are dropped by the kernel
post late_init and deferred probe timeout. Depending on the relative
timing between the ICE probe and the kernel disabling the unused clocks
and power domains occasional unclocked register accesses or 'stuck' clocks
are observed during QCOM‑ICE probe.
When the 'iface' clock is not voted on, unclocked register access would
be observed. On the other hand, if the associated power-domain for ICE
is not enabled, a 'stuck' clock is observed.

This patch series resolves both of these problems by adding explicit
power‑domain enablement and 'iface' clock‑vote handling to the QCOM‑ICE
driver.

The clock 'stuck' issue was first reported on Qualcomm RideSX4 (sa8775p)
platform: https://lore.kernel.org/all/ZZYTYsaNUuWQg3tR@x1/

Issue with unclocked ICE register access is easily reproducible on
on Qualcomm RB3Gen2 (kodiak) platform when 'clk_ignore_unused' is
not passed on the kernel command-line.

This patch series has been validated on: SM8650-MTP, RB3Gen2 and
Lemans-EVK.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
Harshal Dev (11):
      dt-bindings: crypto: qcom,ice: Require power-domain and iface clk
      arm64: dts: qcom: kaanpali: Add power-domain and iface clk for ice node
      arm64: dts: qcom: lemans: Add power-domain and iface clk for ice node
      arm64: dts: qcom: monaco: Add power-domain and iface clk for ice node
      arm64: dts: qcom: sc7180: Add power-domain and iface clk for ice node
      arm64: dts: qcom: kodiak: Add power-domain and iface clk for ice node
      arm64: dts: qcom: sm8450: Add power-domain and iface clk for ice node
      arm64: dts: qcom: sm8550: Add power-domain and iface clk for ice node
      arm64: dts: qcom: sm8650: Add power-domain and iface clk for ice node
      arm64: dts: qcom: sm8750: Add power-domain and iface clk for ice node
      soc: qcom: ice: Add explicit power-domain and clock voting calls for ICE

 .../bindings/crypto/qcom,inline-crypto-engine.yaml   | 14 +++++++++++++-
 arch/arm64/boot/dts/qcom/kaanapali.dtsi              |  6 +++++-
 arch/arm64/boot/dts/qcom/kodiak.dtsi                 |  6 +++++-
 arch/arm64/boot/dts/qcom/lemans.dtsi                 |  6 +++++-
 arch/arm64/boot/dts/qcom/monaco.dtsi                 |  6 +++++-
 arch/arm64/boot/dts/qcom/sc7180.dtsi                 |  6 +++++-
 arch/arm64/boot/dts/qcom/sm8450.dtsi                 |  6 +++++-
 arch/arm64/boot/dts/qcom/sm8550.dtsi                 |  6 +++++-
 arch/arm64/boot/dts/qcom/sm8650.dtsi                 |  6 +++++-
 arch/arm64/boot/dts/qcom/sm8750.dtsi                 |  6 +++++-
 drivers/soc/qcom/ice.c                               | 20 ++++++++++++++++++++
 11 files changed, 78 insertions(+), 10 deletions(-)
---
base-commit: 0f853ca2a798ead9d24d39cad99b0966815c582a
change-id: 20260120-qcom_ice_power_and_clk_vote-769704f5036a

Best regards,
-- 
Harshal Dev <hdev@qti.qualcomm.com>

