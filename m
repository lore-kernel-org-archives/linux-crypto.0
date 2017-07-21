From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Poor RNG performance on Ryzen
Date: Fri, 21 Jul 2017 10:47:42 -0400
Message-ID: <20170721144741.4igkvsd2fowptsy2@thunk.org>
References: <1218e9b7-4eeb-d8a0-02b2-8ddd672ec454@gmail.com>
 <20170721092656.GA18604@wintermute>
 <09c9be2b-8b4d-ee06-8071-4f748fdb5970@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Oliver Mangold <o.mangold@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48538 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932127AbdGUOro (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 10:47:44 -0400
Content-Disposition: inline
In-Reply-To: <09c9be2b-8b4d-ee06-8071-4f748fdb5970@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 21, 2017 at 01:39:13PM +0200, Oliver Mangold wrote:
> Better, but obviously there is still much room for improvement by reducing
> the number of calls to RDRAND.

Hmm, is there some way we can easily tell we are running on Ryzen?  Or
do we believe this is going to be true for all AMD devices?

I guess we could add some kind of "has_crappy_arch_get_random()" call
which could be defined by arch/x86, and change how aggressively we use
arch_get_random_*() depending on whether has_crappy_arch_get_random()
returns true or not....

						- Ted
