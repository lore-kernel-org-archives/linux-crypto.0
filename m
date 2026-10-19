Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7478C4D3BCE
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 14:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792421199; cv=none; b=htp1pqfKoOEnSzwoCm1vMx1Is0vcayRRvd2ey7BqtMdHbAEOHz5N372FtTvXG6FyncUJWAD3rKe3HXFocFMDQMM0Lr19vFQ5bMmGtkFUbR3STL42WW7F16kXoOQuGgjJUPpZWIlLkiat+GXGD1csCtUFj0rkCU9jG4DQpnLH2Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792421199; c=relaxed/simple;
	bh=9e1xHrVqrngx1q2w5pMlAxQNUMEvWrkxxUwvMH3feU0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=b7uQOpz0ZTt2nTet5Y56kXLccM0p8LH0TDjVWOTEI6MbNnUXPwS4rTqpQz/QfumGx53KR1XA6eCqkU6ag+zEGiYZtf5eIlag9FQOI+ieP3LMSrB34kjsBHmjzi6HVJCWzOfrwgeEnLrU8Ow1cxwCXbPLnR8AZPjtx6RHaldjkIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jC3tDrwj; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=J+7jdokM; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jC3tDrwj";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="J+7jdokM"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69JE0ZhV2401860
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 14:46:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ai5AdOZWiu8bcWDZTo6oewJmsAcdheSei39MPbUjKzQ=; b=jC3tDrwj+e7EnAm0
	kIva6ThOIcyiTDhdYutmjYVUqJQZbBaYhCHWlKJXCuO9C5B2huBulQNZfgYIcuhI
	a1a8J0W3e6lb0LVNCtoi2LqMiIh0vCrKthNVOv5WnjFjgVeF91sNvIyGuusyhMK1
	bQUshCQFS5EXJK5GnblSSiaxJ6wQ3oWcwp0nZitSTVbZUmtssAHzaBWl+2tkcWuK
	8VGXkVaPdqLICCcDJQ6yKIM332NB/oWH34apFjK4lRGleBwZxj2f9krHIa5qhIg0
	jpH8SDWn0KQpCv6+H6c5XBnUtJVJeFB1xeToYfpH2RXO+U8SqhFYlYnhSzjWcUl/
	7G7MRQ==
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com [209.85.221.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hdf3n1qep-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 14:46:35 +0000 (GMT)
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5eac4820d15so349609e0c.0
        for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 07:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792421194; x=1793025994; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ai5AdOZWiu8bcWDZTo6oewJmsAcdheSei39MPbUjKzQ=;
        b=J+7jdokMplyRL9IxwlPAxORyL5Qi43u65Sc1HOvl8SbN9ioLj5vXGolC84SuZxLpUj
         jz2Ie8vgk9hThs+iG9tv7LmgYMuCai6AOgV4afpUffn5nSf6zWtcRQbpIN4K+wbfBO6D
         OpUJZZSOVgm4FoJvbDtVy/peKD7k+5NCPErPSLEQEchHz2UPd12Cji3J2KCNRhUS1eoa
         fQkPHb+IfVSU5bHXZpSsbpTmrHp9WsdDLc153oGKWRYzJYkmGgJrWUePW2Vf9dHU0rmp
         BmC3+jJPoK2OqeDqU00MBXmGB/9LRFZBd5yCsh5JHwPVKQy+f1yi6+CpVHenXpnK9P6k
         a2XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792421194; x=1793025994;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ai5AdOZWiu8bcWDZTo6oewJmsAcdheSei39MPbUjKzQ=;
        b=oaGRBP/JLMH+/ws/0HNaWLpFjrr895eq3UnlPZKE2mbtw03GDQMx9mgR7jTx6Y+cJD
         mm3YRIXSu+HBLQQfWV5Vimeio7XpIfvZgydRJY7QqtHex90O83wHfgqsnQdv2S/Gsn2u
         PLepOKLHHEGEUF9j5cKBV7ozP3DELbv8ydEmoIvYj9Om6J0A09leDFRZnlELwAPDUNJ4
         CzG1Fgtd29KsfUpUNR8VoRDGTvuqc3Nn9TpHrw+xwR1a9kDhV7rvBfxJiT9Uz4cWwFXZ
         /NchfCpuPt/TIkK5Opx6hTf2S6ZudzBAmEw+JQGtuj8WdjW9AFBXOTYc5xJ98m8XZCwt
         Q0gQ==
X-Gm-Message-State: AFq9FYJhsZG4cosgfBseaEdhYd92E0SBj3rE1KYVKZEJWDqZWB2NzQSB
	rmfMlDdbKMFFFB0LYFzj/dAE6oDK+pz3blcJbU7Bn81dhgr8WrKsPd5WZ2OdFcofZ2iolqyI+El
	Jk/fjdIN5bX1uxR+L0Gkmh/lrf/yRG5Ql0Huy1oeAruVG+Q6nQ/1fXAYjA0TFZBeX/Qg=
X-Gm-Gg: AYBFou3AJ+8iGzDYl6ydyV3H4KaAmAYkIR0t9iAPhuvS31CvU25rGtFfjpibA6b3B2r
	DzppG5KtQg2tA5QgChqrEW8E2roZDVEsNdnZClBGGklg/RZAnVNp+3wGPs8wvQTqxythaTpBiQZ
	L5arXS9RpwjwrGra5SHK1vLtK1qYEHQ3IA6zkYaLNoL36hPxl27sajHdt5dIxWcP896d9JX+efH
	hF9V7yweeUyAecjqKIbdpvatgYWFmkgCJEppBkER8cX7dUhHmOeFm2TYtGkC+2F01y6bRxVuVPy
	vn3qqTHCf5cvZVBVO4kS1rsWwiXYZDflJITX5Hvz6nTvmppPTmslJS/Fl2jj97TIZXHJbMSJNyI
	5KfR1W19uiAmTVA71E6auNyX1RKEC
X-Received: by 2002:a05:6122:4f8a:b0:5d6:36d0:d20f with SMTP id 71dfb90a1353d-5eaaa99dc41mr2969613e0c.23.1792421193959;
        Mon, 19 Oct 2026 07:46:33 -0700 (PDT)
X-Received: by 2002:a05:6122:4f8a:b0:5d6:36d0:d20f with SMTP id 71dfb90a1353d-5eaaa99dc41mr2969600e0c.23.1792421193463;
        Mon, 19 Oct 2026 07:46:33 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1e7657d4dsm98504635e9.2.2026.10.19.07.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 07:46:32 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Mon, 19 Oct 2026 16:46:06 +0200
Subject: [PATCH v12 2/4] crypto: qce - Use a fallback for AES-CTR with a
 partial final block
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261019-qce-fixes-skcipher-v12-2-046e6be9bd83@oss.qualcomm.com>
References: <20261019-qce-fixes-skcipher-v12-0-046e6be9bd83@oss.qualcomm.com>
In-Reply-To: <20261019-qce-fixes-skcipher-v12-0-046e6be9bd83@oss.qualcomm.com>
To: Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        stable@vger.kernel.org, Pankaj Patil <pankaj.patil@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1821;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=9e1xHrVqrngx1q2w5pMlAxQNUMEvWrkxxUwvMH3feU0=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBq1i1CQgYyGhEyNdGfXYCF6P6beEIQCaiWExaql
 WrjVVESvpGJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCatYtQgAKCRAFnS7L/zaE
 w2ZhD/9wMKfU9yqgeSWTiGkZtiMnwvoJEBxSjbyFtLdKdwJZ4k3RUecBcJkFg3MuiOI9i/o007v
 fIyujnvRWL1qthyj1+6F9fGpC+sj/kqgnSxO+XRMKdblPomGLLsf3Qsl+KXWS989n8X3jUZiKVn
 48n86lQqU8CXbzUaPJWEk5JseZ8eeCNmvsvU4uKAKdWpjWS673z+wl2VgAaZkgE3fzJbIrmgVaf
 amRYb5VCu52Nv2R29m4CZlv1O/6HzK1Q9IyW9M2xVlM7nwx9lJn/EBWrqid090OYtwLD3IsB08a
 XtV01gJiXH4OGx69eflQwKUe9k7nZoxdbfrBDjbMVvZD+OBQsBFd/8N9KDQukSlsS2L1OdTkHJJ
 8x9Bo+odm16fpSkPrcvg3/XwwyFzQHt3nY5p3s9ALXYASvIke2ZvypFdLTacZ3XwBfPo+wov+RW
 8d9QsETpaQep4YqFJGtSRRme9HFV6k9csqM+BefuZbo0QZBQVMKtKXL353awfElqzearXjUkIn4
 6AZUjnObIn/mdnonDmSjtOKds7dD/fk9Wowvv3F/y7nqbKPfDxp/pxv2em0ia6sNeUaXpqoIPkD
 V/fYQ5T4E6HOwHFu5WPt3J4p8juM+TS2x95ItUlexf7KSCoqfPT0zU7o6qMP1mJWm5amsoaDvwu
 8UtNitzuGK+3hAw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE5MDA1OCBTYWx0ZWRfX2Gyl88Cfudj7
 T6OCoIi4BvRHdQ6t9YS0YaRZmqvAX+FXxuOoT2YCWi0DiZfKWEsf+Kl/6j24kJR5wrUDI+codTl
 UBKDOQPcQMbNNjOyybOt1w4RkB2uowc=
X-Proofpoint-ORIG-GUID: oMclPcdGpRa_52klzwyzS4Tw_N7XMLbI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE5MDA1OCBTYWx0ZWRfXy/eqhprmkYz4
 HaJcA6FnuIOUfTguniNpEY3UDhyXioEuYwlsnt2RxrLQBjiThF/7zS5hzdoHz3L0kwbAtueuOlq
 mDyzYlh5o8Ls5DntrCDA0N3ss/dwrNr8KojH6I0mBlqPMAMAH14o2pU7p9g4KyiPEmJNTYE1Ujm
 liYDLFiiL1qO6Z1JKQ5VbxByyRftpO9URJNj7Q6owpQM2T8fTghkxV9NDTSO5e3y9NwBJTx+CsT
 MOo2DXJfyi5d6EiFL1Lo2mPwmp4p/rIJ/LrGPnYrdJ5OkDyBss/SmPTo1SoWM/roWZI8RUIiZRi
 3yvjo/Ys0pHVClDoxFLxdjK3J3kf+dyh42btG4IFoha6ziH7ZRhswhBI993i+5p3ePPFEzYkt8l
 HF+vYb1XSJ2XAk+vLRcOqmWCLx7WQkD413sLneEWvkKAYXOBvvo7OSf3Dla66bJrqyl2ZsV12HL
 Snh8hByQ29C20Ppd2Jg==
X-Proofpoint-GUID: oMclPcdGpRa_52klzwyzS4Tw_N7XMLbI
X-Authority-Analysis: v=2.4 cv=Zf2IpcVA c=1 sm=1 tr=0 ts=6ad62d4b cx=c_pps
 a=1Os3MKEOqt8YzSjcPV0cFA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=vUpbTSJP45I4i0_vGVUA:9 a=QEXdDO2ut3YA:10
 a=hhpmQAJR8DioWGSBphRh:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-19_04,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610190058

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
Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index d9a5b255015341e741515bdfd6ff54bd3b24f1e3..8d4cd1d08c0e9d78f044057ecb45e5aa8b9a40a3 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -248,9 +248,12 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
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

