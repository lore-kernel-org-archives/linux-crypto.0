Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B6D3B4EA3
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776342384; cv=none; b=IdtlJGP2s78soXGK84x6izdynpo8a3NhriWELHCh4j7VB2kVdOY7pK0A4s/9LMpKWPmGntDZYOqCk50RRaEl+XTrpDcJJ81rhNrr6pLpAAOYdED1BueB/tQ2dRw98lzEluEbyMfd8A0lNRZEZ6fiGfCarzlEGb6EZcAhlnRUEyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776342384; c=relaxed/simple;
	bh=HLksdKGJAI0iCgDUXw1Rzp6ezeKwOcpnSyQnHzdCJXg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=d7r3+EgaQVV672u5gh9ni7sHr717b7aWsBchXNBkRqUcSaOH3KR26m8ka6Zu1zAx+F3YoNzoYluEyORPWwlLgAQpL4x3U82o9fAabn4htApwXZO7Zvfhg1n63wR42UcbvImiqv5mc0fx+xPuuMqj/e4LjkXMUXM/manLbdxFUt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=U+FIJYd7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dkEQYLfc; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="U+FIJYd7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dkEQYLfc"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63GAY4tG1245288
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:26:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=aplkmEpHZiGBKfdGyVM+q1
	QOGEwDPUO4XHDxKA0PfAw=; b=U+FIJYd7hDfdlddgMNL9MmWZzHQtk8agmh+nHU
	XBVsiqh1CrL2gea+S4mh/5LjXqbLJ35RDMCXlDjbBw16yG1q+UQ2Fe0htiBvUOE4
	TsWtEtHoY29bxBSSVP2iBlpUzZN5qI6znOKTAc+mtO5V/PtTWS0yM3qYVsdBYzJW
	0bYPb6oPY3FnekxpUOyIFJlExfITal5T9hNQnWswcOkgRpkRUeE+4QdJTWQymF+b
	xWUa2zoTpy0Lc8iAP04jNKiUrkqlN06SDc58Pdi02/pI/rAhtKUe/O5Nm3ZnIL5/
	V4HZ0IudFMNEs1qxO5ojL+LifGmHD2+p8Fr50d5ohEl5BZtw==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djx4k8aqx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:26:22 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-b630b4d8d52so5467778a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 05:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776342382; x=1776947182; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aplkmEpHZiGBKfdGyVM+q1QOGEwDPUO4XHDxKA0PfAw=;
        b=dkEQYLfcQ6XAltISDF+u9TxCpxz4sWxiMzj2ni2zZLHMXWj8ueJAsvH3yrsd/wON+V
         gKhvOz0ydlqzHJUntotuD7FarFz/K7a9XAiZjOK+852LnJgsSvH3gLCDZbX/beY29e5/
         zcMCdddysfCejBrbUNort0ZOVT5cvpJTO3VRKX/g3ENRjfYZC1gOSBW1OsrRU8cSaasP
         wYO+1uGLeCpqWNGaEsAwhjw7437W9QTfUyEUchwSi2yPM5ALwDBAg4PXXwL5gWJPR07U
         UQVDPBLYYwEFDVUmT8pw8vCM+WDzdbZgIlGfCDXAZrG1t6AwCIeWVx6cYlrH+zlF21t/
         wWXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776342382; x=1776947182;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aplkmEpHZiGBKfdGyVM+q1QOGEwDPUO4XHDxKA0PfAw=;
        b=SG4FcCsJy46FKehDb+WomDP06rvC2W8jHSJhQvHKwagCyT705/hW3qbqGNI+ooXk5L
         UYSsiUu7k9zDwVUJlo6bDtJZi+/rJI+ZYnhUgOehZsknmlQB6kKnKnBzxeR0lIKXEGP7
         xZRNYyjt0ch/PVd4vo0XX/XSPP7eIwaKVqoIP9kpHqy8sdpCOgHvC78XFhAY+MHc8YN8
         zRiwYnHZeLBkPeHQnJnTS2rnnF2PBpgr2MlmKc6s9EmW5goI5mc/TyRqAeaYkPAUansT
         ZDG7pG97rg/+Twx+OqOQd5LMTCydGYzkEUG6O+S6TwxRn9NmXB/v9LUySjO9OdzVWIGq
         eK5A==
X-Forwarded-Encrypted: i=1; AFNElJ+BlomtSXh9eqL9lACzxhJymhbXlVt2gGzO5Gpph2mNjxARyEr2j0zc645Uckn8u/DHucnl/YU3AYitH0c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdBALvIfcVSLU0qs2+EE2V8d8PQ5pux5WuEjcSSjf1+X+wB2kN
	e1DP3KeFHj9OpO4ltFEOuYipIsofgWeimxKl1hAy7cI5ZXXqrfgVLKog9C/c1qCFwEeUpU0f6K4
	JJ9REbcNsYl4CDY7oCXB9qVC64A+rRCmOmIOu+e+4O+y/wMv5RbGp/dugwonVkKZjgGQ=
X-Gm-Gg: AeBDiesQqySpYEyzX4ehi+9PKnwXg0dcfalXyQgClfCOnOZCg5x459ZDrmUOJL79BJQ
	sI6B97wJD5DTCOwsmPsjXTMBWrL2M53x5xvr2/G29TSk7nF+aG2288bP1q+x5b8DtjjeIlxhGRF
	pBiQ+kFRWd6AfGbaemgYAps9g7/rtDDYzZhKnDjhY8T1v7xB8oKKjOy/SwUgof+52ulF8SB3H8q
	e3UhAGCG7RPCu7Bz+AyRo1kZv7qCwXr+gFwKbusJnVeekwhMIYpc11Q8cKbbxVSFOOcSKH7xRBH
	j84znmEGy0A1sI1GZQ7BvH04ZO6jpwdqt5m+LXx1VH6KFEdAQ5rr5ijvvtHMAQ9bgP6JIA+JCyv
	pp+8S3GVZGiG5tCyXiWzcDieIjw7XLNYfl8HnvwQMxBfmx8w1X5JhxAzeHw==
X-Received: by 2002:a05:6a20:6a27:b0:398:b95c:51ed with SMTP id adf61e73a8af0-39fe3f55568mr29161925637.35.1776342382008;
        Thu, 16 Apr 2026 05:26:22 -0700 (PDT)
X-Received: by 2002:a05:6a20:6a27:b0:398:b95c:51ed with SMTP id adf61e73a8af0-39fe3f55568mr29161889637.35.1776342381463;
        Thu, 16 Apr 2026 05:26:21 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f673e0b56sm6227542b3a.37.2026.04.16.05.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 05:26:20 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Subject: [PATCH 0/2] Add TRNG support for Glymur SoC
Date: Thu, 16 Apr 2026 17:56:10 +0530
Message-Id: <20260416-glymur_trng_enablement-v1-0-60abcfd45403@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGLV4GkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDE0Mz3fScytzSoviSorz0+NS8xKSc1NzUvBJdY0NTQ4skM8u0pOREJaD
 mgqLUtMwKsMHRsbW1AGqQTf9oAAAA
X-Change-ID: 20260416-glymur_trng_enablement-31518b69fbca
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776342376; l=613;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=HLksdKGJAI0iCgDUXw1Rzp6ezeKwOcpnSyQnHzdCJXg=;
 b=mG7KiALHFvK6cAP3z1XDvOghxNC9BUw1l5PAsyazoDMkEoYkSXd7mZ0o4kXIygqdBgNHU8+DQ
 syNWhn0gRoHC4wkEo9jCW+3aqBfhDESoOElkfv700oFGkClnG1mz7gB
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-GUID: F549381SxJp6C5UL8z2twdXevUZdpft3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDExOSBTYWx0ZWRfX0PvH0fVmDyP6
 ZyTwJCDG4FtlgvRzdPRWGR4h4b59cY61+bvaJS2dbf9kjccCEKzhmN44ZcBS4l7klJ0TV2Z9E1Y
 iMNexuk6kpDPkz36e9n3pue2PcHOvjY+vCwydFiBlzkGvAOOcy+gJ+pFBQgKAPJjHvO0f3tWcm4
 qK/OotT19eqVe0FBaKOoUrkAcuOcO8ljGHtFMA9U1/UOOPkFm85PPcW02cFdL+nCuuc0lOzyQf/
 5x5GQkeh70D5L19yCwshXtOILQ7a/1tKEF69swbGSIcdPUhQGPe+1TW7DC+SZnGfcFm6dixsJYm
 3KJ2Z9AS4zD8nE1PuTen1uVVRrckqjc/MMtIC0++qCTPLhnaIn8R1IIcdwg2kBQ0znLYgTpZD3L
 GEzAmGUTd30voHf0PKZUqWC/Qbcp/cYxBiNKOKqX4hmHSIhRnzDZx9RCPX4TYBIc5G0iBCMZwtR
 pUCMIV73N9EsXXC+azw==
X-Authority-Analysis: v=2.4 cv=H47rBeYi c=1 sm=1 tr=0 ts=69e0d56e cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=kES01Y3mVqZ45jXFSuIA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-ORIG-GUID: F549381SxJp6C5UL8z2twdXevUZdpft3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 bulkscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604160119

Document and add the device-tree node to enable TRNG for Glymur SoC.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
Harshal Dev (2):
      dt-bindings: crypto: qcom,prng: Document Glymur TRNG
      arm64: dts: qcom: glymur: add TRNG node

 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 arch/arm64/boot/dts/qcom/glymur.dtsi                    | 5 +++++
 2 files changed, 6 insertions(+)
---
base-commit: 936c21068d7ade00325e40d82bfd2f3f29d9f659
change-id: 20260416-glymur_trng_enablement-31518b69fbca

Best regards,
-- 
Harshal Dev <harshal.dev@oss.qualcomm.com>

