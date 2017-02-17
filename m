From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: crypto: hang in crypto_larval_lookup
Date: Fri, 17 Feb 2017 18:50:27 +0100
Message-ID: <02b80c39-0fd5-b7bd-39da-07e5d71abbad@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50341 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934271AbdBQVQQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Feb 2017 16:16:16 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1HHmkiC015188
        for <linux-crypto@vger.kernel.org>; Fri, 17 Feb 2017 12:50:39 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 28nwc7wtfu-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Fri, 17 Feb 2017 12:50:38 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.vnet.ibm.com>;
        Fri, 17 Feb 2017 17:50:36 -0000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hello all

I am currently following a hang at modprobe aes_s390 where
crypto_register_alg() does not come back for the xts(aes) algorithm.

The registration is waiting forever in algapi.c crypto_wait_for_test() but
the completion never occurs. The cryptomgr is triggering a test via
kthread_run to invoce cryptomgr_probe and this thread is calling the
create() function of the xts template (file xts.c). Following this thread
it comes down to api.c crypto_larval_lookup(name="aes") which is first
requesting the module "crypto-aes" via request_module() successful and then
blocking forever in requesting the module "crypto-aes-all".

The xts(aes) has at registration CRYPTO_ALG_NEED_FALLBACK flag on.

This problem is seen since about 6 weeks now, first only on the linux next
kernel. Now it appers on the 4.10-rc kernels as well. And I still have no
idea on how this could be fixed or what's wrong with just the xts
registration (ecb, cbc, ctr work fine).

Any ideas or hints?
Thank's in advance.

regards
Harald Freudenberger
