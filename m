Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF3438A726
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 13:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778764603; cv=none; b=Y+x0n5pNoFadBtLIIcn7n9ESAgMFcRc4OoqqLdgCED2jR5osS+zX9w8B4MQ5zbVcHcR4yxnkmJPR9UHBis4/c3tuaJuNjOft7ayJ2I0j4bV8WH+CwcBWZjo/3Nurazsa1Jaa0bjHFQ9u6o9vmH3uON+aO01HQk6SI34xVCeqVnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778764603; c=relaxed/simple;
	bh=doRT8cwl5tuW4v3nDKY0tWcMpACQ4r7ipwewcgGcF4s=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=jOehedDIcefBl041VBCajLvfeRJC/Tq8Myqjr//tdVCQ/4Lze4+0XhXJXnEGXCjxJIAhRCHQq19jhX4ZGW9cVIe3pfHOwu/KuaPUc8R8glmxjPpBwzq1tvHThCLD8haufOYwcrnNqy0fFPcQEERTWlP5sjLq7VjaQcw15m0XxjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pJ4O9nvL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QtW4/rle; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pJ4O9nvL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QtW4/rle"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64EBeUO13048536
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 13:16:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=MSrY1vYdLTiLQUIIayjkcA
	EoHn9Qam7mz3CuMYOBslo=; b=pJ4O9nvLiJsW5EMSIZ4lS8u0tHjFofwxQMLwmv
	FR4YDpL4rHNFVmMo/+/tPLUprNvyw0C98FH4t77PiAEWu3rVl8X8NfKHHJ/mlfAU
	7pFYhznenI4CZ99u9bxXugs8PA8ZYNn23QGkxrjRNjZmqIUSFgh6KbT7j8tlfwY+
	Y49lMsOw2M0qg6OaAUZ4S9iMrYgpNpmfYwRjsN39VHFfUhnV+PAtURaLUkg2Zen4
	C8y/qKSpsNipSQPjOw+w7dzogITG1YwCa4mFXJ3TbrZp2aKlzPR5v4IOfCmULaGm
	WUvU5Ua6HXkxvCpcbuuO5qh2a+ZBOiHvphZn9Ds7QdF3+BUw==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e5492t7su-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 13:16:40 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-82f6a5b4f88so9940356b3a.2
        for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 06:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778764600; x=1779369400; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MSrY1vYdLTiLQUIIayjkcAEoHn9Qam7mz3CuMYOBslo=;
        b=QtW4/rleex2nkQ6SM2AXOTMi64fnyBeNgW53MbY6ajVfF3Qw10J1DZDx79YiQNIjw4
         6GkLb9j4ydeLRI9Wh5hrrKCdN25i0W2Kx5TSn0wRgAgVdkmE9P9M2HuF+3Okyh7mw6rc
         +Xor/G5JF3fnFng2Wnt+j+V+KPAzn6z6febEkpnBTq7Zsi9kZZP93I5lYzgS1LLW7LFD
         XmtPLbXIHiGpFvkVIMAR4GYfFqHFTeb9I/0g057ChWiVHbu1FUKayp8BhAmdM4PtVoaS
         eGhYfHFkWn7uJP0zglR7pC94WPzBTmJCQpbA+Ma/DBNqfsLHx27B6fC9iWH1eQEHg79F
         mEbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778764600; x=1779369400;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MSrY1vYdLTiLQUIIayjkcAEoHn9Qam7mz3CuMYOBslo=;
        b=HGHRnOMA/p+cUl5N+sAiyFWgJfid2J7sNqWgLjq8Jdi3PqhFINtVBx6928Y2IoF1xI
         5feU4RbBC72de3ySCjuR2qrJKTdI2tjALUMlZ9jcCUa6OaodqVk8iGzWTHKl3c7JmZPm
         7PzU5D/RLZkY+wC/quhMVmFTW4fWAbEggIpRFRUK3NE2gkgak1+jAcTbkgzctasJMvuZ
         epU5T1ABCOa8LhfsbN/Ku+PLL/WghercFF8n+9OLsEUtLPWp4BDCeeZbZbpDu9OLt+pW
         zefNiLvYKOXU6lchAZImiGWJ0eN6aqaCBTR9VNVdHIzoyfvCuAxLIpgfR/NHlfR1DUjQ
         bMww==
X-Forwarded-Encrypted: i=1; AFNElJ8y/bDM61nkXxGxMGwDGtKEyjK42IeIW3VMmFUtTFEL0f/E2k4T11PZqPNnJt+BT5l1kiX9AE/otYOoBgw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQXdFIsv5BywEu3O7zcCyJi5UXiQJS5VW3VRkDM84WYhj8b3X0
	jM7gP2tJV2f+nbHs/Dsw5JkWI+6qyv0+qjY6UT4aIIehGX52XUehkEmNgCxgwIDnNp/0uoHD1jJ
	ljkQETc5NkH5ooHjDaLIXI6e1V/SEWTCPmIaAirT9NYo0fCNNMsefwhI2PviBmd9bLyE=
X-Gm-Gg: Acq92OHMxqN1sODSO84EyCyQdi1LpXFNp0CxQ5JKnJxyQbWyEyUwMi9n+WY3n5NZYRZ
	/viWyyMngUvXCkxs7hre5AVhGdqqlZ5yZCyifox8jtkMu8uF/CXPwLWOGFyD3eZcKweJAAvVvqu
	vCn047uu88BzMcTlD1TxFnmAjKi/gbDyDUMyvPmK1/J6aq+0Y0Gn2ZVm58FujLVXpH5+t1SlHRy
	mqkzzjAmQL8OqAebk1F/MPTYW5QdidIfZ46pLz7ZrZU7S4wr+tP/5ZgvF0V/PAuDH4R1mzocTcy
	h5Yzc6wvRdEzwLVpI0eEVgk1PA/KzmaRdyTwegtXjyrp+PkAKkeOM3UbVaK/4BA0C+caj7Ti/4A
	ABBw5yfnUpo7/Md2ggRQBWcoMhH6OiVeDnEdZoOMbLB657u9bamvtmRQ=
X-Received: by 2002:a05:6a00:8e09:b0:82f:aae5:c7a6 with SMTP id d2e1a72fcca58-83f042c3b5bmr8052730b3a.43.1778764599912;
        Thu, 14 May 2026 06:16:39 -0700 (PDT)
X-Received: by 2002:a05:6a00:8e09:b0:82f:aae5:c7a6 with SMTP id d2e1a72fcca58-83f042c3b5bmr8052683b3a.43.1778764599429;
        Thu, 14 May 2026 06:16:39 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19c7f202sm2666656b3a.43.2026.05.14.06.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 06:16:38 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Subject: [PATCH 0/2] Add support for rng on shikra
Date: Thu, 14 May 2026 18:46:23 +0530
Message-Id: <20260514-shikra_rng-v1-0-4ea721a1429a@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACfLBWoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDU0MT3eKMzOyixPiivHTd5FQLcxMDy8S0FCMjJaCGgqLUtMwKsGHRsRB
 +cWlSVmpyCcgEpdpaAKWRhVxuAAAA
X-Change-ID: 20260514-shikra_rng-ce87409afd22
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Proofpoint-GUID: Bmisch5ldBTAzdD20ytu74hLr5BTZraY
X-Authority-Analysis: v=2.4 cv=R74z39RX c=1 sm=1 tr=0 ts=6a05cb38 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=RhLXBfPnT0iXFB-BVwwA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-ORIG-GUID: Bmisch5ldBTAzdD20ytu74hLr5BTZraY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDEzMyBTYWx0ZWRfX69OuhrO3x2TT
 +NKtErIoKjB+/gZrRdP+hLtghjJVzzokmdhCiWhCY83BMqsrXzScN4aufTjQYkjjDjIP1MS5NYO
 W/V4JulTQPmN+SqIX++DGYsbk1jhshRlFWj4XqWM5FGWD5A5MAvREfu2uM+KR6oZDzZD0OmFqzA
 x92+5nnYV9xAeQy9YjLdq4ckY8Bh8aYdLfgntmbQNuY9Wf/mCIh6dX4yq6COlrz70bmGqkiYbyQ
 LXRpN4bpVtep5bLp0XEMNRyVPhVtSLnAIujSvbbKUmlBXySfQIjjxlvTaToez1gIHTivjQsHP8j
 fCl/GUvUCMBGd4QpG15auDy5RSCJxdi/oUewxzYpeOxdY1wbdALDPqe4FTjMJHwklSjQuFjTkKV
 bbnsyUh1bSYlojpNQ3SnDypl9Garrlf8qfU+GoFlkXPQMimc0i+SA68r1VaTqJQ30m4mBIkxNOK
 VoUZVxGTTm1KrEpgTIg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_03,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605140133

The patchseries contain dt-binding and DT changes for enabling rng on
shikra.

This series depends on the following prerequisite patchset:
- https://lore.kernel.org/all/20260512-shikra-dt-v1-0-716438330dd0@oss.qualcomm.com/

Tested-on: shikra-iqs-evk

Testing:
- Boot the board and verify qcom_rng driver probe success.
- Validated rngtest utils
- validated against dt_binding and dtbs_check.

Steps followed:
- cat /sys/class/misc/hw_random/rng_available
- echo qcom_hwrng > /sys/class/misc/hw_random/rng_current
- cat /sys/class/misc/hw_random/rng_current
- cat /dev/random | rngtest -c 1000

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
Kuldeep Singh (2):
      dt-bindings: crypto: qcom,prng: Document Shikra TRNG
      arm64: dts: qcom: shikra: Add TRNG support

 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 arch/arm64/boot/dts/qcom/shikra.dtsi                    | 5 +++++
 2 files changed, 6 insertions(+)
---
base-commit: 33c8e3305b65a2e757e68b10af521ad54ea051a6
change-id: 20260514-shikra_rng-ce87409afd22

Best regards,
--  
Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

