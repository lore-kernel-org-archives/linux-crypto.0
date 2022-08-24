Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B5C6C00140
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Aug 2022 17:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240308AbiHXR4L (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Aug 2022 13:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239736AbiHXRzu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Aug 2022 13:55:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB87219030;
        Wed, 24 Aug 2022 10:55:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35FC161634;
        Wed, 24 Aug 2022 17:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D2DC433C1;
        Wed, 24 Aug 2022 17:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661363748;
        bh=VmiW4sXUJt6tiJbrffJcavkP+6lH+jowV8hE7PB2wDw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S8QQKT15RqfGR4LpE1sIYwWPmynsCkAqvXLjqiEMaGcCGicmnPfaDTzbdeUJyKwoK
         huwlzkB4RwvBSlhvgwHI/j7LCGg11Xe3lXxA3etw4sYcdCjkTXYrOEmYa07sCO037E
         3Wp5ZWELQSNea3TmwwsCKqHmZDpi633bwVAXUdIUpNxyr2TKRmS0mgxcslE8GVsl/F
         URcjcWJUVxTIenbGj8765ou71Wpzr2ZB/+Ilg5eFGBONU9IPfO0EVOAI5c8eUer2Nz
         zmNkFnsaSCKyMhWVVxKzsCvR6tPpewmpy8TMddo1fHmCG/3Grpa1ZozxTPCghylxxB
         fctVqJBERaGSA==
Date:   Wed, 24 Aug 2022 10:55:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Leonard Crestez <cdleonard@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH 00/31] net/tcp: Add TCP-AO support
Message-ID: <20220824105547.49d5bad2@kernel.org>
In-Reply-To: <YwYdqEFQuQjXxATb@lunn.ch>
References: <20220818170005.747015-1-dima@arista.com>
        <fc05893d-7733-1426-3b12-7ba60ef2698f@gmail.com>
        <a83e24c9-ab25-6ca0-8b81-268f92791ae5@kernel.org>
        <8097c38e-e88e-66ad-74d3-2f4a9e3734f4@arista.com>
        <7ad5a9be-4ee9-bab2-4a70-b0f661f91beb@gmail.com>
        <YwYdqEFQuQjXxATb@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 24 Aug 2022 14:46:32 +0200 Andrew Lunn wrote:
> > I think it would make sense to push key validity times and the key selection
> > policy entirely in the kernel so that it can handle key rotation/expiration
> > by itself. This way userspace only has to configure the keys and doesn't
> > have to touch established connections at all.  
> 
> I know nothing aobut TCP-AO, nor much about kTLS. But doesn't kTLS
> have the same issue? Is there anything which can be learnt from kTLS?
> Maybe the same mechanisms can be used? No point inventing something
> new if you can copy/refactor working code?

kTLS does not support key rotation FWIW. It's extremely rare.

> > My series has a "flags" field on the key struct where it can filter by IP,
> > prefix, ifindex and so on. It would be possible to add additional flags for
> > making the key only valid between certain times (by wall time).  
> 
> What out for wall clock time, it jumps around in funny ways. Plus the
> kernel has no idea what time zone the wall the wall clock is mounted
> on is in.

I'd do all of this over netlink, next-gen crypto on sockets is *the*
reason I started the YAML work. Sadly my crypto config via netlink
does not exist yet and is probably 2mo out ;(
