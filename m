Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6096040B365
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 15:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781538630; cv=none; b=P/7BI/4xcKiazG0lyiE30YjfjeRATwgEwH4V2nSqisTlEVHi3ZfclqT7L+jJV5p2EXwehT6dL3gy7pKSJlFo9sXZXX9pF7FWPPQz9/8EVQ5j+2MfHhoMes6USIAl8tCjhmfYh+tKmT/pBHBLKX5wqxJfEo7P7J5R7zb+U+iErWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781538630; c=relaxed/simple;
	bh=SGpiGMPoMnJW8OsKM6YbK2sMApDpA7GM7O3oLvyBQys=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Pk4TMZAePsp7SwnIwzwx3MtFU/6w8JIRrUeYtkd3wMfiQyLnM9gFwyfplEcVEgb5ThwiIqbbT+Gkzm4PnTN/R+Kx9GPwdS8qsr9ktznPXxuLFuCNKHDzyQ5IotXXwJXZYSODmNDUh7ZNAE/WFL7UETmimgv1UyFI8sb0vPbnVYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TdJMSSrM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UP42y13K; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TdJMSSrM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UP42y13K"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FFhcnr3139958
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 15:50:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6sgKQfIbcheNzVd3O2AIimrVboSNykNJD8xRHhAS+4c=; b=TdJMSSrMO9k5R6Dz
	o5xPN88okf0ZEJs+gP0BjTdE5OOqhvLY9PN1zjNXRnoLt2GAlQU3MFOqJwhEXHoK
	wYhsSH8EYWrfnpJqNGW6wIqXeF3I/uJunW+EPXuIx2uzDaQQJOLxaPabshHNgBY2
	RnxGfjKKZe+eWZpS/aenARlHKnchxQM5wqWrBqnjOEP12blZvgs+NJbhS/M0Ap3F
	xiU2PviYlGX9rNY+JZsXzDp5UtFLfKOGBC8ghv1m0tcefTPEzonMS7+nx12CerHQ
	2T1IP6B14Pu32mh7VGj+rxx/GinX1hL2x3FApUsAHl6LtHIVJZA5qRc7QoIO7qNL
	jZTZVg==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ete981q14-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 15:50:28 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-91931144870so356510485a.1
        for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 08:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781538628; x=1782143428; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6sgKQfIbcheNzVd3O2AIimrVboSNykNJD8xRHhAS+4c=;
        b=UP42y13KmdCCjsd7QocVprCC28sSCGxxbdP/fy1uRVXaVrGTUvB+nXJ9bSi0U1hBEh
         u5yRUJJeTaHRZ4eRZbFPxQSYimlgq9W994Xwtg2Sv0foIWpYElM6RY/CO3xPioaMW4LK
         7Me1FFIyAhQ9sGNgUFkOzWT9o0L1IA3thulL4v3pkVj2UFoa62iIL1ic0QPK2z0phTEJ
         BECuve0oS4ph1Jlgch19ib8B4nmGXBv9PZb66/e+2pMwbk5ffM/Twd7hnUXQ2C8Axrru
         vVM98mPrj5KPn1Hm0AqCRf1pa64LeuiELaN7r40VcXbwW70B5oMe7081FI69JCgjsWq9
         yzXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781538628; x=1782143428;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6sgKQfIbcheNzVd3O2AIimrVboSNykNJD8xRHhAS+4c=;
        b=eXPTqiXEQLiXvyIDR9hPFdmLIWy6IOwvG9c/N1TKV9UKqzhnZXZJp/2kyhz+6N5HHH
         INmX03LycRoSQxLz77QFuQnwsUpe/vu3JqdCjtBVbxrlSvdXa/d4fu7MtUq4STSqwb9B
         Cy2POjIWhoScZGkiIyPNcAArae5FBnBvp5DL4B2g6QU1ORP7GvGq3sJyX44xWIpsuEAM
         mvaCR87jEjBgImDnCoBo2su7K1YDVpg2T8ZLKsdzw634RnjXRMDs45XmK6mghtrKNMwI
         qdoUjixltdvhHCbzyW3CPQk3oaNOz5d4bNANvjmUJSBrezYQxEBx7UlSR39B80RhV+lG
         I0oA==
X-Gm-Message-State: AOJu0Yw2s9g4tI+1z6LLTJ6qYsjvIApNnCMUhKpjv++7aeXhcueZEYcX
	y/rZUFfyCqb2Jd3EbZ2jWf9QDKR2CniSe7KQENhgClMAvtF8uvRRQhxTTqXoBhO6T5C5SfCl71V
	7iscjlJh9SuiGPkZX2cgpQt1TZTGKkp+Zz3vJCeQ3xv2Zy2H/GnnsDcK0+PlnQPp7YCs=
X-Gm-Gg: Acq92OHzcB+80whPf1a5qUbyrLqTp6ACjG9kUyK2ZVq6HpsxXkApFJWBtPzOd80dOOa
	+oVyfWTKfY4ZzrqwauI84hTRAEmGZbIzBLIRQij6mkz3oNapHT7a97ijcZ/f1T7CPO0YvJL/UjZ
	w8kJUmHfn3DpsKJyD/eFMN+gDiwphuwHaGh7ADHOpDx3Yx452TaOWUPaVN9J3fZru7k0QZgFH3V
	YFng9ajdht5LLPx/useOHot3JK4byNiTozP0wcgZmhhOJJEY9t12aIrm9RGokoCIAY0Drbse/zQ
	enJhu1kAa1xOVmuNv5PCvvImvnXFUB1fnc1mxWxaCNRr10MKhlYIZ8QegVZJeAwDE8jxMHxEMue
	RS/u5b9ARIZhEQ/qIYL2ih4o7Z4f6yvzM07JKjDWl4OmajG7WAKI=
X-Received: by 2002:a05:620a:7106:b0:915:a953:4b93 with SMTP id af79cd13be357-9161baf5670mr2274027585a.3.1781538627421;
        Mon, 15 Jun 2026 08:50:27 -0700 (PDT)
X-Received: by 2002:a05:620a:7106:b0:915:a953:4b93 with SMTP id af79cd13be357-9161baf5670mr2274019185a.3.1781538626936;
        Mon, 15 Jun 2026 08:50:26 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:7fe3:eaf0:5a0b:2610])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26f450sm38643032f8f.10.2026.06.15.08.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 08:50:25 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 15 Jun 2026 17:49:55 +0200
Subject: [PATCH v2 4/8] crypto: qce - Fix CTR-AES for partial block
 requests
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-qce-fix-self-tests-v2-4-dc911f1aad42@oss.qualcomm.com>
References: <20260615-qce-fix-self-tests-v2-0-dc911f1aad42@oss.qualcomm.com>
In-Reply-To: <20260615-qce-fix-self-tests-v2-0-dc911f1aad42@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3447;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=S0n3FvtYweutMZSxJALq2DQ3CjmyCxFcNrOXGyJ+JFE=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqMB8vWTxT6nK9U6anmrJqcFiMjPqzFfQpNqOUD
 5ZIdIjDEXiJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCajAfLwAKCRAFnS7L/zaE
 w5WJEACsEI87v3YbjeVgMti2J5cFz4Hd9oJCvqnot/2jl5P2OxJUb6RJ01yOawx/Oe5ZS0llkRy
 FJdJxUs+OL+S+KKe0H/Z2BJGDHNDAQID3twnLnL49jrZ0TYZki82H/AfpL/9og4KJhI3ON90XQy
 X6Q8p6f2thoRf9J1fnpnhBNATpNNqOzMBexokOROQcs8Fmt3nn9+kQPJ5BdecjtIQt9WleDloGG
 Rzx1fxrtpqVyrwwFS/7uWVMgep4iav8ZivIeuv9PC17Q85YxyJrtGSkkjcn2lNI6hCVdylde6/w
 xPhi+7VK86xe6F9eAF9bPMl4g3g63fnxAK3kXTFHRApAgznEFQOAa5pZzAiEaviQdKZMYZxKFVL
 fCqcxGms7i3Rk7w4SoNoU8BlvifkRbqpj5obfqUtO4f+23NF9cp7xEbM/IYYaP8bd0G7w1A6PZi
 zFybf6V0BvxwGO/a2Pc6LuTtyX1S4hkN9ilymDJ6Ny+H6FrFKPZDNNyPVLprnFLpYxHD2PSRpW0
 VjNk1Br7vflvd4mJrmdi7uqjRkNahko5DaY88ig9B2VFRnvNJXhufKjHlz3P4iO7TBt0gYAFKzz
 LlWFQkQWUPjIt9nK6p0WIFBUeZhJlKqqhUSiHPRv3O4b9K/Ifxhj3vc59xYTa6CTNuGbaNlgcYF
 emGZ21I51dtksNA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=V5tNF+ni c=1 sm=1 tr=0 ts=6a301f44 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=Y2NcAOke46LZopEJyX0A:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-GUID: 36pHf2FB2Vekhd5VZ67O69-_8NlhDKn9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDE2NyBTYWx0ZWRfX6w6gAN/Fs9L2
 E3YOxn4UkiZpi3XDwbNFxMQC4Le3WMVcoXhCqx/GCcdDKXWu1g11Zl9vjSykbgS3vMUQeZIKuo0
 MVK9Jhl+jrhqhyLFSGnE1Jg97zeqn8o=
X-Proofpoint-ORIG-GUID: 36pHf2FB2Vekhd5VZ67O69-_8NlhDKn9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDE2NyBTYWx0ZWRfX5lYXSSvPWK+h
 FcT0CcHUByoDJYSkDSGWYc/HHS2lODLbiNM76WxhSz4qo0NLATPaLPYyB9JAzslmbFd2e4Z2Gp9
 7+cUbzno0H0Zrh0RXsxyg6+Q5vF2/zFW7pMsqQUeopQhXIgCdNMsuXrYLaKnOmXc3yiKYTq4XNn
 evsXhEF+BCQntpC6Xa25rqcWldDXB5somZvlhYF5NN7SStZgdFvgewCc+eK6PO2b0hOy4m7J6b/
 IhZYlumhzhzJcO3QLFYg4Q5S34BYx0AJBzvpMZ6VV8BiFI2aLt6KIYoF4IFMR7mNSmgmor6E9Qz
 RyMnJr/S0hz/Ax6Uzg2daENARHvsMpYPEDgB+bepWnzoqzvsMqeWmhK5iVtQc1ejUspUJqnKuim
 V490frChvM9BI2jZ0uUVXfmWDqkmDq8Tb1JvxZBPMlw3HikBzOHdy9rJqLLZqecOVtpnNGSqokB
 5A774739Z2EWCtp2nmA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_04,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150167

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
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 68b83e3ae088ae42a7fb2a2f0c2e132acf62e849..379b45d2cd952a39c387e84af71238b53f7737e9 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -11,6 +11,7 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <crypto/aes.h>
+#include <crypto/algapi.h>
 #include <crypto/internal/des.h>
 #include <crypto/internal/skcipher.h>
 
@@ -34,6 +35,7 @@ static void qce_skcipher_done(void *data)
 	struct qce_device *qce = tmpl->qce;
 	struct qce_result_dump *result_buf = qce->dma.result_buf;
 	enum dma_data_direction dir_src, dir_dst;
+	unsigned int blocks;
 	u32 status;
 	int error;
 	bool diff_dst;
@@ -57,7 +59,21 @@ static void qce_skcipher_done(void *data)
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

