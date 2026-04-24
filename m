Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF65834FF59
	for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2026 08:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777019743; cv=none; b=fFG5C+6YOk76Tua4ghS5oEUp7Zoet6ITDkbW08ukr0tCLi5DExZZKwClVEo1wwVZGonA0BFE2GcvZShU9IcYHIZ4sdRbkIotSdCcwAg9EOaKZyVgKEm7SNeXQViP7TJi9UhmkfQGVbgLsNN3wxoYJOc5JN5j0I+leqOdMuNLncI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777019743; c=relaxed/simple;
	bh=/J52INIEyqe3ryPTItKAe/xWhQ950uSYdgT3SblSQxs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Z+cgABGZDiSJila8XQOVd8ir9hWRLJDx72Lzzp7bQr51ADnW2MGaDCd0U1hjsesNIjl8Cn2eg0x4f/IGiiI0EoL0prQFOk6F1/OZpbytIXJ+gRlgr+TnFm7MS2kxFUF4zabC+VTHAnpcXZMW2fREoMC0FULyYn/qAzGnr4NkXx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=B1J9xkVw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Kljc4D+c; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="B1J9xkVw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Kljc4D+c"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63O3GkCP518505
	for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2026 08:35:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+mjPQuWLUUjcauUhnqzA5xqePzScAkWSzv6f2oIP6zs=; b=B1J9xkVwuSXnaanF
	PD9KeovKYT13cC/HBCwnHxXlAt0oXxKx97i7QUHy6PNdJ977io0TZxeRNZGbVcwh
	xwazTRnGl8/D2uN4PpEn8YCVjCCXTBkXNe6sFRhEH/Kv50ugjPuX2WeOo//GmrPx
	Yvc9rmL6pSQWw9IYp3WJ8oMtC01LO7bYxOBylLTGmK1quZSydeFhIX/xOOF+uPhZ
	JWp51aiGuYbztBvt8AEeHdxNUl74PMiSJgnzqnFXscCTd5sd342IEWTqzl/Ft7W0
	IA823mBwvSUBL/TojMXJOOpkZ7bDmvYYD/yNVYC5gLlkD7LsjYna1bLHmvweFAyl
	jEt6+w==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dr0fnh3r6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2026 08:35:38 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2aad5fec175so106904565ad.2
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2026 01:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777019737; x=1777624537; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+mjPQuWLUUjcauUhnqzA5xqePzScAkWSzv6f2oIP6zs=;
        b=Kljc4D+cK545Qcke4H7go+UN9X75jlwX7HMPtcmgheRt4nmng2pVMhOs0aIuuOz03Q
         LZyCvdC5CWRMmRIYoqfALH6iGjOYHapVA+OA9WrsAPS+/QzG696QguKMzw8S5k4jl6TD
         2EIoVhDlX/1zLHLvXdciDx9JdayYxKhpC67xbCh6GuH+SACTxz8GNNX+Z9LJGxRFgtW2
         Vpo0Nh00U5wkgNgYNl1ut0l7Q2PB3q4kN2pM9UNzGWBqaNw12rtmVPh9iwDhn4u2ynMm
         0w0oNyjgEhXBauVULohdpBRKaSNG9Uel/wnZR3WHS78sOWXvwy2T4VSgqRSER+DFk6Rl
         Gj4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777019737; x=1777624537;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+mjPQuWLUUjcauUhnqzA5xqePzScAkWSzv6f2oIP6zs=;
        b=gdYMp02Y0fRCcXEEmHTRia5dC8L02VA0jEgGwMv1BEzAIYBJVUVui3YExooq2SzfA3
         d1dJdgXIjsipYHgYnxr5bCpxTUnMdUHBJyrniBhJODKG/eZJGZlEfWzBnFs9cIoXwJUb
         TtCMsTh8zW0iciXctY4yEw2E9XbmW/WAyXtgAf/P+F4EXoUDt6pEzoCmAn6eiemqD218
         yCgv2i79j6YTsnW5DfTfqXHMQDD4LnqYY+A1VDc4d14j1icv6tef2o4rZCE4E4l0Jzez
         W+NSOb49YVjDQmklVHpzeNLniDThNNdKVu9h6CRgM5Kz/2MpFdkrkeqe9Aiw08OjdbEq
         +Ujw==
X-Forwarded-Encrypted: i=1; AFNElJ8w7dYwkLAfaQHCsRng4Es57wAnLp4y8ikfoH2/vIdIXVIbcJMR1WuTuX/H3+Le+b13RxNjPKgJCssesBU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxIdI9eqxNqF/CZAC5IrOmJ6uPlM1VGO/HYU6gW1jEorvQpsVf
	vOQUz01sbPm23vpyCjXgOSRotsMv3xnLsG3LryfXTbMW6pEDYrbpKX6wj//MQVckYu+Y0q8TddG
	oQgC39Pf/1Cp97nrWTn+AR9T4Z4L58OdskHvB84xaLkzCRFyE4VeiLg45xLl3tMDADc8=
X-Gm-Gg: AeBDietjlZ6GlPkHNbFBAj7IILpTu+M0qmXEymz4iMqKYtsnzh1AJbRdbagpWiwIkVu
	ZQUAt4RfrgBYYeOtPqbyslN6vO52dFsweWVjW51fK/BwiFXVbIolN/OJodBvf+JyKaG6smoasUN
	hA2Cq+S2oLjCalKR4k5g7AEB1OIxW7oGIQA2nLfguTQsrSUMEv5/q3CkhLkZTwL4YyTuF7vr08e
	6aa0T8bmhvbx45JJLt1OYJRXHPTfxqs6zUQ3QxvEQnhwxv6Av6drmRRjHqfrI8S8waYO1fcrExk
	tqSrIM70RaFcvZaZtvCeUEx48H5wwZGmmBjJKXRsimlI8z1bF39YP311rzH3L33Yz5LGAKxdAiM
	Q39ispUaSJQYSCMpN4tuPiurJhRyOFm4BrYsY1FCIX3jPDn0i4FP+ZkJaow==
X-Received: by 2002:a17:902:9696:b0:2b0:4fb6:85ce with SMTP id d9443c01a7336-2b5f9f7cec4mr224583425ad.21.1777019737424;
        Fri, 24 Apr 2026 01:35:37 -0700 (PDT)
X-Received: by 2002:a17:902:9696:b0:2b0:4fb6:85ce with SMTP id d9443c01a7336-2b5f9f7cec4mr224583235ad.21.1777019736994;
        Fri, 24 Apr 2026 01:35:36 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab3a929sm211389495ad.72.2026.04.24.01.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 01:35:36 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Fri, 24 Apr 2026 14:05:08 +0530
Subject: [PATCH v2 2/2] arm64: dts: qcom: glymur: add TRNG node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260424-glymur_trng_enablement-v2-2-0603cbe68440@oss.qualcomm.com>
References: <20260424-glymur_trng_enablement-v2-0-0603cbe68440@oss.qualcomm.com>
In-Reply-To: <20260424-glymur_trng_enablement-v2-0-0603cbe68440@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777019721; l=857;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=/J52INIEyqe3ryPTItKAe/xWhQ950uSYdgT3SblSQxs=;
 b=Iam1UBTwjoTN0q7XEEYTBVy65N/Q/4JjzJdgQf0MOZsFm5XLvYvex0fZBKQ1SAJnn0WIYAibx
 FXnpgKvI0pECDBo98CQisfZ3wpVWdEJiIVsL+Eq09rBjKENRFX6aafw
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Authority-Analysis: v=2.4 cv=LfYMLDfi c=1 sm=1 tr=0 ts=69eb2b5a cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=XSQ5iGHSRndYU6rLgXUA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI0MDA3OSBTYWx0ZWRfX2/31a5H2Q6rQ
 vvtwezEM3/UbNKo5HMhcie/VX4knkeW2ZvCziOGI9AiopBKQbYQZ8JPZMAV4x5IWbzRUCGQDigc
 U2E8OyXOSHy70ln9LOfa7lkgtvfM355lB1q5rpsPziWJHei6hjymEVDsZ5kx9hLSJOj6T16ofnO
 l+uS55tVNJEh6qlURy5rxeuNDmyFNeaxr1LoHIeydYDcIbRbwMs44l5v82gOo2KaNOGQBgMYfg0
 0o/atKXzt3bjzzWcaCme50f/ByU/W/yW9ytrHe51rYxX04PgeLBgE+jERRvwPfblNSkX1OjiDj6
 WE6GqcpGopKjvdbpSx+EJtJteeO/kGFSn0VShpLz6PIsYSppL1SLy5rYDeNCVTCDLpR03Mxn52k
 bOprjmXFTbaSbPtI02TAOWp0uxeQqMBbxnXtoCx6I8uHCEb1FKI2WKJEWvLy+pR2aTGWZ8WxQjl
 OVMu5N11bAXz5RLXn+Q==
X-Proofpoint-ORIG-GUID: 0GaPfNPqtG2dCGvG2rIJZ9GVJ_IQ0t2g
X-Proofpoint-GUID: 0GaPfNPqtG2dCGvG2rIJZ9GVJ_IQ0t2g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 spamscore=0 impostorscore=0 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604240079

Glymur has a True Random Number Generator, add the node with the correct
compatible set.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index f23cf81ddb77..64bbd5691229 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -3675,6 +3675,11 @@ pcie3b_phy: phy@f10000 {
 			status = "disabled";
 		};
 
+		rng: rng@10c3000 {
+			compatible = "qcom,glymur-trng", "qcom,trng";
+			reg = <0x0 0x010c3000 0x0 0x1000>;
+		};
+
 		tcsr_mutex: hwlock@1f40000 {
 			compatible = "qcom,tcsr-mutex";
 			reg = <0x0 0x01f40000 0x0 0x20000>;

-- 
2.34.1

