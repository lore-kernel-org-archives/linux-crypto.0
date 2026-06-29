Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB353FC5B1
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782727301; cv=none; b=da4+4rQ0fIobI7qgDzxM9+Lvrm4H9WzadzcI4u/Qi3p24CCH3W5e7wNTQzuuArY8kz/sUuibhJ76xK0gRGLcAP3ewElTzlL6Cr/4hxq/G37a6KeDwKl5vGHECqe8saMMnBLiZPoDUu9mIcRq+7lrtOnciYoyrq2guqDdAQ7LxuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782727301; c=relaxed/simple;
	bh=4nbFs/xg8cCMPYrFtHWE96AOtkhXxC7yUgPXEapSLFc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ccrf3NtDLbFrFDsDqCBI3mZ1BgpG9i9Up6qWhAtjS/MYU8JyGQ2EjP8rdSKoAFCWLxBVcOD/3fhhVQfbcc2hzact3dAsJmnCDTAAE52wczufW8Hq1drQnP+8CEYve5dnMVCqW4zPgSrLgDETHDI0F5GdPBj5iwod8rxAx9n0kzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gzTrnZrI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Q1/BONtN; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gzTrnZrI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Q1/BONtN"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65T6rC1A2089012
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/Vh6sT+8mC4wwsdE+AaqQfMuc9K2i5dAUjEpzQ2UVhY=; b=gzTrnZrIWRjyuGAM
	OyqYjnhrfy0iiRcMz6IpRLtA4E4RQT4QnGZxauvQUtztx0+CSnejiKqcH2Cgfpxj
	JpK3wI7V/6Cg3/B6km6VMu5IFeoSEXwXZYriiU1DzNISGTVIOQxH91+xD/rgtsjZ
	b1d/c/c7dGSXSbw6Yue4Hsb4bEhwtSVM+xvy7R4DEJ+3jgoAIU5Zcm9OJUFuujAA
	ICiQ8IGIbqUV+cn3gtjLDY/F0qDwPxWQTDnce5GFdEAaWSO81keaCs+D3+SEaLa1
	ghAL8+sVy6IPRtPDrthhz3TUm+qBVr2ySb83MTr0Ve29ErT2kUqySWo8a2FjZcmO
	WJnhDw==
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com [209.85.222.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f3k7vh3uc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:38 +0000 (GMT)
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-9692df7e2feso552559241.0
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 03:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782727297; x=1783332097; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Vh6sT+8mC4wwsdE+AaqQfMuc9K2i5dAUjEpzQ2UVhY=;
        b=Q1/BONtNcq+U4mIxocOAPwAgFvBSJSPYM4939a4FchLC0Q/l8CW2sEPEW536Aih1p+
         FKrhHtO5a/NvdZvXfcviSxxKzpwY8o1PBESMc8KZmoamH2d2pTHJ1YlLSX6Ne9tosn4P
         xBLfRkw+ckEl9IxuFu8Qb9YU3ter9RSsX/CAVwrVcYjOk8l32PU1xCP1XbNnvcEKJFh1
         N/vZrc+rvSw4WUvvqOAkHlGk80huHTJnvk2LlE9Ghd1MEOtHJYzjpWLWohvGY1JDMjEq
         JOSO0DOHkTS3+y9EAIbxWKfDx9oPz3iFfHYkYd2GuHjAg21t0PlzKhQnrX3kjtsIm5TL
         OgrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782727297; x=1783332097;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/Vh6sT+8mC4wwsdE+AaqQfMuc9K2i5dAUjEpzQ2UVhY=;
        b=cvV1AzNCL7jRL0rY/7X6tJ3q+LQI5+Bch3VM7GvcSCzAp82Kx7RFdEkNJRubMOVrdK
         h4siQaONzIXYczXZ2Yn5pgxsqMe1wubY7DXN9KFItSkqqwZUwbJGuU5icACgGtmEFsqz
         2ByzciPmgZutF9JsmcvZeyxka7s3B1kIVG4eaTV3PFpMHSu5XmotmcMtEJwFDOHmYnPY
         WlPlNo0Zftpc88rPNKSRT+/FSNVVGz0zALBNaLEl/e962vf3+5yV2hZ2DzQs1Z+7WaUc
         ZqSkn9gSQbvMgb9nRxXibDWC7EzOaCzJugv+ixRTm5QDgUvwxBScwsitgRh6UzC6ia0N
         vFuA==
X-Forwarded-Encrypted: i=1; AHgh+RrbUN2jLsHF0IWcSf46048wva1ABT7mgMwZG1Bv0lrVO+KxnxLd47YBIS7QXoc9/h7NncawmHknn0cSon4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCxZOeaT9vfMJ6HXfshwaDDU6ZfFvHiaU6x/EeFCAFtVpyJ75X
	lyx3ugoH0XSTIvEEYDNZTuNugnRNSXHZc/+HI7mDqr11PtJGJzWx0bRCI1U0Ldrs3Sp5LibpYwE
	aiXYjw+yciiNb8IJB00Pt30YLgCTjzN0eBqDu+P/OMRKbX7MnODskE4NSzFPR4IWsTeU=
X-Gm-Gg: AfdE7cktDMPuwNoZ3BtXEZcobZOryJnMSLyeqQqV/cD7lHEiVboQihn9XM6oMnYt+hy
	2ftUnnpx382XV/zp+UQi7Wo/bpnMoQ4YuUdGjjNz+ndPClGjXuvCIzCcoT+obn6VfOhPPsfHgUK
	aew4lyjqKJ9P7hhZuf2S6yAuaFv7JtU+7LGRciqt6HUyv7CB3uhiubw/2SrxASz5jYiXsF2Zka+
	3vKE+Kz7A2mihuZZSxKXSCPRP9WOimjv9pcpiAQZZEike/7mumbrf0kbIe2K4dDr2/u3+ncJ4oW
	eYbjehlEEt744vGdXq01lJTQGQ2UU0yRL+IzbZyvJCLDb+AJi39usPKT/GRJaR85K18jOzfEfH0
	09bQmn76bq38yeTefZoUHAQMkg8db8NY9N3Q9F0+C
X-Received: by 2002:a05:6122:d1e:b0:59f:8ddb:2fc1 with SMTP id 71dfb90a1353d-5bdba9c61c9mr19100e0c.7.1782727297471;
        Mon, 29 Jun 2026 03:01:37 -0700 (PDT)
X-Received: by 2002:a05:6122:d1e:b0:59f:8ddb:2fc1 with SMTP id 71dfb90a1353d-5bdba9c61c9mr18114e0c.7.1782727292310;
        Mon, 29 Jun 2026 03:01:32 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:4640:d76a:6126:9b65])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4705f8ea729sm24729405f8f.0.2026.06.29.03.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 03:01:31 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 29 Jun 2026 12:01:04 +0200
Subject: [PATCH v20 02/14] dmaengine: qcom: bam_dma: free interrupt before
 the clock in error path
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260629-qcom-qce-cmd-descr-v20-2-56f67da84c05@oss.qualcomm.com>
References: <20260629-qcom-qce-cmd-descr-v20-0-56f67da84c05@oss.qualcomm.com>
In-Reply-To: <20260629-qcom-qce-cmd-descr-v20-0-56f67da84c05@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2818;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=4nbFs/xg8cCMPYrFtHWE96AOtkhXxC7yUgPXEapSLFc=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqQkJprRUolPJe/4YhzQT31Z4wc6r48G51XF/tZ
 KO2XV27o42JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCakJCaQAKCRAFnS7L/zaE
 w7lMEACqSAAoFegCmmR20sFZI3Mespj76ohU3JQKkxAV9V5VZxXj5XItwyNXet4kzFNbH23afZ3
 yr4yHbPwqVpoXvNtfSgygW8aMeDD/vMcaYVNe/3CGcFW1bvIrWcCqpurlHhXnq++HywTbG7vMQp
 bDnYIaJNOP/GS9IeJXaJC8jQFhT7nNU7vGfnzH4BtRztLopZHPVMY8NbvtRkoJY9T2JNJQnMikm
 2OznF7ujrCXqOaCHHY35pVRRn5ggbcYyNaoKXwAP7d+qVXZuJoK8X0UnzXVJjaym+75FzB8qA8E
 VYtoq5wg2cDbPiUeHGmE+AZE5ydHJYba4RlIIP4Effx/DIPOCcymDrN3K4+CoUkm7WsymNej8Ac
 jTpTuxFqirZ873P1LK3kvuAc73WeVm0T2GogHvqS95nWuN3usU6kqZv/iEnJHXqAt41ihzWvalU
 T5Lna6D2rH24MjRzs1iBGrWhvOZq+h9YwmMRdULsPwA18h8f4d5l75QkxOZRYyihnN8Dlbny9oq
 lppF78b+HZbc0xSDSU0yHX4yyqL7kURJrOUDJrlVIZi2GONLlWg+ZAYX4cGy2++i18CQmxjRuI0
 bPwsq+Ou+WNm7IhVZxWwPeMl4vreTn4Xp3M465IqabQkFBA56XkQ6XYbck9gnUyGzGrrcR6Hqpf
 3sLn8EyqyWe0FDA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: rJYtzkUYAdzTwL9T8i_qF7x4wGUBj22L
X-Authority-Analysis: v=2.4 cv=CqCPtH4D c=1 sm=1 tr=0 ts=6a424282 cx=c_pps
 a=R6oCqFB+Yf/t2GF8e0/dFg==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=c92rfblmAAAA:8
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=n8zAjjMAgf0wD31B80cA:9 a=QEXdDO2ut3YA:10
 a=TD8TdBvy0hsOASGTdmB-:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA4MCBTYWx0ZWRfXwQSOj1zRjvws
 0o0qDsVHmMd1fEiV5SihTlvijCKgESU88RY//0b+2IxlZEHQXZ4IqxYFpj3q9VWVxBNVsuTWOoq
 Z/hPTfJv9tLQjgALpcrEgF0Ub5z/ops=
X-Proofpoint-ORIG-GUID: rJYtzkUYAdzTwL9T8i_qF7x4wGUBj22L
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA4MCBTYWx0ZWRfX0/6JlbtjbukM
 krn+GCr0LX3QuzFOYNrkl8Hpa0yoSHKm5+ZAAdxeeutcMrCjwr75MmNgm7u1wC5WNZteAf9TVMm
 fCCnb62gVxnPNxilQPTXsnRi0FW54gC8LI0MrL8mUraRLPZR2e9Xb7kbLjbjpB6QSF/4bqCvXFI
 fjFGFQgC6ns/a1WiIx77uzdyNsjjOV/RnHO/NM5B594tgQpcUY7/jkAKdu32Ob2UwnQ7Ww93+9g
 ar4Es1Xj3rereFPK/kIJTcCw5bMI3V6VxDmxeJ8YYNRv0xnFLELoPjX8QB5amexWQKWB+SY6bU7
 iaaL8WxgQe7zQfSt9oFEMGWRw963XJDxt+2kaLQyI1pBIVBIMGCoQ9VBUgljwOGgw7LxzCMOnfU
 tbhFBcy5xs9qdelv6uuAYuPCFgyb7dj/KnXYSHFO5Qs9RL441A0MXqOuHz2eHmyYpjshuUTiUU3
 KlocM1G/I2B+t8VaSbg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606290080

The BAM interrupt is requested with a devres helper and so on error it's
freed after probe() returns. We disable the clock before freeing or
masking it so it may still fire and we may end up reading BAM registers
with clock disabled.

Stop using devres for interrupts as we free it in remove() manually
anyway. Add an appropriate label and free the interrupt before disabling
the clock in error path and in remove().

Fixes: e7c0fe2a5c84 ("dmaengine: add Qualcomm BAM dma driver")
Closes: https://sashiko.dev/#/patchset/20260427-qcom-qce-cmd-descr-v16-0-945fd1cafbbc%40oss.qualcomm.com?part=2
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/dma/qcom/bam_dma.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 1bb26af0405f3a16f97e0d4b86c945c252d97f57..fc155e0d1870cbb7e099a2c4280f9f8fbdf6cf15 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -1332,8 +1332,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	for (i = 0; i < bdev->num_channels; i++)
 		bam_channel_init(bdev, &bdev->channels[i], i);
 
-	ret = devm_request_irq(bdev->dev, bdev->irq, bam_dma_irq,
-			IRQF_TRIGGER_HIGH, "bam_dma", bdev);
+	ret = request_irq(bdev->irq, bam_dma_irq, IRQF_TRIGGER_HIGH, "bam_dma", bdev);
 	if (ret)
 		goto err_bam_channel_exit;
 
@@ -1366,7 +1365,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	ret = dma_async_device_register(&bdev->common);
 	if (ret) {
 		dev_err(bdev->dev, "failed to register dma async device\n");
-		goto err_bam_channel_exit;
+		goto err_free_irq;
 	}
 
 	ret = of_dma_controller_register(pdev->dev.of_node, bam_dma_xlate,
@@ -1385,6 +1384,8 @@ static int bam_dma_probe(struct platform_device *pdev)
 
 err_unregister_dma:
 	dma_async_device_unregister(&bdev->common);
+err_free_irq:
+	free_irq(bdev->irq, bdev);
 err_bam_channel_exit:
 	for (i = 0; i < bdev->num_channels; i++)
 		tasklet_kill(&bdev->channels[i].vc.task);
@@ -1401,6 +1402,8 @@ static void bam_dma_remove(struct platform_device *pdev)
 	struct bam_device *bdev = platform_get_drvdata(pdev);
 	u32 i;
 
+	free_irq(bdev->irq, bdev);
+
 	pm_runtime_force_suspend(&pdev->dev);
 
 	of_dma_controller_free(pdev->dev.of_node);
@@ -1409,8 +1412,6 @@ static void bam_dma_remove(struct platform_device *pdev)
 	/* mask all interrupts for this execution environment */
 	writel_relaxed(0, bam_addr(bdev, 0,  BAM_IRQ_SRCS_MSK_EE));
 
-	devm_free_irq(bdev->dev, bdev->irq, bdev);
-
 	for (i = 0; i < bdev->num_channels; i++) {
 		bam_dma_terminate_all(&bdev->channels[i].vc.chan);
 		tasklet_kill(&bdev->channels[i].vc.task);

-- 
2.47.3

