Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EBD9C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Dec 2021 00:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbhLUALa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Dec 2021 19:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbhLUALa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Dec 2021 19:11:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A0EC061574
        for <linux-crypto@vger.kernel.org>; Mon, 20 Dec 2021 16:11:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0ACD6133A
        for <linux-crypto@vger.kernel.org>; Tue, 21 Dec 2021 00:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7208C36AE5;
        Tue, 21 Dec 2021 00:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640045487;
        bh=AYl4/47VOnsJhZ/lkMkkTtHN5zj3JzFL7MvC2ROf1Uw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iW2qznbw5DzLRojDSq8VN9EDdemZaYCgjZvzRcf4nPHvGBOt0XCUyB6bDTbWgfRul
         gVnrXm3lQlo49Y9qMoHOZaZ8m7LOwp2K9JbP++Fg+suHgohvvMUyj2jI9nJ/1a6xNw
         nfAlg6wICCPh8OE5sPuNO5LQ5lpDO9UyoglvDnwFPV0/s5EDNGH9RFTwOaoYwo/2yI
         WRLR2jVC2bL/bSIuP1ErlfLQulIr59f7ak6CcKi4q4yLKottyH+zEZzdJWuVcqZfcp
         Y/F7UOB2K73jRH6dx8rKnIAT5Vm/d4HtQqyfWAEpiKt6udRq1iGxBnQkNawkTzq5h6
         LlGoKNJ3oaqUA==
Date:   Mon, 20 Dec 2021 16:11:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: x86 AES crypto alignment
Message-ID: <20211220161125.78bc4d66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211220150343.4e12a4d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211207113252.162701ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211208044037.GA11399@gondor.apana.org.au>
        <20211207212907.6e91821b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211220150343.4e12a4d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 20 Dec 2021 15:03:43 -0800 Jakub Kicinski wrote:
> On Tue, 7 Dec 2021 21:29:07 -0800 Jakub Kicinski wrote:
> > On Wed, 8 Dec 2021 15:40:37 +1100 Herbert Xu wrote:  
> > > There is no such thing as an alignment requirement.  If an algorithm
> > > specifies an alignment and you pass it a request which is unaligned,
> > > the Crypto API will automatically align the data for you.
> > > 
> > > So what is the actual problem here?    
> > 
> > By align you mean copy right? I'm trying to avoid the copy.  
> 
> Hm, I'm benchmarking things now and it appears to be a regression
> introduced somewhere around 5.11 / 5.12. I don't see the memcpy 
> eating 20% of performance on 5.10. Bisection time.

83c83e658863 ("crypto: aesni - refactor scatterlist processing")

is what introduced the regression.
