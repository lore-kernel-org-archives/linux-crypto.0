Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45140345753
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 13:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783346063; cv=none; b=gU63WWg2rjUxdRX6JFCiMjpHwjzEDRSOh1YCTZuiRm5MN/usnIXyWerRxqG0uZcvvy/JtZ3uav5/MNADEheM6N+J+YPBVMlhay1aqZl3G3qJmDZn8iOxdzxd7oTAyb00z3MhNuZpIyQXU1uqgMKJkdhN5/eMznykoN8GoHr28Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783346063; c=relaxed/simple;
	bh=ibXDE7QfYBh/Y3uVHmqj0Doeaz6ovE/rm9hnql1AQTc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CL5phEXGQlojsuVQnFMmrg5+/bWgqs6+CDExXMRJSctCWCvZ34CgGDNE4ZKysCsTtPWMC7pOwEzkQTjCVITL5XsrUdydnjCMlAgcCR74si81VzN93tZpVg1nmtsMr/HRDCBXB7SowUIS8QXjvOY1zUacnJqIyLUeD7M7RCNGxFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cmukUE6g; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QZovjtLk; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cmukUE6g";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QZovjtLk"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666AxJmI369083
	for <linux-crypto@vger.kernel.org>; Mon, 6 Jul 2026 13:54:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	QYeFtj5+lSRAHCG4iElDvXo9CD9HgurpDRFCb9pO2Kw=; b=cmukUE6gFgHUT8+f
	Am9j1OFNcGMF/w/GRgSI4eHAgWqJFKa8XXcDiGAKwbs5xxtiBicDud7Ay5by+GNn
	fVUqwwCav/8E4H1qXi0eUWP5vqIDn5q/7kebGWMCKmqdiiBhGX2617oppTL4EaXy
	uusk8ShxawhzaR3qFEIqBNKoxC7gbp9wpp16GEjuRGa8szvVsd7Ox2wHKe5h+EyC
	ZR3kBgoLd8D/Oz5lk5MmeIuwiLhatYnZgXv2/qEy3GuVviMF83hNxmfsVQcKVen3
	6AnAiN4gd4ffv1KeuyRvMgisHlDF5NJNbSQ4jyiJ7gz0M7IU+f02Lz5MJvBtoQzw
	jrwCiw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f88h99cye-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 13:54:17 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-92ac0a54110so343728885a.2
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 06:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783346057; x=1783950857; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QYeFtj5+lSRAHCG4iElDvXo9CD9HgurpDRFCb9pO2Kw=;
        b=QZovjtLk+yW7GZcIlhFdDubCd7b5Xy3kyg9SlwZgG1NOPA5LTrfrHyPZmlOaD9u8NT
         OWfdjUbhLIyMUK3vWZXMqyZE8h4jOVrFQI2a/agAyIaTFvix5iQd6r46P+HwRSp4NgRF
         mTyTgyq4oDSKSAeeMM+gqPmpRT5YjAInzKDmvfZYeR0Y9QTAbjvqZgppDHN9ec7Zae6u
         XNB2+GlpY63E5Peb67yRk+ueHcJfyXTdWWQV5CMDJiAuAK4+abuIcMQ45hlkjitki61w
         S08PlNQkZJR4L4iy9Rav2rhbR2PvHrxfemaYLRkBjhhfYvwyyjlN/EA0n52u12NOzkzE
         QFew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783346057; x=1783950857;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QYeFtj5+lSRAHCG4iElDvXo9CD9HgurpDRFCb9pO2Kw=;
        b=Jyt5Ao+GsCLAYS3zuFHizTCtgW3gkM+iksjuwjefJno1VmbVSvXwRraKpF59XHLWo4
         8L1V0qa4oi0IrY8qbAQ8/DWnJVF0a6wQE08MRGalXdQChdJL/m0Y5wF3zw4ENz18pIeZ
         E39DR2CQoh1xpe5QsiN3epvQjG+EiSyH32rgBxQa7JuqtJsim4TDG5d4qfqbiFadZTv2
         W93LYgR1/3PqMs/0nLgGpTAlLkayUteWj8WWZf/tM05Y9IrGMNvimxtHif0fnBuP1X3a
         FJLKuV2blg6SiBHV/W/jHzqo5CiZunzkfZufEeA/Yyr8Z/yPj8GuaKLnj+k2nGFA/rZW
         72Yw==
X-Gm-Message-State: AOJu0YzWP2GahqRKhbyOQ5PkfK6YV+IHKy3vMQDTsqAQt7BSTu4UT5pj
	MwJsv/2+QCMBg1jg5RrZaO07+234TSHIZoFGOm3jZTL/2JnF+6KOY1DERqmpHOKeI5paAFGr1fL
	e17f8UyKfDNYVGlilusc33kgRHbKt+mfBus0IbMAPmXkVCUJMMnbwudgdv8YuScHdHhfVGVgwxD
	U=
X-Gm-Gg: AfdE7cmfrCeZV2lm8ilcqemTTGQG3CRV93oRGdPgrsm6SArEmS3cQAdklZm13tFhui2
	BZPQxuf6xbdw5h+PyYsy0PQCL4F2+Ha4GwCr410YpEJtED0RWyKo68fYntqidpIe09Vh8YxP0yR
	AKIhWcFNZNC+MAKpCpYypYhnGxZMHt/Txq8YD70KY84jkRM6HJHbiFyAVol7p3FkMjWU98v1l9Z
	deduoE2Kxupfg/ZavnGsa2qeRdz9fn6FNtjMFvnUHn+T9my03QzeZYz2PZmeDWsRHH930if4EjE
	ZETY8v96w10Ry1YcXS0yxyqH66zqbkDCA5wXevTiFBap9hIoMkmBS/crr6pEAXoLUvmM0YWkpkc
	TW53aTmOuvLuDyHjRbazUgfbu8CTPBwH5X4/woKQe
X-Received: by 2002:a05:620a:3712:b0:92e:77f6:157 with SMTP id af79cd13be357-92ebb526d8dmr99621685a.7.1783346056972;
        Mon, 06 Jul 2026 06:54:16 -0700 (PDT)
X-Received: by 2002:a05:620a:3712:b0:92e:77f6:157 with SMTP id af79cd13be357-92ebb526d8dmr99615585a.7.1783346056375;
        Mon, 06 Jul 2026 06:54:16 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:86f0:c42b:ef4c:d3bb])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493c63ba971sm619805145e9.13.2026.07.06.06.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 06:54:15 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 06 Jul 2026 15:53:54 +0200
Subject: [PATCH v5 3/7] crypto: qce - Fix CTR-AES for partial block
 requests
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-qce-fix-self-tests-v5-3-86f461ff1829@oss.qualcomm.com>
References: <20260706-qce-fix-self-tests-v5-0-86f461ff1829@oss.qualcomm.com>
In-Reply-To: <20260706-qce-fix-self-tests-v5-0-86f461ff1829@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3299;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=0wfULYDcviuc8Q42MEg50uyXBEFkn0s1U0Ju00N6IK8=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqS7N7gI5aXXYpEKipt/Y+w0rf+4tyX1l7Ki8bw
 zW72Z8t3PCJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCakuzewAKCRAFnS7L/zaE
 w1tbD/4wE8JoXvinj4zPJBBLSwYcp7FBOuJBP0RUkoUsk1dd3Q0MFIpapGJRoFAHKP92WBj9iqj
 0RbnaMFOUHNCfZQTgL46hhamjt2QLY5ossE5G10wD8gwm4VzdTEOQoKvBZ8fsbhPFSkN5I13CwL
 DsY0BreQaVVujM9pDByPacLGGsizyP9YKLXa4ECD7CiWG82XWDZf55J0Ybe9BS9X/qCRxluJpxF
 mrrHQuYXIaj2NS3WYV9yPZsy4Z/fya1sQzzr8cmvyKyJTs3XlfD/UNrvi+FdxA+HK5tFxP3XOOj
 HzsQjWguLUFW/k4jhGL68wWF4dAiwog9+EWWgxT1Rn7GHe+ePLyqM+ZNje2iQmBgZZw5tVxa0KY
 aM0uaM9VouCqOpNV2uT6Aq/6AufkRSVGuoi7zhnZ1HY/k/ZPotm8A6lsqplcIiuN5M6nlVCnaQO
 zlnovganI/UK4Ih8brRH3NQjAUwFet2bSOx3DWqaHAzpkBTYVu18FP4NArhC/sDOUnV1/ELfNfB
 H0tlh+SlR5r8+P6G2dK9zhhj0+LoR7KnkZr9EiRiUn4M7ThstbYU/QiEzc9Giz9rSndt2jQjIWf
 00BvHJ3fZLwzzvjGs23WkwuDB5GJuZGnf7ZNppi2nVYLwLnYySyWB23pCrb4wm5rtqAzf1g9V15
 t6sAELWLBvv/rww==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: gPHxcohxXjEURWI2e0qy05zpzNN7uzTv
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE0MSBTYWx0ZWRfXytKNe92+ipVG
 6FDNmPV9ghGYm5gBfVat+nbMks+lk+1kXYFmK+wRV06pN3CrRg+CaErBxv6jEz1495SSalXoxb3
 ecgl0Xwwpp5puv8bmNoT3HCCmvnFJSM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE0MSBTYWx0ZWRfXyGIvVpBW9eYO
 IPb4OFjG2SqptT+UZVxU01X5movtLFVetOlAC+MwJalAGna/xVhmPaB8DNPtLSzJwzI5TcRch+j
 cEbtqJtBdFXvhG8vX4oQtHIBEFTygNM4NbZYtsU2dDONrM+CklPBjJEuzrvJ/oG5ZHkh4eQ+rQY
 ua0yesCVJESQv2QvxkGgYJwVPmz9RrM7cabOL7swE7By5FHdmpLoyb95KvaVqiE+996YErtlKoc
 Y5cvCagrILUNrLZ4QUV6KOY5XKOVCpjwODb68WBI4E8XQKJF2u8FVm63dJE3E98QV4cSaOMAJph
 BlYoXjd7LZf9XT3sM6i3/8pxL5NVLCVW6fou7tl1r2jHsmbd5wOC9aPU26sKEA3ZXwxpd9MUfRH
 HQ6YCBHUW13sQfA27ob1zngKTctJp/qYkqZ4NMqHmJ4RX6LH6pBK4RMw6jsGwJTOfE13aExdKkY
 HOBAiNo89olxVkrcDug==
X-Proofpoint-GUID: gPHxcohxXjEURWI2e0qy05zpzNN7uzTv
X-Authority-Analysis: v=2.4 cv=GulyPE1C c=1 sm=1 tr=0 ts=6a4bb389 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=Y2NcAOke46LZopEJyX0A:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607060141

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
index e1f69057607fac36e8b4bdb5dd9e62a2aabe5f50..35ddbe03cfcd75db7599a5754e4ff978f3528105 100644
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

