Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AAF4BD0F1
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885505; cv=none; b=Q4PW5umSvKIodIcBODQVQJGGi0mO1wgDwGdF34qjq0EB6qb2KbqxTsI0mAMdQ5s5jlmX9OARhlOCkNklLYu85GXnRg9MGm0SbBO5PQvX26gFwd4YaFKCL0ZoC5+My27YI65chIsxP80D7hl+Ga+hMdG+GkoNphF7XVdrbti6JIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885505; c=relaxed/simple;
	bh=MLtXfjdlvx+/YwSM8zES/jGUYMWSXbIwKrH/OXziqaA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pevddEqDApw2iDuHqiHkCdARLlM9W2K4ewC0+/fCOLaScLAuQlUIKNlKmBLHkKWbJOC1zNRAwX15mtDHZcCRX/cT3yGk9+rMfh+/jXL1l754th4xgnnVNsU2IdvWrG7V/fqZY4DQoW9RmgG4rAeBBYw4wVLOXrE1EF8aLnPI6h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EA57nKzw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NejWCgB7; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EA57nKzw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NejWCgB7"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D6YwnZ3208446
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XJVes0YlmH/V9R+5fIFgbCWrnbNrzQD5kF6yClXGPlI=; b=EA57nKzw3qtxVOtg
	S/qCtDRVg1payg1/6xeO5ieOqIypPc1awLzU0i1n/DD/+MjZEUBHsrTSE1NBrNRw
	A3SrO55z03kSSTOaUit59auY4f/lE/KLGPiYQN+Rv6hsG1FcL8rWEZTkJfPwFtPp
	JXGTkC2AI0sdy/9M4Sy300Bmabnq9JtnBizgIRV54hELgO4eOaUDNkFRx0gArMNt
	nWzAAuLqQFEgYyYEn4seUGVkTkOdUB7a5BObT53fak8D/Iacl981VBInsdvncm9u
	1IpdSUiGQphEoLCl01+pTgyvjtp7N6W7npfsaK3Eu0UnfJUNXmzDwEAc27x2dFto
	xdHgRQ==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h9fgjgtya-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:22 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93cb71b1443so605261685a.2
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 02:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791885502; x=1792490302; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XJVes0YlmH/V9R+5fIFgbCWrnbNrzQD5kF6yClXGPlI=;
        b=NejWCgB7P5MwoSSbMcnIc76R1QYhBNKvh1R3esdVp/7sqfDPgJJ3C28ZyZoIOzzIg7
         /izfrx1H7YcJkH+48/kf2E8dbA7frnBfxlrez/EWdqF+yhG/aiWOCiiKSAeZnj5uGQth
         vzSMSFIO62fzBFQfj9qKIgK6/LAgT7niGm30CRiYyjOSRTpoMa/p8pKWqIKkki9JrEAW
         EKaaefj2leFYQZqLzgcEyHjgceEcRvIeeFJVXGPsMJQWRbtTETn6D/ETTbaVHYUyBc+3
         S3WkeTpO9Z439dA+wrNJyHohTOjamrx6gzx+j8V+pKPDtuIOk5ABjyiKsvdYMzO6vv9b
         lxBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791885502; x=1792490302;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XJVes0YlmH/V9R+5fIFgbCWrnbNrzQD5kF6yClXGPlI=;
        b=ZJakSZVJN3UVgIRjyS/8RimFDOOfK/PXs66stqtO5oBf9Y8HpbXI97Cgiz4UmP92IU
         O+M6wXmO8ACOvtUdFPVO09C0XcyIfVWdqAxHWBx6Nb7H5Isy4EpkIefAEmY0B/dHvpQt
         9td2kPE/HxGbhSo/NhWHXql73MkcUYZ90+HzCmlexdC+Hz+7QDa5fF+b7oSa8En3Eiwx
         q4sn6antuSa82tRAHbpsIbUGe6rCKh0SRDTIzb3zgOC0GDNJviXX7TdoN/0gXjfAst8a
         2fMYFUzN/SV2k8GUe0h/DjllesPgG7zRADdS8lGzeGkoK/4Efd1OGg7PKwa4ZBERGXRl
         /aug==
X-Gm-Message-State: AFq9FYJZSjXHge7cExU8HYkVRiyRN7tLzmmYZftzAA1uXyEo/ICUhe6U
	K83B13PVD7DIKCfcI2zUX1CrJ/SFx1FnwEqqCRwWi6gOWNxG5cBIAP7Rgx3T689qviWpnC2rdjD
	M/RSfPQ4EsH2+X4qElwvQRLPOFlnOm5ETPQz05L1u2r6wLwsT1yRFvj1wYs1L4OaTMos=
X-Gm-Gg: AYBFou2OZhm4ryW1sb3OuqUiVJOV4zGtgno117va/0OAL7C9JnD/PNlUWz+xVCsa8Re
	otukzB6RvON+QKH9NFk5vLuloHRe4ha7iW+8ZD9pybjKQ6E+BwpETDFuqy3bHj+U65yC6Pvla9E
	DCfACFDsFUe91duvpwlhk0RUMxqedUp3qXQFBuU2wYR8ryS3gYBdByqog1V4PW+Po4IWfDZQ32M
	cg8SqZyZMS+67Icf9oSNJbxcFgTsvOzF2cReVcEFFnoBho5HXzwHhj7MetOzrbhr3GsfPzLXIWc
	kyexdZaq+p3Z+BCZNqShcy1wzlqGpErPyz5ovdIxDfRFR5RmMIoZYGGVwv4IJp1D1jpM/5GTgi/
	Uw9yPCWjdGuuCsX796MOJ572cAv9Q
X-Received: by 2002:a05:620a:2988:b0:93c:5f3c:f485 with SMTP id af79cd13be357-93ebd294dafmr1945174185a.53.1791885501623;
        Tue, 13 Oct 2026 02:58:21 -0700 (PDT)
X-Received: by 2002:a05:620a:2988:b0:93c:5f3c:f485 with SMTP id af79cd13be357-93ebd294dafmr1945170085a.53.1791885501082;
        Tue, 13 Oct 2026 02:58:21 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bb6beaesm209412025e9.0.2026.10.13.02.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 02:58:20 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 13 Oct 2026 11:57:37 +0200
Subject: [PATCH v10 08/14] crypto: qce - Use fallback for CCM with a
 fragmented payload
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-qce-fix-self-tests-v10-8-57162a38a554@oss.qualcomm.com>
References: <20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com>
In-Reply-To: <20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com>
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
        stable@vger.kernel.org, Pankaj Patil <pankaj.patil@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2947;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=MLtXfjdlvx+/YwSM8zES/jGUYMWSXbIwKrH/OXziqaA=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqzgCiJmllq0gkGSQfCgV6plxLZSPw4cJIiPEdt
 nTzAWeEmnKJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCas4AogAKCRAFnS7L/zaE
 w9ehEACnqosa3MpvnSGUd0b7Z1kqk8wSXLPoyieDNSuIjUpXT++a6HT5+2kzEuDwl48w+LctZXD
 WLr/bP/zmkudCPzJ+FzTLKtLiIX0rEpQ/VwTctJhri/oK2HlgUkO6zuro1cR+ueOZpdPDp7O1UX
 NFFQwFJk7PMDRc+Q3C/5ApPKDv/JZAX4uoheHWdjrg59O0zqYxmlcRLWTkwvM/qX5Q4PpgJISfn
 Af2ES2AQUuKPY0K6Mme0CGBYBjpJxDkw/lGm8PQnSflFEWXsRkv860HeV5SUWlyv5e+jgzPlY7A
 h3QLmVJjVjNfB1qVUt1bCX0fVbBD4lF8Tpz2/M+Ks0Dl1bwu18Vy0r4T3PpdESzb6Gkfn9jOPQr
 TxKZm4ACng77uk8hxLiQqjDRELcls6YdKgHZ6DmVWMOaI9zMZjnQMJk8Co8UPMm7a7uPAtfICke
 cdkr72v4im2ptAKrxG9++T+x7XOOhWzpZOKeKOky50nKGhyCR5kphCFGp7DK+E+OglD308YGm15
 CLriam7A6RBmGlzFHB6dS94fdAkEHvxp9P2m0ojtEqe4V/6Z71ofyO3iAZQwlSA+yJ5686VGJCm
 wyvRdhZUTPkDKqn7zKTEcxhVWDA93xGTEcJs5R1wjxjVaf+60NETScbR/C0scCPJJo9sRycZJsG
 5FBBBWIzB8fug2A==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: -DAF-YxDKjHuLxmg9tVLxhPxeI1RPU_W
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfX23fDabcqSrmo
 R82y8ukn/j+3lCKjg44U7/6ZDNAJBBkL16elqPXaZfVmtuztkqesS+ygjmktjywuCEYwA6ABTGp
 FNNeCQkMVS92+3IBzbQoHp/QhK8evp2yYhOIUgUmGXeXRCiU8WbAzbO8UqmP4stVYAKfZfdNYX5
 I0nZIpLWUuGJiz8eqGwMzksAv2naZsUZWIbXPJjLjcAk3RxQLAZnmTqO7bTNvMLZuaMQfTQwcZ0
 cja7ZwhOs/nWgr/tRE5I5JLJi9qlmX+aBAgqiamMk14h9zj3W9kRZ1gJwfJhqPZlk72L9Koldbm
 lzaup6x9jY+VWAOiX+oeIiky0sXbA+58FpIlnIWaRqtAB8ousy9scx5kjXJbC81qqHqm2lmQqkr
 PjKQtATBSniKc4NMskyaLc7ThlWSQq3kg3i1sybLlin1XCpthL1FHDf7or3jHOVrg/QbK7wRF8x
 wdCc+xgoybbwFzlQdrw==
X-Proofpoint-ORIG-GUID: -DAF-YxDKjHuLxmg9tVLxhPxeI1RPU_W
X-Authority-Analysis: v=2.4 cv=PedqFShd c=1 sm=1 tr=0 ts=6ace00bf cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=phyxH6jkQibGXiXynFEA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfXyCVd5MsmsOob
 Jozi3siFSE+FgwGbZLJBacjZbsmntMjcV95u/+tN6zGRzASCKmEjLL56TCKnL3MoI6rn78tOE2G
 zpBVBvWz6t3Ax7+5gq78ArrUDK9r33k=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 spamscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610130039

The crypto engine reliably processes CCM only when the message payload
is a single contiguous buffer. The associated data is already linearized
into a bounce buffer before being submitted, but when the payload itself
is split across multiple scatterlist entries the engine stalls waiting
for input and the request fails with a hardware operation error. This
was uncovered by the crypto self-tests, which feed the algorithms
randomly fragmented buffers.

Detect a payload that spans more than one scatterlist entry (in either
the source or the destination, skipping past the associated data) and
route the request to the software fallback.

Cc: stable@vger.kernel.org
Fixes: 9363efb4181c ("crypto: qce - Add support for AEAD algorithms")
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/aead.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 02e1a7684a7e51ea7ccba0660eea97a17589c3f2..75a1df138dbea312ad660fa06997bcd3022687cc 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -498,7 +498,8 @@ static int qce_aead_crypt(struct aead_request *req, int encrypt)
 	struct qce_aead_reqctx *rctx = aead_request_ctx_dma(req);
 	struct qce_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct qce_alg_template *tmpl = to_aead_tmpl(tfm);
-	unsigned int blocksize = crypto_aead_blocksize(tfm);
+	unsigned int blocksize = crypto_aead_blocksize(tfm), authsize;
+	struct scatterlist __sg[2], *msg_sg;
 
 	rctx->flags  = tmpl->alg_flags;
 	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
@@ -522,6 +523,27 @@ static int qce_aead_crypt(struct aead_request *req, int encrypt)
 	if (IS_CCM(rctx->flags) && !IS_ALIGNED(rctx->cryptlen, AES_BLOCK_SIZE))
 		ctx->need_fallback = true;
 
+	/*
+	 * The CE reliably processes CCM only when the message payload is a
+	 * single contiguous buffer. The associated data is linearized into a
+	 * bounce buffer before being handed to the engine, but a fragmented
+	 * payload makes the engine stall waiting for input, so route those
+	 * requests to the fallback.
+	 */
+	if (IS_CCM(rctx->flags)) {
+		authsize = ctx->authsize;
+
+		msg_sg = scatterwalk_ffwd(__sg, req->src, req->assoclen);
+		if (sg_nents_for_len(msg_sg, rctx->cryptlen +
+				     (encrypt ? 0 : authsize)) > 1)
+			ctx->need_fallback = true;
+
+		msg_sg = scatterwalk_ffwd(__sg, req->dst, req->assoclen);
+		if (sg_nents_for_len(msg_sg, rctx->cryptlen +
+				     (encrypt ? authsize : 0)) > 1)
+			ctx->need_fallback = true;
+	}
+
 	/* If fallback is needed, schedule and exit */
 	if (ctx->need_fallback) {
 		/* Reset need_fallback in case the same ctx is used for another transaction */

-- 
2.47.3

