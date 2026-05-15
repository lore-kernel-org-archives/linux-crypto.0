Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827D644D018
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 10:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778841992; cv=none; b=YxZ/AB6wc+K5LnSYXb8Pwob57Sq9nD8aLrjtpeaQ0tldZFEbHubqfA18wpi2/5MhThRf6jZUWHrc8F7br+C2IRucRwbAXEqm3tD/JSdnlrPjJWGfIyFw9JbIrzznMAuICIuumNhhCUbdrUd273gqZYdJkgkjE/UuprxEbGpBoGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778841992; c=relaxed/simple;
	bh=wMUv2/vsDA9bEMUw/tVu9wXRo/rcLzGAUiB5vdQjm/Y=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=tj+D3LoypX/xB0brzouTsEpDJ8xaeCZgsitsj2nHukoT/tJujmqkw3+/zCbYVVxwl6WC1KwN0wl34aPpWmAb9hcloNf+j9Uq6AKnwLFe5ipgwQz7QzzqzbV52gxl4TQ8e2Fdde44oAQ3rLuaNULmbx8jOCK5+rbjWGOijYCkgmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jysB++YI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=grulyFCs; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jysB++YI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="grulyFCs"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F584273197601
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 10:46:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=XBHTerfjmV+1YAC6GpRFKu
	v6kE7wy/lSovkWyzSWvKQ=; b=jysB++YIDrt78BuRdhn8gRSmZRBLVioHkiYKYE
	da1/34YsCzJ9Gg4SrzmvB/8XDR+FXfL/4U4z5o+ysE2EHApV1ZPBKBQsgmNQ9Pbh
	ZaCNVjHdrpA9wpHCXmCpvpxXifUct9eS3rlFJex8BszS7qSK94SCbj40SvlQqdzl
	nOjaydbNxf4RS6xUcAniHaaW7opkEBCdngx0XJTSjJTsYJv16qc3cFC3Dc85f2Vd
	cEjC1tCJILuzD1dVF/Ddmxc+W7jkQMM41RqQmkbzugSVdS0HDFLRYhAsRpXBkT4V
	FfOKClBIdY0O7XNKHacrnPdl6JR6o2gnn8M1krFBXxKo1l8A==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e5m1qawa0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 10:46:30 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2bd6aeb3637so30098845ad.2
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 03:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778841989; x=1779446789; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XBHTerfjmV+1YAC6GpRFKuv6kE7wy/lSovkWyzSWvKQ=;
        b=grulyFCsOm5L+H5LU8GaP1MpuKTTSTfOt4k81TKs0ihm5P2HW1BddZ+ipHFrOY747+
         LczWxdBJrVllrfwZsPh7uBa9qUDLlKT1vXhAC6xkaPiLEYjz1xR9Fg2CNMlmS424KFi3
         JQ8t5Zamej+jxJkQaiYrkgL68RKeKksSJw0kZG94U+dpPhHY2Js+6T+wWv5o/Yzb/cL3
         FpG4Sghi6L8uvIHQgKCiTyiNHnrW050gl/AVQw0olV//LUvQe+roDTEaX5YLqbUMwLfK
         kbKF4peC3FjzHeFu8Wu6dQvEBOhQDfF60F+RNfHOxjI/6JCL6D/jy57cpsV3EC4ixyvI
         45Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778841989; x=1779446789;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XBHTerfjmV+1YAC6GpRFKuv6kE7wy/lSovkWyzSWvKQ=;
        b=VvnyD2E3B00TiyLHWYWe2csrFDOFGUNIVhUCrM34BqzmkkNFsIrc68rXz1wKVz1dW9
         J40hN8tq9RXoovzNuvdtf+HxuU50Ps9hR92eZ7etlx/7hV3zfSTdaSYVpJvsCzwGqBZd
         VuWX1Y/xzi9qDWlM3Ye2rBsvXneg6V1ku3NtTuDxxaS25SyIfS7r3xqPd8FUtN82tpmX
         ZyVAcFVJ0A6X8lWpL9cUlJy7ahqawwalcfe8yhTj0OjFGpmy9B7J8Qu5DQEHmbcnefrw
         sBv2gfaAgA0YUucf3Y2ktpm/2nmt0Vitr2ObEstMkaR3vC5D7SsQ0fteUCQ1j17vTpiZ
         yVpg==
X-Forwarded-Encrypted: i=1; AFNElJ/RPiBl58YEWjeTNSiRA6QiihzMkDV9Qg+yssrixWoxiQsDrsm2oE6dA98X8U9CC61CzRe0e8BJM9wDFGY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvTh1mzrVTbyuJ2qCW/qj73XgOgTCmRYWtjDIBIXRe8TL5Gupi
	HKqdpGYiSrQ8oRE90jbQFQw5SMHsQFMq24Qmjk5yd4FymzA7t6eobaF6vF5ks7tgR9fROYc+JKb
	TfBvBUyqfwTk04NIeDMizX3BpkdVlqXeFY9rMDWJr5kEoHXL5m6oa9uW7sTFgyOomIb0=
X-Gm-Gg: Acq92OE1ANo3JTsX88JWh6GfS+72dH+LhJygKyGRk/NaZ2n3hOb7EQosVLuM2WHmJTT
	bxn/cS0sjnTqiVyphqDJ5D0RX5yEKCNe1AwQdXNg/c7n37SsGnfgZNmnf97CV8/OYJEq2urLU06
	j640uAD95RU4DY6NRh1qWuSTuSv3bCsz5ykhsS6OPv5oS2YNhRtVrrFXz3FE62e8BVa0/LPQHr4
	BU5BatsLNs/1dW4W0ZIePYcc+CIZXL3JU7ZCtfuI77WQGtipVO84Cj53vIKM8nCiUBMCaJSenOn
	gS44Vg36W+VI3VWpgPRXUcRhEbOLM4TeMdxse3XlrAFTda6LTqbPwHZdcAV2+pzUSqlEZl80j5M
	bSHs9RF6ujOACBDs+7aicV1/LhSe0mnocZhIbezQBUqOr5DGQ2X33dl0=
X-Received: by 2002:a17:902:ca93:b0:2bc:eea4:83c3 with SMTP id d9443c01a7336-2bd7e87d79emr27810695ad.25.1778841989497;
        Fri, 15 May 2026 03:46:29 -0700 (PDT)
X-Received: by 2002:a17:902:ca93:b0:2bc:eea4:83c3 with SMTP id d9443c01a7336-2bd7e87d79emr27810405ad.25.1778841989051;
        Fri, 15 May 2026 03:46:29 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5bd5f2dcsm55839755ad.13.2026.05.15.03.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 03:46:28 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Subject: [PATCH v2 0/2] Add support for ice sdhc on shikra
Date: Fri, 15 May 2026 16:16:02 +0530
Message-Id: <20260515-shikra_ice_ufs-v2-0-2724a54339db@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGv5BmoC/12NQQ6CMBREr0K6tqQtFMWV9zCElPKRr0K1H4iGc
 HcLxo2bSV4y82ZmBB6B2DGamYcJCV0fQO0iZlvTX4BjHZgpoTKhZcKpxZs3JVoox4a4zmthUgV
 JelAsjB4eGnxtwnPxZRqrK9hhtayNFmlw/r09TnLt/eT6Xz5JLnglq8xCvRda5ydHFD9Hc7eu6
 +IQrFiW5QM7aBYzxQAAAA==
X-Change-ID: 20260513-shikra_ice_ufs-59d0a42e3482
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Proofpoint-GUID: FTt_p3TTwsequjDjyEasNjzDM9IuXLyW
X-Authority-Analysis: v=2.4 cv=GulyPE1C c=1 sm=1 tr=0 ts=6a06f986 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=bC-a23v3AAAA:8 a=GDFvtG6j3FZufZSdgfMA:9
 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDEwOSBTYWx0ZWRfX3rGJtvsv4Izs
 LS5CkzX3T1YsollJKwsjVmGTEqM8ajFyyhRzRPeoTKCFlGJF2UDGce1DqBI/GQrIhS9I9EnTpR9
 qJH4alYEAnnoXmeYEaxsHuQdq41fPoBnJffz2H/PlrJ6spLRw6C4MNrg3cTRROpePj2/SB4elDX
 z1nY8lMvcRGvVSD9vDA1mjh4Am857bpUC4VgJqiatnGZsuatJfUptnu0s7Au4Th3TzWtvTrKQlF
 DInZVIDypoXU7k3a//pMp79UbjijGU9IZcYheLD+BLiG7yLqfu5SzpCfsb6WwU5ymcPGcxbJAJc
 52g9Y0mUATvPK0YPHUpitwct/zzqQyPA13vqSxTUy/HQ/Mt+hzXztNjAfw//Z/Q/gvt/Lve0GYI
 OT5r0Asnom5M+oSlEIhdOJF5XNuddNgGcf1a/Rg1ZBjgxCv5EQSmf6JcincfHAKdniKQW6n2PES
 5slBl+U+NoMzSwJ/8zg==
X-Proofpoint-ORIG-GUID: FTt_p3TTwsequjDjyEasNjzDM9IuXLyW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-15_02,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 clxscore=1015 impostorscore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605150109

This patchseries attempt to enable ice sdhc on shikra similar to other
platforms.

Validations: 
- Driver probe on bootup.

Dependency on:
- https://lore.kernel.org/all/20260512-shikra-dt-v1-0-716438330dd0@oss.qualcomm.com/
- https://lore.kernel.org/linux-arm-msm/20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com/

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
Changes in v2:
- Reword commit message for patch 2/2 and cover letter.
- Link to v1: https://patch.msgid.link/20260515-shikra_ice_ufs-v1-0-b1b6ced70559@oss.qualcomm.com

---
Kuldeep Singh (2):
      dt-bindings: crypto: qcom,inline-crypto-engine: Document Shikra ICE
      arm64: dts: qcom: shikra: Enable ice support for SDHC

 .../bindings/crypto/qcom,inline-crypto-engine.yaml           |  1 +
 arch/arm64/boot/dts/qcom/shikra.dtsi                         | 12 ++++++++++++
 2 files changed, 13 insertions(+)
---
base-commit: 7e247866bbe72314f68036d5171c1af354ccdbe8
change-id: 20260513-shikra_ice_ufs-59d0a42e3482

Best regards,
--  
Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

