Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9680834105B
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jun 2026 05:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781070852; cv=none; b=jQ3qmJPfKNvjqBcwpVVdQ0ztdlzL+VnR6U7cA1t38YXn1YFCsFtI5nEzQUlg6Er81Lwn0UsH1zHJMYA8VbVDMJwABudeS9PnDOTU4Ld8oKrQ13i4IoZirjXHVR9UaR/neBmYMytVwXZabXDnf46NobIkmXkrerznj7cDKWz2FP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781070852; c=relaxed/simple;
	bh=N7tD3f9Ln/OjK9UFbjnvbfgV8hf5Ynv3naFrUZ3/PEM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=KhO4xlBt5C9iKb1n6uORbPt1+hQaniM+CG4eUBNxA1b/o/9eSCfntvHv2tQcac3j9XZiAO9X4+Ri/6ud0HfUwkej8Igjez7Dm6zfx5944WyrCichPbj/xgznHoZG+XMxuoroEpbRiICCDpsKXaTj412tbnt9+lLPqE2leu/tmUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=T68vd5Sp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=V5mAlq5B; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="T68vd5Sp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="V5mAlq5B"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65A2epRG3999892
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jun 2026 05:54:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=DzbkyHrykCfB9lfvTmUvUV
	YIFdKphCwy1C3gk2YCmoc=; b=T68vd5SpD2v85QNvq9CvykOnt2U9uE1wwOYlVD
	Zl/EPJB7I1vhB554GwWCg2/uAYXE4obW0DUrwBgfQ6RRyNWPWIkRp+L2xyTwpg7M
	ujWICPGnsuQgkHecOZ6MxYH3wd2Inrmqzc9IYGhPGrHZIhJyN74DDcThHuWW/I36
	dU7EXC5QFRJ91o29Vf+QqAbHazeAMy06uCX1hjz95QNKUvZCQ34YohWYhC9OJhPF
	vG4KDltxpacyDejRg+o7OIzbJFVpwKoqQxVSbw0C886uMjZpJP/jfgJ+rd9KzX9G
	q0j0xUFH1TZiQIgCBso1fwEmiRK5RIfcE4hdk2lkJblVKnog==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4epxuvgp1g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jun 2026 05:54:11 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-842278a630dso7981456b3a.2
        for <linux-crypto@vger.kernel.org>; Tue, 09 Jun 2026 22:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781070850; x=1781675650; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DzbkyHrykCfB9lfvTmUvUVYIFdKphCwy1C3gk2YCmoc=;
        b=V5mAlq5BQnesv0mKOnIYp2/RXJYGLk+ouwWhO1lPBXyx7lvxZm02NpwmDnXJ8abXle
         DJlrVOy3MfEkC5PxOJ72LBeSHxxHXJFJSYDL9w4BbHdK0sJVh4YE2UvkmSbahu68/sNd
         I7XMAvtE3VWSlEPqWNhmbAavCI8+6xtUNS1Cj0NwbmH2BxNFh57w/it0HDv8cBtXp95R
         DPtbNwSAFtp69VT/R3Zc9KcmSAYAwbbtuQ9R8c7VDSzpgE6vlvA50WrxyZWe8NbQWhGp
         iNQidBwuQRhDNrUBd4vXJ2XIN1NSC1RlT5yNUVFmoWz9wzvoOGSgvZY0YttjTbKxdD2q
         3aLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781070850; x=1781675650;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DzbkyHrykCfB9lfvTmUvUVYIFdKphCwy1C3gk2YCmoc=;
        b=EQWGuUmVyzM0pM5uzLXuY56zo5zy7Fm1Kw+y7WpZFaFXbcP7QQVOetBM9uc+62jKgJ
         SLUJfywEItIwXyYQB3ffbpziynYabCu6hP95urg7dIoDEPJZX6/RGT9WKum6CVLh/vmm
         yjaLWq9UyQnTF7CVIyM5BRvSIvMma/ffxNOWEPHDRsL+mKvpF8w9yfEDJawIpOpQmN25
         i3mOvnSDv/kWJ5NFQA7gP9JAvDej7fgIxI3+AnL8Bz46uA7EzzRIzKxkhsNgr+tXMDCe
         vshZC7un++LY3OMFskfeAAS/XxT1ufoedCZcHVxsk5JwUorqzXeDVa27QmSt/izMl+c1
         FynA==
X-Forwarded-Encrypted: i=1; AFNElJ/7LpOurrLp1seM820LKpbk0xnVJT2aaviNtc/kLLbOHBmFQeVzMolvLeUVnnchQa/Gy0tTruskRGxwmvc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+mvkO+5EARAl2biEQ/qAaDVo1K7NN6wdd5ReJ8Fj60x/OzXWO
	OgUyhbW4QpFdpiwFhyXST3iSMrXnxx/kZaK7P0ItrqpgPfKunuEEMZWXyQqVcXW6ErSrTLJz4hS
	7d9EzIrqPGBWBNsSnyKmF517jCop/TIjkIWsWt7LqLJw1sP/FJykpbSchCefIcwMgx5M=
X-Gm-Gg: Acq92OEWrbCrTe2sKIxakPH7tW0uu8rt2k3oscgVsqh0SFCwaeFnfRlXqBmyYTFiP3d
	TQghaLSkbz+9/MkR86F+xRLMlRPuRhTXN/GKOsFblCKQXZ/g58wsEmuqv7bBfrHaELezN2Vhxvq
	oJPZkCIkoO3hJkGA1QyGVfUzngZ82AzkIdY20QBb9p4MN/3Nkbn4gt7XwloQa8d0jf5FBo7Thu8
	N76MwrandxM37Fz3Njoq04kS3kBlrhzjHi9sV7E6mknrhFq9TO39ijmaDERSpidXTicrEO4foRV
	PwdiQget/ZHssKDJ8Ex4HifoTbgLTOWEd7vV9hVKsk5F0de2CE4LBsaDmavgmV5iMWAsUHG5Y18
	pvu/Z1XrR5Yyq3G5NBrPLSe4t5TZLeupAQynqA+0YPUQBDR8wDxY+yXTEiE25SRNOOQ==
X-Received: by 2002:a05:6a00:21cf:b0:83a:3135:edbd with SMTP id d2e1a72fcca58-842b0e1e1f7mr24836323b3a.7.1781070850342;
        Tue, 09 Jun 2026 22:54:10 -0700 (PDT)
X-Received: by 2002:a05:6a00:21cf:b0:83a:3135:edbd with SMTP id d2e1a72fcca58-842b0e1e1f7mr24836298b3a.7.1781070849915;
        Tue, 09 Jun 2026 22:54:09 -0700 (PDT)
Received: from hu-kuldsing-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84282221086sm23687470b3a.10.2026.06.09.22.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 22:54:09 -0700 (PDT)
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Subject: [PATCH 0/2] Fix Qualcomm Crypto engine self tests failures
Date: Wed, 10 Jun 2026 11:24:03 +0530
Message-Id: <20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPv7KGoC/yXMUQqDMBCE4avIPjeQBLuUXkVENI7tlqI2mxZBv
 LupPn4D86+kiAKle7FSxE9UpjHDXQoKz3Z8wEifTd56tuys+QQ0iveQoKkZZDEetmN25Y2vjvJ
 tjsjzkazq0/rtXgjp36Ft2wECvMZrdAAAAA==
X-Change-ID: 20260610-qce_selftest_fix-2e0b66148651
To: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Cc: Thara Gopinath <thara.gopinath@linaro.org>, linux-crypto@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
X-Mailer: b4 0.15.1
X-Proofpoint-GUID: 0hUEdJJTxl-RBKkHeMq9uzYL8FQ_IuVZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEwMDA1MiBTYWx0ZWRfXzWmIHwGpODbb
 oAAT35Jtf1rxsY5Dho+IB9kAPwcJCEdliydpKL0qBBDjtyxI6eF8Nps8LfuuhJohkGl5Lo4humv
 3fGtpdBYDEJLqdvAOBM7RfSi6Pz/BHxBwV5uBrzSKvE2vo57u8/jgbXl7pq1os4+vIr4wIfDV3w
 dHA01u3d5kuN8oAuFcWgyeGZSebHFIKOHwFrnfKKb40eULGKQ0Xoj6uAVe80DrcTtalwucGVadB
 VJkT+m1ZfvUtAxkk/cFQlsDDVKEAoSvs1giTCEYex6AqS5xuIYi00tJZ7yBWII/GbGPWGGDeRtb
 oXZXNzHKDeMGQ6LrdXRoNto8Zn9YFp/AuOsUbdyCNUAY0SsHRKnY1V91ytKp4ca2B1IT570mSmG
 U9jFMgPaIv7mIjtKKZ4dgjqrKqxudglnNfWtRzOoEUCrj+pfwhSCwg0sX+fiU7SYdjZnmqr9LUn
 2OGmvn3Pq5E0dXYbBDg==
X-Authority-Analysis: v=2.4 cv=Co+PtH4D c=1 sm=1 tr=0 ts=6a28fc03 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=SQGNcDTCvMNP9r5F9YYA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-ORIG-GUID: 0hUEdJJTxl-RBKkHeMq9uzYL8FQ_IuVZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-10_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 spamscore=0 clxscore=1015 impostorscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606100052

QCE currents fails with crypto_sefltests for below 2 ciphers.
xts-aes qce and ctr-aes-qce.

Failure log snippet:
[    5.599170] alg: skcipher: xts-aes-qce setkey failed on test vector 0; expected_error=0, actual_error=-126, flags=0x1
[    5.599184] alg: self-tests for xts(aes) using xts-aes-qce failed (rc=-126)
[    5.599187] ------------[ cut here ]------------
[    5.599189] alg: self-tests for xts(aes) using xts-aes-qce failed (rc=-126)
[    5.599222] WARNING: crypto/testmgr.c:5804 at alg_test+0x2a0/0x3bc, CPU#3: cryptomgr_test/150

[    5.606169] alg: skcipher: ctr-aes-qce encryption test failed (wrong output IV) on test vector 4, cfg="in-place (one sglist)"
[    5.606176] 00000000: e7 82 1d b8 53 11 ac 47 e2 7d 18 d6 71 0c a7 61
[    5.606192] alg: self-tests for ctr(aes) using ctr-aes-qce failed (rc=-22)
[    5.606196] ------------[ cut here ]------------
[    5.606198] alg: self-tests for ctr(aes) using ctr-aes-qce failed (rc=-22)
[    5.606231] WARNING: crypto/testmgr.c:5804 at alg_test+0x2a0/0x3bc, CPU#3: cryptomgr_test/149

This patch series attempt to stabilize QCE and stabilize selftest
framework. The failures are common for all targets and is currently
validated on sm8750-mtp and qcs6490-rb3gen2 device.

Steps followed:
  - Enable EXPERT and CRYPTO_SEFLTESTS config.
  - Bootup validation and confirm selftests is triggered.

Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
---
Kuldeep Singh (2):
      crypto: qce: Fix xts-aes-qce for weak keys
      crypto: qce: Fix CTR-AES for partial block requests

 drivers/crypto/qce/cipher.h   |  1 +
 drivers/crypto/qce/skcipher.c | 29 ++++++++++++++++++++++-------
 2 files changed, 23 insertions(+), 7 deletions(-)
---
base-commit: 49e02880ec0a8c378e811bc9d85da188d7c6204c
change-id: 20260610-qce_selftest_fix-2e0b66148651

Best regards,
--  
Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

