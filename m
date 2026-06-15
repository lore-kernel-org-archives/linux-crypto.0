Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AEF40B6F7
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 15:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781538632; cv=none; b=afWj/mcUj4bYeu5KOwZUgWs17TSSSq/RZFT+nZ8tFMptfgPrUDxGDukGB5GdFHuUE/4b6JsrSpp/EsKOH40GQYz2DXuL9SKbtyPSNbHRm+7BwFBaQ9jhABtRPI3BUcXb206/+tn97sVzWgo9Yy8FSSf/0M1Zjt0Rbl5vcoS6bYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781538632; c=relaxed/simple;
	bh=p2lkPad7k8iHoVjbfy8gEFAEKYRKdaoCK71ypvf9NhI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JhneIJ9voZ/V3cNJRMCx3ozFh+HjAUo5anDPm6NnOZOpSwubWBjJQpKC8imckEP2ZzldH/kaydRbjRBoifOFP/tHPNbSinD0yErnb8+14h1G0z1fXPrzPmLAXNrs3SufRmGr01vaEw1qto2ndo7pJsLpgu33JZh/udOJQFk0sfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bGvvymD2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XAnwx9Ol; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bGvvymD2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XAnwx9Ol"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FFhMkg446931
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 15:50:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3yjUdgaJbaFa6PDJnEExmCea7RaAxdvGuHpd+tJjd6Q=; b=bGvvymD2W+/OgvDh
	1SiV1LivfAMR89G4fHsisIaIefUdxzsnvmcIIT+X4RkTLra6UVIpew81CT8q+jBP
	u5I+3lhqFbzsi2MjpE5qSgU/Yyz3Zu8SScJA1fNA++1zz6qhNbBpq0oqoXfx8b+X
	lrJvxbbPd8cY08ufNfSDDsaNP68Y41QDzakBeCciVsGeEbK1WwXIDIQbhHbfqV1m
	72LAPRUqZFdcXwU/UcM8hAFkS66cNOxZFTTYGXedDJZa1g5hbtj+AiqdHAopK4Ro
	sbf0FfqHL3fI0e68YnQ0K2cdsZnCWp0CbLzUKgdHGzcP3p5maaSkxQDLG+7o+svC
	HDMELg==
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com [209.85.217.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4etew0hjbx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 15:50:30 +0000 (GMT)
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-6c7b5cf8bceso1347946137.0
        for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 08:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781538630; x=1782143430; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3yjUdgaJbaFa6PDJnEExmCea7RaAxdvGuHpd+tJjd6Q=;
        b=XAnwx9Ol4Aws+YPbUwsXJx3EALe9MdnjIPBLiiHUcwhg7hJ2s8hstruvzIYLnD/Zoh
         y/32dKBiozWbSiwMo/MtUnFAMRnaH9c7JfxSGWRHXYYm22Eyje3BPOgPAwFzyYV07woN
         6VnF6HOVhfRrlQhztisKaSXa17aC4elUneQiQqfVH60jg9yWILnFDNk40hkhrj1N3miS
         KheMkiRL8HG/VVLDeOTm8F2CgV1NufKvDPzWp46f9IdILtBr7o5mVqH96AQmXh5UMRCO
         DuJstKFEtprn4kIKnZ+H4srdHL63ItIq6VOXkGp5slPwyez3a+YX1x4YAtBKyxti+Jj1
         vTxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781538630; x=1782143430;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3yjUdgaJbaFa6PDJnEExmCea7RaAxdvGuHpd+tJjd6Q=;
        b=lTDM7I2YQCubT6V7PG+vHak5/ShJyDHLDXy6czQ3Ev5Z6L1itEGbaDR36B8ZfD/j7k
         cL+P6OlgY0VQIscJkGeZVS1SWcf3z0KmwueqHRvXL1LgUv4NsYdUbt/qzaYAAgLMp6+T
         banU/NqzCEUCq5l+g2nrbn7CF4j1ynQ6HEdzGtH6J2DngjOVR5AIfjaZYJj9blXRsgKb
         9r7zAThYh6i0KbakwAUiOQ666qRJbK1T/JLJNg5hueNq8afRQE8/3z9OK+tBBYdR/nxb
         MHoJR4b14wqPoSnH3Ny5pIlq6gpjtXi8u9mWb/3L7bpDGGCJ6O8/OYazb0S78d4ddsA9
         Whuw==
X-Gm-Message-State: AOJu0YyM86JgPBeBDpk6eKjGdKk0kjhxjyk44dOY3Z/IadnAJa0ZR79P
	ezcMg39oh0wej3WVdyusOrTEaDVQi0ieZ+0/6397zNlIBYgibG7ikFsTTh8ix0xAejpLVWQ1XfU
	hJfJ4OY4jVfaRaQADitdqncDYkLHfP5VBLCzxvfUcVdIAml9tgZVGyFQgYKk5d6MCnZc=
X-Gm-Gg: Acq92OEkvSBVc22ATuHWilBYFinYt5TkmEgMqACF9U5bau8e/whP/SU3EEcZGP9/lTE
	2vSJHT99qZd/4RX5seiWbm1JhUbVNjiXkpsyH0rslCGIPX1sqvBcDVoOv+lKKugX7BwFIhc5Can
	uzuKe7IDkpPlzeonofBrC8A+jIqpBr0654wF3+rNslRAwlhRE2DAiDrM/td3FsHTmx0gq+qVq3k
	CTbJd1FF86jOZgDrZtOK14Noronmd3swdt54x20rsTHoe1X1qaq9Amzr3ryYT4akmSzMuCn4msy
	Ddv7Dk6Cr+Ekh7juX3iPHLkwRrxb8D+TPnKhEdyMM9cuJpW10GaHP1A5LAnEsIKRml+c64/bZol
	iC8IAMCcIDy925Prliy50Oqc/n32YhbWoiZDG7Sis9q2nKNKbivQ=
X-Received: by 2002:a05:6102:5809:b0:64e:32c3:1371 with SMTP id ada2fe7eead31-71e88ae97edmr7413219137.2.1781538629715;
        Mon, 15 Jun 2026 08:50:29 -0700 (PDT)
X-Received: by 2002:a05:6102:5809:b0:64e:32c3:1371 with SMTP id ada2fe7eead31-71e88ae97edmr7413196137.2.1781538629266;
        Mon, 15 Jun 2026 08:50:29 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:7fe3:eaf0:5a0b:2610])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26f450sm38643032f8f.10.2026.06.15.08.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 08:50:28 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 15 Jun 2026 17:49:56 +0200
Subject: [PATCH v2 5/8] crypto: qce - Use a fallback for AES-CTR with a
 partial final block
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-qce-fix-self-tests-v2-5-dc911f1aad42@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1705;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=p2lkPad7k8iHoVjbfy8gEFAEKYRKdaoCK71ypvf9NhI=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqMB8w9UYBQf8k/SKnm8wmtOfEsV351SVcyOtam
 4bNoNgfKBCJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCajAfMAAKCRAFnS7L/zaE
 w0jPD/wOXCxa9itukT5y+o6hvqPIfJ09Oq6s90WL64CIcIRsLBuAlO1zm2uYbqKJNOhM0moWCQz
 OLkWL31iOZIoln+fCaCXfyugEeHsiALFzQUAXg8NMUbJ1HyGsIQRLjCQSe0ygxVC8mAUKkNDn8+
 6RONM8eYxhuguf/k8Ycejq1nHHCyYrr9u8hWnyyZTAiLtxAFkKdk3HgNQ25T5qmbdMKLGNbon3Z
 aX4fi6fP7vn19p/DwgZQUfu0ujf/X7LXopo0JVgjIRw8F8HONQWn1+NnlJQeC+fm0MTbF8NBT+/
 hdsoXzH8Vm6dGNRHqErbnYmvXFuljWkQBJoGbeQrbEUAocsWBwaU7DpOb/jVwsNCKG7XHDjyh7+
 LW/9qRJCU4guinuPzLRdkA0CSFx50+a95z0/KU0qJspftAp9VJMhGMANU7SC4yC+m97cNYery7A
 7oJeXPJMI3YcMO6a824zxEgs3OHl9ZqMEeCPz5gKO6ccGCX0vf5Am7WLNij00CsOotTZFH466Zp
 H2bz5ihj1ADsX612GABx3EcuAj7kSZHDcUtxJKqE2NJ2IXfoB841MGWHnIn18tht+J3zZrUvZKU
 /4fWeF5AjYC4WjPHyj3Yr0q3AfcbcHlS2XIWufxG7l/v9Yv0izNOOcR6cCSb2EjeFCepDZ3FPBK
 zXHIS2gHmPCqFow==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDE2NyBTYWx0ZWRfX3uamjJQXqKrL
 AjK3temIE50mpNOMkfQFo42kCK7vbVjobiLAwu91tp7rs6y8iu1u+Y3epjIdB9dK7j6up9pkvkU
 cuRUC0FqTX9pSDiWx7a4TDIn2Dmn8iQ=
X-Authority-Analysis: v=2.4 cv=QLlYgALL c=1 sm=1 tr=0 ts=6a301f46 cx=c_pps
 a=N1BjEkVkxJi3uNfLdpvX3g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=vUpbTSJP45I4i0_vGVUA:9 a=QEXdDO2ut3YA:10
 a=crWF4MFLhNY0qMRaF8an:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDE2NyBTYWx0ZWRfX4V1nniN1yVux
 P+R8NLpPtkMjOmMPDptOaV7LiP8AqXYCbTk+rjv4SbKK3waOFl4vC5Rq3Y3s7C9+GX00P4D3kwW
 vdJb61et7CrSYOrZ80u2z0iKcd8DawAmwChlJ4ewL+6o5Lgls8xwqQZbNlCFlPHTlQWTFsO3/Gt
 XHKtZfMMVGuUNwzFhX4eXMUsczOVnbUZlxNJIYHKqQ6Bd6F7f05sM41uqG56bX+8bTtZKH43IJt
 c6e9tvmgKJMqJzzs8vpLz9CFB43f92EhQ3PYV9K+nlDhwO6LtqoTNmRmF3A5l9wEyoIHwBdpstX
 Z/k+YDNqMOS7Eu7usEtiMES1BHJGd0kY+BoIizrmTBwb694qwqdT3W26uxUFJ6rwyXNSbYFuhBc
 dSQ2E7N6r6lZjDDu2wXCx+4Lc7x1R7DWxE5ZJAPt2ndGl8/KBrpZJe8/01JbWNe0gDPT4YJJT/u
 QgegEqjazzgMlNhKyZg==
X-Proofpoint-GUID: jNrvfoHSLo0DIzSb2nwQrQB82WabsjgX
X-Proofpoint-ORIG-GUID: jNrvfoHSLo0DIzSb2nwQrQB82WabsjgX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_04,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 priorityscore=1501 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150167

ctr(aes) is registered with a block size of 1, so the crypto API hands
the driver requests whose length is not a multiple of the AES block
size. The crypto engine, however, stalls waiting for a full block of
input in that case, leaving the operation incomplete and failing the
request (and the crypto self-tests) with a hardware operation error.

Route AES-CTR requests with a partial final block to the software
fallback, which already handles the other cases the engine cannot.

Cc: stable@vger.kernel.org
Fixes: bb5c863b3d3c ("crypto: qce - fix ctr-aes-qce block, chunk sizes")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 379b45d2cd952a39c387e84af71238b53f7737e9..cf34278da30b1ffccf230ed194faae2352cb8550 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -277,9 +277,12 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
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

