Return-Path: <SRS0=wawN=VN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75DE1C76188
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jul 2019 13:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AE412173B
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jul 2019 13:50:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="apjGQC4h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387524AbfGPNuf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Jul 2019 09:50:35 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45156 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbfGPNue (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jul 2019 09:50:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4QEK7Azm4CXxHXb645Kj2aMTlcOadurBJ2fe5B7TS1M=; b=apjGQC4hITTrWEdGA3ONfg2iP
        /828JlG4UXQWAPe6q3t5vInmtxm/ImNGOVeO2ciL/bHXTCCeJ3lo7PsY7/tBKn2UtrobfSixwiCtY
        kgRig9A7tfwzAxTlSkwecLEAcJR9Xy0kYhJwN/AwxaGDoTTD9TO1jtLYZgKDGjSi6VNEHRHXGOPeA
        wlIqIx04Ma33UX3iLA5MjsMbK5lhuPRBCTmaSuroDZSIwaRK2T/XM1hzHphFda9kJ2OgvcKwv/eSw
        lQDaavZxRRhg5Et/iYJrJzsYbR2BPvH0dKeeReBhTLPmIdxc8zBUqI1qSvv/RI3uot/wtEaj3PNuo
        +uLlOHQTg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hnNqO-0001Tb-K0; Tue, 16 Jul 2019 13:50:13 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6CD812059DEA3; Tue, 16 Jul 2019 15:50:10 +0200 (CEST)
Date:   Tue, 16 Jul 2019 15:50:10 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        andrea.parri@amarulasolutions.com, boqun.feng@gmail.com,
        paulmck@linux.ibm.com, linux-arch@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: Use RCU when fetching pd from do_serial
Message-ID: <20190716135010.GC3402@hirez.programming.kicks-ass.net>
References: <20190712100636.mqdr567p7ozanlyl@gondor.apana.org.au>
 <20190712101012.GW14601@gauss3.secunet.de>
 <20190712160737.iniaaxlsnhs6azg5@ca-dmjordan1.us.oracle.com>
 <20190713050321.c5wq7a7jrb6q2pxn@gondor.apana.org.au>
 <20190715161045.zqwgsp62uqjnvx3l@ca-dmjordan1.us.oracle.com>
 <20190716100447.pdongriwwfxsuajf@gondor.apana.org.au>
 <20190716111410.GN17989@gauss3.secunet.de>
 <20190716125704.l2jolyyd3bue6hhn@gondor.apana.org.au>
 <20190716131520.GB3402@hirez.programming.kicks-ass.net>
 <20190716131807.twahbbdff6jhpnu2@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716131807.twahbbdff6jhpnu2@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 16, 2019 at 09:18:07PM +0800, Herbert Xu wrote:
> On Tue, Jul 16, 2019 at 03:15:20PM +0200, Peter Zijlstra wrote:
> >
> > > @@ -367,7 +368,7 @@ void padata_do_serial(struct padata_priv *padata)
> > >  	struct parallel_data *pd;
> > >  	int reorder_via_wq = 0;
> > >  
> > > -	pd = padata->pd;
> > > +	pd = rcu_dereference_bh(padata->inst->pd);
> > >  
> > >  	cpu = get_cpu();
> > >  
> > 
> > That's weird for not having a matching assign and lacking comments to
> > explain that.
> 
> There is a matching rcu_assign_pointer.  But we should add some
> RCU markers.
> 
> Or perhaps you're misreading the level of indirections :)

Could well be, I'm not much familiar with this code; I'll look more
careful.
