Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1EA3563C2
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 10:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772448576; cv=none; b=ROB8hyWWCqZ1q5IdmGdE5cyxNjoWSYL72trUph19tu0XguVP8OlcvO6B4Kq4sTATrXO/muTfJS2sjoEh0seED403GuzXo1n5CotYP5QtiKvzIPM0OFVSfRy5GlsZrltHHy224uxFCuYUJMxI1uBA7tqYNCX1GXLV11FXui40Wy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772448576; c=relaxed/simple;
	bh=c/MjGLzehNhtSesMBugSqhDY6Jq3MzPaWtpVEw841y0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=kjnEQWQZtqXT8+e8nont4erOCNNVOKN61/BDndhrK/IipcPTVnJxN5eFCe1UY/i2RHseSr8KmIUC25gHWu3aD0u4C0amJU3BfzGrCyx2HA+MDrB72DNNnJadtfIQpkLZiZd2gdRg0M9J4K7zetZGYGNVYfOCZ2vhEsfgd8LrDB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VgOA84RN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fHwZCHO8; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VgOA84RN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fHwZCHO8"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6226hGPK2504783
	for <linux-crypto@vger.kernel.org>; Mon, 2 Mar 2026 10:49:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=gQxp8A8SSwIiq0ExgUsWhZ
	eSvDCdzUJskQ/r3mYDhHs=; b=VgOA84RNd4EosX8qFEvuHbyg9jXfZf6aSeeaX8
	OAKUGX1J4WNHpNjSfahucm8+y/mm7n8fSmKTCJtpxsDYbFlUd+AGRsyF/UjRMRSg
	XusIqmfFGycZPWMwMd/AC3O640wkt54PHfxIvlCqHrW3p2jenHgrZLA7EZRmEKcY
	IU1lyz9nSdXpaSruQywAhbipQ3c8EryEzOFI7/30925Qxol+VIzGbyL8ZYBhLnpX
	05+Cw3to3RiamEDEQ43XhYbVODBC6zBs50OiyOfdHNjuxE7hHI+YEfd+Wb5YxBab
	sH2OTQAiBTcR9wJclsqOWaD/ksepIRtIVjzxA6MMWWqW8SEg==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cn5herw40-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 10:49:34 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8273855525aso3713082b3a.0
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 02:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772448574; x=1773053374; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gQxp8A8SSwIiq0ExgUsWhZeSvDCdzUJskQ/r3mYDhHs=;
        b=fHwZCHO80hhKshX/SIThzageGh4iKcAUsERGK0cxM79CHUfSi48u7iMbm5aWtFrkq4
         vTZJSg4bQh5ERgkN/Nq1YgIJ3IE473DHgsD/hFeE4tnAyk05M/7D+/oThyhPK0Lz0iC9
         AD46zElOyA8Kvir0GvYdlZu9vKAwTQHmzZ+YDOqZesQFLM6/FA1rvvkvNw2YdRMK8Qih
         lBDUzZcpoZl7rlNufcyzOVyH4eLxoPcZ/VORA30Xaxg8q5DjolsS2yqUL86rP1bm0yqS
         2yxyLL25SmLOfsyKaslr55mVtEz3Zms39hhzbBPggkhpu4LFL48e3R350wZx8rlz2dwy
         UL+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772448574; x=1773053374;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gQxp8A8SSwIiq0ExgUsWhZeSvDCdzUJskQ/r3mYDhHs=;
        b=jpyfGj1f7sQtBF0lV66BAfYX1ZKwmREavGAzbe257mYsKBQ5jt4b5n0+VjI5xtHv9S
         yGotNFR7BpIP2TAAkDmsenUd+4IMAs6Q1l8D4fHUPfKMh9/IoIspxk9FBEDCD6MpP2WT
         VX0vnRcnKzgYQNlkRJ6u1EYJJCFSvXf67GurnWSPhWvOhj+73PtY/cJwyt3WeTxw4ulj
         i51v9RY1xOkSNCuNKxYfQEhcS9IHOM6WSeCpL5XkhHD3Clbqkvxtxd4OLS8qHSR9bozR
         fcNd1VzO3PCGiYg/E+Se5AC12KE5gJIDhE8qPuwGKSd6zWC07i8MHUP45hpFj/pO1U2V
         LUEA==
X-Forwarded-Encrypted: i=1; AJvYcCWNljOjS6KADN3qeCEgELJ/QEkCRVBs1OT/cdaxLzFfpQlKjSlj/FGqNKQGP3sfG6XDRzENg4XHRRbUBr0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyL3AniIlMPuwL2SR2w1iYv2MoHBHKMKmrpju+DKvOW7gOgS0PS
	sAMj0hrTp7YPSax2ORtfRoMKP/W78jVFrns6TMaRZsG+iqvTEdLH1aOqa6GYtqhx58ZpDxOEmZq
	yhPeYEUQA8Dxlwpk4CL21Jmkei4zVR/YTCv1xQ2SHOnkRz3uWsyc8Co7+4BvTDnoxHP8=
X-Gm-Gg: ATEYQzwRh1xziy5o2JRACc71pa9R41kEZXrqS3+aYjT/syDnmyRoEh4FzHptV+C0Ecp
	D++Ky9zQw3NN2vcQmtBcKtXNNI8wSuooLti/BDrxcGHxU9VCQxafIQk1QE3cd8c+9AHJYMqqj7V
	cNus0fGFL8u5ohSgPNK63zkPNsMlX7908+ubBfF2O07gELek2UOLYgb0cTqZ8J/KEJexz8hgdIZ
	VPg6AqtS+2/oe/21H6ICPZU0HevplyQqH/GR71PiJI8npRIcVsayQUW7Qp/Nql4fCWMHzhowk6H
	nFyJVOHIH2dZxnaLH/F9qheJBoZGuYGUdpC4tCEHVaC4jvvF4TVxUSclpp4FkvDGgPJhpdNDClB
	3hFGgR41Vp19Q6GzRkXIGrqZRfSVcNgHLiZ9Ob0OwmJd9p/3WX2fpbO5UmJA=
X-Received: by 2002:a05:6a00:2e24:b0:823:5745:cfd8 with SMTP id d2e1a72fcca58-8274dbf36f4mr11656351b3a.32.1772448573999;
        Mon, 02 Mar 2026 02:49:33 -0800 (PST)
X-Received: by 2002:a05:6a00:2e24:b0:823:5745:cfd8 with SMTP id d2e1a72fcca58-8274dbf36f4mr11656316b3a.32.1772448573468;
        Mon, 02 Mar 2026 02:49:33 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8273a054b49sm12225956b3a.53.2026.03.02.02.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 02:49:33 -0800 (PST)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Subject: [PATCH v7 0/3] Enable ICE clock scaling
Date: Mon, 02 Mar 2026 16:19:12 +0530
Message-Id: <20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAChrpWkC/4XQz04DIRAG8FdpOEvD8K/Qk+9hPMAwtMTtri52o
 2n23aU1ph5c90LyEfKbb7iwSmOhyvabCxtpKrUMfQu7hw3DY+gPxEtqmUkhDYAUnPoQO+LnXHl
 B4tgN+MIrhq70Bx6FVRiyIps9a8TrSLl83Pin55aPpb4P4+dt2gTX229YCPgfnoC30eiNBSui9
 fZxqHX7dg4dDqfTth3s6k/yboJcM2UzrcW4k947oWHBVD+mFSDViqmamURyRskQk3cLpv5tuhV
 TN/P6UAO5jLS0u7mZijC6JBy3GiPXmYBHiolDa5TQBGdDXgDsvZQEv1LKtlICjdTtp3dJmz/Me
 Z6/AC0PwzlgAgAA
X-Change-ID: 20251120-enable-ufs-ice-clock-scaling-b063caf3e6f9
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Authority-Analysis: v=2.4 cv=BI++bVQG c=1 sm=1 tr=0 ts=69a56b3e cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=FNyBlpCuAAAA:8 a=EUspDBNiAAAA:8 a=-lrO7XeYbFCEYaIRUPEA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=zc0IvFSfCIW2DFIPzwfm:22
 a=RlW-AWeGUCXs_Nkyno-6:22
X-Proofpoint-GUID: L8xNYX0YKSFyC4Tu31eKoo7TeeaC8eyA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA4OSBTYWx0ZWRfXyKhJ+Pqxl0Bv
 8CxuGruEGGfo4kmvQi3kA2nEXXSKMy10yocjmoiSycssWMo36sM6Z1Sb8c9oPiyQosZRK7CF+8x
 VvePqlB3M7Zhgd4xeDIHVDJ0g593Fuk/LRCbggXP2B+PrQpo8fwRTX8FdEGOZgY5nCi86ADbffQ
 y5ucFVS5M9WcnxxE3xIT/CyIgZgjdtclmG2WRepNCEmSrkp8OsgTYa4hCPlZbrhToWxWE9GBfKh
 RoJIQeu3BsQugc7fAFhwISlYmuIpCFjI6oyIhjdj6fVWnUZa3B5sSYjkNLP87giFuqL3nTHwbE3
 2ZJFKoPjbG/eyXzxvcOpWPFXGsq7MkFtwKB3sSsf2gVAw7rMr89b4x/IBkzCLL3m9CeWmAZaDDh
 lNrt26lIwDbz4lzsZaFRO4+tjzPb8PEwIZc/8yMhgRZkEyROrQQAqxeqfTA6g73aF7sPwjOxAGw
 PfnPQbpWVwgtC+sZcEQ==
X-Proofpoint-ORIG-GUID: L8xNYX0YKSFyC4Tu31eKoo7TeeaC8eyA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0 phishscore=0
 spamscore=0 adultscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020089

Introduce support for dynamic clock scaling of the ICE (Inline Crypto Engine)
using the OPP framework. During ICE device probe, the driver now attempts to
parse an optional OPP table from the ICE-specific device tree node for
DVFS-aware operations. API qcom_ice_scale_clk is exposed by ICE driver
and is invoked by UFS host controller driver in response to clock scaling
requests, ensuring coordination between ICE and host controller.

For MMC controllers that do not support clock scaling, the ICE clock frequency
is kept aligned with the MMC controller’s clock rate (TURBO) to ensure
consistent operation.

Dynamic clock scaling based on OPP tables enables better power-performance
trade-offs. By adjusting ICE clock frequencies according to workload and power
constraints, the system can achieve higher throughput when needed and
reduce power consumption during idle or low-load conditions.

The OPP table remains optional, absence of the table will not cause
probe failure. However, in the absence of an OPP table, ICE clocks will
remain at their default rates, which may limit performance under
high-load scenarios or prevent performance optimizations during idle periods.

Merge Order and Dependencies
============================

Patch 1/4 (dt-bindings) from the previous series
(https://lore.kernel.org/all/aaKt9PET6lVkBcif@gondor.apana.org.au/) has already
been applied. This v7 series therefore includes only the ICE driver and
UFS driver changes (previously patches 2–4).

Patch 1 is the change which should be merged first.

Patch 2 is dependent on patch 1 for the qcom_ice_scale_clk API to be available.
Patch 3 is dependent on patch 1 for opp-table parsing to be enabled in the
ICE driver.

Patch 2 and patch 3 are *not* dependent on each other. Once patch 1 is
merged, patch (2,3) can be applied independently by their respective
maintainers.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
Changes in v7:
- Replace the custom rounding flags with 'bool round_ceil' as suggested.
- Update the dev_info log-line.
- Dropped dt-bindings patch (already applied by in previous patchseries).
- Add merge order and dependencies as suggested.
- Link to v6: https://lore.kernel.org/r/20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com

Changes in v6:
- Remove scale_up parameter from qcom_ice_scale_clk API.
- Remove having max_freq and min_freq as the checks for overclocking and underclocking is no-longer needed.
- UFS driver passes rounding flags depending on scale_up value.
- Ensure UFS driver does not fail devfreq requests if ICE OPP is not supported.
- Link to v5: https://lore.kernel.org/r/3ecb8d08-64cb-4fe1-bebd-1532dc5a86af@oss.qualcomm.com

Changes in v5:
- Update operating-points-v2 property in dtbindings as suggested.
- Fix comment styles.
- Add argument in qcom_ice_create to distinguish between legacy bindings and newer bindings.
- Ensure to drop votes in suspend and enable the last vote in resume.
- Link to v4: https://lore.kernel.org/r/20260128-enable-ufs-ice-clock-scaling-v4-0-260141e8fce6@oss.qualcomm.com

Changes in v4:
- Enable multiple frequency scaling based OPP-entries as suggested in v3 patchset.
- Include bindings change: https://lore.kernel.org/all/20260123-add-operating-points-v2-property-for-qcom-ice-bindings-v1-1-2155f7aacc28@oss.qualcomm.com/.
- Link to v3: https://lore.kernel.org/r/20260123-enable-ufs-ice-clock-scaling-v3-0-d0d8532abd98@oss.qualcomm.com

Changes in v3:
- Avoid clock scaling in case of legacy bindings as suggested.
- Use of_device_is_compatible to distinguish between legacy and non-legacy bindings.
- Link to v2: https://lore.kernel.org/r/20251121-enable-ufs-ice-clock-scaling-v2-0-66cb72998041@oss.qualcomm.com

Changes in v2:
- Use OPP-table instead of freq-table-hz for clock scaling.
- Enable clock scaling for legacy targets as well, by fetching frequencies from storage opp-table.
- Introduce has_opp variable in qcom_ice structure to keep track, if ICE instance has dedicated OPP-table registered.
- Combined the changes for patch-series <20251001-set-ice-clock-to-turbo-v1-1-7b802cf61dda@oss.qualcomm.com> as suggested.
- Link to v1: https://lore.kernel.org/r/20251001-enable-ufs-ice-clock-scaling-v1-0-ec956160b696@oss.qualcomm.com

---
Abhinaba Rakshit (3):
      soc: qcom: ice: Add OPP-based clock scaling support for ICE
      ufs: host: Add ICE clock scaling during UFS clock changes
      soc: qcom: ice: Set ICE clk to TURBO on probe

 drivers/soc/qcom/ice.c      | 89 +++++++++++++++++++++++++++++++++++++++++++--
 drivers/ufs/host/ufs-qcom.c | 19 +++++++++-
 include/soc/qcom/ice.h      |  2 +
 3 files changed, 106 insertions(+), 4 deletions(-)
---
base-commit: fe4d0dea039f2befb93f27569593ec209843b0f5
change-id: 20251120-enable-ufs-ice-clock-scaling-b063caf3e6f9

Best regards,
-- 
Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

