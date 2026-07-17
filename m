Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958E83F8EA2
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 15:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784303642; cv=none; b=miJBAZQtILARLedxfR0ncktPA65ObdlPFn6QIONYlYPKpmphM3dQlniqM9V23n2GthqzDtCwtqR0krrxxhVYcSpmONNHSU/ar+TUQG8lFrmRkEq7Ivb9NjS2Rtch8YAVR9U5vYVv4IY0YHqt96zIDgwG26x+EpQgbagQbC1q8aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784303642; c=relaxed/simple;
	bh=c+mrubN7rsfOnXUrhAmKfIPiEiFtp1qvBtE3BukFaZ8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=R+fqMLO0Ajrn9V+5a2qIOdvwxq1EWCWvnJxxTlFJEFeWHlaSISjLRwbhoVmDkgOKoyZcWc4ufC1KMW+GKZWXwXVt5aZaiczqB9FHOMTu7QjafUPmumTogQbZmNLVG039B25tDVQ91I3BJaysnhesgHt6Fgbqd0c29pXu0ycwBv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CZ6a34Wi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=L3CC+iJ/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CZ6a34Wi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="L3CC+iJ/"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE7p701838841
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 15:53:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	su379PS4fCpra/SUatLozY865KIfA6SXq4/i5am3Thg=; b=CZ6a34WiUw/WrrZ1
	N61tgxau6FXPk/q7pIv+pdg8r0hthARXrJURahnhsibXj26LmowiSJ0By71s8Th7
	jfOHtCL05JXqaP6lAK+JekQ73R37CQoNF10yRJtgp4WnoKMkaobF2H5k6iC3iQ/o
	zET6TppVxmqlh87vB2T2qwhSh5ZNkkU++kE3iN152IP/aoiIHq73TsqUsNvDDOhz
	JHMwPM9sigvU96np1ZbbbHQWyU+ASHWWeRqtAUibDq55cPdFO/TcYpKuyRjwMHK6
	1e51lF1KPgKb9T7BJXZJrtHb0Y05+YOKaR8wxbL8tEv9QgNBNabmnGnhPPwqH04o
	7GkVLg==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fffaga24t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 15:53:59 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c083f1818so85431091cf.0
        for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784303639; x=1784908439; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=su379PS4fCpra/SUatLozY865KIfA6SXq4/i5am3Thg=;
        b=L3CC+iJ/0X1zPuom7AYwanzoc5Q07W8PVFzp6pS3cKQH6kjEO7Na0VNaId5EseEuCB
         xdXNDQxKJu5xneMQYn+Vtn20q71pSQSeR8UbUbGcsiCw1hryi4MfPLJ51DJ70Vq4kbYN
         IlsTC+9vBwX/4VrGHuzpZn5zEK5qYx7iS7uHIFDzJ28xPtRXI4kD9feTDsTwyCK5ldV3
         spcR5juK6Cq/c1tMa93aJbXN2mbtaJS09Tp4pfet3fa3crKgT4oF13AY3Apvc9TDyG8P
         hdsmt8q3ki2ImCz6DImx5xOrq2J4uj+IvL0C5p/nd19E+GwO5cp9iOZCoBt1ZPpsL5lh
         3lNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784303639; x=1784908439;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=su379PS4fCpra/SUatLozY865KIfA6SXq4/i5am3Thg=;
        b=Ceh4w+5CVEal+Omw2h9EN/9Qj0uzRKKFtcBe9Ulrtj/toBWYJJ6cEamf3P1r6KnLT5
         l99covz1eaQ0f//QX3opg2DMCAO0ggL6RYcm8wA04wwvLE/6LOHnkAdyLN2yyfFCWmpv
         RqS7Zw/+6jc5GyJObnxseHZPsV1YYhuYzwb+qQm6aWbZmUr+JSvI1nJdlZjYaJaZXdnc
         Ad1HoUKvKtbl+KH2KNii+NysQXeZ8Tet38FhmF3K5eIqvzZrSVpxFPm4XNERzg6cHPWC
         o5P0ptqRUwC+PKgNVrZOzD9pQ7CKR2I2S9S3FzzBdmdEvA3PGT6iFuamDtNEGD3iUIjd
         0g8g==
X-Gm-Message-State: AOJu0YyvLx68bwOAaUS+8PQvDzV9dVF25jwKaYPeWzhhPZlLHnaMrQ4T
	XASlmTBGFto4+kGnMg57PVdA+OrinqJL4XC1jm/PO0cxnpKhX+CmwsWTrP9lmX2dETva/S2claS
	B7iZy0e7Dzi7xQ6ookr12k9Te/SzcWHtIp0GK1Ld3HuJOdT6sZrUHoY7Tgt0oUlDfYNG7elMnCW
	8=
X-Gm-Gg: AfdE7cm2f7fi2fp+2Ozi9iEFm69EW8fLdGdTe7SP5IdvaF4K9rVfzcACQU8LwQttpLP
	/1WttLB41MBeXCw4SebQzZi4nECjgvdj2ymePmukHzLh57Dp8AOVKtPDnjd3Wd9sCDGq5zQPRz/
	94tz6A1zd7CObt0GjJ0wiYm/Fbf/OxDefPKWqcQAEHootUrEvQ3DU5CgSeKddrdiyygdFKDd0al
	C+BIDOWalkc6GCjjyboxyCv2YDayLzh4+46ImfBycKIGp3dVbXyJa55XA6yFuKbHyGFDeOqMf/3
	DpZu3/Gugzvhe7jusSNucFlquFk7T90Grd7beuznHTqy86Su/fLW07mGrT7xn2f056AQ1+7F7Tm
	hNXk18z9HMw6ZWePDV1MzYUHMX2iT6g==
X-Received: by 2002:a05:622a:c08:b0:51b:fcb4:7576 with SMTP id d75a77b69052e-5213aa6e50cmr27491221cf.15.1784303638599;
        Fri, 17 Jul 2026 08:53:58 -0700 (PDT)
X-Received: by 2002:a05:622a:c08:b0:51b:fcb4:7576 with SMTP id d75a77b69052e-5213aa6e50cmr27490921cf.15.1784303638195;
        Fri, 17 Jul 2026 08:53:58 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:dc44:5b1b:5396:79d6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2a2511sm47057095e9.1.2026.07.17.08.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 08:53:57 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 17:53:31 +0200
Subject: [PATCH v6 2/8] crypto: qce - Reject empty messages for AES-XTS
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-qce-fix-self-tests-v6-2-455775fe5f6c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1491;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=c+mrubN7rsfOnXUrhAmKfIPiEiFtp1qvBtE3BukFaZ8=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqWlAJLk8kf+WO4QPge6zzsH6iLkYm/a4I6uEUB
 rNcxsO73RiJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalpQCQAKCRAFnS7L/zaE
 w08EEACNbC6vHABktCcrqSfMiYaJc6A+6pG66OGWUFdrHM7aOGe2iQwkorloHgWFT5SCmPQoQQe
 3Yiqy1+ewkNYT3hUZIIc/5TB252yq6PL92CZGpNLDB3jyR3OX/m2XU16Dg1jkrDhEyUuq3BbfR1
 Iv2oOUkByizuoYqiMcJjwIk4kbKwKJ1Mr3PEakYaNNCiePr4NhR7Is7gsjF9Li4muP5BsaaK5B0
 gp6n5ty2GyW7HFEI1Fi16TLsk/yhgoR6OFrNiMz5eXrUw5S/k9CpzjS7CnjcJQ9io0c9Yh8QU/U
 wpGjSFGU37L/2dfozPJc+cUKOB7ZfgEivyeyH1Znua7szBunnLROQI3TWTrV2oQU18kbMt+EyIU
 48NS9NgZAStB1xiAQgtbe1ElOj9evZ76TqRPVdZuiaJ70lR5/AZ9T1kNjWyPk017x8YI8ce/3Rq
 Ezxk0FZU96CzWaEo7QgoCMYRI73WqO2lZB0rLGuqEt2UdWqFUjKD4t2pc9tJoQ24+HD0TWVF+b2
 OPlK7cy8skUC9DR0vg5+uKTwaTC/BFM2CP1qhkJIDAVU+RFbsnx52wgt0ktXlmqUIF5Tr1cP4+v
 n+KwYRFbxSdXFAXFUGoxACXWUNWVv7c8aakCie2VZxZUQn+QprmhyUgTuiU7w6E4U4PLM/fjuct
 VGupaDD8FkAt9kQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE2MiBTYWx0ZWRfX+5Nk19Z9QtpO
 W61PvrY94Iljj0Pugc/NGZHgT5oSPL/zfG+5aYWcc0i/UMLEHygzTv5ZOs/0GbdodzKqd9NQnyu
 o/CYmIN8gFJuC8+rlQQ2kp/a5KnayqqCEHTPnQOoPVybm1mf+J683Prs0VUUuNJOaTDqiG9cXrV
 SOOc0sDzIP/WCW5baAvu1VUNtlA+8Qd1UrRe8x+al2gK95H0wbfUx5O7kc12GCOIWdCqD1ILa2k
 /mf8jpuq2MTWFBuFMnOgHnr544p4C6wzdCUcOXyp6jlHpHCRgmEHEUTsCltEUG9MwM1ghQfYbgU
 fA8413xs5M7kg+F8xnYan+waaf/CLKvYw/FkmcqVf6s8UY1raia2D4Jk8dBvTqp3q7TipRlvj85
 H0Ki6/+R2tvL7CxpD7fYIPX4qW1ldWqjc2C2WUb9lZdKkneyEoFyzeIMQawWRLJHVaszdDqKB8W
 nfi7/6fjkznn8R8UM9w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE2MiBTYWx0ZWRfX8WgbuIox36ZC
 EugIcaAmuMmJmnr0vPqbu2aY9U8HSBwT/hpe9WCg59Gp52yEGcnfgcF5mPhZXYOTNxEswdwyZla
 Tny7cOtj9cDeZvySiAFugEqANH/A6+0=
X-Authority-Analysis: v=2.4 cv=KZfidwYD c=1 sm=1 tr=0 ts=6a5a5017 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=kiYxeA6Iecqc4QeK3QQA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: WuWjrW6RVLkO2tBYEJHEdXu8-RYpe3jh
X-Proofpoint-ORIG-GUID: WuWjrW6RVLkO2tBYEJHEdXu8-RYpe3jh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 malwarescore=0 spamscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170162

XTS is not defined for an empty plaintext: it requires at least one full
block of data. The driver treated a zero-length request as a successful
no-op, so the crypto self-tests "unexpectedly succeeded" when -EINVAL
was expected.

Return -EINVAL for empty XTS requests while keeping the no-op behavior
for the other ciphers, which the crypto engine simply cannot process due
to its DMA not supporting zero-length transfers.

Cc: stable@vger.kernel.org
Fixes: f08789462255 ("crypto: qce - Return error for zero length messages")
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index b27008ace93a8a40c291d564c3fb9d73df5447ec..e1f69057607fac36e8b4bdb5dd9e62a2aabe5f50 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -223,8 +223,12 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	keylen = IS_XTS(rctx->flags) ? ctx->enc_keylen >> 1 : ctx->enc_keylen;
 
 	/* CE does not handle 0 length messages */
-	if (!req->cryptlen)
+	if (!req->cryptlen) {
+		/* XTS requires at least one full block of data */
+		if (IS_XTS(rctx->flags))
+			return -EINVAL;
 		return 0;
+	}
 
 	/*
 	 * ECB and CBC algorithms require message lengths to be

-- 
2.47.3

