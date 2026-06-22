Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0A73B38B7
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 13:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782134317; cv=none; b=KmU6gjTbXbF0ta61hLxZ/EwiNf1S8/gNFLgPyi+wnwE1p2GQ1HwRUYBG7E/ng2bnH5vuI4dlC105Vm9GxeDWQysZqlMo81F8six0oEz98dNBMNuqcs5LSmnCQFwSvyvjskgg4nZt8Bk6+Z4uiZzGpsO/Xtemm+/P+8Ia8A8l+5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782134317; c=relaxed/simple;
	bh=9/13CghT8FUQYhvJkIMfRdaeEEFUpDm37ejb6o7zYGk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CsyfDUjye2omBIKZ23ax2J8oSaQhatb+45qgfVDSpXX7/tW7A0WxYjLKnemwhAJfeMbNJatyxphViFJG1gZu6krz3ZJ9/LQ8USaVclXfs0q0PMdN4WTAvZTFj/Ce+ucwaJQK2yHPqkleXidXwzTXtS6Pk/vGeitZa7BGpQbzxms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IPb+uo6G; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GfPrICT+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IPb+uo6G";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GfPrICT+"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65MDG5lX1283496
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 13:18:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fnoPkC2GxOfpsWV0NzbQHKvX8CiuSzxebCt7oRE9BIM=; b=IPb+uo6GI16w99hQ
	fHW2TrtLjKX/fVWztx57XD6gdstVZ7ZXWfBzJRquyCv/s+sdvUdSLu9vc//4v88p
	ouA1uPEwxL9dHLab7/b7ArzDV9n1efs92GUPGvH6RK/V9xPnzIelcDpodqzJ/d8H
	vtdsbM7+S6nvH7tYQbngXVyrdmYVebm5lvtRpecxMKMsPotpQuKHyr7QEEL7Wr4/
	M8Mc2uOXLB0/ijLRjBlEFf4cA02thJm8xlEtjAoQCSB1AALO05uJnNjfrQ+a9ex1
	l89jDr/LZPMSwOI8ckdXaEBvULADKV1l/bsirHC1H9IAnBJfdHAobo4gojBT8ZAN
	pDkzmQ==
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com [209.85.222.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ey5n401au-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 13:18:34 +0000 (GMT)
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-966e0176258so2096658241.0
        for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 06:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782134314; x=1782739114; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fnoPkC2GxOfpsWV0NzbQHKvX8CiuSzxebCt7oRE9BIM=;
        b=GfPrICT+D40VMU2mN3vb26p4qryVU6QHN+byPTb+XSZMg/l/I2/nr9hjqWhbAa2pz9
         yFAv6YuVRmSpTiedfWxTYq8/nsYcPSvIZPO94pp0K7iHIZlPJbM/hj4y8lAQ+ZE5A67v
         IXuS3QUo1YscgpynZG0w8+Cd9Fe7ed8EJViyU1sSZZwk8IzvyrHPfr0wWBkg7tlCORW9
         z4NpwVl3STx48ysOzx1mCGBTX/VJLsezJQVIYxI1FUQt8H2IMDtNIkhdoaBMDBcJqWJl
         MtYUfh6SI7LWlGltYKMzOQncXIIPknm32emuooHVIHG7shDEZ2uoHKuNfp4NeB5G08JH
         x74A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782134314; x=1782739114;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fnoPkC2GxOfpsWV0NzbQHKvX8CiuSzxebCt7oRE9BIM=;
        b=Hd8nU6bpAkn/6QvcMXsExhsPHAaFqWn9bWxyab7zoPqFXuoPz/9fKqqRO3v8ys/irW
         2WwZud2XPQFfIhaQBjVUdRfxyAi+xFD6MjGnhjfNy4Zubo5oQo9KedDOl+qMhFntltSF
         ROsDZYs9IodreGUOlZgdA1JOt8JoKYjd0zrMttdsui8baesvWWodrnsz8jGk92n4ib2B
         X9NBj57zboWpwMRGfwAC1j/t3uqWfRlAWbqwLrqZgD/Z3HplR57BHoglikA+1JiGhJ4M
         YrTcAi3Dqu9IFbEKhAUK4pZs66AHPj+aqE/SWTcDE7BgGIEoOMA6gcahvKs6QdDb3GKg
         HZ6g==
X-Gm-Message-State: AOJu0YyCc3P+lQZcoCeTzZGHZO6wbsDaWmKb1Wwp7w7H8piLclQz7Q0i
	XktoBxlqSOZG9AfAcoxxYbFZ8H09aBVyx7nMsxfX5r1sRe3GKKo0F9wwVdpYIcJgFb+E4prayoq
	pKvvf4jHoelNKFLwF/AJtD6sMb0HgU7dHemT4uXKGc7gLcrbuidwl8sLt6PCXhCQvv4c=
X-Gm-Gg: AfdE7cnw6lN1VqfM2Rxqt8ZSrC7TrMhvrmNVqqleibnGzcXCDO2dPEmMEJ3o61z6PIT
	B+iXnqU3AKYLL75UsA3NjFCzWJuZGwmNCZ0uV9Em1Ov9kJFBeVzmpDSrBS3PwVx2P0feKRHqCTa
	RKqXSOkIsBbZbjpLCV+Oyb87bI3X7Qy4gSlxoS5FvzZbo1XrAE5/92o4YEGpKfl+Txpj4t+ZCMZ
	kFGVxrESPMMY5nND9kOXFGY8oi0HK3BqOD2tKiNaS91uy0bXrnzsnclY92yZ5TS/cRNO8TuCDDt
	iNQwwba+jVJ0/MFa6mQI7v3tOvQyzbqBpkUY/K6qM46AUI5xOU9sI86neVXtczFtaSS1/KPhhFT
	mE5OfyL9pnH0lsFvSNffraZFmulsvQ0BEIt7Zt8nx
X-Received: by 2002:a05:6102:1622:b0:728:4383:c831 with SMTP id ada2fe7eead31-72a1d634920mr6736251137.10.1782134313873;
        Mon, 22 Jun 2026 06:18:33 -0700 (PDT)
X-Received: by 2002:a05:6102:1622:b0:728:4383:c831 with SMTP id ada2fe7eead31-72a1d634920mr6736221137.10.1782134313271;
        Mon, 22 Jun 2026 06:18:33 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:dea2:c31b:2872:1bd1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fd30078sm294083835e9.7.2026.06.22.06.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 06:18:32 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 22 Jun 2026 15:18:10 +0200
Subject: [PATCH v4 2/8] crypto: qce - Fix HMAC self-test failures for empty
 messages
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260622-qce-fix-self-tests-v4-2-4f82ffa716c6@oss.qualcomm.com>
References: <20260622-qce-fix-self-tests-v4-0-4f82ffa716c6@oss.qualcomm.com>
In-Reply-To: <20260622-qce-fix-self-tests-v4-0-4f82ffa716c6@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        stable@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5679;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=9/13CghT8FUQYhvJkIMfRdaeEEFUpDm37ejb6o7zYGk=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqOTYcrgYNNRo2vnWpL+O5zYRoZ21faltuUsACO
 K6MsYd8vyCJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCajk2HAAKCRAFnS7L/zaE
 w5+GEACKCvApmJGwQG9zedV5phOxVMmVgoa4r0sqeSooXr1rmXObQTno+ME6/E4VMxUnz+FjR1L
 aO1qgcgOc56gd/i89/sJbiuSlB3InVdt76JOJKSFHdzoXPyXGStiH+9pr8jhbHX6j+i8KBl6GYB
 rT/Yi7zC3dsktyC5J5yiEIVUmF9Jrunqp585s0qFVYKgrBtTcf2fE/e7WySEBG4b9tH/+neInct
 FOO/0mutCjOOgZD+qNlTMKUFv1sYYBPxDLeg/1G7cACgtKFaHtKS3BEKg8euUg/pMIXw6/27mLv
 upXda56G5kWah5msrzm+MM8TV0RLFhx+cy8POaqgOaWcr+LYVioFQBW/PjBysEdxhr2Dc9W34b6
 wNcrVNcI7TAkl+Ttf0D1wgfccaY00D184OUHT3U94gVUWiLnRBOr5ok8G7PUSeGtpvbBqU88xj8
 oHpeEOmCHXGc5Ir8h8TX7jI/FYR0dZPwbxJhMAF1+E8UprA5x42yrKnUf3jtcaAb/GIJpNoW7X8
 L37K9rSlVM/rkFkhdK7QHczcRobGSifrL5UEhk0rBWTlCHQeuhP6MBXqhLIb/wE5pVmN6wPfSxp
 koTlcUVppexYE5xW5wO5U9keKDfmgrv6hzgqud+MapEbaqZy4I5VERUfqQ2VOqol8MdxQ0Pjq8x
 EyAYmps4rXdV8CQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDEzMSBTYWx0ZWRfXwBCl5dVQuzeJ
 ylnGLDgIZOOdC2xsJPjjj9NxRCy/ASmYGRFHAMA1B7sm0rPP8TwUrKiFThoM2qQPDOqfixilZ/2
 7m0PVBkxIo7xdlNuxey48MbERnSR69E=
X-Authority-Analysis: v=2.4 cv=R8Uz39RX c=1 sm=1 tr=0 ts=6a39362a cx=c_pps
 a=UbhLPJ621ZpgOD2l3yZY1w==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=p9FZT9qupOX1he3wxJcA:9 a=QEXdDO2ut3YA:10
 a=TOPH6uDL9cOC6tEoww4z:22
X-Proofpoint-ORIG-GUID: aSv3OeA76bP0XOvrbklTTsitCnIxjNw2
X-Proofpoint-GUID: aSv3OeA76bP0XOvrbklTTsitCnIxjNw2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDEzMSBTYWx0ZWRfX3vBzTovnAryV
 j5et206BCZER66k+Byk+YCFrlEu2c3gEOKQDMUEvcNEs2YAgqfGDLGy8CvGGMigUzT7Aec0qFoF
 YD9KfCgbdBF9viIVnCh1sCZDx9DwUVxN2RIbmCdHtDm/DbCmNpC9FnPNGHGOupOw9M7zBVcHqWv
 qB333VY8ahp5LNsgb1yWhzaUY+cYcFqXduUWpVpQfQIsl8k8xV80BnZr5ZAjXa7vMg5jprhJyrR
 HAj84hw4kUkamuuLDo5zxGXgmET5S9wk9Bl20C5kb39B7EaK2/OKmQJcB5uc/BiDY6M0IxM16wt
 TO3/NMmWpF8ZA7j1P3/EDCtGtt4ah8P0ABqZyndGcWDv5U28QKU3xG+NkXHeBtlEdRgCxOzADk8
 6nzMcfeqRooZFMnlQsLQAjU7zxQYWnHU73ZM1EynCyfSyxxa1848+QlwJ/z1bBJ2FwN+ydwKwoU
 75l4SIYJKc1jDQgq/mA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-22_02,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606220131

BAM DMA cannot process zero-length transfers. For plain hashes this is
handled by returning the precomputed hash of the empty message
(tmpl->hash_zero), but for keyed HMAC the result depends on the key and
cannot be a constant. As a result, hmac(sha256) produced an incorrect
digest for an empty message and the crypto self-tests failed.

Allocate a software fallback ahash for the HMAC transforms and use it to
compute the digest whenever the message is empty (in both the .final()
and .digest() paths). The fallback is allocated in a dedicated cra_init
for the HMAC algorithms and is excluded from matching the crypto engine's
own algorithm to avoid recursion. It is kept keyed in sync with the
hardware transform in .setkey().

Cc: stable@vger.kernel.org
Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/sha.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/crypto/qce/sha.h |  1 +
 2 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 0a3f88aaf5169ea7b47a549bbc10ea87d3ae7a2b..d4d0bf88dea6bf1c58ee103cdccbbbfc266110e1 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -270,6 +270,36 @@ static int qce_ahash_update(struct ahash_request *req)
 	return qce->async_req_enqueue(tmpl->qce, &req->base);
 }
 
+/*
+ * BAM DMA cannot handle zero-length transfers. For plain hashes the result of
+ * an empty message is a known constant (hash_zero), for keyed HMAC it depends
+ * on the key, so compute it with the software fallback.
+ */
+static int qce_ahash_hmac_zero(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct qce_sha_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
+	struct ahash_request *subreq;
+	struct crypto_wait wait;
+	struct scatterlist sg;
+	int ret;
+
+	subreq = ahash_request_alloc(ctx->fallback, GFP_ATOMIC);
+	if (!subreq)
+		return -ENOMEM;
+
+	crypto_init_wait(&wait);
+	ahash_request_set_callback(subreq, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   crypto_req_done, &wait);
+	sg_init_one(&sg, NULL, 0);
+	ahash_request_set_crypt(subreq, &sg, req->result, 0);
+
+	ret = crypto_wait_req(crypto_ahash_digest(subreq), &wait);
+
+	ahash_request_free(subreq);
+	return ret;
+}
+
 static int qce_ahash_final(struct ahash_request *req)
 {
 	struct qce_sha_reqctx *rctx = ahash_request_ctx_dma(req);
@@ -280,6 +310,8 @@ static int qce_ahash_final(struct ahash_request *req)
 		if (tmpl->hash_zero)
 			memcpy(req->result, tmpl->hash_zero,
 					tmpl->alg.ahash.halg.digestsize);
+		else if (IS_SHA_HMAC(rctx->flags))
+			return qce_ahash_hmac_zero(req);
 		return 0;
 	}
 
@@ -317,6 +349,8 @@ static int qce_ahash_digest(struct ahash_request *req)
 		if (tmpl->hash_zero)
 			memcpy(req->result, tmpl->hash_zero,
 					tmpl->alg.ahash.halg.digestsize);
+		else if (IS_SHA_HMAC(rctx->flags))
+			return qce_ahash_hmac_zero(req);
 		return 0;
 	}
 
@@ -340,6 +374,17 @@ static int qce_ahash_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
 	memset(ctx->authkey, 0, sizeof(ctx->authkey));
 
+	/*
+	 * Keep the software fallback keyed in sync - it is used for empty
+	 * messages, which the DMA engine cannot process.
+	 */
+	crypto_ahash_clear_flags(ctx->fallback, CRYPTO_TFM_REQ_MASK);
+	crypto_ahash_set_flags(ctx->fallback,
+			       crypto_ahash_get_flags(tfm) & CRYPTO_TFM_REQ_MASK);
+	ret = crypto_ahash_setkey(ctx->fallback, key, keylen);
+	if (ret)
+		return ret;
+
 	if (keylen <= blocksize) {
 		memcpy(ctx->authkey, key, keylen);
 		return 0;
@@ -395,6 +440,36 @@ static int qce_ahash_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static int qce_ahash_hmac_cra_init(struct crypto_tfm *tfm)
+{
+	struct qce_sha_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_ahash *fallback;
+	int ret;
+
+	ret = qce_ahash_cra_init(tfm);
+	if (ret)
+		return ret;
+
+	/*
+	 * The fallback is used to compute HMACs of empty messages, which the
+	 * DMA engine cannot process.
+	 */
+	fallback = crypto_alloc_ahash(crypto_tfm_alg_name(tfm), 0,
+				      CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(fallback))
+		return PTR_ERR(fallback);
+
+	ctx->fallback = fallback;
+	return 0;
+}
+
+static void qce_ahash_hmac_cra_exit(struct crypto_tfm *tfm)
+{
+	struct qce_sha_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_ahash(ctx->fallback);
+}
+
 struct qce_ahash_def {
 	unsigned long flags;
 	const char *name;
@@ -462,7 +537,14 @@ static int qce_ahash_register_one(const struct qce_ahash_def *def,
 	base->cra_ctxsize = sizeof(struct qce_sha_ctx);
 	base->cra_alignmask = 0;
 	base->cra_module = THIS_MODULE;
-	base->cra_init = qce_ahash_cra_init;
+
+	if (IS_SHA_HMAC(def->flags)) {
+		base->cra_flags |= CRYPTO_ALG_NEED_FALLBACK;
+		base->cra_init = qce_ahash_hmac_cra_init;
+		base->cra_exit = qce_ahash_hmac_cra_exit;
+	} else {
+		base->cra_init = qce_ahash_cra_init;
+	}
 
 	strscpy(base->cra_name, def->name);
 	strscpy(base->cra_driver_name, def->drv_name);
diff --git a/drivers/crypto/qce/sha.h b/drivers/crypto/qce/sha.h
index cb822fc334dc187cf1c66e2a332822a596ebcef3..2fa173ff2b2ec4031710ab6e3b14c28b04e0a746 100644
--- a/drivers/crypto/qce/sha.h
+++ b/drivers/crypto/qce/sha.h
@@ -17,6 +17,7 @@
 
 struct qce_sha_ctx {
 	u8 authkey[QCE_SHA_MAX_BLOCKSIZE];
+	struct crypto_ahash *fallback;
 };
 
 /**

-- 
2.47.3

