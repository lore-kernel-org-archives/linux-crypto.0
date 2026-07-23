Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D22A47D472
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784826617; cv=none; b=DcJsyZpmLuE25JPxGoEkUqxHyp6hwQNfEVI/rQ4QGVQBtMy+ZG4XLRugdNx5GqZgVcdZ061wTTB6pI+KhvVdmO/WwV189V+GS/K0BjLI9yKKnLQeBRThH0xSNI1WdY2AGpyluVa/JsvWne1fz63nUn1fu33PCWMJMtn9yRW1+6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784826617; c=relaxed/simple;
	bh=I6qozPBGCCC+qW2tSIhDtPr1pqACnLdSRJYO6Q/jVhw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WciINdsQizSf/jxvzsiXDlQBOfvbs3EOPIvICGB92m5DxL70v8M7k8AHj6skfb3eOHlzBtPD37W2/F3HyJDvTFxUMKc8oZ3Lquoy6gAOckAMPOUNXYVuJBAb3Oe1z+EXf5cFhOq3s4lAk1jKIStp4YbugJ9YueyoLYAYAfs+YhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=K39y9gzt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QGzgTGdE; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="K39y9gzt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QGzgTGdE"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NF9N5Y162109
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:10:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/ulYiF5q27l0HtYTWxPl+5HbnGbtV3QzEBY0v8bm+NY=; b=K39y9gztZxLnA4zR
	7bJEVeCZ7GuWpK52y6cVKBXuBkrrvZF5d0Khpzl+E4RytfNggMM+BsIpYAUEa19g
	ElslQqwPQwTi8afKUQQCUZHsL8XItdk5u47ApJvfAcxFoXZ40Mp4V+XX/7jCE2J8
	8VJEimp0H5XFzrEdYRivdxXs6jwB7/N+MXNDWJg2iGdJlofcmA7s8cH/MaSDjGEc
	ECbK9nRLJRQYorJdI7/SAbz0pFdn8tM0it9y+cK6F0tC2WYIp5CMQXTLl1AEB9wA
	PpUtFojNZm+i3u6vw/RxQsJZBy2jcyczwOLnsc6F31dV7TrS3ZIDefhwZR8hP4mb
	fReINQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fknbmgncs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:10:07 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c21c01cf3so14425051cf.2
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 10:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784826607; x=1785431407; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/ulYiF5q27l0HtYTWxPl+5HbnGbtV3QzEBY0v8bm+NY=;
        b=QGzgTGdEyqZXR/ao2c3XGdrcM0pz9gpcmHQTfqLBGQKnAbHEFWN8J2Q41sCii/nhNP
         X5SmDhz6ls2ncUmtAdZwSIwmUQKDlKd+2ZeoJqpP5gKJa6Z6X05PW3QY821NA1T55cwX
         aZg7coDxEdEzS50Q5xIsv8HEzd+zVjOGqQ6LQbSjhDotfnk+c5u2gJgLgguHiveDvY/m
         YR9ylnZ+luW1auIhjTRGDyl0lejb4/q65BSdd1UnmxRO7kNQWpe4q/Wgeh/jWQe7hYwz
         HnkpguGEGYl4gdQ2jOScrIa0Evvii+p31ObnvM4gEciaytnIsI6MI1qH9tYX6jLqLr7m
         wjSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784826607; x=1785431407;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/ulYiF5q27l0HtYTWxPl+5HbnGbtV3QzEBY0v8bm+NY=;
        b=LoiE6viyai9Y2exNXdXMeAzQ3U5L05i01MRYHW1qa9ZTJaPtQLsO874hGOwhTc+iVD
         ipi6xIasrZCbdR23sBbVYn3q8T6/9Fd0U+9LIh23gwAe2ZnnXKosq/LOe3PoI3vgRfg3
         zNGYPj2Kw+qCuy8KzZo1OESkUMvilEjRfaZClDr3bVW2smSXvJaBZEUCpR5BsqxvGe2l
         TWY6xhVWGeqApfo0AFbfkW7ooYtJDS2yxEiQrN4jS+Zy/Q+am8OZcdR/nXFjlkN17H1f
         +Y+Q5NiAgFv9huMyd06bmLghWneSRnevQnikYrnjkOLKbXNNJsnLrgTiaBBhV6KFr7Rs
         rR5A==
X-Forwarded-Encrypted: i=1; AHgh+RoZvs7dqYzRA7fVq2zNS4HkUZBT1z9N46MM8Ba+H2m2Cyd0+dEx6dvpP3lxrIO6U7Tw9XK0zoLYlmRnGaY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdEMMZUwJAK0Xw6jfpFcrspGCGzlnyM+Yjpxi6XcvL4nACGueU
	GXWq/xquHlKLoVjwpGYuCasJFfDRycWeOKouav7Q+haz4HwrjckRIir13puasIpBTfAWFSDS+pM
	ffflzSX2XXpIw66htMmLHfD/C8IlsTSqo8UYbfgA8wTCjmN48MrAzAwSvijssiixbFlc=
X-Gm-Gg: AR+sD10GCA0HvrZbLpt++1v734L3LC56+iWdWmn6tpV/SHpq70gXNOCAvI2h0REFwxP
	fD2HPpDPDxGGW38MurdEcRw5CxETh/j0d++YGE9u8TlSUHRDAQ3dTXUsRUW9mNV/lbOv78ly/19
	k9yenUgA9e8dJ0LCSivTCafR/RHcp1xBdmhtsUWvyU28dqbdYYEo/Gfv/LL0I24FiJINqmMzvxT
	M9+tSeMhnflBJLv9L0BbnfPcIXSZTE4bL26cCqsyirhp+4VOL6RaQi27z5YwIhtuk6oaKrk2gdz
	JO8tEqjpEJDLhHIhpAeTzai4UMWQXVdlEyCHKvw6kuRYQ6GM7pqWhUqMRT5zoB6TLmLdI9FLO6k
	j3LlfhKle2f412paaonnVFKdi1yQm
X-Received: by 2002:a05:622a:c08:b0:51b:f40b:2fac with SMTP id d75a77b69052e-5283df4fea9mr36098091cf.50.1784826606781;
        Thu, 23 Jul 2026 10:10:06 -0700 (PDT)
X-Received: by 2002:a05:622a:c08:b0:51b:f40b:2fac with SMTP id d75a77b69052e-5283df4fea9mr36097591cf.50.1784826606341;
        Thu, 23 Jul 2026 10:10:06 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:cd9c:212:1357:7832])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a64dsm18472999f8f.1.2026.07.23.10.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 10:10:05 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 19:09:18 +0200
Subject: [PATCH v24 12/14] crypto: qce - Map crypto memory for DMA
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-qcom-qce-cmd-descr-v24-12-4f87bb4d9938@oss.qualcomm.com>
References: <20260723-qcom-qce-cmd-descr-v24-0-4f87bb4d9938@oss.qualcomm.com>
In-Reply-To: <20260723-qcom-qce-cmd-descr-v24-0-4f87bb4d9938@oss.qualcomm.com>
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
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqYkrJWYMHq7kgUQ1IfzagISl+V3RwfRRpCm6Yd
 khK5qcSBeeJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCamJKyQAKCRAFnS7L/zaE
 w9xgD/92jcrwEhths1pM1e26qDuDJsTs8VIHecHJGIKG2MtyXCynY5PlgFVfMaFI2Stj/0kd8eY
 G8J1L6CENOXg4sqkzkyCadGZcMbOFk5LrvNWyRjM3pWC7bS/fnMgspSQtm53psPCCWMZeIG35XP
 zcyjmf/5sYnVBKahalPJ8iZ5pjAr+UZuVSJEzUhOCQ8meMFW/nXUmJ3eiJuLUPAAIXtyZxv7ihw
 eyboRKSiJ9jYNRqhln14yyjX1OCzcWswLTyPdpk+nrOI35GXijzwyLAiYpIJVZ4VUAy5Q3RKP+Z
 M01nXfEcldcYqOn5xa2gz+KvkyR8FpMGN6ii9o936kNeN04gsRR4NNzbqK6oZt5AyAQOsSm88e2
 fJ19D2Ohu39cVbAWLJT3m8C340yYc4mMHGPXVeLWOlA+QdroTy8xgjxX7P2Rouz49JRb2RP39Je
 JnPbJMlty2L7uTD+y/LcloDitkR5VoKHsOhUhBZz4nXuJ6nDj+y/NGSTHsB+Sk5xsx4dm4gcC6d
 NVf6XenrRTQzz3SZUDgW/JVDMIdkYsMXFeHqMwBZx4ZPK0goy6K3zVnNoqw0NzCL6xGmMlBEvJs
 3vxdKjiflG/X1ofeGO9yQ8BLW0wtLeJjSjIlAkhzB+MtMcYi23Vb6Qu3vzWI+Z1/jvECmh+x3rJ
 5Zkj+xQYXoASXdg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=e742j6p/ c=1 sm=1 tr=0 ts=6a624aef cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=9tNk7rGwWxUH_P3zroIA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: PWCoqFAByKQJ4xD6qwzqCJM6U33fLrWl
X-Proofpoint-GUID: PWCoqFAByKQJ4xD6qwzqCJM6U33fLrWl
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDE2NyBTYWx0ZWRfXwUE+gtiEKtmB
 t+ZKC5ddvf68nIMkJi+VtacHQBbnxQpC6RL0nNcg2YEyMwEIbYUw2rV5JNGfOCtFlJ2AfStXIAV
 3S0h65QXFTaVnEqgH/btP+mKCBhIx4k=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDE2NyBTYWx0ZWRfX0J/Arkh+6BaM
 +Id27XgRgc2yYNK3X/oI+g05CpdW0h8LFrkXnkrcwDTJR1nmozWM9DQzMYfu1lic2fTsJ8k+xqe
 Y6Fw5FoJzIn2XkesXW63RZJCR5PSpHORLK/NQXabmlfJ3hYnhatgp3MZDss11LINk6D+oHDNzSi
 s70wDAIDR8LwpJkWomWr76BJ0q/HmLzI8k0trcInqQ0uKt5LoTkxodZqGLKLcLaWKgPbwVkMRgl
 1bfJxm2/9JNUsZ+Dje89hOwl6Wuoqjf0cn5+0E6YYCv+adnoDWr6Sq4PTk8qBTKuJfR64t8T/+R
 WIxpxvGT0OGlJfFdP1buU6rnRcMgENycfDGWs37wEHu0j1RdEwOE19idfyZgFndJrzYR+pMB5GC
 3HMUupsVMso1KpC1G4kO7TnoZC25XH/bITQUenYDl035NLGK49Zh6clfHdGtvQHFEXS3lTcvgCX
 coUgkSDdIfnYXyfW8GQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_04,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230167

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

