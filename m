From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v4 11/13] net/route: use get_random_int for random counter
Date: Wed, 7 Jun 2017 23:01:54 -0400
Message-ID: <20170608030154.mwniddfm6hke773t@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com>
 <20170606174804.31124-12-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Eric Biggers <ebiggers3@gmail.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58152 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751203AbdFHDB5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Jun 2017 23:01:57 -0400
Content-Disposition: inline
In-Reply-To: <20170606174804.31124-12-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 06, 2017 at 07:48:02PM +0200, Jason A. Donenfeld wrote:
> Using get_random_int here is faster, more fitting of the use case, and
> just as cryptographically secure. It also has the benefit of providing
> better randomness at early boot, which is when many of these structures
> are assigned.
> 
> Also, semantically, it's not really proper to have been assigning an
> atomic_t in this way before, even if in practice it works fine.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: David Miller <davem@davemloft.net>

Applied to the dev branch of the random.git branch, thanks.

	       	   	     	 	    - Ted
