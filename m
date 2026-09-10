Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EEA4915AB
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789045310; cv=none; b=Y7t3MnfLpWbW8rW4J/YV52i9G0OY4HWL+piSGOpARRla7lS70hkV9JwEoic4phLkeTbbW+zKOC4d1hgQZAlEr8Yv0Mqj+JyizzqF5hu1y4bzqbp9rH2lpeOoon2zACRXh1TN85sQwm6Tz/QCByFxAxfjRO1jFMY0XdtrRDQwJXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789045310; c=relaxed/simple;
	bh=vd5H/xImeYjTu+utvQUws4xVG15wDIeOJYRAn2MwOYc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=a6H1x95EgvP/EW6+MOBstz8rIKkZtZcLnx27ec/hO/Lehxrsz6ErLs7i5R9w/I8vq+f5cKe7/NgaCFr5go/A9SDKKh9qMX1fym4KRxIjF0hoNDDs39XcM0lHOMXntOmZMvcOsMcJrTmtxj7/ApGdn00I4PdIC38jV5LwY79gep4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=L0QILee/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QoxfsZRI; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="L0QILee/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QoxfsZRI"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AC7jsk1241990
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GDqvvL/QEdH2j6dVRoAeWH/JNTn7jK0fTxmvAeyTbL8=; b=L0QILee/qYEroYHm
	UD5gCIyOR8HuSKn8QM+OCwI+ccQ6/H4lchBi1Y3UnTv4DHe1+X1gppkuf4Xlao/B
	xW/+f0EGwlwxtgB9VxAlHTLj+SBZlAMfQGWOlnGsgzlxQAtCknTJc+bBQs9ovI3b
	qaQldVOrHb9u/FSLDypTbY2GC215M74e3/kLEclrnErMR+xdoLLStd6lD6f4UYIv
	b0ILllt0YqPpCdc6Jhc5KFQ3ygGklIA+bjrO2FO/JDApQlzXqxwSy33hSJbuwwD0
	97vdfg2NXG7ogNZMhMVW6jqXNbfcVRHHqGxXFUlm/DrJCMMIIhRGJth0XOdAJZw4
	mNDnzA==
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com [209.85.222.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gkrcjs7ep-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:46 +0000 (GMT)
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-97e9e2deaa4so5181854241.1
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 06:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789045306; x=1789650106; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GDqvvL/QEdH2j6dVRoAeWH/JNTn7jK0fTxmvAeyTbL8=;
        b=QoxfsZRITrlZyDQxWvYphnCdaFpWQzseKhoRP8csg9XEDwWeNJi64qCsamZdBdUgcJ
         w2GMwe+HkMHTuTePEB7dzP92UaHQwvOD91Irw2vVnnBJfPspTfoaDfRn5hmSkmA+JxED
         OMZn6NMp1+zoG6re91PrZK2qwjRwH1foyLsZ2/7SFLaDp1ugymL/7ReO8uZFmbCXAwDN
         7iKGIA8IDu+IiCwrYWIGRpXPSs1wRdnbrLIndzY/BnIvV7ju1e49zb5iJSwoKQ/LHOUI
         nR7ORpO9LKo+xa41POKU2G7xOXDlRX9iG0gsCRd6TOgJCMBSsoU+voPcenS7zk/Tjan8
         1Qbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789045306; x=1789650106;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GDqvvL/QEdH2j6dVRoAeWH/JNTn7jK0fTxmvAeyTbL8=;
        b=NTtHNp5AROudEEx3o/YGgTFLDqFMtVhNaC9DIX6XvSM7rq/Y1fOpD6psEHWjANpQnE
         ZN0qrfHkopoAng3YSsKUOqFbqWcg3J8xGtRIcQg25gMAO4vRywB6ePOyfgow6+IuMZGm
         tvotEy88RtutR540yXjUxPqZEBQbCsOrUdCIdx1PuXw40QasvTNlf9UuF/6lpgAbXvYv
         A9HU2t+LHD9F3sXkEtF7azIQZ0LVG2ZkoO2zIUodPWgqT4MFUcmZYhjUnT0sWNQCsDoB
         Azl7HFu+mTn1ZNLZRayUUKJ2mlOZTHQ5RanHxLgnaJLVyDHeyX70h1CkAhaxy4ZJf/xr
         00kQ==
X-Gm-Message-State: AFuF++l6s86nGKyZjVb4tlwSwJohuxogRPf+rnyjJJeIi6eFMs39yNi2
	uJvbQN5xWsdTT1WAUArxpS0MuD2YuX5q6VNhepYUDqLShDEA6OS8JSu+tlCZbMtDQlfyXy4HBJJ
	cl+HiQvKxl30Fkx5tZGinKg29QtQaH0U9ektYNqM0sHfkQDaYZsTnW4VmhQcwYK7FACZdej77pm
	o=
X-Gm-Gg: AYBFou1eENRRy1BXqN6zHOs3A3ioTdMhpERwuo4dj6GnfMH8tZQAAdFYqM+20CO49e+
	0WlmFZb0p0zFB5BLaL8ib6lf+egDwAPsfryYBNmqX7hy815V/ECTJbQIJl11U/8D55LNzHxdeXp
	W9NWQJADGR51L8Z4SRbNAZ+KCNnBAOeA4IJMz+6/3d/OrTgVuZ1H9mnKAz2UQ6dPNWkUd2PYTJ5
	uLFxie0s/qGbNilMjxo2en6vo2zbmj/HlCK83dcKCeBmwVro2BseMyrGrJShHPnLuGhZFnS+vnN
	fgyxWG9sQq9dD1MEOs+zIaeYU417g5GWZhgxnLHmAR1m64+lVGZZcy68C0A6hPZ86ZjQxTfzrO+
	Vih3UQwiDJPHzmAZnXqQbnwqkwY83
X-Received: by 2002:a05:6102:3749:b0:785:eb33:87aa with SMTP id ada2fe7eead31-78a4a8b86a5mr21080238137.5.1789045303905;
        Thu, 10 Sep 2026 06:01:43 -0700 (PDT)
X-Received: by 2002:a05:6102:3749:b0:785:eb33:87aa with SMTP id ada2fe7eead31-78a4a8b86a5mr21080083137.5.1789045303344;
        Thu, 10 Sep 2026 06:01:43 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:c9b1:abfb:f300:5e98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c26204ecdbcsm831849866b.25.2026.09.10.06.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 06:01:42 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 15:00:52 +0200
Subject: [PATCH v7 11/12] soc: qcom: add core driver for the Qualcomm
 Crypto Engine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-qce-fix-self-tests-v7-11-cdbd2718af14@oss.qualcomm.com>
References: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
In-Reply-To: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4666;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=vd5H/xImeYjTu+utvQUws4xVG15wDIeOJYRAn2MwOYc=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqoqoT35CZ4eehx49YjHnh/6a082Rh7gDPBnbUL
 1umZuNkNRWJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaqKqEwAKCRAFnS7L/zaE
 w444EACvnPRKkbmYvqi8DeAM+zuAchJXGVFB521fQLC5pFWwpg7gr4ciV7x3lje/lsUQqtly2vH
 BPN989WtEVDOeAdd+pKqgV6dE3CYrPqHIyTsQ6P2EPkKt04mQLF/lHPd7HWIrC9aI5sFJhmZaSC
 J425A0H1U0dSFSP+xbKCueu9+ZMp5+pcArM19D8rDV8MboVYCwxHzY14X+fgVKeFBPwXG5xvCyJ
 iSzyrQbo9eMZdLi3zKz0GSw40fPRBOrshO+bzBP8Oz2NdRyXLXWmw0hnXjESxCN0xMkXjCYQVk9
 5VpzCCpAz5HIx0l3VqToA6J29oMdLPVcbD5HzCiSuXEr+ynfODimjMZOnOzUBNN1HEMYJoB+CrD
 Nj9HgO8oaOk4fnafcx5CtCKm8sa+FXcPPAyQaFzeyBuVN4amkH6BTrLpSqxHwCiztvOJDBlVoUu
 P9nrAzOWHPJQT1wUkc7/fqcV0TcTesQDDp6rnTxtLkLyYYsetJ3oil+Kr4Wy/YqbDD4I5TVKG8v
 k13NhaGBauv7L0N6xRA6z8wRpGRxBZiu1BApo6Z3OEunnGbpfaIUWZ0wKHpI2xChpQDAPKuYk+P
 dbG0DxluvhpVaDmIZuZeJ31yWXdT/xv0YVTVZNhmOB4nXEKZjfH70cgG3Hj5UO+v7KeFqtx3hAy
 JlsB4wrGPA6d63A==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDE1NiBTYWx0ZWRfX3RvFd+ik/QQj
 75Sj9mvM1UMepNZICc42VYb8uXCLl30rL3X7VJ7JGXeXLgzpPqiSJnDrROeTmBvfLjWdm81gyqM
 ztYPgbaIfN2WC51wR9URL+KgiNNEhoU=
X-Proofpoint-GUID: K-dfwyyWvZNsa48PERVXC1VWU4-FGq0i
X-Authority-Analysis: v=2.4 cv=aef0Dhot c=1 sm=1 tr=0 ts=6aa2aa3a cx=c_pps
 a=ULNsgckmlI/WJG3HAyAuOQ==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=jMd-nSem81Ez8mwE2NwA:9 a=QEXdDO2ut3YA:10 a=1WsBpfsz9X-RYQiigVTh:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDE1NiBTYWx0ZWRfX/c43nK/WdwdR
 jqrOM1SiNUhcLF4R/cTBNaWt79B6VJ27jc+GAGv+UzgiB/jwO5ecX/kySmDBsFihauPTYLUhRDJ
 Va1SSr1aYmTcsvm1vyED0vxuX8RIDXAa7RcYIJWLC/Acyd87CSvsZBV99wscktzp9dyQTyx5zn3
 lR0rjdaj+MlUh0YlDrgIR23baGdhpCstaLkz/msZfw0FtygukIvIM9jOM36rjYbtDIjTORO+irp
 EAlnFmEOf0Ws8ubVfGukcm0KYumilAM61qa767jviiCgMwg/0SuZaxndC6w3wVVqAImnW+GAIGs
 wqWonoMU7vE8sVkMdXKjDvyJCUB20mcj1TAWimfAOnv3HB4OvdsWyKOn1r/Ro6RquQnFBju235l
 9k3+tzCPAJqfQ50q76BeCfSJu71WYUMiKkrRRxsPzRKc2jd1yH9veGEvksqsqC2Oq9DwSeT/86R
 MRXQR0fDqbCreDmpABQ==
X-Proofpoint-ORIG-GUID: K-dfwyyWvZNsa48PERVXC1VWU4-FGq0i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_04,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 phishscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100156

Add the core driver for the Qualcomm crypto engine. Its task is to bind
to the qce DT node, set up runtime PM for interconnect down-scaling and
register the auxiliary device using the crypto accelerator driver.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/soc/qcom/Kconfig    | 11 ++++++
 drivers/soc/qcom/Makefile   |  1 +
 drivers/soc/qcom/qce-core.c | 87 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 99 insertions(+)

diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
index 9f703261d7ac6ccde861b8d29626025bcfdbda8c..81c6634e855be23698591da6d3743ef68b516006 100644
--- a/drivers/soc/qcom/Kconfig
+++ b/drivers/soc/qcom/Kconfig
@@ -121,6 +121,17 @@ config QCOM_PMIC_GLINK
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
index 0000000000000000000000000000000000000000..a7f8acb606cdd6645e0bf1b3352798e439209d57
--- /dev/null
+++ b/drivers/soc/qcom/qce-core.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2026 Qualcomm Technologies, Inc. and/or its subsidiaries
+ */
+
+#include <linux/auxiliary_bus.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/interconnect.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+
+#define QCE_DEFAULT_MEM_BANDWIDTH 393600
+
+static int qce_core_probe(struct platform_device *pdev)
+{
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
+	auxdev = __devm_auxiliary_device_create(dev, "qce", "crypto", NULL, 0);
+	if (IS_ERR(auxdev))
+		return PTR_ERR(auxdev);
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
+	{ .compatible = "qcom,crypto-v5.1", },
+	{ .compatible = "qcom,crypto-v5.4", },
+	{ .compatible = "qcom,qce", },
+	{}
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

