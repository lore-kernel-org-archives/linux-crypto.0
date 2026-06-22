Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7EE3B42F9
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 13:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782134329; cv=none; b=DaN0I2JCgVgeTvRSLX0D7Ud9YNyk/Pvtqm2QjYBeMWhDHopu31T+KMC2JjyiuW/n9/KoRl0PThuP6UR5++G0hyz6k4hzKo7A9AcFrY+3gWP5PzhIFYtcUsiZhi+tHDbOARST9MC4jqmoSfktv3PRILB1R7GSQAWGnr4Sh+C68Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782134329; c=relaxed/simple;
	bh=Ejq3GCF3ALDtojefcexMkYFTMI2wVEXKIrBlhj81Swc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=M8YXe6biqf6nb5SQBThAWHqMgNQfl5QIIVQSb3a/eLFBNarViAWspg+tokNlTuz44H12uoN5txQ4SrKKP6tii6R7ePkqJf6y4JEH4uCtZsWf98An466icxBN69WpmL4BOFG4oEnL1ZO4JazgX+uRrkVYK/saqij16TUvNANsTjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Db+8sPSk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=K0oucX7t; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Db+8sPSk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="K0oucX7t"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65MDG1Lo1061781
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 13:18:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	EagaE396zMSCowVPFT/Lv2P0BLvUgaUxoxYWM76TMv4=; b=Db+8sPSkIIyDME5t
	prFz529aRKIixWWmfWO4AUCTvL4DGzP7pNHyy6hI66MF+3qxNaNJGdbmj73t1DLB
	Wzv/KLar0GdtgOaw1Yg45kNX5HX8K91zbKbpRaXHbJHzBDAiwpGEZtHYitDUkUuM
	hsmJiGQk/RbGwgcFh9UMnVBK6Ub2HypnxWOWoo0QGN6hD1FHKzuJ/jvcLyPT7wyN
	wgn6UPxt/kUufKkGsBSzaicgN9l2JOyOQT1ZoEzjKOOT/4x3xIzsmkY43ss/ro2X
	9bUNpiAVxNAnT60Kmho0jAILi8L1zoyZU/8s20eQAuRn1R79PKZ447H1UNPNqUJZ
	Me8Fww==
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com [209.85.222.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4exyn1sn7u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 13:18:46 +0000 (GMT)
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-96730902709so739511241.1
        for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 06:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782134325; x=1782739125; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EagaE396zMSCowVPFT/Lv2P0BLvUgaUxoxYWM76TMv4=;
        b=K0oucX7t3V4q4rJY5bHcCfs8LfSHRBHRbPdz4U2limMAkSlrTmHcGbJsmR1MtxGcOp
         Qn27mgwglfZgBftB5qqxWOX5Z0+JF7lIL7yOXDYZ93HfjF3N//g26U3MBwjhGqrbr2BX
         pq6eeR8DVHrBBr3R8bfAbf28uyb4JTUfuSoIQw+NQkwmYw5X7mET66THg6NcZjbGycfI
         MohsWxDrFVnklOGbo70k5D7sgkJvvSm/wnkfx/1M2OIV333PvE0YvBWzLEXx1kiAmvCY
         Hffmwyb/GAVLGvwXAfp9zLFUp4nrPdaunZz8Qx7sERwH2tCer/ThSFL2dAMYiS3mzLzo
         RQAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782134325; x=1782739125;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EagaE396zMSCowVPFT/Lv2P0BLvUgaUxoxYWM76TMv4=;
        b=N94WpRlrUj3zk8dXYTLtwMwFdFGjaY/rUR+0xzjFQ871XQhEz2YtOTcpWt98umZLr0
         15uSP6XhVAXnJ0saiQw0AEWr3lFktUXnA57C6a3vsDOKPpjN5aqLx9bF1dkoPzhMkJLH
         KbPP2RiK8bJMlHGUyifRCjI/MzHolV8uKI3E52ygSl5kKT5I1gMx2hOp9EipBZ2KLest
         MhfwO2xp6VHXdkHjJDUKOM/4Lmc2V802r9mXnUsrFdTT2mOoXeHQJu/ukZO1Rfs9Y2FI
         7nlDZMccZZaCC1GV2O1puCKH/rH5ffmD1mBVocfE6zYE4I1UvjBXOslBPQ9vTX+YIKa2
         Iy1Q==
X-Gm-Message-State: AOJu0Yy6P4X38Ml5GDYVTsOFc4qGe3c9n5e4ZTuNE2lXu/bsrq6xo1rD
	sqKClg6WOQxe4KjXYSjaQf17rjXW+1QQddzKsCquyI2UgS/DHxZeDDr7hZ+JvPwuMXyTfkvWRKJ
	vSLcK/1woaOjKU71ONS/2dkJ+OzysP+6UhLliJbK4rCvYP7mesNKYhlXMMvP6o1O4dDE=
X-Gm-Gg: AfdE7cnKBEUs/sAogXpBv2mEY+NO1MYpzHDsj/JEcJOWHldOzWIOtVSO+tLtwQxThsh
	7BQJjjGygLzYHO8skXYMhT9U+qFdMcWU5gkJgeLV/f5n2LMoB+RAAR9ngKBWTWEgR+lVm49X60Z
	PTfoTZzRV5fNAbnWjdRqk4/vA+Jy+XQ9kTHsj7tgC7kcjwm4u+/8WuXnl+toHtS/XnrNzkGdTKV
	cXXTEs465J8wLlYbDmjpjUG36qbH5RvmWjGjb/S/8bxx2hsN3oZlejNP+pSn1+gcXrrow7IyV+f
	QO/hf1m6hepOhykHn6mknIX7SVhBdpppqQvm2JkLWvUsWvPv3/0tZsS7soEWp55fnTLe0D1jppU
	hKgz+ktyVmuHjnd0E++T4Gy/GEa5LILesp5oATdwu
X-Received: by 2002:a05:6102:a14c:b0:726:c671:9b3 with SMTP id ada2fe7eead31-72a28dc5b45mr3659841137.11.1782134325454;
        Mon, 22 Jun 2026 06:18:45 -0700 (PDT)
X-Received: by 2002:a05:6102:a14c:b0:726:c671:9b3 with SMTP id ada2fe7eead31-72a28dc5b45mr3659822137.11.1782134325066;
        Mon, 22 Jun 2026 06:18:45 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:dea2:c31b:2872:1bd1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fd30078sm294083835e9.7.2026.06.22.06.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 06:18:44 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 22 Jun 2026 15:18:15 +0200
Subject: [PATCH v4 7/8] crypto: qce - Use a fallback for CCM with a partial
 final block
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260622-qce-fix-self-tests-v4-7-4f82ffa716c6@oss.qualcomm.com>
References: <20260622-qce-fix-self-tests-v4-0-4f82ffa716c6@oss.qualcomm.com>
In-Reply-To: <20260622-qce-fix-self-tests-v4-0-4f82ffa716c6@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1622;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=Ejq3GCF3ALDtojefcexMkYFTMI2wVEXKIrBlhj81Swc=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqOTYi8Jh1v8wUta/O9lvYexzHQYDAyJQDBui9j
 VQ63gP2oAmJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCajk2IgAKCRAFnS7L/zaE
 w1fPEACf0FREd4HRMwqXi9jrqFiMY2ieOc/pFZtlCrygde9QxQOlRqkQ1OfS3/Hv2y3YuZT2tIL
 UbnRMdaddzghJ+gis00EKzz3wSo7rGue5kGLiELEyZMDgXlsfeKaEC6iH7IaKaaVjuNTdhDtMS7
 OSZrUhsojr8g9gpKMQMGvPpG5p/LV/JAQXhPmS+TppIvPzlvKa1kMW+Rhj1tr5hOCwWy20xUTYZ
 cNBaks5Glryvhf9IQ6QxmnZW6LuKmF0RyK2BGejJTcVn4v6fn5c38PnfmHn9KSdueE+g6F5AOXt
 3mMgy/M6+l1DbfbNWAJImg4rUFfOtCYBIKVwvRp85Za5tqTaks8MsjCdtUTdKfdjKbVuXw9aGPk
 iaO4ciSHJ/xkZqknhlTPv7cFh583ySpDdDx3pZFMzNi3IJP6Fyh1cRg/bQG/YtgP5OBh5Pe5ZRE
 nuPsH++F5q8TmOlqjuE2QXkO2RzLFmJb59QuhovDJpgkwTWM3EBNYIkRP+pZaOpwYhIxIPM69BZ
 lcPZhqoK9Qq1sSJVRGc3ZymBXC5yWDhcxBcqeYMmzE94ZSK8g9oQ2Og8ym+wAOg827AqdpiYetH
 0Ko6AoViscjj33ww9ebnWgT2TpqQAy+e986HU3t+o+sNAbTA75uQz0OnWHUMZSUxazmLlF2x9eO
 8C4Cf4Ts4vtCVjQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: SiQEwM2EkclLGk-4ymbyDT1ViNt4no0Y
X-Authority-Analysis: v=2.4 cv=EOU2FVZC c=1 sm=1 tr=0 ts=6a393636 cx=c_pps
 a=KB4UBwrhAZV1kjiGHFQexw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=dx2SfONCXZg6tt9xEGkA:9 a=QEXdDO2ut3YA:10
 a=o1xkdb1NAhiiM49bd1HK:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDEzMSBTYWx0ZWRfXxHEhhY+nw2jR
 WE3pD1BO18lOIYU7MPHz+JjvPUfu52az72T/ixUau2mX5I87WdLrQEPq+Ta5X5MS7hUUvURZRJ2
 6T+8dLy1496mkrAXqAiqD6XKa8y8yFk=
X-Proofpoint-ORIG-GUID: SiQEwM2EkclLGk-4ymbyDT1ViNt4no0Y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDEzMSBTYWx0ZWRfX+dVdVgEEERso
 DO7X5fsRNBNOF+ISzlgKxzSKXK3SdUsGb66s3WPlhlUKYNRpqrXxBZ4MLdr+L4cobTz9pb65TfR
 RYr1o2LL3Vj5Og03aCl9ESZiYfj5Mjm5tVX8Nxs/bg+qrxx/OsuHZNMIQYSt2Q7L4qsC4VJ4Wet
 VJZaPPwRisY9SILL/Li+e1fupZbHX+c99+K8+dVHaSdJkyrh5RaF6mZ9qCN7FjHJiJtXtGLYaQC
 okbJK+z1flI3m1w1bPYN2T3K4BUC4+zjkyacqUSr/kd0jX3VwUg5sTCfym8JJj1tVrvkpqy+K6e
 Q4as8zRus9OMHJhbqdj4gjdUutAWeTpgAGM2xRfd4VUKQdGCKFGo4Oi5s26Fu7vb6HGgpeQ41LQ
 dFvCz7tbqF81+lBFtUP+uvmVqe0MnCgQ5eMJdNy6vXyrKS/nKXRtZ3cKhjGTuuM06G/Z1L9my6Z
 e5KXO1+n5LCli5XXZaA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-22_02,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606220131

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
index 336614a11377e0be246817da584296124f4de5d8..4fa018204cb628c112f64c45ff6c7407df73b945 100644
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

