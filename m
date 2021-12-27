Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3A2C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Dec 2021 05:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbhL0Fwz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Dec 2021 00:52:55 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58610 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230061AbhL0Fwz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Dec 2021 00:52:55 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n1iwH-0005IL-Dw; Mon, 27 Dec 2021 16:52:54 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Dec 2021 16:52:53 +1100
Date:   Mon, 27 Dec 2021 16:52:53 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Petr Vorel <pvorel@suse.cz>, linux-crypto@vger.kernel.org,
        Cyril Hrubis <chrubis@suse.cz>
Subject: Re: ELIBBAD vs. ENOENT for ciphers not allowed by FIPS
Message-ID: <YclUtekRBeENk/UZ@gondor.apana.org.au>
References: <YcN4S7NIV9F0XXPP@pevik>
 <YcOh6jij1s6KA2ee@gondor.apana.org.au>
 <YcOlw1UJizlngAEG@quark>
 <YcOnRRRYbV/MrRhO@gondor.apana.org.au>
 <YcOqoGOLfNTZh/ZF@quark>
 <YcQxeW/hzS7cCUCs@pevik>
 <YcSQ/hhu9Lwr4OSC@quark>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcSQ/hhu9Lwr4OSC@quark>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 23, 2021 at 09:08:46AM -0600, Eric Biggers wrote:
> Being able to distinguish between those reasons doesn't seem to be important,
> whereas being able to distinguish between a self-test failure and an algorithm
> being disabled is important.

ELIBBAD isn't equivalent to a self-test failure at all.  ELIBBAD
means that every implementation of an algorithm that the kernel
could find has failed the self-test.

If one implementation fails the self-test while other implementations
(such as the generic one) of the same algorithm still exist, the
kernel would never return ELIBBAD.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
