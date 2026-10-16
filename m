Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBE74D2ECF
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 14:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792159932; cv=none; b=rzABiptE30u5EI0HnoAE/pK0MQgizJCKd+uN3mkOjJrHjsHNSicI7nDF3QVj8HWFGS4+B2tzTa3qEtQ/nPVWo1sP/zBNjUDr2xfpkqH+lOo1S+yfivPcfosPsS+ZemMngvV2VRrV3ZuShKEbM8NuPEC1UjlD2UQmOScb0SfK8lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792159932; c=relaxed/simple;
	bh=growEXKfL95i1OZPjUOAOaxVU0oFXi+ujqUIx6R/v18=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ser3FFJCm+dc3WTH3JEB25kWUzLQuG2tQtSdPfyX5HrqI/DwlVnehM56C99d4MQrO+noyFLEzQuOQji0PA7zcSZMAd5EZQSYdYYtGXcTooHzpHugRwx1xGzCeFDasjFg0wr44JCiq6Rn/u7IDPXzmLbGMvWsh2ArfmnYmMPqUAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fQrMijis; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WsI7V6u6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fQrMijis";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WsI7V6u6"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GE68EV2455315
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 14:12:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	YWBaZNLE2NxmhBfPwxyYxR7jIhcDJqVLs/QSuWULptQ=; b=fQrMijisiW15+juD
	LXfLva94PiPeTaNErMrd6kDWtX0YzBGWNNhC7K54HQ70jVbzJaGiC+csoEHUw9rw
	KTUC2hFRaHjX07oU6/apZCDxBAFBgWr5LuEzVjPFKcp4lDRK8PpDv4pLXTIUxQSa
	V6iJgezvq++oH6uXhnICuSTJ6AGq25caFlgcT3dEZTN3aVmZzOBtRAGD9SYMSeYE
	h+iWPOcv0TXAGhHhK4sMISVQb2DjLSWyhGMEUpNdTUjz7M8tYVtrGfpq3th4LiJv
	vlhyOac7/YzkCsWbjM8c6ezyQ9u7ewcgQfJCIafCiHA+luqUtEaPvMKBOefFn/Vt
	PQ+ssA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hbg5ysar3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 14:12:00 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93a082c014aso6024485a.0
        for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 07:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792159920; x=1792764720; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YWBaZNLE2NxmhBfPwxyYxR7jIhcDJqVLs/QSuWULptQ=;
        b=WsI7V6u6skBCenT95UoED7l1l0UBjuzX5PE+2YGWOrP6UqsJVZck8Bisk8kXKNkdht
         mRzfT3jWuYQfAeTj90nKvaurLm/FZevGQDYCiC5VdcvlRzxz5aAK654fjxPQhsePbnOl
         mDXHs4Gp6krBKZR/lTrSTiOZqTPHtBHlL9LLeQupqi8Jl7aterDPBYK1i9WxZXmvLH35
         3IsdF9guEABWsSLRlaQ1ajqIgl21BYju3rvcGZALn6eFM+gMEFh7oNmHrifg/5TJtjq+
         1CP613xUxHKM8G5R45iy2NLhQpGxr5h53+sIH6ohj8Ezun/LBzybGROfFoQtq5yx6jlP
         RAcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792159920; x=1792764720;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YWBaZNLE2NxmhBfPwxyYxR7jIhcDJqVLs/QSuWULptQ=;
        b=EL2l36ufmqy9s9fCEUIS0QoMXvAsyFF3EgZqOru9pwXlbIL+t+eK43fwiTgjpV4Vf0
         XmxiP3CqmnBTBVgXoX9qNpoCTIXbdn5Gl95XhToUmaaAOKlLZ4EYuLLHD8SxPkaA26UI
         R3ABdmS6PPUb9A8Mb+to9p4MGc/6SSiBSmOi3teVH6SzcVUppuqxCUQdu3r9tDs5cjtx
         QMkGnpEhVJnDlCycRl0LxxBKv2da8QepNOD3rCc8Dgya2lwdApM1lRB+sLtMUUDYtzrF
         PYcry9ZFX3TyRj8Hzc9LvqYyX047CB09PqQhdjemo1MYVd1I/uMkjWwTmXVnBtDkMMEN
         RH3g==
X-Gm-Message-State: AFq9FYK2TkvpPXvZ+1Ilb1C7nd+Tz0idVeGnwGv27Pp8iGgniTcahhdF
	kVV7dNwsu9F+K5G6k0vTGn97Wjl2SBjNRHJuRmuPbfO++9VKJBTe+nTuy1sqRBgedJgpX/rJCtr
	pHtQrr9onUSgh9/YVLI2iHJY5CEvgPdiQNMR0m35VGKx2TA2sACykgF0sKjR2UnKVUkc=
X-Gm-Gg: AYBFou0H+lrJ0pakV7iiBKdkCjuBSvwKAeCy6RwJmdLkoPC8jm62rNDclaC3pguY6Jn
	VwCC5X0zclesi1qmMOa8EppNREjshexVe3m+91b0DVNqm0qDx+7rhJQFGdwVWwTtRgx+p22HOK7
	bWuBy7KyM22xq/tlt9J/llJHVNnlJGKPA12jpvIRyHApnS/etqKtPlXy8bem6BfutRogRwUtSut
	Z8pszL53QUPMb3U6QcSCQd21ST9LUMwMBsju/kErPpvWsk0J3elOz/m77f33GXbgbOWjOtnSuyd
	NlZPtKqgsKRqvENokOHTROVH49NfgzLw4SVM934N0/ipmXrEtkj7PtpU8zadbvn/l/AB5XMbrWW
	vj5xs5vczJ0GEwYsdrD5DfShBazEb
X-Received: by 2002:a05:620a:460d:b0:93e:c12d:4ec7 with SMTP id af79cd13be357-93f17fa8fb2mr547499585a.39.1792159919426;
        Fri, 16 Oct 2026 07:11:59 -0700 (PDT)
X-Received: by 2002:a05:620a:460d:b0:93e:c12d:4ec7 with SMTP id af79cd13be357-93f17fa8fb2mr547491285a.39.1792159918844;
        Fri, 16 Oct 2026 07:11:58 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4f8babsm5760145f8f.33.2026.10.16.07.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 07:11:58 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 16:11:47 +0200
Subject: [PATCH v11 2/4] crypto: qce - Use a fallback for AES-CTR with a
 partial final block
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-qce-fixes-skcipher-v11-2-d13ddfe609a4@oss.qualcomm.com>
References: <20261016-qce-fixes-skcipher-v11-0-d13ddfe609a4@oss.qualcomm.com>
In-Reply-To: <20261016-qce-fixes-skcipher-v11-0-d13ddfe609a4@oss.qualcomm.com>
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
 bh=growEXKfL95i1OZPjUOAOaxVU0oFXi+ujqUIx6R/v18=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBq0jCoWfLCOU4A74xiIahuAFqOMrVNEEzNe38mf
 H62uAZckAGJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCatIwqAAKCRAFnS7L/zaE
 wwrmEACo1tT80qq86C7wP7y6yAx74Aa/SHZfhkQgklqsLYyoqNRLy8JFU1tW6LkME+cCWMucmkE
 1eioGn9WgzXIE3ZjRsff5ntnTjgE3Tl4e5dfdCC8W5zluevhP7hZvIG2UAia95ejB1s/FZJlmFh
 dEvfv7429q23bk0R7dE93ZF0ysQL68tYgkxRdpvI2r23QaPikIqra+P/KxtMJi0baWvDgJmHeCr
 e+H00vVnD2/x17xsQoH6nHW6xn1ga1tzOrQFxdWqntd6bKhkY1QdwwkGIDy+WqPvC0G+mHw0jia
 e5ooWHluJaBCW66r8JQ0yErf62x/sT2hZM/5760PvRukPJ1i4y94aA7WnFlhac5s1AosCgfDRtN
 KyOkl1SI2xpcZ34WHrbdEHv1B//Azq5bq10//PHec2M/w8ZLuJaO2MCMWloVPK/B2TpETTnCx7i
 SvPnv0OUw6zOAohpsJhz2g0Tmx8i/1MA67eoDAIR3/+hTQRlK2h/x5bd8PwcLu81yS0O6OS2HyL
 a/UphkjLDbmQDkfqqkXxNSuldiutFm3YOKyq0Y0AhC1TtzuNZbkbXyOt749/GC6f9Flzn12QWAo
 bzS4pi0B/csm+8+29uusXxZTVt0rONyPonhH8u2TqOv5nIwAXMSmWb5cQRYowkx007ytwB4CtIs
 Zvxqjwdh+2v6yag==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-ORIG-GUID: Nl-u7RxdDQQeKhL_26RFssRW4ZBteKsY
X-Authority-Analysis: v=2.4 cv=M+HYuCws c=1 sm=1 tr=0 ts=6ad230b0 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=vUpbTSJP45I4i0_vGVUA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1NiBTYWx0ZWRfXyLoRB/3kZo2+
 RZyaeUIDMT5fRFy6PzeIBM0b4QZqldbtFS+bVUQZSKBDyObv7/Y7FB5w1Y0tu01MGotQ82hw6N8
 dMjVrB7aHKO62oe+P0ql3zFFpMWxIAw=
X-Proofpoint-GUID: Nl-u7RxdDQQeKhL_26RFssRW4ZBteKsY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1NiBTYWx0ZWRfX07hkJAJCi8Wj
 +NfLJStSZxqcjpuysJrNwUhYvj3YNNCi+d8Ujfoo4wJ2Lg7IYX3fyy0MBWyD9kydycmqUkZeek6
 uALDIBpWNn+tDDGUJaFWef4fsvz9CqtzCE8qYn+s0UM1a+DJGYY+DeQlwTUozprg7JW3TIc9/Sc
 RuafUVGwlsxWb0RkmmA3QDGrWDU3t25cgJOoYMic5X+BSQoX1A9blFzuJLrcdoeO89yCee7H8rL
 QEPsY/nTQF9u/8cmUq4uhULXC9yEa6Pt4/nF64sTmaGkpNtrlof+ZkptfSTePA/pDawHZwKhGlK
 /UJ3iT/zxau8tyKWoptPqIH+px7L7tT2eXWo8qXvvWI8yBNWe8JHEv+qyqdWDyxUyz7ggEQ0xcC
 dOxCL0J8Olp1nf4QsTLJ6WQxZZHv+g8iCIYYSOxc5Y5HDXdNOZDivSbWYETMFMeQ9OeDrowjAFe
 9yAGHBgB4KVaUAqhfOw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_02,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160056

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
index f177062eb735148561f798d0d3e65265f3235da8..c23ebc61873f1c542a4b475904c3c3a3d89bcc35 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -244,9 +244,12 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
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

