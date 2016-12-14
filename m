From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2] keys/encrypted: Fix two crypto-on-the-stack bugs
Date: Wed, 14 Dec 2016 08:22:52 -0800
Message-ID: <CALCETrWWt33=03gbBs73NkBOunZU+req1BLgUNcEMfh3T1AXUA@mail.gmail.com>
References: <627e948e37314c13a67c90917386c814c56b8e20.1481683609.git.luto@kernel.org>
 <CALCETrX-YYp5iXPLKOpiT9+3DXYxGTVRXVyPN0oiYpQQC8kH3w@mail.gmail.com> <18039.1481704679@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andy Lutomirski <luto@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, keyrings@vger.kernel.org,
        Eric Biggers <ebiggers3@gmail.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <18039.1481704679@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Dec 14, 2016 at 12:37 AM, David Howells <dhowells@redhat.com> wrote:
> Andy Lutomirski <luto@amacapital.net> wrote:
>
>> > -       sg_set_buf(&sg_out[1], pad, sizeof pad);
>> > +       sg_set_buf(&sg_out[1], empty_zero_page, 16);
>>
>> My fix here is obviously bogus (I meant to use ZERO_PAGE(0)), but what
>> exactly is the code trying to do?  The old code makes no sense.  It's
>> setting the *output* buffer to zeroed padding.
>
> Padding goes into the encrypt function and is going to come out of the decrypt
> function.  Possibly derived_key_decrypt() should be checking that the padding
> that comes out is actually a bunch of zeros.  Maybe we don't actually need to
> get the padding out, but I'm not sure whether the crypto layer will
> malfunction if we don't give it a buffer for the padding.

It was the memset that threw me for a loop.

David, are these encrypted keys ever exported anywhere?  If not, could
the code use a mode that doesn't need padding?

--Andy

>
> David



-- 
Andy Lutomirski
AMA Capital Management, LLC
