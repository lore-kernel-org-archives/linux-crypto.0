Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFAD4C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Dec 2021 23:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhLTXDr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Dec 2021 18:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbhLTXDq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Dec 2021 18:03:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E3AC061574
        for <linux-crypto@vger.kernel.org>; Mon, 20 Dec 2021 15:03:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D653661307
        for <linux-crypto@vger.kernel.org>; Mon, 20 Dec 2021 23:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CF8C36AE5;
        Mon, 20 Dec 2021 23:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640041425;
        bh=ndFkGBmlGSLOFm8EMoS2iRZs68aMch9dTDxUbDQlNNA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TUmQsM9VJNr/37XUZG+rZuZI9FKteL2Hs91zFqiHFH18AlFSFg3Ro3rOyftfE1B8B
         QJu27LcnGSsaRYwPrqpSs5w7MSm8lTeEwM78OW28hOambGaaoB0PRs89VA/ig4GEp8
         eYtVSljXpBCBTVCnjjLZXT31m3tEjEbYC7FkkCNxMolLbWxTBiujjq40XHzlLmUwHR
         dnVRbwmiEIgW/+Zvvh4WEGqHmVHoNhE9Vz9YWIiOohiZ6BrJLfvPfjCaqu2ocZX9Ks
         35/iNhuJJ4AfQIbBxLy20O6nnD5YQksTzgqsLyMpuIdd8Er6rkVFNF33po0DOxVqv3
         XtgUEay3sZieA==
Date:   Mon, 20 Dec 2021 15:03:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: x86 AES crypto alignment
Message-ID: <20211220150343.4e12a4d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211207212907.6e91821b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211207113252.162701ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211208044037.GA11399@gondor.apana.org.au>
        <20211207212907.6e91821b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 7 Dec 2021 21:29:07 -0800 Jakub Kicinski wrote:
> On Wed, 8 Dec 2021 15:40:37 +1100 Herbert Xu wrote:
> > On Tue, Dec 07, 2021 at 11:32:52AM -0800, Jakub Kicinski wrote:  
> > > Hi!
> > > 
> > > The x86 AES crypto (gcm(aes)) requires 16B alignment which is hard to
> > > achieve in networking. Is there any reason for this? On any moderately 
> > > recent Intel platform aligned and unaligned vmovdq should have the same
> > > performance (reportedly).    
> > 
> > There is no such thing as an alignment requirement.  If an algorithm
> > specifies an alignment and you pass it a request which is unaligned,
> > the Crypto API will automatically align the data for you.
> > 
> > So what is the actual problem here?  
> 
> By align you mean copy right? I'm trying to avoid the copy.

Hm, I'm benchmarking things now and it appears to be a regression
introduced somewhere around 5.11 / 5.12. I don't see the memcpy 
eating 20% of performance on 5.10. Bisection time.
