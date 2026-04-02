Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0777E3F0752
	for <linux-crypto@vger.kernel.org>; Thu,  2 Apr 2026 14:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775141769; cv=none; b=MVC0yeH9ZvCVRHL96iwV/vrvgq9fMLAyScwWrI11671gMkUzaya+620wlZRdHeDHSr3pgfre5o8xzPTjfMRvDPcU7NOfi61UD7EKvMOQ1Ro3tZ7DiPMWUr6W5PoXpOt7sJqA82dfITJ/W6A+b1zYe/s/yBgeOeBuxr43vsqoTKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775141769; c=relaxed/simple;
	bh=6dN4XjHr+6OQnOzxmGwMll0VZH7PW0q5aNlxk1E5+Hg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Owrt4zjqmcMyBvD4OesC8BaeAcG/mskk3XdjGOQKs7yQWKWm15mGRG1qQIo40NEglNYgadPGEg6UAHCXkcpZV/rD15HHVrt9E/H4brbeqMp7EgBQ1tcDd4rhEtUSBKgoW6f63i/q4j9k2DQ2pazTSW8dUgbtfSyDrLvvK5Iu5sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fnAEDssy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IyNFdDlD; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fnAEDssy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IyNFdDlD"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632CHsB14009752
	for <linux-crypto@vger.kernel.org>; Thu, 2 Apr 2026 14:56:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9iGVNuTYeeAltbq14HNN1Bd2g5XTMHQ/MFj6N7hyZ8I=; b=fnAEDssyNLp3ghhD
	f25/maqd1A+1r1IMow5HxZz/DPatB5OjSKm/mmd+91kbOhUstS22Az8SuZPumI1v
	1vsfNL9zjpt9rK/2Qf9OIsVS8nbFK+ZbMk3UfgPu+tafBQ9zDZSFlzedv0egIWD1
	XaXCo/gr54EU1KiqKRlDIut2Ecf91D3q//fnIIB8LkyZDsij2K8D44LGT7x3mMl3
	B1L8IqZdBb01hikGg6BM4UbmqrF3YqyP6A04or+xKwyjek+MgimeDG2wG3g3+iK4
	GRquod6DN6hSJavBLdBwhrbQ5j/1goF/2ZfhxaaYy37iNkzIdWYATZ7nx5pikEKB
	Bc7thA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d97e04kyk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 02 Apr 2026 14:56:06 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8cfc61fc9b8so217039585a.1
        for <linux-crypto@vger.kernel.org>; Thu, 02 Apr 2026 07:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775141765; x=1775746565; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9iGVNuTYeeAltbq14HNN1Bd2g5XTMHQ/MFj6N7hyZ8I=;
        b=IyNFdDlDHzxY5egKAoGOE0eGdm1zeZDnEsydRJqp3cEmu1reCgxWSDuTPQPbJ8xBSi
         PP3ehw129+Uusbw4gP0sYtStNxmMdn5ieP83uD2WCMHPTKe5jNBK724hISKmqh5vEQmE
         YqmIYTLDe0m6ZvkSg+D2yHmo4RietaM10lfGqAafNCgAZkMsr/udAMgQckHYStVKD4vH
         TVdTrcsp/l6gAJPcJEYjStbJ+YItZ53RkuC91YCXjNu2LhPZ9xJXWEJ+qbJPPT9WvanT
         8zh0K8TS5xcP0Ezm+HbNkhGYEGP2TrWK9aG8OZEI3FBhPb7RQgzTS/qLuu+xiXOerdHw
         wF3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775141765; x=1775746565;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9iGVNuTYeeAltbq14HNN1Bd2g5XTMHQ/MFj6N7hyZ8I=;
        b=S4WMm4tBNfQErrNeCbPCtNU2AVHUOP9+/+UPFlL4S+rrUX6MOxq0xzIo7B5PyZtqX7
         ZvX3GpSQAa2FowBRmwdiKi8nVbec3YsHzwzJyWY65Qp+KHMHUuLFHXrG9pLgJfk8PuxG
         qPJSOt78CS/xKlHuvrBn2y88fgQMrE4h6bA+maK2KwU/2XQ5z5OLllXcyYbPqGvUUV1g
         V/cjHY2XD2zmwUmQrk8cb6lIsCwtfXYsJLpktRFsu/t9i90nOqelOR/8l84z+DkM3uJF
         zP3ow4oWLRRejUC6Y9uAHluDYHk0fegdm0YT6Y8N0kanqqRFrXKuJXG5oGJF5kNa/cr6
         0f2w==
X-Forwarded-Encrypted: i=1; AJvYcCVKQBPnax1SjN6DAnwK9RJZk/rjKVEMwkBidqkHv9EZgT+z5DQUtOQnQ3RkA0Hz+yHPeg1pUlztsWA2fks=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSSsRwJJ3kNvCnBpC77utsGPtRWgriPt0fmySZ1M62FzLKAmgg
	uK2XsB+SBIhwqsTzFrderhAD4xJMK3/p4hPW5p2m+Ei58buQ/uV/UjH4Y78nXFg51ldthnBwEaq
	DwW5gDaaURBiufkh5j01fM07Wqwrxru9/VkFPLNsp+EH3D+W7vfTSv72ohmiPe12OEnU=
X-Gm-Gg: ATEYQzzMtqq6eXcZxCorpjxOrztQ9FZEAzQHW652F5noc47NC/UrpKpRyqoKB+zjT4O
	j+EfuqDilrv3rH6EhnpyENy6WyjIv23nb+YpzyvKl49yaL5rCgWBR8uLvYKun+Z43Aq79ZzcEZs
	OKF3Gf+S+wYIA/w7Uz0pGFhOwhvf7qGYWiT/uho28WQ45B8eoI8fYB+SwUMqlePJkNiJgzNNLN3
	iZyIE0D6EA/Zko0B87roY53O5leyOSuM1UUb6ej6sO3SXQs+HXF4tC7DSwxujq7zzuJP8dWCtTS
	yfMM9vf57bz96DQaSw55BEt4LdlYPEFNJ7pVBRpiHWuxWULHmtY7hO99/dIAS4PFbvAXyLTobsL
	KVgx42MyW5yLEL5xR5/Q8WqdrDjaX9FoMdZB9gYiziVKjcCb41tYC
X-Received: by 2002:ac8:580c:0:b0:509:3cd:b243 with SMTP id d75a77b69052e-50d3bbddfecmr105597551cf.21.1775141765139;
        Thu, 02 Apr 2026 07:56:05 -0700 (PDT)
X-Received: by 2002:ac8:580c:0:b0:509:3cd:b243 with SMTP id d75a77b69052e-50d3bbddfecmr105596981cf.21.1775141764680;
        Thu, 02 Apr 2026 07:56:04 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:4ff1:3e57:22ec:dadc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4f5294sm7234038f8f.35.2026.04.02.07.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 07:56:03 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 02 Apr 2026 16:55:18 +0200
Subject: [PATCH v15 07/12] crypto: qce - Remove unused ignore_buf
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260402-qcom-qce-cmd-descr-v15-7-98b5361f7ed7@oss.qualcomm.com>
References: <20260402-qcom-qce-cmd-descr-v15-0-98b5361f7ed7@oss.qualcomm.com>
In-Reply-To: <20260402-qcom-qce-cmd-descr-v15-0-98b5361f7ed7@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2012;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=DfH5Bb+Cx5AadRW9+jaH1GcMtyO0VLpMWlVREcJBr7o=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpzoNyFx0Etnu2/7Xen0gWpBFZ1ieiULMMRmf0H
 dTMlK6qKdeJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCac6DcgAKCRAFnS7L/zaE
 wxcyD/4hXcbTkC8LIp/lwCB+yEZJEm/+U6CMtxj0z5MXytldDhzObBweDdkesDvi2TH0bZnhx/M
 QAEDeB7fy3n4n97BktwVseoItXlZ2bj9ipNnLEymN9G6ze2aZKXIkQ3ANRQpc271S/pz4R8pD1U
 XMip2W2kAz8R5+2cygpnjwYHhCIjXYuK7piExHs53IaUtpqWgdpUYsbQr7h6bu/Kjsu/jMUpiEJ
 TnnF0JEkuAGezCa5beyxU6YL8kMaFVT7h7Vg7x0RYQKu4G97cZAVX/zMY5rJVWsj+EDoao+lUvM
 wD+nv8o+kyD3Ikj2lfUVY2AzLMMANjOQWZuUaUihp0iVfh5uX3Oy1gBAT25PWFcUGX4n2C6oD9d
 o49niLg3vR2qIVQCtghh2fx2Wl/palGRNaDucuTAzrXIS6taZ6WBx160n5jodW+R2AqO86pnudI
 tUqBye1okP3/9ucTEBmRQsu3W2WpNCWHpjvLZH3qYVEXveiWZ58AfRRdrpmopJ6wb1z4aKMpq+z
 94a45xjHW/dO6ffUlFz1HLxAi4BvPiWd9n5Bo83Y9eY/W1wwQsSjUpRRLhtkgK2A8AI7hIVzYzA
 +pLL16n9HNqW5r9ginpaVJg1RR1v9VIk1mWRFnaQ+skPc3e+DMDwSqO2BSRLREqo4qXE5S+4GHs
 BjTGf2SKCagZs/g==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=fdGgCkQF c=1 sm=1 tr=0 ts=69ce8386 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=tWRRbWwrKX-5tUpmLDIA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: H76H-81gNrc5R2zfFjwc5yXNvLDTJFSG
X-Proofpoint-GUID: H76H-81gNrc5R2zfFjwc5yXNvLDTJFSG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDEzNCBTYWx0ZWRfX9RSdHdnLxmkw
 9AaXgvRXJGsK68lms9j+J1NejlBHZfAeOKkVLJor848v1UE27+ng768frB92xeBNVKlRx55RT/4
 iWkxh7Rb0W3E+PmSI3nkyBl+D12oshJ3kn0PbnmoCWC95VnbH4eON3scMlbQl8RCr/kv7vvkEO3
 FduzJqJ3fw1YNAwTTFKPqW5PTAU0SOfZ9fvETuTUcZAR793dxWpteoZ/N8F8HplP1BQBxHP1lwj
 agPowSAHb1ToxbvlVNkapBDMA0mNyzn43CuaUV2h0Qux1nieoTKc+Aulp5TohjEFnHelxeVQHt3
 xp/UJU0cPZXwY1XapFVILkQUkl0WOd7bkUQOXzW6ulpB6NVG1cYXVgWdV3zt6B2HGOSViOA9G2v
 hGXGOpFF5o6C8c2H32BY/ZbQthM20loHcbITZbrUTTboQgv2pAPNFsTl9WsuEe0sXd8y6QF3/7j
 d29i+4DkD40qpbFKVzw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_02,2026-04-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2604020134

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

It's unclear what the purpose of this field is. It has been here since
the initial commit but without any explanation. The driver works fine
without it. We still keep allocating more space in the result buffer, we
just don't need to store its address. While at it: move the
QCE_IGNORE_BUF_SZ definition into dma.c as it's not used outside of this
compilation unit.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/dma.c | 4 ++--
 drivers/crypto/qce/dma.h | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 68cafd4741ad3d91906d39e817fc7873b028d498..08bf3e8ec12433c1a8ee17003f3487e41b7329e4 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -9,6 +9,8 @@
 
 #include "dma.h"
 
+#define QCE_IGNORE_BUF_SZ		(2 * QCE_BAM_BURST_SIZE)
+
 static void qce_dma_release(void *data)
 {
 	struct qce_dma_data *dma = data;
@@ -41,8 +43,6 @@ int devm_qce_dma_request(struct device *dev, struct qce_dma_data *dma)
 		goto error_nomem;
 	}
 
-	dma->ignore_buf = dma->result_buf + QCE_RESULT_BUF_SZ;
-
 	return devm_add_action_or_reset(dev, qce_dma_release, dma);
 
 error_nomem:
diff --git a/drivers/crypto/qce/dma.h b/drivers/crypto/qce/dma.h
index 31629185000e12242fa07c2cc08b95fcbd5d4b8c..fc337c435cd14917bdfb99febcf9119275afdeba 100644
--- a/drivers/crypto/qce/dma.h
+++ b/drivers/crypto/qce/dma.h
@@ -23,7 +23,6 @@ struct qce_result_dump {
 	u32 status2;
 };
 
-#define QCE_IGNORE_BUF_SZ	(2 * QCE_BAM_BURST_SIZE)
 #define QCE_RESULT_BUF_SZ	\
 		ALIGN(sizeof(struct qce_result_dump), QCE_BAM_BURST_SIZE)
 
@@ -31,7 +30,6 @@ struct qce_dma_data {
 	struct dma_chan *txchan;
 	struct dma_chan *rxchan;
 	struct qce_result_dump *result_buf;
-	void *ignore_buf;
 };
 
 int devm_qce_dma_request(struct device *dev, struct qce_dma_data *dma);

-- 
2.47.3

