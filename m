Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0627B49BD7E
	for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 12:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789995548; cv=none; b=tt+BxPSt3/M9XZ8RkHIihA92dbGL48k162Bh/wc5FsU5YNxQlTvx/KfaaNIUqQh81Wwc6Llyq8vZ5xGeF9wPUNu2hJ9CamGI6R1oFq5xp6I0KLkH8T6ldDnO024n9FPisTMthSn6ZP+2bHbFzo4rpOqvac4B3vUKxnRgXlLK6S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789995548; c=relaxed/simple;
	bh=vkQ0+w+OaiTixUsSZRF4DmzZtt122AZuDXlpHEfsrS8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Pn+WjRPdD7A327qBECer5vDql6fwjMOzSnFt2ubwEb9hlr35cgMTMACf/gCDEIO+/R/7oYPym6nhdshgPke9XQEhUMXANlBHMMb1+/I9t9toKm7HdOFgPAOk/nsdO/tPLlecsyGn4FmFvjSmJcrDmChztZ9hFp9dDVohO+B9bMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NjrsCL/J; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=F/LBz31n; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NjrsCL/J";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="F/LBz31n"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAdos81217422
	for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 12:59:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HHyrvKQS0PCTJFUcgPmmdME//BoOFMVeQtcfEBdKJso=; b=NjrsCL/JBu9HQB+J
	h69K5/sLacS08MzxiXPy3uV4UWA6XSeCZoYa6DBlgYetDH+3botROPx9tVLVJJBu
	EAIe9YZqpFIkrFUxqc214msuW131IcjIiu0hbETLeNKhsgCIY+2Yub6FaninzHhF
	QWHVKrAuikXdI1R3AdATRTS+AHsh7mvx+kOCV6tpNdPIDZuQuwt5DswQWwpnLRry
	Iu+K36hfuJe/pWr6cPOHzMyPiUBprz9GfLml9OVCKr8DhsqfWniFvCZrRQUAjbLP
	lQBXEIdZHFM+XpcJaHYC6cssiVo2elec4fh7S1g4jiy25k/jwE+5SVJG7V/Blp0X
	kQhK4w==
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com [209.85.222.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gu0119bbx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 12:59:04 +0000 (GMT)
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-98055f91346so2281162241.2
        for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 05:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789995544; x=1790600344; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HHyrvKQS0PCTJFUcgPmmdME//BoOFMVeQtcfEBdKJso=;
        b=F/LBz31nI5+bL3syukYfLvtEKVcBs2Pf1akVDPssJrmub+ji5+MYKSOK8qnpOzoTtS
         sSTiLq/OvjA0aImlJESnUl652Gwy8BPECXqQCtVaru2ibCeeWF1lcgc9CNHnsgUcI2zy
         GEnSdjjCZxXDOLPIooz0MBAWQ4YK34aKSwbzohDjN1nZxP/LwFcQ9DJkAPO9wy+lyTc7
         cArlR8vM39NcaWl6D6rxGa/u4yj71pMV8yvFQJDPCMqIWz9nbHAUwcJRoXFzqAquQnPS
         NraXd1HNvmFhhcRSAKV16VBbbog0QJRbh2GLt/w7oGjbFNUM2SlzJ33fFGPQogDAPKuH
         7ZgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789995544; x=1790600344;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HHyrvKQS0PCTJFUcgPmmdME//BoOFMVeQtcfEBdKJso=;
        b=NOJ0mQf/dp6uwFxksoYbP60DCWRlAUuY5eu7VZIku8emL/ZGivCLo0WSyf9iPDvYqi
         940l1kvW+nPatpNEA+dnJjZLwWBZRt7XrG27UeQsDeGHjTAl+b3gWwBapCdvIpXZkRFw
         yDE/tADrPocTBhi5XDuFojn4ffdtjGArAWOIOFkIhBsCpvVDaCoC2GSJVBa+9OaeUVOv
         4maXE/Q3Sw4qDPw8tC5NVbSY3h8j3TdTVW5C+cNpPy0MSCCwGLJiJyuYxBViYCRBNxTT
         bk5j7d/ogFDtlLHBdEssSJpX4PrrULj4yQYMv47KBwKW4rCuKjRpmzZ6KPxSE8mSjDVp
         9lvA==
X-Gm-Message-State: AFuF++nNwkZCI2C5uqU1059OdBkf9tuD0fu1QKbogiHlh1q4eRHY74nz
	PaTNh+pBu6yqk9fgk7xxXET4/vvISW1oV/bRW2lz9c/6jwQ6tFiiZGeW5IHx2snuCMiv3dAtBFx
	DRARNcVfJt/CYM3DzcC+uJpoXEKQgdZY8opEssl/DrK6jzEl4XxYgBQHXzvUzTts7EFU=
X-Gm-Gg: AYBFou3TUlkaxGQHBN7H1+5vgPJzRzlZIkP7sGgmZEb4kAqN5lSGChQoadW7/Fq+rMO
	I2Dj3Y1snrgPdWeyTi1fZiSM7KUdMmURPJdIdYOk8humvRGrOi64Ms/bF7ttSgYopyCLuQb06BY
	tx9vv9K6ix+p9dWTR6J75BTNb55zVypD4KP+ublCpgxr/gyaU4+AGfAN2er3/pKOAoM/IlBq8gx
	1sdYR/JdbpHdNzy0EgP+tkdy+lCZNIzld0FaU8wzO6pdwNQt8YxdQ2LuoBumMMi1uHx46chGkAe
	wNO+8BKu1Ge23ZOqqxw341wZD5ILQASzEThhNAmUErwJS6Qd8vuovPz2gXd3QIbI7SRmqTGmeuC
	slMYimPNnIHHFuaFOM4/u9A97cag=
X-Received: by 2002:a05:6102:f9c:b0:7a1:f7d2:e82a with SMTP id ada2fe7eead31-7a55e1a6bc1mr4171416137.35.1789995544153;
        Mon, 21 Sep 2026 05:59:04 -0700 (PDT)
X-Received: by 2002:a05:6102:f9c:b0:7a1:f7d2:e82a with SMTP id ada2fe7eead31-7a55e1a6bc1mr4171378137.35.1789995543721;
        Mon, 21 Sep 2026 05:59:03 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:d04:d483:faad:1e4e])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a359037aasm320278766b.63.2026.09.21.05.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 05:59:00 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 21 Sep 2026 14:58:19 +0200
Subject: [PATCH v8 10/14] Revert "crypto: qce - Mark QCE as BROKEN"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-qce-fix-self-tests-v8-10-107537869a72@oss.qualcomm.com>
References: <20260921-qce-fix-self-tests-v8-0-107537869a72@oss.qualcomm.com>
In-Reply-To: <20260921-qce-fix-self-tests-v8-0-107537869a72@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3022;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=vkQ0+w+OaiTixUsSZRF4DmzZtt122AZuDXlpHEfsrS8=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqsSny8RXHnD/hCcrWJJtVX444fZXPh9LvFHLf1
 8/flOUlVXSJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCarEp8gAKCRAFnS7L/zaE
 wxw4EACvpYLqBSBBiTMrlHW+mTMnlQpCkcDrV1TD1p5dpE41/RNPbKnKpXgDbsXga4i/DAVh5Vg
 J0SPGdUCxS1rXetIyXiz8oOkzyB7K4430qdp+meWpohC1/lY4klRK+mVJXCOC/mBM68q0jk5BLG
 mYsMMZo/Ga6y1GAOvweRpoaLfr0YucfEPRq+MHcAyKnFVZL9JZHCjrxUZ+YZcM0TGCct8z3fyG8
 S3vyMpHgulgfe9ARtPHFzcERjhnja74y7o8L4zX3lKDiN7egT85OzHuc4LffWznNSDwYkmgI8SE
 xllDJLYHxY3vt+g18ZLqOLYPDOZSGqbdV/8kHLdClK/ay9dZVhaa7EeUUfhUZ2HTMrXQfTGq3N8
 QTRTr65y4hBK08y0XeWotSLBhryjoPsac3NiTr+6xtd5gySQwZ/aMbLvh0N0Ym0qA7TP/9zbk2x
 /vDySC4+kYbZUI7OqKIrT86Mo27alii76gSJqUzB788hvFGfh3n1dJRYQA8eOjoftZRn5beH9vU
 4YnbFvDnBznJgziFxjZu1yzp424IIEpMh+bPmfegRLSep6gNbxmOP4rkbD8oRvQzxd/suxnbARF
 MDcSY8rtPEibhvvZAxozCjNYxsd6myGs7PmSj0l7dCeMO6w3kakTurU4NSHievC38gT/ziKVfbO
 nitVFOitYmcR1KQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: mu5FwOkHYVzQfF47l-vUEYutX2bDfXR7
X-Authority-Analysis: v=2.4 cv=dPczC+Zb c=1 sm=1 tr=0 ts=6ab12a18 cx=c_pps
 a=UbhLPJ621ZpgOD2l3yZY1w==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=Y_jwshM-TqYlUzFSP1QA:9 a=QEXdDO2ut3YA:10 a=TOPH6uDL9cOC6tEoww4z:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4OSBTYWx0ZWRfX5KGrc89wT5VI
 ++stkC2q8yeT+7QVFC3aUhiarmkn9rrr0UUxJrCedEMHi375gwzTl1HL+RA5l3pmX/osShieKBZ
 jSfy8VpgzXw6yka/qF9sX+kwsmdtC9axKxGp1egRvDScTkyphdNVg8bptFjk+hSd3md6Dxs1aE5
 Wq5STGF2TkuqeySG8IWyU+4MfW9zVXEHQmqx/WOH1VM+FeQPtN0yfUGZbqsBOka/VJVjNgD5Nbm
 qcRwiNOaibm3fXsd0syZhEpMUMLV+6dDLYqk4G0hjIUjPN4s3j8fpYPtOkQVxXYxVV9T60288DI
 VZ+mR5vTXnyrSXd4HrN/DTzv0QeN3q9mH5RBKvqzZJGwxojM+KNQuwUCsF9T2D+YhqMHLGpwQ3e
 /qsURj3am8hW8DDddKewG+rdA3ki52RwGYpbppuj1/6o6Nv1lCisF/fYmSjOg1oUJRUJUK0AN11
 Cli0ofhTKrQYp1tiwDA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4OSBTYWx0ZWRfX4egm1zLPgnxC
 oljOklhYFmtvCYWEciqLGDWMjRq4clgZGdjFQTwVMP7epTK3x+bhsYZo8Hu1ZmutODKogo4arc2
 /yHsvoJ4D9oOAzrXsSmXYAJDXUisoCs=
X-Proofpoint-ORIG-GUID: mu5FwOkHYVzQfF47l-vUEYutX2bDfXR7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609210189

The self-tests for this driver have been fixed. The crypto algorithms
are only registered if the user explicitly requests it with the provided
module parameter defaulting to false. There's no reason to further keep
it unbuildable with the BROKEN label.

While at it: update the Kconfig description by saying this is an
"offloader" and not an "accelerator".

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 arch/arm/configs/multi_v7_defconfig |  1 +
 arch/arm64/configs/defconfig        |  1 +
 drivers/crypto/Kconfig              | 16 ++++++++--------
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index f9b8dbf9318c9d4947e56ef0159311634bf0c1ee..2d6292f8cab39596b540084fbd8b30f4c25cd4ff 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -1323,6 +1323,7 @@ CONFIG_CRYPTO_DEV_ATMEL_AES=m
 CONFIG_CRYPTO_DEV_ATMEL_TDES=m
 CONFIG_CRYPTO_DEV_ATMEL_SHA=m
 CONFIG_CRYPTO_DEV_MARVELL_CESA=m
+CONFIG_CRYPTO_DEV_QCE=m
 CONFIG_CRYPTO_DEV_ROCKCHIP=m
 CONFIG_CRYPTO_DEV_STM32_HASH=m
 CONFIG_CRYPTO_DEV_STM32_CRYP=m
diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 982ea1758eb667a1949721140961764b3e9be1f6..55a2e8c3ae3522630df8c31cb2b7c7663e973aed 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1957,6 +1957,7 @@ CONFIG_CRYPTO_AES_ARM64_CE_CCM=y
 CONFIG_CRYPTO_DEV_SUN8I_CE=m
 CONFIG_CRYPTO_DEV_FSL_CAAM=m
 CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM=m
+CONFIG_CRYPTO_DEV_QCE=m
 CONFIG_CRYPTO_DEV_TEGRA=m
 CONFIG_CRYPTO_DEV_ZYNQMP_AES=m
 CONFIG_CRYPTO_DEV_ZYNQMP_SHA3=m
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 0189dfdcbbe11098ead0ea194293422a31d8fe65..baf6c4a4c8aed663e89ae2468a7e9ed9dcb66f34 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -527,17 +527,17 @@ source "drivers/crypto/marvell/Kconfig"
 source "drivers/crypto/intel/Kconfig"
 
 config CRYPTO_DEV_QCE
-	tristate "Qualcomm crypto engine accelerator"
-	depends on (BROKEN && ARCH_QCOM) || COMPILE_TEST
+	tristate "Qualcomm crypto engine offloader"
+	depends on ARCH_QCOM || COMPILE_TEST
 	depends on HAS_IOMEM
 	help
-	  This driver supports Qualcomm crypto engine accelerator
-	  hardware. To compile this driver as a module, choose M here. The
-	  module will be called qcrypto.
+	  This driver supports Qualcomm crypto engine offloader hardware. To
+	  compile this driver as a module, choose M here. The module will be
+	  called qcrypto.
 
-	  This driver does not have exclusive access to the
-	  hardware, causing races with the secure world.  It
-	  is also slower than the CPU.
+	  NOTE: This driver does not have exclusive access to the hardware,
+	  causing races with the secure world. It is also *slower* than the
+	  CPU for the same algorithms. Use at your own risk!
 
 config CRYPTO_DEV_QCE_SKCIPHER
 	bool

-- 
2.47.3

