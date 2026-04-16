Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3445F3B6BEE
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776340845; cv=none; b=DQRzGGZC6z/eUZF5dsXqXxiEirkb2uypQspzumoyHC116eXqN2Ol0ZkeH9sGbYRJj4gkbF00Y+VHfUO60eRqAJ5JY5mMd1jhed+Psh+cHemfhVcaQN8n6CmwcBq8FaRfJjdN9OgI4faSu4yxxllq8LJVOMsqigI8msjHUoknnc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776340845; c=relaxed/simple;
	bh=LEbiblCKcyL2p/bVLgNgGMJciZnwnEoCuE0intdil4Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GSoyp8S9L6DQJrF0aUKaYQ3uWX6rSH1tJowpAFO4MQUiSrk5k2oUOJBExvwoJc13MDSwxKpvdfcPYJpK+ujVqAUNjLSQ4sKrJrNJZeJjjFeJaBO+qMEB6vgZu3dATnqJYSHd28TOnC8nvaxRKLBb7YDc0TjLnnstR37RIcOm5dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=i/BzPB16; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kfkeJX6S; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="i/BzPB16";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kfkeJX6S"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63GAXqZj1245083
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:00:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	86A3Mpzo70ON5GHVzRh2OgwDHBFC164e1PdRbOxYstE=; b=i/BzPB167eoItYdU
	9OoC66BGxpkflwVC2uvnkrsOoVDRXiZdEytwbPwbRadYLEiWCoFmWjM0V695gknW
	XklNgvRRubAxzmP6p4nkhWH8nZyS75Nj5M6wfchtsI/d1eGxTezGSoXys/fpXHjl
	GKf78gravvqSzS+s2jDu4Sb3u3PNZWh9jIz+RoKjDEl09zXnZEqvFHWFr/DmsvQD
	Z9BLLhc/3z6RGXEwTBElkjS0w5RWijrB76E01lmctzbIEvyOb1jTU0rdud4ROfiG
	rh7tG0Fg5/w/+FhG9Vwx7pm7lYBMrPhO9IJMUIrBWxhxHiyRg4VODqHs3xHl6NtJ
	ytSyMw==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4djx4k87xg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 12:00:42 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-82f220f1dabso3200599b3a.1
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 05:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776340842; x=1776945642; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=86A3Mpzo70ON5GHVzRh2OgwDHBFC164e1PdRbOxYstE=;
        b=kfkeJX6SrvdHwwoXdsyFkLUlNVOUVN9H5DOjrCUFjnPW0rSxFLh36xfxVpeLx+D2PA
         ftO+OgmIfADEQYbmeUX/BsjWRYfGcMuyq41HsFyHD4sDKIQ1clOBvz27WvjHuOybU8OX
         6JyklAJIjItnDCK2NA04pdlfw2gqV/S8v8IhpwSxYgH28vrm0j6L+ZMGXFRXCL9jus/H
         WvyfoMETYZ/Kq79cEGi1reZ67WtCWr6O6EDB7ZTSlvsv1JBtA9zNRPbfzMmzTC8HMSCz
         +eOx1jc6zyxkRdUTmG9z3t1QJegOY+KlD2fhCoJ9UeWLmtPqynGSQwywjUeNIg+9jAdC
         lsmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776340842; x=1776945642;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=86A3Mpzo70ON5GHVzRh2OgwDHBFC164e1PdRbOxYstE=;
        b=gkkYwgNsuh0ublsQqg8duidbbNMRV5EiH131/Seujruh1eLcfqMbSVjieWj+ryws7K
         eMKHhIEhQPSEAXY6KdKXpGckmrX7g0xzUKT8/DbuXrAbcHToXl95/VoG1MMIwIiNY+Y2
         +Er7Iuj6FE7D9RMgqEd6+9aghShxKUNLwuB6c06w7hLZTePFL8raSTKWUguqIdhm5Q6D
         CV4Ktuo+GnDdLohecW1AM826OHazT44LWWoNLvJUz7uZqfFr2TbXTovFw5fzqv2PE0rd
         z0Ex8Q1k/z13YXMRskU8xMpzE66QlOe3LpL3/j4Q917xFyC9rBB/GwIaTJuWB2wFtYjM
         d4sg==
X-Forwarded-Encrypted: i=1; AFNElJ9RS13AxY6D3vGAJnQCV8y7eagsvHrS7BZCv0KgAx9Sc1d3Ep/JIvVeK2Qlj6mg8B+fZ/MU3qe0GwDKwGo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyhxi1Gp5pubk9T6fyHKMe7EridmUQuPZJUkmIRXqjroD33312U
	363BM6mcLz9b/5TXuWkXKX2W6SkPxUMcenHDC1BAeaQIo1AjVI4p/+zT6lVhZZQb3rWkbKV4WPI
	sJS1j8qcVTLOWIj/x8/8hFXkZ/4PMyZCo1UC2rIUXsZulwkR6ukUADUUbPtwRMfTP13A=
X-Gm-Gg: AeBDievHzH/OgdE3pEX+v+wptlXRfIOKuVjoblsiAgTQzyYEi0TsGP+rMKamxHhJcon
	gnpj9Zi+nKaHP/W0vBjQb9eKKmKmBP/NRQtY4GIVGYFmuN86Uh2byGLs8QP+n33cYmVri2SqsoH
	FRNDGaETu6HH1uW+iWniWER5Rirtiff6NxmP90iRX2c64QpQ28V00HMAwAr9TjPJdt/uIVc49/P
	VzTV79bIOo649fWE8xLP25jhGLotSBhWfDCgWla8TapLzBVWNmtWSmzQXs56pR+T+4xD+z490P2
	O9kk4b++yKeUq5ozERhnJT/qf6cIj/jmi9Ka4mhgLDoBEEEa9zdUPA5txIDbL9Pf6KkLavAyBVH
	yFqMJEVNASKQjlDDxrSqP56P4es8UzMTgD81lZZ6H0ksQoDO+piSlXdu53g==
X-Received: by 2002:a05:6a00:2190:b0:82a:1529:2b4f with SMTP id d2e1a72fcca58-82f0c3256e2mr25219162b3a.44.1776340841916;
        Thu, 16 Apr 2026 05:00:41 -0700 (PDT)
X-Received: by 2002:a05:6a00:2190:b0:82a:1529:2b4f with SMTP id d2e1a72fcca58-82f0c3256e2mr25218961b3a.44.1776340840181;
        Thu, 16 Apr 2026 05:00:40 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f673e0f15sm6335937b3a.35.2026.04.16.05.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 05:00:39 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Thu, 16 Apr 2026 17:29:23 +0530
Subject: [PATCH v5 06/13] arm64: dts: qcom: sc7180: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260416-qcom_ice_power_and_clk_vote-v5-6-5ccf5d7e2846@oss.qualcomm.com>
References: <20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com>
In-Reply-To: <20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org,
        Eric Biggers <ebiggers@google.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Tengfei Fan <tengfei.fan@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>,
        Alexander Koskovich <akoskovich@pm.me>,
        Abel Vesa <abelvesa@kernel.org>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776340775; l=1533;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=LEbiblCKcyL2p/bVLgNgGMJciZnwnEoCuE0intdil4Y=;
 b=0l5AV8MgWXyQHRAPJBcMxCawIilnbY7Jw1JjX7zKCnHnHb9BcISfQr55Jx094Ha34FtuH7hbB
 gNsHb725uU5BQ1/rJke8nrt1o3JL8W8fkfqg+kx7UO6zQIGyANEnVvO
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-GUID: 5S7t41Qfwx28UBuKTQZck5OANoyaKmaE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDExNCBTYWx0ZWRfX/ExSA1HpVy/t
 p1nDQtXrSgwGFDZXpqxcsinVCtYiXnlkEdf1n8Wl0Y3i9tGcOh0vW9MayzWGQkZcJsHGPVvs30d
 UMGQNp4JQycEiAxvBvck/Ya+2JO6nAQ48/Z3PByGBCjBG1RcWJPk2iAMjHp3D369frXwFud5Auv
 rFNyaKd0VqtuXVgJchPJWI5sEQtXZBSqTbWKhUS7JkqgB726OtrNMsdnXnl4Ir1LFZQgJg5Yv7i
 E8nnv+ZCp8Zae1AP8U09pxva4Qzc6PlpwS4WaRU26OwfX4m4xozYaO5WM3pp1a0i0QkVTBV0ZFX
 jgYZMmv8CmrVQic1rT6dE1DDG3XM8i1uQ93ilho+ZL1fYfKg8oihiLpeggYQUp4rfTMUDK7t1aS
 1z9X1vQQ15Fiziss7jm0SVyJqcVAXUwm6M7j+Q3Uh71QJ5Vq2WSjnWVsGCScIx5LVGykvRQQ+ou
 PfsDyqvJSO+cOJWtVgA==
X-Authority-Analysis: v=2.4 cv=H47rBeYi c=1 sm=1 tr=0 ts=69e0cf6a cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-ORIG-GUID: 5S7t41Qfwx28UBuKTQZck5OANoyaKmaE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 bulkscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604160114

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the UFS_PHY_GDSC power domain is enabled. Specify both the
UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sc7180.

Fixes: 858536d9dc946 ("arm64: dts: qcom: sc7180: Add UFS nodes")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index a4b17564469e..94a699cc2688 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -1605,7 +1605,11 @@ ice: crypto@1d90000 {
 			compatible = "qcom,sc7180-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d90000 0 0x8000>;
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "core",
+				      "iface";
+			power-domains = <&gcc UFS_PHY_GDSC>;
 		};
 
 		ipa: ipa@1e40000 {

-- 
2.34.1

