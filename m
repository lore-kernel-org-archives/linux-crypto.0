Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DF43DB99C
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779801084; cv=none; b=Iohgr/7i5YtPBMw99e5qadVO8W78/L7jpZO0pfBIeZF4GNTajgSiggVQC91xmhkt9p7rvjb+uIxtSBWUsSIbawWUqy7zy8pWcUgPFFYVU7Tzs4VXqNQXUWwJ+ge5eY1Esu8q0O1twymY00NUF9uLHIPTl1ZaTqvXqfIikyiFEWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779801084; c=relaxed/simple;
	bh=C8t0ZoGUnDPF/P+4BK1Ho5MJ1aexupcCMbMgOX1T0s4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=k5dJ0RXjPgVYavfKIzszHj+mwPgfnDVZTMAeeHtiVg+Zk689lK9ud/1vHs8AKyvuSvARS8ktwmac8ycoNCcbs2rWVscNuFLi89aQNAsOaW3T4OzF2u9ovkcvt+wq/fl8Akh3du6WOgZZMJzXZpxcJBajI9KrNY7yz2eNtPRIy+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FwrmGo3l; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AY+3W2wn; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FwrmGo3l";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AY+3W2wn"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64QCsYGd2411785
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	51xURu7Zhd73Xm88jAVPEesUyLMnmj9g9fiXS+Fq4Bs=; b=FwrmGo3l1EbLtRGR
	qlEazVpFROCEMbwBKm6Vv0HetJgZSxFxO8U8pSCr1TPTEBybnimbAqCe5vQvblRo
	7pkDquCy3HPMGYNv1YkJqD/fWsDXCZwpr9kixeEY6elcHIURXp/W6WL0HHwI0FdX
	uNZejcqLWErMXzGz4FGVuMKfMYgkEj28Pv1BSQkNnbKgwttri1cUqVKHY3OABXo/
	eyPOEBdfYU7Dos1McdIsOLTDF0Yx2xmUN2yIakKd6xSvqd88aAxuHz6wJ/wk1jlw
	FvZBXWAPcARPtGzX6gF7DtwjK00MOPEtTi6vyru/C5T2I6g+fSLRV2Lvov09bYog
	/VM0mg==
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ecqync62v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 13:11:21 +0000 (GMT)
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4854350c266so5692952b6e.3
        for <linux-crypto@vger.kernel.org>; Tue, 26 May 2026 06:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779801081; x=1780405881; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=51xURu7Zhd73Xm88jAVPEesUyLMnmj9g9fiXS+Fq4Bs=;
        b=AY+3W2wnEPy3e5a4Bc64c5sWp8OzXNyttoUO5I6GUUlNLvd1Tnfq7/K24EeR8lB2g/
         ydyO3VZUJwrCLinwbZ7CcI1rcbD+tFJ7tO8+FOgg5Ja6KIZDopzNwl7DDeX/OMnH5ZH8
         a5f7ECAkKpeF9W34NVKpfPrk1CLU2Ny1XJgwvtY8k9Nd3JGiuu5hAkDwhX6vodiBo5Ap
         prpb2Fx6n8fcLtIWucSSAGzad3S6BewCqKwTaZHmGwvKJsH80xZRQBrCbPTR+F4KxDCe
         qmjP/L1ew001ytbWn+D2boEcp8yjyo0PtxOVzeys260S0AGUROwcm7iXqSyCLl0oc4fu
         QSuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779801081; x=1780405881;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=51xURu7Zhd73Xm88jAVPEesUyLMnmj9g9fiXS+Fq4Bs=;
        b=g1WyvmotIovjYLB/IRyDfczLxtjVbihopmgzGzobX2C6sHuxJG1n3EWWW799orIPxz
         gsGCoDHrxy+1XJzdCjSf0MkjZXRePFIKz2jsfHLbWaQVzRO2WhbnjuX/znIghEFo+e/K
         DNRsvwfDXI696Eti4stgykYXoYT4P04CaD7lVnxkQQ2+aC9yo+hAIoajHw8gtj4MmfwK
         gQ2MGjfAF2iD5esyFBdEL3JLLGortOIzjixZfyHvyUKkuXYju604n+pIcftI/PamRbDg
         qp/129FRwO/0sYHQOU4MqBJ0STAib5Wp1jRO1saBlHI04zi460je23enFeY17DXuiRk6
         le0A==
X-Forwarded-Encrypted: i=1; AFNElJ8/rh1LbDWyqS78tfqcdswGkyTfnOhPUhBwJG9I90Yn86X+/vY+UsusCNAH7PYrX0N5bd5rYElmIkp0em8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEwCsEluk1tQQ+/DZ/3/Sf85GvyToiyDHgHAfWDu+OWf0Y9Lvf
	Dn/ADDQWbIK84Vbpw4JNWRu+GAtSDy9gQ8IsK2m967rfTU90KKQDS/7xv/eFjSoOeJpFgFBrw57
	6wACB5cXpkB/sUD0IS1FEnSypkqF2L8kdqeWom80mBnwKaaHRKaLUSXwVm4x50eL2/9o=
X-Gm-Gg: Acq92OHMC8Cg6Hjb3Zeys7MHDRoxmNBczokpRtPa8zbJ+dBHBh+vmC2DxjKuwQiGt6/
	row75QQ7nTncv593gnWOLrzCvbM+BmpX3J7KkKn9sypwM/fjL6oHSzNzQ/wwlqMe7GeUElORe6i
	nuVxsE87h1kcieOoohb9UQ2SdJA65d+SXLbJA9DUrQRy3yunapmBeGBBlW2SkedtuWVrymtG0aQ
	uucwUvf4/CrKqHYDdy7JzDzYftz98dD9FNLE3CT1O0NU4r+vQJ+hzIORJqXUqB0fXwfdXQ7eong
	Cvs0JSqOBV/K/P0ITZMSRE+PyO2SWpExFu1jR99B7Ev59oa4P1TouIi7NhKM3bueulP36cZosVs
	dN/DW9ZcTmERco7OSIbtXWtgehQbM28sUbVGrlQBXPjQPpr2I1sAQxeTNbDrDdg==
X-Received: by 2002:a05:6808:3a0e:b0:464:3d5d:d9d4 with SMTP id 5614622812f47-4854a48aad4mr11012403b6e.39.1779801080964;
        Tue, 26 May 2026 06:11:20 -0700 (PDT)
X-Received: by 2002:a05:6808:3a0e:b0:464:3d5d:d9d4 with SMTP id 5614622812f47-4854a48aad4mr11012365b6e.39.1779801080561;
        Tue, 26 May 2026 06:11:20 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:15ba:1d70:65ea:9578])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d5e484sm34259426f8f.30.2026.05.26.06.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 06:11:19 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 26 May 2026 15:10:49 +0200
Subject: [PATCH v19 01/14] dmaengine: constify struct
 dma_descriptor_metadata_ops
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-qcom-qce-cmd-descr-v19-1-08472fdcbf4a@oss.qualcomm.com>
References: <20260526-qcom-qce-cmd-descr-v19-0-08472fdcbf4a@oss.qualcomm.com>
In-Reply-To: <20260526-qcom-qce-cmd-descr-v19-0-08472fdcbf4a@oss.qualcomm.com>
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
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>,
        Andy Gross <agross@codeaurora.org>,
        Neil Armstrong <neil.armstrong@linaro.org>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        brgl@kernel.org, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2295;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=C8t0ZoGUnDPF/P+4BK1Ho5MJ1aexupcCMbMgOX1T0s4=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqFZvnZrG4NrNGJaU2pZ1CupvY19poOELzZROKy
 Qd9YUiJG12JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCahWb5wAKCRAFnS7L/zaE
 w4Z0EACQvm1qeJpD92p8JU9X4LaK7VoaLhH/+IfHP+YsptyCWHPSC3x+qtByclngLxy8PFoLt47
 Oer88xKksxBmBXA1EmW2ZEc0vTFBGgqlICCTBFrKuKn48QnoWMBxHIDwuptDbQVFUX+r4teukRV
 YAPDvm1KNOtw5WMv87ovAZ3el5vf3JpAxvdTHPnv0cuL3VUZ36iO1cvvEwegUUqN0shI/xMsQSo
 z96x9aHjXy7uqfujEhXkwKEiAmElCnQ+rodEgxmWvZY4Ez0tiq2yJmeAv32l2+un4s7mn6r4Epr
 bG6JzPCe0QfkCPEvy9dBDvSqAKA55RUyQXJepXG7QyQGAlFNpRjlMT9HrCeQSelyEjPNKRvx20k
 tpAELXXp43qk9h99cL10RLdO8vHwadsJWMHaCioMMMMuUZC7YOsC4grTawzERt5PoKe0TlXiBZX
 tjz3oCUW4l0woFPjZpkPmRj2WP9jbkUBf3KIEMbueS2zxADXK8x9rwHTYxGCkPCH9BBzSXwO539
 sx3eWF3YkEvUvXMIfEq7HP8IlR5bdp/fTKTMcBJiAyVyvhy5tuJ3mWA+2aAF8Hx8Cc/PtUndQpz
 V5JJ63bGin18PVzjZEZ5rztg/+HxLwAKiS5BwEMkqglo9XF8XIIPQ0IyMXteYHhDmcTXSNIwhuk
 BBhMOmyCRN0DaBA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=Wpwb99fv c=1 sm=1 tr=0 ts=6a159bf9 cx=c_pps
 a=WJcna6AvsNCxL/DJwPP1KA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=XeVHrwws4l7kqE2Ex6IA:9 a=QEXdDO2ut3YA:10
 a=_Y9Zt4tPzoBS9L09Snn2:22
X-Proofpoint-GUID: NlQhTAUOeGGFQUmn4PTURgGNh-03P86B
X-Proofpoint-ORIG-GUID: NlQhTAUOeGGFQUmn4PTURgGNh-03P86B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDExMyBTYWx0ZWRfX9PWsNo8KSNUh
 vkL/rD4JHnrCp/Ow3UPGF3FsWqvA7J9vvbpBr02avSxrUccPyElHDphavhPyvt/MUBxn4FEGqen
 3JhhAj+w1t484ojHO+ab0J8Ls/7k0XAfoFMVm2r3+o3QUt+b6ZkkOdzrQGou7pciKlCbGPU7Qvx
 pNkaxJR0VrHezhyCekb91SpuKm+R90pK+usx+lFpjMixHUXsyfB1WOgGt7YjT03TYZhM3lfESHs
 pwJNGp3sUFHqH3DMkRk6ja/p9E9B/pvsz/rOLqk9NNqOrjJ4/zeNFKRjVtkAjkokVupKupsXiev
 qdEBWHuhqOD4NJiIKu2jPRVwCG70ytAU5vgegFWgxrKUn7GRyM5TkkWEjTO3t6eiD5lTUmiOkMM
 oHmyIN+sn49vXl8wSmqs90W+ABiduV/QROWeoJwDklo6SFum7SJRqhtVwBtQqa+CFs5LcDS5Vxl
 EBdEyXaHXF3KUnDv/rA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-26_03,2026-05-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 suspectscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605260113

There's no reason for the instances of this struct to be modifiable.
Constify the pointer in struct dma_async_tx_descriptor and all drivers
currently using it.

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/dma/ti/k3-udma.c        | 2 +-
 drivers/dma/xilinx/xilinx_dma.c | 2 +-
 include/linux/dmaengine.h       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index c964ebfcf3b68d86e4bbc9b62bad2212f0ce3ee9..8a2f235b669aaf084a6f7b3e6b23d06b04768608 100644
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

