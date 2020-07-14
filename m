Return-Path: <SRS0=vKog=AZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75607C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 13:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45CCC2065D
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 13:38:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D/0uyKNX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbgGNNi5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jul 2020 09:38:57 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53052 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725906AbgGNNi5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jul 2020 09:38:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594733936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VIsTGGfWg9oC5ywv2DfaNcAwBqGoW6BaimgT2CXKK5Q=;
        b=D/0uyKNXkT3uu1sIb+i37FrOsGaR9fMROgM8RzNO/vC9fiw/CQf/6XN7STECwSafTP+u6p
        LoFabEPKAda9I6SmlXOG3PAqAiyZ5fGlitq7hodJNZglcbqQK8hXfVHfLtOQcILd5dlOKR
        M+gnG8gG3IPeNa9rUQDzG1sGseVh8gY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-Ir1g84BzNpO0aWzp0JOrqQ-1; Tue, 14 Jul 2020 09:38:54 -0400
X-MC-Unique: Ir1g84BzNpO0aWzp0JOrqQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDD931080;
        Tue, 14 Jul 2020 13:38:50 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A926C710C8;
        Tue, 14 Jul 2020 13:38:47 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 06EDclcC017184;
        Tue, 14 Jul 2020 09:38:47 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 06EDciQQ017180;
        Tue, 14 Jul 2020 09:38:44 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 14 Jul 2020 09:38:44 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     =?ISO-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
cc:     Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [PATCH 5/6] crypto: set the flag CRYPTO_ALG_ALLOCATES_MEMORY
In-Reply-To: <780cb500-2241-61bc-eb44-6f872ad567d3@nxp.com>
Message-ID: <alpine.LRH.2.02.2007140937260.17016@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200701045217.121126-1-ebiggers@kernel.org> <20200701045217.121126-6-ebiggers@kernel.org> <3f2d3409-2739-b121-0469-b14c86110b2d@nxp.com> <20200713160136.GA1696@sol.localdomain> <780cb500-2241-61bc-eb44-6f872ad567d3@nxp.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="185206533-1492832032-1594733927=:17016"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185206533-1492832032-1594733927=:17016
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT



On Mon, 13 Jul 2020, Horia Geantă wrote:

> On 7/13/2020 7:01 PM, Eric Biggers wrote:
> > On Mon, Jul 13, 2020 at 06:49:00PM +0300, Horia Geantă wrote:
> >> On 7/1/2020 7:52 AM, Eric Biggers wrote:
> >>> From: Mikulas Patocka <mpatocka@redhat.com>
> >>>
> >>> Set the flag CRYPTO_ALG_ALLOCATES_MEMORY in the crypto drivers that
> >>> allocate memory.
> >>>
> >> Quite a few drivers are impacted.
> >>
> >> I wonder what's the proper way to address the memory allocation.
> >>
> >> Herbert mentioned setting up reqsize:
> >> https://lore.kernel.org/linux-crypto/20200610010450.GA6449@gondor.apana.org.au/
> >>
> >> I see at least two hurdles in converting the drivers to using reqsize:
> >>
> >> 1. Some drivers allocate the memory using GFP_DMA
> >>
> >> reqsize does not allow drivers to control gfp allocation flags.
> >>
> >> I've tried converting talitos driver (to use reqsize) at some point,
> >> and in the process adding a generic CRYPTO_TFM_REQ_DMA flag:
> >> https://lore.kernel.org/linux-crypto/54FD8D3B.5040409@freescale.com
> >> https://lore.kernel.org/linux-crypto/1426266882-31626-1-git-send-email-horia.geanta@freescale.com
> >>
> >> The flag was supposed to be transparent for the user,
> >> however there were users that open-coded the request allocation,
> >> for example esp_alloc_tmp() in net/ipv4/esp4.c.
> >> At that time, Dave NACK-ed the change:
> >> https://lore.kernel.org/linux-crypto/1426266922-31679-1-git-send-email-horia.geanta@freescale.com
> >>
> >>
> >> 2. Memory requirements cannot be determined / are not known
> >> at request allocation time
> >>
> >> An analysis for talitos driver is here:
> >> https://lore.kernel.org/linux-crypto/54F8235B.5080301@freescale.com
> >>
> >> In general, drivers would be forced to ask more memory than needed,
> >> to handle the "worst-case".
> >> Logic will be needed to fail in case the "worst-case" isn't correctly estimated.
> >>
> >> However, this is still problematic.
> >>
> >> For example, a driver could set up reqsize to accommodate for 32 S/G entries
> >> (in the HW S/G table). In case a dm-crypt encryption request would require more,
> >> then driver's .encrypt callback would fail, possibly with -ENOMEM,
> >> since there's not enough pre-allocated memory.
> >> This brings us back to the same problem we're trying to solve,
> >> since in this case the driver would be forced to either fail immediately or
> >> to allocate memory at .encrypt/.decrypt time.
> >>
> > 
> > We have to place restrictions on what cases
> > !(flags & CRYPTO_ALG_ALLOCATES_MEMORY) applies to anyway; see the patch that
> > introduces it.  If needed we could add more restrictions, like limit the number
> > of scatterlist elements.  If we did that, the driver could allocate memory if
> > the number of scatterlist elements is large, without having to set
> > CRYPTO_ALG_ALLOCATES_MEMORY.
> > 
> This sounds reasonable.
> 
> > Also, have you considered using a mempool?  A mempool allows allocations without
> > a possibility of failure, at the cost of pre-allocations.
> > 
> Thanks for the suggestion.
> 
> Would this be safe for all cases, e.g. IPsec - where .encrypt/.decrypt callbacks
> execute in (soft)IRQ context?
> kernel-doc for mempool_alloc() mentions it could fail when called from
> "IRQ context". 

In IPsec, you can drop packets (and TCP will retransmit them), so there is 
no problem with memory allocation failures.

> Thanks,
> Horia

Mikulas
--185206533-1492832032-1594733927=:17016--

