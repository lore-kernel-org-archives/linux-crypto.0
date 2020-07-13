Return-Path: <SRS0=38jD=AY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0BE0C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 16:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB13620791
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 16:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594656099;
	bh=SLSKg5ZfVBRZN+zy60+65Wjoc+mClok5dX9AYhdHw9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=U0iooIwXYSgBsr/jJMJfcpOxbYX6jUX3llsRZtjMTZhm4PBSpTjydtx6Ouy/23Go4
	 JYaTLsmquyAH4ZzEYFc9/Ek7djCZtME/DzEJXF+jqBeluC9Sl0qah4kavbM5lXQUlV
	 fMX7ELQJ5ep9E34fXGWxqGNS/MK5Y8psdXMbjBxk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbgGMQBj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jul 2020 12:01:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729840AbgGMQBj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jul 2020 12:01:39 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D2A82067D;
        Mon, 13 Jul 2020 16:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594656098;
        bh=SLSKg5ZfVBRZN+zy60+65Wjoc+mClok5dX9AYhdHw9c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qUytuWDAPIVdL91cVJjojykh+ANO48gVRWXBsjWWpsZmxsJhLEDaf/Q8Nb4s1teVv
         41okgjEgcAFisu1OoXG7L6OfXNnm6Yz2d8Ir0G9m2vwIIuenNQJKn2J5x/V1m0btAq
         DWlR5ec2xZQXrRUBD4Sl8rHW1xakQeuDqy27B6WE=
Date:   Mon, 13 Jul 2020 09:01:36 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [PATCH 5/6] crypto: set the flag CRYPTO_ALG_ALLOCATES_MEMORY
Message-ID: <20200713160136.GA1696@sol.localdomain>
References: <20200701045217.121126-1-ebiggers@kernel.org>
 <20200701045217.121126-6-ebiggers@kernel.org>
 <3f2d3409-2739-b121-0469-b14c86110b2d@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3f2d3409-2739-b121-0469-b14c86110b2d@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 13, 2020 at 06:49:00PM +0300, Horia Geantă wrote:
> On 7/1/2020 7:52 AM, Eric Biggers wrote:
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > Set the flag CRYPTO_ALG_ALLOCATES_MEMORY in the crypto drivers that
> > allocate memory.
> > 
> Quite a few drivers are impacted.
> 
> I wonder what's the proper way to address the memory allocation.
> 
> Herbert mentioned setting up reqsize:
> https://lore.kernel.org/linux-crypto/20200610010450.GA6449@gondor.apana.org.au/
> 
> I see at least two hurdles in converting the drivers to using reqsize:
> 
> 1. Some drivers allocate the memory using GFP_DMA
> 
> reqsize does not allow drivers to control gfp allocation flags.
> 
> I've tried converting talitos driver (to use reqsize) at some point,
> and in the process adding a generic CRYPTO_TFM_REQ_DMA flag:
> https://lore.kernel.org/linux-crypto/54FD8D3B.5040409@freescale.com
> https://lore.kernel.org/linux-crypto/1426266882-31626-1-git-send-email-horia.geanta@freescale.com
> 
> The flag was supposed to be transparent for the user,
> however there were users that open-coded the request allocation,
> for example esp_alloc_tmp() in net/ipv4/esp4.c.
> At that time, Dave NACK-ed the change:
> https://lore.kernel.org/linux-crypto/1426266922-31679-1-git-send-email-horia.geanta@freescale.com
> 
> 
> 2. Memory requirements cannot be determined / are not known
> at request allocation time
> 
> An analysis for talitos driver is here:
> https://lore.kernel.org/linux-crypto/54F8235B.5080301@freescale.com
> 
> In general, drivers would be forced to ask more memory than needed,
> to handle the "worst-case".
> Logic will be needed to fail in case the "worst-case" isn't correctly estimated.
> 
> However, this is still problematic.
> 
> For example, a driver could set up reqsize to accommodate for 32 S/G entries
> (in the HW S/G table). In case a dm-crypt encryption request would require more,
> then driver's .encrypt callback would fail, possibly with -ENOMEM,
> since there's not enough pre-allocated memory.
> This brings us back to the same problem we're trying to solve,
> since in this case the driver would be forced to either fail immediately or
> to allocate memory at .encrypt/.decrypt time.
> 

We have to place restrictions on what cases
!(flags & CRYPTO_ALG_ALLOCATES_MEMORY) applies to anyway; see the patch that
introduces it.  If needed we could add more restrictions, like limit the number
of scatterlist elements.  If we did that, the driver could allocate memory if
the number of scatterlist elements is large, without having to set
CRYPTO_ALG_ALLOCATES_MEMORY.

Also, have you considered using a mempool?  A mempool allows allocations without
a possibility of failure, at the cost of pre-allocations.

- Eric
