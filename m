Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D8242D779
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 15:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784303645; cv=none; b=gu6MNUJKWWo5TgnDOsm7OHc9ZgYyTJZfKHNYAVUG4xgt7fO7qFd4z5I0cIVGfK5uPDBG1D+HnwzZKfbSSD4B/W+GCp7C71+SdonMnSM5Co7+RSd45vDvn+oIaxXSnbyt2VZRjs8ggAGE9OumwvRWTS1HUAzPcueSr/JYus80LBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784303645; c=relaxed/simple;
	bh=CYY45MSM4ZMotmXQHnMyBcMwgxFxp0g8DkA1Qgi2eCQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IL/7wCOlhx1SgL9ec8RQgwF+pv06Lv3vwcouNG1z4YhoOdU9ADEofyUZtzwdtvmxFYK0ac3Mys2DRpwyst9MezVsRyDOxGOJP7IZscGm1DWRHflgwtAQHc2getWXRIX26reQFOI7htVnI1N/YnlGMk73zfHrRs1S/lRafzM/kSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HDq6f2j9; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=f+JuH08h; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HDq6f2j9";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="f+JuH08h"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE7p721838841
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 15:54:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	dh/jB5jnhJ+W/sIx1gynQvHO09FmmOdVkDRtzuKngL4=; b=HDq6f2j9C3nRp0jV
	njEegHW1uOTosOgKsxlq+x8KMDIjUiYT1MWFJuF8vsKjKO/jjeYaLb3PRk2KNQ1K
	aBPlceOCDW8+6B8ah0jxTj0ZWLFIY2VIYGgzYcwWa+ULbqgX7IQ0QRSOHUcBmsWQ
	R482wJEJ/2Ip6r7qLc1ZnWl+HIa24726aOJAZNmPYU6rCdSfQ3uEZVye1fyLr/ix
	4csMLN/msATNiRdpiuYEZPNy5/fzPyPsWKlsgkNnQ6NI44DZSDPP6xad0CNrlXgq
	HNVyS82QIuQ0/huzMbTwFgzQ/Tbp4UoTWEwnDVrRq1oxCrR8jAF0kFN+El3051yg
	TACNqQ==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fffaga253-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 15:54:03 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51a8c689b5fso144925631cf.0
        for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 08:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784303642; x=1784908442; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dh/jB5jnhJ+W/sIx1gynQvHO09FmmOdVkDRtzuKngL4=;
        b=f+JuH08h5uD5M+BC3dlYXYObO+KDIl0Ua6TSqZjj+2jQ4RsPg7kkvjvVrHY/u3StMD
         H2mXWzpH41xq7YbhG4EoF0Iok9WEqjk1B1G3RRQXewrI7R683bPQH2D7GlKOvHNC9e/M
         WdXwn7WgX4OqPkx17Vda1WridIoTVMNjhPHG+8QPcImUCIIKKt83x3C6V3yblSe3gV60
         3ydTDC5qmpkOIyVCEcdn2pJtmuXmeHt9PGraQVYmipLSv0Jkw/ADYhH8zYfXYvlO5XHZ
         Kqw18gRK6iEbPTpgKPUoXN46xMaVGgcVMx9NQt+vuHqy1mkZU6j6tePvZ3usYJNjw7Ql
         Xv2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784303642; x=1784908442;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dh/jB5jnhJ+W/sIx1gynQvHO09FmmOdVkDRtzuKngL4=;
        b=MGlfUS6f8NGIKKhT5TqkSMwQca7ngxCKf7kjWTkrcEwNoUpzOt33PqiUUcZu5a/vxM
         EAH1poEHFGEy4FuU5iw5/Xgth6kiUyW06hBGdaHA6494kJEyDQ67hOUmBpW26HM2E721
         lN8HqbJNoFYT6+QUc+rkvbRMq83z0IqoudfQXVkl23ni2uJIBYLjt+zeJ0ZGBR5cLYmC
         p5I9ARZXi/JLfA2iKrwc0bm8puMY2QrkzWxPm9k6o4KHdpKdg2ojPGiGGD5ld2FrOIL4
         iUVc4AaZ34GAW2S4SaEcL0ScEr0xFK6386WGTYa5grj/3coE+VJ32u913lEOFwi06Axr
         g+8w==
X-Gm-Message-State: AOJu0Yzt2SiHsXc6VeGdbre65rYWqNct5E7YAs4KGRSoGqMNNYlReptv
	ATbFikgegbyT2/0Dyw5s0ZeADbVTlexnGdssWGx+k9v93vqo1VydU/24TCXkM+GSmo7XZDqNFFb
	Ipqpks5399rblOOwU4yn+LJ9Sd/jt3MBDLTCLsPP2KxGQLUxt+5JXep1mq8gBT9dxe1qa3z+1Hs
	g=
X-Gm-Gg: AfdE7clwPsYkuCjqRutCXCOa/QBS/6kZx+MLk6TPShBjbNBimMELcnJG++yDgjfnyy8
	Gm4kgqYrmu2zJqlCuQDzLgBoSR+bKQfjt/Z8IiNNreljhsGAYHQ1xO/Y04XccJ3rt7bqBeJKLeg
	tDV6ekpe3kKG47x7RDfwEUfAbMzr+R96aAh3/cg7ELBQuNb2UIQFlvzlq6EpchtcSIrFCldJYRM
	B1NxjmHbp0svps15F71SkyD7cB0VHnEw/p1m7Kk6Awm3QsfYhJPnMXjuOIf2/r+J5MBwqi5ICAX
	Jb9/aOK+xRJh3EvWMa5+DpMHnLApwDfMMXWrAxh9hZDXrHhk4dzIYP0a5JteziIk+7OnM5nnCt2
	g7uTeOW03SHNZThXSI9T0ZuwgYWNj/Q==
X-Received: by 2002:a05:622a:3ce:b0:51c:43d8:860b with SMTP id d75a77b69052e-5213e28f1aamr29206681cf.54.1784303642442;
        Fri, 17 Jul 2026 08:54:02 -0700 (PDT)
X-Received: by 2002:a05:622a:3ce:b0:51c:43d8:860b with SMTP id d75a77b69052e-5213e28f1aamr29206291cf.54.1784303641924;
        Fri, 17 Jul 2026 08:54:01 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:dc44:5b1b:5396:79d6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2a2511sm47057095e9.1.2026.07.17.08.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 08:54:01 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 17 Jul 2026 17:53:33 +0200
Subject: [PATCH v6 4/8] crypto: qce - Use a fallback for AES-CTR with a
 partial final block
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-qce-fix-self-tests-v6-4-455775fe5f6c@oss.qualcomm.com>
References: <20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com>
In-Reply-To: <20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1764;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=CYY45MSM4ZMotmXQHnMyBcMwgxFxp0g8DkA1Qgi2eCQ=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqWlALZQenLLr/l6GpW57S5CIGl++82suMAmuZ5
 GMNqFZatSOJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCalpQCwAKCRAFnS7L/zaE
 w97xEACEMRpS5rM0mvQKz1+2NoVeFw5NLYBoKPeuEXn9B3lucPezNKgNWOP8Wsad2oGtXDppzDU
 21wvJen4WBZTR5aejnWubWL4nGieXdHwFSjuYJ67ADi2iopB+tYoB+QRs1z6Ko8+czlgEYmcQjv
 AU342zPHXYGzRRscvp2It3Tyei4lMu/RF0D3v1fDHGpAqLnue10cKZiFoCNPt9pxgCeE2IOTjZ0
 2UR8sqNa64Q3A0qUUtPhTfFcOXDTqtfj2HryFOPNrTL3306VARPerJRcMZF4ZumVJNixH2V7Ln/
 FL0bcEWQPhOwn5xos/QGE19AF44gtl3v2BYIOpNOjn+Fz4TIm84R0nKzt9hWOeq2WV+XLZTm7Bo
 nbCJRngBj+Xlq0ZHITDJXpdBgpSXlcqd825Kex4fuLfRHhWPNbNSt+oqpS7YMAzeaP3bcLT6vYM
 U+a6Y+bBAUJWLBQW/1FF6u4g8Fp8DGs5lXkiB4GVb9N3QR/DLvB3Et9OomEONhcIlV2zZ/mpGwi
 x+ap+UHiQhdvBzj4KxbzQabNNGL1UG9QD71O3uZPqo62rM0wTV19Wvmr+mG304M82ZQng0IFTMo
 CzwgXieJMhqLzi0TznKtdPd9sU+yii5cDn7wWtGvrBYNKSJKP+xxmazcL+45kMgjC+BACL3YYUS
 KV2y2ef3OlpRqOQ==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE2MiBTYWx0ZWRfX23KcA+KW1SYW
 /BO2QWLEm7NPyG9Pu83lcCDQdewD/dnucvjDHe5QspvFxkjGUrqHjoqVBfshRdL1BTjG2kYb8Ec
 b1UWomMmt824xUWD45gEhSNsG3GarA77ZyeKEonqv1NbA6FDUiFE+va9MmtgNIDnnKTlG/CTgSD
 qVbCiG65ZeYueZon5QCmmrfXI2WnFyGESejsz4b8s30TxpQNQH3p/NQGFpUTZBI9xBUDQUu8iky
 S88Xcm94DntRIeBMJMNtrNuAbr6aItrH6x9edzf97kU8jxd4Va7dpScqWUcBAiwyIrSKE4zJYJ2
 EH9IdLjMU9kU03/rOQg3vMeLKSmHgFzF4hnD4l/ZsTVDzn32ruZAfDMP7dlD+AB1awDdAva+ic7
 QYG3psl50aJ2ACMPjLiqoPzNo60isyCgfiGmMLOP69WqcPbEizLQvSAn7c7S2f3BOftFWFa2HbC
 cLOM4D2zfe0DACJZAaw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE2MiBTYWx0ZWRfX24RyM0L6g1M4
 sODgudIWXWdEpIj84uLE4a725c6IRzzJEaEI4WcCx334FEl4haM30k1gw+yN3HbYdew5ZzksOTL
 hFKWdjNxU1pOaXpa8s7thOSkT5Tj1Vw=
X-Authority-Analysis: v=2.4 cv=KZfidwYD c=1 sm=1 tr=0 ts=6a5a501b cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=vUpbTSJP45I4i0_vGVUA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-GUID: QH7t24SF3rv0H81IBnkbe2840L2m9g9F
X-Proofpoint-ORIG-GUID: QH7t24SF3rv0H81IBnkbe2840L2m9g9F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 malwarescore=0 spamscore=0
 adultscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170162

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
index 35ddbe03cfcd75db7599a5754e4ff978f3528105..54ff013e24317cd4d7a0dcde88cef8268db784c9 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -260,9 +260,12 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
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

