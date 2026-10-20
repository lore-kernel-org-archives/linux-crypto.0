Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792500439;
	b=g1sEC1RR2c+b77BEyCkVl6kqArc9eeX54g2mOGLRnDRu3vWZjsKGJpGMifhMuEHQaBDb
	 pG7LLMXF6d/6tqH8eBj22xM/thjFpTzv9dhMTCkRf0Y2BDk6d6EjdqPiC1MaiLUlKSws6
	 USBgKTHMcP8auAsAITC8yFshQiT/wSPTqCgdznA2Utu9Kzmz5tNl60S4Tzed9HoGtJCsr
	 YaxLyJ0xa90xqY6GCXrpW0vHPJMMriKGIJWTAc1/5dsWFqnXY2ukTi/fE0FpVATKlocZY
	 2GYXXV0eJBGyjmTaiVKrqEefidNoFiGXboNahCj7x5Ak7lzAFYpyh+D3GR4DD6Fk5sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792500439;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=huFKBQDlZuVavcX0HkWyC9IVz+ofFZPmUDE2CCpGGhw=;
	b=K53i/l4GBnrCfqpCaXecnB7LbloKF/YE/tgDssOOmvs2NPNh1LpiKodXtRJi+y0J0Cyw
	 l7MTyM00cooLqgBbTpvOAj1plcvlPUj5szvm55XdLUnMqvEqStofLrvJwdjCalK82xqqL
	 vId2fZJi9kHja5apXdSsfhyjK3SBrsu3vAOZrbhQrs4B6h7anHxZoRBtmKAVV3KP7zNDc
	 fxc8usWv2UtKwKJVaUiFe53E/DZYCX+BFDBYGai6h0ho1CqwToJvwndiUY0TopvYmktdl
	 UEPj0MfY4/gp4ouVmf2o1vCoFgl7smXIz4VIPruvR5Ab8Pn1bbJOFVs+E6GRYL3VA6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=M4rHAd6D;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=HLV5jyKx;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608E660A3802
	for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 12:47:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 608E660A3802
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=M4rHAd6D;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=HLV5jyKx
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69KBNhrD2067027
	for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 12:47:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	huFKBQDlZuVavcX0HkWyC9IVz+ofFZPmUDE2CCpGGhw=; b=M4rHAd6D1FJIOzeo
	ZlW02DqDIcBFHQK6ttTi+6nivdTF7yZq0PqRV0LJm2dZlqM4C5u34Ix2frU8xjwe
	78t+MkIw2EfvFDGCKB6MBPrNjb53Fts94lMPa4+NX8KcNybfeXY91La5cIRo/3/U
	aCiylSbMA3wbLsQJOxHJVBzp7JOBGFq1zlgaVjs0AVy2wvPv2rSmRzrrfyW6/DOa
	lb/SBoqCszMAq+9orbVa1rQBgQP4Lj/1nyGsXiqc0TJ+pX0TaL7bLSSO+0QRetbn
	LMu2ivdRQv5ZZUERp9C8vrQNpKWu3KVFexTwoKSf88G7SJDU7too5zMDxr/EcUHw
	xT7bwg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hdw5pjgv5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 12:47:17 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93f33438950so833677285a.1
        for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 05:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792500437; x=1793105237; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=huFKBQDlZuVavcX0HkWyC9IVz+ofFZPmUDE2CCpGGhw=;
        b=HLV5jyKxFGVxD1OAThqrzqe+0u+x5aWPYXjXPpjFoEBacG0vk+K50+PyvXLApAjkqC
         AAB6IsJTHGOqO1pFJMotND7h0/Bqy/A82Eog9I72KwYo9wCJSNcR6vApo8PfFQJWnXXU
         HQzheh4/XpoMy57e78tEABZvfkMJy97dZtGuUCo335enoe5NeLkUtS8iFqjgDoaypKby
         DGS0Y42XHZS7nY5Hmw20Hw1D+hGvIw4LntYTc/CSJNt+eK4NverIE9TNNTuWOwrG1yi3
         woTAhM9l9eVvvV1f2ChtUn52CQBNZ+7+K4KUKXEuz/qZzFUTbODALqiDCFo0ATU114aA
         Nu4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792500437; x=1793105237;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=huFKBQDlZuVavcX0HkWyC9IVz+ofFZPmUDE2CCpGGhw=;
        b=MMBmTigk8tCwBEsq96uLDzTmqZdLh0tAyqYy/cpTBofgbcoXJ0djDaqincmv1n7u9C
         WtAQ22PJChAe1U3kfbn2rsiw837JIH4zrq3Yb4qyh795pKOO0Wv8MACmcXqhiy3p0Xpt
         BXLgnKvwWNDKcFU+PpdZCz3cHzPNMsTPhmSKvbmEMTfm9yiBFn6Z3POr4K5OSJXeKUCn
         M7nuXsLNs9Ay/f38Z10YHii/fmBmxBULU+jcIAZUzUIAFMxy4IqLqj06UVuipKnUUmkW
         lNLf2aEt2HEXYar4EyJlcjK4qkVSGKr8KTp0O7v+jIJyv83PP0ezgPznKgpbbFjdmm3F
         nr/Q==
X-Gm-Message-State: AFq9FYJ5xlLiILnjZUYZl/U+eBc9gQomFD8hxfHpZdGzMPOuSzNXuJuW
	bqk00c/DNq5I4jiuAvctSlEUBN4CUk0V6seD+5MiUfEGjxHKM5yG6/wiZnWNVkjZj5NV5ek/RNc
	PVLrnAdYH65MUN4izINRDrCtMLP8I1V2sZ0C1H/mCrwK9bcpOzNxswI18UaQx6cEhCso=
X-Gm-Gg: AYBFou0KGk9nNxpNg/gWv1iSYJceY3hy/CW7IL39mToyDVbWYsRlYp2Aa7Jw/aVx2ot
	OyORgEl7ARZdiMEeNFazYv5/e9StL/+cC3S+tNtMpa52XaA6jYSDkp22npKr7ro89g/7c89pkIB
	gr+2f/yryxEyJv4GKxiKDKKbn9v1LGG3kTgJtToAn6L/ml1QcrmPSZH8jEe74rz79zIBkC96rAS
	4Q2ZR3HcBN5SHgwU6Qr4l33fFly0gsRF302+LgHnnHRIHclMWKyNq+2uET51Ed9yXlv7W2FmyZJ
	i4Ad3NcThP3Eb6oWRTNi2WdldlNvO+QJRPcw3HRSBRHugjv6wewrrFy4svoHsSsy8o0L4em3AXi
	XwbzSPu16XgfSoLBsWqISkSO7YkMO
X-Received: by 2002:a05:620a:288b:b0:93b:d7a0:d9e5 with SMTP id af79cd13be357-93f29dc760bmr1784979685a.63.1792500436746;
        Tue, 20 Oct 2026 05:47:16 -0700 (PDT)
X-Received: by 2002:a05:620a:288b:b0:93b:d7a0:d9e5 with SMTP id af79cd13be357-93f29dc760bmr1784974985a.63.1792500436235;
        Tue, 20 Oct 2026 05:47:16 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e1d82456asm6544253f8f.42.2026.10.20.05.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 05:47:13 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 20 Oct 2026 14:47:02 +0200
Subject: [PATCH v12 2/3] crypto: qce - Use a fallback for CCM with a
 partial final block
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261020-qce-fixes-aead-v12-2-77a2e09abd0c@oss.qualcomm.com>
References: <20261020-qce-fixes-aead-v12-0-77a2e09abd0c@oss.qualcomm.com>
In-Reply-To: <20261020-qce-fixes-aead-v12-0-77a2e09abd0c@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1628;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=GqhpiPEpEa1I70oxqqZo3K9AEP6IrLH9DMi8DVCLwIs=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBq12LLD9DtGJXaTr9T04Ert0KoYT+bbygA4vMVf
 PJyAMr6eI+JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCatdiywAKCRAFnS7L/zaE
 w44hD/9clJ7ieqwrkF3q+9179egCOT3Rx0KvE4ovz+1T6uYEAT91Veqf2tZapFUdq8H+NqE5s0H
 OMHt1J5Lpd+vGnJaReYbYagXOBYNUST9ZXu5W9e4r+wptn0kDUWb7e9hp30K5xZ4O33ixIADjgU
 KoAOtZo0I5pJQ1CTXX2gSAOya8sf1/DMwRtFVNNIwXFi2ii69RJaXyq+iea08vFaFSAwIruZxyL
 B02PwJYSBfSithkOgsx2DcAmabxbfI5ZSEg6i04FtdlRpbK6VgekszSoAtXFrQLpMhBzjKsVjx8
 do2UNTz6vUcXLYmBQzN9gt4NXljvmAEElt/vWycQxpg4nNmMZqFdLeI4NqS3kvQf4MOJD9r9/vq
 V1SPA/CrSXWo4UqvOf0funuk14tBCTyPp8CvC/q3cEye/PqtyzNIOGsXkG8PmS4kDQcttuP+nK2
 L/un1xjZRxcDlcIxxXaevMqgIXUAVxP+cpYPil0HeHbiy6+uH3iVovuyVXMCmubczEL3nfh/+H3
 dzHhs2P39OgEHgm/UQ5De2zBP3/t9oIbbYG5IvAT9L6uLZEfpONWsJLHDNxUR9yUA6/tm3YTNsY
 FPFxr73LIOXY36roVVhOPsFYpV2QXwjba8P+D47SZEMPmKQ9rylbNRC2xrqj41NpsdWBL6SI6rl
 bBq2xfNNIfAoh4Q==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=a7WlZkSF c=1 sm=1 tr=0 ts=6ad762d5 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=dx2SfONCXZg6tt9xEGkA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-ORIG-GUID: UFjGekfHfXnV9iOVPbsCIJeSWVFaysrT
X-Proofpoint-GUID: UFjGekfHfXnV9iOVPbsCIJeSWVFaysrT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIwMDA1MCBTYWx0ZWRfX284/7DayTrs5
 4J5AGx8cFmR2/IuET5cDsD+TlwqCk9UdqLJE9SmaUI19fAHdFtEg7O3IRF9iUtPZlKSCtyw6DbZ
 F/f39oPNzHOKWorUQyTNk2nKJsCa7Ryzz/DKbPMcghtqaRdcjWJUlYcNsYdZ2VjtPj593aPRkSF
 ccsTh1bdjxwQZdtcu0oGUwvOBAHcqfzfNp7DBMYEUwsILK8ONpavsH2PBH24knIYCthHYxNDNZz
 pTmt8aaBM33HxuH6fYvqK72JV71Bcm7hjRkOuVai3pJd4baBamp/P8Tmxz8AOw9zfVruZhMbGVC
 rQgEsuEIuBNtIx476Vnhgxx+vdpsJsY7H+QvBArswd5C72xuay0C+csxfBPccwKIpqD2sXjxqrG
 PFdkG0jM+oa5qb9jCGqDEtmsNjoqiC4OlnwTxyoB3+TTzDNvchXUA8gouekfDttpx6fVbtERNlT
 Cp1+k+7iHfO+Jl+c1mQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIwMDA1MCBTYWx0ZWRfX6OCimKdnkxKZ
 zImnXT2/uupVLUG8xR9KMTH5O6QCCTjpwqFyXXci7idH72TLBTGSHVHI6/bMMdYzuUc5meprg4A
 LjlojAbi68k+irQWYmtHp029t3n/11o=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-20_01,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 priorityscore=1501 adultscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610200050

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
Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/aead.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index b7873852249dffeb91d09df3bae6534f77c08b7e..19d7e92aaeda0df1072114fa0435dc40e1eb6849 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -515,6 +515,14 @@ static int qce_aead_crypt(struct aead_request *req, int encrypt)
 			fallback = true;
 	}
 
+	/*
+	 * CCM uses AES-CTR internally and the CE stalls on a partial final
+	 * block, so a payload that is not a multiple of the block size has to
+	 * be handled by the fallback.
+	 */
+	if (IS_CCM(rctx->flags) && !IS_ALIGNED(rctx->cryptlen, AES_BLOCK_SIZE))
+		fallback = true;
+
 	/* If fallback is needed, schedule and exit */
 	if (fallback) {
 		aead_request_set_tfm(&rctx->fallback_req, ctx->fallback);

-- 
2.47.3

