Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25763C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jan 2022 06:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbiARGmn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jan 2022 01:42:43 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:59642 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230021AbiARGmm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jan 2022 01:42:42 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n9iCJ-0007NZ-N3; Tue, 18 Jan 2022 17:42:28 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 18 Jan 2022 17:42:28 +1100
Date:   Tue, 18 Jan 2022 17:42:28 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     geert@linux-m68k.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, wireguard@lists.zx2c4.com,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org, tytso@mit.edu,
        gregkh@linuxfoundation.org, jeanphilippe.aumasson@gmail.com,
        ardb@kernel.org
Subject: Re: [PATCH crypto v3 0/2] reduce code size from blake2s on m68k and
 other small platforms
Message-ID: <YeZhVGczxcBl0sI9@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9rxdksVZkN4DF_GabsEPrSDrKbo1cVQs77B_s-e2jZ64A@mail.gmail.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Excellent, thanks for the breakdown. So this shaves off ~4k, which was
> about what we were shooting for here, so I think indeed this series
> accomplishes its goal of counteracting the addition of BLAKE2s.
> Hopefully Herbert will apply this series for 5.17.

As the patches that triggered this weren't part of the crypto
tree, this will have to go through the random tree if you want
them for 5.17.

Otherwise if you're happy to wait then I can pull them through
cryptodev.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
