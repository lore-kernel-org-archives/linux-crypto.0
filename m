From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] keys/encrypted: Fix two crypto-on-the-stack bugs
Date: Wed, 14 Dec 2016 17:58:56 +0100
Message-ID: <20161214165856.GD17255@8bytes.org>
References: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
 <e958f214e8885968be8045ffde813ac339b81178.1481575835.git.luto@kernel.org>
 <063D6719AE5E284EB5DD2968C1650D6DB023CA99@AcuExch.aculab.com>
 <CALCETrWsTKq0NOpwiJtB50OU7w99-m82NhPG_Uxs2Fqbpz0LLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Laight <David.Laight@aculab.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        Eric Biggers <ebiggers3@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 8bytes.org ([81.169.241.247]:44566 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753645AbcLNQ7J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Dec 2016 11:59:09 -0500
Content-Disposition: inline
In-Reply-To: <CALCETrWsTKq0NOpwiJtB50OU7w99-m82NhPG_Uxs2Fqbpz0LLA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 13, 2016 at 08:40:00AM -0800, Andy Lutomirski wrote:
> But I think this is rather silly.  Joerg, Linus, etc: would it be okay
> to change lib/dma-debug.c to allow DMA *from* rodata?

Yeah, this would be fine for DMA_TO_DEVICE mappings. At least I can't
think of a reason right now to not allow it, in the end its also
read-only memory for the CPU, so it can be readable by devices too.
There is no danger of race conditions like on stacks or data leaks, as
there is only compile-time data in rodata.



	Joerg
