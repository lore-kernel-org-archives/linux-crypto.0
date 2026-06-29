Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EB62E7378
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782727310; cv=none; b=tTAQZd5H+V4l2E9uCtF3qNu/V8COB7v0+tkjfTgAX6kPWt5MGLdyKhhRW1d69JkUGNb+diupXNGBsupHU91UFPxl1ccR9fQU22VOb71/9CKIQtjoMTKb8oDHu9OvIAuJJ3SPswO2UDKRTDKlDDuOrgVqixXtesX/Rhdg6kywkk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782727310; c=relaxed/simple;
	bh=vpDVf/b6zHPEUgtVCAl2sRJELM4MLJc6gtP24/up104=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=G15WWfuiD8Pq3N9hKd2AC0pft/yjlgrk/ZdKvh7nZTo7sMxreSFwE00TjYbOwkba/ZGUYPgiXwVQlP86kTEUohcif0vFSFFdKMarkPAyClqJFyJg/WctzJFWYrnaq8rbNjEf/bRaxRVPy42qlW+LpJXFLRn9faoRyPdEybGk7JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LEg703f5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=F7eq1ldm; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LEg703f5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="F7eq1ldm"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65T8OODc2349158
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	twry+rQD67k4KXlgASz4DIRuOCwVvltNp8BQTuA56nA=; b=LEg703f5oAUmJAal
	+gHU7nu0RU7bBn2r1xrDChXJ+FR4599Fai3eHgqxavOc0YxvdUfypUPymZG6KFQu
	fMqH/TDOTpyeMBTEQfuXW9GQHgQLsFdA4+v9nIgClCgdoOf0Qlfh9kUohbLTk6y1
	s2YGV5/SG7YNkVhNd5RuO5ZMziR/TKfUZPB6sJu68rxvB9JMi6+atAKgsVuYIwiW
	W5BuaRSCYmNdQmrelbUvRQZr8ncslfrcAdgNzLVki8k2h2XHcrBYpQKL8k336sCE
	46RZZkiz/qmDeNp/bD+wn1TIovRJYmLiHTKOFHo+xyDb6gEB6IVQE0sLXNxS1H15
	GIxexQ==
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com [209.85.217.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f3n5s0e30-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 10:01:46 +0000 (GMT)
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-737cd7b76ceso465289137.3
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jun 2026 03:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782727306; x=1783332106; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=twry+rQD67k4KXlgASz4DIRuOCwVvltNp8BQTuA56nA=;
        b=F7eq1ldmnYkz53SUv7HJ64/ow9eHXpV/0JVY9ucdBmvYgiQOc3TxhtwUWndXTaNY61
         sXjPSKTPO1UN7w0Rxnj1zUPaaSO+jVuDOX7ReeUTfYUXe9fMLWomUs7AeYLTVmN824W9
         JmtcxadcQQYa7MZLS5mEMm7f490nmVkaI9Q/CQjrWcq1enT2Q6WD/2MwzP60XlzJSB5m
         gnWKrRUO29fEdpXM+1OVHA/SC5vK87RZeeMsNFLZvIzuQb91KLOGMQ/DSyAzgjqRA+ao
         zHK4ulpdOXtY7QotPkrwZVa7mM+hjL4iQLjvP2qeS/oKfPASov3d2mtiC7Fk+32QKPc9
         laaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782727306; x=1783332106;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=twry+rQD67k4KXlgASz4DIRuOCwVvltNp8BQTuA56nA=;
        b=p7YsrdBllnf6NdffeHQXq67uZachAMNF445cmGIOMLhyJ/EL/6rYDdtHFNT5hVTEuu
         OQIZa2NhpHAaGs/JPlP/m63Ft+axBqKrfF7Y4h8wdizi06u7bGKscEvrEWhc9oSfNrzp
         uo3DhXinsj6cn6JhhVyVB1oj5UzK6U20XdZKi4JSyoBDQSnHmMnMltJeF29XZMvvciaN
         z7SGkD0Tkgm26x142xZOY8BexlYkTtu28AOz1mT5VmEkVzOhzVFib5lcXS8FP7OGdorb
         0dbBXfywklg4Nl2cNjOU32XT00bkQc09m4fzk1YmUsMP7f15yRdHgQgRmozArpa3mhuV
         6yZA==
X-Forwarded-Encrypted: i=1; AHgh+RpZm3N7OJ/HdH2D0xRUAVbB4Xtn4l93h/FNzLqdHw9/vYx8Vo8qjhcGUomdFh5aihAKL3LADJEqrIBRo/0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+JsLRAveY4YcQ3hysgHCagMT+xoeeJHfz8mkIUw/tjf8IAWxd
	+QwpKxkK5ZPy2mHDSu32sxoUFPQNGklbjFxTxcAt9ujhpDcyiv29QntsSqpfKgfoDemTtDaavRf
	g7fO0iuiSLoeDQreiDaG64byW1OIC+yMWOmM+xPifHKjsQHfBDok6IBYIkgeDzO96XWU=
X-Gm-Gg: AfdE7clE6YNCROo3zzUYR4wVJWM10G1WyD64bPLnlQ6dZJH/LPvir734FMpr0X7wU5D
	AITM7cc+87wck4IvWYcAHYJcmXUEkfnOsEo3fPC2mcr9WBRKkjOpGZooB82lcPV6l98z4ZYzVr+
	L7ThWO/f5d4hASEJMhRuhATs1LmpLa6+L2ntVyQhnKIJsiZEph5UYy9a6G9q4pqN5Xl2gRFEFu2
	yn5Mh34rnEusONFH8vm4+94UzG2qwoKJvxdQJR2YNcz0EPr5SjV/2WkqzzZpa+3sKjMY85jR3IE
	awHG3b16NrYJg3xBhZjcOyk1akx3jbY5iubW47q1Q4n59eEqRrzqwoUxVXKWIT0F2iVa+8sphYl
	8jbZT+5RtzWKiNUg4a4mZByExoMlXgyXMYK8rhcu0
X-Received: by 2002:a05:6102:95:b0:737:e354:4092 with SMTP id ada2fe7eead31-737e3545ad3mr1196575137.11.1782727305953;
        Mon, 29 Jun 2026 03:01:45 -0700 (PDT)
X-Received: by 2002:a05:6102:95:b0:737:e354:4092 with SMTP id ada2fe7eead31-737e3545ad3mr1196526137.11.1782727305442;
        Mon, 29 Jun 2026 03:01:45 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:4640:d76a:6126:9b65])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4705f8ea729sm24729405f8f.0.2026.06.29.03.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 03:01:44 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 29 Jun 2026 12:01:11 +0200
Subject: [PATCH v20 09/14] crypto: qce - Remove unused ignore_buf
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260629-qcom-qce-cmd-descr-v20-9-56f67da84c05@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2066;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=j6XY4tGbVrzzivRLNBnBuYRESnCKLFI7yXVP5haQkuk=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqQkJwPS7oWMhegzDGpn6W+WADbxymK6guX1y8I
 RaJU6CKoUqJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCakJCcAAKCRAFnS7L/zaE
 w7l4D/oDvOndI1JjwtBTY+Eg/bVcbRTNwsf0yYfaPDEt0LlPqKKKDJYkylNF8Ipu3XluJurf9yt
 gpAQVPC5wJsdY5ACa49GVUxlFR4tvj2/bvgLXhNCZJ+5qeWvnFU10wwIioy1ZZx+KnA2CgmWX3a
 EjYzP8n8WU8ob08iLjXkF5QCFJV9qt7Q3uKwZte9gMm6inrvXliFICfFtcnqxahFSrjexSZnvWA
 K9N5xBr4Hoi2nXUGELVaGOLJN5rCeZvuPeJ0HMdSKUQMq19297Dl/+DabLPQ8TM60NFLouknc6U
 6S97ZdznObH6VPHfqfYkAwRQsLMZd0nUpcRULDvXPKlutq+vUTePngIC4RBiUHKT2a9EDPFB0hA
 +ZY54bSMoAloFzrIiIjLIAvI3WxbuFaS817bSk3r0GOvsbiCuena4hqXzN4ozWZfX43O7paBc0B
 heLR/M4QLCGLcdKOFyCVu5Lw2YBIPNizbdx+HJLm7p8i6nSts5VBxcqEQNjOphoy9QrdaPm56Pg
 PiT2np59HB86JEk9KQ93C+mfdeJZyfsDcNFtUWdiI7b5I1YmG4fLbYbIKE746zHsQMXcpaT1Jnb
 +8OmA3oc+ikQqsN4blAe6LAwPIbjRwy0cJBUic3PzhK2DiOEaabhV1Z3oLKEDNDSy3iwAY4whb5
 yx6/YbbrfsT7ydg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA4MCBTYWx0ZWRfX5u3fBs40jk/D
 LUCrQD1QfFbwklEr3qLk+3bFLZn43wMs+KSUdT+X5Mmlpf7uSmojdFnCZadZG52OMo7xIj5xWdk
 AjddFjFzEm3wtzgkztVG2KXjg/1UbEU=
X-Proofpoint-ORIG-GUID: L4BGSXQEwrYD_QWiyLt2uNOVVyNJZ3-x
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA4MCBTYWx0ZWRfX+CGuvLJf6Lx5
 LTc8jMmaphgmbxgbcgGxmXSTxbA1Uja7se4b08jEit9mY0hBhZWEkYZxc2cea+2G7dD5VhQ+/xH
 B9qh7w7OsCtFAMQTQWnuhFNlD874FmAtydZxJ1U5h2aYSTmSTnqJcpVoBzXKL3kR8XZHzg1FS5D
 jQYzKlkTH+tn3r6W+cbJc6az1H9uIVob8i9I3B3P6hDDqp/7nhi6k3KGgWGX+F22Hcs1PIdFFrR
 uVKckygrHPMAHB8iWlNGE12iLaxL8N/a8xXjONWZkZ1tLoBMmpHxsRCLpBBZU6JEZ0KY9JLE6yL
 3OHJpQUJaimh8ttFNT9E15oPzQDZep30POaZujDXBVWaEcHWZ0XkmE87kCdqYojwuTZhUd5URuX
 d5q2ulkDCsSDNUDZUkH+ZOCpadf/GrVwkgzNgu916d+JA4Fx/a1XIOky8oI4w0DlKjIrAKKRKaJ
 /4/xFXU0E3AuBVTEGtA==
X-Authority-Analysis: v=2.4 cv=NZzWEWD4 c=1 sm=1 tr=0 ts=6a42428a cx=c_pps
 a=N1BjEkVkxJi3uNfLdpvX3g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=tWRRbWwrKX-5tUpmLDIA:9 a=QEXdDO2ut3YA:10
 a=crWF4MFLhNY0qMRaF8an:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: L4BGSXQEwrYD_QWiyLt2uNOVVyNJZ3-x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 spamscore=0 adultscore=0 suspectscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606290080

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

It's unclear what the purpose of this field is. It has been here since
the initial commit but without any explanation. The driver works fine
without it. We still keep allocating more space in the result buffer, we
just don't need to store its address. While at it: move the
QCE_IGNORE_BUF_SZ definition into dma.c as it's not used outside of this
compilation unit.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/dma.c | 4 ++--
 drivers/crypto/qce/dma.h | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 7ec9d72fd690fb17e03ade7efe3cc522fb47e1ac..d1daa229361aa74da5d3d7bfe1bc8ab189761e38 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -9,6 +9,8 @@
 
 #include "dma.h"
 
+#define QCE_IGNORE_BUF_SZ		(2 * QCE_BAM_BURST_SIZE)
+
 static void qce_dma_release(void *data)
 {
 	struct qce_dma_data *dma = data;
@@ -43,8 +45,6 @@ int devm_qce_dma_request(struct device *dev, struct qce_dma_data *dma)
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

