Return-Path: <SRS0=fgde=7X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDEA5C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jun 2020 15:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EA182070B
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jun 2020 15:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591804394;
	bh=jKyRFc09U4pc6AUdaO2U2v1JesKj0Dr9snvP7EDAh0A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=vfh5E5SefBWLisIu6qEiFMSy6gfb3PLvTr8gyu3N6jO+IBU7RF8OJrg1pPrQDtUNQ
	 7ndmjC0u69hI53hLbRrVipyGXm9tGxC0Rk6xw5tS2oenGy3TRcRq+18A54bUn8gSR8
	 lTFhLCqF/z2IPHD0C7JColRfk2DT6NqbgXVOGAGA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgFJPxO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Jun 2020 11:53:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728217AbgFJPxN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jun 2020 11:53:13 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57E37206F4;
        Wed, 10 Jun 2020 15:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591804393;
        bh=jKyRFc09U4pc6AUdaO2U2v1JesKj0Dr9snvP7EDAh0A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bdosIPAFrSzRJCwMhu1K7aaFtBFNSCDNT2zu6Kz4grWB28dgdF39lQvrWPn5dOyYb
         m6JzWoWKQorB50vbPDqgyPq31E0GWkANLhQMbvP9iNKijJA8jhYrG0GFIsVIXAdPwa
         87SarRnsucOIgiYJfTOZPuuXq8HdOJM2kkyuYFMk=
Date:   Wed, 10 Jun 2020 08:53:12 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Tobias Brunner <tobias@strongswan.org>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net v3 3/3] esp, ah: modernize the crypto algorithm
 selections
Message-ID: <20200610155312.GB1339@sol.localdomain>
References: <20200610005402.152495-1-ebiggers@kernel.org>
 <20200610005402.152495-4-ebiggers@kernel.org>
 <c87f1edb-4130-a4a9-2915-ae5d55302f0a@strongswan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c87f1edb-4130-a4a9-2915-ae5d55302f0a@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 10, 2020 at 11:03:55AM +0200, Tobias Brunner wrote:
> Hi Eric,
> 
> > +	  Note that RFC 8221 considers AH itself to be "NOT RECOMMENDED".  It is
> > +	  better to use ESP only, using an AEAD cipher such as AES-GCM.
> 
> What's NOT RECOMMENDED according to the RFC is the combination of ESP+AH
> (i.e. use ESP only for confidentiality and AH for authentication), not
> AH by itself (although the RFC keeps ENCR_NULL as a MUST because ESP
> with NULL encryption is generally preferred over AH due to NATs).
> 
> Regards,
> Tobias

Okay, I'll drop this paragraph.  I'm surprised that authentication-only is still
considered a valid use case though.

- Eric
