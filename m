From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v3] siphash: add cryptographically secure hashtable
 function
Date: Mon, 12 Dec 2016 15:01:00 -0800
Message-ID: <20161212230100.GN8388@tassilo.jf.intel.com>
References: <CA+55aFymjmEPNx8ZwhxtiE=nPG_5gbkzUQhdRAwTareuNcV=tA@mail.gmail.com>
 <20161212221832.10653-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "kernel-hardening@lists.openwall.com"
        <kernel-hardening@lists.openwall.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        George Spelvin <linux@horizon.com>,
        Scott Bauer <sbauer@eng.utah.edu>,
        Andy Lutomirski <luto@amacapital.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Eric Biggers <ebiggers3@gmail.com>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        "Daniel J . Bernstein" <djb@cr.yp.to>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:1567 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752189AbcLLXBB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Dec 2016 18:01:01 -0500
Content-Disposition: inline
In-Reply-To: <20161212221832.10653-1-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Dozens of languages are already using this internally for their hash
> tables. Some of the BSDs already use this in their kernels. SipHash is
> a widely known high-speed solution to a widely known problem, and it's
> time we catch-up.

It would be nice if the network code could be converted to use siphash
for the secure sequence numbers. Right now it pulls in a lot of code
for bigger secure hashes just for that, which is a problem for tiny
kernels.

-Andi
