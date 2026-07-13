Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF219416CFF
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783947719; cv=none; b=aUe9XsMTm4LnyJKBXsK3GaJnV5spKG3tD1sbCM3cEGcYX0sg4Ns/UqmXp4EdGJwJXKsM0g0GrPgl30UMd8hW2s662YFHnZh9M2zLrG7D3OZLgNvrWEfWlsyNCGa2WC1EM3vLIxLm4AozNIGTKWxHpax5FEtKdDbA9Jy7ex6mAe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783947719; c=relaxed/simple;
	bh=vpDVf/b6zHPEUgtVCAl2sRJELM4MLJc6gtP24/up104=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Bxvo42KydDNgzu3xDuL2ShxThK0cfYr5bM0o+SqSN+CMz4yJtVidZU1VEP50XXJ1RcWXAVOJ5VEJyuF6GiALSA86EBkd1cKZssLR791v4SwkNCF8O6rgyzBWVquM7OSdzOrv7adf/9N861mKoZQpXXqV8yTt4qKLFKG1Wd8CuUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mtKQ6aQh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dVZFNWdF; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mtKQ6aQh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dVZFNWdF"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DCE7Ix1210730
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	twry+rQD67k4KXlgASz4DIRuOCwVvltNp8BQTuA56nA=; b=mtKQ6aQhFyuDQE93
	vLS0PLFWn+3ssts+aKobAO4Z3qGaqUVXI5gjuS1xu91JAaK0kAk/MFI1n9gRiUXK
	VZzGPSNz7Bp8q1PLeYXrHFP1zBkaHghZt20UDZxw9SVbih6HTBrYynh9ebRMxzq4
	x7idrnW8SkVIPMMgND2OOJ9L5ZatDG6f1i0qL5BlTCGbRBX68aqkgW7qgO0zmXe1
	exmg4REXsTFM0RWl+20r6ygIGPNOxnnFnAj7bIJimxGs7typmqwCVsb4VRF8/iPS
	4TOkXNTH8GpUVAUlnxv++fl7mtAbYY+u2zDjZ7DLmFdVMOxrhx523pVll9J1dIRf
	6wTqRg==
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fcw4qrteu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 13:01:56 +0000 (GMT)
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6a18bd9c3caso4633790eaf.1
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 06:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783947716; x=1784552516; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=twry+rQD67k4KXlgASz4DIRuOCwVvltNp8BQTuA56nA=;
        b=dVZFNWdF4A1JlGeWpiXaOtiTdGCUNeInmkwmovudvfh4wodJpBuar1rWVS3GVZ0b0Y
         mqoPnmUaBLfXyWPP1OPAvNKUqNypwj5Vf3AWuuYBVTx68FfW7wmURaUTjo13bjNnyrLf
         R8GWvLXcD/aZgTT3Z7X9IOAmLSgcuK+kqEXvdtMVqgk3Hbt1eQqF+plcWnsL9GM0ukcd
         hDaEbTnKzjsTRiSQq1+0A5b6QEzVlV6nxkYNFFgUQphQVsKb9EGYMzyK2GTn1NjLHX3q
         aPXq62j4x+ei3phtojSBlQv3uNpP/ZxM7alNM/CSWkINALnVH8435HLNNplaFH/UFZri
         0mxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783947716; x=1784552516;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=twry+rQD67k4KXlgASz4DIRuOCwVvltNp8BQTuA56nA=;
        b=q2Ef/c99tYvqOq80mGB5mTXPbJHqHJdlnRP/YiIB1GVUYm45T9Tqm/5JuFYvydJS61
         plfkpX5PndVfbfgCC0keIQju3jnh41nv/8VUcMoPeybkCJPxcxNcc7b6kS8rR1IlaBGt
         ZESnEpig1XsUuzk8WQ0a6AevFOzpXrB7b2tWDP01aBX9QN//C30GdcB15lmVGR5VMLvW
         sfOGQxBJhPeJvzJpvxVSA5TUHYVeALwjYYX1jV+hSGaq6CAHEMreLaOnJajgUUL9Jr27
         j1Qscn5LLcgyUEnj7X1BgUbuesFQW+sAmvXNSlZdQjgo3Lsk4fLxBhjQY6nzzTiCrlP2
         n8lg==
X-Forwarded-Encrypted: i=1; AFNElJ9NKVA2+w2LFeCZUq4wuJCxE6UFpogQkDcIQXAU2fKXz8jK6Vt5o0m79hUJAGPPAT5s3mryz67mJIukhlA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMQ/g/TChiFhlk4eDHJ0tIXiYtFDBBn2BuWMO5QGFlqYHBYeLm
	azPPLBQSLvmG+p08BoWMLCIpsUX69cBob6ST7/KWcaEE9OU8ZRO7pPQDlrYmreFjMD7TCQyKzKm
	Jm/knsz7jOoi7PHn9STh9tZqN96JecRuh8V/4dD8dSa2Zpsnfe360noown00W8QI+cfhQGvAi3q
	k=
X-Gm-Gg: AfdE7cmBCoi4f89zNiDkQ7gBkdJAW8IV5gZ+fctI/0JZD4g2xzlK99689RkHpu9Gk8J
	Kmfgb1LJjksBz/Dawa9CmQwTmIFsXRT9LSIqaSx1Khz/IRvJZt98eNSAFEa37Fci0UFKCIoDB6A
	H2iKtYDKKF4CqcCkerUQeyjO+fwh/b/5gRvNcmnaSp2fxEF36Vy5TjFvwP9ZWCGJ9cAP0DrHPnp
	LQjxamf+wtxbejO4j0BHTVe0fPa8rCnQRPwaKEfhJjwDKWxPun8JWZ4dUHY1GnlsMf9M5XOBPQ7
	KqgoE6balwrrZRElXfJBOEkH2hERPJt9iDlKb01gk23a7L71WDKpjE5MM3dlw4dOgHGoWwapahE
	rvkKt+NrbcqmkjtkES2DdA2p3bANu6OsTTDZeuLo/
X-Received: by 2002:a05:6820:4cc1:b0:6a3:916a:1d26 with SMTP id 006d021491bc7-6a39a8561bemr5855910eaf.61.1783947715871;
        Mon, 13 Jul 2026 06:01:55 -0700 (PDT)
X-Received: by 2002:a05:6820:4cc1:b0:6a3:916a:1d26 with SMTP id 006d021491bc7-6a39a8561bemr5855857eaf.61.1783947715189;
        Mon, 13 Jul 2026 06:01:55 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8881:83b8:89fa:1a2a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493f2d97527sm306129725e9.2.2026.07.13.06.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 06:01:52 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 13 Jul 2026 15:01:10 +0200
Subject: [PATCH v21 09/14] crypto: qce - Remove unused ignore_buf
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-qcom-qce-cmd-descr-v21-9-bc2583e18475@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2066;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=j6XY4tGbVrzzivRLNBnBuYRESnCKLFI7yXVP5haQkuk=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqVOGeHIeb8ttU8NMHmfvZe/dnHD8TlSqP+D4CC
 DKyl2r0VFyJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalThngAKCRAFnS7L/zaE
 w3GID/9wtsZ7eG9siySdL9ECGYbUZMDbkEeFrIkn7nhWh+imlHfzg+aps1ekYXqrnnKoNpMAcYj
 s5S+a7t13UfMF0H4ezCA4SmKeySbw4Xza4+KOINoRrCvitkyhrOhRnOFTGtL5OYdsxUi8vBYxfA
 bhOYwwMqCw7xtvs39WG+W+ugZyCQMBrvMOVao1ZTs/QOVw5JdfTK7Enjn6CPI047t7+XtVbdcnR
 AO8b52ajf+00/8XS9y2hWNMhT5hPJq1QjkwjaCBTObA23ROM4Z7cGEXjrn0TNSwFOGdiBaI7voe
 FCJ9VyAiQ3yRc5198Eni4HMzXj5sqx9F5X+ZYs+sd8lJrvAld3W7gZMIZ3TJ9SZ8cpTzqmMqUqv
 pwheSNQn9xKZ2M+opu+1hy7/26q5i+Wk/hNPr8w/gYP29uPGH2/ZCBTwH3mHbK4Auw/w8oHI+aA
 q2aXjx9NPwmqdFBvo7EHkgNDmckjNdXVmbg+pmujnI8AeKsKpVqartHSq2sVSrE4NnFPbjGNlfJ
 GYyJNVtENy8vNNqtCs2rbm1CX4Cp2nNLnd4GPm257Yy/HS1E8BhMfwaVKgbqszK9Zx/smc3DJvT
 pOtMoWNgul11dbGF21pBRIe4dSyZoJ22b64Quq16v7iBe6XsVrKSjj3xPBP9JsDPEYNkrtYJ8vf
 9BPGsifSF6T4yow==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfXyfBMZngQHqqz
 Bq8iXGF5P3pnsGKhVvcOBbVgjEYb5j1ga27Vt61QI8Q/dQLWGk+nbdmAC3PcNA9KGBt2VNlgGjM
 3W3d7Nwrq1srpZ+JXg9YBMvZGN2SU5EAmzZTnvrrxM8CJ9r+GxRRT0k83lsw4QnRllgyfSKrMZX
 JKFoOKOaE7pBeojUqLSQkyqx+7kKF9mJcadpnJjvlNRHDdFePP0qMeK2LRhHgLZZ8MK019ArCqA
 e/rB+MygC9jI+duBuIIXu69xTOzUq2BempQLTzzyywJ3z8zeDAELmHYjsWTswjCpicajQ1IGvyg
 +xb9BPidVLYL313Da5ok2F3BZw3JST3w8UPgII3+ypSDJOVsnyZZEPxfE0ry+IdLLT8Oq2/sE2L
 MYj+F7JKhmAs8XxDg6jhwOCUjFMGpsHQNw1fwLp1DUUD80yAwODlkXymGNEkzt0QkjNmaU/PANZ
 Y56LGGvZ8Emsr2CcP4Q==
X-Authority-Analysis: v=2.4 cv=HJrz0Itv c=1 sm=1 tr=0 ts=6a54e1c4 cx=c_pps
 a=lkkFf9KBb43tY3aOjL++dA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=tWRRbWwrKX-5tUpmLDIA:9 a=QEXdDO2ut3YA:10
 a=k4UEASGLJojhI9HsvVT1:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: EeDoW3u4doxJ2QdprZn59V2RJvchb-d6
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDEzNSBTYWx0ZWRfX78uYvyHTqEuh
 Lh9SxSwIGDOrDisVAEJIxW/3PsmcWpriUwT4DdJjUQ6WT5WFrkdjEXaBy38D0MhLSHLYSfE5Knx
 r73ikJnbn2CVuPUMu8WV4crdr+KupLc=
X-Proofpoint-ORIG-GUID: EeDoW3u4doxJ2QdprZn59V2RJvchb-d6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_03,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607130135

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

