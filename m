Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201AE495ACB
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885495; cv=none; b=USwCJluUyIWxIGuh/JLD15wesMIgtlL44RefFKG0mYTUWkZQ6yB0cDbEMtId7nJaNe9THYOwLlPvPqwRBq+sZ6FuFOGMQpAlshveEcyttM9bL93j0ecCZORICeSyVXPkwsrRdH/oP/NK6Gvc6KFwfZr349a6QCeH1MgmI+0YO2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885495; c=relaxed/simple;
	bh=o2PLt208rLJX1I1Ev7CtiLH+CY+pRMd25u8UBju1Wmg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GDap+TymB+5l/bkcakWoTqbXLzHfeyAo3DkT2V6tFEx5x+t8OvPDJXSkBznN1/2wTmZVBM50DN+rjqrcURTsGf9IDW0QvoebJgaG63GVnHvUH7DiNyoEzoga8K44Dr/8CHWsqtI8iJOhz5GHZz8KgRf3ouba/Z22WRjouxaBOsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=U8tndUkB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HU1SXrr6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="U8tndUkB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HU1SXrr6"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D947fs483105
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XXvlAkzFWJa0VY+9IClEkg+ej24Kwxvf5XUBwFS2R1A=; b=U8tndUkB63edaDXv
	sD05wREmauABsI4wh8KHBeP/Vn4KyFXztX2EVFfHcRP45sZHFCOwue2qmfbYSPsq
	8gy5FuFX1Ej2AuhwfyQZ235OaFtQ9nbF3I9nuo5aRh2NksUmZmFqhCEXWkbK7lLH
	u/9Cen9o9nxzL2JRiMy6XIfVFBQ1I40aa4SvVKzHzoRb3ykzjvhqe05wStDrs2P1
	sGkJ39jhF+DeQrIHwJpjf8gHdi2ptHUZLZitsPWb+EVOTOKVCnCnIdsYKYnaxh+5
	WyBAShntYaBIY7QzFdnXCbq3uiLFZA2aD4bd2tzH0W/JdhzJ/q9uyX2f6+cfJoqx
	jyr4Lg==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h9hpg87gk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:12 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93dea1b6c89so536292485a.2
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 02:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791885492; x=1792490292; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XXvlAkzFWJa0VY+9IClEkg+ej24Kwxvf5XUBwFS2R1A=;
        b=HU1SXrr6wQMFD2x7tOC2dhypNXykp4iuYgC/rJWOxwttQgAFZR6Lkb37ljIb78A/A+
         ZNgUbRAgKH9fs45Diyvp4B54pnGGncA1B/kzMs45MVoSMp3fELPvEPK02bbQCsk1Gok4
         a8j+b1CjIKphZZPS0SWxjX0cpSNfFBy4UgT4ARaLKvq/O0Pin6J6os9s82X2AhjDs4pw
         4/Qmbix6zapRiafBgxtaKF82xc9N02joL+ypKfBBvx85r+MsreWlg99llD67Gfyy7Iba
         swLWZIiy5ED2ytXYXJoWTaI3fCr13I2olYl8y74axOwONqF4uzjozZ9HzcUwdEqYSlQJ
         H/ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791885492; x=1792490292;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XXvlAkzFWJa0VY+9IClEkg+ej24Kwxvf5XUBwFS2R1A=;
        b=jxgP5SkiCbStE8gMkRl5zgePTzRM0l3p+OpYBjsFMLXgSqygx6hUOCWkI+06VhUZ2k
         RVbkIbsyNcpugRTyaZem3LFYXIGIO/RF33YzWj4hBLYQWMtyLUu5z8M/TBt3KGtBk2ZI
         7BHccDnm715J91G11v7x8Pv4MDMw+f6HnnY1SCwQ9OR6OIv3AUcKpgjLE5K277H2TGj6
         lcD5yXfOTpIr4rTYnXHqAE/FVVUb0kWQrBWlGuC7BHBt9f1fElO7zYuXm4ewxdMexvvH
         8EUIBCZGXUnQYi+PIdQoYYP1NACju8A61g09ChIHYSDdJVK+jF0zwZ92UwT/7a3s6rqW
         qgqA==
X-Gm-Message-State: AFq9FYJPNX9rl5dtxIGDYo9JwELJaNVjb60/QjLshEoUeKcXezSQqxYH
	uXjTb7dOpuD+SWb/EApc7YfCyaqwcBp5TvODI4Ai5p0do5d0YkmjVQKBzRekDFqaPI+kFjoZ8So
	LOXGtKpmcXIsRwjqvBKQ9IhGj6INUkB+XOllFvjRSXOHoSadMaCWPkWtxQh1YZPc8nZ8=
X-Gm-Gg: AYBFou2KjmU935ZED1N4D3MFjE+XNvJFKyLTxFAj0lIbA+WvZd6pF8EMWG+egrjbsG7
	nbLQDme7idGMAqoVrNGzhJo30qES0sWhmt8dhmN4yv8yZKkS/st+pgFyUHNKfHgoXwSPVwDnzgz
	hseO34dHoIWPMxEKxDE0p9VgH0ULQyl7hqhOlcY4A/ixnj+9eMGFDLbDn5zqhif7tk0CqnATQW1
	JW4haYzum0ZkSqwYbNTzX3xKLeowIwX4GM1FTUA2xN7UGriwXCZfeYLzNw3f5bSoklcBfvk1gi3
	cUTzkUQxdBBjXtdkLWZe0wua98MXnF4c1EIWheYioczKuON3iXj7eDDCxZ9sIZXMoJsmviJWO5J
	ufL3epIatx6lVsoObbZnyv87SmTrS
X-Received: by 2002:a05:620a:470b:b0:93e:c12c:43fe with SMTP id af79cd13be357-93ec12c4aa8mr1766957585a.75.1791885492225;
        Tue, 13 Oct 2026 02:58:12 -0700 (PDT)
X-Received: by 2002:a05:620a:470b:b0:93e:c12c:43fe with SMTP id af79cd13be357-93ec12c4aa8mr1766953885a.75.1791885491701;
        Tue, 13 Oct 2026 02:58:11 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bb6beaesm209412025e9.0.2026.10.13.02.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 02:58:10 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 13 Oct 2026 11:57:33 +0200
Subject: [PATCH v10 04/14] crypto: qce - Use a fallback for AES-CTR with a
 partial final block
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-qce-fix-self-tests-v10-4-57162a38a554@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1821;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=o2PLt208rLJX1I1Ev7CtiLH+CY+pRMd25u8UBju1Wmg=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqzgCdyS0irkJUuouCdhrrlVSxeOpNfphJ+mMZT
 Z0BSI+5n9KJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCas4AnQAKCRAFnS7L/zaE
 wzqQEACh7NqpVgqvOFp/vxH6ipDstZLUdS0Fkk/8DS9bZ2/zwSFvyqdxFcgBCRtxM+Qsz2oCV1b
 /fL0RLZjg8VG3QEdN6rEi5y2+e9hBFyXqjV44HwKNnS1PRNAZm5wkJu/qFuhZLDBZTI+PzAwpaw
 AJHY9xQVMgPiyIXnG+R5EcEoqzHZhk8xRe/cxHPQ8T1sKGm1/vvclwFKQWzCs6IQgPU6kmeZq6q
 IfDv+jIzjoQRtLxeCpcwSIpZVot1N6Oa9iDqcdwfw4ZX3cOAauzILv7z6fQxmmUidlhzYMBbWyB
 V0b4+Ix5h6j9jHGdmN9PeVQnh9TwUUvDOHXvvfui3wcCHJlpiFUbEqErRj6f0wuDCAEhoL4HGZs
 am5cX0f7l2dWXKkyExRsezNds1KrXxBJT14Ld6caU0tFumy/kzOimV3XUEZi55GIHNyJL+KHWzV
 c0253hxjMYI6R+Qgkjy1knkcZF7c9llINZhoNRe5FWVTxPc31lh0kS3IjQLK7rtuD3+3x0bZS9m
 beKOhfx/c512WrQ/3erNlM3pWsa1REkb+ZkGTkCYwyeeAIIbuV5nCuubpF0aC6TxMiazswKcx6K
 Om0XiuMwXKNI32F5xc3mwyN606GcYdNfGXXzwK5pdQ6oNBxH2XQkh1ZjVxZADaEwcA4RCfcH+11
 asD6z6tkH2ESkJQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: XsURnHWDNOuK0ekfLXt8X3-MS69VWpZX
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfXy1lJzuwj8HOP
 S0MqOmnsfjSHGhrPYp5pF5KdUkzoj9YYpFfQZLHK48lk8gd7xBttpxX4+M9sazLBnamyHO6XzJo
 +iNa2hW9vn1bGj/zYtqdSfEbRDAIDPQ=
X-Proofpoint-ORIG-GUID: XsURnHWDNOuK0ekfLXt8X3-MS69VWpZX
X-Authority-Analysis: v=2.4 cv=Z4Z5j3RA c=1 sm=1 tr=0 ts=6ace00b4 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=vUpbTSJP45I4i0_vGVUA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfX2tHwgK9zgD9u
 xM2QZGrXnwgTiVFG7Ei+3JrKtND2B3YDTs0Ey+55+5R4T8ZrfA9DUc7kjzSXh3TVr2vAritV87C
 nO1tA8hlNbdAVNAl2Ow63pdllGLu3gQJNYvcERZoOIzqy5D4+FZVc8Kl/uB7kLfp5g5MGH6x9ae
 xB4/4zjV4GiYYCxCCaLzmT6yEG1x2ZidGkSXL3ewpFflFYmfsnJR8LI9x7mRVWT7wxInPCt6sNq
 AYfcpR/tessD4LTSkeiugdnHXT5PUwj28ekOlPbjsprrALYe9Fj8XBkCMv5IH5o2v7FTzKjmwTC
 puOBX8mFeFQ5Tk3LpzR5iFDxTToa3AJwfw83iBZ05RW95llBHqqV3EbVlg/KBam7o5nIXWWeWhs
 IbuaZefMTtxcwJ4sUvKjHJDgiojIxaIlLGzBgCev63xH6HNGORxS3y2EVjbma9nf/JRXWAS5S9m
 A7CDTqR3/rdp9kmJPGA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 phishscore=0 bulkscore=0 adultscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610130039

ctr(aes) is registered with a block size of 1, so the crypto API hands
the driver requests whose length is not a multiple of the AES block
size. The crypto engine, however, stalls waiting for a full block of
input in that case, leaving the operation incomplete and failing the
request (and the crypto self-tests) with a hardware operation error.

Route AES-CTR requests with a partial final block to the software
fallback, which already handles the other cases the engine cannot.

Cc: stable@vger.kernel.org
Fixes: bb5c863b3d3c ("crypto: qce - fix ctr-aes-qce block, chunk sizes")
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 86e3184812e061943822928a805d542004347ca4..6c578bda8363c6656b61105e2c3c62b9ed55e7b4 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -252,9 +252,12 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	 * AES-XTS request with len > QCE_SECTOR_SIZE and
 	 * is not a multiple of it.(Revisit this condition to check if it is
 	 * needed in all versions of CE)
+	 * AES-CTR with a partial final block (the CE stalls waiting for a full
+	 * block of input).
 	 */
 	if (IS_AES(rctx->flags) &&
 	    ((keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256) ||
+	    (IS_CTR(rctx->flags) && !IS_ALIGNED(req->cryptlen, AES_BLOCK_SIZE)) ||
 	    (IS_XTS(rctx->flags) && ((req->cryptlen <= aes_sw_max_len) ||
 	    (req->cryptlen > QCE_SECTOR_SIZE &&
 	    req->cryptlen % QCE_SECTOR_SIZE))))) {

-- 
2.47.3

