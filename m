Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D223E6391
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784277438; cv=none; b=oNy58Hv81mSBEXKAMNlVbF7RUPp1730Ug2voZv4I0A8pbF8ANiJWI+Ar8aZa7WlpT+Zy2T1LOt5wonVDj7P1Jid5QT9RlfBhaDiZqVtksuZ9UFgiauzki2VuvD7MIO/x/ZEtqG8l1vkQ0G1AwNSc6v6j3LUzE8txjB1Pf1T/PGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784277438; c=relaxed/simple;
	bh=/3Q5BLE2qswUURgRMp8Md6+CmS+GMHS0PuiKEz36BBw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Wl1pJrlgBPyJqNqZgr/9flXi6qqUlDrD2y3yca5dHZq87REfdVUloNacTRbOepdtHVmXaH1lKUfXlDtirx/qY3RGv0PZs3kqH10zT0IPHb1RqHioKY1CqJuzoW/xljj+GiKpojI5wpTPqqWgoeI4jFZrGf9Z2t8XQM7dwGmcFds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bs7wpj9C; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=C/WCStKE; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bs7wpj9C";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="C/WCStKE"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66H6cEjl1065304
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:37:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	I65WEZ9oqgYF8KlnrmzqEJMBV2oN2r3NUJBwbhZLtgQ=; b=bs7wpj9CHNuDZvIL
	oZOU59Jv1celGbiupsgYmI2bQaPMMTbiFd1NGISpe6dNhPfQ64cV9NOwE4em+2nG
	HK7zqeTvwTTzXFjoWSnpHmrv9zR8cEWe958318skR5t5in9Crpz29H2LpHiurno2
	z8UIePR6RTcD/n0Z6K8d9cbXqZjAEUdcAStjGXVC4IkfVySVX02d7F4yCLQhod9b
	Rml7atZzQwOCPH5nWWyoawoxzp+bzDWyFmi18P9gQTdzchF5ffama7955ZL6AUIo
	pvhZ1JLTgLltp5Ia6JQ0EMv0kn+TVQOYVl/nsIUunn7TsTHnNQXX2207qf1ygKkI
	SjeOfw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ffbquh7am-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:37:14 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51ebdfceddcso55475221cf.3
        for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 01:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784277434; x=1784882234; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I65WEZ9oqgYF8KlnrmzqEJMBV2oN2r3NUJBwbhZLtgQ=;
        b=C/WCStKE2LOWjPHfdwdQOvX1JF9sSn4hMQyykJZXGIir9CNISKcshnONzJywWHYE6v
         yxO4YgZ4oyEZos0XvaqvuCR8kD9K4jGNEhgHn7x7Mv/b5vAN22N8tQbwHULGklYMMXtL
         3rSm99mqOYQLMCtVoEFyym0lF0WoYAurq3TjAOpZzckOmrB+HKyvN1IyClJxFMfKNy5s
         +2R2tE56W0v+hUHcsscxeZ0KX4VtnUyETibKAdg7F65hTZ9Nqdvnf3WUVEDyF/n1YaeV
         uiVJJuHbWvKHMRJiX0XgvypF9H0EEzGe/XKNJQ7Lx1Bpeo821GTbxSg+rbmKDZA7cCwG
         4lQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784277434; x=1784882234;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I65WEZ9oqgYF8KlnrmzqEJMBV2oN2r3NUJBwbhZLtgQ=;
        b=LGoNRFwIra2R7hGz+yvliyy9j4olZtYIb46MEeozg019iDm/4qXkEMKfZLlgxsBSPw
         sPqc+7/861hBq0/E68qxFoMi+cEStqR+CwthbdPrWyCEZLNDD4m007g+5lgIKxONR7DL
         nQG9gshq35dgiXDsUUdQTzb1FhZf9a7VnKlEfl1kgdzUrV5D/sPSiYlg/ChRu7yQTinp
         /bfdhMorTkaoOTex/pNvjcDwOCT9T4VDTeVW/pU/WfkFvx/qTlNSdmV4RIabr2ssB+ud
         uChCjB9Pbu80aS9XsB2Sk3mhNmkG7i+SAUftFU2Vg5mANOdbUNVIJimr6ahmDPj+QpJB
         cmSA==
X-Forwarded-Encrypted: i=1; AHgh+RoQYfUMA9ABAuPtERaDpDd/8EzKRkt739VsKipuPIvJYdhKAnwJP5glAoW2PJvLeFaeYusNHLP8M/EU/uQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyV5H0x7zgif6wFpI+lBlmJSmy3c+i9mRW/z5EeCcwjoKn8qFxg
	JH7qjS2IcRMBGaM6PUoNWrKlfrosCMAfNkzFcpF5h5Mc9atTXxSAM5am2D09Co5WQCmDSGkeBzt
	yG3qOiryIRz3Hq8aHueuUfAO3iDcWiTNnwSjtjKcafgUNrgWQPuMMwQL2kYcfeRsC0ZI=
X-Gm-Gg: AfdE7ck5Giot9vK84UTZ+joL7ab+shJPSc96EMG30dE3NAmfA5ga0dDd1MXKoswaqb3
	u3uFa1snKHRLwpAnAccbYO9N+lgrqjWwGwPHS5C8JKx4ttiJnatySPP1hLxsaMeKPS9BFXh10mn
	YZ5KaA96InW+QAkPWBlVNMitY75BylWDLWNPXMxnL5MXdEuGXUwqjjGK/1/UYr/D3MQL2RItc+e
	PnCzdu4wcQxlnbJGE4jqzGVgOgfBhstpeWaPjkQj7PR8S3O3/xxRJEmOdZREMadY2F13duxYbvX
	0CE3a2NdjKjmsN7Y+eqX8RbLQxtaZxRMXIRUHM2P3QIPZbBaMrGAYHcU0K/gmLrXpKyeC7A+sfP
	pNqshqC1/k+IXWo7avrOFSBG6vQqNJw==
X-Received: by 2002:a05:622a:48a:b0:519:efea:cf41 with SMTP id d75a77b69052e-5213c20521cmr12203411cf.28.1784277433854;
        Fri, 17 Jul 2026 01:37:13 -0700 (PDT)
X-Received: by 2002:a05:622a:48a:b0:519:efea:cf41 with SMTP id d75a77b69052e-5213c20521cmr12203241cf.28.1784277433452;
        Fri, 17 Jul 2026 01:37:13 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:dc44:5b1b:5396:79d6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2b893dsm31268205e9.8.2026.07.17.01.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 01:37:12 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 10:36:36 +0200
Subject: [PATCH v22 10/14] crypto: qce - Simplify arguments of
 devm_qce_dma_request()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-qcom-qce-cmd-descr-v22-10-ff0d18b27246@oss.qualcomm.com>
References: <20260717-qcom-qce-cmd-descr-v22-0-ff0d18b27246@oss.qualcomm.com>
In-Reply-To: <20260717-qcom-qce-cmd-descr-v22-0-ff0d18b27246@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2674;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=34ButmP/zHfg7ujor83QeeFN6rzFB4sOTC9ae7ymGro=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqWemexsKpDxnXhuP3uo8FwjW3Jtxly/cipfPEm
 cL/C3GK1A6JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalnpngAKCRAFnS7L/zaE
 w9Z5EACDsrPJ7iONMQcF9YFCQHndu2Fo/+RMLLUe2xEQWQgPPiqXpbs0KQjzclUC4onevUP9rGc
 ncO3rZfyyFHN6W7JTgKevAh2yjNFLq0xussp1HnNSwGPdmoQfIzQuf6CKEYA9lWDEN3/Sgwdxry
 /kQAwzsMcRP0A4qoDh6CBZQ/AIKhDRoWhXOw2cKOxHCAsqXtPidsQiJEru3KcPFvydWjdgwWqy0
 XVJrtS0jKVQd5anSTQqBYvk8EfpWRLzYRpypEVAzaS2+Low5JNrx3e2K8uTyHW4JaWoLl+wDTz8
 WjlmEcGllpdUQ4KtdCgAa1nXBpmah0pYANeseWgvvisrUD3Jh67d0II1DWJxXT6lA+7i6uaW965
 WJdhQ0c88oFLMajjzx75DYRfh+O02euKGO8ugDg2j056jyP68qsQtPv3i1vky3GPJTdAbBSxkAX
 6l5q622foN9JmIqxMfw/nlkqcub2UKimFhI1fIANCJlJZRDYjEnq4/gic4RKfUluvIX3e7EAOh3
 irVFORAc7CC3dMMhKdYNfNa+hVH9WhlVcvuaioMVT0GiAt6fEbRUQFh+1K8mM06Dqy0OcbZ0u8W
 UuBixplowmU7SV33LxATZTKWe3tgw0d2PpFTxKubNecS5YajJ9+dYovJMMG65t4Tv4YyUxk6wfz
 YHm5QXPV7DdQStg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: v-Dm3MvHr1JnFQ9C42DP9scyNaXw-oEV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDA4NCBTYWx0ZWRfX05G40xFd6tkh
 e7xucQi4MQIjYZaBIxYYeCclHrY8UgZ5kfLzC5O+pEvenS56XYkGW6QiKg7UtxltlwihsJGojuW
 O5kyC8aq0Tc3FU2WzOLCJrVCH7e+vNNK6HROeWyC2IS+QJAK//2C9thSh6akqptoHhwSbPgyv0B
 oWw5ZhoZspMqTU+oUPp035E3g3F13++RNrpPBU7rXN7G6AiVPeEuwfM9QFBjGCmuKZ6jZDqW9K9
 8cPLuwwYbTs3FWJXCFxPSEWuX1F11XRx+ir0UdCYc3nQihqPDNRAWIJWuBMjFOxgDmAC4R/xz7j
 nl+XT5H7/pKoxR0VIzeKTueQUo/rhc24r5Blt/ar6MgWO0PVU5PUHFPc34Oc7DEE24O+Xf4CilY
 GX1k0Dcseut0u5Oqc3BxGRsxxPKxdOonag5weBY5MT1PTy8hpAnKGM6XBKbgsUdcNH22nwqPd6z
 FqpdUOwozzfZKms5gng==
X-Authority-Analysis: v=2.4 cv=NZ3WEWD4 c=1 sm=1 tr=0 ts=6a59e9ba cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=lH6k5GM5CfRwGFUYfCYA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: v-Dm3MvHr1JnFQ9C42DP9scyNaXw-oEV
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDA4NCBTYWx0ZWRfX2L7tnOhoIN5o
 fcsgKa0/MVpsmnY94/p884RaXoti98sLmG7ADZEIyUeonU80Fc9G9ve8dIMWn7SkFjQLPni2PXP
 YJDTb1/xEc1xk8gaFg7S5QLmGKHQmzQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_02,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170084

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

This function can extract all the information it needs from struct
qce_device alone so simplify its arguments. This is done in preparation
for adding support for register I/O over DMA which will require
accessing even more fields from struct qce_device.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/core.c | 2 +-
 drivers/crypto/qce/dma.c  | 5 ++++-
 drivers/crypto/qce/dma.h  | 4 +++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index dd860435d2c47a608c82cc2686583a44ff96c889..aa4a0b17749081f1ad653424bc265ee81e348e15 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -237,7 +237,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = devm_qce_dma_request(qce->dev, &qce->dma);
+	ret = devm_qce_dma_request(qce);
 	if (ret)
 		return ret;
 
diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index d1daa229361aa74da5d3d7bfe1bc8ab189761e38..d60efb5c26d88f8b0259b1dccc8724d0f75571c6 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -7,6 +7,7 @@
 #include <linux/dmaengine.h>
 #include <crypto/scatterwalk.h>
 
+#include "core.h"
 #include "dma.h"
 
 #define QCE_IGNORE_BUF_SZ		(2 * QCE_BAM_BURST_SIZE)
@@ -22,8 +23,10 @@ static void qce_dma_release(void *data)
 	kfree(dma->result_buf);
 }
 
-int devm_qce_dma_request(struct device *dev, struct qce_dma_data *dma)
+int devm_qce_dma_request(struct qce_device *qce)
 {
+	struct qce_dma_data *dma = &qce->dma;
+	struct device *dev = qce->dev;
 	int ret;
 
 	dma->txchan = dma_request_chan(dev, "tx");
diff --git a/drivers/crypto/qce/dma.h b/drivers/crypto/qce/dma.h
index fc337c435cd14917bdfb99febcf9119275afdeba..483789d9fa98e79d1283de8297bf2fc2a773f3a7 100644
--- a/drivers/crypto/qce/dma.h
+++ b/drivers/crypto/qce/dma.h
@@ -8,6 +8,8 @@
 
 #include <linux/dmaengine.h>
 
+struct qce_device;
+
 /* maximum data transfer block size between BAM and CE */
 #define QCE_BAM_BURST_SIZE		64
 
@@ -32,7 +34,7 @@ struct qce_dma_data {
 	struct qce_result_dump *result_buf;
 };
 
-int devm_qce_dma_request(struct device *dev, struct qce_dma_data *dma);
+int devm_qce_dma_request(struct qce_device *qce);
 int qce_dma_prep_sgs(struct qce_dma_data *dma, struct scatterlist *sg_in,
 		     int in_ents, struct scatterlist *sg_out, int out_ents,
 		     dma_async_tx_callback cb, void *cb_param);

-- 
2.47.3

