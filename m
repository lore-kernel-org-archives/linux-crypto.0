Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0577F41325B
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783947696; cv=none; b=R/e9mjViRw5O3Y58xlX/BRT3xO8ZfOFsn1cTFaO4DA6muDCJCV+82dwYQ4Xg8ywN9FZvhK8nHFbnFOKw/T+aaGicHRi/pA+acijt3gh0U3Nka+Dc5pyPzQ75GK8x4RtTuqEuzOM24ZABBDa0nQ1WeiVITa19+txtyM0yue/OHE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783947696; c=relaxed/simple;
	bh=4nbFs/xg8cCMPYrFtHWE96AOtkhXxC7yUgPXEapSLFc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nhmwaLg/wYoqHsYQgjnuUJEWpnqHCUXgEWoXKpyAZmNtDNjSiWb/NB9/wU5X1jFiGk+b+DbQWPhlzhYRbQLIaZ6/Q9cPjBo/2sFF8rpnDhmDb56L3H5SQXc4YbPV4Zaq9ufkMy9Rc37fwxBgUeIfh1/6C7vJI9koCpauXKxm2JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BPMW7qvk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JWcLO6W+; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BPMW7qvk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JWcLO6W+"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DCDux91209914
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/Vh6sT+8mC4wwsdE+AaqQfMuc9K2i5dAUjEpzQ2UVhY=; b=BPMW7qvk4rSt6hfp
	63NVF49Uug/1J+UqZRmu13NNmzyySLm+WIuCm8InPagd22orXm3WJQHbabsezl3t
	SgzsHsBJXP/0IuzYU4ChVZJVUMzZ0cDk64sZzQ26MzDO1zJ1govoSOLqDumCAVww
	qHFJ3EbQac2wbxux3joUkrpJCYNDFVP9UOUzhb4abwFOmBknvlfA3DpccDzPY7UJ
	2m6iWDMoHs6rBEXMZQuz1kfL0hIa4hNKxkCukX5Sd14MGIeI0rOgtSU+22xBvGbi
	OMMPGrWiJ+uCwVtrhMJFtMh5tq1WkgwY4jJQIYYewBeSjb6q3+x/HtPrbN7gcrwp
	KM59hQ==
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fcw4qrtbr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:32 +0000 (GMT)
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7ead3468408so2357331a34.0
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 06:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783947692; x=1784552492; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/Vh6sT+8mC4wwsdE+AaqQfMuc9K2i5dAUjEpzQ2UVhY=;
        b=JWcLO6W+5Qc6ie8sQXtgkO884bcTyYr8gZGdCpRZ0QUnPCpRgOFG6fuMAM4x+IYeMq
         CzSpE47uUEQdtdicB/AkDJ+bxDNcNmWDMGucYvMwwyvwkXpMRs0EaVt6R/0vwucQfOMT
         7ogxnnr/K27rnvsq3wRGknd5i0b6dq0AZF3CDzWXbzOou4Iavjyh0flL+jDnkOP36AA3
         zJAC8f4bkYFkUvsEBAextRE2GAxkFlYGYjW/xAkc3/qZtXN9IKO1NkpOPEnOlJpfSuTy
         OgKixHku8AukoLdAJSA3VcTI9nNYLZMwUDwObDku0rsjHY57ftkA6duJaO6Fa7HhlL5G
         ZtHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783947692; x=1784552492;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/Vh6sT+8mC4wwsdE+AaqQfMuc9K2i5dAUjEpzQ2UVhY=;
        b=dAnN8kxZZ4WYbrms0IYSOhXGzxU8Q8DYydGIYZlWSHYbdX9r9qeiym1/kbiSUf5icz
         FF9YzvJHGWmw2S74LL/ymMPDWEA+YB70eHn/T9itdmHFfgSj4x5OJCBOyuxXX7nSeDjh
         QJd8f8xa+VjKLKgsqPuT2+N7C6ApvJ1T4diFvTZrk2r0R1p4hQG56fX8NtraL1sV5ct5
         +LBR//rv3JIEU3ceXPxuznQqgeJrKdHoLmGAmY0cnv8hVNBTgjbN9UdA8syRtxXYgQy+
         8R5whnLtWyDm+/ghXXyompcfF/pgIiyhxDf6GJvS2FqaHO1mLypMwO5FA5mbWhr5t8Yp
         8cnA==
X-Forwarded-Encrypted: i=1; AFNElJ/pzduN+BVeahLeY3O5s8rM6un1osUoaQ1GWdnwzZt4fRoZB9Ek+g2+aPMrXifVcHfVv5tVbKgwzK93IBo=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywx2x5Vaexf2T9kQO+VlubRhaAtsrxCAeTZiyq7Hf3nTeLgTJp2
	yNfOPmunY95S5xDi+dKDQGBE/b721W6G7joQ6UG0SbXty9WH9qwiw6/AQknVPA6FV8cDD/rcMf2
	w8xNFKwMFkPQNoFfKN7Uc0aJvxfTkEkdJt0d3OrmcnmvOjnjICvY6/nSw0DXQuBmi5Ck=
X-Gm-Gg: AfdE7clHQJ0ueWi8Cu+5PhO010o4Wq775GE3iYuWuWxmTPn1o2nNzADHjSbkanALUOl
	pNiA0vhREogHxzSSLjmpX5Jb0GWf2PCL+KWipjUcMOvrKc17YO60YKyYgjqWuFZHO/GKFvgjS+c
	U/rhVtu7rmqOiT5JUt+ufd9VWWauqVSs3ifxqnnRToWJTgtvDaFDTnOwiU043zs+aOe1P1MBWV0
	lURar2bvzwhtMBLQNWHRJOb5RIGu7dzXJViy9oVLgAUy4368kCQnPB7xwygnKdo7ZLELFDdxekL
	e8FZbcWhKo83P1od1rjApV9Ad2Ij4dzzJkjuU41f0ZLzn3Ul5gBtDv+saTnan/M9+de5S4Hi1Sx
	NJji6RkJIEjFXEyqpIhiwJXiywzrNAtzoWHwBbM6r
X-Received: by 2002:a05:6820:709a:20b0:6a1:87cb:c34e with SMTP id 006d021491bc7-6a39a8bc0cfmr3777053eaf.72.1783947692042;
        Mon, 13 Jul 2026 06:01:32 -0700 (PDT)
X-Received: by 2002:a05:6820:709a:20b0:6a1:87cb:c34e with SMTP id 006d021491bc7-6a39a8bc0cfmr3777006eaf.72.1783947691457;
        Mon, 13 Jul 2026 06:01:31 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8881:83b8:89fa:1a2a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493f2d97527sm306129725e9.2.2026.07.13.06.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 06:01:30 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 13 Jul 2026 15:01:03 +0200
Subject: [PATCH v21 02/14] dmaengine: qcom: bam_dma: free interrupt before
 the clock in error path
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-qcom-qce-cmd-descr-v21-2-bc2583e18475@oss.qualcomm.com>
References: <20260713-qcom-qce-cmd-descr-v21-0-bc2583e18475@oss.qualcomm.com>
In-Reply-To: <20260713-qcom-qce-cmd-descr-v21-0-bc2583e18475@oss.qualcomm.com>
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
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqVOGW93v0sClC2ft1uCv5Hw3EHtNtjlSJJwq2r
 tE4EdQeEpKJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalThlgAKCRAFnS7L/zaE
 w/uzD/4w7eNiuNpdXOL3t9tZlS5LdaL8UOWb9G3C8AYDPtr+fAN90n14n2NZg3uMrzojjmDpFUt
 9Iksuw7xVCS8Q7h06Z+LOwUYoaNcF0Gc2xPMRwd195hnUU/A+s7yXeaIJBr5PUJj9SG+Tij0l0q
 4bMuNqytBjFwaz08h6FCxbDKCbL9Ff2GWef6txBaonkpWuyrvUvT3V3h9z/lk3gLr1W3KH2dT2j
 POs49V+Qbj1NxYMoJW2YDLOhagEbVsSydQW2ipiXh4EsYKumCfShgSwuZAD8YWz01K4wF4o86YB
 Sj+m4+o3hUIbfnqo9ftCfyMDopd1O6fuaTMGO3yLaxOv1SEcoQIGNBpgHsaKsaj82CESkHpYOq0
 4vzS/QnSmT/XNVCQ352PE2k5HJssuzCzUFiX21caaVJ9HegTqNjL+sO7XXyFHiHx+eyhevnboX6
 zLdH9SIZuysid7hmCa6D6JwQJfiaJgT6naeB6YZiXeiqNpnlF5YdKB08eFK4Xy4U/0FnI1GIfaU
 MTQvGK1+c4PQOI/98pLZIEKZj/V6+LWNqt4LwDjhTBeQ8HFC6p0P2RqQfqpw1MnErtYQAC3D+Zz
 TUMi/XvI79oxiLqk9uhZMCGkVrz/zuI1f/T24vQF52gXfwhD71tnxmULJ2aTCOV5TxdY2AcfMnv
 qYTuv6HHSU9AEKg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfX3axdm2sHpQyp
 w9SPJZqgEV1zRSa9B4LV1bBMbYR4MmY3ZyvqkMKySodPb25PXBF5NUbksZlPfq9JKLP7BEekhWq
 SSPFDFOeLlY+dsCsxnxeZDvpVwMg3U5l8CSb1CKgJGmUD0VtMPlw28E3e+vHEGoiFvURDF6S03m
 46OrIWm42/FmFQQTCqUJIigey2IXTiO5jxSsE7MNaD6dWRR+xju2Z8ZGMTFQf+s+CyFdDdx1i/x
 6IMMllO3VXZfsLArB4QtxX8SJg6PAmfLhbVoYEzxedwyem6ewNHniliGguLz0GSknJFtRzosxq+
 kMsdXK0ZgMvuqB6Ma5vQmHhdFlJQcqbYbh61MFqRumJBOCT/lFzit9wG+JCB1KCXn+g0HljB2SF
 7dWFHE0epnAYTsZEtsaUOtm+SLmjrA+4pL/a2WU//+rSyFYpsGaqAeniEzD2QmXuci+uARn3kMI
 Z/91w5z0/h30QxOqp0w==
X-Authority-Analysis: v=2.4 cv=HJrz0Itv c=1 sm=1 tr=0 ts=6a54e1ac cx=c_pps
 a=z9lCQkyTxNhZyzAvolXo/A==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=c92rfblmAAAA:8
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=n8zAjjMAgf0wD31B80cA:9 a=QEXdDO2ut3YA:10
 a=EyFUmsFV_t8cxB2kMr4A:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-GUID: aryVGC5o0yi5IwcGtm8emn6eCYCA31QN
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfX8MJywAAlAkOZ
 HQgCfnO5w+0tAW2+85TR1xFmbuV0ZujwxUFgZY2CDTGpYCZaSWachaCvgk9kvl/NFdh++GFXOly
 5oh2+Nuf2HvDUq+CZl5qeKL4pAuUkpI=
X-Proofpoint-ORIG-GUID: aryVGC5o0yi5IwcGtm8emn6eCYCA31QN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_03,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607130135

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

