Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BED74F85D4
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 13:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792417707; cv=none; b=EYWlddVLdicHKcd3J5jqXp2uYNz+KmecaJh4xcsPEvMOG9dr7gMe5bEqTzqAxvT/DJxb0TqwF9u2exw9DYRB6HVSftSjtQaStySygeBGbi0gaYsGxklZMXZb1ucBqckIxKKBbjfRwcjXtg5Ih8r0NrQedlqIPAkY+RlxckDHUtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792417707; c=relaxed/simple;
	bh=5GHHihT8Q28Q2Z6IqnDJJLR49udVLHKyjwu/T6aBJ7g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VsM7y6RF4Qjm89QXuEF85BFKqSWBOQwOyvf2aa9rl1LaCmcYW1qY0CuNpo1OcW63f6iLC0CDvka8/yNZwd+SjGSFa4O5RPPPEfebBGer2ZjgAScY8HQ4fXXaskiO2KXY5nTylsStNUOAOxAd39nb0JUGRVNfWzzXm/el6cibrDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eve5dmsK; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JUTLbyvz; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eve5dmsK";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JUTLbyvz"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69J8P11c2042000
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 13:48:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3z8i+KPSNZ2br0pM0JUREqSlK3MOF1iO3EQWQGWiPH4=; b=eve5dmsKKTHeRAik
	/3vr2+iutwPPDVeub8pyF0Dt+QIu770JipWdLd7OrSqlxu5R4rXEnbJcCywz6vwc
	vBB3+EwI3JairFp7cdDTWkL+xGnXqWDGQl6Zgh2ro0uhBuemdXG8oNCmieIa8yWv
	kqqzG7ccjnATqjJtyuqtnNbWaAXKvpXBubmyXc6ppjSbeDPXlrF45vFcLxEerp6Z
	xXmBOacReS33qdhEk5hxz4tsN/qgJknxV5TTAFkPfBYIUncqQyirIbT10C48gwGr
	u0BL0LvlJvTAYd9cLxrrsWHSHGW4MGDJxpIqd0Vg9vV38cmObKktOWSGJP8U2+B7
	BZpKXA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hd5ur3038-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 13:48:22 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93f13c143c8so404666085a.3
        for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 06:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792417702; x=1793022502; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3z8i+KPSNZ2br0pM0JUREqSlK3MOF1iO3EQWQGWiPH4=;
        b=JUTLbyvz3CpDwhWSt0A6avupu4f61+inNrFvTYI4qgpQk6SsYQvDy5U+8nhKb6fS2s
         gLQBdNboW9n8t9mmgEcy/OvNVAA4Fiq19jvzru0+wYSHnt2DfAVbcLKJ9UM3pu8dZLRp
         ij7K7HUUVbpPXElzoLrg6rqQ+1fQbvkIAUej3FlUdpaLLqw8N5OC509FDN0AeD7po3vC
         7f6QBAlsEaIIKhOV1ZiU+o2H5UgETVfysS0QsmNkzJHBRUZwZffcM1XCTc4asTddh+MY
         ApY1P53/E3m+RTfOZHOI1B1qmwQSiVzwDy5sK4pf32qQswafAKapyE66899KcMFi+rGd
         EChA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792417702; x=1793022502;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3z8i+KPSNZ2br0pM0JUREqSlK3MOF1iO3EQWQGWiPH4=;
        b=V3uGyyp1EsyHpi//2FayPHpexA+Ajx1qvKjdPtG3kicwLcqLEyAAFewPMCrTYHmBeM
         aa3crUEkIHv05KHtDW3L96CS/bZZbabrtEHpCbHGNO+tA9ey2Rk74re/iwQSlBvJuIZe
         IsnG+nChV4tlpfRD0UtS5BTuDTqbuHtpHZYJHeLJHdRYm0Zfd7Cs4EnHy/cv0v+m6PEF
         cTkkSdNuipR/oe1Uq8agMeHm3LBLvzJJUlMvUUVrAhCfQ8LfOBtFR1Pm0hiWi5j79psk
         pUezSIrcnasj47qpLilMfD0jNIepaBdzRUwaXh/oeUOSBQS9VhzcJsHt4GD9Y2idUjco
         KVCg==
X-Gm-Message-State: AFq9FYLw5ZW0GFBLGfXKG2o9YXikCgx3lbrsZbdO6QQzpeDpjOrzE5gA
	NiwPpw3OnOLdNq9b1c2xdyCQUMKE2/ts5Ue87PDzcS+jdvvV4N6RR4zfDE/eKipety3zWRB6HAF
	6ewBtoGCw7uxFJrqk3wMF5khYRU5pFSlA9Qc2aKgP7aV882Sk+S3Tsw/wxMObnS17ZBI=
X-Gm-Gg: AYBFou2eksZLd1zZatI/nBzE34bZh0axhSl/U4wPP0N5j0JGREyEEuEbuTRTV5j2BYd
	vGIUISmGFGS3Wmdp+n7DNJcWPbFh9bhxXCzE3OZaGKzhM/WyaUhu2r/wraGhOhTiRnMp1jTfYoJ
	3Ksxw7rKvbfJh5W1jQC6D/yu2DdwBkgbrhYq97ZsxlxFfuWHMaXbYCQH07VMi2+QXsBckbPzhje
	KQ2WxKpDTvrtMnqjiWuONqHR0TwG64IjYpUxRwM0Yih4z7JBjxBrPniyEXV2RgNNCTwp+3y9CWR
	h9nYTOauhp3NZ20Iok5TIu7ejOoegw2uIV50uYFZqJ+8xYKBJ7/+LU1XCFOnAXkEoN1Ofswr50Y
	bHAHZdCq/KZFa32leCB04WpeoWwhw
X-Received: by 2002:a05:620a:4547:b0:93f:2610:fb6d with SMTP id af79cd13be357-93f29cc832bmr1363861185a.13.1792417702275;
        Mon, 19 Oct 2026 06:48:22 -0700 (PDT)
X-Received: by 2002:a05:620a:4547:b0:93f:2610:fb6d with SMTP id af79cd13be357-93f29cc832bmr1363855185a.13.1792417701785;
        Mon, 19 Oct 2026 06:48:21 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4c4fc4sm20595574f8f.15.2026.10.19.06.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 06:48:20 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 19 Oct 2026 15:48:08 +0200
Subject: [PATCH v11 1/3] crypto: qce - Don't modify the TFM context for
 per-request fallback
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261019-qce-fixes-aead-v11-1-11c55cc7a695@oss.qualcomm.com>
References: <20261019-qce-fixes-aead-v11-0-11c55cc7a695@oss.qualcomm.com>
In-Reply-To: <20261019-qce-fixes-aead-v11-0-11c55cc7a695@oss.qualcomm.com>
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
        stable@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2422;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=5GHHihT8Q28Q2Z6IqnDJJLR49udVLHKyjwu/T6aBJ7g=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBq1h+gMOTqjQt6l7IKLo91jf5mwj0P/GJHk24Py
 KKqGkk9mZmJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCatYfoAAKCRAFnS7L/zaE
 w94ND/4k+pDq8J3I5zsCSvWVpqkCQyoYt9nrtKvRWvKqvjlYsSe6yybcwAtZuig5BWOUTwzi3QC
 8KcSiGBv8klBVo3MBblAG8tByLMV5Y89PGJg/DKdpA5ULdhS/h6iNkMEV2m48n3WlU62ZPSPG0E
 NEiBZHkqktVGjYaIxsWE3qhuHLfn+5zYV007HtvsmkRBLSUja/5uua+fZmpXiGujUe6pTTIec3O
 qxQhIdPkEf+oNItFdiCJblNNtoL05mo2KHsaCgmJ77+UqozwZLZmUf2QvhxdFTt0oazP38Kun8a
 Ci9CynxK5nB1X5s/QaPV6/Bp0/0FrWiQLMc0nhpGFgu3PBDBeLec1qq/sz1kFmp4eSl0IwzI9eA
 60hXOPVQbWUhg7klpEKfVDbE6iDY0OxtiBtt6H0JLWKFxmxlYHMcx+Q1EIpH5t073DKDdSOzvOH
 4gt1Zr3hEzKpin5+dRQBASjn6itMEOTMvqEHewA1VS0TAYYBW8g/5MoaxCp7g9VoR/KACh+xU+J
 C6sxjVRND4U1me8UiGrGE6B6qjMXd0Escb3C+9BAn3XK+NRiWsq36r+v14K7Ox0JjbaU5JO3Tv/
 Ag7qxUJ+ehUZM67aF14ifyFZS5VVZzC2mEVGjLdUfyfidpM8QPDEwrcS5i/GeOwNL/LcvJAQafN
 kBCTaQrv9OgOMHg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE5MDA1NCBTYWx0ZWRfX2SYRpIvaT9GU
 1ZKRpWwboWeOKbYvfz3XMyhsNyifboCIEAaG6FsVm3kDPdlUn0gx4evknsEKtxS6ZVp2lc285In
 iclWPeS6cr+XBisChBHL68r5M6O+d2M=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE5MDA1NCBTYWx0ZWRfXxWs1bh2nXXZq
 RKt+tKR70knGF4nff6V1/RjhqEp3zHiRJ3oPinC8jwLNG4KZ7a9uRDoilN9dd5XkgPCRePOlORi
 yAaS6CI4MY1OYqaAn/JvZwbuyEQGBGyVIlYG2GKQEbL49SjwXvkif742H7qcA8wZgBP01F9YxQp
 6Yq7k3VYD2r9AwS6bd/zyvehuqUHrJ/9/hN2kJEfHsEbhm2ZNFnOq6A8Ls4RMt7LgR4kev/4uMJ
 f1kYURV3zHD0cVLfjmcy8L8NgeSr5wHPAi69jtL+24J2pjHYvVEpFEhc1X0ESUVimVdmx3JzZrx
 4ZYueA3DcxeoSVZsj1lS7Yz6Kd1brWIyQEmi8JG5U7ggegvo3NHVF64KGv4CHUiQPXFUwnge0as
 WAUQuZgB1gHgyY+LG1JS+DVm7fV/NiSez7c7VKJCgSEFXMigA5hRELn9zqqucXL+xSJwdLJV3SM
 4uHqVzD4B6Rdf08Pd9Q==
X-Proofpoint-ORIG-GUID: y298kNijssMTasZUIyCN48kgc65jrY-S
X-Proofpoint-GUID: y298kNijssMTasZUIyCN48kgc65jrY-S
X-Authority-Analysis: v=2.4 cv=CP6/zhrD c=1 sm=1 tr=0 ts=6ad61fa6 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=8On1wDE6BETRpeAr_T4A:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-19_03,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610190054

qce_aead_crypt() records a per-request decision to use the software
fallback (on zero-length message) in ctx->need_fallback, which lives in the
TFM context shared by all concurrent requests on the transform, and then
clears it again. This has two problems:

1. Concurrent requests race on the flag: one request can observe and
clear the flag set for another, so that a request that needs the fallback
is sent to the engine while an unrelated one is diverted to the fallback.

2. ctx->need_fallback is also set by setkey() for AES-192 keys, which
the engine cannot handle for any request. Clearing it after the first
fallback request makes every following request on that TFM go to the
hardware with an unsupported key size.

Use a local variable seeded from the per-TFM flag for the per-request
decision and stop clearing the flag.

Fixes: b51dcf05c1e9 ("crypto: qce - Schedule fallback aead algorithm")
Cc: stable@vger.kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/aead.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index e0061bfab216861444e36700d6530e7a3cd347e7..81c1a9598474c7c1623e71a9eac876fcc0c111b4 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -499,6 +499,7 @@ static int qce_aead_crypt(struct aead_request *req, int encrypt)
 	struct qce_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct qce_alg_template *tmpl = to_aead_tmpl(tfm);
 	unsigned int blocksize = crypto_aead_blocksize(tfm);
+	bool fallback = ctx->need_fallback;
 
 	rctx->flags  = tmpl->alg_flags;
 	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
@@ -511,14 +512,11 @@ static int qce_aead_crypt(struct aead_request *req, int encrypt)
 	/* CE does not handle 0 length messages */
 	if (!rctx->cryptlen) {
 		if (!(IS_CCM(rctx->flags) && IS_DECRYPT(rctx->flags)))
-			ctx->need_fallback = true;
+			fallback = true;
 	}
 
 	/* If fallback is needed, schedule and exit */
-	if (ctx->need_fallback) {
-		/* Reset need_fallback in case the same ctx is used for another transaction */
-		ctx->need_fallback = false;
-
+	if (fallback) {
 		aead_request_set_tfm(&rctx->fallback_req, ctx->fallback);
 		aead_request_set_callback(&rctx->fallback_req, req->base.flags,
 					  req->base.complete, req->base.data);

-- 
2.47.3

