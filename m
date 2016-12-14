From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v2] keys/encrypted: Fix two crypto-on-the-stack bugs
Date: Wed, 14 Dec 2016 13:04:04 +0800
Message-ID: <20161214050404.GC9592@gondor.apana.org.au>
References: <627e948e37314c13a67c90917386c814c56b8e20.1481683609.git.luto@kernel.org>
 <CALCETrX-YYp5iXPLKOpiT9+3DXYxGTVRXVyPN0oiYpQQC8kH3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrX-YYp5iXPLKOpiT9+3DXYxGTVRXVyPN0oiYpQQC8kH3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Dec 13, 2016 at 06:53:03PM -0800, Andy Lutomirski wrote:
> On Tue, Dec 13, 2016 at 6:48 PM, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > The driver put a constant buffer of all zeros on the stack and
> > pointed a scatterlist entry at it in two places.  This doesn't work
> > with virtual stacks.  Use ZERO_PAGE instead.
> 
> Wait a second...
> 
> > -       sg_set_buf(&sg_out[1], pad, sizeof pad);
> > +       sg_set_buf(&sg_out[1], empty_zero_page, 16);
> 
> My fix here is obviously bogus (I meant to use ZERO_PAGE(0)), but what
> exactly is the code trying to do?  The old code makes no sense.  It's
> setting the *output* buffer to zeroed padding.

It's decrypting so I presume it just needs to the extra space for
the padding and the result will be thrown away.

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
