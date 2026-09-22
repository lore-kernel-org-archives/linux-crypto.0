Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CF82E8DEC
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790081876; cv=none; b=ERMmqlf5g870EQbF+YAdLlk7yUq524wKnlCdkEglaRlOwkHCHZPKAFqFmMX6NT6hQnCgrJH36xDfNUnl4MtmTxAa4j2ne4M+o17KqSIP04zpXLuTEk8kawUCDGWKD3sNzruDisGZxlD3i5To7xd5NcpjbQMDU/XTcScVwra8Ixw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790081876; c=relaxed/simple;
	bh=xyzdu2q1tpL6mhFPCDTUidWRkkUpI2PcImyNjPq2sLw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=X5vB9tpgwFLDFyKKO68DwcQaGg7fihL0Jvsl6wzU72qKg9OILQ+U7KN9NVEOGP7aD0bmLdQldPu5FZiQiWPVzT8xOkbrVKqxSFPazmetTlgK6WQv8p2K8KK9c57U3vmNbCZvjDPzb9D8TtRnPr4orCIsExTNDAAOnq6cVUgYWvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oCxyr3Bu; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LkRwaJ2A; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oCxyr3Bu";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LkRwaJ2A"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MBPYYt3487079
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:57:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	QSt7Om/WARb9DD7M+LNLPO3I5eWJQD69hsyVLSKhInE=; b=oCxyr3Bu8iz//duf
	BM1TVeZjNJ5TfEbv1Ld4WEg2cKlJHM0PHEnczyPU93E7Ei7YbL7yP4wgcu+BiQ2H
	BNhQJQ1ASXPT/fSITM/KhArSEwFxV6kBFYYksQft+uzebf3Z8OEw80Vf+UEd26vz
	C5GBoPuXPM5hgcDVspnAjz0Vj75q1ELm57+YwkNehBKwK5rjDc3AxVQDBivWJNMc
	tdY76vmqfM0SCcLtYpXNOZwyXqGa0KwbwJ3PHT3UFQHHMVzjlJGeOcHEQNiDGTgv
	PRnknhLXVx4/EKqL9sGQqAhvzcYzbfoKgdzYyjm3xbMZNYkTQ6j1PWKp+WM/ncdb
	2JG/NQ==
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com [209.85.221.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gudw0jyee-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:57:53 +0000 (GMT)
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5c833d4bd04so1077572e0c.3
        for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 05:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790081873; x=1790686673; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QSt7Om/WARb9DD7M+LNLPO3I5eWJQD69hsyVLSKhInE=;
        b=LkRwaJ2AHTdbHS4aVIaaON0wxFX8csoWygTVI6YrWEK72egpQBsGTWsGVLEniKT/je
         gPxT+0wu+kU7tCcji7qv2m3HHsa2rXMGPUvzkDlSGp8ioDWcqTGBA1fyUHnUKOog7fC7
         mmlrJ45YJzLffZ2+svSCAJo+H6VWoT4FPRfBhZxqUbFejSAYYhRPJ/+09dPF8wzaZP0W
         hvFQgcLqT82lDgeSpcufVap1RjjX4bvoUD8jGfArg4OwthjcZkcNhyxk1F938/lA6E47
         xsyas7kAK78yPOAYF9HZzA/evCcU5gkFzrHzSpub1DCb+YtMI7fuYPnxs0vluMbPHJtT
         bgXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790081873; x=1790686673;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QSt7Om/WARb9DD7M+LNLPO3I5eWJQD69hsyVLSKhInE=;
        b=rPlvzc3orPBoQLS2N8geeYG56OXjVrkZsLV6Nlz+DQgUUC4nq5IF3qJrTEKWV+Cnx4
         5w0rJchRlYU0+iiGujcczDr33f09LOf0E8uqxDz8cEIiFbyf0yESW4LCsqCZoEcnCJeI
         L+m0HcPdvfYMsarNIV793qbuH66dkdJL9LvLEcP92wd5hRsYKTY/LlS6z3XD4ZkKMc40
         HzpzZQhnmsPZ9vthhd+66sCFRcB2jms1REz740asZs3mSzqJjoNCm3YSa5OhDXwVHfKB
         0KrJoACqwBJoB+hAxj1haMR2T6a8st2RCFDUu2CegaicxMHkV1pAFBUrmG7sUX3xfodc
         J3Tg==
X-Gm-Message-State: AFuF++klRiSMoZoQqIQw3OlJqnHDXKU24FMOOs9loK4dL7zbMzlcwQMs
	9XgXztr8s2i3q33yeY3MUY/YSmkghqX+2JXtcwYTsxANDtSTMfv+0jUbbeWMjOFuIaevS4N1HuO
	yRvQV4wu+GCqYSwE4Wnn8ayTZpDqDtbkTDRF/ZghAZpmfLyqFpL+v7oeUGZlSvMIZwV0=
X-Gm-Gg: AYBFou3Ty3tk2kxkqlqe5y3UKShNNNIzLWGsCYdCaVqA8pM8FhDaPWj0mSR+WS6pqnR
	+NvuC9lHavcls1A1K8Zn1LMIo36wpsw1egjElnIr8Bwpu4YYmJxhi/pvuZP+CHj8gdk4OyF6LX+
	sv/F1uvPN8zKJFcOThH3nxXLp/B/QNIYVD27w5WOXj4inH+hOTfVoHm8dwTBlSuWfzqG6d7165X
	o6ltmSv5+hfiHyEYtYdyTtxy0D68L2qCgu6esuG5LaIYeZLpu73QPvVW9eMP/c73S6wkY0SnLQI
	revND5YYcY8cbAsf17/u+coADvR8wSIdpqMn9aJIdoUdJEZccF14j/Z/eQeeOZLsOr5z3pNvf7Z
	DgA/bj+vumQY5Htnho4kYV2Hdrk0=
X-Received: by 2002:a05:6122:8d1:b0:5c9:c60a:e9ae with SMTP id 71dfb90a1353d-5c9c60af4d9mr5452824e0c.20.1790081872742;
        Tue, 22 Sep 2026 05:57:52 -0700 (PDT)
X-Received: by 2002:a05:6122:8d1:b0:5c9:c60a:e9ae with SMTP id 71dfb90a1353d-5c9c60af4d9mr5452788e0c.20.1790081872310;
        Tue, 22 Sep 2026 05:57:52 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:5105:ff9:e148:c440])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aaa4537b5dsm1097669a12.30.2026.09.22.05.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 05:57:51 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 22 Sep 2026 14:57:19 +0200
Subject: [PATCH v9 04/14] crypto: qce - Use a fallback for AES-CTR with a
 partial final block
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-qce-fix-self-tests-v9-4-b1aa742e79af@oss.qualcomm.com>
References: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com>
In-Reply-To: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com>
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
        stable@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1764;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=xyzdu2q1tpL6mhFPCDTUidWRkkUpI2PcImyNjPq2sLw=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqsns5UtvWLW6lIYAfah148jHNJ/4S50XpACUQe
 12MNVv0xeKJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCarJ7OQAKCRAFnS7L/zaE
 w28DD/9nfSdD+17cgYjPaGe5HJAgXHxftzNagDQJH7cEhX9vMt2Mbk+DuGFFwD9Q20XZyUyipgr
 CMs2cyMfWynkJsBRHA+hM2oMBL7xhii8d6+WvWRd9bx0nun1NS81+DB7DbCaqxLnKe6z4cC9jxW
 cpNQ1e8YXfvZ400M5Uc0xALSJLJZKMg8mPje4uDSj0tRaRQDp8MTXT47Sq+YzLEN6EKZRLgSrfg
 U0Oof9KZJutCTjYN3iQ8YZAY84vnJ/Wthr69++YkItEvgzFpDjYm0Gu6Z2F4Q2w6TEzNEMQR55U
 4V/4D9X4cDxRLXF0/HCo3S0IVV4Hf4Sb5m52tqV+/kviEcwJFm+2ENiG5e0GJ0Cl2oIIQJ2+EPP
 WQIXBnI7Nkb48ZswP56iVZpbCw6y7Qqi4RaaoxjLkcYNtXHtVtVZD9jrpN2z80OAoiA0dslO1Qu
 CyIGFZmWvvID54Ciehq0raOUB0fuDtTojLs/v7xv2VGBYThETFvIVOzIlyiNs70Xgcx+F6q7ss0
 7gxW9MyHtj3dJim1PSnVkTwU5VjCQ/7kCLpYDxwFjT/jBE00AB1CCNl08sBcL9wY9L72/kI8N7o
 lVC6AvNYXTB+q5bQ7HNr4cuu53xXf5cjVOdJEjo8UobUDHg39ohLUo8sb/AXBTFb7lJuxZeJXfF
 XQSr60V2vwRoCqg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: Pk0pluh5XpzkmuloCf1BfEI1RiRV7_0Q
X-Proofpoint-GUID: Pk0pluh5XpzkmuloCf1BfEI1RiRV7_0Q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDE4NyBTYWx0ZWRfX5/KyNFZrTZ0F
 /bfFEkAc8rtsUfu/pB8d/GInaYFleI/0nfSzd29yXczayE4vDJdQMF26HDcEY35t0IGzM9huGYq
 6Zv4tN5IRaXidosIS8jQFZJLc+NNktB8jjE7NGDvyat5LxFLHfMCadsdf+ZvByG4IeMkJ2OPRcu
 /JZsM8iAYYYr6EEjk+JqbWDzgDvdxw1zWD+Lxcw+3mXj3bddF5xiF4y6B2hGuLTyYD2ASdX8rpd
 ytBGUGanf0Cg6cwDf/7nX+FtF1TaqenXkIrf5PZCUcCvUkqgOT2hq6Qovau5qy9DUd670JQXdXc
 BUZPq9QWOExAwIbvha0aKMzmO0CkNrmKqQXrHn/Xr86KK8SEdbJXtEsYdg/NXgSz3EKhpitaEf0
 jokDEE7DBwtUNje8d6Zl79NCxGUgl+J+i2dXlVPkM1yE23ZeirRzKVTzxgn/25vJdcoMdDtUuAZ
 1Jid1DHTX9LSPMAiEow==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDE4NyBTYWx0ZWRfX9lk+7yz119ci
 rVGZ50HXyDDG5skKrP+hZoPcUT5l4pXINNmawrSMmdrKI50p9Nc3XtdlfCqC4HGXGzToFMYn8jG
 vRJdwlmVh6nzBzsb4CCvTTv6RKVSpJc=
X-Authority-Analysis: v=2.4 cv=TvFzFzXh c=1 sm=1 tr=0 ts=6ab27b51 cx=c_pps
 a=1Os3MKEOqt8YzSjcPV0cFA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=vUpbTSJP45I4i0_vGVUA:9 a=QEXdDO2ut3YA:10
 a=hhpmQAJR8DioWGSBphRh:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 priorityscore=1501 suspectscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220187

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
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index ec2f21446cee9dd4a5e3a73879925ebbcafe0548..27ce87be2029d896fd987608f091084ac64f5185 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -259,9 +259,12 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
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

