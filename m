From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2] keys/encrypted: Fix two crypto-on-the-stack bugs
Date: Tue, 13 Dec 2016 18:53:03 -0800
Message-ID: <CALCETrX-YYp5iXPLKOpiT9+3DXYxGTVRXVyPN0oiYpQQC8kH3w@mail.gmail.com>
References: <627e948e37314c13a67c90917386c814c56b8e20.1481683609.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
        Eric Biggers <ebiggers3@gmail.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
To: Andy Lutomirski <luto@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <627e948e37314c13a67c90917386c814c56b8e20.1481683609.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Dec 13, 2016 at 6:48 PM, Andy Lutomirski <luto@kernel.org> wrote:
> The driver put a constant buffer of all zeros on the stack and
> pointed a scatterlist entry at it in two places.  This doesn't work
> with virtual stacks.  Use ZERO_PAGE instead.

Wait a second...

> -       sg_set_buf(&sg_out[1], pad, sizeof pad);
> +       sg_set_buf(&sg_out[1], empty_zero_page, 16);

My fix here is obviously bogus (I meant to use ZERO_PAGE(0)), but what
exactly is the code trying to do?  The old code makes no sense.  It's
setting the *output* buffer to zeroed padding.

--Andy
