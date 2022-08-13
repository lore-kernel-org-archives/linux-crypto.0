Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7164C19F2D
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Aug 2022 23:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiHMXP7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 13 Aug 2022 19:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiHMXP6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 13 Aug 2022 19:15:58 -0400
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E62EE0F9
        for <linux-crypto@vger.kernel.org>; Sat, 13 Aug 2022 16:15:57 -0700 (PDT)
Received: from pps.filterd (m0134421.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27DI2850007963;
        Sat, 13 Aug 2022 23:14:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pps0720;
 bh=KkSSwSrX9O/aVIJWHWVAjso6Z4YTaN/HspdHdSqKUaU=;
 b=dk8LOBXiUZJ4WMjjyLeWqunNF8Z9h6KIG2zGQi9o6cYC2FPIoE+m8TBuLymoFSl0J7oh
 b19SEwQRjIXcOfjm8eO6Z/AJwhwfCDepi0END7WmUksHAnVkkaG3pcV7j8BHmZsedpTP
 XQ1S6JW0JXTu3gvvLQIspkbEzGepyFqqPzlgaia3jcBqaJWaIme+NiACJrkdSpAwzdeS
 VO9LjdXW6hhcu2RD02Sc6FzcOMXZyHad3nN6Lut5RFdeNNvh2clFu+npxN/81LLcqjnV
 5aKcwl7M2fpR043FJb7ElRmWYnf3ihoL080BoBfyG4z5wRvJrcgJ9FobKpBVgeF8ji7o Ag== 
Received: from p1lg14879.it.hpe.com (p1lg14879.it.hpe.com [16.230.97.200])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3hx3vfme2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 13 Aug 2022 23:14:50 +0000
Received: from p1lg14886.dc01.its.hpecorp.net (unknown [10.119.18.237])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by p1lg14879.it.hpe.com (Postfix) with ESMTPS id 13E6CD2ED;
        Sat, 13 Aug 2022 23:14:50 +0000 (UTC)
Received: from adevxp033-sys.us.rdlabs.hpecorp.net (unknown [16.231.227.36])
        by p1lg14886.dc01.its.hpecorp.net (Postfix) with ESMTP id 4BCAC80026D;
        Sat, 13 Aug 2022 23:14:49 +0000 (UTC)
From:   Robert Elliott <elliott@hpe.com>
To:     ebiggers@google.com, tim.c.chen@linux.intel.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, toshi.kani@hpe.com, rwright@hpe.com
Cc:     Robert Elliott <elliott@hpe.com>
Subject: [PATCH] crypto: testmgr - don't generate WARN for missing modules
Date:   Sat, 13 Aug 2022 18:14:43 -0500
Message-Id: <20220813231443.2706-1-elliott@hpe.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: CPgsvbFmveAl0wqxKO_gkzX7UWhWql3N
X-Proofpoint-ORIG-GUID: CPgsvbFmveAl0wqxKO_gkzX7UWhWql3N
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-13_11,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 spamscore=0 clxscore=1015 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208130096
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This userspace command:
    modprobe tcrypt
or
    modprobe tcrypt mode=0

runs all the tcrypt test cases numbered <200 (i.e., all the
test cases calling tcrypt_test() and returning return values).

Tests are sparsely numbered from 0 to 1000. For example:
    modprobe tcrypt mode=12
tests sha512, and
    modprobe tcrypt mode=152
tests rfc4543(gcm(aes))) - AES-GCM as GMAC

The test manager generates WARNING crashdumps every time it attempts
a test using an algorithm that is not available (not built-in to the
kernel or available as a module):

    alg: skcipher: failed to allocate transform for ecb(arc4): -2
    ------------[ cut here ]-----------
    alg: self-tests for ecb(arc4) (ecb(arc4)) failed (rc=-2)
    WARNING: CPU: 9 PID: 4618 at crypto/testmgr.c:5777
alg_test+0x30b/0x510
    [50 more lines....]

    ---[ end trace 0000000000000000 ]---

If the kernel is compiled with CRYPTO_USER_API_ENABLE_OBSOLETE
disabled (the default), then these algorithms are not compiled into
the kernel or made into modules and trigger WARNINGs:
    arc4 tea xtea khazad anubis xeta seed

Additionally, any other algorithms that are not enabled in .config
will generate WARNINGs. In RHEL 9.0, for example, the default
selection of algorithms leads to 16 WARNING dumps.

One attempt to fix this was by modifying tcrypt_test() to check
crypto_has_alg() and immediately return 0 if crypto_has_alg() fails,
rather than proceed and return a non-zero error value that causes
the caller (alg_test() in crypto/testmgr.c) to invoke WARN().
That knocks out too many algorithms, though; some combinations
like ctr(des3_ede) would work.

Instead, change the condition on the WARN to ignore a return
value is ENOENT, which is the value returned when the algorithm
or combination of algorithms doesn't exist. Add a pr_warn to
communicate that information in case the WARN is skipped.

This approach allows algorithm tests to work that are combinations,
not provided by one driver, like ctr(blowfish).

Result - no more WARNINGs:
modprobe tcrypt
[  115.541765] tcrypt: testing md5
[  115.556415] tcrypt: testing sha1
[  115.570463] tcrypt: testing ecb(des)
[  115.585303] cryptomgr: alg: skcipher: failed to allocate transform for ecb(des): -2
[  115.593037] cryptomgr: alg: self-tests for ecb(des) using ecb(des) failed (rc=-2)
[  115.593038] tcrypt: testing cbc(des)
[  115.610641] cryptomgr: alg: skcipher: failed to allocate transform for cbc(des): -2
[  115.618359] cryptomgr: alg: self-tests for cbc(des) using cbc(des) failed (rc=-2)
...

Signed-off-by: Robert Elliott <elliott@hpe.com>
---
 crypto/testmgr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 5801a8f9f713..c28fb0a7811d 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5774,8 +5774,11 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 			      driver, alg,
 			      fips_enabled ? "fips" : "panic_on_fail");
 		}
-		WARN(1, "alg: self-tests for %s (%s) failed (rc=%d)",
-		     driver, alg, rc);
+		pr_warn("alg: self-tests for %s using %s failed (rc=%d)",
+			alg, driver, rc);
+		WARN(rc != -ENOENT,
+		     "alg: self-tests for %s using %s failed (rc=%d)",
+		     alg, driver, rc);
 	} else {
 		if (fips_enabled)
 			pr_info("alg: self-tests for %s (%s) passed\n",
-- 
2.37.1

