Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D36C4915B8
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789045309; cv=none; b=Ofo11AZ8z6osgLEeq5oCtj6Xfl+0B7GD3GssmDwVggWaYSQiaR8U5lKmcihID+46HgNOm0hS2eLq8F7tANjV7yNP/S/t5/aMDsduhnQDcHXrRyy8qLKe9OgR2MJTESiCvXGQgDal76V1vbbhv53m6STsdZ5UcmMQG9Ir/mkwZaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789045309; c=relaxed/simple;
	bh=BresRinsDjLU7I8KbFnNfeg2un9NXgFjbMY4oSk9178=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Jbu80tOC/q0oUVNYgaEXWMvDCQ1XmjbwHfzGg3fZFPEnlmEJeMiWXKxYu0HRbPFMqWF2SHPxGmpXALgbj7oIWQR6XrfFbUgQYnffcDxnraKUHTz4HFXJ7h66s5ATXG3VyL942VoBYt7Y7gnTh8pjiG/LTsfNsulys4LfUXB7ACM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=V97PFYxE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=aH34KzwV; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="V97PFYxE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="aH34KzwV"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AC7k2I918775
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	QaTek2Onfxdx39SUxr29UbGVlfItIqvvpD+sFEVufXI=; b=V97PFYxEKxj6ZhxF
	TBiIuFDJZl7WlCReqGQXXYA4oUoOLZnYRg7zejNzW/+sUD/Cvr0enXMqWo1WXe3p
	r63elQSI+NOympo564Om9QI5QyBFMz+w+jYsW7/FQmmtbQjH3GmKBhS6WIQ/LX9T
	05/g/g62Xupzc4VkRKw4E9VUlaK+sbC0AP4d9sehl/tNmnK7V+VOAlrejqcXLLGN
	VkQv0FrxUou9e1mmzlHREYaV+j6uSXRkxatiKNMN7HlR7wN5jjZ2RN3GxPd5CgtJ
	AatbE12bm1FG0JHsdmeI/2cYFUwC75caNK0gAYW/jvZCltqqPpFlJeKUNXNZ+OYf
	8HOUoA==
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com [209.85.217.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gkcygux3q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:01:46 +0000 (GMT)
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-79013d05471so363262137.1
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 06:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789045305; x=1789650105; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QaTek2Onfxdx39SUxr29UbGVlfItIqvvpD+sFEVufXI=;
        b=aH34KzwVche2Kxs7qAOPuiz9oCKZjpBVjRhxeBtFlqGTXpZtyn6mb6N5tuyUTVBTQ9
         iR05pDJd8FDVNMP1lVtCIaDvTp12hR9nN23lJ6zk3MeknbR0fVSt3VPP2dQtFfxY41IP
         7lIsZsWKzzGAU2NMVURStq6qCQ5jniA+Ro7OWNibpqTg9BG/paeqjnyyruLDWZZAYWQH
         UeAbqXKPZoaabzg9tRwsoNe54YYy+Equ09OpIlEmCXdTNqqqw5QiKmzpvoqkyU66jy9j
         rJqQsWEtLzbzV9VRR9cPdC4bwbpaYsWCbKbroXq5odSJ+5iLILdZLKDp0rzVY79EXUL2
         qu+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789045305; x=1789650105;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QaTek2Onfxdx39SUxr29UbGVlfItIqvvpD+sFEVufXI=;
        b=f1Wixk9P8RT9Jfc5RE4MvFU/u542llOYa/JPw4wYKC3h48Rw16E11S4/7lvj/u5Qs6
         VsVAVAXuMHooQIEb/owGL7RfnTMod8j/RoePPzgLKVkdv/OPY68PUvh5S8Wi081XmfYb
         334a0zUrlZFLOu3qiuLqI3ytk874CWhH1i+GBL1/1n6sPIliZF5L+sEe2PZOZZk3f0Qm
         JZIzVQNuPbLyVYO3ML0dTbraBnMUwYW32pLmhs6KYX2Y8ViJ6r5+/ZrclfkyHtlcncSm
         1fLHu/QvJqs9j+dPiqOvTaJuUr89NFLNTe3V1Wm2FZ3E4cCBc+7flwSHs0l5XyxYsfzx
         P+MA==
X-Gm-Message-State: AFuF++nRd0aM/I0DKNC54+o7im4F8yMcZhqy2bWZBcRw9jqN1iyfBjup
	KTI6G3kAxlr9VOA2DPVb23DK7me10q0QKcxUEov6240Q6fmxjyNROcS+JDl23XM5vAcC0dRxIBk
	65s/3cT4YmfX3qAItgx18O+60mQwUSTmWY6frrI+qh0QHqdJC3yWhY1OGv5for874PAA=
X-Gm-Gg: AYBFou28R6ZDefSZfzHKd2RDSQx4zPM0eu7lvfCPpY/kQvinzTEDsRtYRPFcsSAn76P
	vdomhKoRThuSpi8ojxBTCtU/MRF1p0VAf+oCbASm5rjrK/ZeBKKNgJu0DRjaDH3vQpJBfEtGVmj
	1O7nL4qlHwf9GeVgJLieXmE1plroL5fgVVhg7Cg9RMoqpDvMqtfVuD6nbFKt/rVNURmmkmgJQ1Q
	/SSXiDFw6C1ukHgSSHVwthqTZ1e5s/CKdARWSy0rDUffRaG9Y/bHtQaAi27bAleYuDKi9hWufvc
	pocCId/jU23NlOlAHKY7n/jf27QSd0PkP61Eaq/DlntVeQdW5kUZKvkxS/xaQy3hP1uIJVM+fcP
	yoUvRik75HGIj8dlxurbAyNIhR11b
X-Received: by 2002:a05:6102:e08:b0:789:100e:3d1b with SMTP id ada2fe7eead31-78f70e265acmr4187991137.0.1789045300329;
        Thu, 10 Sep 2026 06:01:40 -0700 (PDT)
X-Received: by 2002:a05:6102:e08:b0:789:100e:3d1b with SMTP id ada2fe7eead31-78f70e265acmr4187645137.0.1789045295027;
        Thu, 10 Sep 2026 06:01:35 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:c9b1:abfb:f300:5e98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c26204ecdbcsm831849866b.25.2026.09.10.06.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 06:01:34 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 15:00:50 +0200
Subject: [PATCH v7 09/12] crypto: qce - remove the BROKEN label
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-qce-fix-self-tests-v7-9-cdbd2718af14@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=785;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=BresRinsDjLU7I8KbFnNfeg2un9NXgFjbMY4oSk9178=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqoqoSw1zAVU0Ymhsj/oLmPX2Tqm9nj03vEbH+x
 E0E+2e+i1mJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaqKqEgAKCRAFnS7L/zaE
 w5QUD/4nPFFJn8rB+N4iV2FEfnliZc9W5qwW0KgaNwSEMeAmJnO4aUdqU42tR3YLXFrE7N3yWvi
 MfVZWprgceNoYtNxA/fSStmocMDGmD8SvhBgbw94ag5uhcAmu/IAg5ev6VTLyiGzN/Fks3Q8cYc
 jJwYX7tDOrBFYsIi0RlXHZfAQvkIgCCMnfKdWmHaJ0F5J8em6x+DMp2Dis8pqpjUCNCCrS563sz
 PaIOMO/NX10m2VOw/biB7uEPSSf4NIrA5r2smwm7g9xoiU6zCXtIqgT1rc8bj7lJLPDiTdZCgm0
 RKbSB9mFEP/K67rU9NwTLLdUPAYUYfhSxVxs++Ss6Vs49KHoeScZZse2fjq9ZDXL8irvwXU+EAu
 BFUb+s0akyKaJ/GVkGO2TJc2OoH3Rfmi8tY++3FmEbK73QyQNVSG7+GgQRLCiIPLf+B/Hp2jhbf
 0/G3gI1M2DV2amI3DcdFo/PP1bYYMIdVzngGE6+zGr/fpJayrfz6Q8jDf9tpOfES3hRcbTNFr05
 Fmb+CsgD13D67I8XZO8zMJ5gsvNgGt0Rs+Pki+VB5lvmmr0bwzXW64eSjIW9O/7UbejhJf2Lgm2
 IItUmBbEH5UT2HhXyabC8Nho18PJIUXU/Sxi2QYhspU4Sgh4o5xld9mszudQcwu1AiW6fL4kyVT
 1Ct+ijsjfIEcrDw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDE1NiBTYWx0ZWRfX636kHhQr/v3w
 3BhVlA/PTFlhUpsLtiRCf2geG5AUvMis+Gq01Gksgv+Zv3vaFUwVkiUKufJ9ey7t8cpAKryn+vG
 7UywzMQcBriJuNkRl3uSZNOBCFXRKS9unBv+/tZR4h4lM1mY7uCHpN8f0gZTqd+iYEMc5x1YcSD
 UjSWqHTtCzJBT+2XU77Vm9tjXV0RqrKgEh+kRHedARm/TXw9OpzGLu0zwVOFHY1oTqT09YtqXjV
 /gCveMKINolS/lc1ToXK3xbEz/srD9mOo/zQ96/JjXA0Cr+l7SNWFlv0uLggVjsfDUR2iQZ68Vj
 zxt1aAY30Qi89ANdhxqlb7itIIYEaZhCcHKZ72dlMFfwCgZOMxbtPMIq908v52VNNJoVUBu/UJ2
 Rpzf4zRfHNcDj8gfy8WdENS//fmw0pF/R3heMB+za+OD3M1tfqs872yrEzOkfKq7Q7eLSx/d0R/
 ziCotcvEizQs8BGd3cA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDE1NiBTYWx0ZWRfX6rlykI1KLiUU
 ewcKqt5L2yVYs9mshqYbrZ4AYYCIuLm41jlh0mB8XdUZ5LzuNdy74eNBbiwH5w9ExlX/9WVu6Wb
 9qhg3TCe5spM4EMDiZmLsQSxWZ/RDIs=
X-Proofpoint-ORIG-GUID: PBnKdNhxdS9p4UH1XNbHH0OrpbDQ2W-9
X-Authority-Analysis: v=2.4 cv=VONIDNPX c=1 sm=1 tr=0 ts=6aa2aa3a cx=c_pps
 a=DUEm7b3gzWu7BqY5nP7+9g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=0MPpsrD0zQiP_6dgn8YA:9 a=QEXdDO2ut3YA:10 a=-aSRE8QhW-JAV6biHavz:22
X-Proofpoint-GUID: PBnKdNhxdS9p4UH1XNbHH0OrpbDQ2W-9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_04,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100156

All self-tests now pass. Remove the BROKEN label from the driver.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 0189dfdcbbe11098ead0ea194293422a31d8fe65..9f6aa82301a5101d57b3651c9b2ba33213e41d3c 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -528,7 +528,7 @@ source "drivers/crypto/intel/Kconfig"
 
 config CRYPTO_DEV_QCE
 	tristate "Qualcomm crypto engine accelerator"
-	depends on (BROKEN && ARCH_QCOM) || COMPILE_TEST
+	depends on ARCH_QCOM || COMPILE_TEST
 	depends on HAS_IOMEM
 	help
 	  This driver supports Qualcomm crypto engine accelerator

-- 
2.47.3

