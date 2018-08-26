From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v2 02/17] zinc: introduce minimal cryptography library
Date: Sun, 26 Aug 2018 09:59:58 -0600
Message-ID: <CAHmME9pRVmjLHzaU7X3DZAihMUHORQfr8VPXv0Rt7SfZG=K4FQ@mail.gmail.com>
References: <20180824213849.23647-1-Jason@zx2c4.com> <20180824213849.23647-3-Jason@zx2c4.com>
 <20180825062951.GC726@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lutomirski <luto@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180825062951.GC726@sol.localdomain>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Aug 25, 2018 at 12:29 AM Eric Biggers <ebiggers@kernel.org> wrote:
> I thought you were going to wrap lines at 80 characters?  It's hard to read the
> extremely long lines, and they encourage deep nesting.

> There are still some alignment bugs where integers are loaded from byte arrays
> without using the unaligned access macros, e.g. in chacha20_init(),
> hchacha20_generic(), and fe_frombytes_impl().

These fixes are now completed in the development tree.
