Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27544D3BD6
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 14:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792421197; cv=none; b=EVi7zorNdFd/y/XDNpIstQT3MQzv+1YLivye3GmtODs7k1fBGm1LjpPkCH+WBmjYky3nPlnpOloyBYDIMNbT6Q2SG+lT8kt6BlCCBxpAb6wqWFs5MstXWjRsZ1KqKnS3EoVcGRVXEE6vsN5X+OZbRwIpzhcRyaWWdko+zdUs85c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792421197; c=relaxed/simple;
	bh=zaDAUHPH3FRyGvoQHOCfbxcwxcS34UzOQiDHp/EmAwY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jG/chV3arHrEB1M0IBcfn16dIO30wATjScccelQSRoRgflJjs7sF+grwdm5LffnMBLq0r8C/ld/hge3a8fkpNaDfJ7K+OLZxd0niyEik2xSyCG6IMwtVjv8Bm5OjY/LdqTg5OMxC+1aPGK6dgqY88EPKM3BaY8wVBQRqIcQjbH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=i/YqWyIm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cBpBfaP2; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="i/YqWyIm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cBpBfaP2"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69JE0Ef82971228
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 14:46:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Sis3k50GOEV0dt3wgPQ6B7BfXj0xegRMlx0JZSqwuW8=; b=i/YqWyImmGbcycD5
	x991H0FTbXVUKpn3EhIRPQ0UfyG2kbXcU4PQBDhOF3CG+DFFICNs0+HfBu7hWHk7
	TZL7waGHSHebulmfOu3VyAvQMe60wmuVFcf/kZE0DxSlCPvJSQcaHd5UkMyBB//m
	pquqL8nra2tHxK/CxLCSG1kpkKis6Z3WkdZAWIM/1pPR+4K3rG6wLIG//5HElZiU
	t27bhJjv3hxWl+xECuexu6KhgnldygHVgamPtvRKrOiMVRGS9BuvskUkAqdWq94w
	Sr4NNpLY5XKRg07HbHyN/5AX12RgjG7uW95txiUwa3TLBzERlhBQKtX+MuGdcBj0
	vIVtHg==
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com [209.85.221.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hdf3x9rff-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 14:46:32 +0000 (GMT)
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-5eac4820d15so349583e0c.0
        for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 07:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792421192; x=1793025992; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sis3k50GOEV0dt3wgPQ6B7BfXj0xegRMlx0JZSqwuW8=;
        b=cBpBfaP2SXiqTJAKUmOophgPT2rQR4oPgLT6/87H2UeXMalXw9JsLYuHwTzt14P+S5
         bS2Wn2l4AzQQi2AlzHeArrI5ESienihFpcNoEe3/tYnB3/MtAlgXuiNZ1kERGvIiniSS
         z9fpG3zBhM9KlzYaYVI/JA2dTgNwlWZENVr64LSj60r9swQJVVpk8lA2e351aW37IwmX
         dy1naL/wynMPCtgyjp3hfJ/OdbT1U6YeqxtCiVPCFOe2oyrGoSKUwzkRgw+NO/i+zSq9
         sWI73mQ/i269TPT/03zy/B1z2nWxnFpxaJdYcp/y2AycQisUzP5RZgugmTSOceGf9sHZ
         sXCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792421192; x=1793025992;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Sis3k50GOEV0dt3wgPQ6B7BfXj0xegRMlx0JZSqwuW8=;
        b=lZvAX83v8Yqsw1m/38+4e2CeO5D8OroNTZ5oXckEXOHpouPp2fhz37/rOPzWppsE/c
         M+uBg0HXYacuVL3UDo4XgmYAiY+uRZ5hoyKigeMXMA6oHbEdkl13Eew4/nN9jnSjAbi2
         u+h/+JiEylPRsmwXT/CrSrzuSSoo90KR39LnfTnnGb/Rcfq7IPWdllB5gX6bVs/WeKqb
         Kji+QP+TSnBqjmsfmgVoPCzc8kh8XM0YCZ49bopJPdByK9hlFez97wN/cJ+oL2nGWlbU
         p3WAED4VOJJF0K/RR6mf6ooq4ZbegRt+IWOSYfRSPL86BFfmDTAVm1MnRaODXyXya9zg
         KdLQ==
X-Gm-Message-State: AFq9FYITSSAzbUQKt8k/bCEECvw8RJodS1z7EI0UWG9tUUo/vOtFREDp
	+753PhzkFr1k7BgaadTr0CrhRSJLOPizmnMkUmlUxWwrPiwmm1RiizC6SNTNddkJJxH4YBUWi9C
	wpFgmzzhvAXko3YReZ62GoU6b5Ci1EQWJNhwnMpkTt19EUDRD0/XENXQ74VFCFUMDBdA=
X-Gm-Gg: AYBFou1pC5WeDeTBfUg/I/oWmEhq9UUssWYZttyDOkoTHq2jOj+TGsgOyzwrZlfeAZy
	48tNsTGEkio3/6/Cwrd+QZSjGcWXYz/rcaHK/B0tc+FfFWp4qzaZ6gZhVChePNs6n5rHHZHnhBI
	Gpn23lq2OJeujL504NiRB9IuZ8UQFccYp4JHKmdI+03hwoHSQQkNF3pQX5aRUP8kh08416GjfYr
	FAhkAsJzK7AP4X8fwinZHC6DqPS5HZ620bZlPcY08EAAarG6ERh6VPugn/7iG+U1UGRblq61upf
	0R2p5z4vSXnOnjM9vLQDQLNgFUDZBOkgVRyTkWoEbfZnD1AN+rdfOX4CU/uQRoLRy892LPhzgVi
	DGq51GdabwcDwta9hUB+Z7NAew49+
X-Received: by 2002:a05:6122:2907:b0:5c9:a60d:327a with SMTP id 71dfb90a1353d-5eaaa7a3a0emr2328635e0c.14.1792421191931;
        Mon, 19 Oct 2026 07:46:31 -0700 (PDT)
X-Received: by 2002:a05:6122:2907:b0:5c9:a60d:327a with SMTP id 71dfb90a1353d-5eaaa7a3a0emr2328621e0c.14.1792421191478;
        Mon, 19 Oct 2026 07:46:31 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1e7657d4dsm98504635e9.2.2026.10.19.07.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 07:46:30 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 19 Oct 2026 16:46:05 +0200
Subject: [PATCH v12 1/4] crypto: qce - Reject messages shorter than a block
 for AES-XTS
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261019-qce-fixes-skcipher-v12-1-046e6be9bd83@oss.qualcomm.com>
References: <20261019-qce-fixes-skcipher-v12-0-046e6be9bd83@oss.qualcomm.com>
In-Reply-To: <20261019-qce-fixes-skcipher-v12-0-046e6be9bd83@oss.qualcomm.com>
To: Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        stable@vger.kernel.org, Pankaj Patil <pankaj.patil@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1876;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=zaDAUHPH3FRyGvoQHOCfbxcwxcS34UzOQiDHp/EmAwY=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBq1i1Cz6Yu6VZa0X9xCRCFr0RQZpclyUOWijj2F
 Wy0Fw1aBvuJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCatYtQgAKCRAFnS7L/zaE
 wwuQD/437GsZskSEevZGi7dGUYqCfTfpoU1FimzScOz7rlQ3opOtlitH9R/5WjOUq670bruqIi3
 bSxU+XxuAtw6h860sK/LFNrMBaZw3CAIhD0PnJXfxSmyBuIqIy5n1mc2ouHFCslygBNDb2NCo5/
 Jms6M36yBk8jW4HTw1giMefb7JVD/g/Kcp924Nwwi5G89kvUIrd/GlFJYuPqXeJuyRjelpuC/EF
 UqkA3iWas7e4z8CB0G91DdtzC4zZ/HJW+ZTO8m8H4LWXyk8kjVcou6gMK3Ok7OctOCS7khdjGyG
 o3EKnglJDxQxLQ9WUTP8hNM/OMCHIO34p2aSc7HZ86LjSPjQlTzLbj0LQU1dKbXDTk3eZPKrJhC
 XYp40lIAHrcSgUq2NvWcxTtLZULRuwZrjLdsiqQ1fc7OvGN41Urwm4te3H7bQszsYectR/rKJCp
 CqKx/796ZjWys4o0uRMaQpbIq5QoQSK6t4LBMVGN9jHMpDcStCV6nPt3ZYZX6SXLeig/hnOY0vq
 W8DReYvz2hiiJ7taTC/gzCVqaauCN+jWYiYguukANfspKQ6kmmHVdtv/fs/a+dG/lZ8SEoE2AyU
 NnL7QSlSS2r4JyAIC804lDbYXxilaenZ/HLjt7OPM6UkOf/751pWA9ADJFWdKVjtEkzCdIJ+/9J
 gkO0VpKtwNDKoeA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: tnZwSS3flnUS7bhhOX6xPqQflHmuu1sF
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE5MDA1OCBTYWx0ZWRfXyvtbUwEs+Cob
 fdeNjSmXona7g1HuELa9PZm2SCCSjlWCNsn2a8OdhyJHRyH5IP5q2+EnshsUzgctPMbEdXTBsR2
 RsL4jYh/5nEkWJPpt1m8BJm8HE9zCMg=
X-Authority-Analysis: v=2.4 cv=XPOl2ghE c=1 sm=1 tr=0 ts=6ad62d48 cx=c_pps
 a=JIY1xp/sjQ9K5JH4t62bdg==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=k8o_H65wWHdScxXBDjwA:9 a=QEXdDO2ut3YA:10
 a=tNoRWFLymzeba-QzToBc:22
X-Proofpoint-GUID: tnZwSS3flnUS7bhhOX6xPqQflHmuu1sF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE5MDA1OCBTYWx0ZWRfXwjMdtpmzdtpm
 nN6uRxOzDLlRlS9YA9KvOTeOOhxeUIyL+KsvmSM7tNgAdOMTMrLIgJDwq/BHqn7uY7ejmaFUqQK
 em7+fhefNvGTR+5oq989RbLT4ZguQbJ5Tik3ZKkcFSJwIeKl5pqrTXXjxITqJqiywECC8bpovwh
 g5k5ZlvP0PPntfW5s323jcxVIg4FqiFu0Y3OW6HOk79fSo4J7cVFGGZ6QdX58OenRDFVD/eLYU1
 xyTczL2yH83GPu+DAG+DbBDiO1Bxmx+qOz0Goq3zGrE7McfsOPQwSQHMIE48Ou35fVVSRU2cu0W
 DUIFATDhATpDy3LMyro714d49499HZ56EugUKrIa8dQItE2d3H/HlGnebUL+ltnS8NSY//dmkIR
 jl1gaEiQ3LpLGbyG+ZSmM7t1mSSzdTVnvQV2ofba0lfKrYFDLn3R+x09gitBgGzhEe8ACWlIO3m
 ZnuHnW2ND5LV7M1f7Nw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-19_04,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 adultscore=0 phishscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610190058

XTS is not defined for a payload shorter than one cipher block. The
driver treated a zero-length request as a successful no-op, so the
crypto self-tests "unexpectedly succeeded" when -EINVAL was expected.
Requests of 1 to 15 bytes are not rejected either and, when they are not
diverted to the fallback (e.g. with aes_sw_max_len set to 0), reach the
engine which stalls waiting for a full block of input.

Return -EINVAL for XTS requests shorter than AES_BLOCK_SIZE while
keeping the no-op behavior for empty requests of the other ciphers,
which the crypto engine simply cannot process due to its DMA not
supporting zero-length transfers.

Cc: stable@vger.kernel.org
Fixes: f08789462255 ("crypto: qce - Return error for zero length messages")
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 03a3cec2bb90e8d8c17e491ca40ec740a003d1b4..d9a5b255015341e741515bdfd6ff54bd3b24f1e3 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -221,6 +221,14 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
 	keylen = IS_XTS(rctx->flags) ? ctx->enc_keylen >> 1 : ctx->enc_keylen;
 
+	/*
+	 * XTS requires at least one full block of data. Reject anything
+	 * shorter here as the engine would stall waiting for more input if
+	 * such a request reached it.
+	 */
+	if (IS_XTS(rctx->flags) && req->cryptlen < AES_BLOCK_SIZE)
+		return -EINVAL;
+
 	/* CE does not handle 0 length messages */
 	if (!req->cryptlen)
 		return 0;

-- 
2.47.3

