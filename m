Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AC03A1699
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 15:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773157502; cv=none; b=d2UmxwyyNNlmshwlwDTRJ/3aRdjpky7l5K7QXgikVyHNrQN7yFyLBWZ0Jxe1S89mkf6Kchn9jV9EiPp1Pjn5Oh/R/qusmq6eFTC9jgv+PKKVqLefqyDgtCZmmn0gcSVbfgvA+GndV5Ut1uxr6q8xsbbprOs8yLqKrFrWPP3cbxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773157502; c=relaxed/simple;
	bh=6dN4XjHr+6OQnOzxmGwMll0VZH7PW0q5aNlxk1E5+Hg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jR56NVefWNWqFYlUYwQysmC7jASMC3CUnjh9+jZ9ULGS63Lpi7flC6S7t4qq7wGOOajGT0f4JT5nojOHbN0lhmt9lkbnbvsOPmGf3EipdRFLUQeywggbx95Mkh+r2BpRwtxgQSAsmeHFDfPLms4PhO3DJg57bfmnD0xDPElPOMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=P1/Grsya; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cT0iw+u3; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="P1/Grsya";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cT0iw+u3"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62ACaTK73417107
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 15:44:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9iGVNuTYeeAltbq14HNN1Bd2g5XTMHQ/MFj6N7hyZ8I=; b=P1/GrsyaIA2oSetH
	qyeav9DFW2XVlmvlGqPfQIv+eWCC43lgxBPSd/gqGr69BOQvm0QgM9MipdPFDVq6
	I18t0iy80eSWl7F7kIW8CK9lW0zZRh1+6QbkViBqou7V6BVLBCV8qp3VzBhKB0Ud
	j+Q+qDDbWmNKq8mukpI7x9BCcx8J4gR3n+3O4nAG9ciRywZUW7FkdjzyV3qpLirG
	lyM9VHhcjH86rOV2TgyNVymX95CiMXng6JiMG4EgDTa0d3qp2L9c/4QFndzIyV1Z
	b890QdBIgn8Z0WCvXfCh0lnF3XyQ6T0dGELQFR6N4pkTfikGYDxEaC3RmLOgSAx9
	0lDLNw==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctja290jv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 15:44:59 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8cd80c4965aso2016185a.1
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 08:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773157499; x=1773762299; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9iGVNuTYeeAltbq14HNN1Bd2g5XTMHQ/MFj6N7hyZ8I=;
        b=cT0iw+u3d25XErAChj7lkf4Gpfqhj85Fbx5fu15VzBhfKpDQJ472BV/nEnpkH4UqY8
         CC6XF/s0r1hhs5W1dJ/FyLXwnovaqsnADpYYjZyb4j3NKf2vMN5X8XkA/goyF8gHRs53
         Lohauk1A4U9ggXlL2XzRDbGwNf1VBmlfqG+c8kSlEiOo+28IaUlANKkOhsxfo3yaaxjE
         wAXzwyFrHw26l9Yme5VYC2twcJ/1z611KwBleODeS6HRl2gOFWj7X9qWclpVgnyh/Lq8
         INvKXPsctonXzKSGkXcETpFAXR/8ZCNoSZwVYypHfAcvxRHhgy3Ygt+f1np9kxH25odS
         Y7BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773157499; x=1773762299;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9iGVNuTYeeAltbq14HNN1Bd2g5XTMHQ/MFj6N7hyZ8I=;
        b=utYEZ5l5JuyrvBU6pqDJuT/0tT1mDlpa1WPPY2W23ihLtmU0jEPP5nUesiVTtqbwfm
         6mKA8V4G1E2v835tmDGK/HFgN8kNA6iMbpP6xMEbTRfrKRAyUx1YjanDNDTDwGhgHzNw
         z6y0KX1AMWj7dANgu9CyR4GdaKY5U0viN+JdumpU8/JqB1xLju3RiBlsZI3ms00L+LYp
         FfEy2grY3zwi9m/wn4vBDe6gqxmXh1zGSZ5vgxTr8FBEWs8EkL4n1rPlzQA7ExXMDn54
         9nko2ftQpK9gd5uHvewlZ1DDzuxGo8GewSN9azg1Cw2a3Hq+3twFnIMH76nstEFGl4gV
         twQA==
X-Forwarded-Encrypted: i=1; AJvYcCXV7sjnrk4BE4T6Ti8B1k5luRIERUHm6DRVuoEHxAyIwf332PwZKTR6TUJ4dnC5Q44U11a2J7Mb/E7W2us=@vger.kernel.org
X-Gm-Message-State: AOJu0YxM7ng3OKtTSidaixRLF8dOPirqGQpMm2N1jtBejsSJxmU6Tcu6
	5P/wdWfph9YVYcKEkdQqC1VpyhNMhlZMjS0FnVd4wV3YGNrdj0uzIh3kIBpV/K/zTQh1KLGeFsD
	zlICF/+IgXQG/s+lH2xDFhrCuBYec/YTIZyRjL93JJYWET7J0Gq3JelGUJw5fic1ZVXs=
X-Gm-Gg: ATEYQzzybrYhDLRaVZwJIyOZUm+PsykFQsqNQd0AV5VwOSFhA+X7aXLt/HS7L5RvJ7i
	423yIXdYCAwURoh2G/wRd5oXtHabWtH/XgfKT/y/RbFsQa1Ytix3Cbj9cPXAqEo8kG27jnq5BYf
	nD/7gVOxD4eXdgLeEH15jDb5TiKNF9VSwklLlgxtVinsvCb7uvlzDsgvfToACzuK0BGZ43RL+y2
	kjYW+V8mBKTS5qYOdH5yY09YVsJ9s1aik8g+BZDYTz+1octkKnYQPUBpxX/5kzMukosXFF649Ao
	FHHzV9d+W6KUAApTQt/P7HdSCtYewltTMuN+0dGZqtYmdVpTKezTU0l6pHzDwiB3ZsvGcyutALx
	W8lPcrm+JCFVkn2zHC9sehx+CCrOpNKQUn3Ap01BGkLrmYs9wrw2Y
X-Received: by 2002:a05:620a:4142:b0:8cd:87f2:1cf with SMTP id af79cd13be357-8cd93becd02mr444892685a.20.1773157499059;
        Tue, 10 Mar 2026 08:44:59 -0700 (PDT)
X-Received: by 2002:a05:620a:4142:b0:8cd:87f2:1cf with SMTP id af79cd13be357-8cd93becd02mr444889585a.20.1773157498559;
        Tue, 10 Mar 2026 08:44:58 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:47e6:5a62:7ef7:9a28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dad8d968sm35991600f8f.6.2026.03.10.08.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 08:44:57 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 16:44:21 +0100
Subject: [PATCH v12 07/12] crypto: qce - Remove unused ignore_buf
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-qcom-qce-cmd-descr-v12-7-398f37f26ef0@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2012;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=DfH5Bb+Cx5AadRW9+jaH1GcMtyO0VLpMWlVREcJBr7o=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpsDxm7NNbkl7dnR5eoGZNBh/IFZgrDD/Cz7G1i
 Nuf0N+OiJ+JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCabA8ZgAKCRAFnS7L/zaE
 w8NNEACAbBKH2NWwSM1Mz+lOJfH83qaOWjprWgrcCwR5/JGaCQnrFvy63IiH9Cp9njz9bbvb3sX
 KIqKY13S3Lcnsab4bNU5UL1h3uKpBh/++69VsiUGdjNACk8Jp7wz0FigRoaYBqtMkjxeFlo3bRM
 LT6uFjE4NQhW6mCDI6fC7ZxdwayrLrNEGgpFmccQNIj96aOxtJ1Mql631jGWJhqUoVOUoVy/M/P
 lkmCKZyW6xeFME1xZ05QSe+neR/2FTEwdCa6/lv1IHrC5Ufi+Xq6XBtdeAwBraIXrf9TXNNnPBN
 er8sj/RHTaePjHJAAzKRHBrzWxGemSnr+zVRNE4hMhoNYeTvn9LvfoOBUSuGNVpR3CpDJBdkwZW
 nrSzkkfxc1Xe7+xX6ovsPtT3gHyRdiM64YzOrOIkZiAGkfMoBbmPpdD2Te6mqyLLex+rTI9Ww5B
 0LRhSROfBlHDIJ9D6OpJAjBoPOWdhe31wX86PZ+2zYSr6u9brW0pTR6lLt6OYhoBJr7bzql6t6i
 wSiDT9l3m47j/pfJGSDyCITTycql7iBtXEuaz7z2aql9Be09aoGF8ulhlt9kwNyamfQ2d/+g2ML
 305/3e6tCVFrRUIMZTNP5dOm6jw7DUQyB0fFPy24HtpSzBpKO6DRzHXSUOngL5uP3+GwxkVwYKi
 +axkBwuOz5l3ySA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=c9WmgB9l c=1 sm=1 tr=0 ts=69b03c7b cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=KKAkSRfTAAAA:8
 a=EUspDBNiAAAA:8 a=tWRRbWwrKX-5tUpmLDIA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: ByxBD_RTrC_pVphfxhQUmLvKw5VXcOaX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEzNyBTYWx0ZWRfX8mB5eWkm9h+6
 mMSMBY7+VtsTjxwLw+62sIuf3QRx+98rfJ/rVqHN4lNdM7SMsB2CrrywmRWxvUaGB00g4QCU+3K
 8G8xz/fi6onHVD99dDEvl6H69PH9SWMvRxsvdb+K5z40s1LMSZQy2ztMKK+fbWX2E9NSABtz7hM
 q73PPGjda8PdgFYAgrruFZgWyNe8ws9qyypv9ta7eAJ0hcJimdbo5ABPV9oF1tlHZSQjglk0EDu
 koJv0Q8UIdGy4ZSLB/pX3F2a1tSIUkBsNK9cY6SuYzeZUGwIvUntey7GOt7Y7RZ/KGJ9yNloItn
 KMNjFLDMvkgAnCppcTI29MgrTw399rvhLskcDmgLXH7JBdWDkXM5w/oqIqUdUUNG0xVDCrz+X5+
 x62gcA/U9xPOc+wJu/uDN1mu4w0+DlI7Pi4OzGTXUSrOfyJMzSxc21h+e0sqVcZfLle43yDebgw
 YTWy98WXnASHNsnsxFA==
X-Proofpoint-GUID: ByxBD_RTrC_pVphfxhQUmLvKw5VXcOaX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_03,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 clxscore=1015 impostorscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100137

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

