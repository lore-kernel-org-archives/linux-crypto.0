Return-Path: <SRS0=YR29=63=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD7CC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 13 May 2020 23:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF61420693
	for <linux-crypto@archiver.kernel.org>; Wed, 13 May 2020 23:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732713AbgEMXeQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 May 2020 19:34:16 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4839 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732705AbgEMXeQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 May 2020 19:34:16 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0D22CE1E6186BDFC7A6E;
        Thu, 14 May 2020 07:34:14 +0800 (CST)
Received: from SWX921481.china.huawei.com (10.126.202.158) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Thu, 14 May 2020 07:34:05 +0800
From:   Barry Song <song.bao.hua@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <sjenning@redhat.com>,
        <ddstreet@ieee.org>, <vitaly.wool@konsulko.com>,
        <akpm@linux-foundation.org>
CC:     <mahipalreddy2006@gmail.com>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>
Subject: [PATCH RESEND 0/1] mm/zswap: move to use crypto_acomp APIs
Date:   Thu, 14 May 2020 11:33:17 +1200
Message-ID: <20200513233318.10496-1-song.bao.hua@hisilicon.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.126.202.158]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Seth, Dan, Vitaly, Herbert, Andrew,

Using crypto_comp APIs, zswap is not able to use the hardware accelators which
are only ported to cryto_acomp nowadays. So Mahipal Challa tried to solve this
problem by the below patch a long time ago:
mm: zswap - Add crypto acomp/scomp framework support [1]

At that time, the test was based on acomp with scomp backend. It was not a real
async platform. On a platform with real acomp support like hisilicon-zip, the
patch will lead to serious "sleep on atomic" issues.

To leverage the power of hardware accelerator, right now, I am sending a new patch
which will remove the atomic context and permit crypto to sleep in zswap.

Literally, using an async compressor, people can dynamically allocate acomp_req and
multiple requests can queue in acomp drivers, and finally acomp drivers can use the
callback to notify the completion of compression/decompression. but this will require
dynamic memory allocation and various synchronizations in zswap, and it is too
complex.

Alternatively, this patch pre-allocates the acomp_req with the same number of CPUs.
For each acomp_req, one mutex and one wait are bound with it. The mutex is used
for the race protection of the acomp_req and other percpu resources. Even though
the preempt-disabled atomic context is replaced by sleepable context, threads
might migrate, but the mutex can still protect the race between CPUs for same
resources.

Tested on hisilicon zip driver on a SMP enviorment and on lz4 scomp-based acomp
as well. To use scomp-based acomp, another patch I sent before is needed:
crypto: acomp - search acomp with scomp backend in crypto_has_acomp [2]

[1] https://www.spinics.net/lists/linux-mm/msg122455.html
[2] https://marc.info/?l=linux-crypto-vger&m=158822346227760&w=2

Barry Song (1):
  mm/zswap: move to use crypto_acomp API for hardware acceleration

 mm/zswap.c | 150 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 108 insertions(+), 42 deletions(-)

-- 
2.23.0


