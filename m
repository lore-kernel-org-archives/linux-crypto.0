Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9A94C7557
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 14:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792159927; cv=none; b=ECHzk7WdZva+kRqZ4PyTijUDsZyKtZVqwj09PaGUYIV0cwG9dwDerwP1u5RFrUTPjKMszvMu5UBv6PnO0n+9e7hEL0XUlX/lfxe7aB78c9FF2teAnRrm6ICvxvqPZJdEXswpJwjs2AkVkiptzL6dI/uPDDKgzag8CXz+AA3ql04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792159927; c=relaxed/simple;
	bh=PLKMvG5hyotQDMRVcZZ8iNkIZWwNLAYfcjvBo0H08q8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Mtk1KMerCY8Mz+LGdXfyIX65kO9i9vrIkQsu9aMFUucmomSLegt9KoTnYaQ+jYHB8AwjguVdL+UdA3UogqohF6YJH1mdt1eqIKHmP2cOXQ2LCIvS2ZQ/R+hgfTL/ui3WObM1SuRzOo/66iyQcxARkqm28os7LPMmxn+fsKgIQA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PAsqdvf2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RSDkkA+T; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PAsqdvf2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RSDkkA+T"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GE60Xb2301988
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 14:12:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Cgh66chNi6rdMtMPBnHowPkYFSFoeuEVr7iErvjPiLo=; b=PAsqdvf2LgaNy4uV
	d1KgRfGSWxM87rPVtEM8va0f2J1zmL88i2AKebB9TZtt+B04w2/3bYUgdVq9pYWz
	lUxhDgDJgwCj4LZyqI+ahH3khbQhgyjvBuZzfYww1CT+CakFQYp6lzVq5iLdFCSz
	Oz32Qbp/wNmPI/GLxeijaFn2PFnpz5qMq8NuCY2RMR7zwTnihlos6aChepbYt/xN
	5rF41ZfuQStxt5wsZ3K0GbCDEtNxL0VCgK3CipvmkFUYvclepjnfw/+BT1Om/9vJ
	zXAbVmHom3n7WzWXwCFTCyIGkyy9MX4nlgWq2DoVKgziTUSP7CalAFcdyza4gLcd
	CUiUXQ==
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com [209.85.221.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hb3sev2gy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 14:12:02 +0000 (GMT)
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-5e6f7b15640so5533693e0c.0
        for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 07:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792159921; x=1792764721; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Cgh66chNi6rdMtMPBnHowPkYFSFoeuEVr7iErvjPiLo=;
        b=RSDkkA+TqizFHMPpRpePBk0o1M6Mm07BsWxB7VTDZwUnPPFf/EM0xBr/IKdFtoUU45
         KTbv5cHs79Z/8MvcNxcom9r5sBP0n2XKXk36cIn/YMXRKe4v959qlP9lm4bjAL+sYM5t
         3S1Ux+3alPVm72rt0XmCqX6Aju5uV2K83b3Jv8ZehFc6LZnPcn7D3J6WGtwxffT7Dkto
         s6DHl9G051tH8rqI6Y7lNu66YGhd2SYn3AGxMlVRIezXJjCBQXcWymDndVKKIgs96TMN
         HuAy7cObIaJq8PRXdC5es8chkcanDsUMHpW1gw+l2/9Lp/s6CSK+5UuI8Wc6K3dVD11w
         +03g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792159921; x=1792764721;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Cgh66chNi6rdMtMPBnHowPkYFSFoeuEVr7iErvjPiLo=;
        b=H8+9XUVnSv+/8G3efBATsDcMXvemlOfP4KuHXGgMzKkIOEJpkf9Rt9yfx4zr6sMw3w
         83bukHUhksMH8IJUSFpLq86rEu138FgkEUuQyuiMubeL0KCWR3EXo4Qsh8IlQEBWD+i4
         gp6cpcF5svY+6VNvWkFv7++UdaE5dwJsQBuJe0oD0JOKY/GNdUVVLk5odBIeT5rgdin5
         6Qw5J9ExYdt/6C62hAyXps0mJmo77kXTFKcStIzHpkrp1OQBS5cXcwVcgsxomzQM+3h3
         NeLXGgZeL90rHWH6oXMaTmfSkvHJaSofOkNsDtN+Pd0DCO8eJbyyK61zxLFnfRRam3bt
         dPiw==
X-Gm-Message-State: AFq9FYI6slXxCcdkXxCkLnIROBiHFOkdp07vl8ML4vNY/3bwLq4NNZgd
	nOpWhNWKEAYZ5H/VFfWCbjxIw0gK5cDg4tJFwI1GfhwkWT2ZF+AjlSh3fKG7osye7hgkd01wJD2
	vu9u9PcScP/Z9Bbu16zaZQT9auhwSIbTwMyO0wlZ6TCVDwT2HXjPO1Cg+1344eOzLAco=
X-Gm-Gg: AYBFou18e6Bi/3XFouSz760dBFE81hLADmz6Mbh4YFez5bvvOy4TUFbGQUF5fQOo7nY
	GBjeu/pXwvO4cC2IAPw45AguoCazuxvXIrVCVVjkYOrwyOL06+bXvOd0HOaowuuJEz5z/+qU4MQ
	ua8gEQAoOyNfee//v+tVsOVQ/ePjMuy98zhVaEdVtKWFMpkquUGgS5mOrFvt4ETuc227gar3F1Y
	PR0Z9dl9cjwHKDt5Djvx2HLnrJBupMyvwAbc6aYXgPObxQNxkZgN3fRbcuKBnsfYJw9WE60AiBp
	P6KKm+410HSz9L6qvMBuXG6q/SzPrWEAYliSPmk3mr9+RgHbe5k9Krp2Q6jjP4DTXn5onN990z4
	8yqXTCfDudS3yfFsbXUumThR+Y5BP
X-Received: by 2002:a05:6122:1782:b0:5e9:3144:427a with SMTP id 71dfb90a1353d-5eaaa918625mr50079e0c.19.1792159921503;
        Fri, 16 Oct 2026 07:12:01 -0700 (PDT)
X-Received: by 2002:a05:6122:1782:b0:5e9:3144:427a with SMTP id 71dfb90a1353d-5eaaa918625mr50041e0c.19.1792159921032;
        Fri, 16 Oct 2026 07:12:01 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4f8babsm5760145f8f.33.2026.10.16.07.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 07:12:00 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 16:11:48 +0200
Subject: [PATCH v11 3/4] crypto: qce - Use fallback for fragmented skcipher
 payloads
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-qce-fixes-skcipher-v11-3-d13ddfe609a4@oss.qualcomm.com>
References: <20261016-qce-fixes-skcipher-v11-0-d13ddfe609a4@oss.qualcomm.com>
In-Reply-To: <20261016-qce-fixes-skcipher-v11-0-d13ddfe609a4@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3507;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=PLKMvG5hyotQDMRVcZZ8iNkIZWwNLAYfcjvBo0H08q8=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBq0jCo3pAMan40/z9UMiqByq0ZVspFfxrqhiBE1
 n/mTvdMtZuJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCatIwqAAKCRAFnS7L/zaE
 w8iUD/49hMcTKhTSHUaF1cuIalNVjPDNk0o7rQm3koAyMyEAXNQE6iBus42vBQjq9nxxQgxLULy
 picWDeQu/tDBGhX9b3w+GwAUO8fAv4OyWi0kUNx0Tj9NOb1ExLtsyeHRP+4cBTwBiHdyVoJ4/l2
 MkT/qzXNBbOwn95d3SGz+3jqCnMEhXqGvaEeHx/khBlcpIR4UYXEEETP5x8wBZVhonkIlvPJvso
 xas3heMDCFw76+o4TYAYYJHxx/B2WwJ4ps1PnZWDkv/xOEjlb0RRbuZp7+ijYRf88dGx2x1phFT
 mDbnloS/rERP3h/RqsTpn/H/0oXnH9mEOYq1wpdDXxwdnSl/WBLixxe9QG1jP3ZSkhWEUN8greK
 He5sxwadiuJgXd3yOrrK59VSJQnsTqNUw0piWeaLOPh/i+rSqqjeudFyNzdKXlAZTjd0eeqfEAd
 e53K3L8+5knVDqtGKrNdgWlUzFFKCHLdDrC2DOvWuVwGEAkHPEBEtA33brsl7E6cua3br9CausU
 N5AUlPNuksUHiUnuBvYwelHLsVH7HOuT072r6990ru4mh60v4PbFA37FcTixTBIpaq37Tdyc1fZ
 zfCdnmZWjAXOAAMXINacruOFAUsPkfV4TPqOt2ZdJZrQFrvYOAmAkHJu/Nmq+QCPYSalv0Yn7Cu
 F2ITHRNLceVrygA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: dplaUjbj1pLLUqIBQGu460a4W3KJ4fC-
X-Proofpoint-GUID: dplaUjbj1pLLUqIBQGu460a4W3KJ4fC-
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1NiBTYWx0ZWRfXwJvVSjHY+qOL
 B4kiy4dwTzOUei3OWThTJvn4pi2TuSIQv3HDCBcHcT3gqqA1b6XCJjmRLc5C+VIdyWlctWUujWu
 3CbanfQjVh4CLaXOdIVz9k2kAKql+hY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1NiBTYWx0ZWRfX6krPZKd/lSN1
 baB5i2ZFvPHEah/v9SNnzTgUYTtmQ9nWlL7RNVf9w8vHH829GlPTxo16AsDUR82Y9YuINR1MpnA
 7KOPMUPmYp69syQJrlieB/aTSMSKjY1ZoL9FrpqjCozSr5HFZ6PglYaMNw3ned1DH0t9DNOmhHD
 7P1qTxl+rjwirhcLGQcgLwjex0DVQQ2QH5hRbrF0ryeIyJDIsB6RM1yj+4ajOPZGWVfCB1PtLh1
 RIIy9gCwnMIwilC5klyBm5mk8cYeDfwCJu9xPiQon5YXtlFWGFk5XOfe4APZ5rX5T2iuj7ebM4M
 iwXiPtOMnW6QD2UPCa9nbK8G61zFp7Hy0FaNSH1OlJnPkQ0L/dTL1+0vympzEU6nZ3+4UCg3tl+
 DbdH4lf+Zsy8hzDrIwuhm1+P1AcG/ELbZ7O2tXSCG44P1dgoAaxZThfV42iDqLUm6RB012BaEKc
 k5N5/Jo9rwvlY7KpXQA==
X-Authority-Analysis: v=2.4 cv=Se1i5fRu c=1 sm=1 tr=0 ts=6ad230b2 cx=c_pps
 a=wuOIiItHwq1biOnFUQQHKA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=0H9NDlJ9gza-_DYZ0SQA:9 a=QEXdDO2ut3YA:10
 a=XD7yVLdPMpWraOa8Un9W:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_02,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160056

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
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/cipher.h   |  1 +
 drivers/crypto/qce/skcipher.c | 13 +++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qce/cipher.h b/drivers/crypto/qce/cipher.h
index 850f257d00f3aca0397adc1f703aea690c754d60..daea07551118d444d2f749588bdfe2ae2c6c553f 100644
--- a/drivers/crypto/qce/cipher.h
+++ b/drivers/crypto/qce/cipher.h
@@ -14,6 +14,7 @@
 struct qce_cipher_ctx {
 	u8 enc_key[QCE_MAX_KEY_SIZE];
 	unsigned int enc_keylen;
+	bool use_fallback;
 	struct crypto_skcipher *fallback;
 };
 
diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index c23ebc61873f1c542a4b475904c3c3a3d89bcc35..0473033db2af90e119b731b9a6ec96de5973d3c8 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -215,7 +215,7 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	struct qce_cipher_reqctx *rctx = skcipher_request_ctx(req);
 	struct qce_alg_template *tmpl = to_cipher_tmpl(tfm);
 	unsigned int blocksize = crypto_skcipher_blocksize(tfm);
-	int keylen;
+	int keylen, src_nents, dst_nents;
 
 	rctx->flags = tmpl->alg_flags;
 	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
@@ -237,6 +237,11 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 		if (!IS_ALIGNED(req->cryptlen, blocksize))
 			return -EINVAL;
 
+	src_nents = sg_nents_for_len(req->src, req->cryptlen);
+	dst_nents = sg_nents_for_len(req->dst, req->cryptlen);
+	if (src_nents < 0 || dst_nents < 0)
+		return -EINVAL;
+
 	/*
 	 * Conditions for requesting a fallback cipher
 	 * AES-192 (not supported by crypto engine (CE))
@@ -246,13 +251,17 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
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
+	    (IS_XTS(rctx->flags) && ctx->use_fallback) ||
+	    src_nents > 1 || dst_nents > 1)) {
 		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&rctx->fallback_req,
 					      req->base.flags,

-- 
2.47.3

