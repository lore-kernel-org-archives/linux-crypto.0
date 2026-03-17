Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F2B3E3C44
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773756191; cv=none; b=rvuFwsqy276CDk+NsLg49qM1oUZcECBLHdDwgwfWITCJvTI41hxS1cvKzcnCIZluVTpZPLDy+IQ+siRT5s/JuOfVo9IZw7O9MrGImaQ1afwQBbZ6edfJd6v3TVsgTcjiWgDIs82fvwuXCcj0EfcvVSSgch5vIebWtc95yETG0X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773756191; c=relaxed/simple;
	bh=zaDjliGI9P8SDSmb8oK5ZUowNY4iBaNue5t3+i0OgLI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Qeiqb3RzW1mBSgNSJtuTh7vdn5s34gEugGKACULLyNLUE+KB1pLwFXkLks8228c1q2UK5ZGN9qQ61cJYp0iyOkMydEQi9bkRwYw2TlZ6azthS5jbQ1htut+TZaZOIPoDYwNIPoFClRfdzHv9cRPpRhAfvXtieK+0wrcYKA6oxmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PeSQpoHg; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jhw0lUx4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PeSQpoHg";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jhw0lUx4"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62H95dQm3102446
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:03:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nLZDYW56A6RoHAFTzDl5i+KhZW9amsZPLqs+n6djD5w=; b=PeSQpoHgCjkDtOpF
	8xeOshEXMg4ZlauTggV9b9YBkoEKe37XcZ7EeVFd/6tJwGqKWol2ScLNk2xdEIIH
	pyNAokq1UBmH9GFMeu6/KCBbWHi6rNnL7LCpkQ00mfwYZ1CExBcuZQPmMjBfMRvs
	icqFAgUoODE6b54sozyN/12caC4wKLjRwY/4GTbHSfd3fV4X3AzYPnyCdsW9UhDp
	Ex6li41eEdPpTmbuMZ4WoqjKp5PpS65MMZn8n8TKwf10CwonYHW18kt0ruC+MXNi
	ulqV0wv09KEQjXCUTsSooU/lDfRAwrdfg11TO7ppTTVxRmtm3qT0SjFbG9IhOlNG
	z+hHMw==
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com [209.85.217.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cxnb7c2hn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 14:03:09 +0000 (GMT)
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-5ffcb3a10f8so6120219137.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 07:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773756188; x=1774360988; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nLZDYW56A6RoHAFTzDl5i+KhZW9amsZPLqs+n6djD5w=;
        b=jhw0lUx4VpEo1hFrjEhQv3/FszhzhGYA6ue9bpPxzIPb5EpF35MNy4jo5u5uOFhdOn
         xhWPGaNtHCbG8ASurhef63A4bkrEqwgjEkXnRB+oHcciogRU7njfKEiJwAV0PGB+I1M0
         pKyR0XVgOb5QolbQqgyTgu/M9FyCllGlA7ofaqGjygd+5gDhdctn2Vt0HLWvipZLmbXd
         vG+mGJPRdbomM9UIMazMI0ZnnY7tuYvJf2b7HB1+9x34ipTkDILraLYZVNtIJBbquTsk
         XbV6QitrrfbLGKZVHKBaPJxBm51YmhMldEzfKJh/jw6vNYAKq4QeTG9aaP0CCM6J51xW
         7tqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773756188; x=1774360988;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nLZDYW56A6RoHAFTzDl5i+KhZW9amsZPLqs+n6djD5w=;
        b=XyPWiFMEnmDquMAx4sUkxujbzdoiBRNl1ADggmLeg5D9Mbvj+t2YwpmaLrw8niXHgv
         qpxGy0LAzFttfTSf9e9o5ZIQSCYp5vk/F1uyR9bEPp1CU9748u1kxIE4f6zlMkkoRdwO
         dDzZMbCK4r3MlWNO+58vhh1DkzaQUI7qjNhY+Syw9dQ53Q4SG9pC6uUPK3nMkazwbBMQ
         r4l+Nzted9RdFG5iw2mq9FlUD2fJR+LiWUpiW7cTqVRvogdYiq4SKLMmb1s/STMnwIrV
         LactJOn3OfR2i6J66otoKb3IiR1x1mKGC+hQSsQUJEtJWNaQ9YtZLwqoihMnbHwLRMjU
         C3yg==
X-Forwarded-Encrypted: i=1; AJvYcCW4eYLGcxLdAn3SwMWeBChmb6XNTPFRf1KDBXLyU4XHI6G7c0XzfWj1bp1v0yGKGzZL/pyKmfg1nmhkPfs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCsftolws8ez3WYW/XxmcRrkkdXcBqm75AW7rDbHUipIAw1suZ
	y6IFvJ7n6ELWsvs3MHjRNJFfUl8CiAlUnbXmHpk97XYGJrNXyIqAaIL3obv+8lzez//uuSdNj76
	JbtsUHunUzKZvcyVsBpl9SlhTJaMysGkeuvGHXa7crVOfe1HPf8/eydaqpCsWn2ZARck=
X-Gm-Gg: ATEYQzwMSVlB/M+KWIHSoNfJT9Li510rvcLcfcYHSMKYyoFo6Oaql52OuUA8T5nVgdN
	G/hX7kxbp9iaYAbV2VejhBIq2VRGyBotfrRafs3ouki/DlgDcDKnq0nt3ooNnOy9iRa3qkVrazk
	/4u8R9h64CiCsWn0ulaS/hLb3fgVjATBS8rNTD+Usac5OBEvuz/RB5gigsEKUl1qGY2lGPknN+Z
	BZsnHYFdm0ooLabLP7f4VtA0YMxjIS+HyC6eW+Gr4fzqkDyRtKBKChePQTvRD9Lax/BLi3bEsvL
	CxamN6mrFr9ipddt0OGIysljJ7+6mTycOQWP/EqHRIw0h6W1nWG1EVTLie2wNG0Fzy4wTjoj7F4
	K0A1rD1mNjthNAGfCx4yyFsSw5LBrM0KK6Iy0rROep5u/Odak6qAQ
X-Received: by 2002:a05:6102:3e94:b0:5ff:befc:6769 with SMTP id ada2fe7eead31-6020e501571mr7432148137.19.1773756188435;
        Tue, 17 Mar 2026 07:03:08 -0700 (PDT)
X-Received: by 2002:a05:6102:3e94:b0:5ff:befc:6769 with SMTP id ada2fe7eead31-6020e501571mr7432059137.19.1773756187757;
        Tue, 17 Mar 2026 07:03:07 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:6aa2:dd35:4d6d:8eec])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b4938854csm9359709f8f.34.2026.03.17.07.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 07:03:06 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 17 Mar 2026 15:02:19 +0100
Subject: [PATCH v13 12/12] crypto: qce - Communicate the base physical
 address to the dmaengine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-qcom-qce-cmd-descr-v13-12-0968eb4f8c40@oss.qualcomm.com>
References: <20260317-qcom-qce-cmd-descr-v13-0-0968eb4f8c40@oss.qualcomm.com>
In-Reply-To: <20260317-qcom-qce-cmd-descr-v13-0-0968eb4f8c40@oss.qualcomm.com>
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
        Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        brgl@kernel.org, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2392;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=zaDjliGI9P8SDSmb8oK5ZUowNY4iBaNue5t3+i0OgLI=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpuV77vDCIAYQfI0C3VRl7ukLCKUCkcp4kTAmRc
 iM8NiplJyGJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCable+wAKCRAFnS7L/zaE
 wxoDD/0WSHRC6PfNqAmPMsnjMbE0sIR5179rvqrjPAs4tHYZjlfgSKp93rEdS4eNLqf3JrBuB3C
 tDP+ethl4+iQ1U/zNVHVLX0UoL6dd+kelGmj16HABRYfZE8OAww7gsCqgt+i/VuPJC1FvAtmXmC
 GdJBFhKm6ln6wNIiyYHEaGXbLCbrJAtSBQQ4s1ehX4guY2rrDaqrIzmdR7FYxzLRZKcHc4GrJ6F
 epJsJcM9LsAAp7UI5gUjq/OwYPZKCtmKp0A7sS6AUZAj/0vsOY3ery5R1rG69LOCBQMvyYjWefu
 jkn5BT6zjy6cyV3O98r2EqReK63cX0ybe5VlsUqhLynoFZUfeJD8aRIdnamKhjBxW/BpzcmP+1Z
 dJadF7bph5q5ZQWll4GvPeeR4bWR6fpE7CIejftDYidq3NDLDSofdlkKkiw3wMLxvYzJMO4hMT6
 DqrmG+lHvPf+R85RPdBBclZ2/05xpRXVT8xCDmnW3VrkxHUOROXBacLS3kXbP2gPz66VydFUzKF
 tsbaqFJ+nYrKJvbRRN7KYnx2xWUXgHdF+1ltnt/KTrPykMf6z89/PtWtJLQ0mDuwsBPZDpU7io2
 GmDJEP7kGuvldOvDCahNhdcmw8iTOnre/lQ8zI3aUM7sUmA/3hTfTGtX1A1DyqgSZEI3YJR2SlM
 rGyUPdHOIWTH8Sg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE3MDEyNCBTYWx0ZWRfXzkJ18VjnVETu
 xGTqvikga77cvx52mJY4ut7DLbOxJ0mvGj/M9K2IqENTDc7j0zxrcuH3Oc++xIeUJD5TTZ+jkkP
 vzQJKKMKZxSI/okm3AAwa9aerzJ8FUwJrSQ+9E4GmR1jNJZhJjnEnt4El1ve0/QEd+Hldw8cnc/
 H5rJoHBJOB4qmBqyOFUh5Gh5GXQg41tEevgi4hjcz55FF51Z7aplt/E/XLg4Ta/TFwrTbIrfcPh
 QZTF0zWomiqHyjhhpG/VDJETqd926oKQ7InSaRuy8aHLPXpPlLC+wQs8UGlk6zuKRt1EzpGnsc5
 L8zIOdCeO7Pnes2SsQYnryjxmPkC4oIgYLKhqrFpBUjQcZjcFpN6B5UkCyAuI9J9ANrGRMFH3uo
 aQy26IEh62+uc9E+wOU0cuB9nJxVftttt8882TVCnGnGjWbuPJmKf3y/HmF61i2TplaJfhXxgYr
 uhYr9rIO0UWUnMXYy5Q==
X-Authority-Analysis: v=2.4 cv=D7pK6/Rj c=1 sm=1 tr=0 ts=69b95f1d cx=c_pps
 a=N1BjEkVkxJi3uNfLdpvX3g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=6g4OycmRf1yXlxMorl0A:9 a=QEXdDO2ut3YA:10 a=crWF4MFLhNY0qMRaF8an:22
X-Proofpoint-ORIG-GUID: 5ifsUiA3bhAr1pmm17_es2rR0rO5S2bY
X-Proofpoint-GUID: 5ifsUiA3bhAr1pmm17_es2rR0rO5S2bY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-17_01,2026-03-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 clxscore=1015 suspectscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603170124

In order to communicate to the BAM DMA engine which address should be
used as a scratchpad for dummy writes related to BAM pipe locking,
fill out and attach the provided metadata struct to the descriptor as
well as mark the RX channel as such using the slave config struct.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/dma.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 5c42fc7ddf01e11a6562d272ba7c90c906e0e312..635208947668667765e6accf9ef02100746c0f9a 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -11,6 +11,7 @@
 
 #include "core.h"
 #include "dma.h"
+#include "regs-v5.h"
 
 #define QCE_IGNORE_BUF_SZ		(2 * QCE_BAM_BURST_SIZE)
 #define QCE_BAM_CMD_SGL_SIZE		128
@@ -43,6 +44,7 @@ void qce_clear_bam_transaction(struct qce_device *qce)
 
 int qce_submit_cmd_desc(struct qce_device *qce)
 {
+	struct bam_desc_metadata meta = { .scratchpad_addr = qce->base_phys + REG_VERSION };
 	struct qce_desc_info *qce_desc = qce->dma.bam_txn->desc;
 	struct qce_bam_transaction *bam_txn = qce->dma.bam_txn;
 	struct dma_async_tx_descriptor *dma_desc;
@@ -64,6 +66,12 @@ int qce_submit_cmd_desc(struct qce_device *qce)
 		return -ENOMEM;
 	}
 
+	ret = dmaengine_desc_attach_metadata(dma_desc, &meta, 0);
+	if (ret) {
+		dma_unmap_sg(qce->dev, bam_txn->wr_sgl, bam_txn->wr_sgl_cnt, DMA_TO_DEVICE);
+		return ret;
+	}
+
 	qce_desc->dma_desc = dma_desc;
 	cookie = dmaengine_submit(qce_desc->dma_desc);
 
@@ -107,7 +115,9 @@ void qce_write_dma(struct qce_device *qce, unsigned int offset, u32 val)
 int devm_qce_dma_request(struct qce_device *qce)
 {
 	struct qce_dma_data *dma = &qce->dma;
+	struct dma_slave_config cfg = { };
 	struct device *dev = qce->dev;
+	int ret;
 
 	dma->txchan = devm_dma_request_chan(dev, "tx");
 	if (IS_ERR(dma->txchan))
@@ -119,6 +129,11 @@ int devm_qce_dma_request(struct qce_device *qce)
 		return dev_err_probe(dev, PTR_ERR(dma->rxchan),
 				     "Failed to get RX DMA channel\n");
 
+	cfg.direction = DMA_MEM_TO_DEV;
+	ret = dmaengine_slave_config(dma->rxchan, &cfg);
+	if (ret)
+		return ret;
+
 	dma->result_buf = devm_kmalloc(dev, QCE_RESULT_BUF_SZ + QCE_IGNORE_BUF_SZ, GFP_KERNEL);
 	if (!dma->result_buf)
 		return -ENOMEM;

-- 
2.47.3

