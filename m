From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 3/6] crypto: AF_ALG -- add asymmetric cipher interface
Date: Tue, 14 Jun 2016 07:12:24 +0200
Message-ID: <1759070.fi90mrsgKn@positron.chronox.de>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1> <alpine.OSX.2.20.1606081135160.16651@mjmartin-mac01.local> <CAOq732J6J9b0NWuELRs7udiO7mApybfxjFaYX_UVdqHR+9Fvrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-api@vger.kernel.org, marcel@holtmann.org,
	linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>, davem@davemloft.net
To: Andrew Zaborowski <balrogg@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36420 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423853AbcFNFM2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2016 01:12:28 -0400
In-Reply-To: <CAOq732J6J9b0NWuELRs7udiO7mApybfxjFaYX_UVdqHR+9Fvrw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 14. Juni 2016, 00:16:11 schrieb Andrew Zaborowski:

Hi Andrew,

> Hi,
> 
> On 8 June 2016 at 21:14, Mat Martineau
> 
> <mathew.j.martineau@linux.intel.com> wrote:
> > On Wed, 8 Jun 2016, Stephan Mueller wrote:
> >> What is your concern?
> > 
> > Userspace must allocate larger buffers than it knows are necessary for
> > expected results.
> > 
> > It looks like the software rsa implementation handles shorter output
> > buffers ok (mpi_write_to_sgl will return EOVERFLOW if the the buffer is
> > too small), however I see at least one hardware rsa driver that requires
> > the output buffer to be the maximum size. But this inconsistency might be
> > best addressed within the software cipher or drivers rather than in
> > recvmsg.
> Should the hardware drivers fix this instead?  I've looked at the qat
> and caam drivers, they both require the destination buffer size to be
> the key size and in both cases there would be no penalty for dropping
> this requirement as far as I see.  Both do a memmove if the result
> ends up being shorter than key size.  In case the caller knows it is
> expecting a specific output size, the driver will have to use a self
> allocated buffer + a memcpy in those same cases where it would later
> use memmove instead.  Alternatively the sg passed to dma_map_sg can be
> prepended with a dummy segment the right size to save the memcpy.
> 
> akcipher.h only says:
> @dst_len: Size of the output buffer. It needs to be at least as big as
> the expected result depending on the operation
> 
> Note that for random input data the memmove will be done about 1 in
> 256 times but with PKCS#1 padding the signature always has a leading
> zero.
> 
> Requiring buffers bigger than needed makes the added work of dropping
> the zero bytes from the sglist and potentially re-adding them in the
> client difficult to justify.  RSA doing this sets a precedent for a
> future pkcs1pad (or other algorithm) implementation to do the same
> thing and a portable client having to always know the key size and use
> key-sized buffers.

I think we have agreed on dropping the length enforcement at the interface 
level.

Ciao
Stephan
