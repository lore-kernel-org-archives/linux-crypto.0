Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E9953D9CA
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790081864; cv=none; b=gwZp49JZg+bDEzme/RXv+xpArhjDnxM910znlZVXZIWbehf1MtSTyFTN/S/fVKCeq3zTe6EvaddyClPcYanDg5iFfPBC0QGuaBRW/NzoTblmuPcJAlfYhQFawKZExGMUEnqcBNqVHCyefwskdNtTimse3GHTHe7vVux5UbZGrQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790081864; c=relaxed/simple;
	bh=dYsr7g+tF8CNkXBAx5mFTWaPphcdgU8zJTnndPdeYs4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=UMRIssmWgmaLikMm9Qrq2f+7QUc8VY/+YGq03ClRUHGQxVc/ZHkJtoQXe1QQOJWP4pErQytGhXf9H+tAkuBWrN3zOvs76eVeu+OKTv8dsYIP03b9G1hoa+FCDexnaLCj/MdT9KCWY6hW7MGKDO72P2RgTPt/dK1oVQ6jqW79fGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VfxIlyzF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=R1joqN1f; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VfxIlyzF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="R1joqN1f"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68MBPhOo134530
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:57:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=ymvkpoWzU6m8wYN9GhvTp7
	0cJqfVE7exSAj73XIQgKo=; b=VfxIlyzFqqLhY4ZQtfNj1ourowhNePkyiamnoi
	FWlYCJfXIRVTH2oJjTRtTLhd7VRIvT9V0sP6UHvSnL+icdBn2pw3/SshL75i7fub
	oXFp6FxndGyouEKyzHrLVPrVa8ySiuk1CW9rktSCR/k8TeNoyqtaplfLsuQL8lZR
	Davu03TquMVujBnLWwaiQp+lD2HUno78DdXGcYZBSh4cFSTiKgjnAgbA1ELkef16
	Dmo7EQv6mW1ff/xwsEhGm/3Q9fYMWmf7AYES+62592vwWA5ztF/4NyL5Mp/AeBWh
	aXrZpfH+qoWW8wDbwbdABPlnvNpmefDQsxhXC4YCJ01vrCDw==
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com [209.85.221.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gujkja09x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 12:57:42 +0000 (GMT)
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-5c847f0fe78so1456221e0c.1
        for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 05:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790081861; x=1790686661; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ymvkpoWzU6m8wYN9GhvTp70cJqfVE7exSAj73XIQgKo=;
        b=R1joqN1fx21ztABkQlf7X2BVR67pOF/56jV4U6a6CH/6GCMD1FV7xe6Knz0QEqcKKm
         fxTKLw0h4btaG6paW9OHeoCZaGMooChXcguLvxODwRc5gFDiLUc2z772T0vY7R0j++ks
         hMgMzh4MoKSuJBacrlFWyjOoP2IsDNKcRzi3n7ciZv1N8PBjeACoCJ/dhDAbXM+VDHXr
         OYTFYLiHCogHjYTHSwthZ0F7RR6DAxxrUEz8szUxt+gZ96mWrMejlAXTqRZ2WDKa7/Nj
         6MO/L/L4Fnc98j3JIbnPW8B5YyVThqHwAQCDXC0YFSyrlbxVvf+ODHAu+TJjtZOb+DPO
         gCNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790081861; x=1790686661;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ymvkpoWzU6m8wYN9GhvTp70cJqfVE7exSAj73XIQgKo=;
        b=qosAgUYydsqHpfEUHwkUCUOriHbsH7pEmYweQMnwDL/VNlW+RZMz1exdeYRdNJKmU9
         DLzbFNwU7+AtkfeH4d8GbaMbhjGsJjnwiLigJW/ddLpgxDODAmqPjGd4gAqfSd4iuAuP
         3upkEN9mNTbDHCum3h6VB2JsP+GGXDfvSJrgZTgW5CXISTNX+n//UZj1oabtyAXFS/dp
         7hnoQ5DiJhztSHhvKnT7hL2GxrdOqRPsn6mjIczSuq6kU3utzQP/83uIczx+KpSaRJlj
         mpOBdoo8Ug3vgzjWAUPICSMvFF8rLATWmnj8HlRknyWGHQPz4glzqa5TzahscfDYhyW2
         cPwQ==
X-Gm-Message-State: AFuF++kS0WAy6Xwc3ILAi2aQPOhdiSn0t+sC7NwY/zuSdHIJ55SrtZe5
	cOBMvp4rHQpb+63yw2iZycuAX6B+07HFjFG0/oiW4ywGNkDg6qqQq/52wgdePHv064kxFWeiXz3
	8RNOpjBIV77MC+Lj+SsR6dA/daz0SOroGQ36t0NHY6+m4+DV5WFxB8GVTWJ4iXUemvqU=
X-Gm-Gg: AYBFou12BJ3evG2h+hn7VNuT7u/DwtFPlp0/KGfXVSaxAMmUA473aCY76JKz8avbHgT
	HqiddJZnfGtGRh9E9+2e7eJMOLm9TumSWE0yEt6b316ujCXthxfj1UzbOFKVD4S2C4GvdMIVLd7
	hzGszj00CT8/SfmjSmNWzt/hWDkDzsbS1NkLWepmAyGMuOT6KdYEprXFSrT35teGRS9oWcgxfVX
	MPsm1cauD8wmQf4MV3mXa3NOUlIFHsiogvM3QYP47rTZMD5tGTbBb9+OcOI7eSOj8nGqY/p/seH
	D4QSSucRy6Jexxa2iK7ujyv/AKXmbVZMvDjCpXGt3SzOScZlRdXCl1pAMOOHvXJL7FdgWUiuGpV
	l4Bo8Y5J+jghtIrVjvaFWyD6t7tc=
X-Received: by 2002:a05:6122:3c4a:b0:5c4:4ec2:971c with SMTP id 71dfb90a1353d-5c9e3615b6dmr2296905e0c.10.1790081861029;
        Tue, 22 Sep 2026 05:57:41 -0700 (PDT)
X-Received: by 2002:a05:6122:3c4a:b0:5c4:4ec2:971c with SMTP id 71dfb90a1353d-5c9e3615b6dmr2296864e0c.10.1790081860582;
        Tue, 22 Sep 2026 05:57:40 -0700 (PDT)
Received: from brgl-qcom.local ([2a01:cb1d:dc:7e00:5105:ff9:e148:c440])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aaa4537b5dsm1097669a12.30.2026.09.22.05.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 05:57:39 -0700 (PDT)
From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH v9 00/14] crypto: qce - Fix crypto self-test failures
Date: Tue, 22 Sep 2026 14:57:15 +0200
Message-Id: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACt7smoC/3XRzWoDIRAH8FcJnmvQWT976nuUHow6jZBkm3W7t
 IR9904CJXvQi/CX8ecMc2M1TyVX9rq7sSkvpZbxQsG/7Fg8hstn5iVRZiDACCMFv8bMsfzwmk/
 I51znypUHxAQZvdaMHn5NmSoe6PsH5WOp8zj9Pv5Y4H77z+kWtwAXPEUvJcoQkoK3sdb99Tuc4
 ng+7+lgd3UZtpJtSgNJOUY4qJRTxNSR1EYCaEqKJIWOBg1Wmmg6kn5KVpimpElyBpWRiNKB70h
 mI3WmM/eetLZWY9ZoYkeyT8m3F7hYkmI6JLDSBZSqI7mNBLIpOZKksHqwzvhgW7tb1/UPVun4t
 3cCAAA=
X-Change-ID: 20260610-qce-fix-self-tests-492ffd2ef955
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5645;
 i=bartosz.golaszewski@oss.qualcomm.com; h=from:subject:message-id;
 bh=dYsr7g+tF8CNkXBAx5mFTWaPphcdgU8zJTnndPdeYs4=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBqsnsxXSBbzCZejmMudN1ruGQx6uA+ZMejuQ/IS
 cuLwrGrq7aJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCarJ7MQAKCRAFnS7L/zaE
 w46CD/9Qu8HWR30M4uQybl3JAsIqZ0DaEJ91Jke41wIWITmXR4SCe2IG+YLXQPREFYZg+xKve/u
 YDZjqum/sNjHr285WkA6Cj/4TkhZSYtqa9PiJKervyOSLThSllAlgf8/QV1aOswEzSLWL7Pv73u
 7sLwsp7tLn8yZhhtNRorCh9QPluBSuDeGEx7eaW7uFH+4v+V/Shdykd1SJ2oJGqRffu8BqZ6nw/
 4XC1w4X18UzRqIFe3Q4vGrOxeqpNoSmIANiRRdu9o+IZ2V3Gc8ebKtWolJol71iH/Q1wpvNu0ZP
 d2YtbsV7qurmvjPMjO6lrLTrxk9PcHfzw4iEA+CthqDShgafOMAYHhM+lH++LLXGSU5+hGWsKJm
 QCowWTXG95jOeGg5q4xTIesd9BCyle8eRRfg4U6R2BjRTc6CTiQY5dFhQpG+mnEvLnUGWi4ts7h
 ohC1MN4wbySjf7/KKI7hXd0mas7suaJh5pgKwBguibLT7vjti/u9caJJoKtSuMEKIeEpdp1WcSo
 wAnJl+MrkL2X9oF8he0HwBDpzlCiWeg+JPt8loMX1r6VFqW+0K6z0I6j9MWWPqwKWtSNZtaz4Hn
 tduCUVYwX9XUD4UorPxVjIS3/ogdxzPJT0BOyv7AVZypudHA17B7ZYM63PpLhCBlTHiDZWBUt/W
 tG0kjBjbITth6OA==
X-Developer-Key: i=bartosz.golaszewski@oss.qualcomm.com; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772
X-Proofpoint-GUID: qCNnws98LkIXz4aIHbXu_ZuIMIHqaGJ-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIyMDE4NyBTYWx0ZWRfX3zQqM7/s198F
 I6tYpRKG9J/B4f4c/LjBNLa2BKkemM96bAO9Ew8wjt9jOgV3kQ1c8xZwdbJ24R95qhC39IaXsct
 KKXil04DjQ83LzRQlPVAaNbEERgrtxTUpc1oI7WEnqQVGYH+D/exNRj+HacUAQ4UYwmYX2QIsVb
 nZeirGE4hcAlfGGPnZhWUPJDixa358y6kKkxhJyN/Leqa4zbeeJwqKIR+M6EAEfygU2O2egGF6F
 HC/jUWkmWpK6BA/nF6j3TlcQei3OVaMSuJO8ZDbCMp/ImVWaMlopZjO82v4JkdlXZP8Zcr1+OnD
 dNpqVkGQNdEepCmb5BMunPa7Ea2afNOMUpMOicyxVPct63WJ6F5ruCACafyY09OSY3Q5X8gMvX3
 ENI9OQM5kWddebeWo5xRl+tGFEwQL8KEk44W9xj+59U+a3ciF3oDB2uXqDzYWUxBB+6oKlB2fHn
 9OVQ2gxzS1BwZ0gG4kA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIyMDE4NyBTYWx0ZWRfXxj+nW+O204ix
 ljqdgDDZybibvwf+WbvDTu4xmRzAZ+85fL8l88/DDrD6vCHLTqYqYzxbpRwiZsiKi7oqavj/cRx
 JHzuIllEqO7I0MwQsucL8FHVRds7Ezs=
X-Authority-Analysis: v=2.4 cv=SuAFe/O0 c=1 sm=1 tr=0 ts=6ab27b46 cx=c_pps
 a=wuOIiItHwq1biOnFUQQHKA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=bC-a23v3AAAA:8
 a=EUspDBNiAAAA:8 a=9xMiekJfADYskRgvD40A:9 a=QEXdDO2ut3YA:10
 a=XD7yVLdPMpWraOa8Un9W:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-ORIG-GUID: qCNnws98LkIXz4aIHbXu_ZuIMIHqaGJ-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-22_01,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609220187

This iteration - in addition to the previous fixes - proposes to split
the QCE driver into a core part necessary to bind to the QCE DT node and
enable runtime power management in order to allow to drop the
interconnect votes, and the crypto part registering the crypto
algorithms. The core module is then enabled in arm64 defconfig while the
crypto part stays disabled by default. In addition: the actual
registration of crypto algos is gated with a module parameter that
default to false.

Note that remaining reported bugs will still be fixed in follow-up
series. This series addresses self-tests and disables the algos by
default.

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
Changes in v9:
- Rebase on top of cryptodev/master
- Rephrase Kconfig help text changes
- Link to v8: https://patch.msgid.link/20260921-qce-fix-self-tests-v8-0-107537869a72@oss.qualcomm.com

Changes in v8:
- Add a patch making the crypto driver *not* register algos by default
  but only if the user explicitly requests it with the provided module
  parameter
- Use the "offloader" name for the crypto IP instead of "accelerator"
- Fix device module table issues
- Make the core driver use a list (despite it only having a single
  member now) of child auxiliary devices to register to make it clear we
  have the intention of extending this once we start the work on secure
  media playback
- Link to v7: https://patch.msgid.link/20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com

Changes in v7:
- Add follow-up changes converting the QCE crypto driver to auxiliary
  bus, adding the core QCE driver under drivers/soc/ registering the
  auxiliary device and removing the BROKEN Kconfig label
- Link to v6: https://patch.msgid.link/20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com

Changes in v6:
- Handle all zero-length HMAC finalizations (like imported state with
  data already hashed), not only the genuinely empty message case
- Add an additional patch addressing the fragmented skcipher payload
  issue
- Link to v5: https://patch.msgid.link/20260706-qce-fix-self-tests-v5-0-86f461ff1829@oss.qualcomm.com

Changes in v5:
- Dropped patch 1/8 that's already queued
- Use the pre-allocated fallback ahash for HMAC transforms (Herbert)
- Link to v4: https://patch.msgid.link/20260622-qce-fix-self-tests-v4-0-4f82ffa716c6@oss.qualcomm.com

Changes in v4:
- Remove remaining ECB and DES3 bits
- Pick up tags
- Link to v3: https://patch.msgid.link/20260617-qce-fix-self-tests-v3-0-ecc2b4dedcfd@oss.qualcomm.com

Changes in v3:
- Remove even more algorithms and dead code in patch 1/8
- Link to v2: https://patch.msgid.link/20260615-qce-fix-self-tests-v2-0-dc911f1aad42@oss.qualcomm.com

Changes in v2:
- Add fixes for the full suite of crypto self-tests
- Add Fixes and Cc tags
- Link to v1: https://patch.msgid.link/20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com/

---
Bartosz Golaszewski (12):
      crypto: qce - Fix HMAC self-test failures for empty messages
      crypto: qce - Reject empty messages for AES-XTS
      crypto: qce - Use a fallback for AES-CTR with a partial final block
      crypto: qce - Use fallback for fragmented skcipher payloads
      crypto: qce - Use a fallback for CCM with a partial final block
      crypto: qce - Use fallback for CCM with a fragmented payload
      crypto: qce - Only register algos if the user really wants it
      Revert "crypto: qce - Mark QCE as BROKEN"
      crypto: qce - convert to auxiliary bus
      soc: qcom: add core driver for the Qualcomm Crypto Engine
      arm64: defconfig: enable the Qualcomm Crypto Engine core driver
      arm: multi_v7_defconfig: enable the Qualcomm Crypto Engine core driver

Kuldeep Singh (2):
      crypto: qce - Fix CTR-AES for partial block requests
      crypto: qce - Fix xts-aes-qce for weak keys

 arch/arm/configs/multi_v7_defconfig |   1 +
 arch/arm64/configs/defconfig        |   1 +
 drivers/crypto/Kconfig              |  26 +++++----
 drivers/crypto/qce/aead.c           |  44 ++++++++++++---
 drivers/crypto/qce/cipher.h         |   1 +
 drivers/crypto/qce/common.h         |   1 -
 drivers/crypto/qce/core.c           | 105 ++++++++++++++++++------------------
 drivers/crypto/qce/core.h           |   5 +-
 drivers/crypto/qce/sha.c            |  70 ++++++++++++++++--------
 drivers/crypto/qce/skcipher.c       |  62 +++++++++++++++------
 drivers/soc/qcom/Kconfig            |  11 ++++
 drivers/soc/qcom/Makefile           |   1 +
 drivers/soc/qcom/qce-core.c         |  92 +++++++++++++++++++++++++++++++
 13 files changed, 311 insertions(+), 109 deletions(-)
---
base-commit: a9a2152d292fd0bc73814eb4a127278ee7dd3f6a
change-id: 20260610-qce-fix-self-tests-492ffd2ef955

Best regards,
-- 
Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

