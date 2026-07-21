Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C138436C9E4
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 13:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784640856; cv=none; b=qilbIa++TXyRABj8z/ugcBLaPa2APiQipqfcVVg0WIAaGhFo+pgP9hY5PGgu/6a083r2RrHTP0ruc9L6uOXWFsg9/ChgzlmxCNg7C6VchPbU5StPCsGkKR1aGgNCSYzVIkVe5EByEhvrNCkow7LUOuUBx/pJyy6rN2Q9vVjsgyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784640856; c=relaxed/simple;
	bh=I6qozPBGCCC+qW2tSIhDtPr1pqACnLdSRJYO6Q/jVhw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ELCEmP3bUaR2su8+VBJnCJ6dthI3c+y5131TRApzO5AefJDvKQ4kksxhjtB8hO0YsmFQAHHlLKvkK6x10piKThkvsldwDjnRstLvweJUpMh4eWvHEFTr+gnvTgacP4zQnMIEoBZneYU54Y1nmBlc33T5PoiyLz1uglpU936Enzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jPc/FU+0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QjAQ4hVg; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jPc/FU+0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QjAQ4hVg"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LDLtxG2023903
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 13:34:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/ulYiF5q27l0HtYTWxPl+5HbnGbtV3QzEBY0v8bm+NY=; b=jPc/FU+0Xwyr6zU7
	bUGyesMx57JquvsPFvaYb/49hZZ+ZcMywVRqpik+BsQxZxEz+WZwA/MosIxhuz3b
	19RJiWjFvPidQv4YpNLf7PJr0mH5WKnjDADRSPY89vxvgHHXWZVoApmjRsYUaL16
	xJkSbdRIrJKbcD5p6isfNMoYXaM3YTK1c1HPp1+22U5l8LpQ6JDw6aaQItOxI6n9
	pH/x/ED1DpbCTpMfjI2iM9nbEYuVNjAJqm6+/uhPhKsx4hhuAqxZIvBfkJiEopoT
	MEy8yS3qorgm7iXyF81GauyZrDuHykK2rZjmejKtUwFPgthgn2OqwpF1BCewRKwT
	iI7zQA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fj6r3gxed-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 13:34:14 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c083f1818so150170741cf.0
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 06:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784640853; x=1785245653; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/ulYiF5q27l0HtYTWxPl+5HbnGbtV3QzEBY0v8bm+NY=;
        b=QjAQ4hVgQxogBkFt/U1Z7eROmWfRYka+dIi7ktr7xEwrh0RYpT3I1Dm83ARw/YnxCi
         aiLjJzRYHz4fyLFOfqdvkBaV398CSRu6B88hJcW9JRIC4/+h7mOhEbIw/xUUK+Cq58k4
         t9xZq/KxPX4yZ4sqBq+tl3k9HMVoR9iq8Db/iwuyalhqF3PcdVyhiKDVa3eFZ5np86H4
         59YOP6l9oKDpohgPPm5yspAsVv+y3pJCuBacUKRNOGICavLjUiTx9k3xivfgAwsTaB1X
         aJIoFF2gea34+QOoKuVEr5/P1u5krYjU1JR5x68aFyQ0QuYRbLQHCXyUe8Q8RhdswEc2
         rKtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784640853; x=1785245653;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/ulYiF5q27l0HtYTWxPl+5HbnGbtV3QzEBY0v8bm+NY=;
        b=rgW/RhS4N19LzzrQ0Dd57lz2By9e59X62SiBnc95oHRJGiM2n3rwW3tqrtASaqTzaw
         J6joWgwwvjoKMO+fj2heEcC/nyJ9vkgMNCDvf+u8xD96hwnMhR/zPiKBgXdszZuzM4XD
         bG9mJC13caDYaW6v+zzjFN7i0atb73ZvD17wF5bCB29RjHtJ7DTRNE0ONVu2tzh/xFHf
         WFIlVRmO5wlm9X/h7YhTPRflUzdOuMU8Vzw5paeVIgw3gOnTtBuazfxcJX9tuqe1O8IR
         fNnqgFjtjFFlONuUM0v/hKB/3SpRTFIVyr7EsJlrM3XtacN6IWRuSRQ69Iqc65hJKY12
         Y/9g==
X-Forwarded-Encrypted: i=1; AHgh+RqXlRQLDRhTXhKPEKwh8l9NBJbNxiL/G0Qp9SD3NB8P5V1YNuDcpAMDjeN22GalskbDF0yIdK2O4K0GLxs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFHPp1UwBinwD78ArVmrVGo0Wrw7Muz2CJm1NhUBE/nxw4y1LU
	TdxbbPC0qC6Z7qaotA4f7ezG4ZxSGGq+7yN79dgMUdt4fu0DsuCBx1ppLoGpIYTkYGDTLOAofFl
	JCFe039YXYbaW584gLZc2hNs0mQ5djZM0HgqDKV+nt0CF8AzgCWgZ1c1HspYQvENbVy4=
X-Gm-Gg: AfdE7cl3fZfY1jQrw1bJ53klX2FYGtJo39ccvlhW4yGkkUmCyfW3BOPWOewNR03EmSb
	4utPG63G70fam3r6bYQyGhGIpjmHfNqwLVMdlHyUeN4tOb+7Gn1QRT5gupwnsELhrAAorBGoAxb
	G5+fQ285KxMQG2hQsDdSPMJWiwzpcFRucArt7/VQslyjhVyb8PQjpjrtlBdhic6uMRatrLK539j
	hfhGzbMetKwm3sjLjKsAaITzzwRN0ekhIpu4TzaDf9Y6cfQFkEm9EFSmwNKAZA9RyrMQTn62C2Y
	4/v3ZYbw4E+5HCnhX2Y7rDJlDLSsChACf6jMzLSi6kUHTKluqfVq9wNnsoJrXnFqpdcHfvYCv3s
	dtIq6W7usFMdO1ddnIukK4exczTWA1A==
X-Received: by 2002:a05:622a:1b12:b0:51c:167d:b345 with SMTP id d75a77b69052e-5213b146ffemr155608341cf.24.1784640852963;
        Tue, 21 Jul 2026 06:34:12 -0700 (PDT)
X-Received: by 2002:a05:622a:1b12:b0:51c:167d:b345 with SMTP id d75a77b69052e-5213b146ffemr155608001cf.24.1784640852362;
        Tue, 21 Jul 2026 06:34:12 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:9dcf:9ab8:bffb:ec35])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495499d1d4asm237901185e9.2.2026.07.21.06.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 06:34:09 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 21 Jul 2026 15:33:17 +0200
Subject: [PATCH v23 12/14] crypto: qce - Map crypto memory for DMA
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-qcom-qce-cmd-descr-v23-12-1be02deffda9@oss.qualcomm.com>
References: <20260721-qcom-qce-cmd-descr-v23-0-1be02deffda9@oss.qualcomm.com>
In-Reply-To: <20260721-qcom-qce-cmd-descr-v23-0-1be02deffda9@oss.qualcomm.com>
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
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3111;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=zV1OR5DiqlcnDzl6TeLEQ0wLAWkLclKWK2ow4Gd4Hb0=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqX3Un/B4sUi+B/dVJaFznHoX10XA1vghqMVsur
 E5foyX/j3aJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCal91JwAKCRAFnS7L/zaE
 w3PdD/4yYJmvx3O/tU4TNPLja9G//Czlr3VKIyZcL/gBiQ15z/nZiwZVJZE2b5cn6VQ3MFdHhLh
 F52K/+T0ic9z/uRZogZX49SeTr/lUq7JdXkDEMssyLdpfU2dNmRBaGzTUqzB2AaSFf4QWZ6guOY
 UclVrcQCrx+QeQ+BjvcvUNs3/18XjiMNCxThtSou+9yxEPGbwgVUAqMa38fM3jowTf3MztAUPh8
 VdJb6U0/Zsv1avF9LMguUVyvnwQVcTiph03Z7eOZnyzmi6ER5PHLodsNx9FSgQ1Sin+iDnAMvXC
 DQFsEyo6IpuZEp52pzHc0jdFrxEDMBn1QrRqN/5L4+mRJbdBxYBPZaGliHvrhXxGRWl4vVcrDlG
 +fcYSJ14DbVFHyEq+h0EzJHDRxu/UVevpK4zcKiP376myKw5lhkUoa/WZmQbqb3cdoC1Cd53Dgj
 zm9us7ZAKgaaecK6kXjnDHzMRqgfabcWbnaszl/M9Po7whdH6EMNYP5fQ0R8UVQbFZzFeEzDfAr
 1Hg+DVBGZvTDaN6jr3PurtcEcDwQS+RvMb3Zz+epLeQhNaViTarv2BLRdS03Bo4O3sKWUnIjvdS
 LarnQBYMmNBZQvqi+t/Wls1J7kRBflE+NdGj341EqLWcT3zwFOON0oDPpo32KFbFn0HoLUorCh4
 MwEYNV6TRQONrXQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDE0NCBTYWx0ZWRfX3XHelOzcosod
 mXe3PRvSVb9jPEOJAqfAYPPuuA6s5lj60SASpYYLI7ebU3Rd3fBkZ5Si+4M2Vn1qOqctYlMncms
 Pq71zRlNaz/cQe0BNvcl5VKIcBoIO/bbYmQH08WKWljbaepePGprgwPrxGUmNloAkvnx4CxET8d
 TqzMxk539bZEZprZocyes4t+vmiy/rOsrfoYSPG4isQRsYWfQ11PrUWVzcZo9cSm7ESmE9KBuKX
 tzwNoWLhnNI30MlCpgYM6fgFz+jOmx3fBXISiGrgJ5qBaOx4lgMnWK1nR88xOtLy/U+opKQWVvj
 zSmosqx69g9w0jBEnB/QaocZKkqx4vax7oIYQi+4ilJcDSlDgLeensLE1nRhOb7AO+TCwejeWfl
 FHrJD8S0WdRaNtc9EqhRig+sk04yGa6WabYgPOBep7OznJz0Od521WBMBjhbTVcNXt0Th93jtS9
 8HoSVmg1xUTK4wO59SQ==
X-Proofpoint-ORIG-GUID: j3IHSxxnauvOg9zSstsJfZAALao3b2Qs
X-Proofpoint-GUID: j3IHSxxnauvOg9zSstsJfZAALao3b2Qs
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDE0NCBTYWx0ZWRfX2xbpbAyhvkPE
 DbuRZRWVS6OzZpPzciJdbUPyBX/bH13RHr/jwLDDzIAEUc0yh54t6exMxrRlKMI/zBgQSIUyNsK
 z2143KYZ+jT3vFooIXv83qy22frFO18=
X-Authority-Analysis: v=2.4 cv=SIRykuvH c=1 sm=1 tr=0 ts=6a5f7556 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=9tNk7rGwWxUH_P3zroIA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_02,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 spamscore=0 phishscore=0 clxscore=1015
 suspectscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607210144

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

As the first step in converting the driver to using DMA for register
I/O, let's map the crypto memory range.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/core.c | 23 ++++++++++++++++++++++-
 drivers/crypto/qce/core.h |  6 ++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index aa4a0b17749081f1ad653424bc265ee81e348e15..4031b4516d6519fc5024bbbcc439500a7b3314b2 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -191,10 +191,19 @@ static void qce_cancel_work(void *data)
 	cancel_work_sync(work);
 }
 
+static void qce_crypto_unmap_dma(void *data)
+{
+	struct qce_device *qce = data;
+
+	dma_unmap_resource(qce->dev, qce->base_dma, qce->dma_size,
+			   DMA_BIDIRECTIONAL, 0);
+}
+
 static int qce_crypto_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct qce_device *qce;
+	struct resource *res;
 	int ret;
 
 	qce = devm_kzalloc(dev, sizeof(*qce), GFP_KERNEL);
@@ -204,7 +213,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	qce->dev = dev;
 	platform_set_drvdata(pdev, qce);
 
-	qce->base = devm_platform_ioremap_resource(pdev, 0);
+	qce->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(qce->base))
 		return PTR_ERR(qce->base);
 
@@ -254,6 +263,18 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	qce->async_req_enqueue = qce_async_request_enqueue;
 	qce->async_req_done = qce_async_request_done;
 
+	qce->dma_size = resource_size(res);
+	qce->base_dma = dma_map_resource(dev, res->start, qce->dma_size,
+					 DMA_BIDIRECTIONAL, 0);
+	qce->base_phys = res->start;
+	ret = dma_mapping_error(dev, qce->base_dma);
+	if (ret)
+		return ret;
+
+	ret = devm_add_action_or_reset(qce->dev, qce_crypto_unmap_dma, qce);
+	if (ret)
+		return ret;
+
 	return devm_qce_register_algs(qce);
 }
 
diff --git a/drivers/crypto/qce/core.h b/drivers/crypto/qce/core.h
index f092ce2d3b04a936a37805c20ac5ba78d8fdd2df..a80e12eac6c87e5321cce16c56a4bf5003474ef0 100644
--- a/drivers/crypto/qce/core.h
+++ b/drivers/crypto/qce/core.h
@@ -27,6 +27,9 @@
  * @dma: pointer to dma data
  * @burst_size: the crypto burst size
  * @pipe_pair_id: which pipe pair id the device using
+ * @base_dma: base DMA address
+ * @base_phys: base physical address
+ * @dma_size: size of memory mapped for DMA
  * @async_req_enqueue: invoked by every algorithm to enqueue a request
  * @async_req_done: invoked by every algorithm to finish its request
  */
@@ -43,6 +46,9 @@ struct qce_device {
 	struct qce_dma_data dma;
 	int burst_size;
 	unsigned int pipe_pair_id;
+	dma_addr_t base_dma;
+	phys_addr_t base_phys;
+	size_t dma_size;
 	int (*async_req_enqueue)(struct qce_device *qce,
 				 struct crypto_async_request *req);
 	void (*async_req_done)(struct qce_device *qce, int ret);

-- 
2.47.3

