From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v3] siphash: add cryptographically secure hashtable function
Date: Tue, 13 Dec 2016 00:04:27 +0100
Message-ID: <CAHmME9qk+Z8CdhTFQnTkwT8S-n56tzi77-uAV3dNigcGMQx7uQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
To: Andi Kleen <ak@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:50109 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751845AbcLLXEd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Dec 2016 18:04:33 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 13, 2016 at 12:01 AM, Andi Kleen <ak@linux.intel.com> wrote:
> It would be nice if the network code could be converted to use siphash
> for the secure sequence numbers. Right now it pulls in a lot of code
> for bigger secure hashes just for that, which is a problem for tiny
> kernels.

Indeed this would be a great first candidate. There are lots of places
where MD5 (!!) is pulled in for this sort of thing, when SipHash could
be a faster and leaner replacement (and arguably more secure than
rusty MD5).
