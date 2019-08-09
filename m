Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FB2C31E40
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 19:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C41BF20B7C
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 19:29:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fQ/FPMr1";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="txi+f+au"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfHIT3R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 15:29:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46034 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbfHIT3Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 15:29:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79JIcNJ157279;
        Fri, 9 Aug 2019 19:29:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=cP1lKqCv0m7pam9tebxXo/dg9KekB6e4yuCInD6+caE=;
 b=fQ/FPMr1Ss3eHpewFAbQQhqDVOSD9fOh0Co9WGV6C8A3i5hVaZtc+zix++vGSsvPVdm/
 xLQQ0wEYOUfY8j+tR04Kac5dRl5s6D2OdhgBAEM07aJ0+UyrhhltXzhWw8QduBZA+LSw
 UMqbEDkjtrC9iVb9XU9RVSEud4eYRwPHuyY4CEeJkkDviB3+IwME4A4UvS7psCRDBkSl
 hWSPdXpIAmOZxmYTQRiYuIploShpXT9xtYOj2AbU29xYYlkg9+G3Slzza40TsmsWytYh
 4Gst0i6sgeKJRlbYODOEblOHHVeJxr8s4WWSzY94EWosMG1PsbAjrxBr3pjRR5tyeJUR SQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=cP1lKqCv0m7pam9tebxXo/dg9KekB6e4yuCInD6+caE=;
 b=txi+f+au5w37CRvs2HgnKjiRQgNwWceGT9awkbUgLS/e7hkC9MKKFbqpP/cqbIf7a37C
 h/ypGybwBGdwm2mVxCgHArfBAiojPa0aY0TN/VeXsqVXQ2gcNJ8uQ9DvJlYWke93A1Ve
 4fdcbcr4qhWgEFD2agRqsYAllALcWxLcALc5QZviYyH7VT6a4u3dtPzIGTCfTC3x4CkP
 JijxOrU0oN+2bIkuqc+nMLdW04zokSgn8ZtZKu7FwuC9WrSExJVEbST1VPxA+thzQpOP
 XtzBwV4JbVuPJ32pi8tkt58FCD4DgEesTu395PdnEEAtrkErzNVg66dOYs1JhQO2GMU9 XQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u8hps9kxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Aug 2019 19:29:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79JHxjv067816;
        Fri, 9 Aug 2019 19:29:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2u8pj9fsu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Aug 2019 19:29:05 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x79JT4qA015018;
        Fri, 9 Aug 2019 19:29:04 GMT
Received: from localhost.localdomain (/73.60.114.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 12:29:04 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] padata: validate cpumask without removed CPU during offline
Date:   Fri,  9 Aug 2019 15:28:57 -0400
Message-Id: <20190809192857.26585-2-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809192857.26585-1-daniel.m.jordan@oracle.com>
References: <20190809192857.26585-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090190
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908090190
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Configuring an instance's parallel mask without any online CPUs...

  echo 2 > /sys/kernel/pcrypt/pencrypt/parallel_cpumask
  echo 0 > /sys/devices/system/cpu/cpu1/online

...crashes like this:

  divide error: 0000 [#1] SMP PTI
  CPU: 4 PID: 281 Comm: modprobe Not tainted 5.2.0-padata-base+ #25
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-<snip>
  RIP: 0010:padata_do_parallel+0xf1/0x270
  ...
  Call Trace:
   pcrypt_do_parallel+0xed/0x1e0 [pcrypt]
   pcrypt_aead_encrypt+0xbf/0xd0 [pcrypt]
   do_mult_aead_op+0x68/0x112 [tcrypt]
   test_mb_aead_speed.constprop.0.cold+0x21a/0x55a [tcrypt]
   do_test+0x2280/0x4ca2 [tcrypt]
   tcrypt_mod_init+0x55/0x1000 [tcrypt]
   ...

The cpumask_weight call in padata_cpu_hash returns 0, causing the
division error, because the mask has no CPUs, which is expected in this
situation.  The problem is __padata_remove_cpu doesn't mark the instance
PADATA_INVALID as expected, which would have made padata_do_parallel
return error before doing the division, because it checks for valid
masks too early.

Fix by moving the checks after the masks have been adjusted for the
offlined CPU.  Only do the second check if the first succeeded to avoid
inadvertently clearing PADATA_INVALID.

Fixes: 33e54450683c ("padata: Handle empty padata cpumasks")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 kernel/padata.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index d056276a96ce..2ab3b7402643 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -702,10 +702,7 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 	struct parallel_data *pd = NULL;
 
 	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
-
-		if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
-		    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
-			__padata_stop(pinst);
+		__padata_stop(pinst);
 
 		pd = padata_alloc_pd(pinst, pinst->cpumask.pcpu,
 				     pinst->cpumask.cbcpu);
@@ -716,6 +713,8 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 
 		cpumask_clear_cpu(cpu, pd->cpumask.cbcpu);
 		cpumask_clear_cpu(cpu, pd->cpumask.pcpu);
+		if (padata_validate_cpumask(pinst, pd->cpumask.pcpu))
+			padata_validate_cpumask(pinst, pd->cpumask.cbcpu);
 	}
 
 	return 0;
-- 
2.22.0

