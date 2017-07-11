From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cavium/nitrox - Remove default m setting from
 Kconfig
Date: Tue, 11 Jul 2017 10:14:55 +0800
Message-ID: <20170711021454.GA17383@gondor.apana.org.au>
References: <20170710101532.GA15004@gondor.apana.org.au>
 <CA+55aFx1_-FD=cTvcNUP5JNzY6AQY6HcdNAKJ5fa7dLutvFjCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:35762 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754927AbdGKCPV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jul 2017 22:15:21 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFx1_-FD=cTvcNUP5JNzY6AQY6HcdNAKJ5fa7dLutvFjCg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 10, 2017 at 11:51:42AM -0700, Linus Torvalds wrote:
> Heh, I already did this in commit b4b8cbf679c4.
> 
> I complained because I want maintainers to be aware of this issue -
> adding Kconfig options with defaults that don't make sense should be
> caught earlier than when I do a test built..

OK, I will be more vigilant next time.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
