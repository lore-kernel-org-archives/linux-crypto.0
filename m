Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FEC318BB5
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789045596; cv=none; b=IVHqPnoupZxlEhqSr1iLDs0f1b3joD93XCLeerEitCyU4vW8jJzLHo7i5bN1S+kvpNGkY3b4yfOUSOe2IQwM/dAVNCXuosfUkHcWg9lKnhnME6uI77fpdxsX+t5qZb66SKk5MtckExhtmE1tEln1XzQHS9K4n9ehQtPiFO6c++g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789045596; c=relaxed/simple;
	bh=+q94hW+kiltzd6oZ8H14oSSW0osx3J/1PTA4e8Zi7ro=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IMPof/CCl4fXjVJjMj1mBHehW10c4NbCM7CiM+f1A4q85AsIloAGLaq2pT53I69LqkmDv6ChZYSjy3avIo4kvDlccCP08iiXrlPxQpdpzDVrKMZQCBIG2yRtCV+LZ9Bwa+i++JCm7AkiyNU7z//3D3x3eYWIXawRTBIwCMIDiBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=P+Sm01bS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=A/fcUntp; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="P+Sm01bS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="A/fcUntp"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AC7fdM1440486
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:06:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Apr68ly3hCT/cD0oaIKI9KYaRUniJ63SnCFjliTBbmo=; b=P+Sm01bSkMAvGkup
	dVKFfucx9enT6NmWax115NJ25NxPUw0H4GqTMoA1ZJR9L/4Dn+o+9TJhgS2Lyvbf
	uzEbB1K9Bj9KVRMs48a/LlPLyvyDNFJjmP397VgzzcnTDvk0HXWcKrEfxeQn7oy+
	y53XvphpRVGHb902oAohk2Q2IzYmvPLeXoKIQzjh6+2UKvMxCCwhMBVxf/faeg09
	o0cviNhrIg8LzlyK+Bac9ReJzLo2ai4n1OycTAzgfS6mRG+IZhmAQ2rDCAkOtXbx
	yR45jy1hFCjmkSdhW2wg/moM2dbWWHWnS1VPQulwhCfh1U0XrZoXQkT/gxwolt/t
	+exAtw==
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com [74.125.224.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gkqsvsc3f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 13:06:30 +0000 (GMT)
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-66ce373dc9cso5574007d50.3
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 06:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789045590; x=1789650390; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Apr68ly3hCT/cD0oaIKI9KYaRUniJ63SnCFjliTBbmo=;
        b=A/fcUntpm9wrXVLkAGs5pdCpZ2VHaR/pANqv6xgKL1DoGJDAwzABv9MmmfKUsbeIEF
         QAmq2WSH/HbST6SFAaQR7eyCH1mqXZR9L1gDPeUnEUGczDu1waMFx3l1cJrfNW3QuBHa
         tslGKLa8J1f2H0Nw9ZUyQAVL9YKqzEYYUC5bPPIKETstlHxmCgHTBms+aeLI/PbhmsyC
         mRvZ1MktMWvn0YuyJpzDDGcw30Yj7a70v/Po+bZxcqVGcaDuskCy+Hlpq902dfrHiMfa
         M7LoP8a9kErlBFfJT2faqs+bRCwuM4oSJONCmIeSUPHliJSgCykshRhzLjGzGCf16fhR
         Yl5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789045590; x=1789650390;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Apr68ly3hCT/cD0oaIKI9KYaRUniJ63SnCFjliTBbmo=;
        b=pDy6k1dKYNhwb6790P+oosaVm5fKsB9QXGbKW+RHD1icSURNKQskJJI9JzR3mBBX8D
         3Xd8aaPcUWNT+wSaCLl8VezQslRT5IOqYUjfxe/iba4EjCHV19IxRSk7bGRQjsVxwW7o
         mgTG7sa8YpxpN8g6OZtJ4GvP4c1/dqjmCnpoEs7E1SDoOUJwiYC2fDH9/VsD5tM8iJy3
         H1oEvABYW4Nf3vlLZxTGEMZAAbW03+rQFmaBCpEGDQDWN9U9KafSlpzOdbYyZ7TFJo17
         VWlCiMvm1QkWF3CoDUEOICgQOJ5evOXvqBk60JxAjOeITJkaPPLE66LZT/I1OeJ2K4HI
         KiYQ==
X-Gm-Message-State: AFuF++n27gbsrqlxC2PYS3+XJJlIWBKbbFJBWbpx97UIoYhzk8uqwSL2
	GiqSWHoQUz6QDQqEsBgdNCAQbEnVI/e11L0Fzgm+UWaEzcVb1RhJeMrdMZ42QcCVgSXsOdP5bXZ
	nzgSRwRUH+rUAjsXEkldGWUYH6qZE94beQr7nHyjQp2uw+p6opT9WaTGmMC4RagHoTEnS0Nw/zR
	M=
X-Gm-Gg: AYBFou1BXvBFF+B5/dyMQ+YzmQKiwtg2YA5HaFQpqhFvjeHmSyOCfWV8L6r08ERy8xR
	NyHmMkPCiVC9aeTMJSUhxfoaa1y+P0KTauKnvyLlAxgtoPl41qLBFbfUit+cGa88ZdKMOhVyqck
	Yz9MZhju0T+Kt/HSZuEr14pSQQ0+yOcALDtj9nvKT9fB9lwyWPBwPlGTs4yJboMxBQeh0lotnbX
	2K3oA+Kh59/C6qcacG5TArGbJuzbh1kDG4m4pVBIxPi3HWXaizIyoCRbyfdqNc0u4oxLOHm7CWY
	hzIq4gieYp/UzbmiuNwY9iCLYj4+uEBx0cpZaNx8vxJJVk08EYycN4QLioPDWILcy2FavgyBzEG
	XIHr1ZVqyI9AjGVi1aw00tl9uzOLF
X-Received: by 2002:a05:690e:128e:b0:66f:c8e4:988a with SMTP id 956f58d0204a3-66fc8e4a81amr10216396d50.72.1789045589626;
        Thu, 10 Sep 2026 06:06:29 -0700 (PDT)
X-Received: by 2002:a05:6102:5e91:b0:784:b882:9567 with SMTP id ada2fe7eead31-78a4a9d9306mr22259771137.6.1789045285030;
        Thu, 10 Sep 2026 06:01:25 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:c9b1:abfb:f300:5e98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c26204ecdbcsm831849866b.25.2026.09.10.06.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 06:01:23 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 15:00:46 +0200
Subject: [PATCH v7 05/12] crypto: qce - Use fallback for fragmented
 skcipher payloads
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-qce-fix-self-tests-v7-5-cdbd2718af14@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2137;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=+q94hW+kiltzd6oZ8H14oSSW0osx3J/1PTA4e8Zi7ro=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqoqoOYC9y0PnnwCtT9kBv8b0ovnRcrryw4KSyj
 wGEI5TzlV+JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaqKqDgAKCRAFnS7L/zaE
 wxskEACFOaBj8VCu5B2daTrv5BL1EJdlpaGjPEAc0+autgVw4uDpHrgV+3wQF3YrzSRkh/fJvpA
 hbD1xtYeBJiSF2Ufat0CflOkswP9FSXfiQRPHThyNoRWSS33fwoflUiKMJgGcQqFwtb3fbb0Ntw
 kdthQfMGge4Cbc2g5veN43m/7MpABusDQfWkoWy+RPYyJX1Xc4q/VZwNoVPzUEViD23Bjtp7oV/
 QORX0mTsV9En+Ac5bpj98aM4C1zgYbyF29uemcDC6NwAUEuL2NzpmLjY3OcCPJl83pGNOx+ND8g
 GKAEHiaSouMnH5Gz7P1md81OLNWq65D0nSThs67VRqOaX3q47TSr5BBRvWY9FniDfWR0eMjth4L
 L/Q5u6sVi2IfDxrN+e3LhTOF2L/Du6mTR3yxafNhyke3I1IhBn3cq8IGk2BfQsKpnqiyQ7h4xEd
 gNWzwFH3+IXb1b/vclTk2sIPE41p1kkNcdGqzrjbjp7pLHNu1odQAdJeyMs3iqQsbuMgJqApxWV
 dSH9x53GNGoylA2PkFmmDmhU4FqUowB9r6DzPK+gPWwx+hpo+IX/n1mxV5XVyKhwNEaCdfjy+aE
 Yw4Td64K0jdXuxvTWoL4F7Vk9KReUSLCyLGByeDUmJIr0HsLDJFsfwNnedw1YkSk/VdP7Ii6kaG
 JLQ/08FYJW5Z0VA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=DdOCOftW c=1 sm=1 tr=0 ts=6aa2ab56 cx=c_pps
 a=S/uc88zpIJVNbziUnJ6G4Q==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=2ArJjka39wvl4ErYtigA:9 a=QEXdDO2ut3YA:10
 a=nd2WpGr1bMy9NW-iytEl:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDE1NyBTYWx0ZWRfXyfBwGB9s8ygn
 46OVsimecaHGn80ufkPTu2VzkafnmbwqPFJC9CWfMYWlXTRii4ueIZ2KeL3WR0SJ3g+6v7EL5uw
 i952qeePjOzsN4FAUmagKOVa/kY7xJ5FUSS44iuav8jLgiOzZ+Em1WIIGXT+3KVgZwOHtcLQwjv
 TZxKcdSnHHNd6pTzPUoK3AvEE7SK55wS2sWo+eRxUnzp5Cuo6yKsYqlspnseBUXT2QR5rXDp9cl
 MO4WjGGwq0iS6P+ZA5Is9l/odjXzRo4UYfb4wdLbO0BjH+nL/tShNbBAsWHgixoU4EvPmr7pdfL
 EMnlkpHZInLPqTIqzOyKIsc6YJ/T5pz7nD/JfmwSaQsJ/lCnyG5caKIETuaLmaBb5tSCnSv7GNU
 WUwlqLA7iHMU5arFDUGZlYGim5sY0OB/+awXyHhjP60L+T5xPgPLjvhEC8b7vai76T49Z2B76WP
 8zXtSejQAfBjvWYGWlw==
X-Proofpoint-ORIG-GUID: dld3IQgHNr5ICrbkLypmGkz-oGcbFwop
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDE1NyBTYWx0ZWRfX8hc2IN2NfCzc
 UDTec+6K0f800zjsB9UZrPmk3DP7psYFwAMH8pwZTI/JrA6CUVbPqH8ppfIkAV/hwDJL6LLqoFN
 l7/tYt9NoIHnE92u2RHxLaAk1zXroeU=
X-Proofpoint-GUID: dld3IQgHNr5ICrbkLypmGkz-oGcbFwop
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_04,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 phishscore=0 malwarescore=0 adultscore=0
 spamscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100157

The crypto engine reliably processes AES requests only when the payload
is a single contiguous buffer. A payload split across multiple
scatterlist entries makes the engine stall waiting for input, failing
the request with a hardware operation error. This was uncovered by the
crypto self-tests, which feed the algorithms randomly fragmented
buffers.

Detect a payload that spans more than one scatterlist entry, in either
the source or the destination, and route the request to the software
fallback.

Cc: stable@vger.kernel.org
Fixes: 25b71d61d631 ("crypto: qce - Improve the conditions for requesting AES fallback cipher")
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index e2ca2f7a6eea1129edb724fe30659d55aaae8190..4b7545e6aed220b7fb5af7dbf20ab47db5d1d180 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -261,13 +261,17 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	 * needed in all versions of CE)
 	 * AES-CTR with a partial final block (the CE stalls waiting for a full
 	 * block of input).
+	 * A payload fragmented across more than one scatterlist entry (the CE
+	 * stalls waiting for input in that case too).
 	 */
 	if (IS_AES(rctx->flags) &&
 	    ((keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256) ||
 	    (IS_CTR(rctx->flags) && !IS_ALIGNED(req->cryptlen, AES_BLOCK_SIZE)) ||
 	    (IS_XTS(rctx->flags) && ((req->cryptlen <= aes_sw_max_len) ||
 	    (req->cryptlen > QCE_SECTOR_SIZE &&
-	    req->cryptlen % QCE_SECTOR_SIZE))))) {
+	    req->cryptlen % QCE_SECTOR_SIZE))) ||
+	    sg_nents_for_len(req->src, req->cryptlen) > 1 ||
+	    sg_nents_for_len(req->dst, req->cryptlen) > 1)) {
 		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&rctx->fallback_req,
 					      req->base.flags,

-- 
2.47.3

