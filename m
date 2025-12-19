Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E673002D6
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 10:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766138924; cv=none; b=azGvlCY1BJ0HTkZ8X400pfZwPKUbGRddKp5sZR4VVdxQn6nOBbSCfLtsGi3PFYJpmHVE5r8MkUMN6Hh2p1RO0LeXQ1MmGrieWNtut3/I4XBK2OvUO6/d6rtVopx/519wXDFPnD5YUa+mZqFSes8Xiwxu835/SY3pskOrTCuLFhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766138924; c=relaxed/simple;
	bh=FnVBtOe0OnnBy34d5WsqwWSUvkeiYQ93/vJc1qwp/2M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SBxL+c8a9ztIeFt7LpWGDol3JcdsZpjM1vZUv2zaJOgjgZtNQViaDeDnMekxx0ZEyIthcUB+KwN82AOAI5v4r5fknZrQDhnnXuty4dsudzMHVgfavB//OlnwHOBLajvBa+N+FpGOUsLfeCng3PqZ8JcbXOBTfiyBLvLjEIZx25A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=T61wVVoE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=BzdTy3d/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="T61wVVoE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="BzdTy3d/"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BJ4c15v3990905
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 10:08:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MnBQFcKPOgFHzTGJJB4DToRykxT+JvIdZWyKHEJZL1c=; b=T61wVVoEF547vU/m
	/4wzOx1e+sZFk7oSZAq4Et9N6dQJ3zOtTBbDrpTFNSqb3pvrosLMx5bfbPzER6tc
	cw27Um1x+yOFJA/KD3aE4m1vSqbwOrkuWvbiB24iYAqgkYZxnPF2ANDL582qTs7X
	9GmBkDbxLWd58jyGUFnaHKz9NuV539sDf2Ug3q7o8dHHmVXql3ZfcPWcITajD69B
	pQj26GyYXes4PQjVYE0q7F55MrFkJykSRDJkN/Eb5beacNOQfmDE+SfjcfhOShVq
	7TPbMIrFdVND45Z4dIVWrIKyDoquPCH94tNLsx0EKRcanEw2DcgNgkyuf8B8uoR1
	0gmzfw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4b4r2da6nh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 10:08:40 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4ee0995fa85so40935431cf.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 02:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1766138920; x=1766743720; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MnBQFcKPOgFHzTGJJB4DToRykxT+JvIdZWyKHEJZL1c=;
        b=BzdTy3d/iO5E8K/yywLH5MYQK2g/aKPBaOyauRLK5I/rH1EP/M72keAB6affn2nQht
         56pt7W4H9Wqfe0C13kPE4bBRuAqrvD+PjzPIVoVZw/3dbmnltvN87rLvmhY73UPefmPr
         t0biJL+wSwF7aAWPRrxOP36vZJ74gSC8OuS8dXWzIVGaN/fEVLu+8STQ6C/89RMubO2o
         2W4UpdHruBbQKbDmwPFTmBJLbdFmrUehMZV53h0mai1PnFvuZxAuwIk1sWMECMvzMHgd
         ACGBjTGxcDHwRo3nLwq6DCemr3hLNZ6sauKsfW24DTqjJMhekbWohp/K3UqCvzNXwaEL
         FM+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766138920; x=1766743720;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MnBQFcKPOgFHzTGJJB4DToRykxT+JvIdZWyKHEJZL1c=;
        b=ayrKNpcXoAhLfcI4OafBLdhraXTL9oZSCpTTjjX64DC0aA5UIEZ/bGG1Zj6z1bfRfz
         iVByp4xysAs7tCQ3mxT0Nx1wRA7ky82L5NV34JnTILFrlysDV71FGMOI31r6G6M7v1pE
         03tguDjzOF+eGp2+imhtrK4UlsnIWLpUyKIpBMvwiQZVhpy3FpCqD59j++4NDaLQ8bLA
         OoNRh9s+xPPw7RStPgAukOoySv8CGUUP81EbUt8GWqYb1z6wfTJmabclA9vR+m4F1UUN
         TWQqijwMT3bs0FTaTG1/DH+IDQ0RGxoKgQN+Xyc2l1FozxRAMGOpnIeizu40Ba5Xy+cr
         xbsg==
X-Forwarded-Encrypted: i=1; AJvYcCWVvEAm9HvHL2m4dMUZ5LXPmKEtjU321ozmZzHSal2ZXkg6UWsU0oI2rlGp5Zvb2CjHoeJeG+EMvoUkAJU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuusKZeWcZINxOYHEsHH1eHRTYaNe3ooI+03k0Ul4LLl2rfESC
	s28kDzXlY2bd7gpI/6jmUu0iZxGnvoupkfsmIuXZ+AXYCSX869TM+qzAILkEMMNYUCePYuDOuUV
	MSRiJC6hHDyV0yCOaFY/qqM6YBubZI44jhfvOcH87whsUmfIe3mC8xgKtJ1QovCe7seo=
X-Gm-Gg: AY/fxX4OtEhXuQw4mPEnoDPc4h0GFxz5xWGWBtHvWVq77Ajzd1Y2uc0HK7Zhwj1tG3t
	OtpeLdg7EqUQphFzdWOp0FDxcLqNcAtgUb0IjYDY7Qw9knQ4RTulG1fk/58cUiwqtDav5zcR2ZF
	v5ANQYtN1egNgEd3PEJMu9vDwvl8IogavkLQctywNLN6FA/7KE7B9E05PTyROMlsRHNpgVbKzS7
	1MQO6FJhb1qohcoygw5iIQVUcb/xFelEj5KL2ILuPMkcSfajSKGOZCSf7sTVnNiixGEjFKDJFa6
	aK1R73KMqAyhtG49gF/b3ly/rWdJG2j9tDMKbOIbm8NjxOSXBlvkN3azbyo+5HbAzgCIlrv+Mlb
	pMSndqcHK23qJG3PWolTDIWr/6IGL+NYiD0Fe8g==
X-Received: by 2002:ac8:5d10:0:b0:4ed:64c1:16ec with SMTP id d75a77b69052e-4f4abcd2a4fmr31730131cf.23.1766138919789;
        Fri, 19 Dec 2025 02:08:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE8evzCuL8bcIFiYtwnbQ/Fn0Agh9kHBYubQBpio18ThoiXkcAeiVzR8M+80D4wHn1z4oYyWA==
X-Received: by 2002:ac8:5d10:0:b0:4ed:64c1:16ec with SMTP id d75a77b69052e-4f4abcd2a4fmr31729791cf.23.1766138919351;
        Fri, 19 Dec 2025 02:08:39 -0800 (PST)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:a48:678b:dad2:b2eb])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea82f6asm4209571f8f.27.2025.12.19.02.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 02:08:38 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 19 Dec 2025 11:07:48 +0100
Subject: [PATCH v10 09/12] crypto: qce - Map crypto memory for DMA
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-qcom-qce-cmd-descr-v10-9-ff7e4bf7dad4@oss.qualcomm.com>
References: <20251219-qcom-qce-cmd-descr-v10-0-ff7e4bf7dad4@oss.qualcomm.com>
In-Reply-To: <20251219-qcom-qce-cmd-descr-v10-0-ff7e4bf7dad4@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Michal Simek <michal.simek@amd.com>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3159;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=gRGqUxioVpJcY9zBfeIZn1vIilzfanwkfyseaIOaQFk=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpRSQV6J8jitsCsTQ5/OCwoTR5WiYjuWzbdVisp
 7XbUnPmV1mJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaUUkFQAKCRAFnS7L/zaE
 w7a6D/9U3orOciDL694kuvhMWVRO2YzSkzD6x/t3Ztw2vC3h4+TiTwQEF+992n9vFsjkpatfTL2
 K/FtjcWUAZ+xr3iLRhMrdRtid2SV0A6gtP5USRTjoyouHgap+p3JGs7OKq+q6l65BjTJg5vzlV6
 06/ZWAnswsVPU518NSdHmcEq1hOKvcOxgowU64ok6ZvjqepcruKfTJT5uPLA48z1IhTs1A/bAE4
 icRNm6iUQ5OmBbFCvJszbQ/w4ijaSd40+i2ag/I5n4G5y3XRNzO4Fu2eZOwVPr87yfDRU6qKcuD
 ZHHOYqm9Jo6Gfl1G0dvM/ZXtP66DqAoNJN7aaaCHtDhApBnNTc7MTquaHp853P0rO+HLDmekALP
 7tj6E/jJnjVzJfEgpZu3G8Vf21O1ph+tjq9hth1EOIDIImmNtF2V0paGsTELJZYff0jAQjffAql
 RisGP/ZPauZRYeo7HW9WEkTVrdmKA1wYjzJENcYdFTAuPLyIl9WmJIWDJIeCHCEkGfZRBIoEc8d
 S14UzHCwiw3YOAtj4sEvhRtxFcNPBmSQM0L7Vg8s0sEzHddoOG6LmXM69RgZYLURpQkbiDZlIcj
 KrCWJ4gYv0nrXbJHVBD6+kbZfYUXY5hBQQt3UOGbV/oU3iA/aJgykcsI+TQm7saK2Ce9cpHPnBG
 YPGM3dadzHnJmCA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=AcG83nXG c=1 sm=1 tr=0 ts=69452428 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=76fuQ0JqpD8MvifAs1cA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE5MDA4MyBTYWx0ZWRfX7vX0rXQC1oRo
 m+nKR6PQb6pdOhin5JJtILalloaF4qqaiwE6xjjt+gHzx7HZb2HGbrX16ERygWwFKmSqdcoDeUl
 D6Xatf0MzcyX82h2TbZ+iwNs+A9nY8Tg/3fi8HVedWoKM6joRYbAwJ8KYE5QARqkYhldkfiWq5X
 1NI1ad2gSzQOS0d6ZTSeTSnwtFRWFJIA5b8njRtfZTM07QQM86NXRSjm+lt59i3au94iaPxidVM
 cIgFkPvzd3gjmmC/xx18I2EkPYuLBcUs3nbqMgyjEx3hep6kert0tP328zb5+cW7lqREWu0jbpz
 aEm1s0kKANQWDu5wL8YrXCjfJMi9zfpYP+CXZtI9Bt1YZn9Ac87HHGYIELbddC82QHIpJnFdT/C
 gIOVrZtzbNyTUkVP2lbr/NKSCujUmCeZfqJyrBkeN+CyIVzxXCt0SOsdWdTCmhrdp9I/Ln1TGa6
 GutF75CZ3qPA+HmIVmg==
X-Proofpoint-GUID: GHJsUhw_fcaghdPhHW8V17sZnF0uOmi_
X-Proofpoint-ORIG-GUID: GHJsUhw_fcaghdPhHW8V17sZnF0uOmi_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-19_03,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512190083

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

As the first step in converting the driver to using DMA for register
I/O, let's map the crypto memory range.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/core.c | 25 +++++++++++++++++++++++--
 drivers/crypto/qce/core.h |  6 ++++++
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 8b7bcd0c420c45caf8b29e5455e0f384fd5c5616..2667fcd67fee826a44080da8f88a3e2abbb9b2cf 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -185,10 +185,19 @@ static int qce_check_version(struct qce_device *qce)
 	return 0;
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
@@ -198,7 +207,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	qce->dev = dev;
 	platform_set_drvdata(pdev, qce);
 
-	qce->base = devm_platform_ioremap_resource(pdev, 0);
+	qce->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(qce->base))
 		return PTR_ERR(qce->base);
 
@@ -244,7 +253,19 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	qce->async_req_enqueue = qce_async_request_enqueue;
 	qce->async_req_done = qce_async_request_done;
 
-	return devm_qce_register_algs(qce);
+	ret = devm_qce_register_algs(qce);
+	if (ret)
+		return ret;
+
+	qce->dma_size = resource_size(res);
+	qce->base_dma = dma_map_resource(dev, res->start, qce->dma_size,
+					 DMA_BIDIRECTIONAL, 0);
+	qce->base_phys = res->start;
+	ret = dma_mapping_error(dev, qce->base_dma);
+	if (ret)
+		return ret;
+
+	return devm_add_action_or_reset(qce->dev, qce_crypto_unmap_dma, qce);
 }
 
 static const struct of_device_id qce_crypto_of_match[] = {
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

