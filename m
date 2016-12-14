From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2] keys/encrypted: Fix two crypto-on-the-stack bugs
Date: Wed, 14 Dec 2016 17:00:53 +0000
Message-ID: <3738.1481734853@warthog.procyon.org.uk>
References: <CALCETrWWt33=03gbBs73NkBOunZU+req1BLgUNcEMfh3T1AXUA@mail.gmail.com> <627e948e37314c13a67c90917386c814c56b8e20.1481683609.git.luto@kernel.org> <CALCETrX-YYp5iXPLKOpiT9+3DXYxGTVRXVyPN0oiYpQQC8kH3w@mail.gmail.com> <18039.1481704679@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, Andy Lutomirski <luto@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, keyrings@vger.kernel.org,
        Eric Biggers <ebiggers3@gmail.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWWt33=03gbBs73NkBOunZU+req1BLgUNcEMfh3T1AXUA@mail.gmail.com>
Content-ID: <3737.1481734853.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Andy Lutomirski <luto@amacapital.net> wrote:

> David, are these encrypted keys ever exported anywhere?  If not, could
> the code use a mode that doesn't need padding?

ecryptfs uses them, I think.

David
