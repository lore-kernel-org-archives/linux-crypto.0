Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794406658;
	b=enO1+3ibG4FaMN5JL0dBzOJVnZv5SMQbCAX7GM/ltH2FB2E0XE986oM3uKn70PAuLXNk
	 uDUMMpFH5Qh7SWEMXlW6FmefwqlvWeQa7EwFotcTn7xUFTlwa9zR0wxvwno2U6iFmj52q
	 SweT6w0SfXOW4vfBH7KuY1muv6a2aLD2lrUL6hiNm+VT1uWaVVHV/F+dzZJt30YsMrGur
	 KCGgKjwiP/uBD6LrD1D24pQpQbheSwfW2lYVszKUeDnKGVF0vHBnSYqafGU+721Xf3oMt
	 kwc43gdI0GwMuR6ZnxFHhAMYJCFzmOlUoMj7bPuuKAentCP6Xd/9D481rRxgaLn5v9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794406658;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=6HT8hHbJeK5I+tO3cjERj1hO0RTkiT/uf2C7Ao/T0oc=;
	b=evCkvTw9TsDRlvIsKZtuRTtzOMIb5cZVhqneWL2ii3nYlOGWNuZ9Gr8rKsRqK7D1xcQb
	 bBNr9IV6PByybhreGr0qpf9H0df78yASrfinSUWogliQOPpN+Odz42Pct9p2CbmnHeKvE
	 pioTcKHsuALb25Qx6pGFNWymUa4i+db98EGNBTlkXg7F6NICKek7keoMLdmW2nEU9G2Pp
	 KLmT/4hOUPeiy8Y2ZOMZX0l+KVHiNMtVuwPfjhzsx4PWUuDHcsNOMq6Jp5Ovlu+SHucBa
	 Z0TrxOzBf4LFnCSNNfCqEmM1OMI+Lj0n3ScLwYFwVW1lHQ6Op4zAG1Z1nsz8wu0bJQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=o6ivmwQw;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=QTGCyCCV;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0FF606A32A
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:17:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B0FF606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=o6ivmwQw;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=QTGCyCCV
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABEHTOc2556365
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:17:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6HT8hHbJeK5I+tO3cjERj1hO0RTkiT/uf2C7Ao/T0oc=; b=o6ivmwQwRgG4pHwy
	q+afwrSICKZZR2siQ1gTy04fwkgZRhr+lHnfA30bd+Vsym8aPcCSgEW4Rp4ic+AT
	pd7x+sbkgNl3Keiuet3TtrHMHt+SqAkCdWkzK7T8rm5/4ETAOP6t0pBGpFJA9GQX
	L3RJobIiglW2Ei4mUk33TzEN7f1besSUDLRH952m+J86P1GJcmg5VfCW8R/uPzUo
	2jYvhDSNiTIzKhsd6cuhHjLy+GUOMCOwJnKp80mcNeCIILEIcxfar9NTORYzcNpM
	o1fVRmD40IQBI0GHBERTr28xYsnN2+UskFK5GK8klZykmaeq51HHTyV5OZXzYHyj
	+PUpOw==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hvdnmb0e6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 14:17:36 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1af203073e0so3878478c88.1
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 06:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794406656; x=1795011456; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6HT8hHbJeK5I+tO3cjERj1hO0RTkiT/uf2C7Ao/T0oc=;
        b=QTGCyCCVtTvqmRdxog4MBplwyFsoGPVAXycO9pjpT2PJOe64eXqRFhzw6uqEfUVK2O
         QPvEZqxF53pYUH6PUwfnJi/NsajBQ/PnyQVXrAJsGP5sFk+zohSe1JPMnZ83zB9SxLXx
         uSx1P2Qvi6ajTHev/duVDYw/HJMVAsh84xo9YPKmxsOxNCTnDtwrMCfYVoTqSSuGDCYt
         hk8wlzHL1pPt7t3hB07IxFsn4DxSK6u0yxnOyy03cRwixhxGVrESNpWHONTtxMv37r1j
         LiD39zgGBdmc97KcSmAgIdY951dYc1fXV3WnP7Fdh+mx0hIhmLLZ515wCWBYxv/07NID
         99yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794406656; x=1795011456;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6HT8hHbJeK5I+tO3cjERj1hO0RTkiT/uf2C7Ao/T0oc=;
        b=VHK3cAfp1pMUorZT8rleTp9RwZlP7t5fS14n+p7fcDNXMIfTiFG4pKiRm6BqIsLX3y
         ym7MyfCMEfx5clCH2N4VFh9OFPmXpN437J8o7I86bejYkP+S8QbfQv3shqbC+CC/uELa
         euHaAjf8EtyQ281v82k1QRm5QEKUnFoxWDhGN6GC7/IpCn6p6o3DuvOsPFk+mcIYXBHx
         Mwb1HU6p7VMraquH9FWZelEVxybY8AosOol/eaH4Q6giEb2ZZFwQD9B7cUESOhM3iLXj
         xZkm+NOSyKNBjLmnW5KdaiU4aJrVo/Ov+uZ4xGGnxKGVbul2HyTO6so1kXLq0jI2s1p9
         SW2Q==
X-Forwarded-Encrypted: i=1; AL+hErE1jqxKs2lmg/PPXjkDeEo7eLiqxkiy1CaStyVvwcek/fT2G1XCUK4qlZ/DTxPtHpTUkjCatuhMxghICAw=@vger.kernel.org
X-Gm-Message-State: APuU4Z9TSTTuapVI7dCPn6de/Hv4Nu8i2JOlHxAyJ8vTpTn8Qo1gtOlr
	lkgd3xB1toWw9ixu1ZLcTMNawZ+MYUr28R8MWBihAizeNhInAQjVLpoB1TPn6nn3bSXoy6OOtaP
	LzpCrWBmRppaI7xxow8aLb+RELwsMnI3+fiaVJkkbaZJyF2FnoclGmXoUbQFvF/ybvME=
X-Gm-Gg: AYBFou0FevP4h48pOaFITMcrWG5KKsixKLB2sBe8gnPDI23XU4W4Xod6UvvPYtWdl8D
	hmHB8njzsMsdgbwKdBXQHyYVpv6WGDe/93+yJY2su89JC5PwUN0Q7ptKb6DgoNg8KuIjBQQ9bVQ
	HiVp/e7kjZnQKgpgyPf8e8EECUCGFHPikEaYE7PnlpRpusjc8RAuPKKe5kOsM0ZBQHTIephMUCQ
	4kT8XHdJdM8haXgs3mWkeAmg4r57o/PTtxrwVR3ILOueNwaWOfKFBa+NRFKcdpwleWLvOcqzR3P
	gLigPHSC0v4U+ERhEb538XEcYfmcQqFhhO7vsFOWK5RGFwgM8iZZIN4ZUFfjbUeZoKXCsnwgmIb
	m3DRGNK4dH6egXcj0IZrUJFwoNH1OgwREO7mDI2sNQTPo80gYvYrhEj/WmYj7z7ZaDe2NlL35oA
	==
X-Received: by 2002:a05:701b:2903:b0:18d:5ef2:1644 with SMTP id a92af1059eb24-1b3c036ee7bmr2169541c88.30.1794406655730;
        Wed, 11 Nov 2026 06:17:35 -0800 (PST)
X-Received: by 2002:a05:701b:2903:b0:18d:5ef2:1644 with SMTP id a92af1059eb24-1b3c036ee7bmr2169521c88.30.1794406654965;
        Wed, 11 Nov 2026 06:17:34 -0800 (PST)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b2fc09sm33747063c88.10.2026.11.11.06.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 06:17:34 -0800 (PST)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Wed, 11 Nov 2026 19:47:03 +0530
Subject: [PATCH v2 3/6] firmware: qcom: Add a TEE bus based ICE back-end
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
Message-Id: <20261111-ice-migrate-tee-svc-v2-3-29d19f6c92ab@oss.qualcomm.com>
References: <20261111-ice-migrate-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com>
In-Reply-To: <20261111-ice-migrate-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com>
To: Eric Biggers <ebiggers@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Selvam Sathappan Periakaruppan <selvam.periakaruppan@oss.qualcomm.com>
Cc: Basant Kumar <basantk@qti.qualcomm.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794406634; l=13396;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=PylHrxFtErCha1pfSPdVeT6/oar8gRRa1n/cWHdZRSo=;
 b=ym6OEzmHFd+rmBlgPher3t/9TdCUEi5uF2SyQ0G8HM1LpRk1ImpnBfEM01Ql+8HQkB2Sv6mN7
 YLc0pwyGpCTACftJ8pjRGvSxAGFbV5y4nsw5phqDsehqQ8krU/HiBXf
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: Q9gA8pBvE7m67tosKSAyqi3YvFSyexKX
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA1NiBTYWx0ZWRfX7ZblDhI6M33/
 JGntRu6BrM2r5AVEX5sR3obZ8mqmsbsToPrBj3IG5DToNZY6txdvZJk5FgDh8ESd+NYbTWPT0qA
 H2Pp7gqQYc/qgDqEF9ouQb+XgOwQ85I=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA1NiBTYWx0ZWRfX6D3X0KGSzRbe
 rLC8HDi91HQ8ixX9wbZwm4pdDKT8+uuIbxWwIP5lkTkXQ52fxRNpQnstDYybO+YzbS0ZTuLuc1v
 fjWksAjD3IOuiEIHuz+Mr5KLzVrmXPP5ozrah45fxBpHomLcrjbQtrFHTqLKz0SenlYlyUJj2j8
 4uZnH1Rx4+EFo0Mtk2steGHV5XZCUaveFDXtca+yX6HjR6F2LNL2fMrNHF1rAX0dqSrURuYW2GK
 QTCGKv/UiV895vW2zcEqxnzlLapykDnslYhN/3M42bMKzk1eDG+uTiXg46Uf4T0wGT1qmL3xPwQ
 HUanvdfDO+/856r7zh6eGJsKCxGiXnPjggszdE5sp1Nvj8ZRGf0Eh5+pVV2HQ3vFhRTp0HVd6PG
 vfN/+xNQ4bUVqKmIJZREn+BiJyskhcncsx0WNB1u+HNqpDrfhfzY4f1684nJPtVBvWc8hTmz9wn
 TtB23ZKZ2BBTfJLgamQ==
X-Proofpoint-GUID: Q9gA8pBvE7m67tosKSAyqi3YvFSyexKX
X-Authority-Analysis: v=2.4 cv=MpzHeGae c=1 sm=1 tr=0 ts=6af47900 cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=wV6y_F6WGLPFbETn8MUA:9 a=QEXdDO2ut3YA:10
 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-11_03,2026-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611110056

Add support for a TEE client driver which forwards calls from the Inline
Crypto Engine (ICE) driver to the OPTEE ICE Pseudo-TA.

The ICE PTA supports both ICE Legacy and Standard modes. In Standard mode
Hardware Key Manager v1 is supported.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 MAINTAINERS                          |   7 +
 drivers/firmware/qcom/Kconfig        |   9 +
 drivers/firmware/qcom/Makefile       |   1 +
 drivers/firmware/qcom/qcom_ice_tee.c | 402 +++++++++++++++++++++++++++++++++++
 4 files changed, 419 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f58a305de664..1132e456488b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23007,6 +23007,13 @@ F:	Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
 F:	drivers/soc/qcom/ice.c
 F:	include/soc/qcom/ice.h
 
+QUALCOMM INLINE CRYPTO ENGINE TEE SERVICE
+M:	Harshal Dev <harshal.dev@oss.qualcomm.com>
+L:	linux-arm-msm@vger.kernel.org
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	drivers/firmware/qcom/qcom_ice_tee.c
+
 QUALCOMM INTERCONNECT BWMON DRIVER
 M:	Krzysztof Kozlowski <krzk@kernel.org>
 L:	linux-arm-msm@vger.kernel.org
diff --git a/drivers/firmware/qcom/Kconfig b/drivers/firmware/qcom/Kconfig
index 3ad22f8fc3e5..189ada7fdcd6 100644
--- a/drivers/firmware/qcom/Kconfig
+++ b/drivers/firmware/qcom/Kconfig
@@ -25,6 +25,15 @@ config QCOM_PAS_TEE
 	  Enable the generic Peripheral Authentication Service (PAS) provided
 	  by the firmware TEE implementation as the backend.
 
+config QCOM_ICE_TEE
+	tristate
+	depends on TEE
+	depends on !CPU_BIG_ENDIAN
+	default m if ARCH_QCOM
+	help
+	  Enable the generic Inline Crypto Engine (ICE) firmware service TEE
+	  implementation as a backend.
+
 config QCOM_SCM
 	tristate "Qualcomm PAS SCM interface driver" if ARCH_QCOM || COMPILE_TEST
 	select QCOM_PAS
diff --git a/drivers/firmware/qcom/Makefile b/drivers/firmware/qcom/Makefile
index 88ce74d74c3e..5ef64f17e6e5 100644
--- a/drivers/firmware/qcom/Makefile
+++ b/drivers/firmware/qcom/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_QCOM_QSEECOM)	+= qcom_qseecom.o
 obj-$(CONFIG_QCOM_QSEECOM_UEFISECAPP) += qcom_qseecom_uefisecapp.o
 obj-$(CONFIG_QCOM_PAS)		+= qcom_pas.o
 obj-$(CONFIG_QCOM_PAS_TEE)	+= qcom_pas_tee.o
+obj-$(CONFIG_QCOM_ICE_TEE)     += qcom_ice_tee.o
diff --git a/drivers/firmware/qcom/qcom_ice_tee.c b/drivers/firmware/qcom/qcom_ice_tee.c
new file mode 100644
index 000000000000..694aa05847f0
--- /dev/null
+++ b/drivers/firmware/qcom/qcom_ice_tee.c
@@ -0,0 +1,402 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/tee_drv.h>
+#include <linux/uuid.h>
+#include <linux/firmware/qcom/qcom_ice_tee.h>
+
+#include <soc/qcom/ice.h>
+
+#define PTA_QCOM_ICE_INVALIDATE_KEY		0
+#define PTA_QCOM_ICE_SET_CONFIG_KEY		1
+#define PTA_QCOM_ICE_GENERATE_KEY		2
+#define PTA_QCOM_ICE_IMPORT_KEY			3
+#define PTA_QCOM_ICE_EXPORT_KEY			4
+#define PTA_QCOM_ICE_GET_RAW_SECRET		5
+#define PTA_QCOM_ICE_HAS_WRAPPED_KEY_SUPPORT	6
+
+#define TEE_NUM_PARAMS				4
+
+struct qcom_ice_tee_private {
+	struct device *dev;
+	struct tee_context *ctx;
+	u32 session_id;
+};
+
+static int qcom_ice_tee_invalidate_key(struct device *dev, u32 index)
+{
+	struct qcom_ice_tee_private *data = dev_get_drvdata(dev);
+	struct tee_ioctl_invoke_arg inv_arg = {
+		.func = PTA_QCOM_ICE_INVALIDATE_KEY,
+		.session = data->session_id,
+		.num_params = TEE_NUM_PARAMS,
+	};
+	struct tee_param param[TEE_NUM_PARAMS] = {
+		[0] = {
+			.attr = TEE_IOCTL_PARAM_ATTR_TYPE_VALUE_INPUT,
+			.u.value.a = index,
+			.u.value.b = 0,
+		}
+	};
+	int ret;
+
+	ret = tee_client_invoke_func(data->ctx, &inv_arg, param);
+	if (ret < 0 || inv_arg.ret != 0)
+		ret = ret ?: -EINVAL;
+
+	return ret;
+}
+
+static int qcom_ice_tee_set_key(struct device *dev, u32 index,
+				const u8 *key, u32 key_size,
+				enum qcom_ice_cipher cipher,
+				u32 data_unit_size)
+{
+	struct qcom_ice_tee_private *data = dev_get_drvdata(dev);
+	struct tee_ioctl_invoke_arg inv_arg = {
+		.func = PTA_QCOM_ICE_SET_CONFIG_KEY,
+		.session = data->session_id,
+		.num_params = TEE_NUM_PARAMS,
+	};
+	struct tee_param param[TEE_NUM_PARAMS] = {
+		[0] = {
+			.attr = TEE_IOCTL_PARAM_ATTR_TYPE_VALUE_INPUT,
+			.u.value.a = index,
+			.u.value.b = cipher,
+		},
+		[1] = {
+			.attr = TEE_IOCTL_PARAM_ATTR_TYPE_VALUE_INPUT,
+			.u.value.a = data_unit_size,
+		},
+		[2] = {
+			.attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INPUT,
+		}
+	};
+	struct tee_shm *key_shm;
+	u8 *key_buf;
+	int ret;
+
+	key_shm = tee_shm_alloc_kernel_buf(data->ctx, key_size);
+	if (IS_ERR(key_shm))
+		return PTR_ERR(key_shm);
+
+	key_buf = tee_shm_get_va(key_shm, 0);
+	if (IS_ERR(key_buf)) {
+		ret = PTR_ERR(key_buf);
+		goto exit;
+	}
+
+	memcpy(key_buf, key, key_size);
+	param[2].u.memref.shm = key_shm;
+	param[2].u.memref.size = key_size;
+
+	ret = tee_client_invoke_func(data->ctx, &inv_arg, param);
+	memzero_explicit(key_buf, key_size);
+	if (ret < 0 || inv_arg.ret != 0) {
+		dev_err(dev,
+			"ICE set_key failed, idx=%u, ret=%d, err=0x%x\n",
+			index, ret, inv_arg.ret);
+		ret = ret ?: -EINVAL;
+	}
+exit:
+	tee_shm_free(key_shm);
+	return ret;
+}
+
+static int qcom_ice_tee_wrapped_key_call(struct device *dev, u32 cmd,
+					 const u8 *in, size_t in_size,
+					 u8 *out, size_t out_size)
+{
+	struct qcom_ice_tee_private *data = dev_get_drvdata(dev);
+	struct tee_ioctl_invoke_arg inv_arg = {
+		.func = cmd,
+		.session = data->session_id,
+		.num_params = TEE_NUM_PARAMS,
+	};
+	struct tee_param param[TEE_NUM_PARAMS] = { };
+	struct tee_shm *in_shm = NULL;
+	struct tee_shm *out_shm = NULL;
+	size_t out_buf_size;
+	u8 *buf;
+	int ret;
+
+	if (in && in_size) {
+		in_shm = tee_shm_alloc_kernel_buf(data->ctx, in_size);
+		if (IS_ERR(in_shm))
+			return PTR_ERR(in_shm);
+
+		buf = tee_shm_get_va(in_shm, 0);
+		if (IS_ERR(buf)) {
+			ret = PTR_ERR(buf);
+			goto exit;
+		}
+		memcpy(buf, in, in_size);
+
+		param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INPUT;
+		param[0].u.memref.shm = in_shm;
+		param[0].u.memref.size = in_size;
+	}
+
+	if (out && out_size) {
+		out_shm = tee_shm_alloc_kernel_buf(data->ctx, out_size);
+		if (IS_ERR(out_shm)) {
+			ret = PTR_ERR(out_shm);
+			goto exit;
+		}
+
+		param[1].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_OUTPUT;
+		param[1].u.memref.shm = out_shm;
+		param[1].u.memref.size = out_size;
+	}
+
+	ret = tee_client_invoke_func(data->ctx, &inv_arg, param);
+	if (ret < 0 || inv_arg.ret != 0) {
+		dev_err(dev,
+			"ICE cmd %u failed, ret=%d, err=0x%x\n",
+			cmd, ret, inv_arg.ret);
+		ret = ret ?: -EINVAL;
+		goto exit;
+	}
+
+	if (out && out_size) {
+		out_buf_size = param[1].u.memref.size;
+		if (out_size != out_buf_size) {
+			ret = -EINVAL;
+			goto exit;
+		}
+
+		buf = tee_shm_get_va(out_shm, 0);
+		if (IS_ERR(buf)) {
+			ret = PTR_ERR(buf);
+			goto exit;
+		}
+		memcpy(out, buf, out_buf_size);
+		memzero_explicit(buf, out_buf_size);
+	}
+exit:
+	if (in_shm && !IS_ERR(in_shm)) {
+		buf = tee_shm_get_va(in_shm, 0);
+		if (!IS_ERR(buf))
+			memzero_explicit(buf, in_size);
+		tee_shm_free(in_shm);
+	}
+	if (out_shm && !IS_ERR(out_shm)) {
+		buf = tee_shm_get_va(out_shm, 0);
+		if (!IS_ERR(buf))
+			memzero_explicit(buf, out_size);
+		tee_shm_free(out_shm);
+	}
+
+	return ret;
+}
+
+static int qcom_ice_tee_derive_sw_secret(struct device *dev,
+					 const u8 *eph_key,
+					 size_t eph_key_size,
+					 u8 *sw_secret,
+					 size_t sw_secret_size)
+{
+	return qcom_ice_tee_wrapped_key_call(dev, PTA_QCOM_ICE_GET_RAW_SECRET,
+					     eph_key, eph_key_size,
+					     sw_secret, sw_secret_size);
+}
+
+static int qcom_ice_tee_generate_key(struct device *dev,
+				     u8 *lt_key, size_t lt_key_size)
+{
+	struct qcom_ice_tee_private *data = dev_get_drvdata(dev);
+	struct tee_ioctl_invoke_arg inv_arg = {
+		.func = PTA_QCOM_ICE_GENERATE_KEY,
+		.session = data->session_id,
+		.num_params = TEE_NUM_PARAMS,
+	};
+	struct tee_param param[TEE_NUM_PARAMS] = { };
+	struct tee_shm *key_shm;
+	u8 *buf;
+	size_t out_size;
+	int ret;
+
+	key_shm = tee_shm_alloc_kernel_buf(data->ctx, lt_key_size);
+	if (IS_ERR(key_shm))
+		return PTR_ERR(key_shm);
+
+	param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_OUTPUT;
+	param[0].u.memref.shm = key_shm;
+	param[0].u.memref.shm_offs = 0;
+	param[0].u.memref.size = lt_key_size;
+
+	ret = tee_client_invoke_func(data->ctx, &inv_arg, param);
+	if (ret < 0 || inv_arg.ret != 0) {
+		dev_err(dev,
+			"ICE generate_key failed, ret=%d, err=0x%x\n",
+			ret, inv_arg.ret);
+		ret = ret ?: -EINVAL;
+		goto exit;
+	}
+
+	buf = tee_shm_get_va(key_shm, 0);
+	if (IS_ERR(buf)) {
+		ret = PTR_ERR(buf);
+		goto exit;
+	}
+
+	out_size = param[0].u.memref.size;
+	if (out_size != lt_key_size) {
+		ret = -EINVAL;
+		goto clear;
+	}
+
+	memcpy(lt_key, buf, out_size);
+clear:
+	memzero_explicit(buf, lt_key_size);
+exit:
+	tee_shm_free(key_shm);
+	return ret;
+}
+
+static int qcom_ice_tee_prepare_key(struct device *dev,
+				    const u8 *lt_key,
+				    size_t lt_key_size,
+				    u8 *eph_key,
+				    size_t eph_key_size)
+{
+	return qcom_ice_tee_wrapped_key_call(dev, PTA_QCOM_ICE_EXPORT_KEY,
+					     lt_key, lt_key_size,
+					     eph_key, eph_key_size);
+}
+
+static int qcom_ice_tee_import_key(struct device *dev,
+				   const u8 *raw_key,
+				   size_t raw_key_size,
+				   u8 *lt_key,
+				   size_t lt_key_size)
+{
+	return qcom_ice_tee_wrapped_key_call(dev, PTA_QCOM_ICE_IMPORT_KEY,
+					     raw_key, raw_key_size,
+					     lt_key, lt_key_size);
+}
+
+static bool qcom_ice_tee_has_wrapped_key_support(struct device *dev)
+{
+	struct qcom_ice_tee_private *data = dev_get_drvdata(dev);
+	struct tee_ioctl_invoke_arg inv_arg = {
+		.func = PTA_QCOM_ICE_HAS_WRAPPED_KEY_SUPPORT,
+		.session = data->session_id,
+		.num_params = TEE_NUM_PARAMS,
+	};
+	struct tee_param param[TEE_NUM_PARAMS] = {
+		[0] = {
+			.attr = TEE_IOCTL_PARAM_ATTR_TYPE_VALUE_OUTPUT,
+			.u.value.a = 0,
+		}
+	};
+	int ret;
+	bool has_support = false;
+
+	ret = tee_client_invoke_func(data->ctx, &inv_arg, param);
+	if (ret < 0 || inv_arg.ret != 0) {
+		dev_err(dev,
+			"ICE wrapped_key_support failed, ret=%d, err=0x%x\n",
+			ret, inv_arg.ret);
+		goto exit;
+	}
+
+	has_support = param[0].u.value.a;
+exit:
+	return has_support;
+}
+
+static struct qcom_ice_tz_ops qcom_ice_tee_ops = {
+	.drv_name = "qcom-ice-tee",
+	.ice_invalidate_key = qcom_ice_tee_invalidate_key,
+	.ice_set_key = qcom_ice_tee_set_key,
+	.ice_has_wrapped_key_support = qcom_ice_tee_has_wrapped_key_support,
+	.ice_derive_sw_secret = qcom_ice_tee_derive_sw_secret,
+	.ice_generate_key = qcom_ice_tee_generate_key,
+	.ice_prepare_key = qcom_ice_tee_prepare_key,
+	.ice_import_key = qcom_ice_tee_import_key,
+};
+
+static int optee_ctx_match(struct tee_ioctl_version_data *ver, const void *data)
+{
+	return ver->impl_id == TEE_IMPL_ID_OPTEE;
+}
+
+static int qcom_ice_tee_probe(struct tee_client_device *ice_dev)
+{
+	struct device *dev = &ice_dev->dev;
+	struct qcom_ice_tee_private *data;
+	struct tee_ioctl_open_session_arg sess_arg = {
+		.clnt_login = TEE_IOCTL_LOGIN_REE_KERNEL,
+	};
+	int ret;
+
+	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->ctx = tee_client_open_context(NULL, optee_ctx_match, NULL, NULL);
+	if (IS_ERR(data->ctx))
+		return -ENODEV;
+
+	export_uuid(sess_arg.uuid, &ice_dev->id.uuid);
+	ret = tee_client_open_session(data->ctx, &sess_arg, NULL);
+	if (ret < 0 || sess_arg.ret != 0) {
+		dev_err(dev,
+			"tee_client_open_session failed, ret=%d, err=0x%x\n",
+			ret, sess_arg.ret);
+		ret = ret ?: -EINVAL;
+		goto err_sess;
+	}
+
+	data->session_id = sess_arg.session;
+	dev_set_drvdata(dev, data);
+
+	qcom_ice_tee_ops.dev = dev;
+	ret = qcom_ice_tz_ops_register(&qcom_ice_tee_ops);
+	if (ret)
+		goto err_ops;
+
+	return 0;
+err_ops:
+	tee_client_close_session(data->ctx, data->session_id);
+err_sess:
+	tee_client_close_context(data->ctx);
+	return ret;
+}
+
+static void qcom_ice_tee_remove(struct tee_client_device *ice_dev)
+{
+	struct device *dev = &ice_dev->dev;
+	struct qcom_ice_tee_private *data = dev_get_drvdata(dev);
+
+	qcom_ice_tz_ops_unregister(&qcom_ice_tee_ops);
+	tee_client_close_session(data->ctx, data->session_id);
+	tee_client_close_context(data->ctx);
+}
+
+static const struct tee_client_device_id qcom_ice_tee_id_table[] = {
+	{UUID_INIT(0x29e87b9e, 0x012a, 0x4878,
+		   0xa1, 0xe1, 0xa1, 0xb9, 0x0a, 0x21, 0x5b, 0x16)},
+	{}
+};
+MODULE_DEVICE_TABLE(tee, qcom_ice_tee_id_table);
+
+static struct tee_client_driver qcom_ice_tee_driver = {
+	.probe		= qcom_ice_tee_probe,
+	.remove		= qcom_ice_tee_remove,
+	.id_table	= qcom_ice_tee_id_table,
+	.driver		= {
+		.name = "qcom-ice-tee",
+	},
+};
+
+module_tee_client_driver(qcom_ice_tee_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Qualcomm ICE TEE driver");

-- 
2.34.1

