Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7518649DB82
	for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 12:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789995532; cv=none; b=j6g/gbfjdKgTw4Ll4AdJ2+iuSPAj7lTPrghKMDQDZVLOIbzPymI+qEabIoU99Jjg0W1t0mf7OIuEjMGjayssJ1oB5VeZi0YGN3UwmSD8T051n9TzcBhp+EwH4cQTNHylxK6Tziv5pn8tbmp1xUVn2qO+zgwGheEbp22OWdDfQa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789995532; c=relaxed/simple;
	bh=+q94hW+kiltzd6oZ8H14oSSW0osx3J/1PTA4e8Zi7ro=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PGFsOagoAMaHcFcYxocRdJOXUuZXZp6jRR/Nya7CgyLXA0eznn4Sguj+ROxTmnKxzSV0nAkr8XjdJAgPOFY/F+sIVbI7I3aCepZ15BL120ggUzMNOx8P9lT+lvlfYAtxBt6xo0uS70YMGNS77Rsq5GIIZG3+ygGTUReYKmDP4sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DLwFlDpR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WtQYeD28; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DLwFlDpR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WtQYeD28"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAduH2287294
	for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 12:58:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Apr68ly3hCT/cD0oaIKI9KYaRUniJ63SnCFjliTBbmo=; b=DLwFlDpRW/YNzVdw
	FrHwNY76mp+N7QpoKx6XjiIMj+bHc/lGGJOFv/TmqZ0irmg/6eeoCYt5A6Y5md3I
	FMdc12l1NRMvxfhLAc1+4U/tLmE1m44M3wZ2mGZr4fb8krMYU5TtXTB4KPc0oTOH
	TQ0Ue3b8XDm6Njo9s8Ti2ndheVp51aiMasLCIBKi5j9+gTKExf3Xoxxh3P3IyeUo
	ukTFagyvxke6VVUPTo/0hBFk++fybmYEH1DGz60EDcmZZZuI2+uAZnSQVp6EgWoE
	gRjvh96KXHn8ipuW32lth8Bx7+KG4RoqKX2rvw0crvHGc8sri4zWo/g7f10To+Et
	KqMhVQ==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gu0rj1529-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 12:58:49 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-9390a2c895bso241495385a.0
        for <linux-crypto@vger.kernel.org>; Mon, 21 Sep 2026 05:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789995528; x=1790600328; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Apr68ly3hCT/cD0oaIKI9KYaRUniJ63SnCFjliTBbmo=;
        b=WtQYeD28hWqD5bBRBHAAX43ZMr4RyaS/YnS1cZpP62EJ/cCVcd2VmcRkhxyqatyAp7
         XMNj4/LgKio2ARiAuoZZ+dUsumcmMJWUdnHJ4e6FxtvAQy4v8jjdnOctqHgFJJs1OqTF
         nTMEZQBKjI9LAraqRLR7Xu4+roFUcAqaH7bT8iqE8wxhwp5DfA6UudIGrcHGmWwt7ehm
         wznXRzP+HsOQ85cvRu7lRyjWBb3TOe6ipUDdfb6gpGCFJfKxZtcHRwh1luFppLT6XIVN
         lpV2stdLERCImH5oT+N1IPgSFLsTnuG0adlve1LqIEAv9iWN8vVKayIHMRc/uKnOMtu0
         bIFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789995528; x=1790600328;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Apr68ly3hCT/cD0oaIKI9KYaRUniJ63SnCFjliTBbmo=;
        b=q/zzrbaKIL1g3Qi89DXEZBwpBSUhgnUHHGCKrXNQkkjV/J3pqFfOHZAO4buBwkpiXs
         W0wN1HbDn8M+MkE+5PxIeH2F+oFAeFlkflF2Jqi7WSws9G0JdqhzW6V2hq2xhGipIeLm
         GwXcfmpTgq+jQcXmvDqa3SYCFbxKYP3cR/BJzcQs4XxhB5hR3r9OmEKPrJrMMYzuak6A
         IYtYB+xFlFO9qiy9iYzARrumwI6bE9RVSvd8mlFVaeELuj0lSsR1NIZzG/zBHsKW9YfJ
         LCxu+u0kcc4NV86rpJvYFil0vpvQLkxjtCr6Oimm9hv8MJvBoayXoXMYBBXwr1Vevd58
         xBZA==
X-Gm-Message-State: AFuF++lKVmNzZX733h6tThpDnmjsgRacIh+fQeCZQmDiP6kl97TYCXHr
	nEbtjOyEOkIWSAH3rOPXIJ/cjkNTiQz1G2zt4GV4LAO3sxrWgTmEbU4W45gMXW8kYQorX2XjdFm
	w4dlquHWlghyDboKYHZYQdHtl60ZOsX8sZLG+ITPMGXk3z1xVYvHcI0Vm4YgtHhOicZU=
X-Gm-Gg: AYBFou0NcZTFW+VLPMjSf3dp7YBUZT7zXAk+KUA/wuJVFVb+BcrlumpDAinJ6EHjpzM
	JNsKKBgvd+BJUdP8BQETOiwQiYtwYm57kfSSlYvV+od5MQiqnbGV3M3O3aKSXllr4wNBObaM4ja
	wVwfPLp9var2Om+dCosvSc71G951r/S2poFwlwOMv6GpKj1ZfBwJZHQvhBGsvTH+urrTx4goZhb
	FdsNvsZuZRedIwg4QIN7n+r9wCGQcQC7wQ5Ch8jqCsHjUIMiljWvR57xVca+/cTm5YPVq/uWpk+
	R2Hb8Mjqphs4FPL6TgnA4V0bEf57A6GyqK4mUKm8OjsjEsBopQyDw7SWz4CNHUBuCHy6A2oPz7G
	USC3Rwo9loyPIrUGmbtks8jsv9tI=
X-Received: by 2002:a05:620a:288e:b0:93b:c279:2fc9 with SMTP id af79cd13be357-93c15dda27dmr44780185a.30.1789995528604;
        Mon, 21 Sep 2026 05:58:48 -0700 (PDT)
X-Received: by 2002:a05:620a:288e:b0:93b:c279:2fc9 with SMTP id af79cd13be357-93c15dda27dmr44776785a.30.1789995528174;
        Mon, 21 Sep 2026 05:58:48 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:d04:d483:faad:1e4e])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a359037aasm320278766b.63.2026.09.21.05.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 05:58:47 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 21 Sep 2026 14:58:14 +0200
Subject: [PATCH v8 05/14] crypto: qce - Use fallback for fragmented
 skcipher payloads
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-qce-fix-self-tests-v8-5-107537869a72@oss.qualcomm.com>
References: <20260921-qce-fix-self-tests-v8-0-107537869a72@oss.qualcomm.com>
In-Reply-To: <20260921-qce-fix-self-tests-v8-0-107537869a72@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2137;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=+q94hW+kiltzd6oZ8H14oSSW0osx3J/1PTA4e8Zi7ro=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqsSntalv0A4u6x2wLiP9tsPe+bVnenmBnDZTEi
 sFO8LmZ366JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCarEp7QAKCRAFnS7L/zaE
 w+GQEACZttwFyotUQKFljDEyRe4igLp/89tHuFhol7EGvNxkCWVOkE8o0dIGGtgBzFlEZyH+Ren
 L2XNBJgH7KZxrEZw4txDVrX6y+dODBQ6467be1+9uuS5Ekn5vrtcIRLfGP+uBXa/TfoYXHR7uoj
 g+wbS1siKhyY7aA1clGthUFIpIglEgZ8BymfhP3coggLql9HVFTVIBPbwS0DY0df6T7/UVj50rF
 Uz7gS2+gz1TGqDXoTNyXNseiztBjWyVnGYQ+JfGelyA5qbJGjNDQtoMHzBB0WYdmjuzFlLCgrFn
 Npdhk96sesIt+0dnTTwPFur+M4RmM891qHXDaOtCFjrQmtG0driYLTLOXE+wDW2C5quDaXgoJSz
 cbLi6Hh87+HwAlIiriNOVyw+QZ68KugFY22VGpklYM5BN5IATNXmA1GhaG0LEUTUl7HOpDytxja
 NJJzPj4PCafhxMcX6YksGhA/1uhLnFf4HWgxzAwJWZnCo3Zf3t8jAtN7bWY09YxaKjpLEgb3+7c
 ma21hCkFl7pu9gsNgjPbgVdDQ0vbFe9hNMs/tkYm2ckq+tqmaKK5uj11C8m4Fl9svSfIeLhHB+8
 3vW1Yw9A34S39gu42KjICzuHKmvoAoQKcO4GlCOgKvizSKjiVrVuXmy+u5Jvr+o3Xwhppx5Idfw
 sMiF+eju8KO3Tbg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE4NyBTYWx0ZWRfX8yn15/gwHPPq
 97wyIWc32nHzxcI6gQa9yGKmoNE1s1qOVdJ4H5fr6Ejlh4av5U3elxeYG8o0g3kT8rK3vhBdLPc
 lM/u+Cwfel7x4SOIfHshFwr8wXyg3YU=
X-Authority-Analysis: v=2.4 cv=AsR7T+9P c=1 sm=1 tr=0 ts=6ab12a09 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=2ArJjka39wvl4ErYtigA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-GUID: 4aa75nqapd-ihGe3c8lvqXjjkkm7CY3d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE4NyBTYWx0ZWRfX05fqTRDtihus
 trhDSWHOZ4bvpvwkpgl3jlgyp4ovCtrVSR2nVA+/aSqDWu45PAA1roX0K4GslscKL4c8/VogzRL
 498gvo821SnofqKtgl+yxyjCbJsIiWNuVgZITD51K/ipLwIiSznRMdeQc6zgtrzvmvYS6qRwy7p
 SgkOtz/F+y05AOlYr0q4HQJLWxXYUNAoQAwVmTVthROQ3fKSIEE3JptXotQBAI1P3a7VyLHCezm
 SpxtqaMErStDgJe8oF4GtEj8DwWJ6+KOHKFFkJIOmsbYN3ta1ah4Xy0M+pwNhzUsXQUHorEyFWT
 1vKf+9HO7Pw40KBx3I9D2T127CSwIJBlmL2Y2EtYoSfIgkbwqgCCwXtWixycrSKE7FL4zFRv7WZ
 VrQ0e/ZaQPGZWZKIKPhWPT+IoKNO7THvODRZ9b6TZQxTFDtT9iuG2G7nwRDIrf3FA1kFoCtjI6w
 jtnWPC1eYYlOK9c7jBQ==
X-Proofpoint-ORIG-GUID: 4aa75nqapd-ihGe3c8lvqXjjkkm7CY3d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 malwarescore=0 suspectscore=0 clxscore=1015
 impostorscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210187

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

