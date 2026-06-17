Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FBC4A1387
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 15:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781711407; cv=none; b=gh350GH3V/tMtA419B/4UcNFxlT7KmDGw6vGh96OilFRUTWGoxwG3Ghg2kmUbfEQiwb52M2qrOxp9dpEwaB6tgUcx1mQoYdeoO34bn2BJrEcqfaEobEwt2FfY5OsLNouDc07prBxqAzucAeUWgY0Lejo518L1L5yUlDUH4XLmIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781711407; c=relaxed/simple;
	bh=ZpXcRRX1P/Vbry8Wo72HFVJu88egSE1krlMUW4hDsmQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=rL1cTrbyrjs/EstwcZkq1h70Xqk0+dA9ina2OuhICmEGbyE3M66F8M3U3anuJ0KJSUWj5bySHo4KWwat8Az41veFZNzimFmypycmI2f4uNUl2JsvaabWbTizHVlXvhZqlsyCsJYINf10lAm0E2z6gDR8V9BJIq3HqHTcuClHcwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IOrlRasl; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UryMmDKp; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IOrlRasl";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UryMmDKp"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65HFQv9b3229984
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 15:49:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=XPWZkZ500XJwZn26o7+t4Z
	zKCCQCUoNphYUHhoj3vjo=; b=IOrlRaslGlbY1sb26aDp0aih0jQ5+ndws3+0Kr
	X2WmHDPXzRl4a8cmvKC3bMlb3a0tc8tilkGmt9AGP7WPOdqgGL0CbQBZt3RXhvo2
	vHElKX48aFXkYwMtBCvY4rstv2ZloNBQQbuiKGe3CLxa/jo4ucGQR9ZQTrJFEcpV
	5AftKbMTCtmGDWQuDxhnN5zvka5XtfozBhytcxHD6d3D5cRppC00DyZowsX0skOK
	q519RUzfT4Kq1xoX5mQGr8e2R+iD0JGFjD5H2X9FB4mNHMSFiNhb1txYB+WYRO9P
	/y8wooNFlUB53CawSp1nFE4KMUpgwFNhyBkxDU8KGvRpHWQA==
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eueevm2p3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 15:49:53 +0000 (GMT)
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-6cfe512e871so2871798137.2
        for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 08:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781711393; x=1782316193; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XPWZkZ500XJwZn26o7+t4ZzKCCQCUoNphYUHhoj3vjo=;
        b=UryMmDKp+jeV6AqovPpBRNx+uCDIpQXLGsnWoXY6vCFeTRTZ0P1brk3kymj9nwkdRy
         ElDd7hoKLr0Hm9PKt7pHQF0wBiWCYnLwf2IrkYIZxjg2mV9IkDZyl61FGYXpiZQ8EeIy
         4r2TWTJ4WJVi/mWVu1X2HI07HBlzfwL5gt72PbydFZgujv06WFmmYUy4IKpn2VuR21bY
         LfG3YYjpsysP65qQsgMF3wUGww8c7z1/MvcAvKo9r6q7DreqOlj8H6brFpfduMbdeBK4
         BIKo8oC8UABA6ICLb5ScREMl2ytt/pem9tx1nDQMS00EucZs7at+Dk4i8REY/Gr4fVHp
         qNuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781711393; x=1782316193;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XPWZkZ500XJwZn26o7+t4ZzKCCQCUoNphYUHhoj3vjo=;
        b=PqsLxo6QExRDOd6WXySsLVQn1caRwqkshL/q15wQkqtOLtcLwJNiytqKnDjGz9KcAD
         2sGtq3c47B+rx8PM3djM5v6fWnunoG0UF4HwGpreVkrNH8IYbPPDpj7N5DhhsiAxZxj1
         ESJGRtJP9WuDbuJ6ZR6hhJ8el1tiM83hTqyza+ai9X+fnn/J05f53x48gG2wPv9yd4sa
         Z73MwEA5VspvE9X2OrbLSGc61Fl0nYlQS4vIgXBoHbewyokq0Ihke6Ds0sK8S4oB8sQJ
         meMrN306Kqc+n6IMh+MREWQ+hCl9hukv0FY6pdr6QHDrV3TONblubyuq6q/15om2JN6l
         WlgA==
X-Gm-Message-State: AOJu0Yxfnt9KENCh+2XB8mTIq0pt8PilfdiGxZs9RGn5MZA1xwecidzn
	v4E6eRK484Mn2Bx3DPrDI7FRUcU4O4NXVkyRWnnwaQS9q29vLJ3x0WWvm2uokg2h5TTMhSc4btp
	0XPoFsTnOIJ2BXpefkftpMtmTjpLuS69w5s2QBhnuNGTRlhLXruSO054lFAdqocORD1E=
X-Gm-Gg: AfdE7cmnNvNntycFkIUJc0Llsqa/XUiGWO3YpvA9JvDf4umKuJvK5TLhGdo257NNEmU
	QkB+6FfeGfEuXtrSK7P1PsCS1fcp7zlg2b+0xCG95dJ2BfkZbvb8HTUB7nMIfAg/6fxlT+8sokZ
	fYo5n7DIe55ITepa61vN5IVQlIn4t/cL4tVk6HiXL4hQrviUWtxXL9x78CidvGCNNEMxZ/1BcN7
	R9gFPKklaMW3U7npKHsVw0NDYhdJoiaTvS0B+Zojmfm0ZoIQAfZs0FCoosHfoc+2iCN1LjjW6LC
	g4r9JOthCRFv1dHX4qqbXZpLnqmhfDK+sWF+JXbLZ0N2TfVoV21/1Od3pMEEwg3MinqKv/xogBp
	sqrz4khKF2pK3JBAX16HYMmkTGvZpjG8TMBVHnATm
X-Received: by 2002:a05:6102:15ab:b0:720:81d5:92dd with SMTP id ada2fe7eead31-7246cefffa3mr2759168137.22.1781711392997;
        Wed, 17 Jun 2026 08:49:52 -0700 (PDT)
X-Received: by 2002:a05:6102:15ab:b0:720:81d5:92dd with SMTP id ada2fe7eead31-7246cefffa3mr2759121137.22.1781711392491;
        Wed, 17 Jun 2026 08:49:52 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:c856:25e5:e249:5e0f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa8b423sm168913195e9.11.2026.06.17.08.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 08:49:51 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH v3 0/8] crypto: qce - Fix crypto self-test failures
Date: Wed, 17 Jun 2026 17:49:29 +0200
Message-Id: <20260617-qce-fix-self-tests-v3-0-ecc2b4dedcfd@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAnCMmoC/22NQQqDMBBFryKz7kgyVcGueo/iIiSTGlBTM1Zax
 Ls3FbrrZuB9/n+zgXAKLHApNki8BglxynA+FWB7M90Zg8sMpKhRjVY4W0YfXig8eFxYFsGqJe8
 dsW/rGvLwkTg3Dumty9wHWWJ6Hz9W+qY/Xf1PtxIqdLbV2mtjXEXXKFLOTzPYOI5lPtDt+/4Bp
 zGra7sAAAA=
X-Change-ID: 20260610-qce-fix-self-tests-492ffd2ef955
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2484;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=ZpXcRRX1P/Vbry8Wo72HFVJu88egSE1krlMUW4hDsmQ=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqMsIRrHso5RRinGMfK9331qoboVev1dMveaEtg
 Cmc9jx60wCJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCajLCEQAKCRAFnS7L/zaE
 wy1bD/sFRJTbi4HsHDpTGfTW1y71rTRLPEYEZf+tQr7zD9+h64p0WBNdHUAzq0iGER+zzc1bs6S
 KrTFgZxRFjuIa+sPd20H8JtcvJemtIX/RdnbhoIXxWIo7FopFpLWn3s6i/qe8ikMIOAQlf8K2ok
 NVNJluibGHrbETsjqTwBGtyqWcnf6gfJODLMBYUIfZQeNK3PiIy/C9cAXKV6J6JLqSnADgmVfr4
 u5Xg9WhIQ2E4CNNoUtSXYind0oqeMksahb7tYWPQtd1przzYbVGn8uWkgRDa/bfZsvt+MnJ9cHs
 Z1QVwS9e+OTCCxnzMuhEzmcjW633ksNqqAwNjHtHmRlXGsww/mgX7RaLiOC5Pi4YNV9c+bft0d6
 PUs0Eb8HXC/wqRV5S9FdwdRK76yven+Ma26Q1+pqJnA7zMh06rCEkCJBzKv/J4QL0Cyxwy25Ecw
 wIOTnvBJm+St12E6mppmG/DomDBQ1gQt7XXtOze6snkGNeEoDNXeZv9ZWhsGPNJM2KrlvknHAhJ
 rUrQCcCXM/Zl6IhONHKzpSgLDAgTKuy64zUYXT6wnz4ggIewnetyJBDbnapCiC4qcXmGSUjYOgr
 VAlwZ4B7oShanO/RLT9k0exVBw/I+6XlrdQZ0jrXOt+LwEUOyv22puIsYoY2UCPQG7UzFo0C6fx
 +YW55afoZ5DKpnw==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDE1MCBTYWx0ZWRfXzpDe2t2NxkCS
 b/Sd2QpJYan0OaD9bNXh4oLcS8RTmZLkFhmpupMxaD+GtezhZ4+uZsbb+r4yYM8ZOgBaYPCLKsA
 466eq/IC7pHNmYWQE2VpxfnmDGiIXBSk+OcybD4gSpBETsB7dG0tF/Ky4mzPLZw2ZSfQbPc/ttT
 w4SgwuHjxOyV+DkKf9Ye7LGTblnDENBv6YS5rwU6bTdi1o8HTVNdN9/3v0Ht7TfvkOYwM4Z3j+c
 W/aDRBy1VfCH1nJ0DEO/9+dkfVKzQ1Kw/g05egbIN10GXqLJt8Qh0l+ZME1dt7gUFD846hL+hT7
 dgaT25ToNyam1IMGWoepugNv30AR/bavh9oQGj0pDiKHuDsbTdl7uemaBcHPRYA4AdtjS/7mEgm
 DtQat/8zuFbB4MsyQUarCMNiLBu9Wenau3A6Vg0xQKOgM+lS71hEz+TzuifJMWt6keTkh4qiTxM
 Qbp4++HdE/WTHtfLcuQ==
X-Authority-Analysis: v=2.4 cv=LM1WhpW9 c=1 sm=1 tr=0 ts=6a32c221 cx=c_pps
 a=5HAIKLe1ejAbszaTRHs9Ug==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=bC-a23v3AAAA:8
 a=EUspDBNiAAAA:8 a=5rERACauPDyaBIpbJ_EA:9 a=QEXdDO2ut3YA:10
 a=gYDTvv6II1OnSo0itH1n:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-GUID: AEYElVC2QpsY2u74rqIzUIAelFDqizqd
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDE1MCBTYWx0ZWRfX5eU2FzMJ0y8y
 fgVRPJ8Oclq8ajObrdQkJtmtk58L91Y0+QC34P/iPUyp1nODBrlSD2rjmGc7ZG99wt6G+gW7Duy
 ymnJekIeQqEp946q9MOJyUWC+Ihg6nQ=
X-Proofpoint-ORIG-GUID: AEYElVC2QpsY2u74rqIzUIAelFDqizqd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-17_02,2026-06-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 malwarescore=0 priorityscore=1501 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606170150

This extends the initial submission from Kuldeep.

The QCE hardware crypto engine has several limitations that cause it to
produce incorrect results or stall on certain inputs. This series fixes
several bugs and adds workaround allowing the deiver to pass crypto
self-tests.

The failures addressed are:

- HMAC self-test failures for empty messages
- AES-XTS returning success on zero-length input (should be -EINVAL)
- AES-CTR: partial final block causes the engine to stall, output IV
  derivation was incorrect
- AES-XTS with key1 == key2 is not supported by the CE
- AES-CCM: partial final block and fragmented payload both stall the
  engine

All fixes were tested on an SM8650 QRD board with
CONFIG_CRYPTO_SELFTESTS=y and CONFIG_CRYPTO_SELFTESTS_FULL=y.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
Changes in v3:
- Remove even more algorithms and dead code in patch 1/8
- Link to v2: https://patch.msgid.link/20260615-qce-fix-self-tests-v2-0-dc911f1aad42@oss.qualcomm.com

Changes in v2:
- Add fixes for the full suite of crypto self-tests
- Add Fixes and Cc tags
- Link to v1: https://patch.msgid.link/20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com/

---
Bartosz Golaszewski (6):
      crypto: qce - Remove unsafe/deprecated algorithms
      crypto: qce - Fix HMAC self-test failures for empty messages
      crypto: qce - Reject empty messages for AES-XTS
      crypto: qce - Use a fallback for AES-CTR with a partial final block
      crypto: qce - Use a fallback for CCM with a partial final block
      crypto: qce - Use fallback for CCM with a fragmented payload

Kuldeep Singh (2):
      crypto: qce - Fix CTR-AES for partial block requests
      crypto: qce - Fix xts-aes-qce for weak keys

 drivers/crypto/qce/aead.c     |  88 ++++++++++----------------
 drivers/crypto/qce/cipher.h   |   1 +
 drivers/crypto/qce/common.c   |  40 +++---------
 drivers/crypto/qce/common.h   |  13 +---
 drivers/crypto/qce/regs-v5.h  |   4 --
 drivers/crypto/qce/sha.c      | 114 +++++++++++++++++++++++++---------
 drivers/crypto/qce/sha.h      |   2 +-
 drivers/crypto/qce/skcipher.c | 141 ++++++++++++------------------------------
 8 files changed, 166 insertions(+), 237 deletions(-)
---
base-commit: 7f5e2941e7dccc9dfaaa23d0548a40039772a284
change-id: 20260610-qce-fix-self-tests-492ffd2ef955

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

