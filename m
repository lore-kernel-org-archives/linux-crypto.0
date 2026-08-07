Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C673F44D6BB
	for <linux-crypto@vger.kernel.org>; Fri,  7 Aug 2026 06:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786085705; cv=none; b=PiUxCj+ALQHJPamtI+7fTb4rM4S2gCTd625CwlnkisELInIzYgaeKEhzKl/qP31waQHmWcxoHKBnQRswzreUQaLlYvoNNpc5r6kFsPe1GhuoSEp26AyTNXBkg1Vib9tDuxc+xtX5j+pKM1WgxO6HhMtnWpjorVhQ6H48yLfGS/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786085705; c=relaxed/simple;
	bh=m20Kh+H5fTlZZTfVLpqUKggHmNyF1hCcSM91TM5eEDQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=um19c3QkbCTk8wrdla1dD14i8islMwwOGwKDrvZ5oYXXtE1Hfa2PChwKBCt9lOjBPPaYrJ8OGnZmDtOSV+YxwOxxrSMk/sjr0yFuLUvbMHqN50plPV3BM8F3WILe+V5p+8VDssFx4wn0SrAJQc63OuclmuzpQEMuOd2T2Th4pHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LoPe48Ha; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=f+l54195; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LoPe48Ha";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="f+l54195"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6770Gaue3176962
	for <linux-crypto@vger.kernel.org>; Fri, 7 Aug 2026 06:55:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=Kwl3nXu9nwinBsOKeAAPgUZwJmzbHnalLoK
	uzJgJHQ0=; b=LoPe48Haz7AG5AKKt+S4Qupq9tKhEVkTfG7eM3nddK0mqUB+Wfh
	+0ime4awFgP5mlfwjSvX6GT6krGOjVW4uuc3hED397RQ25k+ui6UH/ecy5sFBUfz
	MK/BX97B5QTx+NRXkJeNXLa5qTcVFb+ODWie/LwGIo3vl/jSmw4tXw+u7NQkFWnO
	7JcdZ6259ch30gEz/aWYfCM7azVCTgxV2a5OJuUAAgHZK3rUZvbfqWEFsXGvANBt
	OxSPCCs2BRsMtInQf9S0uCzmWcg5ogoVZKxdIcXBegszYBgXOiV6RnZUm0gj59y0
	9Gwwd6selKKv02Q4EN6LdAdHqMdMTaadzMw==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvy6jjkt9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 07 Aug 2026 06:55:03 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-848568a6f62so5122646b3a.0
        for <linux-crypto@vger.kernel.org>; Thu, 06 Aug 2026 23:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786085703; x=1786690503; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kwl3nXu9nwinBsOKeAAPgUZwJmzbHnalLoKuzJgJHQ0=;
        b=f+l54195jiR6I52XIKM0142OvKODhQbxxcxeOD2bL78OLxs/iQvnzUxF63FxQuCz1S
         af/Ft2QKApRviIm1WJLgDVGO148pQfiiMBhkwBH+sCOCQsBZCIkH6EF4EWdekNan9w0Q
         YyIRP5yeGUzhkIvbujpoesz08dx/BOX5NQK2CsyO0K8Nt99NiULs7GQNZIUN4QsDn2ZT
         ArKcOmJNbonj3T1zLZvl0wY6lqpR22lATYg+fTGB1yt/cwwZJldA+np1o7+6nHvOXBSe
         QRKH9AFQoTaDf1BTuqQeS/EIU4cirrv8f6sVkNxo85GE9YG4uh/PlbXn+JUyi628ynDl
         b/2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786085703; x=1786690503;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kwl3nXu9nwinBsOKeAAPgUZwJmzbHnalLoKuzJgJHQ0=;
        b=bd58ZJVxRv1ccZuyu0XDwDIYQdU34dm6vsCT/xKUblmHAoQwQBKvahkJIB3oVMtInE
         MJFmN+MKOrwTPaBKvpLLToC7bf+Bt1QY3iCO3Nm44515ChPU11s2K6d6DJptZ+PBreti
         4D9nSa8Pln7D2r52ybfy409M2aTOJYExD0MwCrWclncMIFDdJSJio88081lppw2VevCq
         TEFiYsOqj3Jz+KL17T0pojY8PghGwvkrebbTsF5lVz1DoNC9Wa20bbgAs7ClrxFKn325
         2NrAcn4YnS64jlpk0UU9lzrbOk4WlL1zv8MNtHnGx+gGIxXfWIuGTOhcqi+IZ00jBV0s
         QdCw==
X-Forwarded-Encrypted: i=1; AHgh+RqU6F93enShoK8BSO0giJhh8uObcyIx/ctOfzNL7O7PHC+jnN2HWf5JUgKK1BEFiHJB0sYR4wGl6Px6oHc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLHMZBAHwOS5PORHx6S08QaA9p/2yx6EDBOzVGNoPJJrIPnmQf
	TA6P7ZmEjIg4bgm7c044wiECjAR+VVUbRdS5QAiEqz077CCkYrrW+9qvh/vxSXB5rQOiQGSCSiz
	eNpNu3+Qt4QN39clTOqB1WB6/5h7/cVaOo3nBDomaaszpHW36zIUJUEBRrTU2ZmVrJZc=
X-Gm-Gg: AR+sD10lBGCa4jpvaAGNk4Xc6OZbGPVYcm+B/orLkFPfz1hW3FZRF6vWtRTeVl8EDRK
	0xCuI2SZQLCbNvOFnE9cXTBiMtEa5grrI4HwJN2ckCSD/LNtnEe9BUFttYSROWeKpIs5xI/P2Rh
	cda4C23+DRmSIEl9tFlf2yGo7VnXvPQ4r4avtNuFXPt7wnf1B6KXRdj22R6+17ZOa+8iDfFaPl5
	3olsIbjzeaFwz2UHPnW6Enfm4U7Onrvhzh+v5hjNrzAWDcDMhCuKCG/imFMiUSuNQ4JoUVfO/lg
	saq/xlbnM6ynOqQmDWnannHJNlZ+Z9G3Ow6NbMIkzVeqAzGdKgrSLTUDC/KR3N/KNKdBCx/MG+x
	EXi9EQvgoY/nk43jod9Da1i7pVnPQFZ59zBnNv4iHLsKYqJFcMbv6sLHUwmv51VLny9a5Hk4aPM
	qDsUgUyUYCt8I=
X-Received: by 2002:a05:6a21:6e92:b0:3c6:61c6:8970 with SMTP id adf61e73a8af0-3cb85df2778mr29200668637.14.1786085702564;
        Thu, 06 Aug 2026 23:55:02 -0700 (PDT)
X-Received: by 2002:a05:6a21:6e92:b0:3c6:61c6:8970 with SMTP id adf61e73a8af0-3cb85df2778mr29200425637.14.1786085700148;
        Thu, 06 Aug 2026 23:55:00 -0700 (PDT)
Received: from hu-mdalam-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14101b95b20sm4064525c88.15.2026.08.06.23.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 23:54:59 -0700 (PDT)
From: Md Sadre Alam <md.alam@oss.qualcomm.com>
To: brgl@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net,
        thara.gopinath@linaro.org, linux-crypto@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: varadarajan.narayanan@oss.qualcomm.com, md.alam@oss.qualcomm.com
Subject: [PATCH] crypto: qce: fix CCM AAD buffer underallocation
Date: Fri,  7 Aug 2026 12:24:54 +0530
Message-Id: <20260807065454.1640815-1-md.alam@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDA1MCBTYWx0ZWRfX+n0CzZfcWzrq
 wX4fvDYNmcqiM/M/LWf8EOg3mbiaYo2xkuwXJWSIbvAZfbZEywngOGA1dAn+Iaa0KOLxTBX7twS
 nj17lO4bPAGhbEgpVeeQO8RI8kFvVivtmjtJdDDe/zWZAvoNsRMqLJz3TsIvIynWsHeGNk4xVzp
 fS1WZAaOwh8Na+NXHuM/4x75z/Tdot5HiFdMtqe3t7cs7E4qyGP6GBSbyJXeZKcSUKiJqLuOg7n
 ftrsAYZGsXFIybDITjk1KB0lhXtPiJI8lcR2YGlBTzcUcp/d4K/Fmvn8pCnsc90/5iBqawkTiAs
 MH2tywGhVnd9/gACNKJQNWCiyYn+lghadotiY5b1en4Hdo6vvd46aTSKmEwAUtavx/CoaC5dYBJ
 /n3nQL2jwkoobWK1IbkemJzxBV5qaZbfQW2L9/T7JhSMFYW3gH0ygP10w+b4tL2lVgyzhmnxL3k
 Fm8P89Joj3M+t/7J+ZQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDA1MCBTYWx0ZWRfXxxSGDijYLW+e
 tOM/ZI7wRdiP3ypnfG2xBuD1dPtx/B86SIKeLf6TDXqyY0r3CGOPoXsgATaE3Uc511/yQ/32yxu
 tYWAVMliInuDc7+BjTsbgHuRHSTrWyM=
X-Proofpoint-ORIG-GUID: qqDf69uToBqujhoGdVcsph3v0np0q4pu
X-Proofpoint-GUID: qqDf69uToBqujhoGdVcsph3v0np0q4pu
X-Authority-Analysis: v=2.4 cv=e5Y2j6p/ c=1 sm=1 tr=0 ts=6a758147 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=8zGforoG6dPd7syO8-wA:9 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_01,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608070050

The AAD buffer allocated in qce_aead_ccm_prepare_buf_assoclen()
can be smaller than the length later programmed into the DMA
scatterlist.

The allocation size is currently calculated as:

  ALIGN(assoclen, 16) + MAX_CCM_ADATA_HEADER_LEN

while the DMA length is set to:

  ALIGN(assoclen + adata_header_len, 16)

Since ALIGN() does not distribute over addition, the allocation
can be smaller than the DMA length. For example, when
assoclen = 32 and adata_header_len = 2:

  allocation = ALIGN(32, 16) + 6 = 38
  DMA length = ALIGN(32 + 2, 16) = 48

As a result, the QCE hardware can read beyond the allocated
buffer while computing the CBC-MAC over the associated data.
The extra bytes are folded into the authentication tag,
resulting in an incorrect tag and causing CCM self-test
failures such as:

  alg: aead: ccm-aes-qce encryption test failed (wrong result)
  on test vector 8

Fix the allocation by adding the maximum possible AAD header
length before alignment:

  ALIGN(assoclen + MAX_CCM_ADATA_HEADER_LEN, 16)

This guarantees that the allocated buffer is large enough
for the fully padded AAD data for all supported header sizes.

Cc: stable@vger.kernel.org
Fixes: 9363efb4181c ("crypto: qce - Add support for AEAD algorithms")
Signed-off-by: Md Sadre Alam <md.alam@oss.qualcomm.com>
---
 drivers/crypto/qce/aead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 92d84941d3db..a9642c67f476 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -196,7 +196,7 @@ qce_aead_ccm_prepare_buf_assoclen(struct aead_request *req)
 	/* Get the msg */
 	msg_sg = scatterwalk_ffwd(__sg, req->src, req->assoclen);
 
-	rctx->adata = kzalloc((ALIGN(assoclen, 16) + MAX_CCM_ADATA_HEADER_LEN) *
+	rctx->adata = kzalloc(ALIGN(assoclen + MAX_CCM_ADATA_HEADER_LEN, 16) *
 			       sizeof(unsigned char), GFP_ATOMIC);
 	if (!rctx->adata)
 		return -ENOMEM;
-- 
2.34.1

