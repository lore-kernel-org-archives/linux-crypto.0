Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2D8346E66
	for <linux-crypto@vger.kernel.org>; Tue,  5 May 2026 10:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777977008; cv=none; b=k/cM8otnEwaOtu2HzZ+d62vXstDYi8nOTaqJYT4gbxiEeUxX5Oc6ZwM0jp4C0Cfx4JMHwXCV4JhWT28681dsA2L+7uA9Uckn9WTpJqccyTcDtVe1Ekb7D16FKfpNJ/mMBr4JQ3jK5BW4ndOB9wzpxrR7a8EMpU3z5cjEcsURiHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777977008; c=relaxed/simple;
	bh=VDkI/YIhe/XVJqRBZwnhVwQZX3km79hsSqkFGwSIFV4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BqVqhbZkr/QXZKzIWrVHEYysj51XY58pUN/j1g3XEwBzgJAe10sC+FR1Soly8X+0sTCoJMg0Ha6t3IxMjxC/A5L2IQLOoxsLsW/XFIB+jsGoRxZw8qAmK5cEQfNoQx4fuOPrtciXEN56LLORKBWfj3qKq9FP8UiiSDqRhC6IrOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lIgcX3Xi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fUOBg6U1; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lIgcX3Xi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fUOBg6U1"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6456h4E73467601
	for <linux-crypto@vger.kernel.org>; Tue, 5 May 2026 10:30:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=MB+OotB3e/NHRMtFj5ZsRfgooB5x8zth72z
	dR0iYyVU=; b=lIgcX3XidbQ+SR+YEyIlEgIsD7/Iqnv9ygPNDDvHQpuQxVb5TK7
	k9IC9mONN4OtwulGoyq98ProXGsSSDzdVKcIMX+DwRSF8+Z52qcl4sAOT033ff1c
	BGCzeDt0PNWIHQGC8bLPXSF+yIXBxcepQ+xiCSHk40ukbWO22gcN3Y4toVGc5oq4
	kwHXPNcZBKIoSJOK4fnWO+M6eunJQ74SAjgmhAgbtUsJ+6bFbC83wS1OuzoulN5j
	fNmdVpO2TTf+MYCWf3TCRPw6rvkHxtihVFkOxcyJ5RCa7ume5CkthWG9okDbQcvt
	ofy/dgCO5pKlt1X/JajzxcBtDJm7J7+Nlqw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dxvtjux93-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 05 May 2026 10:30:06 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51306c1076dso19816901cf.3
        for <linux-crypto@vger.kernel.org>; Tue, 05 May 2026 03:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777977005; x=1778581805; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MB+OotB3e/NHRMtFj5ZsRfgooB5x8zth72zdR0iYyVU=;
        b=fUOBg6U1kQ6aFvm7jMB6QYtrnXpBPy517iISlvTV4IkrEvbxTz47lGunW+40Ta/o8t
         Bn93TCY68UOQPeYnllzWVfH3xjhJuHQJzKmH7yYtqnhU8LveisCChpSBk0eml+Fpvdek
         dYW358ZiAo7/mkDb1wkYAg0tr4CNUKtSld2v7FtHQjV+6oXm+rlsv6T1z/ktA/yHiLSR
         4fc39nkitAA7A9Vokh5KFqoMJDhsd6bYDy/rJZuGXb2YOh6JmYH/eIwdrYuLh/2ateHl
         +XyfPUub4ROuLsUaqq4tc6Y5TcEbkWrGsNAiTFoR5pOU5+sHAcv8Adb63qG7vPUeoE9x
         7HLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777977005; x=1778581805;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MB+OotB3e/NHRMtFj5ZsRfgooB5x8zth72zdR0iYyVU=;
        b=Q3u0DPQeDnQ4mohe+7fj5WU8+gfFR+RnVj+M3xMB3xcR19ABOiEV1BQtA4ZiU/8fHl
         /1rV6/XUV9NxATelvjmmMeMbq/kIYBWGOWqQ4YjOhPtHvwPY3NVyu3W7Wf691nLZtEfL
         gHYiuRnIM58oltaXOkEqfrXMWoFh8Dx/9KBtr1VNac4GqNXMje1NEWDeBdEBsn9hdAsx
         4eYhl5tIsNjYbdIrquIkNQep7x6+b6tM1tVcv5jzI74tD+NlkBchu7uWN6NFKreZYQCV
         9DvwezMd3R0QCfBJmc/6IYhIbArXOt2wAihXxxe36vmchBm1KgDQhio6FACxxbdYVtDT
         jQhA==
X-Forwarded-Encrypted: i=1; AFNElJ84mqgOBc7S2QvG0Yh3IRX1upDc1uSbV53YEwoL3DqrohjFmpmJgOzoCy/L1xPKp1rGB6F2awTkqszEnVc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFllgaj08s8CJWI5aDlv1DSpziwYCZ3VJHuM5JwPH+Y43s/Bw0
	GoXF7kPi2Z56h5wb7mDA7lU26yYtMx7t2/xSmtFlCnqhWe9tqZ5/7JSG6s4ia2vNnM00FjqHApy
	GRyn9VGMEtKsi3ppipuQdnO7ls8RygIn/2hyPVrnZWuUBrRffaTvFZQ9gapUfGZsDKbM=
X-Gm-Gg: AeBDiesgnA8uZd7k3W2EWbfAH1L/9TWJefaOyISIa9tp4YN6MZe0uOGY3PVMkvBN/oJ
	JKh7Trs3fKeySR78yWV7LaGjydnyZKHtwUAsu3m1AlYEa5tydUK93aqsU8gCYdMfWtK6rAjXOHd
	kuz8JPPGuGwlrEukg7JoJge6wpSm1cAf2Jv5vSM8tTbEAM6Fo6o4NZN6FiaGy+IDlroaj9aS8yz
	qWIbTIbQdr9KZMNioEjvaKKuIRYvt28nVXlJLFeoFjVhzyeZlkDcflI3DJjYOEyNlXrjY+2jAME
	N29eW8Gxd5/7kESSLXDJI/2kN5+cekplP/hahpFx3wcGrJQD0z/S6wh9sTTAuGUZZm/evxqOVC3
	B7L+rP6gS8/Vu6/6mHl2AsVei7hUhFtKuhwQYvDcBw0rfrmw=
X-Received: by 2002:a05:622a:1826:b0:50f:bcfe:e8e0 with SMTP id d75a77b69052e-5130699349bmr35652661cf.13.1777977005092;
        Tue, 05 May 2026 03:30:05 -0700 (PDT)
X-Received: by 2002:a05:622a:1826:b0:50f:bcfe:e8e0 with SMTP id d75a77b69052e-5130699349bmr35646121cf.13.1777976994822;
        Tue, 05 May 2026 03:29:54 -0700 (PDT)
Received: from quoll ([178.197.219.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48d17710bfbsm17814935e9.7.2026.05.05.03.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 03:29:53 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
To: George Cherian <gcherian@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Srujana Challa <schalla@marvell.com>,
        Bharat Bhushan <bbhushan2@marvell.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH] crypto: Move MODULE_DEVICE_TABLE next to the table itself
Date: Tue,  5 May 2026 12:29:49 +0200
Message-ID: <20260505102948.191683-2-krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5593; i=krzysztof.kozlowski@oss.qualcomm.com;
 h=from:subject; bh=VDkI/YIhe/XVJqRBZwnhVwQZX3km79hsSqkFGwSIFV4=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBp+cacBHRmk278L97Ewwnf1Fxza1c3jh8IRWtCM
 n4O2C/LAi+JAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCafnGnAAKCRDBN2bmhouD
 107cD/4rpyhglndnyBhx30UOnhEGuuWcO2Pgbt9kQfMy02dt1slf1HP1yrDniCE+UbCgiBQZvMO
 ZwOLrlroNWqvoOL1oJV418IndsjaByw8kE6EhVeyKWgGtZ7Pe7cj8zaAkh/JbyvieNjd8bFmLDY
 m7n4dRLCkNeAGnxxIKqtJNq2l16dHPDmKavdEuIa1ffrJTMHps8ZAbg6JSc8TktHs6sTMT8zVsA
 wBEihQ2LNOiaTW0cq0/qnGrqM9dBtyU8DRKshxGfNs9p9kCccRqbG2vkWWAOjMn7onVfeVMgjc1
 QOtp5Ur3SLpkhCKvxRz/stFGk8XKQZB0cA3dZjExKho3f4fxYoX9pEMMR1wwVytnn+Sbb2dp5U6
 +qdDY/ec9gJFXj7EK2+2JPCoYaBmcBVpFdayoRCC5CGer7O8qWwbAByOfj5gmY6sLHnFi6b9pwC
 fpyIbYVHRm2TSUEFKWCMGdYfiTQAR3mnsL8VSJBDm1NoRp6aHECX0yxOkQhXMMCCqMRjFcecfTU
 PtXvIe+sBiOle+A14BK4pwPY1Y5C4qy9N4Bhb79J89MjgIsB91cDDjuYidBOwmpDUNIU6qPm8GY
 +Ilc/JoE3y3NHxmfL5/93AZYsDcV/Z7SSH/JonZfvU+qTPbs8tCG+wQ/+mwp8URr7jF1Iq0vbyW 3yLDrpL6RfylRHg==
X-Developer-Key: i=krzysztof.kozlowski@oss.qualcomm.com; a=openpgp; fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: vxQBHUrdostRciTKiIFNAOerttNSPg0d
X-Authority-Analysis: v=2.4 cv=KuN9H2WN c=1 sm=1 tr=0 ts=69f9c6ae cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=gOEeR9iKwsj33Yj5oN/cWg==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=zAyngx5bAAAA:8 a=K8icyTp2isn7or5TWTQA:9 a=uxP6HrT_eTzRwkO_Te1X:22
 a=4LA4qAFo6bo561LpWNDU:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDA5NyBTYWx0ZWRfX9cO1xIsZwrsz
 qjPRhgsuJHEBgZpXDQYqbH88b4pJfwesgidj2wdbYEiJrMDzNZWMBiDW8SRaknDyvJi0OrQ2JJj
 bJ6+zyufXJiJVWfpsMQ5F1gcidCknxsQI3P0hUulYN8xicc6tw+HdRfkhIRXRp9UmbFzii9Gyov
 bmyJZxvKGnzyPNfnEUbOQ7LpYzEFXmFV6PlNPskVFaEOINKdpsrKzw7bzR112JgGaaW0qfSGKom
 kByuEr54ysvwgd7umfk+OwkJ5G11qgd2CDEtTWgJIHpDS67hyXWE9VD8DfXeGXPk85OOJc4NWlM
 zHA7X3oA6LhriKEXof+V2X6cAXBacJ4PQyz777VXvuwwMqQ6IfoRU4sOyOJ4d6lC8bd9bZPIgFJ
 5gORu3phanLBEuhqPXRbpkH3+buNQQpgixnTj3pDQlNenxI8sucI7VArEWYsb6cgen2laKEjmB8
 ZgPowWjgbbeR6oWvCzw==
X-Proofpoint-ORIG-GUID: vxQBHUrdostRciTKiIFNAOerttNSPg0d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 adultscore=0 impostorscore=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605050097

By convention MODULE_DEVICE_TABLE() immediately follows the ID table it
exports, because this is easier to read and verify.  It also makes more
sense since #ifdef for ACPI or OF could hide both of them.

Most of the privers already have this correctly placed, so adjust
the missing ones.  No functional impact.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
---
 drivers/crypto/cavium/cpt/cptpf_main.c             | 2 +-
 drivers/crypto/cavium/cpt/cptvf_main.c             | 2 +-
 drivers/crypto/marvell/octeontx/otx_cptpf_main.c   | 2 +-
 drivers/crypto/marvell/octeontx/otx_cptvf_main.c   | 2 +-
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c | 2 +-
 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
index 54de869e5374..9358c1c041d4 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -651,6 +651,7 @@ static const struct pci_device_id cpt_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, CPT_81XX_PCI_PF_DEVICE_ID) },
 	{ 0, }  /* end of table */
 };
+MODULE_DEVICE_TABLE(pci, cpt_id_table);
 
 static struct pci_driver cpt_pci_driver = {
 	.name = DRV_NAME,
@@ -666,4 +667,3 @@ MODULE_AUTHOR("George Cherian <george.cherian@cavium.com>");
 MODULE_DESCRIPTION("Cavium Thunder CPT Physical Function Driver");
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION(DRV_VERSION);
-MODULE_DEVICE_TABLE(pci, cpt_id_table);
diff --git a/drivers/crypto/cavium/cpt/cptvf_main.c b/drivers/crypto/cavium/cpt/cptvf_main.c
index 2c9a2af38876..2e2e61f76b80 100644
--- a/drivers/crypto/cavium/cpt/cptvf_main.c
+++ b/drivers/crypto/cavium/cpt/cptvf_main.c
@@ -838,6 +838,7 @@ static const struct pci_device_id cptvf_id_table[] = {
 	{PCI_VDEVICE(CAVIUM, CPT_81XX_PCI_VF_DEVICE_ID), 0},
 	{ 0, }  /* end of table */
 };
+MODULE_DEVICE_TABLE(pci, cptvf_id_table);
 
 static struct pci_driver cptvf_pci_driver = {
 	.name = DRV_NAME,
@@ -853,4 +854,3 @@ MODULE_AUTHOR("George Cherian <george.cherian@cavium.com>");
 MODULE_DESCRIPTION("Cavium Thunder CPT Virtual Function Driver");
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION(DRV_VERSION);
-MODULE_DEVICE_TABLE(pci, cptvf_id_table);
diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_main.c b/drivers/crypto/marvell/octeontx/otx_cptpf_main.c
index 14a42559f81d..e4c828606a73 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptpf_main.c
@@ -283,6 +283,7 @@ static const struct pci_device_id otx_cpt_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, OTX_CPT_PCI_PF_DEVICE_ID) },
 	{ 0, }  /* end of table */
 };
+MODULE_DEVICE_TABLE(pci, otx_cpt_id_table);
 
 static struct pci_driver otx_cpt_pci_driver = {
 	.name = DRV_NAME,
@@ -298,4 +299,3 @@ MODULE_AUTHOR("Marvell International Ltd.");
 MODULE_DESCRIPTION("Marvell OcteonTX CPT Physical Function Driver");
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION(DRV_VERSION);
-MODULE_DEVICE_TABLE(pci, otx_cpt_id_table);
diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
index 587609db6c69..0d4583702543 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_main.c
@@ -960,6 +960,7 @@ static const struct pci_device_id otx_cptvf_id_table[] = {
 	{PCI_VDEVICE(CAVIUM, OTX_CPT_PCI_VF_DEVICE_ID), 0},
 	{ 0, }  /* end of table */
 };
+MODULE_DEVICE_TABLE(pci, otx_cptvf_id_table);
 
 static struct pci_driver otx_cptvf_pci_driver = {
 	.name = DRV_NAME,
@@ -974,4 +975,3 @@ MODULE_AUTHOR("Marvell International Ltd.");
 MODULE_DESCRIPTION("Marvell OcteonTX CPT Virtual Function Driver");
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION(DRV_VERSION);
-MODULE_DEVICE_TABLE(pci, otx_cptvf_id_table);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 346d1345f11c..f6f47f4e5d83 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -867,6 +867,7 @@ static const struct pci_device_id otx2_cpt_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, CN10K_CPT_PCI_PF_DEVICE_ID) },
 	{ 0, }  /* end of table */
 };
+MODULE_DEVICE_TABLE(pci, otx2_cpt_id_table);
 
 static struct pci_driver otx2_cpt_pci_driver = {
 	.name = OTX2_CPT_DRV_NAME,
@@ -883,4 +884,3 @@ MODULE_IMPORT_NS("CRYPTO_DEV_OCTEONTX2_CPT");
 MODULE_AUTHOR("Marvell");
 MODULE_DESCRIPTION(OTX2_CPT_DRV_STRING);
 MODULE_LICENSE("GPL v2");
-MODULE_DEVICE_TABLE(pci, otx2_cpt_id_table);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
index 858f851c9c8a..328ff4ba9742 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
@@ -464,6 +464,7 @@ static const struct pci_device_id otx2_cptvf_id_table[] = {
 	{PCI_VDEVICE(CAVIUM, CN10K_CPT_PCI_VF_DEVICE_ID), 0},
 	{ 0, }  /* end of table */
 };
+MODULE_DEVICE_TABLE(pci, otx2_cptvf_id_table);
 
 static struct pci_driver otx2_cptvf_pci_driver = {
 	.name = OTX2_CPTVF_DRV_NAME,
@@ -479,4 +480,3 @@ MODULE_IMPORT_NS("CRYPTO_DEV_OCTEONTX2_CPT");
 MODULE_AUTHOR("Marvell");
 MODULE_DESCRIPTION("Marvell RVU CPT Virtual Function Driver");
 MODULE_LICENSE("GPL v2");
-MODULE_DEVICE_TABLE(pci, otx2_cptvf_id_table);
-- 
2.51.0

