Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCF5363C5A
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773130068; cv=none; b=nB43m6Q1zGsyqVE6rr1M+POOSry7j1fA4q/BaUJQoYctVZdlHiIzkpc08xgemaFpEdUNeXuZbwIhIXWCu+q05FQB0NvWQWFuOH3UAdhaFPLAnxUBzyw53km+A478qcEqVVdVFDkNKOO+ZMX6g5s0BruLf16Og1M26CapsM+rB1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773130068; c=relaxed/simple;
	bh=niYQmVRxD31LW0CEVaaeCQmeMe417PyBECP1mGWfg5A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GdJd7t8YJmJ2cdKhzCsyd7q4NgnNqv7pCXj/r18ctEtfMfax1/S5zZaVGo1aUsktXKVg2oOeV5juF7GrHV4myV875bkuKSeiPDQL39zQ8IxCG2prQUoP4vAHAiN2jtAhNX2uCWb9MRh1Bto2qG/QKw1ze7bEy6THqvPAnkovYuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RfK9CWCL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Q+cxD4nn; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RfK9CWCL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Q+cxD4nn"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A2EQgk2363326
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qgHEgMJmGM3qOy994TlAjnMH+RNsJUgib0uSTkzmnyU=; b=RfK9CWCLQd00uMza
	GH2BLnhfJVCHFJQvPvlXKsRRIfG+pIi7sKJZCx8xz9hN3mzIhl0f7c6J/deHrQyR
	wmm4E20qINMsLNhLmQI40qgLkYAID0NbONDTSLFBpqI+xFNwaDN1lO6ZCSTriO/m
	TvF6qxgtn+MNuY9lsnylOrPcuC4Einz3dOHwOnThsaO29V/V2eRt8QZSp1xiAraR
	vxr1uV8vyqMpsgJolaRiw7cbEEw2ENbC0SMJ0R+oqn9wDPJNB4dK1hCITeiU2D+K
	92+OhkYDwp836nHjPHbEUDAgTQT2uxDgvgYeiLk8OjJgT25Gv1qeubzej0C8x1bZ
	bk2g/A==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ct032b74y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:07:45 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-35985522c1aso32728926a91.0
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 01:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773130065; x=1773734865; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qgHEgMJmGM3qOy994TlAjnMH+RNsJUgib0uSTkzmnyU=;
        b=Q+cxD4nnZQN9ikAW0gebwbo/ZafV0Zu4Lty2jQA7ANId5KkiqkgmY9OqULtOTbhGe8
         8K8NkAAn1CzL8R9FuKFFH2iINewHfRrqV4ou5Mv/RRxJs18iH2ff2zdsyw5z5uT3RICU
         VSYmb8E1UJpU6IAG2SeDwpDfC+EMZZbFYzBq98FsO5zHI/evveKu03vNn5X0DeS4b9LJ
         yq+7knBADw/o1wi+XqjGL+8E42Tht69yNTZY2sU/dDZcmpD6NHT4Esj5Rjk1Dw4QN4LO
         DWPNd/frkX23YQINEy9Ep/UPtqASjHoXiWiV+OwNWFAjbUnnzUfyncwpkmvPEdTAKXRJ
         Hepw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773130065; x=1773734865;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qgHEgMJmGM3qOy994TlAjnMH+RNsJUgib0uSTkzmnyU=;
        b=mAeOoc3zmh/2gvfcpvZZadq7cp2JVmBmj6DhjPw+vo8SGmCxlM8W2oVxB+VSCwlLjd
         plKgkdvfUTKVnGnBYxquMB1srtz3W6s+DeaHLxHkeambXuWpd/wp9CPLM3dIQ5xackkH
         VfJdWQ1js+ygN2Xs33POeWKwf0oCoFuXf7Zn5AMvGWSPPT4+nFVpWZbcBX3xv3Op5mzc
         L7lWIo3wgPGS9wROp054bfQkI5QUw3Z5pDJWGIythhCSy74CGUKqQ3nPl6yyyFcI/wYr
         2YNe4BsqqJrCcRkK/J3kVtmuDNBZxQLftEcqNkblGafSz7EYDWC/+yt7+yn454r+V3WR
         yGNw==
X-Forwarded-Encrypted: i=1; AJvYcCVf7FyeDAq67Spm8QjpQCBsJ9cQr/RAzKGX3EWOocD5sEDCTJ7SFhoWhxMR1ltVQkfRa43NrhVsEBOC0GI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCN9gD8luW419c1B1QHGLj9/rqUk/MGVk/kOPORjuWJqJikqnD
	GkBrbzGkYvKXz1i9aGZjF6x8eXm6nsdVRmA5c7y6UfIPC20pQccRaVAiqhi/QCCdO1MssAnJxrR
	P2Tn8novL34fN1vcHENQYVXq4o1cyg3i62QqHzu5q8CdRLbcKjgWlL5NNWKHfZ/c8k6M=
X-Gm-Gg: ATEYQzz3JmFusXcMgGvA5OTt8gPlQUpTb3nvSVFk1OpV6ID6ce/nRuAty0+8LG2lCrQ
	8KMi0JZaICWUWF2TmQO8HQ7hBsNRxvRLVLEVH2sHb/lTkpmc4CRwrIokiSByQV2YYZMO3MBVvZU
	eHgDvLLAJgQCuU3v6+qUomKXfUN/I9e1wTo9BCS0ke77uLNcix/Gz1Py2KJnh1pd5npSCTVpECF
	xcPPmJXEvbTcJLS+aLKXE3GwXKW4lr8faVwjUnMKECKRA9gFj3LdPK2auWKQj5BPGB8PGlcS2MR
	VGrplzrOtXVoyeVB4VnQQIZYTMd91M/edbVhXMRLKD5hEBmZ7NkffoCoNW2R6Vp3mNEn7AHicCb
	wQB7VVfUyGu2kBV1UOPQMyUEIcbWEE2BdimScPHyzrV0Blyw=
X-Received: by 2002:a05:6a20:3d8b:b0:398:95b7:c409 with SMTP id adf61e73a8af0-39895b80d85mr6432098637.25.1773130064813;
        Tue, 10 Mar 2026 01:07:44 -0700 (PDT)
X-Received: by 2002:a05:6a20:3d8b:b0:398:95b7:c409 with SMTP id adf61e73a8af0-39895b80d85mr6432061637.25.1773130064307;
        Tue, 10 Mar 2026 01:07:44 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e195c40sm11121969a12.31.2026.03.10.01.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 01:07:43 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 13:36:33 +0530
Subject: [PATCH v2 07/11] arm64: dts: qcom: sm8450: Add power-domain and
 iface clk for ice node
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-qcom_ice_power_and_clk_vote-v2-7-b9c2a5471d9e@oss.qualcomm.com>
References: <20260310-qcom_ice_power_and_clk_vote-v2-0-b9c2a5471d9e@oss.qualcomm.com>
In-Reply-To: <20260310-qcom_ice_power_and_clk_vote-v2-0-b9c2a5471d9e@oss.qualcomm.com>
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
        Yuvaraj Ranganathan <quic_yrangana@quicinc.com>,
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773129997; l=1458;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=niYQmVRxD31LW0CEVaaeCQmeMe417PyBECP1mGWfg5A=;
 b=HsW15hOyG7U3r2z0bpBA9Wgpjw/nsnnipS8qpEkjX95X4JsCfBS+FE4EuL6iI6mlJ+nc4ggkD
 2PrqP41BfDGDYBmancOzP/RZoRS+/cgdJcba0aCDvUhDHPSVLx8F0jw
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA2OCBTYWx0ZWRfX18UNrDbfu1Vf
 w7v+VXJ/Wli3LE89s+VDTe7g+bbZqqhT8eGsKEYoddOlqKDGmWcPNYXx1//WW0Dl/1ynH14CMGO
 tp9wVE7z5oevvdFamQQ1NVpUHnMduicAVfyLgIinxLOM8EkI3nqLsCL3b+Bwvd3ecejx7pcTHke
 YXQ9wJrq2VHwJA/xecINbWDCyCMR4WXhrgbG23wU9NcKnxIRa+pp6/QEZgrZThUxC2+lKiY87sg
 9ZRNCfCGzt2jKm8PrCklJWdsR9YFYXtS8Fd40njW5UxMesAv09Wwi1NjBsorAs++4EQYutbieTH
 QGG43ZTFeItFUGkN319ndt9JYJ6bDDpTGSNUPbvVWpICxehgA8eFG7ebUvfBF+dj4nRENYQMcYC
 k7sEkyBN1s94+zxQDhFkDJ11COLclmOEVBC9WB1H853lSxj7SvHWf/fSM5jiAPgAdo7xGMC4DCV
 psSzdX1lwJrECxaEfHw==
X-Proofpoint-ORIG-GUID: mFEA7jr511odr2VScZelio09u4HabVXb
X-Proofpoint-GUID: mFEA7jr511odr2VScZelio09u4HabVXb
X-Authority-Analysis: v=2.4 cv=WtEm8Nfv c=1 sm=1 tr=0 ts=69afd151 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=IPGZAGG64n0kybUxs1kA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 spamscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100068

Qualcomm in-line crypto engine (ICE) platform driver specifies and votes
for its own resources. Before accessing ICE hardware during probe, to
avoid potential unclocked register access issues (when clk_ignore_unused
is not passed on the kernel command line), in addition to the 'core' clock
the 'iface' clock should also be turned on by the driver. This can only be
done if the UFS_PHY_GDSC power domain is enabled. Specify both the
UFS_PHY_GDSC power domain and the 'iface' clock in the ICE node for sm8450.

Fixes: 86b0aef435851 ("arm64: dts: qcom: sm8450: Use standalone ICE node for UFS")
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 920a2d1c04d0..3d243e757fa1 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -5374,7 +5374,11 @@ ice: crypto@1d88000 {
 			compatible = "qcom,sm8450-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
 			reg = <0 0x01d88000 0 0x8000>;
-			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>;
+			clock-names = "ice_core_clk",
+				      "iface_clk";
+			power-domains = <&gcc UFS_PHY_GDSC>;
 		};
 
 		cryptobam: dma-controller@1dc4000 {

-- 
2.34.1

