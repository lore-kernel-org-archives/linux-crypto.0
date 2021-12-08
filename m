Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B5A2C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Dec 2021 05:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbhLHFcn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Dec 2021 00:32:43 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58526 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbhLHFcm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Dec 2021 00:32:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 74B99CE1FCB
        for <linux-crypto@vger.kernel.org>; Wed,  8 Dec 2021 05:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72858C00446;
        Wed,  8 Dec 2021 05:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638941348;
        bh=iqOglEXzqfkSh9wjA/f7igPh12suSIwPKMKixlRueKo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bog41QveoDmAFaa/5GqXOBvQkpaTOmlfsExYjOekzXCeLTijB+uSytVaS/y0KjnbY
         GVfXdwjePv4CTuz3nHu3X7WxlpSqrJd/WQeHa7WQ0DWPcIpice4PlHZwLPsqaHwbqu
         pi8IolEgpfj0IQ4YbT7AqsPqLcfmahNBE9oyLpRtnaxtUuxUsP5IfTOh+ik8CYliLW
         Ub2si8ITocgo9ChPNuHLeq8e24yyYa8HMj/FV74ClC8sJc2vDhzrEV2s6WJc7zheV8
         0krwbvdLEW4AvpVLf7BVoJ916j8aXMa8ddjQbB7KBG3/TwDC2CfjVK5HrUcUXe5rnu
         C9MOgIg4l3kjg==
Date:   Tue, 7 Dec 2021 21:29:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: x86 AES crypto alignment
Message-ID: <20211207212907.6e91821b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211208044037.GA11399@gondor.apana.org.au>
References: <20211207113252.162701ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211208044037.GA11399@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 8 Dec 2021 15:40:37 +1100 Herbert Xu wrote:
> On Tue, Dec 07, 2021 at 11:32:52AM -0800, Jakub Kicinski wrote:
> > Hi!
> > 
> > The x86 AES crypto (gcm(aes)) requires 16B alignment which is hard to
> > achieve in networking. Is there any reason for this? On any moderately 
> > recent Intel platform aligned and unaligned vmovdq should have the same
> > performance (reportedly).  
> 
> There is no such thing as an alignment requirement.  If an algorithm
> specifies an alignment and you pass it a request which is unaligned,
> the Crypto API will automatically align the data for you.
> 
> So what is the actual problem here?

By align you mean copy right? I'm trying to avoid the copy.
