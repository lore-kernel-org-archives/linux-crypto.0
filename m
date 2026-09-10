Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C50F26FA4B
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789045694; cv=none; b=b+4f7nTtNyUCfGqdptP2e2mNGFtpcq6vYJOkf/1p3V+O7QydR6wIM/ZujRAf+rzDXXHG7oEg6ENS/FLomI9G4VK831NNA2mmUYi/bjf3MSAbmiHDpxj89r8ZEq2fKl2VAChXpQ0ARLKqbxsLdgcmfOpby37ZPgflJrQHkGJoQ9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789045694; c=relaxed/simple;
	bh=Uma3r3Qc44Y0Xz31JrEvI/Rw746qZICX+o0Zsz4ItL8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=idNFVaKsHF+TSIBx/Ic+s/PwmcVCtkIcxwWeGvrWVhM7lN6ydr4RshwTLyzsNT0gYTAOJNDLZQYwdOtCsD3GMMQdnJ3IE6+XfbjnRURivEJhD/b5QPvIoiN9zHLCKE0KOvrf6gQssiRhwPYcJe90J9zFnbR4glsVNIALVfjPWJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GadzsUIg; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZwMZDGOS; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GadzsUIg";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZwMZDGOS"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AC7XNU215987
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:08:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/AX/Kem1ZM8Esmp/0yLI0NjEShE6PnXQcN8z1bGeCo4=; b=GadzsUIg2YzBBr0D
	XAFgVM1jy6rl7/SVGpPBAHcFAUPphOJFD9RTi3dEQzk/rymaMtlE884OdBid3NKz
	C23UA2mhV90HOmldiRUW4bJqiFbybB6JhSc05KyBIeJfAk3ymXQ7+C3/uPCQRH5X
	soysu5yYaOMTR0YF3IW/H8CAmBrDXCb9i0r+AlDYUE4ELnUmShccEzxImWU/38QS
	8gloyOD/WKhi4LdFIi/uXDU/QVZS4XfyFUnf+ngHi5Fz4/WKqNHMcbq5JG5hySXh
	fOhCQBM0t36sqCLk63TmfA2dbEmdTxuy3GJENDbkR2LdMAONwkKHVmsy0zWnAoFS
	n/wpXA==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gkrdn973h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:08:11 +0000 (GMT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7f66ceea676so10395186a34.2
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 06:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789045690; x=1789650490; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/AX/Kem1ZM8Esmp/0yLI0NjEShE6PnXQcN8z1bGeCo4=;
        b=ZwMZDGOSDyF4wNjxc0fOHEP+fZkx0jKKKO8XUX94l076q7UgS0+5b0mdrcPWVwVaJH
         CXDcVfH44XxWdQ27mov3pboQY6Yl15zHBWeThZJsVWlCoCS61mfPdEQGN2CXPZzBgXfT
         F1H/NV/khpH2VXsqnGdmrSXLh9zWH+YvyLdGLXv4YygedshwsPmeF8oD/rbFQr/fEOz0
         aPn8kFf+hujGKCdyBIiccdpFeVBH5NSfbla/FyOHkLDVOIAOCccTO8hK9luNXpG3Yoh+
         sTTgj2yK/ZBjx9v0W6CHsyDyflrSixve+Js6jKqyFB5no4+/w0VcY0qBkmHm9F1WzS0y
         ErFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789045690; x=1789650490;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/AX/Kem1ZM8Esmp/0yLI0NjEShE6PnXQcN8z1bGeCo4=;
        b=opgXNnAbRzHHd8TLIdtPViK3JkrLSsTkrRHK1P3NWM7eJJLyI8CVO8lghCIl/yedla
         PUdc+DyPkKw9LrMCEGC/I9Fny0cMyvof/Ig3pOPuuqlM/wBEOsfeZjd3RMpmXW8Mci3p
         oKwwWgFpIYAQaYkhDI2I7ORSwN6TQ1PdlMWqFV0wSllcl5rpgV0UijoyFKQaAOSNyz9T
         ArHuyOC1ThPo2oTBUmsXHmNMMEyHJ/znrOjp6+b1P5wpJ//YqH/GfYV5A1eB7YYts+DK
         HZBVO3FgolGjBcaR0UE6UwQ87y7MLRHPoqlDosNk6V6MZzQGzouFQ1OOPB0fo84XukZG
         ogOQ==
X-Gm-Message-State: AFuF++kxjwsehV/fw5MFWzOxng9EtqPVPoNc/Rl9pce4aKPbb+ukyBjd
	JNqgRVRTwqa9gngFq+8h6VRuTFJyHuP05YhZOnLAf2AhGWrUP78M+7Tb+LEewvOWBy27JTxYgmD
	dVb4iHBCi6sHWWEIlpOLz9xeySo08an8MLOM+zrI5BlizK5JpyuYgerOpFB73hvDAJTm8I7cbXE
	Q=
X-Gm-Gg: AYBFou02EiIkhieMgYzlKE6DdQgMyPRbgLe/71/uvfYxLiTa5MnKQC0NmVyDraAGuBD
	7jcU4yI7h4nkgHhg3QtdfqKHDKWJc1hTVnPoG8r0XvraUC18siHp8vPWiiLkelPZiRsKqhRnGk/
	6xjp/YPElkStpLYu8/xDvOCfd4u6SRAHqWBouZ83gUuI+FeB09msTF3EwN16Y4NDDHFTx6ZPP84
	j0n91R8Km7FDH9mq5zmNFZ9N6lTsq7EeJOyHTVE4IVn3EVKeAjMH+OoVB1hs4h5Vkv95ZJbi3oW
	Y8LM9atBvVbpXGWb8u524aLiPQSZPpTbsy5KhXVsjLTd9zaCMatsFDvbdiNy7vmuUhaaTtFYsnN
	oyKlgy+ifvusGUIqg8J6PkpCicZaG
X-Received: by 2002:a05:6830:43a8:b0:7fa:5c49:523c with SMTP id 46e09a7af769-802103a0e82mr5086511a34.21.1789045690394;
        Thu, 10 Sep 2026 06:08:10 -0700 (PDT)
X-Received: by 2002:a05:6122:6c1b:b0:5c8:4409:602a with SMTP id 71dfb90a1353d-5c844096071mr109779e0c.8.1789045289387;
        Thu, 10 Sep 2026 06:01:29 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:c9b1:abfb:f300:5e98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c26204ecdbcsm831849866b.25.2026.09.10.06.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 06:01:28 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 15:00:48 +0200
Subject: [PATCH v7 07/12] crypto: qce - Use a fallback for CCM with a
 partial final block
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-qce-fix-self-tests-v7-7-cdbd2718af14@oss.qualcomm.com>
References: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
In-Reply-To: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com>
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        stable@vger.kernel.org
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1622;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=Uma3r3Qc44Y0Xz31JrEvI/Rw746qZICX+o0Zsz4ItL8=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqoqoQWFinvRcFAnUPd4tcM/rD2YmCQ7Yz02TzF
 kzcr8WKelaJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaqKqEAAKCRAFnS7L/zaE
 w/1OD/48D1BIRVEjmOTkZ1OTGEWgwaQ/dwyRiP644llwbqISK4/pqV/Inlwv5tE4QpyEdtpTxdA
 Df7w5Bz12wbRguaAd02lo31r61KrjHVTbBVXqoEo80ceuMRk1J+8LfrSYx0NnQ8KtBD2OnSdXZH
 UGbX4HI7FbSjGSOgUMaE6I2wDWVrAPcia/yWFtyS816NpAytkqKHoND3dlHmXNPA17Tet/FO80U
 WeuX5kRPrxp+jcnU9H8af1GuR2T1lV0SwqZ8nsxqjuVoH92nKd24o5UTxcMA0Qpf5WwIAJYcn5p
 P4oN3MJphGRyLvnQ9KS4KHsfejsoGDl13uRKAclEI6TcwUGYooiVrzgqbjcZExh21imLVS2iOO/
 rA7log+daqucMzjZxtW/xMGCdazuGXKL9w5ujt8z5GdSJDNuzpX1OModWvWo4izz+Q0XPrnOFXV
 HBQ1QHPrmlkk9Jnaf2v49MSx1C+9Mvb1GtnID+H73kSN9k9qYSF0uf+z86TYeGJCfuG0OXm03OP
 VQ03TzoyOKAVkTZuN1IDFsd+peHkQ4/H09el9UHpYI8nJgNUdk73/rAFud+y8pGSNzRK7/x39P3
 dXgJX7c19T+RD5BCxZtuFOUU+WoXtnwrcCPWhVg+DY9179m6Ut9dWqgHupDiSryMW3ja44w8yyd
 r8Nz89K4h5eKNUw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDE1NyBTYWx0ZWRfXxLD8g9WaKTLf
 rU0wqIvtCifW+R/bScSlEN/yAaE33aETBYao0Px1joOW0CvayzS+SnaYz0Ac2+GsX05MYmd73xv
 ag7XkLmqWsTx9m6dP9vmvfK3Dbue7/ls3tT5rrwZKEjs6wU8flRPlZZlk107qJYD7vSVh3+DjUU
 oKMN2BcWMF+3AIsdBJngO0nX4kHg7sz4VxG3zebyfM983X6lHfdz2zQzuXo8+LKB40loDswqyRv
 /gUBQT5hxAEP8rCx6kv16AJoOI3j14X0CNPyIGdV1FP0IwzhyaLwQB7txldmZCtq7s0H24FIz4S
 Eu6qELt2VduiGlNi6WStYsjB1irWlVuB8dSv/jWQnsLWwaPE1Rs+G7hdVjT5N7jDbDXYsjtmSch
 5slSgamRsAuGg3zy/Iw2gzs+oPQSRybSyKxLUtGYbNS8wr3wsSuzo4+KuSEIsLz+3NBBPCwLqXi
 uIo16beVmxy5SuHsXXw==
X-Proofpoint-GUID: dmNYyrk9YK2S0ayowyGoX5nRsMZxxy3O
X-Proofpoint-ORIG-GUID: dmNYyrk9YK2S0ayowyGoX5nRsMZxxy3O
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDE1NyBTYWx0ZWRfXw3reyQrwH59r
 DUN7kKus5/8HQYDgbol1q3tW4BFqZcBbLn66OTtUCX+wKwvuAwDE0IBkZ052kwx8B2lTOt72rbk
 sV4Nt3Wkn7ko+5HNhxgsWJUzMExvqF8=
X-Authority-Analysis: v=2.4 cv=eOmGH3p1 c=1 sm=1 tr=0 ts=6aa2abbb cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=dx2SfONCXZg6tt9xEGkA:9 a=QEXdDO2ut3YA:10
 a=EXS-LbY8YePsIyqnH6vw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_04,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100157

CCM builds on AES-CTR for encryption, and the crypto engine stalls on a
partial final block just as it does for plain ctr(aes): a payload whose
length is not a multiple of the AES block size leaves the operation
incomplete and fails with a hardware operation error. This was caught by
the ccm(aes) crypto self-tests.

Force the software fallback for CCM requests whose message length is not
block aligned, reusing the driver's existing need_fallback mechanism.

Cc: stable@vger.kernel.org
Fixes: 9363efb4181c ("crypto: qce - Add support for AEAD algorithms")
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/aead.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 0453b806408c96db9d67e8f1fcfab83f145ffb26..ddae743903229f248d1dc7037c4ae78537476563 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -514,6 +514,14 @@ static int qce_aead_crypt(struct aead_request *req, int encrypt)
 			ctx->need_fallback = true;
 	}
 
+	/*
+	 * CCM uses AES-CTR internally and the CE stalls on a partial final
+	 * block, so a payload that is not a multiple of the block size has to
+	 * be handled by the fallback.
+	 */
+	if (IS_CCM(rctx->flags) && !IS_ALIGNED(rctx->cryptlen, AES_BLOCK_SIZE))
+		ctx->need_fallback = true;
+
 	/* If fallback is needed, schedule and exit */
 	if (ctx->need_fallback) {
 		/* Reset need_fallback in case the same ctx is used for another transaction */

-- 
2.47.3

