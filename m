Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B803E0223
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 13:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778764612; cv=none; b=eu52ycrXi75WUY/sxC8PAwBGPIehIQXARurIjS5MyBtGVl4SpnDAT25mmvsZkXcQ5ZoFsSW6ZGBBfweChDiQRh0K2+FjzbBshMsjKddJflCS02NDbDySG3I9BMzhridDwIrAo/qhAZRpHnGsc6lP10UWTnEKOpGOlN3hWXDd3Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778764612; c=relaxed/simple;
	bh=rz4pAC3JmkokksupZBh5SY5itEvF9BJ3dxlNr3lUXsU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LACEFPjtUAg6i8kBGp/dH4o+Obw+sACClVZg+M149j2iQgTePAh+P75LUcFtSsE30hEp8lEYHI3Af4DzK89xChM1wBupqkoe3Gx4sQvaYQfaDyffq4O+IOFqrDny2+IkpI1iz50JEVSQ5JzULHY5NiCvyCFde6nUdFaPJDPH6YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mgIiWZSZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NS92vSc5; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mgIiWZSZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NS92vSc5"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64EBeWcw2554568
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 13:16:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8fctHXbGxI63yquHiTvFAqh3nJ5cncAR/B675vKBXMU=; b=mgIiWZSZWp7VehKR
	ozbUOrZvHTRPatZj8yrMDGKSqeay0QXPAZt32spZRD9xAHJxbNtJZQXtcUVZf5PZ
	OTVLWvcu14ghNM4OYZP0a87yC+g3r+sMMYFJGCRVlh/1GqRJ3rHL/j8W3OOSI89Y
	OXYT28kSAGnuYC3liS4b7SwJnNjsIoIntInA50JXv4oiNHAsHywwL2lhxYI8HT/T
	X/mK+QYVbDJ4Qrbvc0W9v7xW0ycnXY8Dr9itoAshsNui8w/xXP4XAn87GnJbCovn
	poxtuBbUY0WXRjbpDJcl9ISYAcR5BrkUgg6fSncTCsj7x58U2Uqngv+Gjqhb74LT
	SGNXUg==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e5b0brvsp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 13:16:50 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c8276c91addso3245583a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 06:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778764609; x=1779369409; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8fctHXbGxI63yquHiTvFAqh3nJ5cncAR/B675vKBXMU=;
        b=NS92vSc5iWiWmMTPtgTH66uQNHvoY2RYdhy7KTIDHkk+zY0Fi2lFdaN6kRGdb61/gb
         wGm8rEb47h4pToNOjybDBaXNy/gcnvYPmW2+RkYrWh6p0djEbhK6wkxbk49ETFngP2iR
         NSrEM4H3zgZLz/KvL5Hw4QNqKWOfxNLdMtuC5IvuYLHmnVeQT8cO9aE1TLJ+MBxwgLYl
         LEQi1KQUKvRdKyW6fOH+pOna4yTZFmOFNO8UZsKM/8ccG8V0xIxSeGc9f2vKG9XJtU/u
         bE090ztqBmCVo/T5ufNRBs18su4Aefsg4TtVS7GZCpN7jC+wtBzHpnWNsN3Y3BzHGope
         0veA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778764609; x=1779369409;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8fctHXbGxI63yquHiTvFAqh3nJ5cncAR/B675vKBXMU=;
        b=qbyZb6ePoydIPWQlSB5Gb5NK1oJKX0S47ryr6ZvCXp+ZZiJnMu5FehuaTA3YdVN+oV
         Pdjs67wz6IXGTZPblTXq0hw4252huB3Kkoe2nTmkC+hjhwy0+7YUXQK0lDQhyqix27BY
         EiV+CrvsYD/zVbBP/hJBCgQaYx43My9PuE5Oo0jwtboeu3W75nbcmjgZyjOsSASbLKQN
         3LAUh0tWVE/tqVDBDoRC9c/6RTtnB9MkHzv0rBGumRIwWsKuzb1SzuKN6ge5w0ty8GWO
         k94NpzX8dBJ+WZqlGJtpKQ0AWBO8XGHwaQtzXVNDP6f4SX/G3PoiWL7kpLIfw1vQO8H+
         XsfA==
X-Forwarded-Encrypted: i=1; AFNElJ93xIIf/1Mzdm9fyfsd9to2kfZ+JQSd5ty0JoAsHMA6NSe65ELCBgaD6oQqMKmJMuqBsitsjx/qMl3n8gQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKgkSvoacYBxi5F0i7RK2sXzNbadyEYGEhuD+gkqJjx9eq2A7L
	W/W66WUPl7n9as1Qca6Zmd8nUaDGGWVhpZamxYQfJcIw1Ez6mG4EaoHsvulT/asVnBjdCPbQvT9
	bPi0YGqNP2wkR/FFFltAKKS5jYMXv2kXYZ4rncCw4Ke2FIKj8inDKPDp/jdsgqHlYrzE=
X-Gm-Gg: Acq92OEuSmIb7SKU//wx07xCgLbtID6wVWm/oBGgbQxCZhO03DJ287CwjHC6fNnwfml
	bG6HeX8pUmYiULiM0CZhK6k0fqbLZG1nbZ9+WmD7MsAEesKynM3KV7Fm0IRB9R4VLeFir/5q/Vj
	NHbCTFqUenArDThyB43WXXmitZR0mJ1D/1c3hL1jA0U2khxgVatfr7BFlLNZJn4UEdUgjZGW7pc
	cEfs90Jw3WOddOtgzPtJzQQrDl+QNk5KAIHJ7q3sOUHiVWtz/ASBe48HNUOiznmgrxaFfwXm417
	f3Rlsnk3a8ZQT7UdyF2pOQrNM0rAH/ebT4I5yIVm/6vS7u9Zd3VPgKATFL361zfhZKcnZyrw5su
	GibB9KtDAL1f0HAQDszgVWAbvSiq0HHJ83PaW/X7kPPdhGlP5MLN9CcM=
X-Received: by 2002:a05:6a00:4509:b0:837:db9d:9606 with SMTP id d2e1a72fcca58-83f042903d4mr8160278b3a.23.1778764609132;
        Thu, 14 May 2026 06:16:49 -0700 (PDT)
X-Received: by 2002:a05:6a00:4509:b0:837:db9d:9606 with SMTP id d2e1a72fcca58-83f042903d4mr8160225b3a.23.1778764608625;
        Thu, 14 May 2026 06:16:48 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19c7f202sm2666656b3a.43.2026.05.14.06.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 06:16:48 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Thu, 14 May 2026 18:46:25 +0530
Subject: [PATCH 2/2] arm64: dts: qcom: shikra: Add TRNG support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260514-shikra_rng-v1-2-4ea721a1429a@oss.qualcomm.com>
References: <20260514-shikra_rng-v1-0-4ea721a1429a@oss.qualcomm.com>
In-Reply-To: <20260514-shikra_rng-v1-0-4ea721a1429a@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDEzMyBTYWx0ZWRfX3G+SPS6m5gF0
 nGRqh9MVPsqUK1Et2f1wEJ6zZXA4CFYpnWjAK3C3iKaYyHN7NXV+CNXpNXo9YsgKhEWuXcCAfh/
 23IPmU+KDBn14UxP5jI1a5k2XgfKDCrCwYgSp7AIFxr5iocQ3NeyAY4EltIjhFNdmSK6LwOYrH/
 Fy3x8+xvTuRxyZfs9uA4ILC83D1hKQ+CfLyEZ+o2uOrkHE57dLAMJA1uG5IcnKM7yY5l+aYia/H
 Fhiq35yaklS6j4inCR/O+xJach3NeKd3G5dM8VpSNq7Po7oRvrXNMlxtKci7To4qXLYLrDpy7+a
 uriIR6qmn7rqKCnbQ19BIZR5g+gLY5oyry8DD5ftw0ovvjt5uajm0zpacChK273LU0aaBFbEsiM
 vE11y29tAuMSmq4P9AaBeGVy4lWIzre+4rzuC1JNj4822TG4ee7foGtnlQZ7LHbk/PPQ622ND1Q
 MRJ/RcsNYUPr8ZsIuRQ==
X-Authority-Analysis: v=2.4 cv=b+2CJNGx c=1 sm=1 tr=0 ts=6a05cb42 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=h2DT8ufvGNBHFgdSJ10A:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-GUID: tuX64Q24Lk8wd8vdHXXUAYOpG4KifK4t
X-Proofpoint-ORIG-GUID: tuX64Q24Lk8wd8vdHXXUAYOpG4KifK4t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_03,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605140133

Add True Random Number Generator(TRNG) node for shikra.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/shikra.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/shikra.dtsi b/arch/arm64/boot/dts/qcom/shikra.dtsi
index 262c488add1e..e81210254ba4 100644
--- a/arch/arm64/boot/dts/qcom/shikra.dtsi
+++ b/arch/arm64/boot/dts/qcom/shikra.dtsi
@@ -580,6 +580,11 @@ spmi_bus: spmi@1c40000 {
 			qcom,ee = <0>;
 		};
 
+		rng: rng@4454000 {
+			compatible = "qcom,shikra-trng", "qcom,trng";
+			reg = <0 0x04454000 0 0x1000>;
+		};
+
 		rpm_msg_ram: sram@45f0000 {
 			compatible = "qcom,rpm-msg-ram", "mmio-sram";
 			reg = <0x0 0x045f0000 0x0 0x7000>;

-- 
2.34.1

