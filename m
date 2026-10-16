Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC664D5968
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 14:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792159933; cv=none; b=ZWPgis4l1pambkIna/DPpeWOsDGzF738g4TyhBBijgS9b7UYLft9eCpb2ccdecxKPpQVdZ1fyzDsLjyzBjGOZfLhXGTzzX+pwz7b0pyGoOynautw6RZh3uNfQrWiPhZxnbCA42JYzM1UU6b6RZrzbTDS64l4kUm8bPvaYeq+LLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792159933; c=relaxed/simple;
	bh=JWi2HBXLZRGrO4ZF1gHCxdS0TYJdIfe5PnYNHkjGs98=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=b0gwZxU6JRBk+yDAlpq8jmq6o6b0CxfAMw2GIFRC/8jKRJztLdI6I+xzqRZvLF6xzhwcMLKdhb2cWi0hgPH+Y3C3KoHgEk8+cTboVohuQAE+90SWJeZ+mw0YDvt4d2oEKAMKA+DIt4NKBZQZGa2lh4dcCRCfQWFIsV6IAhJUOls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Z+YM0IRm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gs3ycTId; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Z+YM0IRm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gs3ycTId"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GE5o2q2153844
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 14:12:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bBbr7ssj/wLJkArntv71Rteg79GZ38p9OiLBwvbkkuU=; b=Z+YM0IRmB3BQ8VrF
	RvVwwLSR3lUixa+/iW5HTESeHBEeGNLout1F5orGNxisaBvF5bXtrNw4VVzXg3Jv
	uYmtw9erA5ums0BCtxRs9tjJeByjVJ4cBYrCW5cwmghQ4BxpsKN8aMrKqTanvIaH
	/BMnxNwU8+EhcLsjDDtaEzFcsZwcdMkC/yrHnXyPHOhPqG0BihF3ygGXC8ylxD5O
	23BFssGbJok233xvxFHGd58JvrC8ATXKRIVgDR0LnMesx5FJSnIHJd0M/0o09o/N
	sDOYXE/MmLlSOlJamVzXSYx+RvNQJpI6AI3iXv6JoEUeSZcqlU1DisSpYxDc/q9Q
	alCcZA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hbhumrucn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 14:12:04 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93cb6391e89so1370592385a.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 07:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792159924; x=1792764724; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bBbr7ssj/wLJkArntv71Rteg79GZ38p9OiLBwvbkkuU=;
        b=gs3ycTIdYiX0WL6qH8+FywgUDQZ9pKNCu/34iRXr2J4fzkI/LEeWPS1r7nNtTMrfMN
         tAPxii2sSM7wxvJPD+iB7pKIcphWrNNISerGNZ22rqVIO6FeFlDaZO4NZnMOEDoN7b71
         W97AzpgfcbveX6mddEAzu/iz8plItfwQWd0LHHv4sLMJmdsLiMbQactfQWjurCtbwxl0
         r/1h2SoW99XAnF4swQdjCTBIhw5ErGmIngm9NtXZ2XXktbhBsKgMVbjlEDEo1l9Y3ca+
         F2izyOqxis7ciPvXwdfCni1LGH6O7nFWZyyI+luQ6aMsqn2cBaJy6HTFTkTLOGIEktGp
         xfkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792159924; x=1792764724;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bBbr7ssj/wLJkArntv71Rteg79GZ38p9OiLBwvbkkuU=;
        b=GQCJxhkaHHRzDtk2WU8R7i4nfdoUGBeQbLLXJ6mHu0Wbowb2/RFpC9PJLMD8BAwz43
         ytXsg+SbjnB9groI0OwDcs94IEOySLLHrErVkCFoMWTEnyg1O1FSHYyCEw7D0YvmNo3L
         h682Uav2J4i3y93UrwoU/Nuul+E2GKUNSQtnAT0gfHiHmjtv+vGearBJ3+xHIJGVdos4
         J4qBWPKK6TTWxT76YIVIajUbZ3mMLHvLpmGL2G7u13Mc0ExIlSSTasl/KiCY78D6c75c
         JJTML+9CkN07WATy/hAfQV/XE3k/Bgpdi58zWS9dqD/eH0QPDgIwD+e3AcfljcHfNE6p
         ChRg==
X-Gm-Message-State: AFq9FYK/iKQzWd3qsa59us/2Ral57Vmcmt6CkhmAwVqkMZ71cVJIGxnM
	wrPh79I0PvQ1YFEy3jd2Vh4gWYwzUQtbGhgBUo3xS7qLTivieew6U1sXayBJx7HBtm5gSvcwuA1
	1xxEmIbAkE5c7QGrxWNr4tH+wdMPaPL8DOuFj/8sbj77JJ4AYD2HGQw8wmM2IfaMpJ/M=
X-Gm-Gg: AYBFou36NmuhXCXP8nwl7g947fuvADzsyrlmDVrUxl05jixaLbc6drw6kJu0J23UOYQ
	zhL9gslX7SRPZP5NlzP+cYmf86unLPKQT+r1VRRRToy9VT6Ob9UG8pjXBGSypmBDMbFEUmnDs3m
	cU61FHhpY0qk+tecVWksQWTjS2JmzQ8ftVMNJ0RVcPIB4TUUWuXO44j6GmD5huVYtR05c1SXM7L
	pebILxPGtoy8UFPsgb0sovql5DTiEhbLT/YXx4QZqO236g7QYBk/do7zzktsWkoQDQJRgv+r9ta
	G3eiBONZZD87doFJKenIZlqHr2nvcA6pF5cZSnwJxK2t76DnNtSpdJIM5mecA34woQHgtSc+/Lz
	0VLlGhMyLJlyjSd5z3Jdh4dx9NwAc
X-Received: by 2002:a05:620a:6f96:10b0:93e:c12c:4402 with SMTP id af79cd13be357-93ec12c49d1mr2498732785a.79.1792159924132;
        Fri, 16 Oct 2026 07:12:04 -0700 (PDT)
X-Received: by 2002:a05:620a:6f96:10b0:93e:c12c:4402 with SMTP id af79cd13be357-93ec12c49d1mr2498728985a.79.1792159923492;
        Fri, 16 Oct 2026 07:12:03 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:8916:7b9b:97a2:6c96])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4f8babsm5760145f8f.33.2026.10.16.07.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 07:12:02 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 16:11:49 +0200
Subject: [PATCH v11 4/4] crypto: qce - Fix xts-aes-qce for weak keys
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-qce-fixes-skcipher-v11-4-d13ddfe609a4@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3273;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=BFUsh7LeAlufJoYh3EtRWVcl5olVBKOBPpPzVaklges=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBq0jCoF+01bu1q7wZcQCvl1gq6+OYJK+Ati/OU4
 +YJtkyq9ruJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCatIwqAAKCRAFnS7L/zaE
 w/TSD/wNF1kW2J922gVDrQi6EvilYyRqbgPCZyj3GklnEKm8m7X07PjHJo193+FrMTL3PdcvsSi
 xAnBpkjhjK5O5cq3RnHg5E9JFnfD4tyRR+cHrJsg8gAx9m/9sOzQDm9rtqGdk5kKEB4zOi8KHYC
 XeTeFRLOuT9dXXXocfMffKqubwVp7QCS98EoeT3/oYxUk/vpEXRNj18tl/FdlyMpQEn4JuABay2
 exy3gSrdNuCPPCzTLp7vUuIEHW90WNWuNGPRmNydnibo1qj6BmwMH0ky2foZIi1IfQOZjMmIEYJ
 2mJNaM38hbbevHzuXYql4h3ELYPxAfvTpYbJI8yTPWaPvRp2KDYEhzsfyMIOoq8n9oGQCYZ107W
 aEzqOqj1DMzVejCQ755g+SRbk4itUSd8lqQHpIlZthPW5VK1Ok1xHfGwVNvuDvXLfEDN6bg5Z6p
 MZSpthVYtgrmYxpQcppHiyQ04gLBS1jf8o2/ITQw3fL/twlZTto79nefS2Jahld8iqbNwOUQKbq
 wOsjSlhjgSQmgFLh5VOzh6C2OCAIP6eItvsrBN0ni3IfX59EtQTUL+MLoy1Dk+qJ/DUMvuuD5Fm
 dw8pMDiq5oZ0gQuFmEXupgLCLVEvzrJvwBPedAGTYNHGaRTxivt+lbufF5/LUHGLFqByWgsl+H7
 Yos95h0uRjT+vKg==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1NiBTYWx0ZWRfX+Xn9zer9ANaA
 ygyy6M2LnRbhJf1QqbTdjwPVZUKJ4Gy8w6IxXoSSvCJnAf/MsHo3FWGo15Pcu5Iz/ksM3W+RZr0
 gWqc8qFUh5sLWyufeIPwOI3lF1A3Zsc=
X-Authority-Analysis: v=2.4 cv=H+BOUOYi c=1 sm=1 tr=0 ts=6ad230b4 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=09uMWaUiLw9_HUPRBkgA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: wLkRgbc6sJAEP3YaTGDyzYd1vw_22uMr
X-Proofpoint-ORIG-GUID: wLkRgbc6sJAEP3YaTGDyzYd1vw_22uMr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1NiBTYWx0ZWRfX0zmhkIlAshSA
 QV1eiFRCZYFmDM+bNxfC9aZ/Xdw/7DXiAvivoXoOXXkZnoM8WxcnnRvTqc9Q/XV8gKTQb7buN+y
 g8yiqgzTD6nVxOpea6NMWmMXqK/RqPZLkccwbsyJJYIofFfgS7YhQhrJCD1iRQUgZVqP/TDC0bC
 2iaZJx1Boh0HYFj2E14tC1uYohsS0TygJbyhnReXB4tT8dHsi70532lluJmKU6/hNy/pr0uOeys
 ufZeUh6tMALI7dmGXwkJJs6BxDRHOE+fjjXUTQfIWD5TFe+vxqK4v+clUWb322pV45UG9gUI3aP
 tpf8vpY3cVPqOkb5yEM1fhspeuTFLgOkh6RUSacqjgZ1U5m2exHXiHvVd7FxxEkyKGdzG62l7ya
 Sp2DIGf7Obxq8EJcFhmPa+nb7VI1j2zzi65r+ncyJiYxhv8d2htZUGp72mWmquE2b/G5zZ2ooUh
 lhfRZhNGk/Yrbg29/gQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_02,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0 priorityscore=1501
 adultscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160056

From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

The QCE hardware does not support AES XTS mode when key1 and key2 are
equal. The driver was handling this by unconditionally rejecting the
keys with -ENOKEY(-126), regardless of whether FIPS mode is active or
the FORBID_WEAK_KEYS flag is set.
[    5.599170] alg: skcipher: xts-aes-qce setkey failed on test vector 0; expected_error=0, actual_error=-126, flags=0x1
[    5.599184] alg: self-tests for xts(aes) using xts-aes-qce failed (rc=-126)

In general for weak keys,
- If FIPS mode is active or FORBID_WEAK_KEYS is set: return -EINVAL.
- In non-FIPS mode, Accept the key and encrypt successfully.

Since QCE was returning -ENOKEY for non-FIPS mode whereas the
expectation is to encrypt content and return success, the selftest saw a
mismatch and failed.

There are two problems in QCE behavior:
  * -ENOKEY is returned instead of -EINVAL for the FIPS/weak-key
    rejection case.
  * key1 == key2 is rejected even in non-FIPS mode

Fix xts-aes-qce behavior by using generic helper xts_verify_key() to
reject keys early with -EINVAL for FIPS mode active(or FORBID_WEAK_KEYS
set). For non-FIPS mode, since QCE hardware cannot accept the keys, use
software fallback mechanism to encrypt the data.

Cc: stable@vger.kernel.org
Fixes: f0d078dd6c49 ("crypto: qce - Return unsupported if key1 and key 2 are same for AES XTS algorithm")
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
---
 drivers/crypto/qce/skcipher.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 0473033db2af90e119b731b9a6ec96de5973d3c8..03492b2fbbd4e22fcfe391cd110dec6cd65a9c48 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -12,6 +12,7 @@
 #include <linux/errno.h>
 #include <crypto/aes.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/xts.h>
 
 #include "cipher.h"
 
@@ -179,14 +180,17 @@ static int qce_skcipher_setkey(struct crypto_skcipher *ablk, const u8 *key,
 	if (!key || !keylen)
 		return -EINVAL;
 
-	/*
-	 * AES XTS key1 = key2 not supported by crypto engine.
-	 * Revisit to request a fallback cipher in this case.
-	 */
 	if (IS_XTS(flags)) {
+		ret = xts_verify_key(ablk, key, keylen);
+		if (ret)
+			return ret;
 		__keylen = keylen >> 1;
-		if (!memcmp(key, key + __keylen, __keylen))
-			return -ENOKEY;
+		/*
+		 * QCE does not support key1 == key2 for XTS.
+		 * Use fallback cipher in this case.
+		 */
+		ctx->use_fallback = !crypto_memneq(key, key + __keylen,
+						       __keylen);
 	} else {
 		__keylen = keylen;
 	}
@@ -251,6 +255,7 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	 * needed in all versions of CE)
 	 * AES-CTR with a partial final block (the CE stalls waiting for a full
 	 * block of input).
+	 * AES-XTS with key1 == key2 (not supported by the CE).
 	 * A payload fragmented across more than one scatterlist entry (the CE
 	 * stalls waiting for input in that case too).
 	 */

-- 
2.47.3

