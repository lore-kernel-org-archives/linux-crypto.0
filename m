Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA7033B6F9
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jun 2026 05:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781070860; cv=none; b=NGV9cSVDkmfwOboD9A0Psqw//S/6NVdqae7avHg6j8L4rHT1ySJqo/Hmfg1kXSzQTqw+2XbKJCLk0ZDhkNIiMErIW17jlbqMZv4mOC5W89WLg6dC6sgDwQ/7Bo8tsAgtyCFKGyAFjVB7L4Yb/1YrnVMHPc06wE3fAOtvGBDHlYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781070860; c=relaxed/simple;
	bh=d0pc5XLYB20EUdMDozhH6d9NLxhlhJieCpOBI1G5dVs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=My+drkluZ/SINQHIVCOZZz/gfEHOzkH317z1my/+s36lcWFajuZfYSP9b4n9f9vCHb6Vi8FeHZrkbpBaGr2kS/cx5ir+xY9BYXwTjkUjnkNGCbPvBbOhKGvX5YWRcYrAAIb6cXnmpz0E4ryuDD+av+SW/rzx819rwFXi3P2Ag0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=agb8W8PN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Dn2WS6zv; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="agb8W8PN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Dn2WS6zv"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65A2fZcK4063289
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jun 2026 05:54:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	r++WJ9p5aERTSYrUGn4QNXdHa6+E5osO+Zj7aaUlLs4=; b=agb8W8PNK6Ys2DQe
	dApLItqd11RVQbpFwpTsji0yJLVxdtHBvc1Id9HodtBiF4tPAyksUs89xu/vsAFg
	wrt0I2HCsPQW+0nbhbdP201EfChGn4oBeiakythfLinO76gwvpLCbac+JMaBXG9d
	xp3cTvmVAb/ORQLqxjkDVtHzQ+gxUGu6egcpIKucbhUs0saXtVxu2rsHnxK5BJyl
	IQHnACz5u1ATK+OMZj/3MYs0Ie9mz11nwapBclG7GMPxeyAIbDBTU37f2HTxV4xe
	/m+39G5s5zokk25ej30b+yLFkrT/OfkPRfwYdDxNVT+15hS47+2gELPr/gsUvuAo
	w1kuZA==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4epwnh0y0v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jun 2026 05:54:18 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8423efdbe6fso4123419b3a.0
        for <linux-crypto@vger.kernel.org>; Tue, 09 Jun 2026 22:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781070857; x=1781675657; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r++WJ9p5aERTSYrUGn4QNXdHa6+E5osO+Zj7aaUlLs4=;
        b=Dn2WS6zvDsCPqcCXN4Kf+sngwQ7KBLq6/0xnSdVjJwrtMdtas4NVpebNFWrMOO6ydB
         oI1NoL1L3gj8kqWcAkqIMcuwYzceAobaIHXtX7Rk08kdUjyAD3UfzWyjqpabbMtxCblA
         J78mCFCpUjDndigyQJ0yNpQ21vseohUR7d585C4aK46LTNJ+i+bOlOPgWFI8+fKJdGPk
         r3X7ypEmO6SQBHQmNSyEhhGLWSj0+KNMqjh0LaCAUSt4eGfvHoFSnInMQbrYndnlFkIp
         UZgyWyTdtUHu5rCWsq2jcjBm/ya/kcew4O1mC5quWyVbPf68xVnHkeywtzGmRbJ4F3ZG
         zovQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781070857; x=1781675657;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=r++WJ9p5aERTSYrUGn4QNXdHa6+E5osO+Zj7aaUlLs4=;
        b=X/Oe22CG+WNJJgfkJnh0QJVNBRDW2mKTNTnxngDo43gQt3EHX03HOGCw+3tTxsQMI3
         7Qpfrf2jmvCODG8touAHnzozMrGLamw4rQ4bYCY5McT/edDi29XHe+TXCABbVM5PRiYA
         kVDBlS7pRxoWXqroIfodBGfPU+sqiJTfcOpIiUD02yvs0Of2OqV6oIWxHlMWplCwzYfT
         n2ItscOSb3GFRImdJgcw16FYngtA9OrQdGpuAAo4V1/lWexZ8HcvrlDRg4xHqyNS2Lvt
         mnCUFO7ovaqEnrCxbOwyl0fmcdewIYobOAzTHQle2IV3BgIir+PwhbS+eHCpzecSVOZZ
         e4pA==
X-Forwarded-Encrypted: i=1; AFNElJ9lHAQUPCeSRJHGBnLYYrDT84OtxY367PhSxwePMXtmvAMtTpqoFtYCCa8VubQ4zebTO4Zl7OdITVr72Io=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUPeBLJDiaOTd7GF06OUsjmFICSCVWLxaL44aqMOHKsn15T8UJ
	kUO/OPrkP56TfmaCsJvHl5h4lhD88QTJhgim+pRPDBCwef9hmB5LCNFdQwRd5ZI/swzj+Aak0BQ
	0DicPUWomN+/ASN9DD/WKDJgSyvF72tCvFvX6Qlbhd0ROdtFLGUQJEkSF8w0NfX9tUrQ=
X-Gm-Gg: Acq92OEpWKIUVoK0gpJGCid/G/+x8xSTbFA23GpNqqfuNUiFtTYRAxh2pfS1+sjiVNx
	tAQW3xqSE2C6i9YDxeFIwko53djDPL2Ld78hVVs7lGgeqGycczL7L+//L4Sa3+4HGkkokN1ufwj
	rKW19Nwcyy8uZhPhSYecKl1U7Y4oH9VW5sDmZRFNIRzG3IEScXFMlTluSua3Z1eO2NJqVnKqFrX
	kKYIH8zH2YQWCxl+3IgHtx1FaKip2N0lxKSMfvHR2j+CtyINE64RMQhUKS+l0fXql3fBuUdXPk8
	t3JYYhxchJHKe/0fwacYnmXGfwy/HG3uHpe2ACwiobXd4ykeg3awj02BYb8HAS16Np4KEzrrRDE
	F4CzO5nUA/U1CUkN8bNGB3mp6KuO+V2tON2ndsy4NwVyevijuBXAQQ/uf6k4ASrg0pw==
X-Received: by 2002:a05:6a00:8d6:b0:842:329e:7635 with SMTP id d2e1a72fcca58-8430a7dc0c1mr6897721b3a.45.1781070857526;
        Tue, 09 Jun 2026 22:54:17 -0700 (PDT)
X-Received: by 2002:a05:6a00:8d6:b0:842:329e:7635 with SMTP id d2e1a72fcca58-8430a7dc0c1mr6897688b3a.45.1781070857095;
        Tue, 09 Jun 2026 22:54:17 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84282221086sm23687470b3a.10.2026.06.09.22.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 22:54:16 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Date: Wed, 10 Jun 2026 11:24:05 +0530
Subject: [PATCH 2/2] crypto: qce: Fix CTR-AES for partial block requests
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-qce_selftest_fix-v1-2-1b0504783a46@oss.qualcomm.com>
References: <20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com>
In-Reply-To: <20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Cc: Thara Gopinath <thara.gopinath@linaro.org>, linux-crypto@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEwMDA1MyBTYWx0ZWRfXwLREwpKSzQVd
 mkzRFjD+hMQDWHoIUo0jODoLXCuvdyDSqTgRSewkSW7/ED7BDoapKmRir3i9AjKWO3Y4VY7gRIQ
 ZMvAsm9p7vKtDOXy33q5Q3jLYXfhpCgps7eZwkNvFbLZmjEKFO3VKjX0EdMcJg+aHIKvu06Fzjz
 KheqzaCK56lLcyJUzqamTr9mepO8PZ2l8baqVJ5unvuRREBm0pzCKb3SsjlEDnhoCNJg8yFETQW
 Zv70LUWwhzRKEMeF/mIOamqgLrlGmoWbIRxIQO9ZqAYGW0EXN3t3tC83TGeFRVH7GYVNU5YlH3t
 i2xOzNN3BKZGD++sFsSNzCryjH7QxOo1wKAr+A+39dRHR67z73Ud5/6mbRZ7p2XsAi6ESF5XFku
 x2PGAUXTlD5mwPxNAweBq2UvsSwBwi0IiK/sDQLtiGySWfWUiEg6YISrpeHHyus5Cely2X2LjLY
 zFfnJJHfnfN233hilsA==
X-Authority-Analysis: v=2.4 cv=Xce5Co55 c=1 sm=1 tr=0 ts=6a28fc0a cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=J69qjfz861JwZTRCukIA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-ORIG-GUID: JzANNOWUV6SIBT4I0RSfa2lj3HguNKCD
X-Proofpoint-GUID: JzANNOWUV6SIBT4I0RSfa2lj3HguNKCD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-10_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 malwarescore=0 impostorscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606100053

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

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 224693a831f5..b25e3b76b6c8 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -11,6 +11,7 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <crypto/aes.h>
+#include <crypto/algapi.h>
 #include <crypto/internal/des.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/xts.h>
@@ -59,6 +60,14 @@ static void qce_skcipher_done(void *data)
 		dev_dbg(qce->dev, "skcipher operation error (%x)\n", status);
 
 	memcpy(rctx->iv, result_buf->encr_cntr_iv, rctx->ivsize);
+	/*
+	 * QCE hardware does not increment the counter for a partial final
+	 * block. Increment it in software so that iv_out reflects the correct
+	 * next counter value expected by the CTR mode.
+	 */
+	if (IS_CTR(rctx->flags) &&
+	   (rctx->cryptlen % crypto_skcipher_chunksize(crypto_skcipher_reqtfm(req))))
+		crypto_inc(rctx->iv, rctx->ivsize);
 	qce->async_req_done(tmpl->qce, error);
 }
 

-- 
2.34.1

