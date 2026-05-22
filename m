Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B5E403EA4
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779457225; cv=none; b=fiaJXUCZNR1voNovCyIgJKE8bMPtY8WAP2n2D7rkBlfHFRq0i6mkfp3asiOdAnz9Y7w9CO4lu9b9VfQOb76Hu4puf3dhERXIZTm7/o8JUFpEzkpuNkgpqlbJ2sh3C6xTTQ8/1xtQOeQLu1Ty4sr72xDlRqyNQuo71SL+YVuib4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779457225; c=relaxed/simple;
	bh=yKvgG0rTvuvJLcjw7C6atYAtuGT91Jlwk9eV3sVaoBM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Y+9nx53yMeGRjahLwkQ5SKJPwH2Ed4WtbT3IAJBFIzmSbQG+/5yClKDybM5of3RMpkDg9korzhUIpyyVPYUr7A/2g5/4jDA3vpH3G+BE6c7NUpY5ZlNY1yeiQQ3dxxuPAVHHTESmGDkKkUO1xjD58aPlD1KCg0nCf4CO3CIPOY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=V9QMcUOi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TOGZXXez; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="V9QMcUOi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TOGZXXez"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64M9CPoU3532263
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	j2g7T67hXwVirNiCmNO6EC06JYgACQ8VaJoiHLwm9Nw=; b=V9QMcUOi7GuPFjlk
	iWsdKoKhc5xnnmNqA0jCFDOGNwx6V6T5eNUHnqAMEHx8ivt1habATb0HlK1ov731
	BBX/0y5CjhIaETy3u2BdCIx/G2q+d4wb6Rci9txyiVFK5yQRta/etS16TAXGTI6C
	Q9gbYtn3lC/yBbW4r0+QArhi/hVwIeejFvhmkHCjwM+I84lHjwLaOryxzD+3p796
	KuVkqmCw0dJOHOMKjGnqu0dTsupbo3QKywOmfbnZ5iHvsh/I0vwmKV6ubhfCvxPL
	SzHkR9RKFkuwjHkdOcg92wocaDkWFZeFhPpqGscNHbCyO8Rc0RyxpL8o36BA0/e1
	g1y2NA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ea39gw8u9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 13:40:23 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-514ae0e3ad6so186240301cf.0
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 06:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779457222; x=1780062022; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j2g7T67hXwVirNiCmNO6EC06JYgACQ8VaJoiHLwm9Nw=;
        b=TOGZXXeziVN6nRQOSb/FeaIh5KGZ6tlHxbneL/e4SR7ZhcPC8epqGPv9DeTMpN4s62
         4Fmqm7l1S0IoM+q+y8oNbwy67ZTQWHmw1JvqGHurXn+WEYf3GDWsOr8BbNCCzu7dNc11
         ZkXfsRvfl2q+u2vMd1JhN103vEtttiIcYe3p3gefWNImo528t2aBv1C2et+xxW10RIwd
         UH6CT7pBtaqeFP5gxG6nbGOwlPf1Rgsg9CqjYx2A39n7bOLoPVjaiZVmKsccCPMZUVC/
         COJl/H+7hz8en+uhEPo5qcY/AEmwOGkd7Ty/qCehWJNbTWent7r7soK2rSul5GDMdQbJ
         VjUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779457222; x=1780062022;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=j2g7T67hXwVirNiCmNO6EC06JYgACQ8VaJoiHLwm9Nw=;
        b=dC9MvvwelNuIbilr/uNWHVV/rn9Zrzlx2yA0uv8UCUeSbdSSKGVtNz+tlQFfVQJQY/
         DjL2SX2Mknjo+2/aRzEDVCp5R2UxkVW8aJCoBcKw72QlCuB3IPbkuu2DUalppuw6mXU0
         3/H4v3p3Me5AeFePQJXBnCQDux8R/r1w/DN2dvv+ilnCPlJRren2aCRm7mgjSvSfNhJl
         h4fiXsGIKPQ9l4ITJdCxQnhCg+fWNOka9i8o/EhrGSRi0cyeasXsY7p0PQHshEJMgv3V
         ZjbbUDt3AlVpf1E3Ri4c/P6dpk/yj8G05GFpJD5r0epCfk+nxPq7kn+oUVzPVFjkGgfw
         N86w==
X-Forwarded-Encrypted: i=1; AFNElJ8TS6w0YG+CHJwEfytuRIWHaMAwe0MmYvDOJXccj6XvoSDr+mB4VvEjCH5jiqFAvXmfGp6uH1vc18lUIOw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxd3VJeKik+qYPRdNw6BbpxRkif3KKjtmA4VgbRgp/lI+qGw5LJ
	cZ/xPz/2p+aUv7880BlysI1Xp+qQoCNzVVHSWG9RbEMCqKrVC8iyvCkCQL/cwp5nim2B1TUz92l
	Q2MKDXKndmQ/0mf2M2F/gEAaue0vqD76ayABfx1kMAhmQ4lI10a8jTPJgg2HElgU5KTL8GGM1aM
	0=
X-Gm-Gg: Acq92OFgfmTehO20bwDJBF2jDPZ7vSI7Gx9Z5ekNnwQNt9oVc7uTpYLt7NgoKuw/Do/
	7ceBBOJmlayAMBlhJJmyx8i6QydfW60pdafEnxStDJQAv9CaMR2UnNUTmslOWCajCakUE4Jikxt
	4BvE7jF/hqn9l6jnmdzksdcmSpqsteXoPmi7ZsO5UhLcUyMLgO6t9W51Bt7x8I8qevkZ+Z4qPLP
	d/C+Tg2BsC8j0jeqvw5kyu0T7s2lCE20eq0s8giY+WCfKvFa0z9vbLNOwVRh6q9yPLv+xWsnDF5
	wP2kMA0qADY1nI2aTIvbZB5WbbLdpK828W+Vv8npDVQxlQdlWpBhjBWp1XHKsRre9C5wyUqeI3C
	vs92eT/a1swDvtdQRWl19J4cTZhiK9m1AXRU2tzCkYD981bQx+g==
X-Received: by 2002:a05:622a:a90b:b0:515:7d69:4c0a with SMTP id d75a77b69052e-516c54cdacamr67015451cf.2.1779457222345;
        Fri, 22 May 2026 06:40:22 -0700 (PDT)
X-Received: by 2002:a05:622a:a90b:b0:515:7d69:4c0a with SMTP id d75a77b69052e-516c54cdacamr67014841cf.2.1779457221737;
        Fri, 22 May 2026 06:40:21 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:2fa:6280:a48f:fb37])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454c600esm44912825e9.3.2026.05.22.06.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 06:40:20 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 22 May 2026 15:39:55 +0200
Subject: [PATCH v18 02/14] dmaengine: qcom: bam_dma: free interrupt before
 the clock in error path
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-qcom-qce-cmd-descr-v18-2-99103926bafc@oss.qualcomm.com>
References: <20260522-qcom-qce-cmd-descr-v18-0-99103926bafc@oss.qualcomm.com>
In-Reply-To: <20260522-qcom-qce-cmd-descr-v18-0-99103926bafc@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2764;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=yKvgG0rTvuvJLcjw7C6atYAtuGT91Jlwk9eV3sVaoBM=;
 b=kA0DAAoBBZ0uy/82hMMByyZiAGoQXLPIYQPrnZ/xYu60uh01cd0qPgA+V20Gnmo2k0X5SkfnW
 okCMwQAAQoAHRYhBJHlEy3ltUYde6Jl/AWdLsv/NoTDBQJqEFyzAAoJEAWdLsv/NoTDIUgP/1Rs
 8KhvkXDlop1eW5Zm2UYtzwQ8MWsBJXIcYHv/LvM40EtGmuKFx3Dv1xPh6uG/54rAtUWB6pdUTt0
 Rt9yQ7eXGUbiO6q6HRm0Nh7SCwlHZEAAmfB/vUQqNa6+FQ+vRujcfXj3tPs41Ra7H848YAYrCJ6
 tMMHzVsFSeQ2mEQ9JDc5cn+F5Z3TWqq7uNfrAxocXFAvdO7/eg6zQrjEbqvWyPB8xxwK2mSoe0d
 tTTRZdmXS9nGoYK6CWq/r9W//W9Ur4DRnzVOBCXsFBsm5Px08pp4sdFZOQC/pBM8mOnZVLmBJ11
 tMSI+TuVsEkxgEfu3OsMZQrL42RDjyrOl4bgXD6GiFERrp6+dU8+KsQbzdMmRTAi30wncJW5wD+
 0XevaHhE2m1YkGstKi6MLn7JQYlXZwkVJM/2k2BvFRDgHel+nZp35Ple22kd/s6/Vw0CIIFlczO
 kGtLE+okV0fbXc0IXMEZhP2ybDw3YrIJQQqLl4P4R7EqaGGcOZEHIJRsZ+ijTZTowqV9854hMnp
 Qu52D3mczLLjgod+IrcP+e5SKtmlZa3jc+mdmI/N2lQiPM1unFZGtUoQ06Lxl/ljfLNwwU8RhIs
 w7g2bdH6iZsY9W7MZdpBnc2SWBMojiIBcy2eF0Xgcj6Mnq/O/84w4q0MwypJDN0BigyVnVRWhT5
 GIU7R
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=Yr8/gYYX c=1 sm=1 tr=0 ts=6a105cc7 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=c92rfblmAAAA:8
 a=EUspDBNiAAAA:8 a=n8zAjjMAgf0wD31B80cA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-ORIG-GUID: vy5xzb-yg6OCIk_8FdH9jxBNPKRNpvE-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDEzNiBTYWx0ZWRfX2CLMhlFlBUGl
 ARuw2BPmqViEmWlmcUVS++Lb2EftyC3Ly0t1xQ1VH7mmF1zF6IGZT2gmSiPPtcwMoCxXgFfbiDC
 05wzTTGoMYCQX+4Z8Q8P633Z72MLmQxo5eShdkyCHopZanMklZs/N2G16twMvvnZ49rbyNUsRZk
 03S4SN5vK1LoPX1gr56/cupbyYCzCLdMce/ytW6PyoN+/M7kMSLsOaXlYktvsOI3elpmXz5nc2H
 fCPOZl5obj88LwSQztodbeGFthpYdfzySUbx0CG2JK+mcJAOPVxBdns98e+ALdOznA7i5e6oixl
 YApZwpMXMlvM9k/jV/TT1c7ib0o04SWXcVYFuwZp9RQ53Vq+UCtTmaJG4XrWvPTv1oQAhwP3BzP
 0U1R1z9iGTbtJfFfdV6AsFUT7Gy/zH1uW34cM6BFEmqFjQXc2sR16dLhYCk0AuvNFFV3gAk6em/
 6565+S/u8c/N8vnQKIA==
X-Proofpoint-GUID: vy5xzb-yg6OCIk_8FdH9jxBNPKRNpvE-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605220136

The BAM interrupt is requested with a devres helper and so on error it's
freed after probe() returns. We disable the clock before freeing or
masking it so it may still fire and we may end up reading BAM registers
with clock disabled.

Stop using devres for interrupts as we free it in remove() manually
anyway. Add an appropriate label and free the interrupt before disabling
the clock in error path and in remove().

Fixes: e7c0fe2a5c84 ("dmaengine: add Qualcomm BAM dma driver")
Closes: https://sashiko.dev/#/patchset/20260427-qcom-qce-cmd-descr-v16-0-945fd1cafbbc%40oss.qualcomm.com?part=2
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/dma/qcom/bam_dma.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 19116295f8325767a0d97a7848077885b118241c..b3d36ea79984385fe0d05ce56042d3e6e3030c5a 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1302,8 +1302,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	for (i = 0; i < bdev->num_channels; i++)
 		bam_channel_init(bdev, &bdev->channels[i], i);
 
-	ret = devm_request_irq(bdev->dev, bdev->irq, bam_dma_irq,
-			IRQF_TRIGGER_HIGH, "bam_dma", bdev);
+	ret = request_irq(bdev->irq, bam_dma_irq, IRQF_TRIGGER_HIGH, "bam_dma", bdev);
 	if (ret)
 		goto err_bam_channel_exit;
 
@@ -1336,7 +1335,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	ret = dma_async_device_register(&bdev->common);
 	if (ret) {
 		dev_err(bdev->dev, "failed to register dma async device\n");
-		goto err_bam_channel_exit;
+		goto err_free_irq;
 	}
 
 	ret = of_dma_controller_register(pdev->dev.of_node, bam_dma_xlate,
@@ -1355,6 +1354,8 @@ static int bam_dma_probe(struct platform_device *pdev)
 
 err_unregister_dma:
 	dma_async_device_unregister(&bdev->common);
+err_free_irq:
+	free_irq(bdev->irq, bdev);
 err_bam_channel_exit:
 	for (i = 0; i < bdev->num_channels; i++)
 		tasklet_kill(&bdev->channels[i].vc.task);
@@ -1371,6 +1372,8 @@ static void bam_dma_remove(struct platform_device *pdev)
 	struct bam_device *bdev = platform_get_drvdata(pdev);
 	u32 i;
 
+	free_irq(bdev->irq, bdev);
+
 	pm_runtime_force_suspend(&pdev->dev);
 
 	of_dma_controller_free(pdev->dev.of_node);
@@ -1379,8 +1382,6 @@ static void bam_dma_remove(struct platform_device *pdev)
 	/* mask all interrupts for this execution environment */
 	writel_relaxed(0, bam_addr(bdev, 0,  BAM_IRQ_SRCS_MSK_EE));
 
-	devm_free_irq(bdev->dev, bdev->irq, bdev);
-
 	for (i = 0; i < bdev->num_channels; i++) {
 		bam_dma_terminate_all(&bdev->channels[i].vc.chan);
 		tasklet_kill(&bdev->channels[i].vc.task);

-- 
2.47.3

