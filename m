Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832DE26CE2B
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 10:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766138920; cv=none; b=F/LqOFmAeNhiMNUsoOdMqkmhLeSeSEiR/S8l00k3HtKxs3rRmmOQ5kr9ifSD7g2+cr1fZdQJa80GsPIjwsUR9CLLQMHa17qhpcFYgx1iuReo8Ji4U1zS8wuRb+PrtOErMANpmFDiia3dCMAo039IL9wEge17eqHDbFcfavAYsRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766138920; c=relaxed/simple;
	bh=6dN4XjHr+6OQnOzxmGwMll0VZH7PW0q5aNlxk1E5+Hg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rIKX0xBRFsuRa2ozzmKRaT5NTRIllOjPEEraZDnTq0NXmoRf8+mCLRr15azUwAOj8ZS02SqsJt1as3FeasrBkdkZuQ4AuSYsRG70LKr113wrhw074HiLpycscLo8MpLyFXOjkJUJT/XUqcNMmUQ/4tzVYH/FkBPXOV4FTWsHDeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=n5fqXN0B; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VBmrq6KK; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="n5fqXN0B";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VBmrq6KK"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BJ4cnZd4155417
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 10:08:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9iGVNuTYeeAltbq14HNN1Bd2g5XTMHQ/MFj6N7hyZ8I=; b=n5fqXN0Bv1w+8CH0
	/TZ9HkqZFss7Hx+yvZ+KsSGXvs/aHLNvPt3++hLfdXNAz48ZTDGjn8PmdRIBYHVb
	b0IkYSx41HEH3I7DkzPodrPATqntLM3uZEmhwYEjcCU9jgZ8SJpVZ7VYDKUY6rll
	5KidemAgIRLq6nZJREjPG18Tg9jD8gWQ14LLP4PusBkKr7x+wRiowIGDIKPT5Qx5
	8KMHGb3MRF5czPTeCJSdWQeDJK8ZpRBoKDpibS5y+ppqmbq0Mb2GiuHJvEbr0MfM
	HyT02UPj75GqzsG7mDLsXa7Juewyo/R18JEDYTFTZZeuOPTO1eVFWxHHAlgM3wSB
	1WvvaA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4b4r2ct9ej-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 10:08:36 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4f4ab58098eso19695851cf.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 02:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1766138915; x=1766743715; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9iGVNuTYeeAltbq14HNN1Bd2g5XTMHQ/MFj6N7hyZ8I=;
        b=VBmrq6KKNxm62b1tuNzd/83a9KO19Jxd7bhjI9qS8Yk/gJbL45W+XQ3PNuCYyX1AK4
         YUODTzvIqYaNdAwVy+SWpHWYX7PuBkv/wo/fs3i9ywDfU7sfpqqwRPsh4bBr3ZTAdNhD
         qrVl2VdveE3Zxyu8EaAG/e18kby7vRzp/WxdK05Rh3a0PxMJ8DPXEg5Bg1GwqZrQHs6U
         h9JQW75+dUy/0ZiqMWooMN0NR0uSjsVoMu0F+7TgdbKU7qnRu50mxLo3KshtuX1Ce68/
         gh1E3tE2ax2khAopOh9pOdfrib7/VhhuNCz6VrOfiqE8bDRoRtq6atn4CFGiAyzR7+21
         fPhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766138915; x=1766743715;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9iGVNuTYeeAltbq14HNN1Bd2g5XTMHQ/MFj6N7hyZ8I=;
        b=DBgOtRPia4uZbaN8Hv5+iXhz2rwV3hClsmO+Yx31+ehXphUmrfNgzuY4oN8HkI3Yko
         QDFJ3UJOTTbjKRwEtOXRBDXgQkyauiDskkeoulm9T6wSEJ91/qyGRu9hjcUjbrtvRpao
         o4i8dHUv7vg1fsLoGr52L9K8CCnmD7Xl79PAoVfOTSLfKmWy1+naK4VTUCA/iINOQbg7
         pdBjygL5OgctmAVkd1kbcqtIEArRiY8gqeMidEHzerQUpyrXYhafGouj5+8iTWl6pU+R
         cFQCveaWg4nXV/zeGjThzKBKEqSJlKovJH+hn3o6rZXyzC7rsiATessVqV4Q5nB8pD43
         j05g==
X-Forwarded-Encrypted: i=1; AJvYcCWdCFuSiYRRGH/ka3vNUinywAzlTXT63TDrNryGYWaQqOh0LdiCTnPQ78FKdyHYgwut95AyHV6UZR1FwIs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEBsazR/5gYifCzRc2lQajEs315XAbaayDJublTAmjjZgL0bti
	0pDBjQOejoH7snNG44Mm4Fc74QPktw4iPbPdga/tXSMerDMD44o/Yv3s9rwu6vHUeM44b/4o1VH
	1nLEpTwvsl98z5O/YRsbmZaTJuVHgPhoh5p8OvxraWeCYh03pKYG445Mf63aYWCqcnyM=
X-Gm-Gg: AY/fxX4hpRLb44aPnTEKq6faZgBzADqwtkjK38NdLdcceGt1SereiGuhFdxftn2px9I
	hlL/7Sy8AhKtC0PYk7SbMOkC9d5L4jJt5GAyEZjB0oAfZ3zbiHi8fcowuxGtVwq2DSrZu7RVzsf
	c6Qz+CJYm7YHKsEcTbAeISbbRY6XdG48DdPBEVatXo0w3oB0yWUVIgk796LH8VjNOGnFnSPVKh8
	iFyq7dJX81hMOt9J0TQk1IDw35kARgrXA6rxZeutwJDaB26Ow25kcLF+74y4EC4HiojC40OUMyf
	/1iC7A6MFj92U9ovJ7rRbR20bIKeNqSKLl+w55DZ2fVpiith5mywxx4fQa2KsituNskvLB74zQE
	SmjmzwbcxYhisERcRblW1o0Yfl2wpdpAOciquOA==
X-Received: by 2002:a05:622a:28f:b0:4ee:1ff0:3799 with SMTP id d75a77b69052e-4f4abd74a55mr29641251cf.44.1766138915317;
        Fri, 19 Dec 2025 02:08:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFz4giQwH5X7LuypWLo9U1+fJMoHQI0FlkCPgyAR+B+nIDT3LsZmrmPqVD87xFUXXNPvdXU/Q==
X-Received: by 2002:a05:622a:28f:b0:4ee:1ff0:3799 with SMTP id d75a77b69052e-4f4abd74a55mr29640941cf.44.1766138914836;
        Fri, 19 Dec 2025 02:08:34 -0800 (PST)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:a48:678b:dad2:b2eb])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea82f6asm4209571f8f.27.2025.12.19.02.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 02:08:34 -0800 (PST)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 19 Dec 2025 11:07:45 +0100
Subject: [PATCH v10 06/12] crypto: qce - Remove unused ignore_buf
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-qcom-qce-cmd-descr-v10-6-ff7e4bf7dad4@oss.qualcomm.com>
References: <20251219-qcom-qce-cmd-descr-v10-0-ff7e4bf7dad4@oss.qualcomm.com>
In-Reply-To: <20251219-qcom-qce-cmd-descr-v10-0-ff7e4bf7dad4@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Michal Simek <michal.simek@amd.com>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2012;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=DfH5Bb+Cx5AadRW9+jaH1GcMtyO0VLpMWlVREcJBr7o=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpRSQTefcv4cYMI1ZoHjt400fLY9Litr6ZG59Dj
 KtoJRtN6nyJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaUUkEwAKCRAFnS7L/zaE
 w7DzEACtc8xd+jyPZoQLMG6DPKT8itC99zs9zfVE3otqbuwsbLdmoFn6MqnzRMuHHe90IBhRJmU
 SY/l7zOg5MDp8BLANHlBm9fqc9xmcqg61MTrzKpM7nYYMJ710O48FZqCl9IDYOhIvETcDh+uqXc
 8oaFJ36UpnKHSoLaigiTalvVx15tY0eZFZc1XGV7O29DQ0gxkVEdl2kjfJBn2PdngFwVINmgJtw
 hMKhhj1reGzd3JaPZbQDjSnFh7mKKKZyP91JnfgXX+vapLLLQDFelirHCPuk4xK023yJkowrz13
 IbItlUbrupdp539e4nSfREzOJonDADg/NiIEwKAcp6dBOubSyviUnfKG6jQ67wguSHDtpW3wpN6
 i+OwT4XyRHAbViqW8isUIo+3mtIxqJnagIuiGWGnWvX/RbLDK2RP1qZop2sTyuY2CJeCyIpPoUi
 5kGt5L5pNb5Q9nSxq9XgZNNmu66T0RK4UpZ0wHS/SHlovNUy+v5muKAHw07Oh6j0RH/fsGHpz8w
 sQLoP+iAZiS6szgaCgTqE9RfvMe/n9W46ZJ84KA3HRzNpilp9zRxIkAyAh3L1w65HyUOdibwWXd
 AUmOIZlJQgL48vmGdtAvxN/HKzwaynU5XNMdb59kXzZ7/RkJSPFeiUXucFHbdnW2Zt4Vx6fPvfs
 t0q5Mk5/jOZHQ+Q==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: qdqrA9D1WtfCZxstvnFse1iQRHXlXIE0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE5MDA4MyBTYWx0ZWRfXyHNbGGcX00t8
 RurUy22+C62Xt+LG+njZO3OAOhaNNWx6Joq1ERNATmwJHh1Ro3Y7ZQwVSvICqZlrGU4ENEcCS71
 G16CrVsQOTg/xld/0SjchSMYmJQa3ApE4Ww9wDlypPRFIqPlrLsToV3hqyflvJv6gac+ziGbUI2
 vs0dk6LQ/2nANe7ncbpgtDaTwDCansNU50chi+daL1suHbsOHOfVQ9Af7ubhkMGLtYJxRaKPYlI
 bmIP8rnT5CTBXjNjlBT0UxR9C1xrT0vPwiQYZnNEOSpsXsvc+BSeBFK5S5DXX7pZMWlU6bF5aBi
 TvEC06eK+PGrMzdE1s8fVtjDQW1YG+a92fm5ZDo8tDZ0XkhB8tmhgr+ObL3fHkuEvL6y6LYNMx9
 OZOiioj1vyJj2fSc6xxTQbvOQF1f0a0utRAi1x4hjgDgnIf6wPBBLZ3hEoCrOZsZG0mPRWv2uN6
 YAA9DtP+kOkyRzwDosg==
X-Proofpoint-ORIG-GUID: qdqrA9D1WtfCZxstvnFse1iQRHXlXIE0
X-Authority-Analysis: v=2.4 cv=Lp2fC3dc c=1 sm=1 tr=0 ts=69452424 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=tWRRbWwrKX-5tUpmLDIA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-19_03,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 adultscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512190083

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

