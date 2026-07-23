Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC834766B7
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784826610; cv=none; b=gyeGxfsJQqb1d5E4M1DbYevxN+pZvjgIM21wtGaw/ZuaoGhKwDnM1k8b+nRuJuCzTOaHUaa8ipnr7jHM/VVPZZdNGUNJtbZihBdeYik4QgyFnGBRu1Si7DvTE7QbWMaqCItXL5QJxrQDVPX9wR5FSJLFDyqj49u3zZgNKkBK7L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784826610; c=relaxed/simple;
	bh=NNnz6awfeEqmEC/yqDO0GWP7yizfp6R665Mk39/3FRo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TXEoDpbI+QWIR/1/ey57cSo5HYE/oKveYfs7AuNoq4FC89Ackzsxx9To+rOQRWUTc5Qf1cPqPcnohF05OjJtur//NLc+Irk9dEb4hWvN+9MTTvNGP61cYxQQfv6JT2H9e7hS8BMR9GmGmHx6vK+v+3wEn4ONVke1n7FJ7E6rCHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RuQZ6qnc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Mtycc4vM; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RuQZ6qnc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Mtycc4vM"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NF4c2r1324148
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:09:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	U1qOoj9SQUQgxQzB/fcCsnUQs1r8P8lLj6KzEKTr4FY=; b=RuQZ6qncLTOl9oSR
	ntR2U4RL+S8vxLh8JksY3Ebtk7fUx3Pf2qr24/BBqcSv8WFagXcE1ZaEWivY89N3
	PoisljpFl6pB7m8+WbmUWrZ/wPa3uqzPJpRyXplT57kHRk/1SULaznRQx2Q4OYwP
	Y+YrZzuk0W/J3zSmeRjIW1i6q0RQAfuCQsCfh5Ot1A4YirbVpLxrHRv6Lu7LXonl
	bY1IY2bGeQnR5YfCNLUSo5pJucJFko2Pz8LWkQJ4RN9dJNL13iD6WDZvv1fQo/1Z
	GSXzqFqqO56eD50r2J0LwKdt0TBkFQNylPUQtNdxCEaGsqgLL6lR8tlhIDdEhyxe
	8NdMIw==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkn9a0mxs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:09:55 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c1a9764f0so21202081cf.1
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 10:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784826594; x=1785431394; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U1qOoj9SQUQgxQzB/fcCsnUQs1r8P8lLj6KzEKTr4FY=;
        b=Mtycc4vMfk3eXO/wiF/whm7PResZhWNkt3vmt6gPdtrp/iDIeDGPdVhebZulJxokCg
         dYVkFkMPhBrKsT/B5g7NfY3Z5CJ83TPwSMCfVotHXrp/WTRHN3c4dUWRH6kYUInkK4cC
         58X3ZXMIuLdRErLSJ6yf8RmNclJ0oanLZXeGENlH2yOGjahKxTzq0qzy/Zrk1dyg0jlo
         beyakqzDrwetsrdt5nmv9dtLvn96aSJAdBvlNZ1kEVObuYYHqjU2X/I3hUBs/4eGNftY
         J7s7gARPDhRr6AjfR55+hVVl5pvQex9bX7dmNme/w7v3bUHbczpZ7CnemV5rOw68iVqO
         SObw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784826594; x=1785431394;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U1qOoj9SQUQgxQzB/fcCsnUQs1r8P8lLj6KzEKTr4FY=;
        b=siPKZUGme6t8YY7ADV8ZThTO1+HQu+CLDcz2V77OicngOWHRpLNiyLOUXJ9IhUqhd7
         qiYtEBfYa59q7mF5RfXpvo4RrNjyG8Jjr0uGArTUsO2ISwr35jPEDJyCqX58fixGcGRv
         rBvFicZ4wb/6ccM6WNNU+EO+xuMwW4vuZ/sFSC95FXKimRz0ReqX01a6Io/1BS9jnS4L
         Wms8yhwl/ZIsFwxtzlzXubGewz9/XhnnR0rcUNOHrtnY87f+7C4iChkVRv6v4perVBQH
         q76rDuasUQjcO55DDKjFvjq06fNzZ7F2ZottrTZoHclHnyUZA9cHTVU0GyUEIcBY5xv3
         dzxw==
X-Forwarded-Encrypted: i=1; AHgh+Rom9OULDM8++uThX7Qql7YXAuK1QjCGshjUcCDMMbfy3pO4hDKdF0OQdwOYS2EIFG808QKAhgVBCJ1D8u8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKliPZxmdISsMC+orZ82DJ/zEuUs9ZyblkqGg0c/2uSiIxM4dF
	tAVN3lgx8tTg5D7ly9ApZlrnexotR06BNEKqNT7RZ0tPGKEF2dSty69uWaT2RIj+dHxHKvOSglC
	4q5fWhvFkQCoISR5Lyhh4Jiv/KkUdqv7H+Z2aTtE176OJxZpX58vXNKGIfxOssJgJlgo=
X-Gm-Gg: AR+sD10UlWBTOUIdZGRU0gymx+4gmvLrW+XOlezkhcKq3Qj9+f8tPpXWFfH/83Ju7uX
	atrdrIXN32rdPNIU8r+pN5QrMCAXNzdKxRgTO+bq2gNkNx0Fnwf7R2088hoQoTuw/JAOcsLBWqs
	fNrWdsYaZMRYl0aENsKWzGxuyh66gKFB4hFqFKqdcfohcw0MEWMd1DTAqfa0oDBLUh2WNSAIFhj
	Kih3ovJwbXKoCzVWrOtmyqYVjxmNdr/2nFiwp3/NPtvkp095UvKpy7rbSoQ2d3Fg9SmN8CjzcZ+
	xgMzRMvsyMWPOmA/UFU6lnOn0KtK5iOqvaxO0FAYZw9JYTnCiBPVzw/T3G66tmpDoxcHf3TEq+n
	6I0roS+2aBWrgeOnB3/AzyBpDKGZv
X-Received: by 2002:ac8:7d86:0:b0:528:32b1:c202 with SMTP id d75a77b69052e-5283ddb0edemr36279061cf.7.1784826594240;
        Thu, 23 Jul 2026 10:09:54 -0700 (PDT)
X-Received: by 2002:ac8:7d86:0:b0:528:32b1:c202 with SMTP id d75a77b69052e-5283ddb0edemr36278371cf.7.1784826593725;
        Thu, 23 Jul 2026 10:09:53 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:cd9c:212:1357:7832])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a64dsm18472999f8f.1.2026.07.23.10.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 10:09:52 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 19:09:13 +0200
Subject: [PATCH v24 07/14] crypto: qce - Cancel work on device detach
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-qcom-qce-cmd-descr-v24-7-4f87bb4d9938@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2473;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=NNnz6awfeEqmEC/yqDO0GWP7yizfp6R665Mk39/3FRo=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqYkrFXChhPvWs/N/IJBpiKC8XVWqYScOKAwNPF
 CGQxQZdRKuJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCamJKxQAKCRAFnS7L/zaE
 w6/bD/9wZpY63c2tN+fULVfdgY8TdNqRNv/T77YoZLohc9Pm9Gee7Qs2XWHGQdHiPLLVSVcCd4S
 TXtc7Sk/SU3Jl0W56Ay8EHyxVzsm4DdysAyDzEWQdlNIPqbweU1jK3L4/qH9Bo2oJG2YM+F2MxH
 5+90KCuhvDIWayeBqbQ+gLo3xAmKWq9HK/SKI4P3n63gPic0zkFglQvq6YnXubK7DtCBYXuLtm0
 it4DYDg5Joi4/HnK4uS0oS5Ao9v4Ckf7JL4I91/gVCJOwIcZmX+a9fIbSlcupDIdp4SaI7oRtID
 lV1x9u1QV/ttYZ4XKByiidT5zQocLaCXIln4cRvUn/YQEWRsVDqSzQllkjR1lKvsdP3nk1PYTFZ
 Kscl+fWREhhiVaMHyKsFSgNagliWKjnTes8JIq4TJ8xm6dYtviNrtS8z0Ig884T8Vzr1xiPDh8y
 drNe0SjR5L+HsGcD6mtd0LZAk4V1BH4MT3DWZBpxWIDmS170ynnK+6k+eREnqbZmBmKfFoBJFG6
 CLyA2AN29pKQ7Ood5qRWfbTLbQa9h3J0vMFjgnllGesotD3mbkd7ujeMaMxsIyxJqKergfdDYzQ
 IEdfHMU96YjlhhzJnEBOE2c2vTzxpe2QXP5pQPPOS6FDKXjRKCvCjxOwst86MkGJVW33fRVjR+H
 lSotaLlYU+tHObA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDE2NyBTYWx0ZWRfX17L9VTqGdSgy
 Sgr/H/uwauWsYPL3frcWXnGh/gw6uUgQLC9Lr5/Lr5CINZ6UWv0mOUe8ZBz3D/aOymtvoxT92s1
 c1idi57exM27fBWVlN5UPtahFjYSLs/3UZzDOUCdEpbRm1uubqO7d29o/3HQE/ZC6f1BvU1vTFS
 vuVf5dLDpyE0SqbP2YKsINI9iDJwWTvOZh4tc5KJ/Kq7alEinIZnBzLFOgXotf7RAu5nvwZF4IY
 0WL0NA/YTtLnpTdm2HY158jSJjkRHd9zj6car7G7gFOvt6nmqGV6muE3xPZLKdteCZNi0vWpa0X
 VyPgcjsD6oJNO5gh+sC8R8kk5fAgu2KmHradDH4fP1mUq7XjlfvQL5WcYahCGE1KPdAK7rLzk+f
 yhlKnDUcOPTR0eStnP8sLFKMLer7exH3HlXijMR6O2QoiRcEMy+OlzxPfziHOfOETfB5WuevoT0
 hPnKFcUaNvvi+SAGu6Q==
X-Proofpoint-ORIG-GUID: HF_P04qOyB527BLkj3sN6nYdGvc6Xx_X
X-Proofpoint-GUID: HF_P04qOyB527BLkj3sN6nYdGvc6Xx_X
X-Authority-Analysis: v=2.4 cv=WOdPmHsR c=1 sm=1 tr=0 ts=6a624ae3 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=c92rfblmAAAA:8
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=SDQHpg0AWQOuS8LWovAA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDE2NyBTYWx0ZWRfX8sNCV7+20AFt
 9iXGqcwz3cTKDwNQgPp13fUiJscOooRQ5I4g6xyRgE/+7nxClPH2kKftY/AdkRZHXDV4oWRC28b
 b4wpPpGchm8CCZGVXLhrUQb9X1riIvE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_04,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230167

The workqueue is setup in probe() but never cancelled on error or in
remove(). Set up a devres action to clean it up. We need to move the
initialization earlier as we don't want to cancel the work before any
outstanding DMA transfer is terminated. Make sure we do terminate all
transfers in qce_dma_release() devres action.

Fixes: eb7986e5e14d ("crypto: qce - convert tasklet to workqueue")
Closes: https://sashiko.dev/#/patchset/20260427-qcom-qce-cmd-descr-v16-0-945fd1cafbbc%40oss.qualcomm.com?part=7
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/core.c | 13 ++++++++++++-
 drivers/crypto/qce/dma.c  |  2 ++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index ac74f69914d6175b39ccde43f16269570fbcf715..b52a26ffff5ee733adcf4e8cf8bef75018dfa63e 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -185,6 +185,13 @@ static int qce_check_version(struct qce_device *qce)
 	return 0;
 }
 
+static void qce_cancel_work(void *data)
+{
+	struct work_struct *work = data;
+
+	cancel_work_sync(work);
+}
+
 static int qce_crypto_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -226,6 +233,11 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	INIT_WORK(&qce->done_work, qce_req_done_work);
+	ret = devm_add_action_or_reset(dev, qce_cancel_work, &qce->done_work);
+	if (ret)
+		return ret;
+
 	ret = devm_qce_dma_request(qce->dev, &qce->dma);
 	if (ret)
 		return ret;
@@ -238,7 +250,6 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	INIT_WORK(&qce->done_work, qce_req_done_work);
 	crypto_init_queue(&qce->queue, QCE_QUEUE_LENGTH);
 
 	qce->async_req_enqueue = qce_async_request_enqueue;
diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 68cafd4741ad3d91906d39e817fc7873b028d498..7ec9d72fd690fb17e03ade7efe3cc522fb47e1ac 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -13,6 +13,8 @@ static void qce_dma_release(void *data)
 {
 	struct qce_dma_data *dma = data;
 
+	dmaengine_terminate_sync(dma->txchan);
+	dmaengine_terminate_sync(dma->rxchan);
 	dma_release_channel(dma->txchan);
 	dma_release_channel(dma->rxchan);
 	kfree(dma->result_buf);

-- 
2.47.3

