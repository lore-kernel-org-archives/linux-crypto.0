From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v2] keys/encrypted: Fix two crypto-on-the-stack bugs
Date: Wed, 14 Dec 2016 00:10:24 -0800
Message-ID: <20161214081024.GA22765@zzz>
References: <627e948e37314c13a67c90917386c814c56b8e20.1481683609.git.luto@kernel.org>
 <CALCETrX-YYp5iXPLKOpiT9+3DXYxGTVRXVyPN0oiYpQQC8kH3w@mail.gmail.com>
 <20161214050404.GC9592@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36581 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752752AbcLNIK3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Dec 2016 03:10:29 -0500
Content-Disposition: inline
In-Reply-To: <20161214050404.GC9592@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 14, 2016 at 01:04:04PM +0800, Herbert Xu wrote:
> On Tue, Dec 13, 2016 at 06:53:03PM -0800, Andy Lutomirski wrote:
> > On Tue, Dec 13, 2016 at 6:48 PM, Andy Lutomirski <luto@kernel.org> wrote:
> > > The driver put a constant buffer of all zeros on the stack and
> > > pointed a scatterlist entry at it in two places.  This doesn't work
> > > with virtual stacks.  Use ZERO_PAGE instead.
> > 
> > Wait a second...
> > 
> > > -       sg_set_buf(&sg_out[1], pad, sizeof pad);
> > > +       sg_set_buf(&sg_out[1], empty_zero_page, 16);
> > 
> > My fix here is obviously bogus (I meant to use ZERO_PAGE(0)), but what
> > exactly is the code trying to do?  The old code makes no sense.  It's
> > setting the *output* buffer to zeroed padding.
> 
> It's decrypting so I presume it just needs to the extra space for
> the padding and the result will be thrown away.
> 

It looks like the data is zero-padded to a 16-byte AES block boundary before
being encrypted with CBC, so the encrypted data may be longer than the original
data.  (I don't know why it doesn't use CTS mode instead, which would make the
lengths the same.)

Since the crypto API can do in-place operations, when *encrypting* I suggest
copying the decrypted data to the output buffer, padding it with 0's, and
encrypting it in-place.  This eliminates the need for the stack buffer.

But when *decrypting* there will be up to 15 extra throwaway bytes of output
produced by the decryption.  There must be space made for these, and since it's
output it can't be empty_zero_page.  I guess either check whether space can be
made for it in-place, or allocate a temporary buffer...

Eric
