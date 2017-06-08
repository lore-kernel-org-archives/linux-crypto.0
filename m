From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v4 09/13] rhashtable: use get_random_u32 for hash_rnd
Date: Wed, 7 Jun 2017 22:47:40 -0400
Message-ID: <20170608024740.qjs2qctopbwgfnw5@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com>
 <20170606174804.31124-10-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Eric Biggers <ebiggers3@gmail.com>,
        Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58088 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751498AbdFHCrr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Jun 2017 22:47:47 -0400
Content-Disposition: inline
In-Reply-To: <20170606174804.31124-10-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 06, 2017 at 07:48:00PM +0200, Jason A. Donenfeld wrote:
> This is much faster and just as secure. It also has the added benefit of
> probably returning better randomness at early-boot on systems with
> architectural RNGs.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Thomas Graf <tgraf@suug.ch>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>

Thanks, applied to the random.git dev branch.

		       		  - Ted
