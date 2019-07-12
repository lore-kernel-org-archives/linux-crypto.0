Return-Path: <SRS0=HUI/=VJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3253C742B3
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jul 2019 10:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 805922084B
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jul 2019 10:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfGLKKO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Jul 2019 06:10:14 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:33376 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfGLKKO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jul 2019 06:10:14 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 719BD20253;
        Fri, 12 Jul 2019 12:10:13 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id M5Ju-BORThWe; Fri, 12 Jul 2019 12:10:13 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 10A11201C1;
        Fri, 12 Jul 2019 12:10:13 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 12 Jul 2019
 12:10:12 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 9ECB0318050B;
 Fri, 12 Jul 2019 12:10:12 +0200 (CEST)
Date:   Fri, 12 Jul 2019 12:10:12 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        <andrea.parri@amarulasolutions.com>, <boqun.feng@gmail.com>,
        <paulmck@linux.ibm.com>, <peterz@infradead.org>,
        <linux-arch@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] padata: use smp_mb in padata_reorder to avoid orphaned
 padata jobs
Message-ID: <20190712101012.GW14601@gauss3.secunet.de>
References: <20190711221205.29889-1-daniel.m.jordan@oracle.com>
 <20190712100636.mqdr567p7ozanlyl@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190712100636.mqdr567p7ozanlyl@gondor.apana.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 12, 2019 at 06:06:36PM +0800, Herbert Xu wrote:
> Daniel Jordan <daniel.m.jordan@oracle.com> wrote:
> >
> > CPU0                                 CPU1
> > 
> > padata_reorder                       padata_do_serial
> >  LOAD reorder_objects  // 0
> >                                       INC reorder_objects  // 1
> >                                       padata_reorder
> >                                         TRYLOCK pd->lock   // failed
> >  UNLOCK pd->lock
> 
> I think this can't happen because CPU1 won't call padata_reorder
> at all as it's the wrong CPU so it gets pushed back onto a work
> queue which will go back to CPU0.
> 
> Steffen, could you please take a look at this as there clearly
> is a problem here?

I'm currently travelling, will have a look at it when I'm back.
