Return-Path: <SRS0=6z3H=UD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08620C282CE
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jun 2019 06:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D838F24BAE
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jun 2019 06:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfFDGpe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Jun 2019 02:45:34 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:51674 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbfFDGpe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jun 2019 02:45:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3795C201D6;
        Tue,  4 Jun 2019 08:45:32 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TGvq5BVqSfeq; Tue,  4 Jun 2019 08:45:31 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 7601920068;
        Tue,  4 Jun 2019 08:45:31 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 4 Jun 2019
 08:45:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 5885A3180550;
 Tue,  4 Jun 2019 08:45:30 +0200 (CEST)
Date:   Tue, 4 Jun 2019 08:45:30 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
CC:     <peterz@infradead.org>, <akpm@linux-foundation.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Question about padata's callback cpu
Message-ID: <20190604064530.GP17989@gauss3.secunet.de>
References: <20190528233707.gc4xomnlcuiszqht@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190528233707.gc4xomnlcuiszqht@ca-dmjordan1.us.oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Daniel,

On Tue, May 28, 2019 at 07:37:07PM -0400, Daniel Jordan wrote:
> Hi Steffen,
> 
> I'm working on some padata patches and stumbled across this thread about the
> purpose of the callback CPU in padata_do_parallel.
> 
>     https://lore.kernel.org/lkml/20100402112326.GA19502@secunet.com/

Well, that's quite long ago :)

> 
> The relevant part is,
> 
>   andrew> - Why would I want to specify which CPU the parallel completion
>   andrew>   callback is to be executed on?
>   
>     steffen> Well, for IPsec for example it is quite interesting to separate the
>     steffen> different flows to different cpus. pcrypt does this by choosing different
>     steffen> callback cpus for the requests belonging to different transforms.
>     steffen> Others might want to see the object on the same cpu as it was before
>     steffen> the parallel codepath.
> 
> Not too familiar with IPsec, but I'm guessing it's interesting to separate the
> flows for performance reasons.  Is the goal to keep multiple flows from
> interfering with each other (ensuring they run on different CPUs), or maybe to
> get better locality (ensuring each always runs on the same CPU)?  It'd be
> helpful if you could expand on this.

Yes, separating flows is for performance reasons. In networking, the packet
order inside a flow is very important. If network packets get reordered,
performance will drop down. So packets of the same flow should always
stay on the same cpu, otherwise you can't ensure the packet order. But to
process the network packets as parallel as possible, you can move different
flows to different cpus by choosing a callback cpu for each flow.

> By the way, the padata patches extend the code to parallelize more places
> around the kernel, as Peter suggested.

That's great, go ahead!

