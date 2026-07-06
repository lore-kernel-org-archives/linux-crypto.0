Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8F6373BE8
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 13:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783346071; cv=none; b=GsjIpnOwNjlo34UayY25GZ3ACbHrqktbcq+iJ06loBSfpfeiKxzq2VLlbhzE2MuGfaXgCHFOYY38t20wwxu87kqGvJ5V2vohyqs9ioKC3bsIhisK/otgNrTYQp3J6xvNncma23UVt1BEbGl1kK177aaw2BoBt3M/dK3onY6zfaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783346071; c=relaxed/simple;
	bh=q9N7xvaeFpdxSCk21VylCtI8nPZtUNdJ9Z4Mvdcp2Gg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZXFr2tCh4kdG9hUzSEHO77agViPiX7IibSjMfwAwq5TImtBVEIVNjgRWQ05pCaa5s1FbCe4lQnOipXzWrXcnmXCoxpea7JPpH/6ELkTCQ8HJou+dz4j8Ul3Gqs7AYrgGTuiD8nTZbWLNUK8G9GKFv1yNDNNuu7Z/eGiwdlBIHqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iTwXJmPw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=drNnAv+s; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iTwXJmPw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="drNnAv+s"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666AxPcm369534
	for <linux-crypto@vger.kernel.org>; Mon, 6 Jul 2026 13:54:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	onHSjGInX0rV0mVGlTmmcWeekHeD6EjKdPIS+Vcr65E=; b=iTwXJmPwI18DLyaW
	KRSLXbhARpIuVdP3sGrJWqtbmqwo1v3DNbQmiFA14YSrIXl3uCInXeCBSv69hNgK
	cvSMIhfyOQPsUE2dRx5+JbOdlc6KR0h9nZzPWq6exDrm2HI1bvQzKbRey7a55d23
	DtVupoV1ziTzldEeZhYVnWK0UEZWWfzhLz/zhYc9EDNUzV+br8Uov7Okp+dk3DZL
	IDTSvrtdKorM3kTcbIR2Mn8Eo5IOExksQbaGDYHzQCOGus3ntfJvL2YXbn2YEVxJ
	dk7+HHGu76KcbiyPpDbmVQfyPCDeLNZgzm+aGye452NEh+kVVlQbKk1LehSvly9F
	or1HPg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f88h99d0c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 13:54:27 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92aea0d801dso289446985a.1
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 06:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783346067; x=1783950867; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=onHSjGInX0rV0mVGlTmmcWeekHeD6EjKdPIS+Vcr65E=;
        b=drNnAv+sz+0bZhoDvvWJw5C/FSouGYlK+dmxKTNWU5jR6GTgXaOeewFWYzLnlXsEW4
         IkZ5Nhx/IOsvRuZCrsWCDKPt4u7q8K0G82clTCG2ucKaNrPNm4ft11dCCKt8WyXqCVo2
         ZD7DZle4Dfe2pToUiFikUkIbywY8w4fzsgfEoO6KkVp5LBccsKSjo7QIbmq8kZLUSC6e
         s8ArAxrVC72yHjfnRjuH92TGLO4+5KlfU4Tief7+c6Ui+OxFIAhOBr1dIsMIg829xIjB
         sO803lOQCGjpWFAVyZcXjvsGf6V/ZIrB8HUBaAuzzCwcV84GtMYgWdb8OHMtDf041Wb3
         Uc7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783346067; x=1783950867;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=onHSjGInX0rV0mVGlTmmcWeekHeD6EjKdPIS+Vcr65E=;
        b=jsihJLwAdN0jP5leHcHQ3UBvwJaliIdhQbOS5N1UErhahTPNub/2598QYWsOSftZj6
         Vw8N649U3dR2u7LFKCmLjr5A1NTi9/1Zv8xEhXhxzM1Pe1Lz5BlntlUpehFkX0yEmJgO
         sGoH5OO1VvK2PHJN2Amp1X7pdc3/sjUklTuCw70m/O4bpwrcxI76PdwNRPhgKQ1Ldegc
         aawCdsUuW8uXGfQNlbWJZUDViQB7Vi46vkhZo6O50zEjMiBOMcWa4jVq/C4SNB60UdTk
         ySETGfaotQnps3aub4DM14moNlD0WSQgY9KyMzUgZ8/lGray5omS68VWt5nHBXjzmJDA
         UbNQ==
X-Gm-Message-State: AOJu0Yx23gVZ2cleVSpBRxkipd/ihyfEO9IVKrg4ApSl/FKzX9VoGOMU
	wTJRX/XOtRET5Y1UJYMI1NEONXW/Qfw2QG+uw2t8JglT0bYlJXmpnnb07twdjZjukXJtXawliqx
	YcRooZjOx6haiGEqxvceBmkg63HbLwhS2WBPAnsn0n5YarrWiw7bWC2O3C2t4uB5ZGCp008u8Vt
	k=
X-Gm-Gg: AfdE7cllKKvl3TBffDCMM3iKPPeD9c21jz/AzWSYSdN9FHXNF+GbhRJ9i0YL9KJjZou
	GJMzuVHQSvOCojGYQcfBPWylbp5AOt6t521uWVosGZW6//0OeDNbLLq8vejDIlGP6Gt6JlwimE+
	ktnvzADKRt0sOT4DyZTPBbObH7XK0EzGS8VtLAn056YS/X5HIK84ThedGoHu/4oNww9z4MbGdN5
	s5kYtFsEsuyMb9eDjN2+kl7FGqcRp/VCOG+0mBbMxzJDUP762QWOO6PC8DIefYNPFR2M8hjZCp0
	Wo3WCr6z1kXgq8OZm0ok5B/XWPCUP0XIV1KeTOM/EXHPyGWaks5oboBnMIyLf0cU1XccpzSjTAs
	+S20waoY78tchk0iTvnwtsLjZYcgl1hVxzHvtLIyE
X-Received: by 2002:a05:620a:7101:b0:915:efa6:d70b with SMTP id af79cd13be357-92ebb553714mr84766185a.43.1783346066730;
        Mon, 06 Jul 2026 06:54:26 -0700 (PDT)
X-Received: by 2002:a05:620a:7101:b0:915:efa6:d70b with SMTP id af79cd13be357-92ebb553714mr84762485a.43.1783346066153;
        Mon, 06 Jul 2026 06:54:26 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:86f0:c42b:ef4c:d3bb])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493c63ba971sm619805145e9.13.2026.07.06.06.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 06:54:25 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 06 Jul 2026 15:53:58 +0200
Subject: [PATCH v5 7/7] crypto: qce - Use fallback for CCM with a
 fragmented payload
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-qce-fix-self-tests-v5-7-86f461ff1829@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2908;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=q9N7xvaeFpdxSCk21VylCtI8nPZtUNdJ9Z4Mvdcp2Gg=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqS7OAaVRF+YYp9zlxR5A6KJaHc6oHPNIsnNvFJ
 8XNJdcFdayJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCakuzgAAKCRAFnS7L/zaE
 w2xJD/9zTCbYP5yPD1HGULpdCAOQ8zNWBFieKFYghalVDiNHTrZW8xGO8COZ71OV2CHogH6NWs3
 bR2+PsKIpxIIKpKg/LXnYEPLNwYaj0rTfHbAKRxaIwOTlyfBccdUwatfSpfrEUFEOhl+n2Metz2
 K8XQ1fDIlR3wJUVE1QJL+PuxHkRIzBfjx1LDz+3LnO7GlWsDaNGi+06TJ+1pkw0CVJtxHV8/dtT
 gv9tu5Q7W6p2IpBxMx2MiavorXo/stO2xME7Urilopf/gHDr0kTt4svlEDE8bOGOaIOPX6uQ77m
 sziwizLgAw5MkwNl9dPo/JEuJo5fkGKkNYHkaxk2KrBP1M5ay5hz+WG+eByXfq12dn+tV8+drbL
 IbWnLHt46Ryl+gWkYgcL2YRzcoyMTnJEYfp/fvLJo9btL97CI8wNrgx3bZsS/+58yWyZBR0GHF4
 5paY/Lx145wgeNOZYWTUlM+wAB/9/9FA/umCe5mMD8QA+xh9zGawW7EwjebckjAGdFHIVfu+PVH
 Vp62Wt5beX12EvPA4+SsTapkXSnyXMFPXfvs1qLaQOEDfBmdIErPmXQMaMCNgq9vDv8WqjX5vWT
 yPybwrSLXyS1HYlyr/hPw/ukBzM+Qtl6dPNLqTThQbrD9HtpcDOID4BJjegMJy7nP8Nuuou99mV
 d2DxOan0Sjg/kDw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: 6he42auMP4PRJkyh1oQ1aL-ZGnccxpRE
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE0MSBTYWx0ZWRfX661ZX8kbSQ8l
 Gtt0WD5pXua8xbUaHZ73D0T4/gnA8py301WBOXd2ih4XvQjHEowjhDYh6rAir/3DpP6zNlQo/bv
 E/TNGpC99pxfOgND94b4kXeesw/Vuw4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE0MSBTYWx0ZWRfX0Dt3WfcZxkYW
 Ln4yUsYB9UpWKc87SSQR1UDcCi/bkRAWoGf96V+/8/eVS5ktrDeG+/kn9WXDUCD+1Tv7igAtdLa
 N5WPEr3zpnW1Pdrdo6W0j3RQNql3kP5QjtYnpRJr9S5Eg2bMbP51s3XSbo/P51VZkm+8+LTdiJt
 A/x5jC71zGuxB/T+A42mwPDP0h0RlUZ+VdgYy2a6Jgv1Muovz+0un8DzbgPIcKFRfG0t2dEMFle
 e4OdSA1MndGjCwSAkxj6A96OC6arjbn2kB7zarpnZGCPATS/cIb5f4scR60YehK4bWVBkAmIjOT
 GifTFZIPbDW969WH2rcBk5jWzlpKiQNDbGQBqR+Hfzs+exATSZGer1nFHd4MH9sO0Lec+PPh5e1
 Bt26ux4ac4a/JuFrm29GzhzowNo4a6KjMNpW8XgF7xYIykBet4fYUVEJDu/rvcvy35yAlqoMh+j
 0AenhpZmLePuZaQQG5w==
X-Proofpoint-GUID: 6he42auMP4PRJkyh1oQ1aL-ZGnccxpRE
X-Authority-Analysis: v=2.4 cv=GulyPE1C c=1 sm=1 tr=0 ts=6a4bb393 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=phyxH6jkQibGXiXynFEA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607060141

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
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/aead.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 4fa018204cb628c112f64c45ff6c7407df73b945..9ff8fe2a7efcd2734e4ff029744961a7b1101013 100644
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
+	if (IS_CCM(rctx->flags) && rctx->cryptlen) {
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

