Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6AD22259B;
	Thu, 22 May 2025 08:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747904286; cv=none; b=QWICIA89uLwZ1LQd3JnlzLQxluXgzTE43jY3aXYtbLXqo7//okslmYK39ev23z5tVnlkHebf2lgeFegAzs2wFy7rlzXCA+rjqtTiKftxXFiSrKhcB9TOw4+dfGtkBWwcSJzcoorNCHG61ngkepeHdkVWP9KNmJm4TKBA0u9or5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747904286; c=relaxed/simple;
	bh=/8SzdPdJRCUD+kdnzMwrPVzUfPKTOvoWoF3HgJWODvA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F/ohp4ACUOMYY686yAXnFoul6y2OzluLQV+vZkPpUu2oVOb1Dx9hFm4/N03dr9CAvCtEzZmnt+mrpo/1P8Q1gIMNQj5XczHuk0dmwjEMm/jfHeJNQDDTyPNxjLLAm1TlRegrfTyREsLdrKXCRTLkD/ZmDz96x/d3YQGkFGIEk3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bb0MEZme; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bb0MEZme"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54LMX8gE006679;
	Thu, 22 May 2025 08:58:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=Bx/rEuUxuzs7gyWVc8XdUVpRrUA5dK9EU/SQIevMz
	C0=; b=bb0MEZme8EoyfpNIfgFRPB6/3UGXEAm2AM9aUYBM4z/T7Xw+etor+etPM
	77IL0L0bKVFkmApSDzNKtnKQDj0oGoGyE9SJIwlJNFUkqy817PI1uiuZenn2vvSC
	L/rILPdatdRwAfLhKswzXY919XEDZ+HBspMFXIX/CRS+tgGE4oIatoAL5f3c6r0Z
	ypLaHW9TfKHjwJc5dd1XQ4HU/MFPZZkq5rqIdHHEJrSyd3ez8K8qjQVlGUKO6Gt9
	TRGuIdVk8T6SWWSGbgCxZAVVbvDfRbNR2puI1ISlHERfaDVCftXMKJplr2WMo0ku
	0pUYIOgbe+Wql5NE83NUbn7tQ0zMA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46sg234pqw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 08:58:00 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54M5SP0u010630;
	Thu, 22 May 2025 08:57:59 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46rwnmgp52-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 08:57:59 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54M8vtGV55902580
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 08:57:56 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF8B020043;
	Thu, 22 May 2025 08:57:55 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9593420040;
	Thu, 22 May 2025 08:57:55 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.152.224.229])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 May 2025 08:57:55 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, dengler@linux.ibm.com, ifranzki@linux.ibm.com
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        fcallies@linux.ibm.com
Subject: [PATCH v11 0/6] New s390 specific protected key hmac
Date: Thu, 22 May 2025 10:57:49 +0200
Message-ID: <20250522085755.40732-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Cf8PmfsIr-FHRVPW9-AkYI4bl6OrVtjZ
X-Authority-Analysis: v=2.4 cv=RPmzH5i+ c=1 sm=1 tr=0 ts=682ee718 cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=dt9VzEwgFbYA:10 a=-xSpq2wtoGP2116iE9YA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDA4NiBTYWx0ZWRfX87WsgnSRmo9x 0KO1yePM1ZBoYcvcmyqNID0IGYmnsmi5dZMfjidRrETqX9f69iG+t3vw+80eKETud5D/UvJzm0V LPKXIStcOLLV988U4ykrd0uw5V45+EeVgxBwPRKEueGo6Lpf+n4LpeWnijenrHibScLsIQq0QfW
 cD3prmwmdvSWdCWSfpOeaRdQWO1Ina4i85Qjj6fUtoXHIYFDQT+4MOIo3TF/Cj9vDVk+IIU14s9 UOQQwfXP+Uc+bxiTFWNjI1xOh2HKyv0nXeqei5FTYruTATbn2kBtiAIbCsvPkUX9eefH0SqSdla jJGgY4VEulF/v29i3LRw6EDd82gszrwf2aCqv1f9ry3X5PGEfk4h20L/1r5xZW9GbO93liT+ycG
 mfxkoe6C5KTFl6V9f8aNR2o8nLe6U7Wvmp5YLco34BaDxZX/bSYITTjOCFvtK4TQYm1Envoe
X-Proofpoint-GUID: Cf8PmfsIr-FHRVPW9-AkYI4bl6OrVtjZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_04,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 phishscore=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505160000 definitions=main-2505220086

Add support for protected key hmac ("phmac") for s390 arch.

With the latest machine generation there is now support for
protected key (that is a key wrapped by a master key stored
in firmware) hmac for sha2 (sha224, sha256, sha384 and sha512)
for the s390 specific CPACF instruction kmac.

This patch adds support via 4 new hashes registered as
phmac(sha224), phmac(sha256), phmac(sha384) and phmac(sha512).

Changelog:
v1: Initial version
v2: Increase HASH_MAX_DESCSIZE generic (not just for arch s390).
    Fix one finding to use kmemdup instead of kmalloc/memcpy from test
    robot. Remove unneeded cpacf subfunctions checks. Simplify
    clone_tfm() function. Rebased to s390/features.
v3: Feedback from Herbert: Use GFP_ATOMIC in setkey function.
    Feedback from Holger: rework tfm clone function, move convert key
    invocation from setkey to init function. Rebased to updated
    s390/features from 11/7/2024. Ready for integration if there are
    no complains on v3.
v4: Rewind back more or less to v2. Add code to check for non-sleeping
    context. Non-sleeping context during attempt to derive the
    protected key from raw key material is not accepted and
    -EOPNOTSUPP is returned (also currently all derivation pathes
    would in fact never sleep). In general the phmac implementation is
    not to be used within non-sleeping context and the code header
    mentions this. Tested with (patched) dm-integrity - works fine.
v5: As suggested by Herbert now the shashes have been marked as
    'internal' and wrapped by ahashes which use the cryptd if an
    atomic context is detected. So the visible phmac algorithms are
    now ahashes. Unfortunately the dm-integrity implementation
    currently requests and deals only with shashes and this phmac
    implementation is not fitting to the original goal any more...
v6: As suggested by Herbert now a pure async phmac implementation.
    Tested via AF_ALG interface. Untested via dm-integrity as this layer
    only supports shashes. Maybe I'll develop a patch to switch the
    dm-integrity to ahash as it is anyway the more flexible interface.
v7: Total rework of the implementation. Now uses workqueues and triggers
    asynch requests for key convert, init, update, final and digest.
    Tested with instrumented code and with a reworked version of
    dm-integrity which uses asynchronous hashes. A patch for dm-integrity
    is on the way but yet needs some last hone work.
v8: Added selftest. With the selftest comes some code which wraps the
    clear key into a "clear key token" digestible by PKEY. The
    selftest also uses import() and export(), so these are now also
    implemented. Furthermore a finup() implementation is now also
    available. Tested with AF_ALG testcases and dm-integrity, also
    tested with some instrumented code to check that the asynch
    workqueue functions do their job correctly. Coding is complete!
v9: As suggested by Herbert use ahash_request_complete() and surround it
    with local_bh_disable().
v10: Split the pkey selftest patch into 3 patches. Slight rework of the
     setkey function as suggested by Holger: When selftest is running
     as much as possible of the production code should run. So now the
     key prep with selftest is one additional if/then block instead of
     an if/then/else construct.
     Code is ready for integration and well tested.
v11: Utterly rework with the insights collected with the paes rework
     and the basic work done with the pkey rework over the last 5 month.
     Note that patch #1 effectively reverts commit 7fa481734016
     ("crypto: ahash - make hash walk functions private to ahash.c")
     from Eric Biggers.

Harald Freudenberger (5):
  crypto: ahash - make hash walk functions from ahash.c public
  s390/crypto: New s390 specific protected key hash phmac
  crypto: api - Add crypto_tfm_alg_get_flags() helper inline function
  s390/crypto: Add selftest support for phmac
  crypto: testmgr - Enable phmac selftest

Holger Dengler (1):
  s390/crypto: Add protected key hmac subfunctions for KMAC

 arch/s390/configs/debug_defconfig |    1 +
 arch/s390/configs/defconfig       |    1 +
 arch/s390/crypto/Makefile         |    1 +
 arch/s390/crypto/phmac_s390.c     | 1042 +++++++++++++++++++++++++++++
 arch/s390/include/asm/cpacf.h     |    4 +
 crypto/ahash.c                    |   26 +-
 crypto/testmgr.c                  |   30 +
 drivers/crypto/Kconfig            |   12 +
 include/crypto/internal/hash.h    |   23 +
 include/linux/crypto.h            |    5 +
 10 files changed, 1124 insertions(+), 21 deletions(-)
 create mode 100644 arch/s390/crypto/phmac_s390.c


base-commit: b5185ea1a6bd35957e556129bb92a64f83aa65e4
--
2.43.0

