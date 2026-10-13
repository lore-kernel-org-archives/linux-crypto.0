Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22975470EA0
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885487; cv=none; b=QXSBbg8nDQ9FxT03t1sfgudrjCeWMnsciS9wMJQ4z8P8u0Z6vs48OxkkVWrP3T+ITUfel5+X9f2PNPUIj/vuTeM3kEhf4ICsY7fJeY13DCwNWbO+49vym5xKIEDDkkPVoYub+vDiK/aQiSwnJudqvP7C69X9Rf+YBZ59Qr5foXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885487; c=relaxed/simple;
	bh=IL2qbLcxGDHaqL9aKu1kcosr0OoM2VP9z6rqwMPRebQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=N+jlZ/V18YILdUmAI9Mj5hRKuymHFBrGLRnYRvtRieG7WGSv004XoIyJU5MZZ/zOBRIeU8Pu9pdOPsYz51R8O7inlacftCTv1JHghePQcsMvHKZAt/8VIJ0tqZ6LSC/8hkVxfKTkz99ICrBFe1DjbPLN8h4uw2lqTwgyS2Z7uoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=K4v2gXcI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hKKydrVs; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="K4v2gXcI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hKKydrVs"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D8V0ui922844
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Wpb76IjtBzrvbAJYohyO9P783yAFFumf2DZOnyI3vOA=; b=K4v2gXcI0D55Z8nc
	QbE6s6W2QEVM4q6CW3fvgp6PyTYPF9MS33TNuk7BfPOvmCr0GHXwQNMvjYKAkkxA
	ExDa1mKiiMTpCyrKw5a8asOvL8O++IhgzDQvyWrydBXlvHycu82dR0sCeYUR7HH6
	eFv+vMCCnCyMMPztAVOuhjMV68g4o7LJxTyEPiKie9C1z2Xv/Uks1RP4K5Nu9W99
	JzRadE7IYaj01f5FSXcYcgmg313YA8vMFbdeyngS1e1BdABK4LNPi8cv8nGrV64K
	bPGHgN6BCQXRbTDNaF+Nm1oDq7c3ihbLyR4aKgwdrNCGo5eCAAzXDnV8LRXe0d/c
	X3YdFw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h98h1tap0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:58:05 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93ea9ea9d13so463643985a.0
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 02:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791885484; x=1792490284; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wpb76IjtBzrvbAJYohyO9P783yAFFumf2DZOnyI3vOA=;
        b=hKKydrVs7WZMEkhv2ffR4p7SKz6IlzEMvFWTTaNDfv9VL5aFgHsvtX/8LQpMQ6U0I3
         2rANdTrwtXkKIMBGJpLJcuHhnq3fSEtnQVy6tv0u14zxsjFg54JR4wGaLbFhCn4w9TBg
         Gaw3Rm2On5DqQEzDjV+3QtVf+1Ke4pEp5epi/X4lKuA4hiyCSuvlLxbC1eeUI6yAub0D
         uRoACRkx/FTQYQYbHW55u/P3+tTz1lJ1SAWchrc5D08jivi1A/KQJvTPi4Wvw/pLJrug
         OWX586BV+K244mBCBBEXVcT5vuWMFX7cU/ZEgMA0BqPCRFhKSwH1zZ9ROjQwdMk0ma5p
         9E2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791885484; x=1792490284;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wpb76IjtBzrvbAJYohyO9P783yAFFumf2DZOnyI3vOA=;
        b=cfJFstvLvS7sYLMp18lAz7mmF1ThjwP3f8+VI76IVSiVT1Xg8XZoept+sSDyFpJ+lZ
         IZchm9r0jp+QJvgMXwUYIyCPrM0siYMzRKeoSoMDEFaOm/R73Et+LIPAwknTm/XkqX/f
         hCO/P07KDVR0wRBjHSytZVqqsCjVyKUlZJdR3dI9H3tP538iYuC1jwxd98K633/fJswH
         wEjFIZ8C5gsUKj3ifst4awIeNtkjKErElXEJ7O2B7g9OJLOUyos4/ElLfaiYE364zd74
         bG0ymMdhdz2bFIJVW+bw3aqK8Sy+9nYDQbGmBP258vlG2bOtaQL1GoSCiTw3gYkdxvm6
         3GiA==
X-Gm-Message-State: AFq9FYIclIU8QuYyKDBuvBNBCbxjRAHKiPYxRpkEwWF0qbMM0mQteKQa
	S4t/hz90DI/gPrFyMoclv4QkupTi5eWvKPICy9aP1TRk6aneF1QcLfvM9YDQ0RCau6c+nlHfp2n
	MZxSxy+p4mXUIusoQWioyxqP6gWOLxsYv5jSRT43ebSEWqqf+7/S7liJqD+VmOULGSeU=
X-Gm-Gg: AYBFou0Syz60DPg4juz/wZXGMt8EatHSEWI0Q+xdscpyhr/3gl3mjgfvrABh6jRNVF3
	UnqMG/7tqo8Gjej7mBZ+dNkVbG0QbQPPV8ly6KFiQSwPAA5gznifhQ1rWSqhrYnpfUxt0LYosOx
	kpfvm3g+RjSQr1U+uS8Tc3Y4Lc942NSVKxz5gJ0c7k7iVccrmAMLyQaVVqpU8xiXsRRLyeoRYv5
	zoHf8rSqr5ZaXVfd8PStmZrzVmTAVy8/hdNkFjBKZ+1IQOovxrcF9Xvcv+BnL2y8s3twN0ripmO
	tcWljixKW5AOP/h0rSLGCZxXt76K9TA3vQ3gXzWAPuVGRQrgMgjs46o/hIBSWtzmOSLSkfKbZZi
	Wh7Wyo/tVFuZI8P1wwbayeFzovnFg
X-Received: by 2002:a05:620a:a0d3:20b0:93e:c12c:9b74 with SMTP id af79cd13be357-93ec12c9f6amr1366685085a.79.1791885484346;
        Tue, 13 Oct 2026 02:58:04 -0700 (PDT)
X-Received: by 2002:a05:620a:a0d3:20b0:93e:c12c:9b74 with SMTP id af79cd13be357-93ec12c9f6amr1366681485a.79.1791885483845;
        Tue, 13 Oct 2026 02:58:03 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bb6beaesm209412025e9.0.2026.10.13.02.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 02:58:02 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Tue, 13 Oct 2026 11:57:30 +0200
Subject: [PATCH v10 01/14] crypto: qce - Fix HMAC self-test failures for
 empty messages
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-qce-fix-self-tests-v10-1-57162a38a554@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5504;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=IL2qbLcxGDHaqL9aKu1kcosr0OoM2VP9z6rqwMPRebQ=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqzgCaCRrqhKDSvOTzkyve/sVYAQR2SEZsIrrcL
 Yxe6Ze/fIqJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCas4AmgAKCRAFnS7L/zaE
 w5xvD/9R7FZN50ixptdJH+RbrIFkZc/qHLj+TzGsJiQEDJFXpksjmeAhiayN/zTil1Xkd0HXIKE
 gZNpp9/2p0dAL1LPIWQMJZhi31FrXHXFGYS2hqRv09bYYnY9fs3srncle5PIfAvpMxWnJ0dVOvX
 56Mqi6zVDhixSh7X8/ZEzTHTHMiR6uZ+L4RdJLUKItAgxh2q92nwI4S29+NnzpWcV3wLqHuN5D1
 4cEw/mMwgpL26yy9qFR8rqob6op/1mTQrE7dPwCj29Z8Jo+RuytVSX3bCVHEegOyD75ZFrTxM6Y
 yt9fjgT8/qhwGzXI8jPqSy4J61PZFyzxXfFWfeQtEZhHKPwTr3kBN4CVGETcZQjHEu/4PPB7hxQ
 nfDwFKmYOkaA5dXtGhyPUYp0YWSJX6SZfIS7QBGtYQ+Q87gsyEVA0I6BS6ZUB2L7yjXd7YqPgKO
 RVvK/r+7lMr0Zfi1N4ToUXUUgbISklkj/3VXRzVLRKig9g45sTs/OFibX3kgvGSdRIYgKqywY5j
 2Y8mWqJW14flTbA1XaMY4YH7VyfRlBoiRWN6w1WtisaLdy3rH8NpzMFWk0QnVzei9rMRKvSrZ8j
 uqnJguQiFzYC5zmpEL3VXpFLyl7B8EgAAqwkOCTRn8B/i7sNQTtEgfOKCiW5W2Xp4yoh6RKZJ5I
 VqweSXqa1vhI8Ug==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Authority-Analysis: v=2.4 cv=VqC2kO2n c=1 sm=1 tr=0 ts=6ace00ad cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=STDFJHEvCfpFcWkAIqQA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: p77OoUV30jZF0542vYuoZrt7Zf1ncOHw
X-Proofpoint-ORIG-GUID: p77OoUV30jZF0542vYuoZrt7Zf1ncOHw
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfX948M8ZizlWvt
 jAfQItXjyLnrX7WLEVtTc59p6QbcJ5WxdsAfIhf7quUo2HldJv2sFqyMJjnscdZAnTgYugHntWo
 99DQo/oTLSRmvlUA+PUyjV+fyTowTaM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfX0pmrNiPT2Ps6
 IR5oiz9Pwq2JDZbRWZRevaGQuF/K9Y76POdTAjTlywIPZMGBLuUbzMaXDXQIFl6VWfy7/F0/nBy
 PzkZta/zKfzquNH1dyShNGKMTPMnEL6wCyo0RN29kJzE68j5x0kpK1P8PGZ7sQPhxOJb8EV6HIP
 6w/ePN1kG3KBi/x4WWATzfz+kpqqRFOk9y9kNeLGsurg0CCfugY7BOIOPaedYpGEGleDzyPY3eM
 WqGIIMBdX1UmjIs3c/5E9Ln7DUs2V+M9x0VykjUM9ixfridbYsIQF+LfGi0JnY3ATmV5CcnWbp5
 r5BsBon1NiQph9xpVCVByuctEJbMKfnKQzfjg1Jw397U/PjbV9PO4T2hXZzIFXEtvN/tZlK53HL
 7i2pkzjlEnAFBdXDhLGi8kY+fUJ106GFG60G2eoosf6pUheyskj6LSEz/xLWfTzZaS4rC1murAv
 dsc68pe/WOa6SuYpb+w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 phishscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610130039

BAM DMA cannot process zero-length transfers, so the driver always holds
back at least one byte to submit to the engine and only ever finalizes
with an empty buffer when nothing is left to submit. For plain hashes
this was handled by returning the precomputed hash of the empty message
(tmpl->hash_zero), but HMAC's result depends on the key and cannot be
constant, so hmac(sha256) produced an incorrect digest for an empty
message and the crypto self-tests failed.

A zero pending buffer at finalization time does not necessarily mean the
message itself is empty, though: the caller can also reach it by
importing a state that already reflects some hashed data with nothing
currently buffered (crypto_ahash_import() followed directly by
finalization). Special-casing only a genuinely empty message would
silently compute the wrong result for an imported state in that
scenario.

Handle every zero-length finalization consistently through the software
fallback ahash instead. When nothing has been processed yet, let the
fallback compute the result from scratch using the key already propagated
to it via setkey(). Otherwise, reconstruct the fallback's running hash
state from the state kept by the driver and finalize from there,
accounting for the HMAC ipad block that the engine absorbs internally and
that never goes through update().

Cc: stable@vger.kernel.org
Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/common.h |  1 -
 drivers/crypto/qce/sha.c    | 62 ++++++++++++++++++++++++++++++++++-----------
 2 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/qce/common.h b/drivers/crypto/qce/common.h
index 9cd2e6ed8bbb0f76e24be187d8ae7e2fe2f7b932..587d349da91d1faa2bed7cd488306d4358467b2d 100644
--- a/drivers/crypto/qce/common.h
+++ b/drivers/crypto/qce/common.h
@@ -82,7 +82,6 @@ struct qce_alg_template {
 		struct aead_alg aead;
 	} alg;
 	struct qce_device *qce;
-	const u8 *hash_zero;
 	const u32 digest_size;
 };
 
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index b67d749db05f2b9823cd2f0953ef24f4f337df2c..738454dd35655a8376bc878444fcc3fbd7535956 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -7,6 +7,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/string.h>
+#include <linux/unaligned.h>
 #include <crypto/internal/hash.h>
 
 #include "common.h"
@@ -249,18 +250,56 @@ static int qce_ahash_update(struct ahash_request *req)
 	return qce->async_req_enqueue(tmpl->qce, &req->base);
 }
 
+/*
+ * BAM DMA cannot handle zero-length transfers, so the driver always holds
+ * back at least one byte to submit to the engine. A zero rctx->buflen at
+ * finalization time does not necessarily mean the message is empty: the
+ * caller may have imported a state that already reflects some hashed data
+ * with nothing currently buffered. Handle both cases through the software
+ * fallback: reconstruct the running state when there is one instead of
+ * assuming the message is empty.
+ */
+static int qce_ahash_finalize_zero(struct ahash_request *req)
+{
+	struct qce_sha_reqctx *rctx = ahash_request_ctx_dma(req);
+	HASH_FBREQ_ON_STACK(fbreq, req);
+	struct __sha256_ctx core;
+	struct scatterlist sg;
+	int ret, i;
+
+	sg_init_table(&sg, 1);
+	ahash_request_set_crypt(fbreq, &sg, req->result, 0);
+
+	if (rctx->first_blk) {
+		ret = crypto_ahash_init(fbreq) ?: crypto_ahash_finup(fbreq);
+	} else {
+		core = (struct __sha256_ctx){
+			.bytecount = rctx->count,
+		};
+
+		/* rctx->digest is the raw big-endian dump of the engine's regs */
+		for (i = 0; i < SHA256_STATE_WORDS; i++)
+			core.state.h[i] = get_unaligned_be32(rctx->digest +
+							     i * sizeof(u32));
+		if (IS_SHA_HMAC(rctx->flags))
+			core.bytecount += SHA256_BLOCK_SIZE;
+
+		ret = crypto_ahash_import_core(fbreq, &core) ?:
+		      crypto_ahash_finup(fbreq);
+	}
+
+	HASH_REQUEST_ZERO(fbreq);
+	return ret;
+}
+
 static int qce_ahash_final(struct ahash_request *req)
 {
 	struct qce_sha_reqctx *rctx = ahash_request_ctx_dma(req);
 	struct qce_alg_template *tmpl = to_ahash_tmpl(req->base.tfm);
 	struct qce_device *qce = tmpl->qce;
 
-	if (!rctx->buflen) {
-		if (tmpl->hash_zero)
-			memcpy(req->result, tmpl->hash_zero,
-					tmpl->alg.ahash.halg.digestsize);
-		return 0;
-	}
+	if (!rctx->buflen)
+		return qce_ahash_finalize_zero(req);
 
 	rctx->last_blk = true;
 
@@ -292,12 +331,8 @@ static int qce_ahash_digest(struct ahash_request *req)
 	rctx->first_blk = true;
 	rctx->last_blk = true;
 
-	if (!rctx->nbytes_orig) {
-		if (tmpl->hash_zero)
-			memcpy(req->result, tmpl->hash_zero,
-					tmpl->alg.ahash.halg.digestsize);
-		return 0;
-	}
+	if (!rctx->nbytes_orig)
+		return qce_ahash_finalize_zero(req);
 
 	return qce->async_req_enqueue(tmpl->qce, &req->base);
 }
@@ -431,9 +466,6 @@ static int qce_ahash_register_one(const struct qce_ahash_def *def,
 	alg->halg.digestsize = def->digestsize;
 	alg->halg.statesize = def->statesize;
 
-	if (IS_SHA256(def->flags))
-		tmpl->hash_zero = sha256_zero_message_hash;
-
 	base = &alg->halg.base;
 	base->cra_blocksize = def->blocksize;
 	base->cra_priority = 175;

-- 
2.47.3

