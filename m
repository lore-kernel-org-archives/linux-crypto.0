Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD6ECC3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 06:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96F18216F4
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 06:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbfHTGHa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 02:07:30 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:32990 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbfHTGHa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 02:07:30 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A1E2C201AA;
        Tue, 20 Aug 2019 08:07:28 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Gl3vgkz7Jn_K; Tue, 20 Aug 2019 08:07:27 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6A7E92019C;
        Tue, 20 Aug 2019 08:07:27 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 20 Aug 2019
 08:07:27 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 0A5BA3182813;
 Tue, 20 Aug 2019 08:07:27 +0200 (CEST)
Date:   Tue, 20 Aug 2019 08:07:27 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] padata: use unbound workqueues for parallel jobs
Message-ID: <20190820060726.GL2879@gauss3.secunet.de>
References: <20190813005224.30779-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190813005224.30779-1-daniel.m.jordan@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 12, 2019 at 08:52:15PM -0400, Daniel Jordan wrote:
> Hi,
> 
> No objections the first time around[*], so this series is no longer RFC.
> The code is the same other than being rebased on recent padata fixes.
> Any feedback or testing welcome.
> 
> Thanks,
> Daniel
> 
> RFC -> v1:
>  - Included Tejun's acks.
>  - Added testing section to cover letter.
> 
> Padata binds the parallel part of a job to a single CPU and round-robins
> over all CPUs in the system for each successive job.  Though the serial
> parts rely on per-CPU queues for correct ordering, they're not necessary
> for parallel work, and it improves performance to run the job locally on
> NUMA machines and let the scheduler pick the CPU within a node on a busy
> system.
>   
> This series makes parallel padata jobs run on unbound workqueues.

Looks good!

I did a test with IPsec pcrypt and it seems to work as expected.
Crypto load gets distributed, no network packet reordering.

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
