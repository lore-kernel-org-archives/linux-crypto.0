Return-Path: <SRS0=f4o8=VO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C0DC76192
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 08:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E44D20818
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 08:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfGQI2S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jul 2019 04:28:18 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:33830 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfGQI2R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jul 2019 04:28:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 117BC201E3;
        Wed, 17 Jul 2019 10:28:16 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id u9EW9tYmRCwt; Wed, 17 Jul 2019 10:28:15 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A869F2008D;
        Wed, 17 Jul 2019 10:28:15 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 17 Jul 2019
 10:28:15 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 459AE318055E;
 Wed, 17 Jul 2019 10:28:15 +0200 (CEST)
Date:   Wed, 17 Jul 2019 10:28:15 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        <andrea.parri@amarulasolutions.com>, <boqun.feng@gmail.com>,
        <paulmck@linux.ibm.com>, <peterz@infradead.org>,
        <linux-arch@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] padata: Use RCU when fetching pd from do_serial
Message-ID: <20190717082815.GP17989@gauss3.secunet.de>
References: <20190711221205.29889-1-daniel.m.jordan@oracle.com>
 <20190712100636.mqdr567p7ozanlyl@gondor.apana.org.au>
 <20190712101012.GW14601@gauss3.secunet.de>
 <20190712160737.iniaaxlsnhs6azg5@ca-dmjordan1.us.oracle.com>
 <20190713050321.c5wq7a7jrb6q2pxn@gondor.apana.org.au>
 <20190715161045.zqwgsp62uqjnvx3l@ca-dmjordan1.us.oracle.com>
 <20190716100447.pdongriwwfxsuajf@gondor.apana.org.au>
 <20190716111410.GN17989@gauss3.secunet.de>
 <20190716125704.l2jolyyd3bue6hhn@gondor.apana.org.au>
 <20190716130928.ga4acvxipsdzyzlp@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190716130928.ga4acvxipsdzyzlp@gondor.apana.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 16, 2019 at 09:09:28PM +0800, Herbert Xu wrote:
> 
> However, I think this leads to another bug in that pcrypt doesn't
> support dm-crypt properly.  It never does the backlog stuff and
> therefore can't guarantee reliable processing which dm-crypt requires.
> 
> Is it intentional to only allow pcrypt for IPsec?

I had a patch to support crypto backlog some years ago,
but testing with dm-crypt did not show any performance
improvement. So I decided to just skip that patch because
it added code for no need.
