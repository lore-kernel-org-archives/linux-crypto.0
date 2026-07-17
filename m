Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D21542E8F8
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 15:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784303647; cv=none; b=WafccX9L7eFRQnt1fj6qTKplJZSlYBe6sOf4hSmE+J78wJLtHAGY5j3u8ql7lC00+1NdFpOxEEQ8Q5iv0zrKFXQyNKAWy3AvNu6OypcfW9tX5R3krqelXwPawaKJADf0zeOW/pyE2pGHoywWIMOBCAcjPQxi2+C+kfGMZphIlmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784303647; c=relaxed/simple;
	bh=BBHp42+omknys/iPA5EACb9kJI3V54wM6S0aFwyVF5Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AR2ro1RpMNesuEGIKfLFs69vVyGB2w+UTTbg/pae01Asm0e8BfdqK6c9b1ujsFInEhhKnG3UwffaNxjlPmDo7DTnJlYFLHO9dCaVetV682sbnR+XT0DVyJ0ab48pzKTsfKATLLLLMl4oI1uerCLbcpZqVyYDpUYqt55eKHfDuMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dsGkRy6o; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Cu9suT9Z; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dsGkRy6o";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Cu9suT9Z"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HFD60k2126585
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 15:54:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	t6HU6VgFlAEyD60GVbuKkJb4521AyTSlWxXiDy7nMI8=; b=dsGkRy6ola/Tsy4Q
	eLdyWTHpWxM3p+sIlpl7/o8CiGZ7O7bTiE/3amw8a4UsC6TQYHn6MyFPKlscEwBl
	vzL8CSg/RshLWokjndeuKk1lawkEdjLyI+RQUCSUiitkBWpwUBMsTRhqmTCh8o8f
	/bTntjmr6kXCRKaBntHqvwlOaUuiYwdsnG3sQLpwupiNBI5EQ6X+aO0L9CER0GI1
	/5MUTG2e/FemeIhEGCNBqnIYrK//ANOdJXgiIxDRG0IB5BLBTThTPaFRNqmHvQu9
	qd54zO7YvVBufA8Ggsj+PsgB6gDGuulQrq5j1HY1HtgMxyb/wYC2wKaVrEH5gH1M
	U1oiSg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ffpug05h6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 15:54:04 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51a8db414c7so122207131cf.0
        for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784303644; x=1784908444; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t6HU6VgFlAEyD60GVbuKkJb4521AyTSlWxXiDy7nMI8=;
        b=Cu9suT9Z/5lag83YTwuV9eBy8O/yX5tms9PAd2w7EYbpqlVeOfnqCFAMVJIA/RjNFE
         GxuaaVWYwYsa8qKaN7+7xEYtEUbs4AKi4vx/tp1W2m3+vsnqk5NZGR1GZQXlh0mcbSLZ
         NeeXipzbDho4/Slwk3aui5udYFt1YtFyiJmdmPmkFcCD1zhVI/xVxOELLrdrgx3qHCCW
         rmdlv32wlmHApHPZEwV9w5DoGaXVw6/zQxxNWxrOD4xxBjjmrjv/UOn/GoUitg+7NhV7
         Y5bzwmyecEiefFHqf7Sd0XrY+DmchyBSur9uclw0ahoU++bjWV9RImKgXgnfAO8w1OI/
         hYgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784303644; x=1784908444;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t6HU6VgFlAEyD60GVbuKkJb4521AyTSlWxXiDy7nMI8=;
        b=K5NYUVNkvntKwQInmE9A2N2ei8XDpBLSrn03aZV7SeqZUEyCqhaEvmQ9JPLqwLKtBV
         klq0NKgkNA5I7jrl3epzxpYP2v93WuHFQfwWm9zlgq8wfcNGjDMzEKj3I6BQ6HvZQvNd
         oVGBZhPcYylynIsFezWxm+EBRCCYhPRNIGdfpVFcCoS4q6zOGT2JkXyQKXNk1VsslRWe
         gr+gePGeOYsEdIx9KkivUTgKTeS7pVsGo3XVSHLEQ5DhyfjNmLODlkgt692plX51e4nz
         Yne4Z1hnZqj/S1VcS3Lkkbj7WZl/D5osA8p4XVN5inAUImP6zqPr+WX1Z2yfSt+uqM+5
         2lpw==
X-Gm-Message-State: AOJu0YxDkFJOV7YHLbJkDBOPOyOaVpn5Jgja7qeEw/FOQUpxhSppxdfF
	JO8M9Ps5AZluby73S0aihAmmunTgr1Ms7t1j1KuA7Z2JIHSzNNPVtZS/zgWvP5dXDOABl3Ib2YG
	ZlB+Zgu2/MLxascY7HGXWvY0aQJ8+KI6sF7uOyl8d9URA2+7mr6M3Dijf4R1jsK9MmRsY/FKroS
	E=
X-Gm-Gg: AfdE7ck+jugpHdjHbVjw1yyjY30iNGv2e0RN+Bw9tBfBdJxgihZ8spIZ86jKA4wniMZ
	MOWVDJBM4D/Vus1E4vamMG1FydNtsizQ5ACFMWxdkAvuq2CVSrlpivy5O17kY+La1Ngvyc+Wwhr
	pDmdfVANJ0m5OSYGfofGKPuveUDdWeU6dV+Zarz2icS4Xifdu63i+kAqV89FoMoSxsqIx4CPO0l
	eBr2wpBJeuBsNhZc5kPwvf8uImVqCKgmgafIOGXOEolfkWOcglKzUznxL2MvQZomGfVj8efZKcR
	E34KoJaW6WoMDdpfnR6Lk8TCPaCen8HZraHQN5au19aPXNyhATjNsaVDTaX7BnmPL1gd8y4208Q
	zPNWDVBrB3hzBbyY3zSJHhIzAuu5SaA==
X-Received: by 2002:a05:622a:4012:b0:51f:13a1:807b with SMTP id d75a77b69052e-5213f966098mr31155691cf.88.1784303644420;
        Fri, 17 Jul 2026 08:54:04 -0700 (PDT)
X-Received: by 2002:a05:622a:4012:b0:51f:13a1:807b with SMTP id d75a77b69052e-5213f966098mr31155381cf.88.1784303643916;
        Fri, 17 Jul 2026 08:54:03 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:dc44:5b1b:5396:79d6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2a2511sm47057095e9.1.2026.07.17.08.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 08:54:02 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 17:53:34 +0200
Subject: [PATCH v6 5/8] crypto: qce - Use fallback for fragmented skcipher
 payloads
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-qce-fix-self-tests-v6-5-455775fe5f6c@oss.qualcomm.com>
References: <20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com>
In-Reply-To: <20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2078;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=BBHp42+omknys/iPA5EACb9kJI3V54wM6S0aFwyVF5Y=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqWlAMC1qipsrdpvkDTnEt3LtXQk6P8tCLDjNUq
 CZYsxfrAdqJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalpQDAAKCRAFnS7L/zaE
 w0GVD/9VCHqi53NFCsozgiEzSCqXRnXY7Q5QbyuEPGrQiWdHwteOGG9viZpzSwtiHQUgKv8QcFh
 Gz+TeR+pYaDGQ5tUm0ErR0UY8K3yWxGEQUkpITHRcd14PdJOHphonJ0vkHFP1karcbhSu9Geuh7
 xsZZCxpCH3FUn4jy745QEECI7FFYEvB7Xkw3WJujIBYRCFFi0062OAqzhRSoRxjpk3iEgRX5ZTS
 mTwv/7ko6S3gQ4rtTuQOlAlA4NRghSWbNDVkARoAkw36YqEw3HMMq/FUpqz6dIH6yS7DsfhADmh
 DheiadLNqGyjFZJPwKvsRA4UUoKwiRWn7rYIG3svoFn+oXx+ZhZv7xgYi9vh2324Ctn+6rv3P5O
 zQ0Xo74N3ay6vldqyBWiMMo771ywbgPodXLhRXE3RGYDfm+1WKH2TSFrTKxJzRUaOXnlCwrKeKp
 LRtQtT3sQa6MgOkgceBfiomucJM41Blkm2e/sv/v1EhrGGFuoMwQZjfc7j6UbjxUlJFwis5AvJ6
 YUTPmoCly4bS+QyI8OsrbAvTnCWkXNNNF0Qjk1xDG8zxPZxIOPZEY+e8jQiPvupjrYSrkhgtc3e
 V4o6S0h6KIrfTEmK1stXwFZXL8s3UIUI9jhx8nzID8hvhWmBrW8JFFvHcwIvdbClkhthMHMsyZA
 pioAgzz5dCZXzzQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE2MiBTYWx0ZWRfX/P/gLQ9p7mLh
 0RW1jFX63Znhz9tVrBh/5RoySc0g4Yh7r6fel08SpBeSR/laD/+kHMGEYB4/sBWxpNAZYbU8a5j
 AiWnlvmBtqbi12tTQEbcYOucN4qH/gN6gOC9KiRIHRhmYQIjQVXv9Gw9FIPkZ63xEbsvCCZeWFr
 q00PTWl5Kj2Y6NwExZaNCtiYURxSO4jI69aR330jPokyF1yiAcH56pEv227hNc2h/Tlq7XImtl5
 PI30C+H1Z6cDrmZRU9p7+UySMVYzd5ghT4pYMoCrV2XEShx47CKxbzpEyaXniMH27wVGeZjr8di
 zVGuvl6PwWnlShOECIeNYgHofKyWY5rX9NzZFaSJxVoRGArsZ0mfhhNTkc1+a0n3vV5PGh7IoVc
 teOu3mOzGCYuLdpOmY9Fhaensx+v0Z5dyxuwZjF8yXfLfcfPlnIVtUU75Y4eTQsHlrnpg6GTHuo
 03w4pbh55pL/rC+STVQ==
X-Proofpoint-GUID: J4X6XmGUVpXK2TwYtm5_979e_kKNMzVQ
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE2MiBTYWx0ZWRfX/5zOEjb1gqdz
 6/+mKRoZBhIYgsyB5MKtxizMfO/u+Fe/3H5x6U6f/wNJSxt8Di8I+pv352FcwTJJlkf9QxeSreU
 P4Riufjojub9R0Ebd7EFEIh6qgK9pes=
X-Proofpoint-ORIG-GUID: J4X6XmGUVpXK2TwYtm5_979e_kKNMzVQ
X-Authority-Analysis: v=2.4 cv=Q63iJY2a c=1 sm=1 tr=0 ts=6a5a501d cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=2ArJjka39wvl4ErYtigA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 spamscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607170162

The crypto engine reliably processes AES requests only when the payload
is a single contiguous buffer. A payload split across multiple
scatterlist entries makes the engine stall waiting for input, failing
the request with a hardware operation error. This was uncovered by the
crypto self-tests, which feed the algorithms randomly fragmented
buffers.

Detect a payload that spans more than one scatterlist entry, in either
the source or the destination, and route the request to the software
fallback.

Cc: stable@vger.kernel.org
Fixes: 25b71d61d631 ("crypto: qce - Improve the conditions for requesting AES fallback cipher")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 54ff013e24317cd4d7a0dcde88cef8268db784c9..4779218d4f33a07331c510abf0d6d23e7e70d102 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -262,13 +262,17 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	 * needed in all versions of CE)
 	 * AES-CTR with a partial final block (the CE stalls waiting for a full
 	 * block of input).
+	 * A payload fragmented across more than one scatterlist entry (the CE
+	 * stalls waiting for input in that case too).
 	 */
 	if (IS_AES(rctx->flags) &&
 	    ((keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256) ||
 	    (IS_CTR(rctx->flags) && !IS_ALIGNED(req->cryptlen, AES_BLOCK_SIZE)) ||
 	    (IS_XTS(rctx->flags) && ((req->cryptlen <= aes_sw_max_len) ||
 	    (req->cryptlen > QCE_SECTOR_SIZE &&
-	    req->cryptlen % QCE_SECTOR_SIZE))))) {
+	    req->cryptlen % QCE_SECTOR_SIZE))) ||
+	    sg_nents_for_len(req->src, req->cryptlen) > 1 ||
+	    sg_nents_for_len(req->dst, req->cryptlen) > 1)) {
 		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&rctx->fallback_req,
 					      req->base.flags,

-- 
2.47.3

