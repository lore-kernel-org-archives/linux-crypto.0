Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0C929B783
	for <linux-crypto@vger.kernel.org>; Thu,  9 Oct 2025 06:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759990765; cv=none; b=KAMYesNNFvPxvvDjbX8IubmLJ2JrRUiRK4qN/FGoQnR1tD1PS4GtQ2yl6uJ+X9QUELYuZHg+7408j/BZIlo5pTOZDxF2AghfJ8SEUfatpTBQGy8g9SKotdgqxZoXIf7MUzN098fRauEMAqu9BMTnhAOkzrQBhZCfOJ9kaTBLZvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759990765; c=relaxed/simple;
	bh=hq6lPwx/LlAxDemNp/o43bmJQh1mZWxBV9kEbcr71VA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Kmfja6OhouDYWJs43JL5pWLsFY1ap+4vZwLQyDMwIf+qlsk9n9862tYguLPjYH+ty0qdsA6RmLnSpTO1sHTccbmLISkqY9Mun9qu3gn9X+ChLMSDYZKAxe59CuWhqXeJ7yIpyvgL00Aqd/gXJdaZJ6y0aO08nuwEbQ/Q7TgWUks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=b6eJ3jPy; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="b6eJ3jPy"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5996EPIT028592
	for <linux-crypto@vger.kernel.org>; Thu, 9 Oct 2025 06:19:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vihRQdTrmgMT5JdtyKr026uGWsPWwj22Qw1GxNp1440=; b=b6eJ3jPyTK5hkGce
	KQsS/Yqt/3qKYyd8AHrcEUXvCxCByXwfCIh7t/NxMDiVutd/lsR1LLQvnrV+mXbw
	pSx8Nm6ftBnSNgzJ34bOmcZ+Efg1cQCZVOTxD/bsRYCDVZR6Pn52VR2V4FEzA+NX
	KL1G28u6Dq3ncOdOkxnlZJyCON1tXgdzrBnaBHIFCiR6I/r19GD23dPn/6mK+sE5
	Fq+1NUtRTu6VEEljzAP879YzBYbDO3KiXfgGs0FBpAKsKfWEW8TGcuyUHBmVX5N6
	v1A2jKDwzImO6T6csmwu+hUzE/AdW8AgpcChknL0ttquGPIe833i2kgpfTU4M5lg
	vK4IKA==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49nv4ksnuk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 09 Oct 2025 06:19:22 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b650a3e0efcso652934a12.2
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 23:19:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759990762; x=1760595562;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vihRQdTrmgMT5JdtyKr026uGWsPWwj22Qw1GxNp1440=;
        b=ECdFxga6uRn/MZCfLrCK68H15y6MeKFUkMl5uIn9roXO0b9q/zTn4EYzekChtpIGXh
         he7SdC6k4u6uiiacH6A8TbPMgoZnhrbw2d3sFdu6+3JOV9H1OHEEGjzlp5aCB+C7vXWn
         1p1XHrFzFnKE+SYUvSlRU4Sh38tFpZ3jkBUId0lr+lblkfFtwjenqtr+pZvvjRSf8LPE
         gBA/4N+Wg2IQzMkhGpCgs6Pi+83jsM5I975xIr60Kx8kOMQg29AGfOwflpVWyJFzwg5K
         PxGC3zZOJiuilWaslkH1ysNUavvI5Warc6kCKZsDTUa6Ob4AjfSFVAe2yodVph5GrwYi
         bF5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVn+86/WZkOfLmVXEC4rlU4MbzgHREtD8AxPpmG2Ze5XtMh2sGs7IatsOMxQTf99cvwqaIAB9NZMmBuzb8=@vger.kernel.org
X-Gm-Message-State: AOJu0YznY3hp2xT4fyZYoBqwbp34IvCMPuYSklVGSx3wcPRVz/H5Jbgk
	r3lx7kIhTvqYjJSSXH9EaSZeFSFikcaAjeCV4zkDM1gsUEDpldxULnpJcb3Wx1eVeUHXygggyBD
	mkrA7td4LmT+WjMRIgMQQzw80Wdzn3EwIR/fw0/UqfZMa+uQlnQdgZlrcvS5wpj0Oq9w=
X-Gm-Gg: ASbGncujmJgmcFzEEw3U+uuwX3CsaB5RpqOSWKhfX6dn+y9BHuNqq1qWM/zGibfTEQc
	5IEGJw0UrOf4bIOGzCtqukhfGX7DVJwNxCAMlMRHrAv2sIp5V/shZTWp694YMYpNdtIcQMLIsOc
	T5JyrWKybkurm+O1y+R5zk9NtG+/dzG4BoU8Jy9YPlorLJe3NFwaV6Nip60GgaHn7q88AH5jq5I
	TRhMsMPGn6ttDm/NkWmv9GcSJaUeEsLSs2QjQk12og2HSXwpsGglIH6NGhbT67MklElxfG3Mnep
	8umbq+yCspDzgEjl2nmw6mpBWOj6looEEAT04xK3I9FdMhGyNjYf4WOtwsVkbYwX7TQ1XWHQTFN
	nI9Hk4Ww=
X-Received: by 2002:a05:6a20:3d93:b0:2f6:ec69:d448 with SMTP id adf61e73a8af0-32da83e389bmr8621610637.31.1759990761905;
        Wed, 08 Oct 2025 23:19:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmGBOeCai2v9eRB0KpRm+tuIHJxkr+PscYZcrlVB1lXuEuGL44JtmrAh4zV0b7qSGb6VhPsg==
X-Received: by 2002:a05:6a20:3d93:b0:2f6:ec69:d448 with SMTP id adf61e73a8af0-32da83e389bmr8621573637.31.1759990761401;
        Wed, 08 Oct 2025 23:19:21 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6099adbcbesm19239671a12.4.2025.10.08.23.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 23:19:21 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Thu, 09 Oct 2025 11:48:52 +0530
Subject: [PATCH 2/5] dt-bindings: crypto: ice: add freq-table-hz property
 to ICE schema
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251009-add-separate-ice-ufs-and-emmc-device-nodes-for-qcs615-platform-v1-2-2a34d8d03c72@oss.qualcomm.com>
References: <20251009-add-separate-ice-ufs-and-emmc-device-nodes-for-qcs615-platform-v1-0-2a34d8d03c72@oss.qualcomm.com>
In-Reply-To: <20251009-add-separate-ice-ufs-and-emmc-device-nodes-for-qcs615-platform-v1-0-2a34d8d03c72@oss.qualcomm.com>
To: Ulf Hansson <ulf.hansson@linaro.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfXwSgVzuPkOC2J
 tRTaDydlwssV1Voe+13Gh+yAtV5NoawKEh/V+vxW6BJ7OH+aLgdNBjgyo97ZQL+hECL1llteOdB
 Dn+6LcgWMZYJM0n+Zb5Go+CdGhQrQEofVUQcHdU8DbMZ3FyMBwP+gkS2gXfijAJM7Dud9oHLUhe
 szNjI+I67fjVqPQqHbGiQlcx+BMlrjmN+PatlFDELRsyALgo174fuluSqoNy3y/dcLg8eDKUlEc
 Tnm0ty7KFYoHC3jvBp3udE8BEFZq5hZu416uagb6fnAxKHmLx2T96Ab45ShWQKDpiU3mm/U0FFA
 HROa7Ey2HjPMiNAzq4UdR/NtUgPZlSpBzvUhuUkZP/TgL5K8YrruJrlBCdj7geBAJ6bsjfSqIck
 vD305bhqTB7nfVRgGwhKai2NpFryTA==
X-Proofpoint-GUID: rOolFUYVzneoCqC94TB73l29pBYVPvho
X-Proofpoint-ORIG-GUID: rOolFUYVzneoCqC94TB73l29pBYVPvho
X-Authority-Analysis: v=2.4 cv=SJxPlevH c=1 sm=1 tr=0 ts=68e753ea cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=EUspDBNiAAAA:8 a=RNL4ykPXmF0GAHKcDNUA:9
 a=QEXdDO2ut3YA:10 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-09_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 impostorscore=0 spamscore=0 phishscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121

Introduce the 'freq-table-hz' property to specify the minimum and maximum
frequencies supported by the Inline Crypto Engine (ICE) clock.

This property is added to the ICE device node because the ICE clock is
managed independently by the ICE driver and requires frequency information
to be available in the device tree for the proper configuration.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 .../devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml       | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 08fe6a707a3714ff11d01b36afc8a2aab1ad490c..88bef1d38013fc7d0e6842e370b2adb3bf3e8735 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -29,6 +29,11 @@ properties:
   clocks:
     maxItems: 1
 
+  freq-table-hz:
+    items:
+      - description: Minimum frequency for ICE core clock in Hz
+      - description: Maximum frequency for ICE core clock in Hz
+
 required:
   - compatible
   - reg
@@ -45,5 +50,6 @@ examples:
                    "qcom,inline-crypto-engine";
       reg = <0x01d88000 0x8000>;
       clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+      freq-table-hz = <75000000 300000000>;
     };
 ...

-- 
2.34.1

