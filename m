Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4B419922D
	for <linux-crypto@vger.kernel.org>; Thu,  9 Oct 2025 06:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759990757; cv=none; b=S3elRg/Mu+VlxMbWTMeXLSPy2jMe24F0uGgaZrVzM06M24zR6IpYgpBORQ8ohM+h20f2BtkxPgLILdJ4fGST7vmjMQWo9mo36rJgP46YQY3NsDHGeAe8+uv/eNu1/cjkn3K6Whvih0nIrPcmGmyHAthMEQ+aP3T2gNUkPVe8Elk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759990757; c=relaxed/simple;
	bh=RElW/V0Z435eecAoQxgFffr/tjQtz6OYj7jJiPqLdnw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=tfJj/oX2/rSwffT+Mh1ocqaqzbD0ee9La8ksApJUC4vPv4m3kyIvw7ToS9JYUE91PvMXRun/KyE8GWIuorxbujS/M7+WxgP2B6+Tvpu++0ARNzak5O+nWjaBQ6pt8LlG4ATDyHvO5QtQitvvzm3svwXKQmPPPT/ayzjrNjNMMQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YjJFE0/r; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YjJFE0/r"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5996EPIS028592
	for <linux-crypto@vger.kernel.org>; Thu, 9 Oct 2025 06:19:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=27kHMdvwH0X0328kYvOzhu
	ArDwRqIDLbTEsO0hy9HCs=; b=YjJFE0/rII1owim/UA+hyfDgNMuDeEEDElg3Iy
	B+juKA67PUZwgbom6twBx2RXIt1JjYmLShtoasVUiZMnv5be0KwZ5NWvGScDroHO
	lD9xXANlGq1mSs7xJoUflN/8+fXF/aQAoXn+QDygvzO4nrkmNvei+VWz/S+O2xJR
	qZYD+5LBVLsnQWCNffzEpxK6lJ8XikT9KOznD4P9/7Wg9WCRN+xRcW9FOw5B4xcx
	xU0opuJyAZuTC/k1d93/faxE4qYXdGUZCbSFsSdY21JTd4c+M6NcUDpZXzMIWT+C
	RReJnx8vGiqeAMwagGmXhYmTLKN6SLRzg6twbWnxd4SxO0zw==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49nv4ksnu9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 09 Oct 2025 06:19:14 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b5533921eb2so772312a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 23:19:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759990753; x=1760595553;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=27kHMdvwH0X0328kYvOzhuArDwRqIDLbTEsO0hy9HCs=;
        b=jaCDnfzR4Pq1gbFtCOo+vgE7HMClUj0Gdy6UqGPc0t3ILWWTfmg69vw/f6MppP6bCx
         6JNuC8s77UtY4w2C9qk8k5yQouT8c7+oD6HpYPuBbfkJh73qEbjhf01FK2se1WJq/jtu
         b3d0yKwe+zDC+Azq3ItJdsYHPty7D6/ZYy2CCUO6RP8kMcZQy7SORmlktLrExJeFBPTj
         /EOkMXRvHa4RDVGEQCbxj+9qsN85pGcTJN1TED6QV1qg57SQ42a7jTd6d+VbiWoMXIOG
         4UMak1jJkfRlUfMOpIGu86A4slZ67SJE4aM2RyqK0i8FdT7zF8RmzdzND4bqZ3nsX9td
         GWbA==
X-Forwarded-Encrypted: i=1; AJvYcCXFZcaCwbvq18DEqIm4IUvoFAVNH7zQdJqwYrICvuD314OVwhXGF6YzomMH6DIrauklq82JHdi3ay+q7Nc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp3/yh/J/K39nKVWTS3hNUvBr1Wri7B7m5fYizklLW2k6iAP5V
	pPt5tgWy8UwGCFJKqjdtzqDyAKg82wkbXCbG8T++txp6UrM5Xw8zQ1HGRkglYiq2s84S2ojZN/4
	6IWFXpgB2CVd42KNfReheG5XfWOEKKr9K/6fXTRga+IiN6Qq+GWucVf6qN9sH9YQyYA0=
X-Gm-Gg: ASbGncs6RGFbWOQEgUK3qBT8DDxd7hFDQTFy6RiAtxw/zMmZbsfB8DeP6aM5WJqL2zR
	QxYceHiqS5M6llqa5UtqnyOuc+5ycFfWxZwl/BwkpOp6gLNc6L51hv+8InnnRJ5DTQo8NGA/umC
	J9h2OAScw1QInlt9MbWNz2ZI/BfJnCSysd/JitV+8TEtUGixIPS1m/f4BglvUDKIBJKfNLyKwtk
	IclDxZW5w/u/Mt6S0L2amruycGBRAoI9Fgbp2KD5T0FhGE3SF8cKlHdoiuLBHpbGOblfmNGTrtz
	zQPmHtV0MTqhhJqrEOe40YJQBfL0cogAh0ZjpG5mtMwWdxnFBkXtr+4+biahj3AmIc458Po+gM/
	TuDYjQWM=
X-Received: by 2002:a05:6a20:6a1a:b0:323:cbb9:aa1b with SMTP id adf61e73a8af0-32da845fef7mr8847873637.51.1759990753252;
        Wed, 08 Oct 2025 23:19:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYwiXOhov/LxmRkYry+Q9grSkuraWC5lKuqWh3Ov3GOZp6ZzGWGHWrshn76JtzwZKRRdX/NA==
X-Received: by 2002:a05:6a20:6a1a:b0:323:cbb9:aa1b with SMTP id adf61e73a8af0-32da845fef7mr8847838637.51.1759990752738;
        Wed, 08 Oct 2025 23:19:12 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6099adbcbesm19239671a12.4.2025.10.08.23.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 23:19:12 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Subject: [PATCH 0/5] Add separate ICE UFS and eMMC device nodes for QCS615
 platform
Date: Thu, 09 Oct 2025 11:48:50 +0530
Message-Id: <20251009-add-separate-ice-ufs-and-emmc-device-nodes-for-qcs615-platform-v1-0-2a34d8d03c72@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMpT52gC/x2OwQrCMBBEf6Xk7ELS0ir+injY7m40YJKabUUo/
 XcXj28G3szuVFoSdddud00+SVMtBuHUOXpieQgkNna978fg/QTIDCoLNlytI4EtKmBhkJwJ2BS
 WlcqiEGuDN+kURlheuBpmuAwy03CemZmcjSxNYvr+D9zux/EDOpnIN5AAAAA=
X-Change-ID: 20251006-add-separate-ice-ufs-and-emmc-device-nodes-for-qcs615-platform-83ebc37bdddc
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX+OqA2nHyi7NO
 PhxkqEFBusl8uICXUF63qzKr5QYSPfFZhQI9Jaljq2ESqn2IseJBzk/lFXoUeaR1EpzjzPgLaX7
 1zlC2aTT4Bkojv3QcKAe8xdxu52mbQE334Sd567XC+7fyDlS8kT2J7x8PWKSeeKowlDb4xFVc97
 LTBE1cpBJSrywo5vEC2YVePeLpdOjkHGsdkeJTSjmvp6QrZ9d4WI14g1UuAAX59hynXDqtEutyX
 hi7DA4wqWyqPuz+BYF/+G6nyOJYPs+gGM3uzBOAP1IMgRlfq5zwgRL8qgLRjHl++Qkb6e1odtes
 hpCL5vNJpEY5nFZFFTSc+6RkIB1yGNuBXZux/TfhVVOXveNRnnvfwMux58EFWSgAYtE4KTxeNp3
 Lq0Ow42ClYVDpXXWswKHlohuv5R9EQ==
X-Proofpoint-GUID: HmsioCeAfXK_dQMx6b7JfYeJAV0u8n9Y
X-Proofpoint-ORIG-GUID: HmsioCeAfXK_dQMx6b7JfYeJAV0u8n9Y
X-Authority-Analysis: v=2.4 cv=SJxPlevH c=1 sm=1 tr=0 ts=68e753e2 cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=EUspDBNiAAAA:8 a=TE4wMAv-58-w6rAmtzAA:9
 a=QEXdDO2ut3YA:10 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-09_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 impostorscore=0 spamscore=0 phishscore=0
 clxscore=1011 bulkscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121

This patch series introduces support for representing the Inline Crypto Engine (ICE)
as separate device nodes for both UFS and eMMC on the QCS615 platform.
Previously, ICE functionality was implicitly tied to the UFS/eMMC controllers.
With this update, ICE is modeled as an independent hardware block, allowing its
clock and frequency configuration to be managed directly by the ICE driver.
This separation improves modularity, aligns with hardware architecture.

The change allows the MMC/UFS controller to link to the ICE node for
crypto operations without embedding ICE-specific properties directly
in the MMC nodes.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
Abhinaba Rakshit (5):
      dt-bindings: mmc: add qcom,ice phandle to mmc
      dt-bindings: crypto: ice: add freq-table-hz property to ICE schema
      dt-bindings: crypto: ice: document the qcs615 inline crypto engine
      arm64: dts: qcom: qcs615: add ufs and emmc inline crypto engine nodes
      dts: qcom: qcs615-ride: Enable ice ufs and emmc

 .../bindings/crypto/qcom,inline-crypto-engine.yaml |  7 +++
 .../devicetree/bindings/mmc/sdhci-msm.yaml         |  4 ++
 arch/arm64/boot/dts/qcom/qcs615-ride.dts           |  8 ++++
 arch/arm64/boot/dts/qcom/sm6150.dtsi               | 51 +++++++++++++---------
 4 files changed, 49 insertions(+), 21 deletions(-)
---
base-commit: 47a8d4b89844f5974f634b4189a39d5ccbacd81c
change-id: 20251006-add-separate-ice-ufs-and-emmc-device-nodes-for-qcs615-platform-83ebc37bdddc

Best regards,
-- 
Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

