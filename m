Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF633E44EE
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784277419; cv=none; b=TD3KVZG15bntClVUmBUEuZOgWF9pjdl3i2/ZG6JrUq6LBCCW251v/7lLQa6NME+Sl7G9jRYRApCcP5jO6xo1YRjiCS2FQZMG32k1xf6YISM9+5k6fhoQ68KV8wV3Aw8yo2eDSxumqS1oHqcNdAo8YIkhBYZbM9BuETs5KN8eShM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784277419; c=relaxed/simple;
	bh=T0ZAEoPGlcD+MBsHOs7IR7iXvbxs2FRnDbpOdt9CWCM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Y26RTVtWh6DaC1BWvuQvA1Uiwmxgkdwq+L4gPNU4Nfky/OPnzNIM8qBFAGru0vuGvPCQ5fPcMlE2LUnlbt6EAyQYpVhzjgLvd0g2MWt4UeSbbhgoc6p0Wno1qF3OypJHQB20pjXrTEYyBbSY7QOhEd2VrEz+AMJx92neiLgT3yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AjNCwr+s; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TIlNdFTt; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AjNCwr+s";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TIlNdFTt"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66H6cklr1093257
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ssHW8XScr3JWgrcOFJ5LiFi8t9CrlHFACuaOrI33AwM=; b=AjNCwr+sRv9g2AVU
	iB6pKffGqXeOIXQzg7vFLBhvIyfneNHz+YE9Y0Bes7ETVA184wtriOyFrGGKtFNB
	mEtSjM8z1AqK7d3g/siVC+5OqIh8PHEiBCuCJEstZjbWpYeX2VYC1V+eDsZtY9nL
	sDVh1hH+62WYoailE1GN0r1yIilONmSPw9yXz7rWe/QrlUiUw0wFMCmc65CVV3gO
	OUtfmUkcuWUcLlF7O0mpaoDhJZrSwlaNFUD3uUlEQlKPcBXYc3fbucI0Xido/R/0
	lcD83hg5A29jbFJ2XWS4UFjWlN617O4XAKURLLqb7aGZsLPhS4itq7NX4w83k9ip
	4laPOg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ffe0urrny-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:36:54 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-520a00c7a03so28524251cf.1
        for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 01:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784277414; x=1784882214; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ssHW8XScr3JWgrcOFJ5LiFi8t9CrlHFACuaOrI33AwM=;
        b=TIlNdFTtnsINtIvlljX44TFg2tOsEq909hhNfdoF69yFj/J/3Xc12lKA4+lZTMypby
         qTgsuvvl+38Zk5yugJV52KlW5r+DH373IauwufMBxHOkxtZbSqw396BcU5jfb4yaBBKl
         Gmhe47+pjBBWzoJq5qocMf8PeYvLG36zUbzaC2B0Jymk0USQmFm8une8xpB13wGCKwKh
         AaibWcmGlQv8aGGS/QgTiNtAi4cvSKnoQ8a+ILC9zlEcSrdr7EAx17ZAK3Vsqd+JoTjq
         xoLED4rXCulV4PSJTkh4zXo8bXgBocF/OoA4pZyTUjU/2dlECX7vmF9BriFQ0sH/a74V
         v+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784277414; x=1784882214;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ssHW8XScr3JWgrcOFJ5LiFi8t9CrlHFACuaOrI33AwM=;
        b=YK2rClt8sKjQg8o1cell/mA96lk1c72YjHt1olHO/M7/SOY1fzyw1J69yVrD4JrzDz
         W5XjQujPWC+jeKnaC3t/1jEBdIzKeZj2FkY46klYMD/s7xCUa4zfzXTzX+cawoP+klE9
         ueMwanA65aifHnjTK/0RSkEqHV/qnDij0mjIT8tB1qOcBGqEUCW3L8Qn/SO87Ev54JzX
         IjuEWlLSOZhGRO0Ghwz4QgiVi9hEjpngXZHfbKadDz6x4WyF40HnWF0XIcB6C6vP/4pu
         HcvQxdECxyXqrMmurAJveSO/L6OOFJ8PJQY8vMzFd1jtU/fkMbbkBIRFs5a1T8qyOIgV
         NMOQ==
X-Forwarded-Encrypted: i=1; AHgh+RpNqCBmNoYdiFNqjcPmQRYHlPV6f5ZkfmS/5UoWHtaFYcSkLQvjSiEkhJK7DapOMxD2Nao6YqWj0q3r6MQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOVoV1Q+gnX5gKZZlzwWoe4fKv7fwjL/d6LJV6YyBKtsvd0WMj
	qxlDh3A5+SWA9dKW5jsyv2ps/Mj0rlZeddZGJWy2Lznc0e2JjHWeqeLqiWKJXJxyYvsaWOoxGRP
	Dt1M0feLgLdFshgMQdu32wpotgPEeXe8Ma6I2BS1afTgEU+msG2Eiv9TvdVS7hhYzvuY=
X-Gm-Gg: AfdE7clHBUac8B0u8D+9pFj6yy65Sv0KcDBkTkyFXy13H3gfzk+cDF4er+Z5j2br/HZ
	9pDai7jns5PukQPOkHPSgFqG9t7PcZHbLRSRUiBgIWRpAGdYtjCTbHObzNRkqRBlgWQuM+BnTGr
	bPb+VdEM3tw+5pDu89gxdXc7I0zW0+ugcAOm+1ua0G+A2LK7Q2kaPS7/dgCzP0EqAQtPM3p15Yn
	yg0A5lQ93T8r1GsrneISz1hDWM6KVfSlfF0ubgL6Zu/J9qtn2Bxdg09WcBnTkZ7oi7fjqgu6/Z0
	LIHMdlVCeQRb3Q0iC5wAuI9fiZcZI6PuHl0NtsU/m0di/2S1bBj0BztPWZATvXTg2PdYRX5cMi5
	9d7QPsUdtb4V40Dahgtlj1H5YuS55KQ==
X-Received: by 2002:a05:622a:283:b0:51c:775:c175 with SMTP id d75a77b69052e-5213e77d807mr12257431cf.40.1784277414359;
        Fri, 17 Jul 2026 01:36:54 -0700 (PDT)
X-Received: by 2002:a05:622a:283:b0:51c:775:c175 with SMTP id d75a77b69052e-5213e77d807mr12257271cf.40.1784277413969;
        Fri, 17 Jul 2026 01:36:53 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:dc44:5b1b:5396:79d6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2b893dsm31268205e9.8.2026.07.17.01.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 01:36:53 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 10:36:27 +0200
Subject: [PATCH v22 01/14] dmaengine: constify struct
 dma_descriptor_metadata_ops
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-qcom-qce-cmd-descr-v22-1-ff0d18b27246@oss.qualcomm.com>
References: <20260717-qcom-qce-cmd-descr-v22-0-ff0d18b27246@oss.qualcomm.com>
In-Reply-To: <20260717-qcom-qce-cmd-descr-v22-0-ff0d18b27246@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Stephan Gerhold <stephan.gerhold@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>,
        Andy Gross <agross@codeaurora.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        brgl@kernel.org, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2359;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=T0ZAEoPGlcD+MBsHOs7IR7iXvbxs2FRnDbpOdt9CWCM=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqWemVQLvsoBlGUC8Id5HKABGvrQnHacgwbnQKb
 dV5Msto6GWJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalnplQAKCRAFnS7L/zaE
 w7U9D/0Tcm22Q6sO5uCv62Ub4sZXCWkpD5YcJjqq79dBD4DQ05U8WmqZViexgaYwIr5Wi/Jzxbs
 H0IiNrfekHuE/z2T44i/LBZrpj+i1p4I/iJQIP+hNGS+clq0b77m/AXM6lGBBO9X0cGO2sfUmiG
 j0eR2WCLXsbjart0QQjpCeSxSq8/5g6V70MnqfI6Kw+UXariJasrZeVeCgfX46RpTVDUcbaSeEm
 cbgOypWN/0qb/c8EfgN9ixrqv2o4yV1RHx7L5BE5xA0elNQqbvPqNzpPeiQTDbfvN8iHBHnS5/g
 naD79zRUbLlyuSdb6ieV4PIM/UToBoh8eFyewP8aose2G/QigggMAtDjYWgGTI/ZMXC5yzd6Fl8
 Dq95srQg/noEMR5CLrjadrqMbsA/wvnFUwff/PVj+CgOWoXbdHSz5aYTrlEetqRpHQSfjRwS4ej
 kxDimCX4aDXgt3fZXejKKXyna56IIMwLvpquXbpxm3KZOEQMODV+Mu5ZcytQIW92ZMQQHgb23/y
 a5wcK4uAn7uKz/sxrmFof1bINsnOYR5BpxQ4yDcIwUFSLZzuAANfs1Nh3O1LR8Bu3iO2hqkUcJ6
 /cTHzelOUfANV3e9qB9nscOAS/tztq1GJ7/lEH1O2Tc7uljCQFSk2OTMyQlTQ/HddjnV/VtL1po
 TEFTVrPXPpnlEJA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=deWwG3Xe c=1 sm=1 tr=0 ts=6a59e9a6 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=VwQbUJbxAAAA:8
 a=zd2uoN0lAAAA:8 a=EUspDBNiAAAA:8 a=XeVHrwws4l7kqE2Ex6IA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDA4NCBTYWx0ZWRfX4muQ/FlPCpi1
 YYlE2iMhcGP+zlEEg1un+seNVfAd98GlOLXSNw039uKFIZt11fKfzKD/KXBKVQIRxRGiNVTgU5u
 iv5Yr5z3+Ok3RLsaWtTDplMzCdphBejFdxfrypLIwL9a5p2G+TLZThXRauW5qoZBz6gs8V7kzBt
 WVdPJvVvDzMnrFch0M9KTRAp8jBgSx6Q5B4iU+NBtgiHz/DHKOLGV+wdB50y0IlOSPL1k/sAFMP
 9EWMgTtRdlvDR8ik0Pk3n3S7hW/ianheSVq1JL7fZB9Ps5nPINNq94XfzDIuUBVEwG8i7Ks9tOl
 k8rRY715mPFVtVlJYSiAYLoSGXuCr61Q5r3rFEhfXAVKaIxdgJVRhzpy/Zou2z2UcKDfjIf3HTl
 kQICdvOt3AviAuz70zxG9oMTZHoEVDTNvQP9zGQby0M6lTqvGFGoeX1GO8s2vf9j2AXTWk5mpKk
 0oQRO6BqWe6qO2CKp1g==
X-Proofpoint-ORIG-GUID: U_4019r2rxaQVBEMazuVAPr6pPFrrFPO
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDA4NCBTYWx0ZWRfX6T8rGzQgLUrP
 6VzRPSrlgtI1UApGUhk4oxj8mH6rHf3I6GqmyTO/I+xSG907Ox8Pfp3g0nJIRtTH6cSXPaYtKKQ
 uHKzrc/3tKdxTJETTfwaFN564nBw+6c=
X-Proofpoint-GUID: U_4019r2rxaQVBEMazuVAPr6pPFrrFPO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_02,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170084

There's no reason for the instances of this struct to be modifiable.
Constify the pointer in struct dma_async_tx_descriptor and all drivers
currently using it.

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/dma/ti/k3-udma.c        | 2 +-
 drivers/dma/xilinx/xilinx_dma.c | 2 +-
 include/linux/dmaengine.h       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index 1cf158eb7bdb541c4e7f4f79f65ab70be4311fad..fb21e0df5ab7b20e4e16777b5ff7f61d2ae67b2b 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -3408,7 +3408,7 @@ static int udma_set_metadata_len(struct dma_async_tx_descriptor *desc,
 	return 0;
 }
 
-static struct dma_descriptor_metadata_ops metadata_ops = {
+static const struct dma_descriptor_metadata_ops metadata_ops = {
 	.attach = udma_attach_metadata,
 	.get_ptr = udma_get_metadata_ptr,
 	.set_len = udma_set_metadata_len,
diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 404235c1735384635597e88edc25c67c7d250647..165b11a7c776abc6a8d66d631e19da669644577d 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -653,7 +653,7 @@ static void *xilinx_dma_get_metadata_ptr(struct dma_async_tx_descriptor *tx,
 	return seg->hw.app;
 }
 
-static struct dma_descriptor_metadata_ops xilinx_dma_metadata_ops = {
+static const struct dma_descriptor_metadata_ops xilinx_dma_metadata_ops = {
 	.get_ptr = xilinx_dma_get_metadata_ptr,
 };
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index b3d251c9734e95e1b75cf6763d4d2c3a1c6a9910..5244edb90e7e7510bf4460b6a74ee2a7f91c1ccc 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -623,7 +623,7 @@ struct dma_async_tx_descriptor {
 	void *callback_param;
 	struct dmaengine_unmap_data *unmap;
 	enum dma_desc_metadata_mode desc_metadata_mode;
-	struct dma_descriptor_metadata_ops *metadata_ops;
+	const struct dma_descriptor_metadata_ops *metadata_ops;
 #ifdef CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH
 	struct dma_async_tx_descriptor *next;
 	struct dma_async_tx_descriptor *parent;

-- 
2.47.3

