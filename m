Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9AA409E07
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 15:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781538627; cv=none; b=VQeKFByrzZ27VhxCb1i7tKV7CIDhzPT7Nby78ADyPRcpraezKz4Y2zeU3IFNmxQV5GczE1+vwM4RajtyhArJeV3hJA+NotGw2C1B0bcUpOE626/mIKzEJFVu8y0ibpIcXKuY9t0q6WUMqXtj9DBtJohhqWuHL44OULnQxNpenGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781538627; c=relaxed/simple;
	bh=i2fU3H0f8RtrifvWpGUX+rYKiakFm1ijQ2hsGbX86gs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=W48fyjjGOyQFUSnarVMcf0yte9frK7ZWqQm8fMqIAjFmNGi0i9+KxIXcsCw+OkHQTHUgSEGzz+hwYr2IeW7V2K71NuBUsbyWVo/x1vtY1lRs3UFUSw+T/uMdZ4poPfm4IseLlM5iuCgu2mmg5gh6BeM9fLqWX7CrPrR5nuJpFFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZtuaOlcH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ja73Rj/E; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZtuaOlcH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ja73Rj/E"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FFhLTQ446900
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 15:50:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GvVf4ywBOXek3VYmfQJ/BRHKjKyA+5DXdSFDv3cDrFQ=; b=ZtuaOlcH4py7MOKT
	JJT26dIfoOSO2/9mj4T77e+w9mg79tPF8r55+pdZelqg6m0F12gH7hd3ff+tCGug
	20+ZdV5+TqzP1s0Ukz5OrR0Eb/YRHB15qSqGsNn3lQtAoh6rylq4ptZYAHH8C7A9
	8d0Lae/dVNSoNzAOEb38nrZrBf0ix+ZwMuayvDl3cD4i2/ibTH8PfE9SWljQz8tR
	uaMjT9JF6wCjZyxLXLtdS2EcytKQf0mKvmHff+4c0h8FoFqiSK08GNpY27EZ+9zT
	r2L0SFFNWNxFOV69rwiHLP2qTLooO9qPUQXmij6t45C2ocsu2/xzBf+uMGOIUWS6
	ZRbl8A==
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4etew0hjbf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 15:50:25 +0000 (GMT)
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-6cfe512e871so1418511137.2
        for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 08:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781538625; x=1782143425; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GvVf4ywBOXek3VYmfQJ/BRHKjKyA+5DXdSFDv3cDrFQ=;
        b=Ja73Rj/EYpg/W2kO+W3pWLPWfNm8MYU2PrXOtFrk7O0vpZpcTyOI8UgQ3/8+T8I8gB
         2Rel3Q6RPDIcIddrlmua/mEK3F8zLUXwnvPu/UHng0HorTTefP7TWzRdzy74xdA7wxa2
         KFnYiU15m3odFJi/PeJcP1VzVKclisHPHtf5fMHBvolTn/a081ocyi5ZUU/mMOdagrjI
         3B+6arjV5kVKF60LYiX9G7qHZ6xeJ0eSgCGeSq9SD+iUOkRXGe3FPeBOYvgmiB51XTj/
         YLTjNRLWfQV4+GaZfRzdPe3xmjzdKki3BZBY9Xyl3AcGsEGG/hBek9szEjkUDkf83dFE
         7mDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781538625; x=1782143425;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GvVf4ywBOXek3VYmfQJ/BRHKjKyA+5DXdSFDv3cDrFQ=;
        b=C4aI+X26Edm1jaH0F+T8sQR77U1PS7pOI3qlJFDyw6kqE1GS8K2NaP7xD8LgwkWvry
         hwGBKNSInr07lNwyrthcbeFwUHVL6sIW1gfKHmf9OQ+FxBgyLUXnBb1TWOpTmHEVzyQ7
         pyc52g9XJJztEfEkXlwoSRCuPEtSmsseTY4y8iV+go6Cbfom8VQ7Tk7CeLScHAff8WVS
         svcsLazVOmabu6tM0IayZsJAUTrTNa06WLzKFThEO6goCiGQECWorKwL+ohJP35Oa2pf
         Jzu/r4ZYpELyObJZ3kLi8b9fkKwOs2BwA3Uz61r8jB782LvnxGbwnOauM4bFcwUwIsGx
         tglQ==
X-Gm-Message-State: AOJu0YxHKwy4ZgFFGF1KdImB140fp2Wa/fBoPXKYBK8i3LTTx6r2EDjo
	398vz+a/t21QFJFkNPL9093jsJoilPxE5XzrDpxBkjZkTccJbxIc9TDJziADM3YHk3U63jVm5/V
	x9RxI0U7bNplwNQRlVYLyJm00Huwo0pjwo7uHm9ke0JdR7rPiVD1wukmQxkIFdeehLFU=
X-Gm-Gg: Acq92OHb9at0fTxoh/FLTQJUWWatHZQmRe+gBOMMj4cpIKlFxuZh4nwGuW9+y4jnCto
	VjzRjPvzEr+ObZ2cYP8CMmr4vPju4/5tPcuJ/Um+YMKWZif4Ol1q5EqQbPg3TQhlrwSvS6R7WVk
	HVB142X14uSxjcYsybcktIuiBkjcV5IRmDNRv9jMN3brUGDvVpzp3sd5ltLnm4ti66klpFwfOWq
	aWb05q6dN3ZRMxk+HBlkA8WVqDmy5EzbYeq9gOFOoW46ia831LKPZsN/XqBAb+r9l5bm/TRQiqZ
	WypJB+kajQ+Q5xUNKrxBfstPD/8N8Sf1jyvwxwDdFGY9kVXjyIn0VA7elU5+ZH/BnSWC6jjs2Wa
	a1KWC7SKvvXwy7R5e9QT+oJLG9dtc5ZYPJ8hwLV2z7LCbXoun23Y=
X-Received: by 2002:a05:6102:801d:b0:6a2:b2a1:f16a with SMTP id ada2fe7eead31-71e88acea75mr7814514137.2.1781538624937;
        Mon, 15 Jun 2026 08:50:24 -0700 (PDT)
X-Received: by 2002:a05:6102:801d:b0:6a2:b2a1:f16a with SMTP id ada2fe7eead31-71e88acea75mr7814498137.2.1781538624459;
        Mon, 15 Jun 2026 08:50:24 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:7fe3:eaf0:5a0b:2610])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26f450sm38643032f8f.10.2026.06.15.08.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 08:50:23 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 15 Jun 2026 17:49:54 +0200
Subject: [PATCH v2 3/8] crypto: qce - Reject empty messages for AES-XTS
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-qce-fix-self-tests-v2-3-dc911f1aad42@oss.qualcomm.com>
References: <20260615-qce-fix-self-tests-v2-0-dc911f1aad42@oss.qualcomm.com>
In-Reply-To: <20260615-qce-fix-self-tests-v2-0-dc911f1aad42@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1432;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=i2fU3H0f8RtrifvWpGUX+rYKiakFm1ijQ2hsGbX86gs=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqMB8uiTVzUq6zsXGI17YitgotwtvpOvjWs4SVp
 zEJ8U2hxWCJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCajAfLgAKCRAFnS7L/zaE
 w0cJEACzsfUnjbY5uXwNOwJqpfqt0kdS+dtI9SbD12awmoINPES9jW748rjjS0DgzlcO+jQhlsk
 BjYjjh5MokdL4NXga0Tvju1ZAShPYm8rLBvzv0kHrppuv2xXy88ZAxFVVyOM3NXmf8kr89XYHDz
 XJYjWvK3EnTnB2do3rKalb2ofF1jQ2owvmkh0zr7lvWot0GgBoU4qoy+AzKApEyq+YSrd25uXR0
 czh/fzoUUXmiSkLVQnT4uwmHQPewevsnHUbp4Y5FZR+toXYqYmyFA4I+oXAOxyjV3DubSsK46Q7
 2wIkikvjcics51UKy5yn1AkeygsAaRjDwbKH+e5Q61cclVDlUDka8t1HaMHVOFaqb57KcrVyIZC
 H0s+UGusV2Xoj0VssWKg6ft+mwI7RTPPrPZR2HACdsuD/MulK0F0PhSdMRiGdBJZrPt97y81rpa
 844B07hs9+MxM5dFZ886bTbtxTXVVRl3tAfFKtQcTSNTkAdrm6FGvRlJHs3g8Gb5fC/m119subT
 g8Dz5TCo+HraFFDmM5pEf8ZwYteVE6++3hNRv9lNiD3OVWMIGCiDNsOtV+f2ke6d8yL4JZkubSB
 s+Ow2+T5Ohe9sripLlPTF9b9bgg6YV6B51JTs/1zfNqI7lf1DMHPKX5KQle1cTODt2Dk+h0FYLW
 5Ap4scN78RZmSkA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDE2NyBTYWx0ZWRfX2zWZ/cnN/Dm+
 Q+dNyIjO5pv8Cyd1NbicLZp6ZPiUTIqaPcYmD6VrF0wUWjlLiAzVBoP/JipZODxwfwtmlM3WBd3
 SuTgTLSZ8woivebf41TbwH8wmh0yfEs=
X-Authority-Analysis: v=2.4 cv=QLlYgALL c=1 sm=1 tr=0 ts=6a301f41 cx=c_pps
 a=5HAIKLe1ejAbszaTRHs9Ug==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=kiYxeA6Iecqc4QeK3QQA:9 a=QEXdDO2ut3YA:10
 a=gYDTvv6II1OnSo0itH1n:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDE2NyBTYWx0ZWRfXy636eSNuWRg7
 jGN70W1MptJzqWybkE62JPk6ERa9OtaOeUhafEM6uJgfDcjvYr4PLm8qDTw8jFKYqg5WSNnFb0P
 0HTmRVWr8GAFpMRd+v3u/44+gDA/xzYYNpWf5X/8E872Y5FAZrPOov33gWsL0mNJMqP9djOUc/h
 LlJiUBqMCYuq1AVZwE9ZthnMBEBYkUBLevlvAGI2W+mtxxBVAEr6fiLy47yASXoxcGfNvLsLrHM
 pCq04O0PflckPeS1ckdCkZuPtuXkX/2rqwEXe4ys9kfxInMo4tZ4crWSZthLfoVr9rfOQxLv1AH
 SQV/PddB7nBDSTOHqiO7JwK6A3XDTdwSmqU7G0v+KImohoZZaNLZe255IviSlCvAQHZO0jl/eIW
 crHDEDmWcGqaw/gZUtylJsMGgsXPENjC9hN0XnXsBs0pvzkYPYzUpGA/ey2QOKEqskhU4ma3Nvj
 YafkmmDnoNo/SsYb4Zw==
X-Proofpoint-GUID: pgEvQwAbFKwVk0JrZSbpjvpz9xuvJd_K
X-Proofpoint-ORIG-GUID: pgEvQwAbFKwVk0JrZSbpjvpz9xuvJd_K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_04,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 priorityscore=1501 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150167

XTS is not defined for an empty plaintext: it requires at least one full
block of data. The driver treated a zero-length request as a successful
no-op, so the crypto self-tests "unexpectedly succeeded" when -EINVAL
was expected.

Return -EINVAL for empty XTS requests while keeping the no-op behavior
for the other ciphers, which the crypto engine simply cannot process due
to its DMA not supporting zero-length transfers.

Cc: stable@vger.kernel.org
Fixes: f08789462255 ("crypto: qce - Return error for zero length messages")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index eff80ad5cb943c5b2e1e293c723bb1b31102b006..68b83e3ae088ae42a7fb2a2f0c2e132acf62e849 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -239,8 +239,12 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
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

