Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E970C77B75
	for <linux-crypto@archiver.kernel.org>; Tue, 16 May 2023 12:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbjEPMH3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 May 2023 08:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbjEPMH2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 May 2023 08:07:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5C63A87;
        Tue, 16 May 2023 05:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nFSjVGlQ0NaiRcQejVvCxxu5us/QrO5JhwIcwtv8Br8=; b=AHguV97S1IjUyMBo14THbXFyfE
        FaD9/bZSH59kp+oTFIRX8k4AETTYAcaxXVqPS2DNtlRsChUFZN3OOWxTKNFXpx0wkgyXH3rWTOcop
        NOef6ehjBdUhbZuLVIYxfhW3NoeOpFbru+KduR310kwFqmBszNKGWUaOSNTbW619lq2I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pytSY-00D0qm-0v; Tue, 16 May 2023 14:07:18 +0200
Date:   Tue, 16 May 2023 14:07:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     FUJITA Tomonori <tomo@exabit.dev>
Cc:     rust-for-linux@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, fujita.tomonori@gmail.com
Subject: Re: [PATCH 2/2] rust: add socket support
Message-ID: <01b36031-944b-4bf3-b089-f90bb421457c@lunn.ch>
References: <20230515043353.2324288-1-tomo@exabit.dev>
 <010101881db03866-754b644c-682c-44be-8d8e-8376d34c77b3-000000@us-west-2.amazonses.com>
 <f22b24f8-f599-4eec-9535-bcca71138057@lunn.ch>
 <010101882315a489-908f5965-2e67-497f-97f8-5c91bc928673-000000@us-west-2.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <010101882315a489-908f5965-2e67-497f-97f8-5c91bc928673-000000@us-west-2.amazonses.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 16, 2023 at 05:43:21AM +0000, FUJITA Tomonori wrote:
> On Mon, 15 May 2023 16:14:56 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > On Mon, May 15, 2023 at 04:34:28AM +0000, FUJITA Tomonori wrote:
> >> From: FUJITA Tomonori <fujita.tomonori@gmail.com>
> >> 
> >> minimum abstraction for networking.
> > 
> >> Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
> >> ---
> >>  rust/bindings/bindings_helper.h |   3 +
> >>  rust/kernel/lib.rs              |   2 +
> >>  rust/kernel/net.rs              | 174 ++++++++++++++++++++++++++++++++
> > 
> > The full networking API is huge. So trying to put it all into net.rs
> > is unlikely to work in the long run. Maybe it would be better to name
> > this file based on the tiny little bit of the network API you are
> > writing an abstraction for?
> 
> Yeah, in the long run. I tried the simplest but if the maintainers
> prefer that approach as the first step, I'll update the patch. how
> about rust/net/socket.rs ?

That is better. But probably Eric or one of the other core maintainers
should comment. I also put kern into the name to try to make it clear
that this is not the BSD Socket kAPI, but the kernel internal API for
sockets. I don't know how important this distinction is.

	 Andrew
