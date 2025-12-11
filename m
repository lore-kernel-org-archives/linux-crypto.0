Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8658426E6F2
	for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 08:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765442710; cv=none; b=ZLfkNZcpltGbSi3XsNtWazkelzehgwSFJ4Ut0C6M9BhVa3ewK2ZuTS9urMHy1Lxahnu/FZckrJ4rHgHhTeyOLQexoA5pGfB7aDbCGSGMHHpY9IbZdABhOIWE4nw6j1oeYS0bq1G0mzN9XLhGXaidcvcnZgK5XB3+WWYIto15yGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765442710; c=relaxed/simple;
	bh=v87WcpJ5SjS1TYa30P/cv1eb5Av0T7oqmwWqdRVsZxE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=NFivPUFGtNu7La15i/9E4YviBlagCwh9EWf1He90RbddGIV5iJNdhCScgWtXG584VDm0HsjeTCPLC+7aJd8b3DlEgRvsKCCOSQmDmMIdHKGTTrvS3f6Yg+NH/N0AlHDs8zoO+0hAtY7BrAsxHThWbWPjUf4pFGASX3Zxd1ubnpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Sc1un1HH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ITPRECc8; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Sc1un1HH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ITPRECc8"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BB8gaBN224258
	for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 08:45:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=hv35z6aXJ85tgay5dnPDLX
	Q0ev+G4Jzc8gX3Vem/A8A=; b=Sc1un1HH1tIm38Vv9yY9isFsP+qgDe4/Vl77qt
	v3JtUa2Lqr3mEciKwWLGJKMjxmseqAmZSTFW1Kxv5E0SopP12q7HTHWMrbsLsNzN
	7rTgbJmIH9/IkP0qAezVgodGhcFbodFO+KmOrxwknxzRGi8Q+iGCnX7OUMJVstwa
	R0j0ubTgwplK0p9tVHRdb/ffMO0Yjz5JzL5Vtk48fORSSHIYpDD99xVuybo2vr++
	9W6VBWEz7qzh1UPQeB2+0yI8Hs5uFqkFelYPJhYA1WZIic1kb+8odBhLu1F9N9Sf
	Nbx4/sZQd0IZpx0py+5HjC+F5hzfy/tg6eeipObqkaWakKNA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4aynpvrvms-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 08:45:07 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-297f48e81b8so11202505ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 00:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765442707; x=1766047507; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hv35z6aXJ85tgay5dnPDLXQ0ev+G4Jzc8gX3Vem/A8A=;
        b=ITPRECc8RPhHnwIl0GJ1WfmDw9YE66o9hg+QUHZcnjisIFWHBvZsRdbu+VppdZ4Bd4
         tu4yZiI3ghj4vWyndutoRhVgqce2d/+SM1lA6bI3+TMvlMvhmJLG0xES3atI7g4seuFo
         C2w2ZcvKpSvr4V4X5EzmQN3Vzn8BoplWOf5/78RIURNtJg6sTiMutoyar5OMYPzd16I2
         GovVrkS8Wjg7GeExLcqcTF0fgzGe9dSxE295hXPLPCaxNIhhO0pj+sWAS2yt5F1YIKTF
         VRwZ3udjdKbe9g6CsHcm2kAXO+evWQN6Q+3d1dYt2paDSbV01mrpr4Wmp0a+PhnYa4Go
         pOIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765442707; x=1766047507;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hv35z6aXJ85tgay5dnPDLXQ0ev+G4Jzc8gX3Vem/A8A=;
        b=Qe42wd7Zq5WPsjBs2gCmHT+iMlF+YSkcpTDCEpPpuxiSADiiZ8Je1g8SpEoVQmMjKL
         jCp50D2ja9GIHV1CqPu5vRRy/VzhReB4Kn0SErChHJ/I7uPdTzgZrMBPNuv/QgyoBE30
         JvTX5a8Od6DuKtBPKSxIFpPVGkzH0OZFDTGQfaduZHmGkAM6oxAqizznQ5SwXWN81EpT
         ibh5cIWExLAiM5Jr4NiY1rFs2sfdtmvypGrm+UhgG8SIZ9uv8B+yMhkw5aFtlO1TpWjX
         XaCF6jysCyiHJ0Kr/PXTSZlrSq3T9rHiDaow41o3GHu//4D0sR7EPHUDhylBtnL9jts8
         fuLQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3gLYUiYrUvpnIhOvMmfu9spTeSqVDJEQjpkGbPUFAWHGXhisnUcV+Cc/QajSB+g/qvDcWlo1mdPyAGVs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrYojGimddovROrIAK4TnYO6xLsjwxB8yYsJpjncMIKM0NJIuR
	M4hToNfvoQR2n4gA86DH5p6twZN1HpgQUYLwzAR8zmzM7TBc1pMvQnBeXF+XaYQ741EKiFDXDRt
	MfTsEkXL7gGuWZH4qUcWV2GSCu2vNDagVAf+wFPQBunsSGyNo8+FLrxw87QaHxYh3q2uGWhU/1g
	A=
X-Gm-Gg: AY/fxX6dEgH3aZNm1MHT1qW4U98WiRe0SaIvaUO6OspYCu8TVulvmvZENy0NcY8EGsf
	GXacFKvyP8HFQGeBc8efMnRcjyTP8Wxpi/jiDn8gUEHATafZKeXZpn1H+XDsKGdVNu2xZr2IzVD
	TW9MyxhzShYLMkpT7ZtqHtywtTy+Lu1s/FFOJuYMLGQD73M5gPe13Z7IY2TbG+iOyLU5liwd3G/
	q/M+H4XgdKWU3OpGUKoUf6QDxOXXgyzCUnHT01SeQpvkysi7GtLrttFEAkfJz3foUo2D0twepqn
	W/V4UtKXRnP/Tzrlnl3X18NobQskFe7iMFdrypJIbwjq8rd4sKThNRjj/G7g6YVupeRuHKyWxwB
	iBHWLvQRcbWqKatU1JCsGIzzBT5SnQuC2Ccw=
X-Received: by 2002:a17:902:d50f:b0:267:8b4f:df36 with SMTP id d9443c01a7336-29eeec1e3edmr15702145ad.29.1765442705974;
        Thu, 11 Dec 2025 00:45:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFROZCggjnHyx9jcKxhajvG65OuqDhUWCroSswMRWKrmqzaoPAiiqpJSOUgLqJ6hyMrXp1HWQ==
X-Received: by 2002:a17:902:d50f:b0:267:8b4f:df36 with SMTP id d9443c01a7336-29eeec1e3edmr15701755ad.29.1765442705500;
        Thu, 11 Dec 2025 00:45:05 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea03fcd8sm17322105ad.74.2025.12.11.00.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 00:45:05 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Subject: [PATCH v3 0/2] Add TRNG node for x1e80100 SoC
Date: Thu, 11 Dec 2025 14:14:58 +0530
Message-Id: <20251211-trng_dt_binding_x1e80100-v3-0-397fb3872ff1@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIqEOmkC/42NUQqDMBBEryL73Ug2pmj71XsUkagbXahJm1ixi
 Hdv6gn6M8wbmJkNIgWmCNdsg0ALR/YuQXHKoBuNG0hwnxiUVGdEpcUc3ND0c9Oy6znZFamSKKW
 4aOrQVgVq1UKqPwNZXo/pe5145Dj78DmeFvylf4wuKKRoNRlrpEVZljcfY/56m0fnpylPAvW+7
 19jUhnkxwAAAA==
X-Change-ID: 20251124-trng_dt_binding_x1e80100-94ec1f83142b
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765442701; l=954;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=v87WcpJ5SjS1TYa30P/cv1eb5Av0T7oqmwWqdRVsZxE=;
 b=uI6OTVEg9k7IYASsnj1NlqBilg4RjG5B/DUeyuTzVljMcsrNjcr8VOJnPkQnYZkf5OezRI0FA
 MYUc6ULZMTkATcB0+TN0eVxUJ4KAC5wR9/eKeW2YSTZDzzE8C9DvzKN
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjExMDA2NCBTYWx0ZWRfX9XSwXoyJUSDo
 wyw6EcX8Ut3jMvMoNhHbWnq6CAFAy7b3lJ3AKaTXP+zd4k1vLkbzLVzNf2bXY1lOA7msXOUXkgQ
 SnZlFn0FXNuio3cKocJSqK57cLDqRKdXsw4fKJ7KiZsrVf5eJ52fC3RYrinE7G/8FoT0yB9DvKE
 8oKpEjV5KEUaciMhvyZYqBvUCF72tHvB/7cf6Kl6kfFqljfm/o6nidBQfE0AvUIVn0XT4GQhUxy
 39OiPYNCb+9+3tPVzf0XVSkIAV+a2fclRf3UEhqfMTx7LpwL3wb0cCUUpMiY8Y8P2KUifhPKmat
 1TUqWGtbjMuKYIxYGzTeErPCz2MQIbf1QJlCFp6Go5fuG9TT9x3PBqBOs20DHIKeoOplgB9gZQv
 mtA666KGwuu8eOXK3mOAFONVQpFsTg==
X-Proofpoint-GUID: 4KQIrASOxYUhb_ykqytPL8D7xgOFHWu6
X-Authority-Analysis: v=2.4 cv=C6nkCAP+ c=1 sm=1 tr=0 ts=693a8493 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=6ZNt1lSE2E78l_tYFJ4A:9 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-ORIG-GUID: 4KQIrASOxYUhb_ykqytPL8D7xgOFHWu6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-10_03,2025-12-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512110064

Add device-tree nodes to enable TRNG for x1e80100 SoC

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
Changes in v3:
- Removed Tested-by tag from DT binding commit.
- Link to v2: https://lore.kernel.org/all/20251210-trng_dt_binding_x1e80100-v2-0-f678c6a44083@oss.qualcomm.com
Changes in v2:
- Collected Tested-by and Reviewed-by tags.
- Link to v1: https://lore.kernel.org/r/20251124-trng_dt_binding_x1e80100-v1-0-b4eafa0f1077@oss.qualcomm.com

---
Harshal Dev (2):
      dt-bindings: crypto: qcom,prng: document x1e80100
      arm64: dts: qcom: x1e80100: add TRNG node

 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 arch/arm64/boot/dts/qcom/x1e80100.dtsi                  | 5 +++++
 2 files changed, 6 insertions(+)
---
base-commit: d13f3ac64efb868d09cb2726b1e84929afe90235
change-id: 20251124-trng_dt_binding_x1e80100-94ec1f83142b

Best regards,
-- 
Harshal Dev <harshal.dev@oss.qualcomm.com>

