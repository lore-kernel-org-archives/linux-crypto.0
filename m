Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7CE5C0650F
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 16:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 776D7217F4
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 16:05:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EkBVZSNZ";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="plTG0uX6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403849AbfHHQF4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 12:05:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47704 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732698AbfHHQF4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 12:05:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x78FuLm2155989;
        Thu, 8 Aug 2019 16:05:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=sBbOLnRj6Q0JgUUU4xmQw9W1HyJ1xIvokVeC4MhO0M4=;
 b=EkBVZSNZOgiRTalVvPCvhfNII+whsQ9eya8vyGPXljlLhy0E5gQur6667ImfbxiopkPX
 FktlhZxqaKlYd7leFTIOO5lJkw+YTUCLhz1q4dDwWVhNru3SuifOF0KCeE8Tx3Yk73Bs
 sqqj46k2bMNikPaQiMHmNX9cdduYX0v6r25eP47uapk7ngwxVBVEMCKUZLWRjkptlNAU
 cwOlaTnXiPI+585GbgHiyp9COLRJlBHWHzpJ4vOqFiQfNJ6rUAZoMLcMrIHq4eCswlsO
 lBNSLVRSFMRt9aRZn59EETuHVMGmhzawqhMOWetif8zkCyes6aypnLgZDdOOFOh1GIwt cQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=sBbOLnRj6Q0JgUUU4xmQw9W1HyJ1xIvokVeC4MhO0M4=;
 b=plTG0uX62gkHXEYAU2IICb1SBJA0z17MXQg9bDZ4jcPqnUu4eqXH0H/AMcWtUxLPLw47
 eepVTj7ErVUSfV9ii3gEiUUE269GNfMu0Dc1s+OdgZ1Xvvk1krtc5i+KGXu7XTqQHhVs
 3ODF56s0fbN/FbWY6mrM1T6CMW+LGa7Lc5Sb5Lax1FuRnh12j90jqZnzEVsy+TQJlmVA
 dSkM9Cn55Lss5ZJWt21k/V4mDYxQzLRkYduiByvG5wi8vNqrh0dlpqkv9O9KHeuP0oeW
 D88/thWhtSK5/z571LJY2rgMH0ep5Ld0Fdm3Cjn/6juYcLjIKiV4FJTdaq1578mMQr3S CA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2u8hgp27ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 16:05:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x78FwA6j011668;
        Thu, 8 Aug 2019 16:05:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2u763khenv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 16:05:44 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x78G5gHB030447;
        Thu, 8 Aug 2019 16:05:43 GMT
Received: from localhost.localdomain (/73.60.114.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Aug 2019 09:05:42 -0700
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] padata: initialize pd->cpu with effective cpumask
Date:   Thu,  8 Aug 2019 12:05:35 -0400
Message-Id: <20190808160535.27219-1-daniel.m.jordan@oracle.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908080151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908080151
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Exercising CPU hotplug on a 5.2 kernel with recent padata fixes from
cryptodev-2.6.git in an 8-CPU kvm guest...

    # modprobe tcrypt alg="pcrypt(rfc4106(gcm(aes)))" type=3
    # echo 0 > /sys/devices/system/cpu/cpu1/online
    # echo c > /sys/kernel/pcrypt/pencrypt/parallel_cpumask
    # modprobe tcrypt mode=215

...caused the following crash:

    BUG: kernel NULL pointer dereference, address: 0000000000000000
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    PGD 0 P4D 0
    Oops: 0000 [#1] SMP PTI
    CPU: 2 PID: 134 Comm: kworker/2:2 Not tainted 5.2.0-padata-base+ #7
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-<snip>
    Workqueue: pencrypt padata_parallel_worker
    RIP: 0010:padata_reorder+0xcb/0x180
    ...
    Call Trace:
     padata_do_serial+0x57/0x60
     pcrypt_aead_enc+0x3a/0x50 [pcrypt]
     padata_parallel_worker+0x9b/0xe0
     process_one_work+0x1b5/0x3f0
     worker_thread+0x4a/0x3c0
     ...

In padata_alloc_pd, pd->cpu is set using the user-supplied cpumask
instead of the effective cpumask, and in this case cpumask_first picked
an offline CPU.

The offline CPU's reorder->list.next is NULL in padata_reorder because
the list wasn't initialized in padata_init_pqueues, which only operates
on CPUs in the effective mask.

Fix by using the effective mask in padata_alloc_pd.

Fixes: 726e431130f3 ("padata: Replace delayed timer with immediate workqueue in padata_reorder")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---

Hi, not sure what the normal process is for fixing patches in cryptodev
that haven't reached mainline yet.  Feel free to fold this in with the
Fixes patch if preferred.

Thanks,
Daniel

 kernel/padata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 7372fb45eeeb..b60cc3dcee58 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -426,7 +426,7 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 	atomic_set(&pd->refcnt, 0);
 	pd->pinst = pinst;
 	spin_lock_init(&pd->lock);
-	pd->cpu = cpumask_first(pcpumask);
+	pd->cpu = cpumask_first(pd->cpumask.pcpu);
 	INIT_WORK(&pd->reorder_work, invoke_padata_reorder);
 
 	return pd;
-- 
2.22.0

