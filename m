Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F924963DA
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784826607; cv=none; b=HaGBM6mDx4fyLeU7YN8o39mLIOYDakmgVi5l5H23XZe9+dyu4RWW55D5O5Xg6QRTh43WxVpLEVXLzKsxG4ZKs0jVA9XZbPE18yv7LK0DuIBEYaknsBW3cbtUzV+iVgwpi1F1K0SwetXch/paj0tKBxtFyyiezd3pAdl9L5uPoag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784826607; c=relaxed/simple;
	bh=vpDVf/b6zHPEUgtVCAl2sRJELM4MLJc6gtP24/up104=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=c4sZKGiXytj8IaIrofOG3s63h1DBGKwcs0TK+2cRPVAqstR71NYPSBYWnbfJZEXTLPb3BKlixqX/qvswOManL3+gtf7yboAcnAa50/XPcKU+ejJJ0CxFj9pUg9PT4Yf3h28SdyKb83uhllIOR6HmjCQqYaZdjQ3HcN93US+WX/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LGSaZwYT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=izFg3kvZ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LGSaZwYT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="izFg3kvZ"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NCvoW2011801
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:10:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	twry+rQD67k4KXlgASz4DIRuOCwVvltNp8BQTuA56nA=; b=LGSaZwYTvZGwccVl
	pA0EWYh/eZK/4U2qPMKc6ObiY15z7/WdN9Qa0Zt2fIihfTQGV+Sk+vXGXodVtOaW
	dH/4TX+mbplfE6yEwzc73/mGn9ljwcVfH9ri7IoFRETbBhEMQ5r/rwGv9GuftWMx
	PV/QXPbTfVgucEfJoXbLRWD2ptWm4MzL6MjJJ53msaQMhcW7F56RTFx9Z61hvGCY
	Pu5t3iZBUb+fAf2JC61QWLBtVs85ahXiA9BdpbId0zadKuIHJ67l6XZyouEe1V00
	fmKGyJ6MtE4kuOPqBe+rh47j9/uvFw2t+Uhur68zwKFa+FPl1d9XeDsM4RlWL8zy
	U2OsoA==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fkayhbcu2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 17:09:59 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51c21c01cf3so14422771cf.2
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 10:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784826599; x=1785431399; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=twry+rQD67k4KXlgASz4DIRuOCwVvltNp8BQTuA56nA=;
        b=izFg3kvZlNj8mj0TgPaNJIIP44cWibX3S0fdi2pinps4HqgKhGzN2BNTeheSUMalVe
         tw3/B52qIZRMuCp2AhjekXpsak8XXJ0lKazyAN+WIkF3Uc/kLQM8lFTlYXE3GUH8RufR
         bxsoE+KMWs3baBmldd1tS8EaGrULQn01+Ez0hJS3/AeyFOscUyjOwr7Kiv0y8XVLup4E
         osjhOKTYLV3Zm5Qrjhb5O9KAqeYHCMjcHB90+uKI2E7PKbq8GFg49R07NbONY89PLlmL
         7uRehcwSPTekPnnHYy7HYQPPP54xLdWaaGJ4QF8emY8Vf8ifwW25XmvKP7ySHh6zTPZn
         r2WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784826599; x=1785431399;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=twry+rQD67k4KXlgASz4DIRuOCwVvltNp8BQTuA56nA=;
        b=DAn3KJl++4ttVGsBHp855/5tkkZsiUmuCc2o0syxtenKcR31ZCJwRnmYC3iMyLDo6N
         4D8m1tbvI/57x/6NSoHtRBXkN1P/BYpQPBBq3P3wkzOVjCu/MvhKzcfCgYsn++LrenEK
         GGhyoyOYHQg4+uPoY9tTmwi2AAhTFghf7JE7RC+OXrn27Vkrh4O80OfgBv/QqLTubquW
         Icpi1jcUXdkBgNLPuVZcEvOC0flN7uZCQnx1F5kUuLyz6ZDk9o11p70vO6SsYTfPQcWF
         eYYbqezwRDKSLF0Uu9AFhD662VEGry3RKevj1TRb99is+fTJV9rq0YCCRZNTJ4SKw0As
         ptmw==
X-Forwarded-Encrypted: i=1; AHgh+Rpc1I+KLMAMuHFsoe2KaaDdrGvT8cGZGULzdrDnRqhL1CIYbk26JY61mIj1LvHhhIkDBb4C9ePQzYpn30Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+BNZlusdxhmQV69CDool/M/5FVz1azEEJDoFOxDNCtUur0oi3
	digDmtRWoM1TPoxOUBHigZO2/qAuRzUOAMQU/6mUwxlj3kFnlkGdDife9YMJS4ofg1mydSYco/T
	3LDpHFt2/xQh40LHVX+8I1SqTuBIRMbMhx2v6R6IjG755TEMou7otb5Eh/thfC4a8fok=
X-Gm-Gg: AR+sD1086u2K4pDDTpUpZIfdksyBv6RO4WXWdhS0ohVcYR/FZOJKmHaURNqUTo8vij6
	NZDp32JdmFRqx4nv4B2FTCXqiPgwBt5sJSNjI6FsnlWI1feEf/MUq8U3TMy6/htoYqgNyaSunSq
	NqpU2bIry6Vg6AXbxhOQwekhHChFS3Y1NZ3C7SAdBFynpvFfqnCgr+s1Zem1YJih2AdSchT7vmL
	ZGphZifHYDR8C+KkFyRsW0UjM8XR+sNi2oBy5r9MgwDtZh8RSyDm8kbuhok7RLdQwdZnQHY2kL+
	AtjvgJi//TfGFSXWlJvt+FDuyeGQTRuTFS1EgBVTlHsHaBgSC2zuak3Uy80TVWxvOsrXCud2Kbr
	W9cEwjFPNJolGEftoyUdDlAsi+AeJ
X-Received: by 2002:a05:622a:4887:b0:527:6d0b:b00c with SMTP id d75a77b69052e-5283dfd07a9mr37944101cf.68.1784826599204;
        Thu, 23 Jul 2026 10:09:59 -0700 (PDT)
X-Received: by 2002:a05:622a:4887:b0:527:6d0b:b00c with SMTP id d75a77b69052e-5283dfd07a9mr37943611cf.68.1784826598688;
        Thu, 23 Jul 2026 10:09:58 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:cd9c:212:1357:7832])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a64dsm18472999f8f.1.2026.07.23.10.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 10:09:57 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 19:09:15 +0200
Subject: [PATCH v24 09/14] crypto: qce - Remove unused ignore_buf
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-qcom-qce-cmd-descr-v24-9-4f87bb4d9938@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2066;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=j6XY4tGbVrzzivRLNBnBuYRESnCKLFI7yXVP5haQkuk=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqYkrHRC31uqWfuPCshkpr4F9yhF00Q8kTZX6rw
 dse+wx0PiSJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCamJKxwAKCRAFnS7L/zaE
 w/U3D/4l/JZB1CI1zLQeeEPcdQ6oFcKCNVWSMVFUFdkhJ9BkrcxnGZuhnMpJwO4vO+Oj6Yhmb/h
 ZoKCPuJ1X0o3xdGe6tpfEIzROywogHcp2+tQcqYhyCwTg7WZAcGzxoR0LftUJ9KvGYq9QdqctNc
 lSFZbf65kdE2Tc02wAU/H+pC7yUQU76utOnkqbgTIHQtBA26Tpy8SDY2jAHTcqM6RUDQS/QZOE2
 uYL6JpIio9+5No8/xj/sIFfBWrZTD9y1gSq027YSHsL78J4qPTu9UpiVhcgX5p4R0cIB7cukMoO
 6HTz2lNB8WtWCCmp8ZGwCW/17HnhWGzniHiXH6GyrVOQSsLNFV+Ska6P7uo4vilXjNcYfM70IyW
 0IcDc45D5hsjGPbcRaRykn6DYvvomb7lzqPYxxwwj/5LqQIkcVI9c8Tm/idGAf029Cwq2zKMd6X
 yGyPL++zMP7shdIb6qer47c817fmdblEWodhtGQl1taZMKPTYA0N9McR0wbJHiNif8QSwy/eauR
 GhIMYkKSCIAzCinSVVcK+VR/pQ/2hHQQADI5icvIrRVwJX/zBRs5UUwqphuPB26sxEpab+svSq6
 1tRdkQ+B0BpxsfWz1r7YLY5YrwBYQXmF47ceIy29rd+FOOQwPz8X+u+hiypJ2UTXH73pm19LuYl
 DDKG/6N7DZoUbYw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=HZgkiCE8 c=1 sm=1 tr=0 ts=6a624ae7 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=KKAkSRfTAAAA:8
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=tWRRbWwrKX-5tUpmLDIA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: tzeI7gL_zCVcYSP7mNWQVNYxxx38EsM_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDE2NyBTYWx0ZWRfX2V99HW2s4pat
 Ot1NLZJxCs+EjjSk09F0YV2/70mED5TQLMIKT/9J/NMtKsngRw9amwRGHPJ9XRbshwRU7rC4htU
 AMSicJL36SKrWWqv0ZcyqbJgCouTPbYbwyQrYO4WD9i1y2H08ANfT1k2IApLPtFaaMEOTjWkz/9
 H2jrmf4zH3OgLLvHbuAjYzqtcvuN4ItNIUkPP3u15RKEhIs3qrgQihflY6AZlSIx+icW9PF3+KD
 kkEapGqThTvTnVXZJ+0W55qV/1h58F0F+Mz21h6rKrC5Yg3jJU6sf7IdqOPkZAE30KQfl5w0Usz
 kiFQucWgkj4J2+C7gSE1RGR+VRvNEVznu11Q08LQfgNWXo0F4YVVgv27Chy/D+g2uSy3kp4Loe8
 DTLmikjJJ9dqWx3ArGlqPWv4v0Y1mRmcmadaMQxhSVc0llKXldCs3tpXtOmByI8/1kTTyk+uyoS
 xY5r2EE95K8kl6mzdWw==
X-Proofpoint-GUID: tzeI7gL_zCVcYSP7mNWQVNYxxx38EsM_
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDE2NyBTYWx0ZWRfXy8+w+m3BK/t0
 +HBqaNqV48Ec8g/7kOaaxfPP3QWTxviCPmh0s1h3IGcNlvIkn20C2Dzqxwri3cWRim+4O1ZIOM9
 ly/wZlnFqQ9M9V7GaKq+K21vzO3mZMY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_04,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607230167

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

