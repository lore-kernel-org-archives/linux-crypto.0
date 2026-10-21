Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792597420;
	b=F65I/5HNpGzw0qNdq4mM1OScheoDJnh5Wc0cK34bFpTcPvL5cRUQMN3+fp7W9BRGq2c7
	 Hw2UU8nFOaIA1SgBGAbZ5V+yUq8sDy1xZNMDuD3qIBeNVZmTtyjNbsEYk03hGgYAen+0v
	 wlZIxYRoka7rC+wpS+YtZxwq68lDltMeZjycvEqbdkntnuS0gWougD1Qa559g1/MwA5Bi
	 d3rRu3pxZ8y+tupsFSmKO6aPbLOqKEZ2YBNZ+ZSyeJj4U5IvIYKn7zrBjpzHJsGFqmmd7
	 P+a+tyPP79TRV1cu+EYmsJYfWI0i56wrVg4JOCt0MyT/CgEg+3XT5QSA7yTJXZbDXyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792597420;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=PK1O9DLe2zPgJMY35B/jdWprIHSb/6My/ydSWK7Ng1I=;
	b=d/oy57iqFKiP6L21uCM4uuoBLEYxN7HZ0uEGgMMf6LicVjmOwvd4wCnFRca09TzXSJIg
	 0u6kkgjGn8TuW9WSyFbwz43aVuQhUALT+nnWjXOLL242KbpHWcSYyNIw/MWRhYiWY3zsZ
	 Tn8YeTVXCfT+R/I542He8L6Umro6pqXlCTBwZOUAvVcVwapb4c7i54SB2bxQan0LOyVQS
	 cabEMILgXQ2rNN7Z1EnuJFIxn6APUoeiq6G0jF3E/GtiSdczA902S1oC7AJ4Vwrzq3BJ4
	 ayCKtK5E5r6hDF2SDo0iGobEjP4/ARHA0/+b/u1x85/TidDA3kPHQZXCcLXIeQuP+DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=SJzcbxrk;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=hkhICCtZ;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBEB60A2601
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 15:43:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CBEB60A2601
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=SJzcbxrk;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=hkhICCtZ
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LFU0Ln3726131
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 15:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PK1O9DLe2zPgJMY35B/jdWprIHSb/6My/ydSWK7Ng1I=; b=SJzcbxrkM9dqPxpy
	57+YC7/Xz9kpNJ5h4KxPyJ4aD6jOQzcdFfQey3hRod0Yz42koCI8F0F+apUF+ZsS
	whocLkc6Hwa2GJKJ/glI1fVW9PBF7Q9Vc8JXKTSBeRghuZ566/1orctL99QRdrcz
	gklYN3s4kvoyyctMLBLyPD41/DANaHvohY1eTq52nVaN4LU1QIgwC3z/MeFX2BfC
	v0C58rhi0xAsdQ4wcy2vRqWmjE5b/iEwK01x8D9GZl879bynldhVtaxzcUqT+eWV
	huS2VYe+S33fQwcx5emaLVzx9N0qBDHUSGGaiKYOBHvwLeIzilGK40yD8lL6GqZ0
	caUHAQ==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hesy79v0n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 15:43:32 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3425098ae4bso40706eec.0
        for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 08:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792597412; x=1793202212; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PK1O9DLe2zPgJMY35B/jdWprIHSb/6My/ydSWK7Ng1I=;
        b=hkhICCtZ2okWYFEAo/477yTp8ZZdECyuLAXYE/TGV66orjwVf6OP7H2TJR+9haVKim
         BKkdOb3PKfhkYdAc02PXzwM32ACPhEsqv0qfhc9DOrTxyG0VKpAoaygBRlBwr3C4pPQp
         G/M5rjRi8QO8k4PMXkKyzSdS/lzDCytt5pEAtzWzni/05o8tlR+6CPc/lmkFYNkoe8PG
         toXmayPajDsrA7uxHCsyR1XNJp9VVSuG4PNSWWCiwNnK21s8PHaCFNsJxZldFLnf7rH9
         8zbNHDAm0FwkNdsC1lGcn7y4XG5Y/UV24pdOiFzgRs7Rvpm85EOsCEPIoBfB+gWWzBxw
         R5Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792597412; x=1793202212;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PK1O9DLe2zPgJMY35B/jdWprIHSb/6My/ydSWK7Ng1I=;
        b=O3LHu/jD0dGmcP+apEzG/XE4hiRN9nEGdDMtUdWc+LMeepfAwKvcXylon/mCCivfwB
         jqJkgmuTBovr/qhlf5yWd2m3vg5lDrR5yVJitKr6eKfXz6Hgba0ZFl04ayQud55XOKg5
         sFDDT3M0DyrG9+fnsO+o33mRPH0yrxcnZjpkUFd9IBoMf2QC2EXcpv7nh3snAoGCKMpr
         M3qBiEn1k+J2mZIFagCHkSJ3VM9lgtPouupKXE0wzbk1nyzbG7t3KQhYFoho1zm96nXb
         Fl5jn6oq+qQEKyEhpJJi4vdHy7k2u36KVCnTvKKwSCvwm1+ha0CXEJF5Lz88NLc/gyTO
         2XIw==
X-Forwarded-Encrypted: i=1; AKwUvBwStJL191RwS1Z1GTbh3BJTtiX7rS0Bvp0ZVxWgGjM0u8TKNCLX6ugHqA+7VATxCptqWxfNpcsge5Rhy/g=@vger.kernel.org
X-Gm-Message-State: AFq9FYLzMTRLsqLNDEX182jJdLly9t9hokcG6FVUwrs60cUxJoyPt8yW
	+8CCuMzx/8cXgrhPWw9M13tp4/U6rndYOCD5WgPJPHqoMhNOGHahBAKGlanO/HEUs6kB+9WtBLQ
	h9XxcKeonoYkvpH62TOSyUquLd6UkURfpMhesFl91Kfl/ggBlTqAFuPSmJrt/HHH8uFw=
X-Gm-Gg: AYBFou1/yF13h/EawY8wsSgxiz3JV2P14wN4AfSyPKp5IuaNSEkCaKfesn1yk/ZPqHi
	5kiChfIQwtSNqaz1lW5xafY7ZPX6MhDkwTC0AcBUkLoYqlUVrlU8DstiaRszWQE/v/kc2DyOV4R
	uPbmrjtkxksay2Sn8oiclFcD8k4uinLscxbrcyx1/2E6scH7DkwgFxQtZ1j9uB31Cxxp32Ufy9s
	D5mTOpYqUMinCE/78aolbmhrBejaGuIHiyt3kSPtHO321wVYaPeAs8q0ro6tg9KlBDb05VmQPT0
	nMU81tAVaTRGZ8BxWOQQ5aNTBgAEIms+V9G2iYFEXhKTR625vXFNXWmLG1Hkmdbt3+thHZUaIjP
	iRhoL+yMZCpJzgIhV20aWLJEq
X-Received: by 2002:a05:7022:419e:b0:185:e68c:904c with SMTP id a92af1059eb24-18dbe2af64bmr10406243c88.7.1792597411415;
        Wed, 21 Oct 2026 08:43:31 -0700 (PDT)
X-Received: by 2002:a05:7022:419e:b0:185:e68c:904c with SMTP id a92af1059eb24-18dbe2af64bmr10406192c88.7.1792597410688;
        Wed, 21 Oct 2026 08:43:30 -0700 (PDT)
Received: from hu-hdev-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1902f96dc4bsm7937768c88.0.2026.10.21.08.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 08:43:30 -0700 (PDT)
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 21:13:07 +0530
Subject: [PATCH 1/5] firmware: qcom: Add a generic ICE service
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
Message-Id: <20261021-ice-migrate-tee-svc-v1-1-b035be7aab0a@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792597401; l=10247;
 i=harshal.dev@oss.qualcomm.com; s=20251124; h=from:subject:message-id;
 bh=vfJmdr9eEKYwCZJp3EElKbzW79+lSOJNHBy6jnHe668=;
 b=dchV6/8fR7XW9p5INJZThG4HdgkSgTl2oUaBFr/zI8OKdt+qkGcKrVlO9KFygRmC3YThiKue0
 lps8+4IHKq6DcsZvuuMrJzJfS0MWmSrPThT0C7EXKOYB8I4aS8vxEUH
X-Developer-Key: i=harshal.dev@oss.qualcomm.com; a=ed25519;
 pk=SHJ8K4SglF5t7KmfMKXl6Mby40WczSeLs4Qus7yFO7c=
X-Proofpoint-GUID: akQiA_cmFMJltmHBW_QPc_4bm6gAyN0Y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA2MiBTYWx0ZWRfX5I+cXBBsp6zW
 MlRv+YSVB2adfb78ZauoOTGIoQhqK6VC5WF8dVXf/XKIFjxSxpqJqqViLXxeSr2ZP+LmPkhR1Bu
 wi7qEIv5L1JY+iiKwc/3VrI1fb72arawM06kVwvHA4tQh0EMcIt3XjIBaAQlNb57Mb25PXgSNX7
 khuki8veFImzKN/1fUxIyqjOFkNnBCd2/AiuQsBJLvyzr2WhiL6pgTKqsM4vOHB5mI07+bEyIkd
 WnZgJJ1shHWn1tT+JiesNWDMPlTsjmGOeYOwbM21udo7OgKGWGnTgm2N0aUC3cdTAsMyUksnOaz
 evEUWZLYZwq0uJq5dQLZ0nXjftNmgfzlAMjJSkHjHtH+Gb0kEdpa14l1eoGwQHOvCdYUDt1qG9Z
 SkhSxaYdjBkuEJHsh4o9EvhoBmqrnQA2WvGroDfOKpvZ+qfivLaD/eeB/yftVYfV5hJPRszdRTR
 ONEpAJlfyWv55VNk0Vg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA2MiBTYWx0ZWRfX4EHlhheQ+ttZ
 PBVa1wWe73nVmz9mayChLDxo0jqsNDo8fV04f0KqGIYJ3QC/XLAQl/u++SLyPm3AsAelsFqh6Sv
 D7g24CBAje7XiRv/pUW8qiWhxRjvDs8=
X-Proofpoint-ORIG-GUID: akQiA_cmFMJltmHBW_QPc_4bm6gAyN0Y
X-Authority-Analysis: v=2.4 cv=IPaXmQvG c=1 sm=1 tr=0 ts=6ad8dda4 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=FunFjVdMjTOM9eWGH8wA:9 a=QEXdDO2ut3YA:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-21_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210062

Qualcomm platforms such as the IQ-9075 EVK now boot with both QTEE and
OPTEE. However, the Qualcomm Inline Crypto Engine (ICE) driver
currently only makes SCM calls into QTEE. With the arrival of ICE
support on OPTEE for Qualcomm platforms, there is a need for a generic
layer which re-directs the call to the correct TEE at runtime.

Add a generic ICE service which acts as a common layer with different
TEE backends plugged in whether it's an SCM implementation or a proper
TEE bus based implementation (such as for OPTEE).

Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
---
 MAINTAINERS                            |   9 +++
 drivers/firmware/qcom/Kconfig          |   8 +++
 drivers/firmware/qcom/Makefile         |   1 +
 drivers/firmware/qcom/qcom_ice.c       | 125 +++++++++++++++++++++++++++++++++
 drivers/firmware/qcom/qcom_ice.h       |  51 ++++++++++++++
 include/linux/firmware/qcom/qcom_ice.h |  32 +++++++++
 6 files changed, 226 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f58a305de664..7a80b776896c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23007,6 +23007,15 @@ F:	Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
 F:	drivers/soc/qcom/ice.c
 F:	include/soc/qcom/ice.h
 
+QUALCOMM INLINE CRYPTO ENGINE TZ SERVICE
+M:	Harshal Dev <harshal.dev@oss.qualcomm.com>
+L:	linux-arm-msm@vger.kernel.org
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	drivers/firmware/qcom/qcom_ice.c
+F:	drivers/firmware/qcom/qcom_ice.h
+F:	include/linux/firmware/qcom/qcom_ice.h
+
 QUALCOMM INTERCONNECT BWMON DRIVER
 M:	Krzysztof Kozlowski <krzk@kernel.org>
 L:	linux-arm-msm@vger.kernel.org
diff --git a/drivers/firmware/qcom/Kconfig b/drivers/firmware/qcom/Kconfig
index 3ad22f8fc3e5..e2d1c17296c2 100644
--- a/drivers/firmware/qcom/Kconfig
+++ b/drivers/firmware/qcom/Kconfig
@@ -25,6 +25,14 @@ config QCOM_PAS_TEE
 	  Enable the generic Peripheral Authentication Service (PAS) provided
 	  by the firmware TEE implementation as the backend.
 
+config QCOM_ICE_SERVICE
+	tristate
+	help
+	  Enable the generic Inline Crypto Engine (ICE) service provided by
+	  firmware. It acts as a common layer with different TZ backends
+	  plugged in whether it's an SCM implementation or a TEE bus based
+	  ICE service implementation.
+
 config QCOM_SCM
 	tristate "Qualcomm PAS SCM interface driver" if ARCH_QCOM || COMPILE_TEST
 	select QCOM_PAS
diff --git a/drivers/firmware/qcom/Makefile b/drivers/firmware/qcom/Makefile
index 88ce74d74c3e..6403e8a17249 100644
--- a/drivers/firmware/qcom/Makefile
+++ b/drivers/firmware/qcom/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_QCOM_QSEECOM)	+= qcom_qseecom.o
 obj-$(CONFIG_QCOM_QSEECOM_UEFISECAPP) += qcom_qseecom_uefisecapp.o
 obj-$(CONFIG_QCOM_PAS)		+= qcom_pas.o
 obj-$(CONFIG_QCOM_PAS_TEE)	+= qcom_pas_tee.o
+obj-$(CONFIG_QCOM_ICE_SERVICE)	+= qcom_ice.o
diff --git a/drivers/firmware/qcom/qcom_ice.c b/drivers/firmware/qcom/qcom_ice.c
new file mode 100644
index 000000000000..2e42d70c855a
--- /dev/null
+++ b/drivers/firmware/qcom/qcom_ice.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
+ */
+
+#include <linux/firmware/qcom/qcom_ice.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "qcom_ice.h"
+
+static struct qcom_ice_ops *ops_ptr;
+
+bool qcom_ice_svc_ops_registered(void)
+{
+	/*
+	 * The barrier for ops_ptr is intended to synchronize the data stores
+	 * for the ops data structure when client drivers are in parallel
+	 * checking for ICE service availability.
+	 */
+	return !!smp_load_acquire(&ops_ptr);
+}
+EXPORT_SYMBOL_GPL(qcom_ice_svc_ops_registered);
+
+bool qcom_ice_svc_available(void)
+{
+	if (!ops_ptr)
+		return false;
+
+	return ops_ptr->is_ice_available(ops_ptr->dev);
+}
+EXPORT_SYMBOL_GPL(qcom_ice_svc_available);
+
+int qcom_ice_svc_invalidate_key(u32 index)
+{
+	if (!ops_ptr)
+		return -ENODEV;
+
+	return ops_ptr->ice_invalidate_key(ops_ptr->dev, index);
+}
+EXPORT_SYMBOL_GPL(qcom_ice_svc_invalidate_key);
+
+int qcom_ice_svc_set_key(u32 index, const u8 *key, u32 key_size,
+			 enum qcom_ice_cipher cipher, u32 data_unit_size)
+{
+	if (!ops_ptr)
+		return -ENODEV;
+
+	return ops_ptr->ice_set_key(ops_ptr->dev, index, key, key_size,
+					cipher, data_unit_size);
+}
+EXPORT_SYMBOL_GPL(qcom_ice_svc_set_key);
+
+bool qcom_ice_svc_has_wrapped_key_support(void)
+{
+	if (!ops_ptr)
+		return false;
+
+	return ops_ptr->ice_has_wrapped_key_support(ops_ptr->dev);
+}
+EXPORT_SYMBOL_GPL(qcom_ice_svc_has_wrapped_key_support);
+
+int qcom_ice_svc_derive_sw_secret(const u8 *eph_key, size_t eph_key_size,
+				  u8 *sw_secret, size_t sw_secret_size)
+{
+	if (!ops_ptr)
+		return -ENODEV;
+
+	return ops_ptr->ice_derive_sw_secret(ops_ptr->dev, eph_key, eph_key_size,
+					 sw_secret, sw_secret_size);
+}
+EXPORT_SYMBOL_GPL(qcom_ice_svc_derive_sw_secret);
+
+int qcom_ice_svc_generate_key(u8 *lt_key, size_t lt_key_size)
+{
+	if (!ops_ptr)
+		return -ENODEV;
+
+	return ops_ptr->ice_generate_key(ops_ptr->dev, lt_key, lt_key_size);
+}
+EXPORT_SYMBOL_GPL(qcom_ice_svc_generate_key);
+
+int qcom_ice_svc_prepare_key(const u8 *lt_key, size_t lt_key_size,
+			     u8 *eph_key, size_t eph_key_size)
+{
+	if (!ops_ptr)
+		return -ENODEV;
+
+	return ops_ptr->ice_prepare_key(ops_ptr->dev, lt_key, lt_key_size,
+				    eph_key, eph_key_size);
+}
+EXPORT_SYMBOL_GPL(qcom_ice_svc_prepare_key);
+
+int qcom_ice_svc_import_key(const u8 *raw_key, size_t raw_key_size,
+			    u8 *lt_key, size_t lt_key_size)
+{
+	if (!ops_ptr)
+		return -ENODEV;
+
+	return ops_ptr->ice_import_key(ops_ptr->dev, raw_key, raw_key_size,
+				   lt_key, lt_key_size);
+}
+EXPORT_SYMBOL_GPL(qcom_ice_svc_import_key);
+
+void qcom_ice_svc_ops_register(struct qcom_ice_ops *ops)
+{
+	if (!qcom_ice_svc_ops_registered())
+		/* Paired with smp_load_acquire() in qcom_ice_svc_ops_registered() */
+		smp_store_release(&ops_ptr, ops);
+	else
+		pr_err("qcom_ice: ops already registered (%s), rejecting %s\n",
+		       ops_ptr->drv_name, ops->drv_name);
+}
+EXPORT_SYMBOL_GPL(qcom_ice_svc_ops_register);
+
+void qcom_ice_svc_ops_unregister(struct qcom_ice_ops *ops)
+{
+	if (READ_ONCE(ops_ptr) == ops)
+		/* Paired with smp_load_acquire() in qcom_ice_svc_ops_registered() */
+		smp_store_release(&ops_ptr, NULL);
+}
+EXPORT_SYMBOL_GPL(qcom_ice_svc_ops_unregister);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Qualcomm ICE service");
diff --git a/drivers/firmware/qcom/qcom_ice.h b/drivers/firmware/qcom/qcom_ice.h
new file mode 100644
index 000000000000..aefaf1ecc3df
--- /dev/null
+++ b/drivers/firmware/qcom/qcom_ice.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
+ */
+
+#ifndef __QCOM_ICE_INT_H
+#define __QCOM_ICE_INT_H
+
+#include <linux/firmware/qcom/qcom_ice.h>
+
+struct device;
+
+/**
+ * struct qcom_ice_ops - Qcom ICE service backend ops
+ * @drv_name:                    ICE backend driver name.
+ * @dev:                         ICE backend device pointer.
+ * @is_ice_available:            ICE service available callback.
+ * @ice_invalidate_key:          Invalidate keyslot callback.
+ * @ice_set_key:                 Program keyslot callback.
+ * @ice_has_wrapped_key_support: Wrapped-key support callback.
+ * @ice_derive_sw_secret:        Derive software secret callback.
+ * @ice_generate_key:            Generate wrapped key callback.
+ * @ice_prepare_key:             Prepare wrapped key callback.
+ * @ice_import_key:              Import wrapped key callback.
+ */
+struct qcom_ice_ops {
+	const char *drv_name;
+	struct device *dev;
+	bool (*is_ice_available)(struct device *dev);
+	int (*ice_invalidate_key)(struct device *dev, u32 index);
+	int (*ice_set_key)(struct device *dev, u32 index, const u8 *key,
+			   u32 key_size, enum qcom_ice_cipher cipher,
+			   u32 data_unit_size);
+	bool (*ice_has_wrapped_key_support)(struct device *dev);
+	int (*ice_derive_sw_secret)(struct device *dev, const u8 *eph_key,
+				    size_t eph_key_size, u8 *sw_secret,
+				    size_t sw_secret_size);
+	int (*ice_generate_key)(struct device *dev, u8 *lt_key,
+				size_t lt_key_size);
+	int (*ice_prepare_key)(struct device *dev, const u8 *lt_key,
+			       size_t lt_key_size, u8 *eph_key,
+			       size_t eph_key_size);
+	int (*ice_import_key)(struct device *dev, const u8 *raw_key,
+			      size_t raw_key_size, u8 *lt_key,
+			      size_t lt_key_size);
+};
+
+void qcom_ice_svc_ops_register(struct qcom_ice_ops *ops);
+void qcom_ice_svc_ops_unregister(struct qcom_ice_ops *ops);
+
+#endif /* __QCOM_ICE_INT_H */
diff --git a/include/linux/firmware/qcom/qcom_ice.h b/include/linux/firmware/qcom/qcom_ice.h
new file mode 100644
index 000000000000..c3d93259c72a
--- /dev/null
+++ b/include/linux/firmware/qcom/qcom_ice.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
+ */
+
+#ifndef __QCOM_TZ_ICE_H
+#define __QCOM_TZ_ICE_H
+
+#include <linux/types.h>
+
+enum qcom_ice_cipher {
+	QCOM_ICE_CIPHER_AES_128_XTS = 0,
+	QCOM_ICE_CIPHER_AES_128_CBC = 1,
+	QCOM_ICE_CIPHER_AES_256_XTS = 3,
+	QCOM_ICE_CIPHER_AES_256_CBC = 4,
+};
+
+bool qcom_ice_svc_ops_registered(void);
+bool qcom_ice_svc_available(void);
+int qcom_ice_svc_invalidate_key(u32 index);
+int qcom_ice_svc_set_key(u32 index, const u8 *key, u32 key_size,
+			 enum qcom_ice_cipher cipher, u32 data_unit_size);
+bool qcom_ice_svc_has_wrapped_key_support(void);
+int qcom_ice_svc_derive_sw_secret(const u8 *eph_key, size_t eph_key_size,
+				  u8 *sw_secret, size_t sw_secret_size);
+int qcom_ice_svc_generate_key(u8 *lt_key, size_t lt_key_size);
+int qcom_ice_svc_prepare_key(const u8 *lt_key, size_t lt_key_size,
+			     u8 *eph_key, size_t eph_key_size);
+int qcom_ice_svc_import_key(const u8 *raw_key, size_t raw_key_size,
+			    u8 *lt_key, size_t lt_key_size);
+
+#endif /* __QCOM_TZ_ICE_H */

-- 
2.34.1

