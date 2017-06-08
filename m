From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [kernel-hardening] [PATCH v4 05/13] crypto/rng: ensure that the
 RNG is ready before using
Date: Wed, 7 Jun 2017 20:41:34 -0400
Message-ID: <20170608004134.hveeuvojoc2edgjm@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com>
 <20170606174804.31124-6-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Eric Biggers <ebiggers3@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57570 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751049AbdFHAlj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Jun 2017 20:41:39 -0400
Content-Disposition: inline
In-Reply-To: <20170606174804.31124-6-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 06, 2017 at 07:47:56PM +0200, Jason A. Donenfeld wrote:
> Otherwise, we might be seeding the RNG using bad randomness, which is
> dangerous. The one use of this function from within the kernel -- not
> from userspace -- is being removed (keys/big_key), so that call site
> isn't relevant in assessing this.

The use in keys/big_key is _being_ removed, so this commit is
dependent on that commit landing, correct?  (Order matters, because
otherwise we don't want to potentially screw up doing a kernel bisect
and causing their kernel to deadlock during the boot while they are
trying to track down an unreleated problem.)

       	  	     		   - Ted
