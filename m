Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792597424;
	b=NuPOxAWjRpKl9IwcU+fUHzlC+MEugkki9D04+nsmzSlPkkLwDGDLk09tUbwSkWSahlHM
	 tvt5ilHWO64hgcs33epVw16SJqlFTfDG4mvWkc0fIBaljwkMji8dy8m1TCnO4T2oO+pvd
	 ei20tCo6anGgZel79MmqLyVwGTAyni12wJUH+/1jx2X7QVEzVQivamwd1NVxnvWkTAxS5
	 dUGvJPghEpcnlcYfLc+eyhdutN1MjA6GA2nF7E+b3nyyQIQeqeynb9zCT/BHxdUG7hrTK
	 9zVJWAsJABNGyBeTFCWv2jkX8QSDcbKz8Tpe7Et2qJEXntIrPQqhpuagvtUhAkbIhiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792597424;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=7/aF8g01Trbdxz8TZjbr9PZplLDUT8OZook3IGPzEqc=;
	b=jh90s7yi2zEQ+FF73VndfWIR3xR+jF4N9cHCkhD63jEU5qd42lEnkdVm47xPfexWZ2W4
	 LWqKlZxyh/twFJfYdJZf08TjOw9MZTg8zWVvf2AvCbreUO5fw0+TYoG9y1tnJ5L/lcjcb
	 9r4LdmPu3aYhhis5iDzTSyCPw4sulqbzu6cCmrZYNdj62u9QIlUHgh9WxboAB+RwUuqDn
	 U7IWfTnRmq48F0Dm4UcSLxLWia6Kq3ZeQbIVMTQtj8inQCm4CtRWpF1jw374do5LCJgrH
	 2CF1av++NyCxeTD1nBOfEtoGi7dydRsFnTo2VOEL9TczkpR8NXEOJxTbXMw+4lkNktw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ATT8dEPL;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="a/AKCV4f";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED10A60A5BC5
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 15:43:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED10A60A5BC5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=ATT8dEPL;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=a/AKCV4f
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LFTqrg2071153
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 15:43:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7/aF8g01Trbdxz8TZjbr9PZplLDUT8OZook3IGPzEqc=; b=ATT8dEPLOVtcZ/GT
	5c4qYDbF30/M4HlZbwrep4CbQbcmIcaqP77yYf4WhgjGx3lBhl/iiMzQK0H7h5Xq
	lhg/FVgG94JtUM+75ND9RKjCeRZnM0x/wveE+3WvAJOEIT2VPmYCdvQk5UrO+d4r
	2q991aC6sYupCA4lym2u3FwO98fVM0FgeGYIC3o34TPXDU4QhkkVXR6phhokz6Rd
	GzfXmqKUGU66gEnm+gSYVaJ79bwOzZ5xbZrl17bmqTH0E9WvxnwhzqdYzY6fVzGP
	cNjh869+o8beRQgCelC/QgCvQhlukeU4QRvkxmhgfgaZLIZ/KMCbCMMcfri+vKiw
	I2ScYw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4heda4vqsq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 15:43:43 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-33713e5e6daso1423030eec.0
        for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 08:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792597422; x=1793202222; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7/aF8g01Trbdxz8TZjbr9PZplLDUT8OZook3IGPzEqc=;
        b=a/AKCV4fodods1iUzafRvdQjqKVLh7DH1vYU3+t80hay5kCl0DBnErRn1EUhfFFP+T
         RbTpuuCB4zBNACrPcdreMGjuPAOfAaanTzHF/f4dDPKBipSydjCFKaURg0//H1veHgLB
         toLs0e9DDMnXst8l5jwNe6C73itUBZx/5FR34fDBRSHJoznhGBL/mXiGjX+PrziKregK
         4iVxFF1NxM9DTlaObJqvpX3vCJv9QloZJpfmO2Fbmei0BJE/g1/F3ezF1UT4sIP3lCh4
         rrOkndZTf/tR1LRNqLQQHS+zOVG8NEqq5AyLGEmD9lfeXZLNhkIxblqOPAnmOKM1PaRJ
         nnSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792597422; x=1793202222;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7/aF8g01Trbdxz8TZjbr9PZplLDUT8OZook3IGPzEqc=;
        b=mRquXTk2oU4pkIB9hy5GfxaowoWu0KXmYMnQv+3eMhVXXfvrSmqT97TCZlUB8cggl8
         1o0RBoc9ssavgbZ0s7Dv8HwuGONacfuQPZAYz2822dCSa/jAPbJfGepxjle2ycPEEq4p
         ddv3S0ynp1InDZZwV41+EqFSrTucT6qTSlDbdzbxCNHCvnzs6C92/wYRz2QK1PmhpJij
         PieYx1fC2N2G7LpdPzOPzAl22OK1ln1lrWdWvhTP1wY0nblLL5hp9P+6p4Rz6W8ej6X3
         SpKC+tm9BcVpu3mQVGTem9urc3ShBsfu0HHS7PuJX6K8TaGRRMt5fg51EFy1Ng5OhvZR
         GJVw==
X-Forwarded-Encrypted: i=1; AKwUvBy13C2dXwf0S6Yh5EQzvMKorokYz0JxHxZRM7K7tWT2xSwkwwI48p26ERl0VMtghu5vFOpkPFkcY/ORxnM=@vger.kernel.org
X-Gm-Message-State: AFq9FYIKVi5W0G59tHrOuOBU7G+YYjiClY5IVPQvCtA+KChf8HxlDivr
	fGLwVnySoO/4hxHqKCrOEvyOixgqcuO6ho8D2xHltw1s3WlGyNeLcnjn+eQaT8yTDxh3gEv6N4s
	huFK+EBNcaDgH+JWba5abHJapNwZu5GDmaTpyHd6IiacHvDNhibXG9M625df4gajxpaU=
X-Gm-Gg: AYBFou3YpzcWnObTGplytUepdAt1tqbpcCGuD7MD8BMKWiJMxUCoQL99v4kcX2tBkRt
	Zvl/qf9MEaoMVZDuAPRHnwmYDnVOGiNc0UW9VV6GTa5JhysDkmg7Lgi4p7xMZkSc9dwkEsiDPzO
	JtlRIVla/L4AbNP/rHQmn6Pz8VbET6/UlVRYzDkTxLMps9ZgOcfRPGqIh4WOu3JR7uxOQ37bt8p
	n04/brBTTN69JGpmLU0lC/Um+QiWt5K/eDTwF+yJQVSS1eplUcin7j/XDmuZvNtg9sLGH1xpXUF
	UO2Ch67LSyiRH49wYNUBl3lxP6hBblKlD+8kjxu7htXGiJdu5TKydUakvi6Df2QKRpT4lHQV163
	ppQdBI9+eUWEK5D9kT9pm9fUh
X-Received: by 2002:a05:7022:ec8a:b0:168:fe32:35a with SMTP id a92af1059eb24-190a57ac54dmr3475734c88.20.1792597421178;
        Wed, 21 Oct 2026 08:43:41 -0700 (PDT)
X-Received: by 2002:a05:7022:ec8a:b0:168:fe32:35a with SMTP id a92af1059eb24-190a57ac54dmr3475677c88.20.1792597420487;
        Wed, 21 Oct 2026 08:43:40 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1902f96dc4bsm7937768c88.0.2026.10.21.08.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 08:43:40 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 21:13:09 +0530
Subject: [PATCH 3/5] firmware: qcom: Add an TEE bus based ICE back-end
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
Message-Id: <20261021-ice-migrate-tee-svc-v1-3-b035be7aab0a@oss.qualcomm.com>
References: <20261021-ice-migrate-tee-svc-v1-0-b035be7aab0a@oss.qualcomm.com>
In-Reply-To: <20261021-ice-migrate-tee-svc-v1-0-b035be7aab0a@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792597401; l=12871;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=fja1EocfzMIrsKQbYh7D32xrr8xUrvqluhCasdjihlA=;
 b=Ak50a0lT/3tGCVjFCofD/Oo2BPV/Kx73AbD+TUAL69VdxGSKsZcTn/7MSG/NXD31C0pSLOWz6
 lwalL8w06flClIa9/ag8lVwMFXyTFqZmd2VSUIdbcvDGpWuV7qvURC+
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-ORIG-GUID: OoC-B3UpdZEVgh-U3XeoO3UYyBpuRIui
X-Proofpoint-GUID: OoC-B3UpdZEVgh-U3XeoO3UYyBpuRIui
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA2MiBTYWx0ZWRfX0cH6pMSZyuFH
 gAKlpRIHDoK+5IHq7ZCPhZob4rvWOuJFRjOS6zdDv8ygoW5ho0Fy38mnAwS3u8hOFQMmrnhyaU0
 UhdBeLCG+uGvrvHm8PHC+UZO/J2vuk4=
X-Authority-Analysis: v=2.4 cv=R7aWitRX c=1 sm=1 tr=0 ts=6ad8ddaf cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=wV6y_F6WGLPFbETn8MUA:9 a=QEXdDO2ut3YA:10
 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA2MiBTYWx0ZWRfX5WVNcDrBiaYn
 K0ztoIu9AK2+o5r+rX7hmq+i0pS5X0mmU19QfwO6jsisZrWuChVZ+LcUbc/7OmbK4Br0VDPAKw+
 XBBXYuHExlclJWRD+Ik0cd2mki2tStERN2q2s5Yhg3VX+YnCCwSO0MJA5T65JHiW/PVe9urrJYa
 KEOzpV+4UINuQA0zxzo7+CE9/+sOLCosU3qGkmoJ/+bfaDrOxWsbVSE0Z+wFVq3JlMyQZqISKZg
 rwLnfDvBcPrBUXWuTqiOEJKg7hcSo0I+OJDNTjzj6KajuItV5gH1sJWdIl2bBHUNYBI6317MvRP
 iwVaHdnnwhRB+htexz+RCtOM9r9SBF+SmDmuT/g2B7Q/04DoBIg9Pb+yPQoZxChmPGUUhlFk71J
 MmZRnQVA/AxIFHRs7RbfeQcN2kNuuYsXNl/GEyfWOdPdEaDNAEEx+i28Xbjpu38Z3YLnTvE+Kja
 5ZseKGuJNPPSjzJFiLw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 spamscore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610210062

Add support for a TEE client driver which forwards calls from the Inline
Crypto Engine (ICE) service (invoked by the ICE driver) to the OPTEE ICE
Psuedo-TA.

The ICE PTA supports both ICE Legacy and Standard modes. In Standard mode
Hardware Key Manager v1 is supported.

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 MAINTAINERS                          |   1 +
 drivers/firmware/qcom/Kconfig        |  10 +
 drivers/firmware/qcom/Makefile       |   1 +
 drivers/firmware/qcom/qcom_ice_tee.c | 384 +++++++++++++++++++++++++++++++++++
 4 files changed, 396 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7a80b776896c..d5d4f1ca85b2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23014,6 +23014,7 @@ L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	drivers/firmware/qcom/qcom_ice.c
 F:	drivers/firmware/qcom/qcom_ice.h
+F:	drivers/firmware/qcom/qcom_ice_tee.c
 F:	include/linux/firmware/qcom/qcom_ice.h
 
 QUALCOMM INTERCONNECT BWMON DRIVER
diff --git a/drivers/firmware/qcom/Kconfig b/drivers/firmware/qcom/Kconfig
index 6cde1704dbc7..bb67bd93cc51 100644
--- a/drivers/firmware/qcom/Kconfig
+++ b/drivers/firmware/qcom/Kconfig
@@ -33,6 +33,16 @@ config QCOM_ICE_SERVICE
 	  plugged in whether it's an SCM implementation or a TEE bus based
 	  ICE service implementation.
 
+config QCOM_ICE_TEE
+       tristate
+       select QCOM_ICE_SERVICE
+       depends on TEE
+       depends on !CPU_BIG_ENDIAN
+       default m if ARCH_QCOM
+       help
+         Enable the generic Inline Crypto Engine (ICE) firmware service TEE
+         implementation as a backend.
+
 config QCOM_SCM
 	tristate "Qualcomm PAS SCM interface driver" if ARCH_QCOM || COMPILE_TEST
 	select QCOM_PAS
diff --git a/drivers/firmware/qcom/Makefile b/drivers/firmware/qcom/Makefile
index 6403e8a17249..db9c9823420b 100644
--- a/drivers/firmware/qcom/Makefile
+++ b/drivers/firmware/qcom/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_QCOM_QSEECOM_UEFISECAPP) += qcom_qseecom_uefisecapp.o
 obj-$(CONFIG_QCOM_PAS)		+= qcom_pas.o
 obj-$(CONFIG_QCOM_PAS_TEE)	+= qcom_pas_tee.o
 obj-$(CONFIG_QCOM_ICE_SERVICE)	+= qcom_ice.o
+obj-$(CONFIG_QCOM_ICE_TEE)     += qcom_ice_tee.o
diff --git a/drivers/firmware/qcom/qcom_ice_tee.c b/drivers/firmware/qcom/qcom_ice_tee.c
new file mode 100644
index 000000000000..b7434f19e6eb
--- /dev/null
+++ b/drivers/firmware/qcom/qcom_ice_tee.c
@@ -0,0 +1,384 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
+ */
+
+#include <linux/firmware/qcom/qcom_ice.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/tee_drv.h>
+#include <linux/uuid.h>
+
+#include "qcom_ice.h"
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
+		goto out;
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
+out:
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
+			goto out;
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
+			goto out;
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
+		goto out;
+	}
+
+	if (out && out_size) {
+		buf = tee_shm_get_va(out_shm, 0);
+		if (IS_ERR(buf)) {
+			ret = PTR_ERR(buf);
+			goto out;
+		}
+		memcpy(out, buf, out_size);
+		memzero_explicit(buf, out_size);
+	}
+out:
+	if (in_shm && !IS_ERR(in_shm)) {
+		buf = tee_shm_get_va(in_shm, 0);
+		if (!IS_ERR(buf))
+			memzero_explicit(buf, in_size);
+		tee_shm_free(in_shm);
+	}
+	if (out_shm && !IS_ERR(out_shm))
+		tee_shm_free(out_shm);
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
+		goto out;
+	}
+
+	buf = tee_shm_get_va(key_shm, 0);
+	out_size = param[0].u.memref.size;
+
+	memcpy(lt_key, buf, lt_key_size);
+	memzero_explicit(buf, out_size);
+out:
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
+static bool qcom_ice_tee_available(struct device *dev)
+{
+	return true;
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
+		goto out;
+	}
+
+	has_support = param[0].u.value.a;
+out:
+	return has_support;
+}
+
+static struct qcom_ice_ops qcom_ice_ops_tee = {
+	.drv_name = "qcom-ice-tee",
+	.is_ice_available = qcom_ice_tee_available,
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
+	int ret, err = -ENODEV;
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
+		err = ret ?: -EINVAL;
+		goto out_ctx;
+	}
+
+	data->session_id = sess_arg.session;
+	dev_set_drvdata(dev, data);
+
+	qcom_ice_ops_tee.dev = dev;
+	qcom_ice_svc_ops_register(&qcom_ice_ops_tee);
+
+	return ret;
+out_ctx:
+	tee_client_close_context(data->ctx);
+
+	return err;
+}
+
+static void qcom_ice_tee_remove(struct tee_client_device *ice_dev)
+{
+	struct device *dev = &ice_dev->dev;
+	struct qcom_ice_tee_private *data = dev_get_drvdata(dev);
+
+	qcom_ice_svc_ops_unregister(&qcom_ice_ops_tee);
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
+static struct tee_client_driver optee_ice_tee_driver = {
+	.probe		= qcom_ice_tee_probe,
+	.remove		= qcom_ice_tee_remove,
+	.id_table	= qcom_ice_tee_id_table,
+	.driver		= {
+		.name		= "qcom-ice-tee",
+	},
+};
+
+module_tee_client_driver(optee_ice_tee_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Qualcomm ICE TEE driver");

-- 
2.34.1

