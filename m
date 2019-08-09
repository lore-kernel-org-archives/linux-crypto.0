Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F349DC433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 21:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBE0A2085A
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 21:08:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VPi+kpqy";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VgLe7xqr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfHIVI0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 17:08:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45396 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfHIVI0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 17:08:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79L5ckN070468;
        Fri, 9 Aug 2019 21:08:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=qPGkfFOzCb8gidKvwQnil0iLWuNYNpWlWuUd78n126c=;
 b=VPi+kpqy0bi3E9ra/RYYGrfhuQgzF7z+//srmIaL+tCfXJ35FGn/4vcqn/1T05mJXxLd
 YIjGYfJbUxhJPrOgtzeoKfTQoB/YpIAZhvZdvjYCOzfKZu33yVpHOUtEeFthlA+8hE7v
 YletivaSHwBNNRLnqHcvOra4hJKYBDadgVP1UQbBPTpT3FDgT35hEYu2/Sz69QEKgaUB
 JV6B3IYPrvaFh3p5XKEYOrHbBVDFIMCx6nJXhZ3KnaYUkJWjYbNh+B61S70ZliMaEi3B
 8Qfmg1z0/anJu2lOTkd45QRDDH8kIpWomV6uWI6qqHS3KYpDIrHpcq4F1mSUGlgLKUpt lg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=qPGkfFOzCb8gidKvwQnil0iLWuNYNpWlWuUd78n126c=;
 b=VgLe7xqr47J3KwzCUURxYaKc0fZO3TdQT9zUVnIs1dSjA94hBriLCvOlJOVmk7JoZS9f
 U+EfgT/NkB6rM1KcouHBKM2lck2twbzXUVE2/ZMhFeLdkObfuF21kRH9P1gNKNxviGtp
 s840uWwedscVlhuw5n12MXMc7okF0f5rLYeD1ossyRGAGi9Zz++wAkdzYC5km0Idq5Mp
 WfyQW1GBqUpL8sOobw3TITDkBd5vr6fwDkUFqfy6mAOWDDA2jox56XTbNd3bArO1MzTp
 RZmMDJtofx2tfU08RpCiShqoct14NbE9UH/xJPW8aMgHPwZmiorG/CiNNtlvWD211sZk fA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u8hasj5rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Aug 2019 21:08:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79L49hm015714;
        Fri, 9 Aug 2019 21:06:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2u8x9fwp4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Aug 2019 21:06:15 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x79L6DGG016522;
        Fri, 9 Aug 2019 21:06:14 GMT
Received: from localhost.localdomain (/73.60.114.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:06:13 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] padata: validate cpumask without removed CPU during offline
Date:   Fri,  9 Aug 2019 17:06:03 -0400
Message-Id: <20190809210603.20900-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809192857.26585-2-daniel.m.jordan@oracle.com>
References: <20190809192857.26585-2-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090206
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908090206
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

Stop the instance unconditionally and start again if the masks are
valid.  Stopping the instance only after an invalid mask is found risks
this div-by-0 crash since a padata_do_parallel call in another task
could happen between cpumask_clear_cpu and padata_validate_cpumask.

Fixes: 33e54450683c ("padata: Handle empty padata cpumasks")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---

v2: Don't leave the instance stopped if the masks are valid.

 kernel/padata.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index d056276a96ce..01460ea1d160 100644
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
@@ -716,6 +713,9 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 
 		cpumask_clear_cpu(cpu, pd->cpumask.cbcpu);
 		cpumask_clear_cpu(cpu, pd->cpumask.pcpu);
+		if (padata_validate_cpumask(pinst, pd->cpumask.pcpu) &&
+		    padata_validate_cpumask(pinst, pd->cpumask.cbcpu))
+			__padata_start(pinst);
 	}
 
 	return 0;
-- 
2.22.0

