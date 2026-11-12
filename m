Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794523174;
	b=OU+V0S2ulFRYQ9PZ6586RAuKq/3LfMXv8yk9aUBEp44XKAQ2+bqC6MZrEP/U04iRtMj3
	 44+Ufruaw/tVQQg80mmx7FqnI6dV6OMvglpYWr8EfI4oKzDiHcJfBJO6vu6uoM4V7GjYv
	 AO4RSNZtFtJ8UzTNSLwwuxealLPpfdZuU/3IrS7gg65Ii1kmGunnBc8HSJr2sNuo/SOA9
	 nWl9ViFRRrdqfzBbcX+xI7aEYmDmhdacqFTi4fjWtpvgpCZ69Q3QKM1cZlh7jWgRfkyWa
	 BO9OhWkFl0v79tb+uIkroXkouXkkDcBS1mPzjm/Q2/9efWlpCglukIGt4h5Ko3FnLsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794523174;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=yc/mt44iiI3JDnoTa+amNxghgBGpPCt5eP48vxd/muE=;
	b=0wAYDmpL+UYZoAI+aBQuDrIPPb7oLce8cfoF3SmtwlExomBWc2l0bhOI96w/4si2sgDZ
	 lHXz4WPE5n7yhfp8JBERtUBBaY1N3yMiS0UkD9casjXoT6SqqQrqe95EQJgXJAsGvDKrH
	 /k3KXvHsDMR5yaDFh308cV0+2C9sYuJ7NVbnjxZLooiF8pIXs/FX5Cn1Z6ILv5UMdy6kK
	 zheg349G2VTzN2xgMb8mcRWDXGPllnldS0bc4qCCeSsnYYkFzhjlz93Frve30WkgoeJwX
	 zB8We+NLaf2zFfJhkteFaB9B7a5D0HhCRHc5MGXeHak8GK2DFu/TpjD+WX33ugYPXkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=dmOBb8rJ;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="T/HlP/+a";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8249B606A8A8
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 22:39:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8249B606A8A8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=dmOBb8rJ;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=T/HlP/+a
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ACJZW7p2266564
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 22:39:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yc/mt44iiI3JDnoTa+amNxghgBGpPCt5eP48vxd/muE=; b=dmOBb8rJ9DJUSOlN
	31Fzm000FnyJBj+8QH/DajyZ69iDI04r1LceMymteo4RXucWdvGNTTGt6OAeOnU5
	xbfGLc/WQvzimbrDkwOhWfhf9eMedTZb3eGzgYse0EwgmtqgTYG4ONV46Dwt6DB6
	Uuxui7UGB3YIaQt+2YIEpamngOD8oRw+r7aXK3mYHDarFLSYkKX+kWFpTFR0U1p1
	UByb1YQw3yh/H7r6RX+N0vkofYtgihVgHYGjRyv+OKhEuUZ43evtgFnOgetS32Kt
	7nhEq8sZN+lgxKLIpX2CKj8dLct55F+8dQFiWnmkvStwh5k8RzzMHEU2Jlqa+itd
	63uHSA==
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hw7nc3jn0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 22:39:33 +0000 (GMT)
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-1a5005fd0f8so748696c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 14:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794523173; x=1795127973; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yc/mt44iiI3JDnoTa+amNxghgBGpPCt5eP48vxd/muE=;
        b=T/HlP/+ahzjBAHcmMwdp40+2HfWnVY6Wf5oa2Ecpg5OCTvBNoq2Wp/ppBQ+Cmfu8fy
         +UwoNevhqUJ/oiSUhVKINxiFItj5uEPOdpDckgTROpoPzRmxUeezZ2jm9xZOIbecp69d
         xOF8EcAZSdYcegY7k8M5v4U9ngtTxQAPe/MckIjHWHjdW8PjcyrmcNe1l/C8fWGpYw5U
         X7FLRl70rIWK9RaF7Ep8v340ghgNTEoZl+W+yz7TFljxGNwhJ6S85qprmmxPxvvJTAGY
         FFwfb3bzCTgt67nbOheXvh2OXkS0mjjfAfBL6R2GlOxetv/7uC6cftpjihqmPZwW3lgQ
         QcIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794523173; x=1795127973;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yc/mt44iiI3JDnoTa+amNxghgBGpPCt5eP48vxd/muE=;
        b=r276vCtQfBuI8RclSXxWFuF3s9YExpCWJQGyA7hbA+9UO+tKLrixDc8pzpkmgw+Rmr
         bNK9JwS2mpNx6f5QYYdd4Hwx5c7GZfhWo75rm8wVaaysygq++wI4HHhCPoanS4WetOBe
         dsrE6radQ/ARsl/iPQ09dH9htKBrWdGJVElEJ9BMoVZwsS9jJbbwX6UzVhJivjc93VTI
         EbQrLNWLaKkUalJxIyqRCX8GR/DGWwgPsdxi/mt0mb6pZ9ymFGIN4OqYo+6/bVGGDasn
         SzmBPt1fmetiaNSRg+bIDZ4LWJPvqO5W2NnoV/a8jwBnxdqcRbrN0g0qz2tnHTgcxOoq
         SfLg==
X-Forwarded-Encrypted: i=1; AL+hErGGHywGYoVLtAmKaGKAG+8LwN/42xtqwjgeNWv4ImLXQqXD1qd6O0A4tpYojTOK6eJEDhmNjCwfHoQsCjo=@vger.kernel.org
X-Gm-Message-State: APuU4Z/7K/2UGLelN0JCtOTaC08IQIRZrJhwb0cQmbfYL4tkLiNUnW4a
	6ywTae9E5p0XWg3mGe750HJ94X+d2Hf6I2FW1e1+1TQke1rXBpedMgiMwyg4aYTtLesb9je4VZN
	nuoaJdAZRypqJ6cro5skxCggf56jV0tlNigtVKcDZcBwck+CBbGtJgGjx3vnNdAG7xgU=
X-Gm-Gg: AYBFou0IMgNiANkmYRDJzy6zCA+xZeYzkUaSgFBGzF9SYPcjfxM6wJNousEDaAulTJb
	Y4jO2TZux0uvrcQFmQJX0oZu8GQHAAiZLaFHBxj72AhUaYwSb1OY3DweImm+OKEavi6MYv7J+/4
	uiXlwpHMCMu+Apf2JKwwS+ADKiCFhLjvEfgerBJ1D7M9L4iDB5sxK/y5OyboV3aJCcSZ9wSxNgH
	GZyxdLnTqJuRtv4r1R4ewqyTUG3aJ855RYr7paplujefqnNOqD29wGVCqrA1f33AZ/Rcnzm/GbV
	+kgdvP6mTEBHBL0clQOTzrmJqWiFdMlI5sYUbH7h7N/7b8KxSnnMkXKmMC4g06oBG5JJoCOIKYd
	qjpqQqat5i+c1WtM7i2Z2K1MAgUNetHFa5IUxFBi77k430+7ENivbVbgpYzVQXcbSQiXcWytGs3
	aiso/a8yQbqw==
X-Received: by 2002:a05:7023:904:b0:195:c6c2:c6b with SMTP id a92af1059eb24-1b50319ce0bmr844401c88.35.1794523173076;
        Thu, 12 Nov 2026 14:39:33 -0800 (PST)
X-Received: by 2002:a05:7023:904:b0:195:c6c2:c6b with SMTP id a92af1059eb24-1b50319ce0bmr844351c88.35.1794523171031;
        Thu, 12 Nov 2026 14:39:31 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031468b7sm2333496c88.5.2026.11.12.14.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 14:39:30 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Fri, 13 Nov 2026 04:08:29 +0530
Subject: [PATCH v13 3/6] mmc: sdhci-msm: Set ICE clk to TURBO at sdhci ICE
 init
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-enable-ice-clock-scaling-v13-3-258dc817bd63@oss.qualcomm.com>
References: <20261113-enable-ice-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com>
In-Reply-To: <20261113-enable-ice-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com>
To: Abel Vesa <abelvesa@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-ORIG-GUID: zzyKH5QVOvY3cpNbcjUOUirImKHVg_Cc
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA5MCBTYWx0ZWRfXw4BqeRUATnJ6
 Y2hTZltFFtvwQkzdtArcUVAj56975f/J4jdk4W269Eg/IqK67sIQbkoTLUqh4PNxF9XVzHrF8Vp
 AjTmSiT76sNxk1puncgG8V+ASAzdbn4=
X-Proofpoint-GUID: zzyKH5QVOvY3cpNbcjUOUirImKHVg_Cc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA5MCBTYWx0ZWRfX99So99GuhOFj
 rVX3ITIirb8UleQ6Zr3dPa0A+ziTHeYUqxQb3l+C4mGQIgfG+8iYL0QV4E9d3VoeVuJDimX22V5
 tcQFpRGX7HBxfUtHpE2jEPhs+hDe9HxqQqYpSs5eW73fVqU9FAB/u+lNRl2Fnyah6a7QLip9IQE
 EJZ2Se7jWfGUv4DpZIdU1/mrX+gptameEpt+36j1j5WaZSCJIu59M1bsjHEr/yxT6c0YQLzLk8Q
 5SpCq9PX9RtR3vEZq6ewFi21NPHGBMa7yakVH07gesUf4jaMS9E4nyq8592EfpadVDd/E3Razv/
 94iBYLsR+VgoW9L8qPQSZba7r9YuoJYd39c5kUQ620385FD6qxWeFb4K3ehESO7X3gcpDvEbQ8V
 GIzLrObbjCKd1hbbvR/F6/5r5YLlbtB1KZTjMZl3WIAhe/Mo2t0AIWEglpBqncwhqz4p50WZj5A
 wUQzXHRdunJ00djarMQ==
X-Authority-Analysis: v=2.4 cv=A8b5rKWG c=1 sm=1 tr=0 ts=6af64025 cx=c_pps
 a=kVLUcbK0zfr7ocalXnG1qA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=QyXUC8HyAAAA:8 a=PzEurhthzZq-M9kHIYIA:9 a=QEXdDO2ut3YA:10
 a=vr4QvYf-bLy2KjpDp97w:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_03,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 spamscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120090

MMC controller lacks a clock scaling mechanism, unlike the UFS
controller. By default, the MMC controller is set to TURBO mode
during probe, but the ICE clock remains at XO frequency,
leading to read/write performance degradation on eMMC.

To address this, set the ICE clock to TURBO during sdhci_msm_ice_init
to align it with the controller clock. This ensures consistent
performance and avoids mismatches between the controller
and ICE clock frequencies.

For platforms where ICE is represented as a separate device,
use the OPP framework to vote for TURBO mode, maintaining
proper voltage and power domain constraints.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/mmc/host/sdhci-msm.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 32b1bcba47d6b75578f01d8de6ee9beea3b1e080..652c5cfc87bcc3c59b845b9e2fd785bcba197fa0 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1902,6 +1902,16 @@ static void sdhci_msm_set_clock(struct sdhci_host *host, unsigned int clock)
 
 static const struct blk_crypto_ll_ops sdhci_msm_crypto_ops; /* forward decl */
 
+static int sdhci_msm_ice_scale_clk(struct sdhci_msm_host *msm_host,
+				   unsigned long target_freq,
+				   bool round_ceil)
+{
+	if (msm_host->mmc->caps2 & MMC_CAP2_CRYPTO)
+		return qcom_ice_scale_clk(msm_host->ice, target_freq, round_ceil);
+
+	return 0;
+}
+
 static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 			      struct cqhci_host *cq_host)
 {
@@ -1960,6 +1970,11 @@ static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 
 	mmc->caps2 |= MMC_CAP2_CRYPTO;
 	mmc->caps2 |= MMC_CAP2_CRYPTO_NO_REPROG;
+
+	err = sdhci_msm_ice_scale_clk(msm_host, ULONG_MAX, false);
+	if (err && err != -EOPNOTSUPP)
+		dev_warn(dev, "Unable to boost ICE clock to TURBO\n");
+
 	return 0;
 }
 
@@ -2160,6 +2175,13 @@ sdhci_msm_ice_suspend(struct sdhci_msm_host *msm_host)
 static inline void sdhci_msm_ice_restore(struct sdhci_host *host)
 {
 }
+
+static inline int
+sdhci_msm_ice_scale_clk(struct sdhci_msm_host *msm_host, unsigned long target_freq,
+			bool round_ceil)
+{
+	return 0;
+}
 #endif /* !CONFIG_MMC_CRYPTO */
 
 /*****************************************************************************\

-- 
2.34.1

