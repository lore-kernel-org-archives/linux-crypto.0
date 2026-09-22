Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BD953F6AA
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790081871; cv=none; b=Z4t58Su3EKHtKy34zfh+IhSZEBy3oB3ifpZyF9859IEjyH1c0JVQZ5g9CqetY7wr9mz4554cR88728zPjbUm4DhKs0j20t9yXXxa63rYQjJwsfb2AdZ0AZrA+HZJkIeWwpYIQ6xFzXAKeaemuqMJvozUBIe7/F4dHUF6HLyKxGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790081871; c=relaxed/simple;
	bh=M8H+MPXamFMq0WJoXACKxu5xswBagOiIf4IGpV1851w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GKh+bqeL1nebeSgQY8d+Ak1+Rrmy1dfft7mV2YrsbmfAOPy6yfQWWJ/3PlXYusL3tgHrLWcgjpWph4UjOfyvw/UPpnv056czxRreb3bbb+HDL1ocunZVY+SzT2GWGuZI7VsxxiWtnS8Cm/P+CoUUPsqOhsGD3WWErdJiBTnZMjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Zt+TEc8P; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Li4zvDAH; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Zt+TEc8P";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Li4zvDAH"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MBOvaM1145889
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:57:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WYSi2uh0Xa4ChBv5axZgn08de+UEeDLKohCgue7QxG0=; b=Zt+TEc8PIENLZEa8
	3h3zGokW40mLifhoR3tcxXoiKI8FE5knm9YNuh4KCt7sZlA1xP3m9A1ZyKe7cEwN
	N9YASAKINGVGipmffmX7en6McR1eFTDfUYg7yW295ulgfYXD3/d9o9rS4Yrgoepy
	8DIyMeOkWRYfDX3g3sNYYsQH7fYdMl4d1uEq9VCciTF1nD5hIBRzu/rzJHW74XNM
	kk/hOQw4R9CWAdPpy763wk9/hsIhro+E5VaUmlc7IzudMdS7nFFNxS4aXcZLgRUf
	v44QvgGFV7o7fLaAG+NqdCJ0Zb7DK7Hf7hJFQndYjxamJrqIceQBuZyOhKdeqi/p
	tXN4eA==
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com [209.85.221.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4guqycrjmm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:57:48 +0000 (GMT)
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-5c82b120e93so813939e0c.3
        for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 05:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790081867; x=1790686667; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WYSi2uh0Xa4ChBv5axZgn08de+UEeDLKohCgue7QxG0=;
        b=Li4zvDAHDxZ6gFFydWcRRuIXCnDdBs+Gejwvh4L4TbLPlkUKugxQJcBde9LuWmVBSw
         NZYrh2UQu0yoprLFMneXAeuH1flz/ko+rjdB0eLmL4LqrYVGSO322d2pTDkOxK/HLFzT
         fOEiHAeaqn+BQCOUqOv3iyeK5LXZ0+K+snPxmMWcciYy20uX2VlOwunnYTT/e7qZm9F7
         331HBDRcyXvjUTLd/7Pl8x19Vov5QAFvkk2Sw02naLRKeWrisSMh7bmb3w5qSa0QQBUg
         meSXPcuQKiA9EvCAb745K0H0t8XZewPQMu8cjOj0g/Gk2t1zbXZmukVsUktKS/Txrq2A
         S24w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790081867; x=1790686667;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WYSi2uh0Xa4ChBv5axZgn08de+UEeDLKohCgue7QxG0=;
        b=PGvusWryW02MZGdBYOAfXskKMg9A0Nv/DZWCYGugZD1e3Fqg5+S3+ZcTrpxDfbeiL5
         /0ytZMDi/8TzwgO6OmvlJFWzeXf2doJ2+8Km9PZv36tE+lHVLo89m/Db8e/4VSlU/T+s
         MZQQF09TyW2SqHRWhfAQs13KDQpnrcd5+a0upgd+YLsZIwIYR5+At2AiNY7K7l1Mx7uU
         sECxalGqAuxwKZpq5qQ40EsQwSeqcRJLUSjl94QHkxEkZkJ/Q5FTVIGqinbRA1CoWAif
         h9brtGFaf9jvIMCSpQR5Zgdd+rdaW85xTpKwb8O89YpUZth2CWKCkiHhe7oyJVT+zuw9
         Exrw==
X-Gm-Message-State: AFuF++m+yrhezNy8WCG1MJywsrdOa3j93ux5PJTAjSfTVif9JIW4a3JH
	T4BR1uLB6vv3B48k62ZLcc8jccsPzvs5kBFQ1fjexc/P7IRe9NR54m9ibr42kIIjeCbYV6qHHe9
	aVyLmkgVb+NTNuSlIWjQsdvWHqhvAgjiCxAVOTAd8KuMrK82KW0mqn8oZ/68R8rFWOVE=
X-Gm-Gg: AYBFou383wZhEV9NHbKi/T4CEZYrRVGkb9fbDfZ07e89EcHH0Nz6ptk1USf/T3PA00q
	1oqmMaWB6Nacr8Z6VZoHM1MW6ofJwOHfufh9rnFkrTuc0ljNdGcJkfhESw40QFNczYniNCp/RSk
	XdAKsAzJ9PKTFzHUtFbf6xz62oQ53ki9ueWIJbddfRuq6P3jbZ1a197VgLv3Xwzj+zhtY4S3a3b
	r0y+3PbLTK6TkUMDaJvKSr0J6XaX3FhV7njAHMil1PCfPMJycZ9rNf79Fnb2i2d/Jc+ZGKE9KYu
	TMsUJjJuSzk7yUHNqweZLkvUE+MvOOOpTL3gKC2xyXPd99kI8MSzV5V1lOBGFvg1FkN+7Vr+kjK
	KpcMMIP9PmfULA+3q0boLXT2utFA=
X-Received: by 2002:a05:6122:3d0c:b0:5c9:a617:5812 with SMTP id 71dfb90a1353d-5c9b8b73530mr8218886e0c.15.1790081867020;
        Tue, 22 Sep 2026 05:57:47 -0700 (PDT)
X-Received: by 2002:a05:6122:3d0c:b0:5c9:a617:5812 with SMTP id 71dfb90a1353d-5c9b8b73530mr8218859e0c.15.1790081866586;
        Tue, 22 Sep 2026 05:57:46 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:5105:ff9:e148:c440])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aaa4537b5dsm1097669a12.30.2026.09.22.05.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 05:57:45 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 22 Sep 2026 14:57:17 +0200
Subject: [PATCH v9 02/14] crypto: qce - Reject empty messages for AES-XTS
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-qce-fix-self-tests-v9-2-b1aa742e79af@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1491;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=M8H+MPXamFMq0WJoXACKxu5xswBagOiIf4IGpV1851w=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqsns2NF05OVLf3x0BlKxlMYYjKLgFGd0Q0jxPu
 SojZU1UJS+JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCarJ7NgAKCRAFnS7L/zaE
 w1jMD/kBe09jKjOM6rqKowD6dBQaMaFHmu91AvkXmalQ5/R0rESCSg1XSr2F3w/dm709XwkhGdk
 MfQwKzf8qKH1pxBWwRj4Q8cmvUZa9r0NZa8DsB8g8nFfrEFYuF8gI3t8GqchqdxN5NwRWi4or6D
 5qkxc0bTGuCup1aEEHQ/0oHzQs3c/xhrUS09T/rE2NRbLxkZGyDZ7tPW5RrOahc1eOsoRBplSlO
 gNxgZz8R42P/78aH0d7BcIg2wbRwgSZu/cVAEnTXN3nMFYp9jwvHULyLMLzWeLmlYBqf0mpihrb
 eszbGS3zEURhE7J6BBqkV3+hGjgIqzu3Z+wvJDgP7jze5CDn12rMUGdivU3m+Cx/Ow27hTQ8i0r
 FonZekhc+R74RLuLmZUT+fqERQH+fnPdLGKAKfet/oxEBiz4d/ijpzBG9wzdWqSblAop5Rafrl1
 r7nEgLK57yfQ74IxKO3+aUP+UE0hyVwmr42mcbIfvUccuA7IavKbL9sec/4tBMAgbSuLG4gxlpt
 dnCgdxAlmQgpEV8dOrvaGfZAWmJfnjn4nviw9gaqTubFasXSNaVzxHSaI8tm/ZR06uuXFHq3PnO
 0lDJKE3q6MIa6BwU9u/XL3UpB68/2ZWMYjobJHBnZ9u1yp0vKjzJqF4ZOOR9ZkOyE8nZM05UzNt
 W5vmL3weQJJB49w==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: jP9y0wkupNa4E6MB2Wu_dMETFVUcJA7W
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDE4NyBTYWx0ZWRfX8o9IQN8lUM9a
 qvH231iyOQI8J7Zd5dw0ZqWyi9B299YmCxWGy8zj3QLYA6QRM2DDF47vLRxefXPdt+YToFurPDg
 Go91wBv2VQLMlXmIIYBX1RA1ZSrH1QpN9ccBDU2QYuGj24QzYLuL75miqfbniYNCe+BsuwLQGGI
 j/l0B09RflkceBgWY0NeaXm4dA4eaJ6/N2phnNg4v/6L1r/kiS8L8faDLfL2Wk9CUFqGapqIqh/
 bf2S4A6uWXdaseCH2KONrtsaHbHzachj26ptT1Y36SC/0yAUTHomPFWH30dz1/yWrF+K68Msj2J
 MmWJ+M+cKt/ibvioaYL1Ob6bnoiQ0E90ub7sTIZHASM89E6gjyZR4vXPn9eHBpjnC+L7ztvJ67j
 HEbsMV0S7K67mCoJTVwclVY2q5UAwWv6cCbVGSicE/gBwuOIpPGnkK5NAJ+ezFLPPDErL0/KV3U
 x2vHD5W6uoSy5rxT1zw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDE4NyBTYWx0ZWRfXxCuD+HbGzurz
 t6BKgNCC917Wu22nCEkStC1aQgvWJoS3heTO7j40d8NfsEKmkJ3ajZVvRpqjzLjEftvrylzSkqn
 qsLzMjXQ7b2kiNs3kWx4PzPY2lqfsOU=
X-Authority-Analysis: v=2.4 cv=c8I+0h9l c=1 sm=1 tr=0 ts=6ab27b4c cx=c_pps
 a=JIY1xp/sjQ9K5JH4t62bdg==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=kiYxeA6Iecqc4QeK3QQA:9 a=QEXdDO2ut3YA:10
 a=tNoRWFLymzeba-QzToBc:22
X-Proofpoint-ORIG-GUID: jP9y0wkupNa4E6MB2Wu_dMETFVUcJA7W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0 bulkscore=0
 adultscore=0 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220187

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

