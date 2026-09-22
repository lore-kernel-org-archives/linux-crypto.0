Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36665476E4
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790081874; cv=none; b=g9ft0B6mUzIL0ZbMM36j9d7Fzxql4JWTvGXmNL0Rf4oIKqBE/fcMcFlQiwPj0ftNbLwGmMbgb6mljVRrDz4Uq+398MUz82lm2oBzMx6QhZ9sIZZlHNpcozjlM01Mivzjnj6phjnZDbPihFmoKg0WmvrKbGQunEp4chvMaAFvA/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790081874; c=relaxed/simple;
	bh=UWs7BGpP9oi4D5e4m9onKqarsURB/nAknWQjeenMDN8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=L/agoXNybotLwcHR3N+jAQaa0iU6L+Sf0mW8smsgEj+AvLuHbUe3ZXrXJji+vfeIoYX7+mXfFZfkoYlmgYHLQYBK27yK9CThpQ3yABNgZxsC0b7nOQ24csJK6jkNv5o2VGcYvKplIOYKqKAnODqSYgz1BXvbXeDHBMXAqi8CgoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=n3CofNf6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=P9IBMGGN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="n3CofNf6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="P9IBMGGN"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MBPaDA2869482
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:57:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+tmpneQVB4OWcXyv0z/2Bcq0vGeEFiuJNYvYu0fNYIg=; b=n3CofNf69AX7BkI+
	d001WuCFTC6oShrxBmBYIvCrI4mBHQss8e2doTs9nDRdHgCG3VX4KD7RgxfLIB7n
	QJLAKEDcm0Z0KtlnNgdbhgNQ0mAbP7zJMDGhFCoqm9uzDJiST/ETr1p/T2d9DrX6
	dJWW7WoBiZcSGqTnMg0jkQFIo8L/ST731k8P3dZL2H47PxeH5f/epCixjSBjCg1E
	lwcihGoyP2t1/oUy7OTt3OIhMQaHmZRdj6czwahYmmlMyAU6CuAuXx7XtYJ5SlBS
	O0xf1UDF51roc9SSSZanyBtVjFpUoFGvw2OUpW0c6tg3e3Dm1O5lXYVqgnE1bXif
	9aOEPg==
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com [209.85.221.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4guj112329-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:57:50 +0000 (GMT)
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-5c82c79466cso5232592e0c.2
        for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 05:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790081870; x=1790686670; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+tmpneQVB4OWcXyv0z/2Bcq0vGeEFiuJNYvYu0fNYIg=;
        b=P9IBMGGNR2ve+ieDT0pSf/CJNUWWfL6qLiKdd3y1DzzeX8sG0fxrmf5kQqxifVxCGg
         VvQuf4DcM5vw+Fq/OdNNgkoe1ffGDJGc4D0FIPrsGMK92HsPr2VYosQpM4pVIoSGTbup
         QkFUfLXRePyAWECVXxsSR4/QA4vFn6FjjDuO98C8v14HPvjdoEoI9vj6JGwiVLcdR+lN
         6yGQuM7qooYkIhwHRF4/HvgYbfIeppItOhAv7iQfehrJpR53f2M+lpkNH1VFX1b6ZIQQ
         u5irTtylySSQQgWhFpg/q+A+o33LZvDfdhvGCqIPpXgx3MfAcuWOH/NrmxfEIxWrsf/W
         ymiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790081870; x=1790686670;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+tmpneQVB4OWcXyv0z/2Bcq0vGeEFiuJNYvYu0fNYIg=;
        b=ev5EpRmxGHwxl4E4mOr1+yGoFCPkN5lxDWoKUQEQpUv/doFVZK21CLLLzuEk1OyeIo
         dPIOCTTOnGkNAGEfyd3tOttWwOy4Muy0UfkcUWE539+W313LeXT2yuS8sgnM11KSikk0
         EfSFO8f4W3wvRFAKk91bH9L6qZ5LTgjKvZB1IjsDWtgMxKei160Q20C6V41/+Y2DInGH
         mnTvbD1xGFilkH7NNBJvPfQcjKrm3oeMMprdHncvZBdhp54xJH3P1wi0W7D2TSM1tgzo
         8znEW6f8ZnwYfohuPyYwoTQGXug1m4kSx3znYUBu16ezlRyomkXapSTqypdSO8nfHlHB
         Pzmg==
X-Gm-Message-State: AFuF++lPPkMmDQdm+0go4lIyX5byukxs7ZnMudvyDqexCOp7c8NOfNpq
	PsJQzzbB3gDIDIknvYadsuK7xqYTe3keg4/dHtkywZScy6e4PV3cViMLuav6T7Vv8IPgFwxPJLM
	PxV49o+s4TZLixpQBFtYqpBz9kvf7mspK6Jbid8VpO8kCtRYbzxNaasGzCqk2QSk2tmU=
X-Gm-Gg: AYBFou212hTIUzNee8w9abi1YmgrCrhMp8FOaWX1FkzD3tD4QVMMObePvyRd0Op7cra
	zAd7/YYqUoC8bDWVe9dObh7wbgYfULX3PLy1SG7M15c31BKyw7RqPTgHqxUp7qT74UVp5qYcQJK
	q3MMDG+jiI37KG/3FRekFYgm5kNqGFmuH1F+YTLUPXeIECiQD2aSopyWnUiBW+Ab8mkal1CvsZw
	U3DvisKH3HxEgl+9gVjs2btp6pR9lN6Ueo99TgRhtfc5RdhE7k0HeCF1wGjantpw7tDtUGFt0DW
	M+BCSKk9q6xUmaIhj7oJBaexa4K0O8DhSLWeu4uI/FhiNHbzMGJnyeywK7EIxzvKl1lEzPzwCGZ
	+uF7EHs23xBLxWG5Ytpl0NWbz+DY=
X-Received: by 2002:a05:6122:1c02:b0:5bd:71cf:e97e with SMTP id 71dfb90a1353d-5c9b58caf66mr7590756e0c.5.1790081869863;
        Tue, 22 Sep 2026 05:57:49 -0700 (PDT)
X-Received: by 2002:a05:6122:1c02:b0:5bd:71cf:e97e with SMTP id 71dfb90a1353d-5c9b58caf66mr7590713e0c.5.1790081869390;
        Tue, 22 Sep 2026 05:57:49 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:5105:ff9:e148:c440])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aaa4537b5dsm1097669a12.30.2026.09.22.05.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 05:57:48 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 22 Sep 2026 14:57:18 +0200
Subject: [PATCH v9 03/14] crypto: qce - Fix CTR-AES for partial block
 requests
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-qce-fix-self-tests-v9-3-b1aa742e79af@oss.qualcomm.com>
References: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com>
In-Reply-To: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        stable@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3299;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=zIbsmodNrd/Ar66AXytQCbkfJGL7e12+q42vj5mvYqA=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqsns4BI9SE0NByBue052dzl+vj4VvGjDm4HHUK
 CU+HjvXlyKJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCarJ7OAAKCRAFnS7L/zaE
 w5kFD/0VsuEoiaC+N2wsBqm5UDVtvpVOuSrdrdXVx0OD8PhHo2mjCPynJjtPyvYR724NyKG9ZC0
 nHCKXBKZcnI1WP0OT0Hai7Msx5MSajxZfmyhz4zgJVcmiruJEBihSXBSrGQuomUbH7/GNgXMmxq
 EiEk0q/ycBwdVTt8Qpw2zhtNIbYqXvmGVNqx5ahYETbYx/CJTqxU1lcsw4Ncqq706pU/Hq9ZRwM
 Pu1I0fm2oTenvqTQe7xsPZ6h4fhnNxYPth8FUPaL2KmczCWYD1QILmdLeAkocJL0tecVnw3RxfL
 b5L7Up3XiS53TF1/tUB3VBHK8caV3mLd9YAym/Y5LaRM6lvPWHoAHFkbW2I33+keeOZh/CH5rhj
 88y7ZIhmtSoTpKmD4+dwZGHBEdbBjb0k0M8tU0X8ZVdVgTowmn08BWfGzFog8Q6yLB2LhLzfHNO
 qL2wOOHUhnsq6uzSySRu/OrE4STKvu0S0J3xcLjmVT2c64SwwojTFF365Z3Qn5lyRYKfC1YEN9K
 s7V2j3dMRcCQnTKLv6ELSmMF0VbRzD1oHhkvY0whrxDHeylnQ2FdhjDu3uZh7tJlmoz6KHoa3os
 PzBXHn6Kzn1EJVchRV33LdaMBRM+PTgvdO+pzND9e9OVjUd/rULDxa32K2QwmHCoDTOQk50OmFP
 hOCsqqymY0gX1Fw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: zA5ZUldCu4tN6heuRPZ-KWFfrpR3qmnU
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDE4NyBTYWx0ZWRfXyDL6KmUhcwYw
 ncbyJCN2AN0oYg8OtSicC0f/YRCkmLP+GzxYSYxWSfOHS0Yf1P91Sf6OIouYWVjdnWk3dL+pfQX
 dbuC92K8MzGYHyjh5lEqyVcTpUCaFg4=
X-Proofpoint-ORIG-GUID: zA5ZUldCu4tN6heuRPZ-KWFfrpR3qmnU
X-Authority-Analysis: v=2.4 cv=atQnmiZV c=1 sm=1 tr=0 ts=6ab27b4e cx=c_pps
 a=+D9SDfe9YZWTjADjLiQY5g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=Y2NcAOke46LZopEJyX0A:9 a=QEXdDO2ut3YA:10
 a=vmgOmaN-Xu0dpDh8OwbV:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDE4NyBTYWx0ZWRfX7uOe7J/5iW9c
 hx4mNtDSIc6B4ucSso8B/B9gEhmN3iQbTVm/eM+QwPcEfsCqinFpwoENsEe2sCeh7Awm7rvbFu4
 y9w6rg+Qt3rsI6j8QGvLezFQw3awNPaTfaHE+6ipcPKmjA41T1IEDaXcg9eJBanPyRqNosGXjzj
 z/cWMe3MCLCaEiqiD1OjKYWPxj2lw+bPn8xra+zd3KbFzqSYFu+4/I6JjM4UXVh7VnS0RllxzOf
 Zh0ePjUHUKLPo5Yq4U9RGSWm3Wgjand1ZZL40C7n44244ZuQUj+SGBo0L6BZh2dUEaNuGfzEYm8
 iSrIYpQjCzckvMDNJ3RGXLtZij4/FHZR6/TxMm02ljd7/yhOX+LUB2eeUxc8sa+eiQG0YYol1dE
 06BvSKig/iRQ/zY2Nt9PEwIEh3TVxiA9Nqf6c0koM/joqrypCvVt9e/H7uzzwARC5hMcl4EL1nH
 pVjds5rtmJmlrgHngrg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 adultscore=0 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220187

From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

In CTR mode, the IV acts as the initial counter block.
APer NIST SP 800-38A, after a CTR mode operation the next unused counter
value is:

IV_next = IV_in + ceil(cryptlen / AES_BLOCK_SIZE)

The skcipher requires req->iv to hold this updated counter on
completion, ensuring chained requests produce correct results.

Referring to Crypto6.0 documentation, Section 2.2.5 says:
"The count value increments automatically once per block of data (in
AES, a block is 16 bytes) based on the value in the
CRYPTO_ENCR_CNTR_MASK registers."

QCE increments internal counter register once per full 16-byte block(for
ctr-aes) is processed. In case of partial request length, the hardware
uses the current counter to generate keystreams but does not increment
the counter register afterwards. So the counter value written in
CRYPTO_ENCR_CNTRn_IVn later once read by software is one less than the
expected value.

Crypto selftest framework capture this scenario with test vector
4 comprising of a 499-byte payload (31 full blocks + 3 partial bytes).
Error:
[    5.606169] alg: skcipher: ctr-aes-qce encryption test failed (wrong output IV) on test vector 4, cfg="in-place (one sglist)"
[    5.606176] 00000000: e7 82 1d b8 53 11 ac 47 e2 7d 18 d6 71 0c a7 61
[    5.606192] alg: self-tests for ctr(aes) using ctr-aes-qce failed (rc=-22)
Expected iv_out: 0x62 (iv_in + 32)
Obtained iv_out: 0x61 (iv_in + 31, partial block not counted)

To fix this, just increase the counter value for partial block requests
by 1 and for the full block size requests, don't take any action as
expected value is already returned by the hardware.

Cc: stable@vger.kernel.org
Fixes: 3e806a12d10a ("crypto: qce - update the skcipher IV")
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index f177062eb735148561f798d0d3e65265f3235da8..ec2f21446cee9dd4a5e3a73879925ebbcafe0548 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -33,6 +33,7 @@ static void qce_skcipher_done(void *data)
 	struct qce_device *qce = tmpl->qce;
 	struct qce_result_dump *result_buf = qce->dma.result_buf;
 	enum dma_data_direction dir_src, dir_dst;
+	unsigned int blocks;
 	u32 status;
 	int error;
 	bool diff_dst;
@@ -56,7 +57,21 @@ static void qce_skcipher_done(void *data)
 	if (error < 0)
 		dev_dbg(qce->dev, "skcipher operation error (%x)\n", status);
 
-	memcpy(rctx->iv, result_buf->encr_cntr_iv, rctx->ivsize);
+	if (IS_CTR(rctx->flags)) {
+		/*
+		 * QCE hardware does not increment the counter for a partial
+		 * final block. Increment it in software so that iv_out
+		 * reflects the correct next counter value expected by the CTR
+		 * mode.
+		 */
+		blocks = DIV_ROUND_UP(rctx->cryptlen, AES_BLOCK_SIZE);
+
+		while (blocks--)
+			crypto_inc(rctx->iv, rctx->ivsize);
+	} else {
+		memcpy(rctx->iv, result_buf->encr_cntr_iv, rctx->ivsize);
+	}
+
 	qce->async_req_done(tmpl->qce, error);
 }
 

-- 
2.47.3

