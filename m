Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 615FBC282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 10:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E642218A2
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 10:47:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfAYKr6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 05:47:58 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:44448 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfAYKr6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 05:47:58 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gmz1Z-0005gV-SG; Fri, 25 Jan 2019 18:47:49 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gmz1W-00025X-KJ; Fri, 25 Jan 2019 18:47:46 +0800
Date:   Fri, 25 Jan 2019 18:47:46 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Ondrej Mosnacek <omosnacek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: Re: [patch 2/9] crypto: aegis - Cleanup license mess
Message-ID: <20190125104746.xetes7ryqlmhya7u@gondor.apana.org.au>
References: <20190117231416.111952141@linutronix.de>
 <20190117231500.970473486@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117231500.970473486@linutronix.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 18, 2019 at 12:14:18AM +0100, Thomas Gleixner wrote:
> Precise and non-ambiguous license information is important. The recently
> added aegis header file has a SPDX license identifier, which is nice, but
> at the same time it has a contradictionary license boiler plate text.
> 
>   SPDX-License-Identifier: GPL-2.0
> 
> versus 
> 
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms of the GNU General Public License as published by the Free
>   * Software Foundation; either version 2 of the License, or (at your option)
>   * any later version
> 
> Oh well.
> 
> As the other aegis related files are licensed under the GPL v2 or later,
> it's assumed that the boiler plate code is correct, but the SPDX license
> identifier is wrong.
> 
> Fix the SPDX identifier and remove the boiler plate as it is redundant.
> 
> Fixes: f606a88e5823 ("crypto: aegis - Add generic AEGIS AEAD implementations")
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ondrej Mosnacek <omosnacek@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> ---
> 
> P.S.: This patch is part of a larger cleanup, but independent of other
>       patches and is intended to be picked up by the maintainer directly.
> 
> ---
>  crypto/aegis.h |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)

Patches 2-5 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
