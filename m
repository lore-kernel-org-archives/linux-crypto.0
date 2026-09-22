Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD28954CF65
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790081900; cv=none; b=geYQJq00DsLmd5pEvfZGV/aUmq2QtIbYE5CaHxO2vl4QCCExglbCeY/oMFZN0VxCqS7YFPyW1uuX13k58hlgC1ARLSWtqiN+1FkU3XnblSDX20QbAUp3xQGH1toHUbeXCe7zaVqrUdC85nOVWZstJplitkpQ3wRudAc5MeaCG8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790081900; c=relaxed/simple;
	bh=SZ2dL8TwrDpPKl/RZfPPK/8ppxvf49E+FLMHDVsmpq8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tu4HzDGTwJFskXtj2yGNVXVcocObBZNl8LvCmDiD13TyOyOaQWc/0jK6yXSYy02lyq0Dn+9JFiFZ/W7agk6Yj+P3cfP0980NVUJCXOrGWNYzKI9L2fJykccWN5l8EnDO1hZ08Dk0xj/aEy+kYEUyNhc2Tugz6RKt5rlh850to6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ahpZQs+h; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JwtEZMQc; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ahpZQs+h";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JwtEZMQc"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MBOxOq1145895
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:58:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XZGjRR4bE84GpahnnVxSpqzzsPWMTO6jcs8PAfT5Of0=; b=ahpZQs+hgJ4BnWqy
	r8zDxs3duzjY3RBW3GAIJNncaKRe0LvW9yrJhn+ao99tuVzozHn4/h154+nZnTcF
	U7b99wBu9IGObJslPHDGA5Trpi08MonY4f9+09ree4qTCKP080G7RgV3nv6bkm1b
	a/cLQQlRMmazgwTAypPLTnbwaFb3fTE//UPo6xy40rlHoZf7P4/1TckVB/4hrUnt
	XxpE60a0jtvGOsqD1bR1wnM+CWdzqsIP7Rd7MCMia1ChXTtZF5vDHlMYLudJOWAs
	zjB66mP4yRaBw6ZVeV4kgvney6Q9B56n3YnJu6WBpHNSdxTroLaVMBDhTt5zAWsE
	wj6IIw==
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com [209.85.221.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4guqycrjrq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:58:18 +0000 (GMT)
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5c83007a11cso1347904e0c.2
        for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 05:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790081897; x=1790686697; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XZGjRR4bE84GpahnnVxSpqzzsPWMTO6jcs8PAfT5Of0=;
        b=JwtEZMQcDtnRnXH705APLWDLWBJcxRlnDuyhh26e0dqXdiNMSZAEjqHwAQON5zhZWt
         lZvskgaYPbnxBIbdUP9dvS1xLXG44PhDF2A8AzRF89mG1df1F1l2UG22kn64n+T0vqaP
         whtAEX/udI9yzX86d9aIJivGgJVDl5/q2vugIL3IQiN9TvOuKNtMVAoGVkNokRPW6GF6
         SRi/nK8Q0r3qUCg4vyxgE145ACWsH4oj1W0bN2g8icVJIBqky48eGNKa9rNKsOWAc33z
         q8k3xfNH1CgT9o2J4Fbscv814jU9c8QnpTiVGPQsU4ade4uS+DgVStY7EHlJmYCBo+s7
         dLNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790081897; x=1790686697;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XZGjRR4bE84GpahnnVxSpqzzsPWMTO6jcs8PAfT5Of0=;
        b=TByC12X5y+QMHDw3AGg9xnqaVSoiiFs51GRVuP6QzRxyQRZsNnOdiCCKsDSv3Fc4tb
         JDmZJ6ISf31S88GMQINQUvaPGZJdwulpvgDoPfDrPOZnasXH4ePz1YsQxrIDSdLXx83e
         HZp53G7SCHs+FnnYwGr2R2MJr9t9Wdq5qa1hlOgB/1coLEKh5SDWKCtnbrnhY+sXhxaw
         lEL2lDT6m/T4nvRI3tAsXWKD/gWv3wyYb5HPVkufk1SDG9XJ9htQY34Jw3WlMDPPnfTA
         P/GE+sKCw76ObYwmogqnN0fwwpU2qeS7oOTO+VlY2OT9m4sk45LeoIe5eQOHwa2kGA7r
         SKxg==
X-Gm-Message-State: AFuF++nQJOwYbRnTG3vZ3Hv9Ee/AXbspdXECWbyMdUdGniVHeqYfHtJV
	VguwpJG/+BI35rT48pCQXMhAqcGUiKmQOb7Nl4Rqy+MtS2Mt4kEa1JSIG7XUaldx0Fu5i+JER02
	Fry52/EM3d0S0sKuMcC5Qyjl5ZMgxXuLwbjAAaZdUK9meBCfNwRoTl1n3DXdOFUIbaGg=
X-Gm-Gg: AYBFou3no0q//FSGP5Jk6uIufK5qzYlbfNCw7rabrXosH8g2b++lyTlz5lDpIzWmPo2
	RU4/qDeImkq1HzJNDnNf2EL0945Ia2jx593sKo6IlPXPNQFhfutrQO29QhudnHFFN+BcZmgpINt
	jGKfrXQ7brO7At+oUCkknsSSq+uH7brMe+OrNYUUZIttCz8w7ijuCzqoODbt7d/cRgC/0+4hPq9
	GrTwt4h6DBMut4XB0Ns8ILvdKsa1/xaP4vG5BCzpctnNBeVmDJZtfLgeQvmhk+YrW8SKJgR4lNp
	lU4clu53pxU3u0l92TIeJMJos94/rdlv7XqR0vDKiOU/dO+lgO2XeqLEIlb9zTcyv/2dS3A8jfq
	GFe39Sz9d8r2euvVos1e9TDFmxgk=
X-Received: by 2002:a05:6122:3b82:b0:5c9:a60b:e5d1 with SMTP id 71dfb90a1353d-5c9b5a027bamr7763474e0c.11.1790081897203;
        Tue, 22 Sep 2026 05:58:17 -0700 (PDT)
X-Received: by 2002:a05:6122:3b82:b0:5c9:a60b:e5d1 with SMTP id 71dfb90a1353d-5c9b5a027bamr7763442e0c.11.1790081896818;
        Tue, 22 Sep 2026 05:58:16 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:5105:ff9:e148:c440])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aaa4537b5dsm1097669a12.30.2026.09.22.05.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 05:58:15 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 22 Sep 2026 14:57:27 +0200
Subject: [PATCH v9 12/14] soc: qcom: add core driver for the Qualcomm
 Crypto Engine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-qce-fix-self-tests-v9-12-b1aa742e79af@oss.qualcomm.com>
References: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com>
In-Reply-To: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4833;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=SZ2dL8TwrDpPKl/RZfPPK/8ppxvf49E+FLMHDVsmpq8=;
 b=kA0DAAoBBZ0uy/82hMMByyZiAGqye0CjFATY8qRJUxSTrr+MR4MKk7y483DIvvUdG+Xfxslmr
 okCMwQAAQoAHRYhBJHlEy3ltUYde6Jl/AWdLsv/NoTDBQJqsntAAAoJEAWdLsv/NoTDvU4P/0g3
 ScrXNMzcgD5Nubh/LB92lMnZ1rh9sko3oqFnLkywoIYzu+dXEHCsh0HNoLTm9LBrYVIfqORos20
 GOD9KHsJotIc2yMiOHjoH9dr39j+GzkJm8y92uwHnpNa93AqIWsA8bNxewRQ/phrWXmRR+70wv4
 in7wuSo43KCEVNthQmYq5KBZ7fx4QWWQdaf3zqFofAp2JFAyvmNolIpDFwWvQPgUoB05XR4v5jv
 mz0Ek21ROJwdp57risy8zPZo87UpZqTgJyLmOqP5MdTD33Go1oGBlR6OXmuwRnIPrtN7Wwap6IJ
 QaXedjpXY+4KNJ9wsdpTa2qFFf+uYtmL+PR6qWVWYUqEsN8JixE9OktyCjRtTOv4HBQBhJOvr2a
 RapYdU9sxLiqFG2M+gZGd2B2LftOSnfBtRFunQeQYlh2J9t45Xp8NfZb/KmDvX+ClrtREcTmYR+
 3ewRVKu2UQk8zhYp4RQAwsK819nh7g5pm8Yxjb4zxkKFKdKsD5jcM4EKeIKSTqmZloIq4DO0ZxU
 +Odwwmq9UmdDVe9BkW+LXyrF81aTPbvCSOPNpzbukfcKbMcKpp0xBPedT3EvyjvVreuaMVBQ+sy
 bgkq0iKWdvrO7te3KaCtD6gOk9RL53zSCTAvAupyuiDRjeAWkgQ4fhiJHg/zK/9hoZz9oyyVrbY
 NNBOQ
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: VwXYxrEegP-VphG68FROa2e45nAs2Idr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDE4NyBTYWx0ZWRfX+xobFPtopc4X
 W4hkZ/hlvcE173glo/2F28tTwkzinwbUFH32UqO4YLt33BN2/wwQthxqcy8YHM5vb09UhyXu8HI
 6tDFiVtnG4sPT53N4MXTq/LSuIY8vJ3rrKgpmz2W6TAaBMO0v23/FaTMXocFtj1ac+W85uQe0SS
 BLg3cOtsxcQRQ4N/2vDnx38r7uHcWF7qJGH5TU3MtPQG4XezofxhMugDGoi7yU4MmZJ18e6dSrh
 j0Og+cl0knVyrT40CUI6a+7Z5B1/sJ9op3+sQkGzZnH24YnflVDOw4sVmuM6RV3O4i4PO8/uWRP
 EsWeN0QE4eG5yD/7uLXTYt2WcK8c+Ut0r/MjSOGI8w8kLulpxtFl3eSsYkNAeQ3BthnghMyhp6t
 ZRsMLYcmaQzuVlLRJ3YC8JIP7NX9zRon8sPr9gcE/XWle94Esvw9R79+m696ZsQr/h8F8vOMJ8z
 DMw4FT2XFH4WmvwwjzQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDE4NyBTYWx0ZWRfX/v7XKbazZwbG
 mvo+K/ppV+Pu7RkMnq2merpfCA1h5yTBorIeVc3Rl8Au4xRQ6mS+46YwWtrgsYLWD8XlgHfxMJC
 2QBl4JMBNGkZJGIuQR/UDES9/We3eSw=
X-Authority-Analysis: v=2.4 cv=c8I+0h9l c=1 sm=1 tr=0 ts=6ab27b6a cx=c_pps
 a=1Os3MKEOqt8YzSjcPV0cFA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8
 a=EhY2VP3nYDlqWzrqXREA:9 a=QEXdDO2ut3YA:10 a=hhpmQAJR8DioWGSBphRh:22
X-Proofpoint-ORIG-GUID: VwXYxrEegP-VphG68FROa2e45nAs2Idr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0 bulkscore=0
 adultscore=0 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220187

Add the core driver for the Qualcomm crypto engine. Its task is to bind
to the qce DT node, set up runtime PM for interconnect down-scaling and
register the auxiliary device using the crypto offloader driver.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/soc/qcom/Kconfig    | 11 ++++++
 drivers/soc/qcom/Makefile   |  1 +
 drivers/soc/qcom/qce-core.c | 92 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 104 insertions(+)

diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
index 2b524154d9fb331199fb162e43b0acfc03eced6b..859835a3dd1d98d1e4099f708d75f36ca89d3f3e 100644
--- a/drivers/soc/qcom/Kconfig
+++ b/drivers/soc/qcom/Kconfig
@@ -122,6 +122,17 @@ config QCOM_PMIC_GLINK
 	  Say yes here to support USB-C and battery status on modern Qualcomm
 	  platforms.
 
+config QCOM_CRYPTO_CORE
+	tristate "Qualcomm Crypto Engine core driver"
+	depends on PM
+	select AUXILIARY_BUS
+	help
+	  Core driver for the Qualcomm Crypto Engine. Say yes here to enable
+	  the top-level driver that binds to the devicetree node representing
+	  the QCE, registers the sub-devices implementing actual QCE
+	  functionalities and sets up runtime PM allowing the interconnects to
+	  scale down.
+
 config QCOM_RAMP_CTRL
 	tristate "Qualcomm Ramp Controller driver"
 	help
diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
index 798643be3590cc8303854658fd483b7807d2230f..33dfef07e7db2c0488b14c78f098afebf689d013 100644
--- a/drivers/soc/qcom/Makefile
+++ b/drivers/soc/qcom/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_QCOM_PMIC_GLINK)	+= pmic_glink.o
 obj-$(CONFIG_QCOM_PMIC_GLINK)	+= pmic_glink_altmode.o
 obj-$(CONFIG_QCOM_PMIC_PDCHARGER_ULOG)	+= pmic_pdcharger_ulog.o
 CFLAGS_pmic_pdcharger_ulog.o	:=  -I$(src)
+obj-$(CONFIG_QCOM_CRYPTO_CORE)	+= qce-core.o
 obj-$(CONFIG_QCOM_QMI_HELPERS)	+= qmi_helpers.o
 qmi_helpers-y	+= qmi_encdec.o qmi_interface.o
 obj-$(CONFIG_QCOM_RAMP_CTRL)	+= ramp_controller.o
diff --git a/drivers/soc/qcom/qce-core.c b/drivers/soc/qcom/qce-core.c
new file mode 100644
index 0000000000000000000000000000000000000000..8a9d070935cc87eaf20ae2db25f304cf4b2694c0
--- /dev/null
+++ b/drivers/soc/qcom/qce-core.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2026 Qualcomm Technologies, Inc. and/or its subsidiaries
+ */
+
+#include <linux/auxiliary_bus.h>
+#include <linux/device.h>
+#include <linux/device-id/of.h>
+#include <linux/err.h>
+#include <linux/interconnect.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+
+#define QCE_DEFAULT_MEM_BANDWIDTH 393600
+
+static const char *const qce_core_aux_devs[] = { "crypto", NULL };
+
+static int qce_core_probe(struct platform_device *pdev)
+{
+	static const char *const *subdev;
+	struct auxiliary_device *auxdev;
+	struct device *dev = &pdev->dev;
+	struct icc_path *mem_path;
+	int ret;
+
+	mem_path = devm_of_icc_get(&pdev->dev, "memory");
+	if (IS_ERR(mem_path))
+		return PTR_ERR(mem_path);
+
+	dev_set_drvdata(dev, mem_path);
+
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
+
+	PM_RUNTIME_ACQUIRE(dev, pm);
+	ret = PM_RUNTIME_ACQUIRE_ERR(&pm);
+	if (ret)
+		return ret;
+
+	for (subdev = qce_core_aux_devs; *subdev; subdev++) {
+		auxdev = __devm_auxiliary_device_create(dev, "qce", *subdev, NULL, 0);
+		if (IS_ERR(auxdev))
+			return PTR_ERR(auxdev);
+	}
+
+	return 0;
+}
+
+static int qce_core_runtime_suspend(struct device *dev)
+{
+	struct icc_path *mem_path = dev_get_drvdata(dev);
+
+	return icc_set_bw(mem_path, 0, 0);
+}
+
+static int qce_core_runtime_resume(struct device *dev)
+{
+	struct icc_path *mem_path = dev_get_drvdata(dev);
+
+	return icc_set_bw(mem_path, QCE_DEFAULT_MEM_BANDWIDTH,
+			  QCE_DEFAULT_MEM_BANDWIDTH);
+}
+
+static const struct dev_pm_ops qce_core_pm_ops = {
+	RUNTIME_PM_OPS(qce_core_runtime_suspend, qce_core_runtime_resume, NULL)
+	SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
+};
+
+static const struct of_device_id qce_core_of_match[] = {
+	{ .compatible = "qcom,crypto-v5.1" },
+	{ .compatible = "qcom,crypto-v5.4" },
+	{ .compatible = "qcom,qce" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, qce_core_of_match);
+
+static struct platform_driver qce_core_driver = {
+	.probe = qce_core_probe,
+	.driver = {
+		.name = KBUILD_MODNAME,
+		.of_match_table = qce_core_of_match,
+		.pm = pm_ptr(&qce_core_pm_ops),
+	},
+};
+module_platform_driver(qce_core_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Qualcomm crypto engine core driver");
+MODULE_ALIAS("platform:" KBUILD_MODNAME);
+MODULE_AUTHOR("Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>");

-- 
2.47.3

