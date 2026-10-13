Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72C0486431
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885493; cv=none; b=Q3F1DTY5WGXxVuTDmLXEs62IP2d2LmEELarJNRTRUeJ3uvufbYPK/VZiAeb/A/wx8+XS/gSlHqmOUmhl36CgkhEPNyR2/KVRSMDFNZSjOK3VmOu5F9AsNGcPtn0GK0TKe7BL5voq8kzftvCwJldRjOCaDCHAq8xXrTJxW1JLibA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885493; c=relaxed/simple;
	bh=QFn0hYtnIddGPu6ZD1e4kramclvX5BS5lZcNIdMhaEg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tcs9ZP1NZsFlQwDZL5wq/asF5wDa/0SqSJGjNj1d+yy+SLHAuxoBlMpn/MlyDQTAshHKUcyocF5yJafCl+T5U9oWSggGHuwprVJKRLlrE6nmCXra2n3+vHkKhfsIJeEzEUvoblnWCpXSVZBVEb0vwL9fnlEEUYXPZLOUXgm24UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=StkXkT5j; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ixQRvaEE; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="StkXkT5j";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ixQRvaEE"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D89BPp3054903
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OtHpmGKrg2BE9xI0hOUoPVHguAoJPwSTIJj7uW32WVI=; b=StkXkT5j8AxukhgJ
	ZanTdktwyuynQxlViCCmjXKve+gKrMmF9AIoGabvbzHrsa1sA642EbKqIHtmt2Xm
	bGJDXA66qJtVk6WQ6f9H3H5cqtrrRF4CHaQ8alb2rJT/U7PPc5PX3v37HNO4RWu+
	GUgCto5YJu4QSqd0iJ/RFF73+RnLkmh1b/V7QfUhuJYB4o4n18KgpnlUKW2IeDaD
	8IMksU+KNMIQiotMUZR4E6QAqFvPUNGPg68l9F8CXBbZzmbJiDdCLaB+OaAwdyrI
	kgy8ffboTmUe1Xj9qpSQ5SvxNzoobBnRkWobVcGegF2M0yCp/vKQj5XafV3CchwC
	XKfiPw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h93aeunmv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:10 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93dd3c3badbso621697985a.2
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 02:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791885490; x=1792490290; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OtHpmGKrg2BE9xI0hOUoPVHguAoJPwSTIJj7uW32WVI=;
        b=ixQRvaEEjwGb4Lp34TCfMypATD77Re2OhycKASZpE0ia995s48bpzwfeFF7JP8nr62
         Ey8gcvXCW3+LaRlePqI19t5Sw3ZJjwyxKEUYgA+3jzDURoocOFNpMbDMOEK1o9geCD/L
         Nnpva4fCniTcCClYJz3b9qrKOiLKk09g1ljVca6/1Ffj7iqO4Cc3FeznEaX8lioZ0a0O
         8K4APrxE6THU5ZKVtjnvV/kLW+Pl/fLEKf393rFGuH6bKy5DObthHjz+zCxVHGx5JCKv
         aJltSC0uLfX7/cSG3J/Edw3ajLi1iHvBV0ZzjnNuVnHV4bCybjKtuV/Byh4rkYEMyNzG
         ZU/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791885490; x=1792490290;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OtHpmGKrg2BE9xI0hOUoPVHguAoJPwSTIJj7uW32WVI=;
        b=BG9ia781tzlJbsMGCbP/vnRl/EqSfCL/NpXjwn6fT0LHuCOOIO1Z1+1K/RqEfQdxbh
         2yZNWmlcyZjPsinL4neeVxiftKl0mvxfo+bE0I7qL2L5Qb6u4rdq0lLP9TjqPPPOdtTu
         opgSS6nFxaMYVdmhZx1v87Wy4Jx0Frv3FvBaHK7lAXZhYy4ZAXyvuBx6jVPGZ++iy76q
         2ZlGLUQgyzypqJ1JP79o7Kyn6FT3fdVztPMb2PUTmAGm8AlYPKrgLV0U61OmgZOSNdOP
         55hw26uyi+/6oy77uCdvj4UQ5k6HTVEiIhFlWi46gTYtAZiGL+ucM5ji4IMVtyxRxjoi
         extg==
X-Gm-Message-State: AFq9FYLZnufVDrvfYeoRg21OQJGwPmLbPc5gyFOn22lpDtjl3IstZCwX
	UEPSjiFrH14DQuXwh/Gysm4yI5t/TNrICVeh6y8ZK5DkseJeg97m2stIk9Dpw75VR3+f63YfLWl
	Ac5VnZAhrs1KXyfQcvH1hp2Phz5eY6qKXHi/Q4LfHom8utVrvQMxW/cKB2wXsOtHGPGg=
X-Gm-Gg: AYBFou1jV3mbg0K76YRjMi/MUwdfcyR1fh+giACm7ktBW6+3QSW4NhaKUXNQxs8Rpfa
	CWre738Bymm33jf6Q7UQuKcR6XCB7WOsRo9D9zHHSYTd42M9kZcgW1nU8qMPkG78S/i/SQWRVNV
	5XkOY42GeNtXzO67Tis2uzZZmPjF1pQDtfWm+DodDDuM/wziUhCmfPv5MPRpjeefYT/JGnNzkqj
	WcxDFxY1LiVVUKjbbzMHqhhWPd4zdmDKa5dMR55mpWhhwOQhcRdCaCMZ+m2i16uMj2VBDPG1xZb
	f2hkUnYP+IHgUXt0ZmSedaX3TgJTn+twm0X4J+EjTcueWHtoTfRuVPx1ZPyhRrN/OJBF/ZXzfqi
	/I3dGnjQXk9y4NjDQD03XKJz2gapm
X-Received: by 2002:a05:620a:3956:b0:93e:9792:fd47 with SMTP id af79cd13be357-93ebd0c2423mr1851233985a.4.1791885489994;
        Tue, 13 Oct 2026 02:58:09 -0700 (PDT)
X-Received: by 2002:a05:620a:3956:b0:93e:9792:fd47 with SMTP id af79cd13be357-93ebd0c2423mr1851229185a.4.1791885489454;
        Tue, 13 Oct 2026 02:58:09 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bb6beaesm209412025e9.0.2026.10.13.02.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 02:58:08 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 13 Oct 2026 11:57:32 +0200
Subject: [PATCH v10 03/14] crypto: qce - Fix CTR-AES for partial block
 requests
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-qce-fix-self-tests-v10-3-57162a38a554@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2934;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=AHcm2z2kVXAcha0bgo99T4rtQad4LJa2JNe/bUUBrP8=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqzgCcEQMHEtCWQDQPma4fD58ybalytD9wKQ4PX
 FjKqsxoioGJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCas4AnAAKCRAFnS7L/zaE
 w4ifD/4iXDDtlX4vBwZCFJjsF7kwY6R/A8EHMcnTpM0VwM6TkByDByL3lofHJVStc+/Pf0ofp77
 iskEBqCyG5Mlk5t6Nrxuui6Sw/70hVBd4suzGcnf476FxPSgfFUXypk7iU2FxxI2JjlLRSfg1vy
 TF5XdeIimSr/ANs6pNWD8PwujzwWm8Fcl2NuHPRWvB1MxKj+A/4c92w50qLSWryau+Uk26Mj8Kp
 NYP3hZyFem7e26ij76CVi/DypgiS6RFi3aMNhqKK2CSjmPsCmr31f3KCj6lu7jOAjowfT/T96ah
 iHrtIwOcJkkDzOq21LE72F6HtrA78B1j4HSxt2+TRJ/Z67H04wPCidbcLhhmyEfXD0QoGmhY91k
 WD4E1YI5qNiiHbSYJwaVw5LK8ZOVEQp2Yun5c2kLGAUYzEF4euEqbBCMaFoiKShzX3XgdUYkcvL
 msc77H18pnhb+0pb32BoDd68hObVGjxF2R4o+BIvwMJRyzc4GnOMZYWfcazIP+9FseB5MDUPtBw
 CTE5kKDNV64CCPOwYtv2/AmxWdS31c9dQTmrq3vJyt1ZR/ZpA05ftrVquAjAvt/xou+oDVFrGLH
 Faaw6V1tVuu/CfiGAv5Nsv/NK/l+LmGpBRzlgjOyQE5Zw6dbOuHcJWH8khKY5sPIDZ9wi2ynTmN
 9l0RNtyifdeXMeA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: QjCTDQibTImKNM-Q3H17NVhhZO42tP7f
X-Authority-Analysis: v=2.4 cv=JJuuIMKb c=1 sm=1 tr=0 ts=6ace00b2 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=Ida2_KdOZ2FwM6MSgQEA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfX9ZVdyMCUunQD
 b+LXcWmkMjTKiS3Ekq4utDfzoTMMzPzELSyZSMK/p1zAYPQJhyDUhCBLwtATxLc34vcxhRT8rUm
 GWVWkGtn8Hyaf8WExRruf1hwbmMYvHk=
X-Proofpoint-ORIG-GUID: QjCTDQibTImKNM-Q3H17NVhhZO42tP7f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfX9Vr0DkajDuP6
 FHbnIxW3Q/YE62TXnEAx5oDove6m8kom0r1Ybuy27Y9SW/4TEmXm19bEF/Vy+pWM37a02Q+gXlp
 +W1S+5b6CtSp4CJQtb0Bj7W7pGpHjLzXqe6WVlyx4omjqj+JzbEgxvNcXD6nCLdpFLEUw/VVb17
 dtkyABHcdxCeYJeAZ0hKJcsLei6utWLrBJnT2amDvFa4tWogv3ZWqG3DrqB+W9uOkTBqzSeGWl3
 Da7RIMWyKyyu44653riwyo0ys2n4R0myVPmyxRz9w/50ltvRh761Ihuv8LXtJ+TJHINlHUpaEDh
 A0TmgbIGsMYPIFQk4bvP7MNM+H13F/MgkAryBLIsoowoF2wK4JcYg+4KGFvzge4XgX60QQG4+ha
 GN7bkjIQ54RxU8WG5Bs09XOdK/ZY3Dz+8i2p0UOx7CTlUH66OXWgUKVG7iWu7h8iTAb4/6hRrQZ
 aLGS+jn2YnMO4tOMw1A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 impostorscore=0 adultscore=0 phishscore=0 priorityscore=1501 spamscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610130039

From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

In CTR mode, the IV acts as the initial counter block.
APer NIST SP 800-38A, after a CTR mode operation the next unused counter
value is:

IV_next = IV_in + ceil(cryptlen / AES_BLOCK_SIZE)

The skcipher requires req->iv to hold this updated counter on
completion, ensuring chained requests produce correct results.

Referring to Crypto6.0 documentation, Section 2.2.5 says:
"The count value increments automatically once per block of data (in
AES, a block is 16 bytes) based on the value in the
CRYPTO_ENCR_CNTR_MASK registers."

QCE increments internal counter register once per full 16-byte block(for
ctr-aes) is processed. In case of partial request length, the hardware
uses the current counter to generate keystreams but does not increment
the counter register afterwards. So the counter value written in
CRYPTO_ENCR_CNTRn_IVn later once read by software is one less than the
expected value.

Crypto selftest framework capture this scenario with test vector
4 comprising of a 499-byte payload (31 full blocks + 3 partial bytes).
Error:
[    5.606169] alg: skcipher: ctr-aes-qce encryption test failed (wrong output IV) on test vector 4, cfg="in-place (one sglist)"
[    5.606176] 00000000: e7 82 1d b8 53 11 ac 47 e2 7d 18 d6 71 0c a7 61
[    5.606192] alg: self-tests for ctr(aes) using ctr-aes-qce failed (rc=-22)
Expected iv_out: 0x62 (iv_in + 32)
Obtained iv_out: 0x61 (iv_in + 31, partial block not counted)

To fix this, just increase the counter value for partial block requests
by 1 and for the full block size requests, don't take any action as
expected value is already returned by the hardware.

Cc: stable@vger.kernel.org
Fixes: 3e806a12d10a ("crypto: qce - update the skcipher IV")
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Co-developed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index f177062eb735148561f798d0d3e65265f3235da8..86e3184812e061943822928a805d542004347ca4 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -57,6 +57,14 @@ static void qce_skcipher_done(void *data)
 		dev_dbg(qce->dev, "skcipher operation error (%x)\n", status);
 
 	memcpy(rctx->iv, result_buf->encr_cntr_iv, rctx->ivsize);
+
+	/*
+	 * QCE hardware does not count a partial final block, so the counter it
+	 * reports is one short of the value CTR mode expects for iv_out.
+	 */
+	if (IS_CTR(rctx->flags) && !IS_ALIGNED(rctx->cryptlen, AES_BLOCK_SIZE))
+		crypto_inc(rctx->iv, rctx->ivsize);
+
 	qce->async_req_done(tmpl->qce, error);
 }
 

-- 
2.47.3

