Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E15B3B0AF4
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 15:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773157515; cv=none; b=B28BM/L2ZDlUk/QMiXFHDfWXk05pcYpfRabBKignYZz/p0LVRTnQTL+ycH0Y+YWRslSLbP6WSKDCme/+IQtUCV9hc+h/5aCRnmKfNocZeKdFPI8SMoHe4EBVUUOb9jBDFGn4+3GYA/HGX9FANMAvf/p776U/c8YveKcbVWsYwgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773157515; c=relaxed/simple;
	bh=E19Bzt73t1zSAfX2/01ff6pZaiXi+Fsgm2+zGDQ+P+I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EdfyhSkuKGzhmY6UhT5Ydnf2P6Hsnffj5JrW0n84YRGBj//oj0V1QoGF9wphkStiZWSc3X5pk4gDs0qgGC43UT96kqaDZ719M9smr2QS3Ztdayql90l0yqKvR0Q+wMLI/PhFsS2C2XVo6+Bmkb39+bynBGy2t5aEHP+5szD++GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=m3ODAHPJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dWYiXCo7; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="m3ODAHPJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dWYiXCo7"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62ACaWg9024189
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 15:45:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mX7VZc0C4Y6KtnlB3JQWqwZ8mA0msAHnsmKHvmZNoXc=; b=m3ODAHPJ+mLT+uru
	3AWl4atTBvFth+TCsSNP1pw8J0FNJxmXF+/HqQQr01U2cUwK90w02qHaqfWxpvI5
	O0CTMvkBjZI2/OnR0DvfJ7FtIzDYGGWYHXz/eWz9BjbmkTXD1W6DWDDHzlVAdDi4
	7r4UhhI4sX72Xk4ZGDAZQrNmMxdDBrUYyoTRGedmf2rzAnBqV7TI7nQlxDAcvzQO
	eVdVyi+PF4nOKPxX6ZA3hzsEgdtqdZ3LxgLveXXjdthHb3WSGkBeMqSPXD3wzlp/
	I1dsvfSB8dNmbqxjuE9pNho5H9sLKSt41M7Vi8qgHtwgE8agPc5f8jm6WLdXwmnA
	+jzMPw==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctg5nhk6a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 15:45:11 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-50333a8184aso1017157401cf.1
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773157510; x=1773762310; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mX7VZc0C4Y6KtnlB3JQWqwZ8mA0msAHnsmKHvmZNoXc=;
        b=dWYiXCo7rHWKSRd4/Do+2h8PLpIihfdLupsM/uoo5cdQk3OPgZYRF/dv8QVo0sNvKJ
         2pj6pxNofIHrdAjMsz0jFcfTCzvX/g+c/EBF55lNcF/c7vfYZ8U/+gohq0nYnYFgdj+t
         RN+xvLl0bWFM6CJjsqglPDt0T+klnLN3Tb4ijzJ5WPM6vRy7vQ5dEkuX/2iN7PFcnkhr
         PoxaTiRuyb8OEZxewkDkD8IiFdXrMf0tUhzF9I7OJyNByvsb4EvJGn9tbnQUzdFE8opc
         TYr4v2HEwxOJMaSMoxMKjAjD4k9SZKARi4zb4HZkMFBqwNqXws5yuumpcoyRVlV2icbr
         FaIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773157510; x=1773762310;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mX7VZc0C4Y6KtnlB3JQWqwZ8mA0msAHnsmKHvmZNoXc=;
        b=KM9y2kg0udOjB6gl0DGP0uB2gpfstFYnix/7XexdQ+7tao4dkLVrXumN1ZA7KWfdn7
         FTQexa381qvuzmLvZeErW/5WVuXnJ2Zdai76yaepTPhBFjNFXYpcN0DAOsHBIy8wGdNv
         FYWV1dpUKzjBBf79/Q04VTMIho2Pe2n3juovaH5S25457EPv3Qg7RGt4ck1WYFd0/Rda
         TqgEO/lS9fkgrmetmaxROjJrvbRyE2+82TcxGFLUSdfORVi+PlJ9SU2Kaze0vcXoHG3a
         Jcz/FqlCyjneFR58hOTscR9WkhzkrVDQe8O8v8KitncKTmdsAvAoZfMElq1leWTf8NIt
         000w==
X-Forwarded-Encrypted: i=1; AJvYcCXFCGXh4yE1LerHa/OV6tnpuU1PK+knmwQrImuLO68XofgPehFn8xNncGVKtdRAxD5w1tdm9/8no/9S8Fc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQ5EB54sdg19u7x8fuuNybu5lFpb+Ywd5JJ+IIwqNOzpKgdBAQ
	dcaHi4Buj7utKXUHdZt9p0l8rGRjQDNhpc/3fWMm/RBAG5Ye/Lc7C3KhdHB1nq9PQmGVHjSah7Z
	6ihbXxb29yEoOkZuKxcCbJIy1CVVKDuJob/7y3hzoKZbCM+dPQlvUk9f+lRkMXStlk/4=
X-Gm-Gg: ATEYQzzC4UIuQ3a2v+Sp5JuJdRmcZkKYE1yzxHgj7V7NxVjXXgI8qvDqF7oJ+Tv8whb
	IUmOJj9REtCIFwZBJLzIh9pZe/ThrYzZjt9X9twpEG+9naRMjY2Twhp679nMm27e3QsQbCEi53d
	JieJWfd54PCx76Kd/FgN709asDcfvJb+62zw5gpnC2G3yqry5v3uhMIKYSjNc/9WxJKXjiWzt6T
	+rvebmFvGrj4fdSItTfL/6osQDBFTVHREufF85WJCZPKFe5ZeNzi72Fjz/yWE+zk+Vxk3HG5yML
	YYaIIOdmV8KRhYWxbCOsOPgqEcT5udvYcsFg0rSVIhAZbS8cAU2IELuVzfxnYqYPiLshXxIyDVb
	7UOQTP/AiFXjFQIPWoK2XSe8UJvgdZde3nC7SS+SL/b9N39Pv9Hqc
X-Received: by 2002:a05:620a:459f:b0:8cd:91f5:7a29 with SMTP id af79cd13be357-8cd91f57c94mr600693085a.53.1773157510173;
        Tue, 10 Mar 2026 08:45:10 -0700 (PDT)
X-Received: by 2002:a05:620a:459f:b0:8cd:91f5:7a29 with SMTP id af79cd13be357-8cd91f57c94mr600685585a.53.1773157509620;
        Tue, 10 Mar 2026 08:45:09 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:47e6:5a62:7ef7:9a28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dad8d968sm35991600f8f.6.2026.03.10.08.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 08:45:08 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 16:44:26 +0100
Subject: [PATCH v12 12/12] crypto: qce - Communicate the base physical
 address to the dmaengine
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-qcom-qce-cmd-descr-v12-12-398f37f26ef0@oss.qualcomm.com>
References: <20260310-qcom-qce-cmd-descr-v12-0-398f37f26ef0@oss.qualcomm.com>
In-Reply-To: <20260310-qcom-qce-cmd-descr-v12-0-398f37f26ef0@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>,
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
 bh=E19Bzt73t1zSAfX2/01ff6pZaiXi+Fsgm2+zGDQ+P+I=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpsDxqf7crh0eAak9U6C23Q3P+wGjMPB/1YbCCD
 xeEoYobLaqJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCabA8agAKCRAFnS7L/zaE
 w2eVD/9sbXB64zWnj0AaeA4iZQubFXVyULCqF0PkraiQCXOMIT+DW9nQdGdDILB3UKyvDxHrhgK
 4xkO0LIePybUCrJiHWbhi6jBM69iLjN8gGXsLZGSvXJE2h6W9u1CocQditDn3OR/quXy+v6UHVp
 YfMEUO2g3vzgxNaJEN1gH4m1hvWcDKPhS9aWY8gaLmdIF9V8g3AMXrGcpUO7gs97exG9tWhMt25
 OqczZWp7n8hPrNA9ITYVTf4u38DKNzOrha9NIrGQicdyzxV/iQUxJAcPYdnYYf0ImZ2dS4TVq9O
 uIMb5DMp9kr7mls5zZTdzT9/JUyafbKgAPfxs/5R9kf4XXhOWM8KmVPMFWANIRPKaYCFB43dxfo
 k7JTtTXM7KY9VLJi0P9I7lVL2pWxaEKVTEe3cVcWmBAGDJoNab1ZUUWJNjbYidNznEoNkrGYj1S
 ijobV7GkrSBYXj1wZ878807AnKDYsUL2+jSjTMtPRWvjtqle063PcJ0h9VpB3xUxll+2qh9Eymu
 s1Sp9zR7FGu8eIn4We/kpvP8hRK6HUA11O4HLcugh69lLvA4KoAzOseFFZKZEyrirJfyONFbxYj
 K/MEezvk7XR8ym9xZGKEWKIA6JL1rLC7hgWFMVJv+Pb2uOBXkaUVaozTtfwmfGq084TQwkEAzLq
 9iuJO1MQRs7FuCQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: HGy0VQh9fnfBO3spHZYAzJaR3Jq9igEk
X-Authority-Analysis: v=2.4 cv=ervSD4pX c=1 sm=1 tr=0 ts=69b03c87 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=6g4OycmRf1yXlxMorl0A:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-ORIG-GUID: HGy0VQh9fnfBO3spHZYAzJaR3Jq9igEk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEzNyBTYWx0ZWRfX5Umcy/WJIdXW
 h4klKe98BipuSPE52lraMyq4v0NUPcYfwAXcRW8OMzZJuhf59jVXNBGWaClD3jovmN8fRA4gxoL
 mMxl+p/DE2Q11BfvIA2MqFuGxswLA9132glnjdNAZtqAE3mTPlFz6jAp6+TXjGRlb090XQlTMCz
 iTUUztWiF31z6Zo71Snt9ZTHvGKI5dqsFY8JqTyHVvyjs/ESSKDjOAalkeQVqIrbUwedCwBZbrQ
 YMtCQKdaER0K6sLy4FDDrVRAVuDfRunzVMomf4PUCG/IflFm5TcdCESH9GosvNKZecP8AvnFrMr
 8QFCHjyskYwpCtSoLjQlvc9m9aGsUTleoTlFer11TmrbTQ0EnwvLZ4PcfFb+QTXwzv8/lLCslxY
 8ZeVSTZEPk5jh8AKKj0miiAKUtAt+nwAHkET6OKotx3nJPlsaM71LQiSDiw2iNsV3KFgnzpy6Vf
 JQWMH62YrPr0sRl/wAQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_03,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100137

In order to communicate to the BAM DMA engine which address should be
used as a scratchpad for dummy writes related to BAM pipe locking,
fill out and attach the provided metadata struct to the descriptor as
well as mark the RX channel as such using the slave config struct.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/dma.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index ba7a52fd4c6349d59c075c346f75741defeb6034..6ab352261223c3c4815a01e84238447e8e61e040 100644
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
 
@@ -109,7 +117,9 @@ void qce_write_dma(struct qce_device *qce, unsigned int offset, u32 val)
 int devm_qce_dma_request(struct qce_device *qce)
 {
 	struct qce_dma_data *dma = &qce->dma;
+	struct dma_slave_config cfg = { };
 	struct device *dev = qce->dev;
+	int ret;
 
 	dma->txchan = devm_dma_request_chan(dev, "tx");
 	if (IS_ERR(dma->txchan))
@@ -121,6 +131,11 @@ int devm_qce_dma_request(struct qce_device *qce)
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

