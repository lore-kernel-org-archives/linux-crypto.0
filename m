Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B511A348C76
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779196706; cv=none; b=tjdQOEVwDUV+81SWchAagvgvswKGOa+WmsgQN6fpxATrbsbs5w5YCrSioaBJLXMINM8hRwDms0soDOmLMD7SdNTSU3Wfymb74SChZnwg8xmTN+xhL/FecNT8VHSpbcRf4q53DlLRX2qWdIqDtu9a1J6GEw+8Zm7d4bElX8P4lWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779196706; c=relaxed/simple;
	bh=5ItlPbuBhP65nUTpXCo9dRl8GJjRN3Zgl/exx3Ev5Lc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KsyIObeyNixAnrgPx1vfWWexbZ2VdsOW0QCOIvdcNGGUYXfzebZ7ny/ceCk8UjvoOuW4tejTjKaXpz32L5WKXGYeVoFGWVhb/WPI3qkpLpFl73PGioDa0OgCc+PYxaZXm0Cd2LGQRRiXalT2loJ/Bgby0hslYVr4WKC+c6sJH6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nUnR4W0z; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HhXk+8F2; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nUnR4W0z";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HhXk+8F2"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64J9v5EC1054781
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:18:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	25Y3YTCZIMOzZ+yX4mVdRMjdJrxXuFwJ3ZTHD7azqTY=; b=nUnR4W0zT4THAyDA
	BO5PEYk5i36DYPXVfbCQORPC2a1zrZ98GupBpJZPlAuucFGO1xwgnYBoENeGd23Z
	bJiXwvReW7Ka2T/bIJ3ci8V2vsf3a8Razr/6jV6H03Eupsz8ajwdjnIc6w3aW94E
	QEKoIyIoiTB+f20kRkx3cllmfRmPszNX0fuXnc5jKrts2VdJwHBn1RukFUZx2/h7
	lkmrnHKRSuUNvUTyCsFRJCu+8sjYBYr2jGXH0b1W4DqPPEvfWd/iMi9me9gOjy1j
	DRyX3uX99ztgFvqFhbnkjoYLE2T1DVZ0y+Kf1xicV9VtiRXTZsuOmfo+WsSfc2Uk
	KGeZng==
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com [209.85.221.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e8nparrk1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:18:23 +0000 (GMT)
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-57563cc7576so2687033e0c.3
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 06:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779196703; x=1779801503; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=25Y3YTCZIMOzZ+yX4mVdRMjdJrxXuFwJ3ZTHD7azqTY=;
        b=HhXk+8F2xI+OmpXuHWtB5Sp5e3gV7xjsbWL1sqodI5G2up5QPaQQ8uwUotw/vH35R+
         IDq9lqIs9eSCpQhMdyWWCN6qgr5cuX/g8p10MeBERDe6Kgt11q/WqQa5IRqTLRK/d/Ta
         yiTmuLa6nf17vKNZWGseI51JrYiPn7T4j2XMDVDc5IVrJy2QqvSwd+ppOY3Gnd8/k+Q/
         6dX4DGT6P3MAS0PQO7LnkUy9SKfrLbmObNDvO2EwCk2lIRlZM+G/mTYVqYfq/nmVz5qQ
         mqP5QfE76HLuEf0EykYmV3gin/160YDkdxLt2PskxxN89TKTxtz+bqoQKqE5bGpx2LsS
         E8VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779196703; x=1779801503;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=25Y3YTCZIMOzZ+yX4mVdRMjdJrxXuFwJ3ZTHD7azqTY=;
        b=GRpaBzEp+zW4on1iO3XVP8PHijcoD6syRlWP5YJhyIFIoKQRvE9hzvvKHsXN7nl5o6
         NFHoeTpYMcor2cbvHJrgY1uGgyPgEEmL0xVj3sTAfNGOZhEFPTVp17MxpsytzFhYrgbB
         NZWrtyY740HCu8mDedGeNgsu4qoGQavZSo1ptSWvzCDt2APS7KSrHFbB4PnvZ7V521db
         qJst8LYi6C1iBqSDe7N+1dbwzcQJLwWNWxptbBauna39LvlwXFNVsTW3Ht53BbG1FIvI
         Q9emKQjY1Yidj5v/GKtgHe0lxw4YDNDiYmkhf7wwHLQcX74p97a5PjnNSalX1laA+/MN
         pBSw==
X-Forwarded-Encrypted: i=1; AFNElJ8Y4liTb61kDuTWXF//YnjX8wLSsjHc217AV+5NfPZdNAK9NyC6da4LFIBbvpXkZl/CoVVuFzioDBJhxR0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1p2xm355NtLiTP1Z0rXmtO2rzpUwO2ii2knPktr43fAOVOIpm
	Ynxk5XE/dlcw26SMDVLIscGHiIvUY+kvvi8gRu4myYERZPpIIq4saS1nTtTxg35fq71jp/4DVPh
	xtvPosBAggviwGtVaB935c4uptJAJkyEivgz12qaJA29z3qy3ZG0u0+dSNGvm5IYHEGo=
X-Gm-Gg: Acq92OG+falsIn1RfVYXeK2RCkZY9Nx/C3iRzpccMCqAqPj/h6jyuhWMWB7WLSK0uBI
	2JQqWZuWuJ2AqcpcBjThsu9KS2rErtdxBy1ujtd0K9Lfj0wQjaMFdtQSCUG5iUgMEbUi60xiq9C
	jLmFtYYXSpag+nu66JzGoOaJ+R2yCZz0dohdaK6BsGme65D2DFGSNC4wg0CTCpFyaMX+cMqZiKa
	kaFDOGUhOV7gfFYQEGgi93TiJCmocAzxcAZOdMz0sw1Tpern9fMKbbtPt/hvPP9se7BQWDRDEOx
	DQcKI2pxDG7ZXmSz4R42+RhHWxoNnmSL5WmsgDaf3hze4gyQdEjrPCg/JrzaLmlYY0gGMg4qk0V
	088DDNCE8eTEnvt3GLWxmtVqzXIb66OQp4Jv+/RCPrXqGAs3BfEk=
X-Received: by 2002:a05:6122:e247:b0:56c:ce0b:fecd with SMTP id 71dfb90a1353d-5760c09441bmr9346593e0c.12.1779196703143;
        Tue, 19 May 2026 06:18:23 -0700 (PDT)
X-Received: by 2002:a05:6122:e247:b0:56c:ce0b:fecd with SMTP id 71dfb90a1353d-5760c09441bmr9346525e0c.12.1779196702531;
        Tue, 19 May 2026 06:18:22 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:3fb6:74e3:3c25:ba2f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febe7dd22sm143969195e9.7.2026.05.19.06.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 06:18:21 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 19 May 2026 15:17:49 +0200
Subject: [PATCH v17 07/14] crypto: qce - Cancel work on device detach
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260519-qcom-qce-cmd-descr-v17-7-53a595414b79@oss.qualcomm.com>
References: <20260519-qcom-qce-cmd-descr-v17-0-53a595414b79@oss.qualcomm.com>
In-Reply-To: <20260519-qcom-qce-cmd-descr-v17-0-53a595414b79@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1394;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=5ItlPbuBhP65nUTpXCo9dRl8GJjRN3Zgl/exx3Ev5Lc=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqDGMI2QVh4QfndgsCdNJD5n4VcvO8wt8Q5d+K/
 ZH44cIVyrCJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCagxjCAAKCRAFnS7L/zaE
 w7SCD/4naK6qeLv2LqSaYlys+AC2IFPuiySUYpicSD14elbykLxS88aNE36/HjJDfx2KdgTGz2E
 6lDBGA02ogSf8A4sS02QdH39yDnTbC2VmgGbksHM7AysDFjO+oeKyayaE5ouP6zqjLUqYgD27Py
 x+c6BVd7KOsHWvLXGFWqBw3uz76d769SzY71UOkdLG349OLlqXANFldeuBs+YHoNao8cFvu4rCM
 4QOwsctgpNtl2mBSL2dP6TQasIBVn35viGQgC1JR6GuDo6nV/1gasDUumnZT6gy/dA/vPbcTkPq
 RtltJxBhOWYX51fF5oHbJDQ1HDHGyq4eMzKbEACEPx3JvJIvo1HJ3xhfa21JFKemU0EqhKW92pX
 ao2iuSFx84uqCIHUAjYBsg++6WdkxeMmnsqL15nxvFhm/esX+gC9zo32q7MhweFuE5LkAZlSdfz
 OSw8pLIsXi4SBvnU05aOt9TogVAKm/1LO+GSH4PNvyrWNjb7jpGpslYy/Y29bK/mls72DZY1HPo
 Ct+K2s9AFrKoX4hwE+SJDRt2ypAWlx4mkEwauNq4/8I4ikevdgQSvT6vXb259DAQMSjM/GAuVI+
 R1m68oimVXXb9U9tkbJC445i/80bOCPcc69OGI/4yc6wcjQwyQYz8JP9t5cQjraEqr1lIaMiS1C
 C5UV0W5yxOvAVBg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDEzMSBTYWx0ZWRfX4XDF/jEQYGyh
 xyz0C6YdYM47irt5I1kovXZW7ifwZuWQAcZ9f0RcTFtds9BgSAu2EF+KHdPEZJ6qbdWPEEZlMu8
 k3i2aSUFdlm4P3Q5xnuLk5cXpj7j4lXL4ySOV5zDlK0l4P3UatFCztC7meWD4iy8hCUcRm1jy34
 v7KB5SMeHThOvWpLNd67XFZ4rh5X4elGlKIxFp1uzMQUamlDNagB/m/jsivgb0iSX23XWNqC2ba
 X45IqTPVyqRVhS96dv/ssO3Uh6Gnv3ZwboTgDTYeonjd1j85M9TM39vfzrAWkIY7KE39f416nyN
 HGIPdTDBviYNzn7kPmR0w/F5Yqrf6L4nvUt0UH+WK1B17eljGl20MZJbCX+G24+QqsE5necgtF4
 wKeSQn6NXvdJvy7RRRyJyQCMSulQX9Z6pd7nJjQcI0kTWkQHyh9cVIdW+e5qBJ7u0d9lqc6EVxb
 li/2pmYYGKi8nYZgE3w==
X-Authority-Analysis: v=2.4 cv=NrjhtcdJ c=1 sm=1 tr=0 ts=6a0c631f cx=c_pps
 a=JIY1xp/sjQ9K5JH4t62bdg==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=c92rfblmAAAA:8
 a=EUspDBNiAAAA:8 a=Jr3KVaxKR4ukTOMpvgYA:9 a=QEXdDO2ut3YA:10
 a=tNoRWFLymzeba-QzToBc:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-GUID: xSE4PPtOtNO9zzYyM1xRgxqSOEACnRi1
X-Proofpoint-ORIG-GUID: xSE4PPtOtNO9zzYyM1xRgxqSOEACnRi1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 phishscore=0 clxscore=1015 impostorscore=0
 adultscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190131

The workqueue is setup in probe() but never cancelled on error or in
remove(). Set up a devres action to clean it up.

Fixes: eb7986e5e14d ("crypto: qce - convert tasklet to workqueue")
Closes: https://sashiko.dev/#/patchset/20260427-qcom-qce-cmd-descr-v16-0-945fd1cafbbc%40oss.qualcomm.com?part=7
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index b966f3365b7de8d2a8f6707397a34aa4facdc4ac..e82fc862c74b20c34ea5abd6c0b98b71089a3fee 100644
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
@@ -240,6 +247,11 @@ static int qce_crypto_probe(struct platform_device *pdev)
 		return ret;
 
 	INIT_WORK(&qce->done_work, qce_req_done_work);
+
+	ret = devm_add_action_or_reset(dev, qce_cancel_work, &qce->done_work);
+	if (ret)
+		return ret;
+
 	crypto_init_queue(&qce->queue, QCE_QUEUE_LENGTH);
 
 	qce->async_req_enqueue = qce_async_request_enqueue;

-- 
2.47.3

