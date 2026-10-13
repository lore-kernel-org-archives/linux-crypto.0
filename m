Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F8C47FAEA
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885491; cv=none; b=ttp6sIkONMnb2Z10fKZqQW3OBmRr2vyk6+R1F69r1/SlzcOV25VUa0b7tHmoLTrVUyPjA86mwUWtX/8B0PDM3jnGlYtN3v96+PE1v07SSaX0YBdptH7ZzJQmr2QfxImZYvlUtahiRCSxyOmGynYFt0t49qHBJe9X8reGnplCxyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885491; c=relaxed/simple;
	bh=10czG1yn2EOwOEpiuflfvi91l4e59NVnoKNaveNpS5Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=h1D7TLp4WUyaJM2LQCpwtqEsMnv5K/f53yDNGayfaDfGYfwlcjqbGrKPU0vY7jQ6rPmnhdwtzYPGLZB6V/k7gLNIM+WtiQ4HHOpBxrJK01vGFMKuVhehw4QxZPUlIb2OJTE4jOCedUaX6x4/c7WILb3Pwcjke6dEtlsSGUPdc6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QXyeWvDw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cgOJEVUD; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QXyeWvDw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cgOJEVUD"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D7OaVm015557
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	83Mt4HXkNxMhXoNbNZY+WQIFtNOuy89fZ73gqiGaArw=; b=QXyeWvDwyJzJZmF3
	SJPq2gpYsl2cjS918L9xmE5rDouOVwxHChyDHK+jWn1q8Cx3239kqgsSHIa5ncRO
	Dl3y5iynJLOI9Zk+APut40MONc3zpOY/T7vaGjzou8O9QbysdQtWVJfRITIX7J+s
	mgOpWgVsPxyWwTIA/2p2Gcdu9m+d/lL5e/HP5QUjyH9qwxeBzSmAlogYqcZ2sVPQ
	PB7t2FyqEchkGT/XqwACDvpZ9ePraray71r9Qgrr19IvaL0O2MstW9pzJsRxyQvM
	TbaQfXPR/6+QAFE/kpzaQXjXHaMdLjG6yszF3zQ+nNwudHEOErYNfV9jQDuHF11Q
	dv2/NQ==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h9g7ugmjt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:08 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93cc0b31ecaso569677285a.1
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 02:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791885488; x=1792490288; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=83Mt4HXkNxMhXoNbNZY+WQIFtNOuy89fZ73gqiGaArw=;
        b=cgOJEVUDxQZXEiCr2puxnSiiZbzTditHRX06/lo9AP7z63IhxnGWn3VBG4XjHvkthz
         Gvd7yfkIotog9E+lLdO4eEdKpelMkH7mt6+DpiG90zKAKWG4DxJ5I7aXrAtdL8MzAORU
         bbXtrv8efAQY5CQRlZ6T7YVkzqCAmflIyOIe51Xtsiv3XS8x8bBAtKo9U0w1nlgNtylE
         tYHDPO8cbFLcPsq1KllUc0AZjTCNYlcrPTQ2v5a2wzOnPalU1Ze5y19lf/EDHjr4T79/
         GF+Gb3Y74BpNvwHuTG1ioW8xyQhyqIHWYxtXgwsNKnnqNqhN98ssQYZFvMgrJa9trIaq
         ncDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791885488; x=1792490288;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=83Mt4HXkNxMhXoNbNZY+WQIFtNOuy89fZ73gqiGaArw=;
        b=CO2xCMz96g1QFdTIFWwB+0XxDa1o1k5vItpUXYgk+WIiT90dmh656I4v0YguJoQzzP
         kT1m94m+qaAPfbv7L9PMpHDqB2WKLtUrW7oWXCeOZoEWH68hB3iIQ2tldx4BqsVFuSsB
         0wt3xqkIFANE+VKRIgL9QWQDGxxrYg/uwoVUkIOosrNlFGqJVdqZgL2XYnT5Q8VkxNvA
         W0vqxXMyBwTIXmlqNosqXV2N3DvdJYpyn7zcqRUL4X+ZXsruXB1t91mg/M4Gjm6wO2DN
         ZSAM14DgS3UG/G6skTNjVcvV+M1Mg7Zg0RMnhloy993h0YLs/RyJOqSydXdIqo+R3ZtM
         4xIA==
X-Gm-Message-State: AFq9FYIyuRfCtZm68cKG8+uPTMYdystpTu1GIX9fR5JmSik0X+eAfgaz
	5RmCjOP++cWu2mnZE1uJZGRT3f5TMSKibt1r9m/l3IDVXy599QgN2/yZeoIZQnPm6Pr1XmgVvbB
	5oazfOZns5YpfjwqvmcsQ87rciXrTiCp8WBPESFuyNQjF1wKye77fTXEK97ansmpQdBY=
X-Gm-Gg: AYBFou39+R569pw2CACdyVUU+6xwK6yl0jLdabiNYJ50z6jdLbPevpr/WGNTspG7I+A
	AulEW/VCuTrsuXfhgSJFyh+qOjQnAqKiqu+/utYzAHaZwAdbNgRljPpyPh7DGJoCskvtcN1dlnc
	H1Nw9Apr3KJ18+prQjFdvRHMexzSGUN6mpve0B4MrsSfPA+5b8lnsLK8QV3n5rKU+rfTRqwqK5w
	v/LH6Q+YrySpXiQO8A4q60hMkOIQ8MUlrL8eRZyczB95e1Uo+7b4OjR2oh0ZFsVl/k0VjGfCmHQ
	CzRq2pevaUDiRfu24wfqhiF/3AgWEIrH6S0MbjsB2auhx+8JLabcH+hX2I9G3b+T0Ef8pPH+P70
	mXzraIz9QEzNKoS66cU3c/ANPUO4V
X-Received: by 2002:a05:620a:270d:b0:93e:7939:43f0 with SMTP id af79cd13be357-93ebd247f8dmr2055646185a.32.1791885487692;
        Tue, 13 Oct 2026 02:58:07 -0700 (PDT)
X-Received: by 2002:a05:620a:270d:b0:93e:7939:43f0 with SMTP id af79cd13be357-93ebd247f8dmr2055642985a.32.1791885487269;
        Tue, 13 Oct 2026 02:58:07 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bb6beaesm209412025e9.0.2026.10.13.02.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 02:58:05 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 13 Oct 2026 11:57:31 +0200
Subject: [PATCH v10 02/14] crypto: qce - Reject empty messages for AES-XTS
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-qce-fix-self-tests-v10-2-57162a38a554@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1548;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=10czG1yn2EOwOEpiuflfvi91l4e59NVnoKNaveNpS5Q=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqzgCb+PXfJPflooYW0X+6u/+Z1zoTOjPBF4ifg
 sQTVCQOBfKJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCas4AmwAKCRAFnS7L/zaE
 w5OAD/44Cd45IorOSGi7mJwtmQ6WdaX6qmUoR1aecVb53vv1qqtm5lnfb1+IN2Dk7+NrCitUW5b
 e1PMnKqDk1SDFB1UP1LbKBvOtKdIcWNTU0mJCeFaLVKyVcAqxM1Do6tEc5BbNE3NtWI2GljqwHa
 qEbnP9Mhlw4LYMzo/oi/v+EY9qrsr0Hhk8g5D7vWMnfdU6zUGkckY/nQftXfAtqSS0cvaeQ4Ob2
 SN70xeId23HurGpcM0RzdJ+sIYZqwbKc9CaTe6Q22uxaWuwc9VUOarSN3dDE5rlMWr+5HNDhQq5
 I+Oww8JDQ0crG12sVqslneavK/nXvcBcZsh9VA8SflNa+1UlWluUkzPKKVxJfiqKNk1GpnTErBX
 NAkd3jh7LRuYX/YGn9M7vWZAhVPY6DC21q1zpYYu31ssbg4b3MKlr30GOYwVFQaGhm47/GhH7ze
 aqz5RLzouerOM2dr1ApwyecmfmK7GLbmrzFKgFDvJP1qlDg/2KrHsY3i+59TUVvqvhqotv3YDcr
 IVoqrFGjxfOGbjyC3zbkwMdD5J43XN3EA+jLJjjWa9CBoqqRJHSyxarR4EsBYLj2Z3RPkE4VAvO
 UwaNViQiK5BnqSagCdpQcbjNwOkH+Eu1mzLEKKv3OKLxKmGJPKyOlsbdq7XAAt8RIYtuwuId5q+
 X3J3tQo3RtNudlg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfX/uxsFvmLzpQK
 JHDNOCqVvRJWMoisZlm+F3WWEhsgMJTfzdDv63WuQfEoJKa7v3JKBbrZc/xHnf+WGofY/1wrq7B
 bUP17tCMeY5R6vCf3Xa26+F4QoFva1s8XKVYX9zFcluad+IP5G6f1rOvFMvmvWaMSBA/kxkh3nJ
 ktKkmdTIwmfQUzlJJjjaSlkzFkxlcmCOlsPnNJAn7g7vTJynuPk8boruoVtkP5NT16jIJML14Uv
 WMEy4tfKXAjcTaPQHJwf2+cTgZHb9XzcerU+2dSwVfefps0OhJyd1CRPEIoJHwlVER6UviHvK9G
 XzA6JZgKDXtrZLoaQ1uXOJwjDqueWY9Z9qwM4PjLq1AaGelpyhGnGTbhK0lV7i+QpQZBBg/0ehP
 wReAlGcxQPhqcaKCGZ8Xb5Aj/CYtP/EqykQByd73hWRBuIoRLn4Ay8MYLLyUhrvbJjZS5mWmIu3
 B8gT6iw6iH3p5v89MRw==
X-Authority-Analysis: v=2.4 cv=Z495j3RA c=1 sm=1 tr=0 ts=6ace00b0 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=kiYxeA6Iecqc4QeK3QQA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-ORIG-GUID: DpJFYl0mXvZFkIK6YkrxbU8-me4HTmKE
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfX/o1lyDjNpyZz
 HoHkwj0f5Wftmwhk4aXNcVgqdnOd1g9zXJkz5MMGaUJLj9ZLC+xuZQw9EnMmT5JkwHyMBQYjiK7
 G/7m0Ah/6TfN1zwrohMbBQhZcNhy5jU=
X-Proofpoint-GUID: DpJFYl0mXvZFkIK6YkrxbU8-me4HTmKE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 clxscore=1015
 malwarescore=0 priorityscore=1501 phishscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610130039

XTS is not defined for an empty plaintext: it requires at least one full
block of data. The driver treated a zero-length request as a successful
no-op, so the crypto self-tests "unexpectedly succeeded" when -EINVAL
was expected.

Return -EINVAL for empty XTS requests while keeping the no-op behavior
for the other ciphers, which the crypto engine simply cannot process due
to its DMA not supporting zero-length transfers.

Cc: stable@vger.kernel.org
Fixes: f08789462255 ("crypto: qce - Return error for zero length messages")
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 03a3cec2bb90e8d8c17e491ca40ec740a003d1b4..f177062eb735148561f798d0d3e65265f3235da8 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -222,8 +222,12 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
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

