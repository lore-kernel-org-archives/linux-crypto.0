From: David Miller <davem@davemloft.net>
Subject: Re: AF_ALG broken?
Date: Mon, 08 Aug 2016 16:04:20 -0700 (PDT)
Message-ID: <20160808.160420.2284525436367147596.davem@davemloft.net>
References: <5469036.jmYhrDdAzD@positron.chronox.de>
	<5217898.dpPNhAO3PW@tauon.atsec.com>
	<20160808225851.GE1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: smueller@chronox.de, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
To: linux@armlinux.org.uk
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:35708 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbcHHXEW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 19:04:22 -0400
Received: by mail-pf0-f181.google.com with SMTP id x72so123413713pfd.2
        for <linux-crypto@vger.kernel.org>; Mon, 08 Aug 2016 16:04:22 -0700 (PDT)
In-Reply-To: <20160808225851.GE1041@n2100.armlinux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Russell King - ARM Linux <linux@armlinux.org.uk>
Date: Mon, 8 Aug 2016 23:58:51 +0100

> I don't know, but this seems to go completely against Linus' no
> userspace regressions, which seems to be an absolute requirement of
> all kernel development... Linus flames people for arguing against
> that rule!

Reading the explanation for the change given to you, it's impossible
for some hash algorithms to function properly without being given the
key first, and would crash.

Therefore the requirement is reasonable, even though it is unfortunate
that a critical piece of userspace infrastructure was coded this way.
