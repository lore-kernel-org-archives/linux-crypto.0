Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACE73FE37A
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782727305; cv=none; b=qRO3F3WLXEWH9mviqypQB7Fk4QFjbhj/qBHehv8JhhbyEPebK/79ePq8ks+HZT/siPp8eGtlsknJLEGN0S5OEmpVZ8AqcDuJYhZ0axPpXgrVBp5bx8DDa2QrE2wqtbV4pd30h5qQSgFwvT82k8H9oYKu+e2duwZLzHan7/4AYDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782727305; c=relaxed/simple;
	bh=k97Y8ImiDOSEM/i3DdCydkceZy4j+DJOA/cqgxZHohk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dTWpbq+HxEG2nS2ebG8Z3zzYCiuM3mNFf2CV8ngFtmLmGwplbGnQoNU5n79aFV9T0gRJWnb99/5Q9qxFUbwsAQlkx0EeKSGRU0/yzF8QpAgKfV6tN1ku1bqlUUnRe7YbbV1LjzV70QW6XugoQxZ9QWlE4nv6ZZS+ZX4y8nWJAZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FpkTkdW9; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iceY07Cl; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FpkTkdW9";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iceY07Cl"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65T72aYH2163920
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	dak13vsaTB1dmsrIHeCt+zMpkHOZXt2RO0KMkS+FxIk=; b=FpkTkdW94q5lBN3g
	dkdN4jE77PcLbI4Qf53nV3+FAUoXtJE6R79k1lnsg0zWmc5sHC6uDAwk4ykMGyax
	pmCEmOKnHieLa+kvngcD9R2fRnAVSel6Q0y8bX/f1WsrWIgulXVJy6n0BSaNkD3/
	xPkFfwoj20VBVPdzgc6lSivn828PnQ73hvMncO6qjVO3gK+yhvaJcxfBDFAL2P5P
	vUCXPP+Txt2gzygMvb2UOw6pQL/jhC5RwJrZYqokcEKhvoAf4/o3WsU3qA3oDC7c
	9rQj1jMs1tfrgrJaLGqdKM9yokDBN5SU9oh/vpXOJUI50MovpOxOOq2rxJw/Zv7/
	qSWApw==
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f3kyjgqxm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:42 +0000 (GMT)
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-48f5afc9692so4665043b6e.3
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 03:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782727302; x=1783332102; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dak13vsaTB1dmsrIHeCt+zMpkHOZXt2RO0KMkS+FxIk=;
        b=iceY07Cl7PrmGCI4bTmtK+RABzn4ECtETn1XaRUgjt1S2JgRVJBRyD823i2s35SRDk
         7c9W8yvUMRzN2Tpdd3PP/WLpKVIFg6vVN41zXteDMsqFxECCLSgO1K/cO9b9kKkYpuY+
         oS30zz3ZCpaCmPpFGWvbSPkJdwIdflBWfPqrSHLAbg30B8CfJRtrfJfeiC4Lf1SHpl0g
         jQabH87oJMfaT74PxULuvvHEU+3pk2KkVRkti3oeKDQqbdcJxdutfaQ0s/bECusuaNNG
         VkuepICRgVYZEHk1K52hjKftCrhUhNG42iRBzthsVtOdHZQW2n9XpQmeniwPdts4ONm4
         DvnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782727302; x=1783332102;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dak13vsaTB1dmsrIHeCt+zMpkHOZXt2RO0KMkS+FxIk=;
        b=bpYyH4Zd6BITSBoE2SKqpNCGp2vvZQhqfDihZu+/iuVPlCMD2tGjCKjbPtevsGO7ma
         3BPaYvngadKznROmTXAltIuO7AQQgZNqiFLMwY3DL1yG8Mv/QG3toy2h2Supd/G6g8RN
         n1sOFXY6Dcc1lkh3SzWMtZLfI89uW8kEdW6hJlem+xo3SmO9ISiojBWBkODUeXPa9Oik
         4v8A5lzURV68Fyv4Q6Ez0KQ4lp90ln1jaa7tdt/LMFghXL7JZnhdfsnNPltI0WjQCeK/
         180JCA3yJNEOy1f4zYT6O0zdjVWk6Y6IJ+vaanYpXiwJE/ZcGDXNEDcts9Inap9p+umf
         yEdQ==
X-Forwarded-Encrypted: i=1; AFNElJ/Ev+49rZQELyl+19QWtwe8KL83tY5GZ4Lt0Yx1pjlHv7YD91YEJTGQq525zCkt+a2mAudRT3C+4P+qF6o=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywm5Jwqz4VnssblSdf6CUCFaztvFOGhC1YRtHn+Rdmu4Yo02zjQ
	00KNVhhbMaKtwLX4TieC5OD4x6eujp3BtZYrliU39l29Xy5Oi4cG1VgH0nP/AgxY9w7me1AogoN
	vg7PQX4Tt3FbBXMfVLLRGQPGp7xeZAzVoguLkfwW1EmrrL4dOXox9qdRX1XHlM16FNpM=
X-Gm-Gg: AfdE7cmK4hLMkT63Hfeo1/tAoHf6muraghSXUeCAu7tKnHZLeT2tsCISvFPgv9MQU0C
	3+tckcIFTbpql7fBQ6eRJ1SD64yVIcQSbJVDlVNwAsd/+qc+1z2/3egRwGw/y4iAfx+5T0uNePh
	ivbit7quQAuXygFjWjxQDxQkCJvWEwdqfE10Rr0qIxI6BviuHpzNYYh8H4DB+dxYuXPAwpx6sIm
	XSQSpn3IBUa4cjblJZyllA/cDQeARQpYxuu8ir/QeusikSg/1cItav30NAo/5I+/N9k9UAGxgUc
	Ip4wQhp1QU5J2agXYCLn+jJwKtCR/z95An7Sx4T0a3SNokrFzlA7OXBrC+lyCuCLTaDmXbwwZlU
	WaCoz8qfqK+aDupozlp0psKWaIm08Jg+oWBUGS8ca
X-Received: by 2002:a05:6808:c2a8:b0:486:560d:aa8b with SMTP id 5614622812f47-49217721151mr14163624b6e.26.1782727302116;
        Mon, 29 Jun 2026 03:01:42 -0700 (PDT)
X-Received: by 2002:a05:6808:c2a8:b0:486:560d:aa8b with SMTP id 5614622812f47-49217721151mr14163591b6e.26.1782727301644;
        Mon, 29 Jun 2026 03:01:41 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:4640:d76a:6126:9b65])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4705f8ea729sm24729405f8f.0.2026.06.29.03.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 03:01:40 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 29 Jun 2026 12:01:09 +0200
Subject: [PATCH v20 07/14] crypto: qce - Cancel work on device detach
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260629-qcom-qce-cmd-descr-v20-7-56f67da84c05@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2473;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=k97Y8ImiDOSEM/i3DdCydkceZy4j+DJOA/cqgxZHohk=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqQkJu2j4B5iGt3lgZNmZCIOqxBYKHlpUlmdmNK
 obLr78GakmJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCakJCbgAKCRAFnS7L/zaE
 w879D/wIIjeWzgU6Mgj8NFmmou09FD8ZwLrlnpBMuNQ6T93B9MmEWJzLggmXvFhz0tK79qStVi7
 RlFA1/40f9ZOVCiE4h5hJTh/8nVw5M1LhbO/ExjeCCtYg1IMpaVWawKSCQX+SuL5b8bqn2A7ZOL
 /fADVqxxeaHHQMnfAE2QYylq7jrwZqoeKnnIEsjJrbn3mvSj7vZrYKX1qLySAQSSvBgycHbVyVC
 jiLWDuToa6BMjh1zxM7/JKiEL+1pWA/EPLbPeiTtQGv6dHAEjov+aZFsldpbMyhM+c4HAZi8yeg
 yebcr1xdDCo2ybpZHTCm30+H2vRIgxJ3lp2/wXk0JCBBel++LtHIJnIZwPqCGa65BCAQC97SvOy
 txKcOpBdCc42/+MaF6qKbiTHoThSsNRRePD91nWsukHoi+NknUEbCJIW5Xmsnyd4otJwucURvW1
 umW9ZwlW6fm1cmhOiqXOeqZ005MhbIlulCbWFYW+dO8m8Fk6KroqlsrNm60g3CfOxNkcJqdCCpN
 P9AIBooZmPNVl8+D3tJLbkKQyxQI8zlwmP1g8sO89KmtQ1j8NPJ9fflrN6ZEeNQYvg6iSK3XD7V
 ldjRIfvRjQrMootA/aeUjlzwf2unZp7y4cLvtO4rQ8M6x8f8JQFfk+Zh6XZ2ayoxqePAMWGWGBJ
 l8GySfJl5GhypWQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: t19V9F_90PvvElb3rMGu_iO65P8CSsQp
X-Proofpoint-ORIG-GUID: t19V9F_90PvvElb3rMGu_iO65P8CSsQp
X-Authority-Analysis: v=2.4 cv=Ftk1OWrq c=1 sm=1 tr=0 ts=6a424286 cx=c_pps
 a=yymyAM/LQ7lj/HqAiIiKTw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=c92rfblmAAAA:8
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=SDQHpg0AWQOuS8LWovAA:9
 a=0bXxn9q0MV6snEgNplNhOjQmxlI=:19 a=QEXdDO2ut3YA:10 a=efpaJB4zofY2dbm2aIRb:22
 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA4MCBTYWx0ZWRfXwazu/FRPV2E6
 +JjLw547JVRkh+osGAoRaoVE57lkOeABCdAsX8OSKi9yZ+AOYF2mTv+Gt+V2j8qSPqrrHAW+gWv
 8XicyBD1biu22mbQ8eqkawcpwtLVZ8Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA4MCBTYWx0ZWRfX8fmxldCSSKeM
 VyrAxgRBwhqGF75RQrW2yGwMVDa03IvTu8liHFj0OdRG8fd7mZdudqudtmC/M7jDevWVcLA/FNI
 VhT7XauD9q5AXByzzhMUck14EPIN0OHjpiLFH0WSCosm5cXCx19jEQgHloHB7ACXpGxern9geid
 nVRdkiw1fngcEoqWePZRG+kXy+6/UV4KTKD3EjkreTloJ8C6nrvVdZuFFFJhTcYtAv1KvYFZkEy
 Q7rfpO5YHQ4AUXmXxr9QqakpKBiWMo5Dn/13V88r8bJgw2R3BYXJxhNzQ93/fwmwwUuWCR+w78G
 aVEoy9G7pYMzus1H6By47EiAlm52/qgiZS1XHCZNeaGAeBYx6IFX6cxRFJOyfzpHzbvqqpgrxE2
 P++BAribyYedzUZdWiniqFx9XOWaHk3L4ZsdTHDloZo0gINCakajJYMDfsYQu82gD4MAOZGZgCf
 fVsUPUWFiZjnIt7bUEw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606290080

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
index b966f3365b7de8d2a8f6707397a34aa4facdc4ac..f671946cf7351cd5f0c319909bafd87e3af701c7 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -186,6 +186,13 @@ static int qce_check_version(struct qce_device *qce)
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
@@ -227,6 +234,11 @@ static int qce_crypto_probe(struct platform_device *pdev)
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
@@ -239,7 +251,6 @@ static int qce_crypto_probe(struct platform_device *pdev)
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

