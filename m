From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 03/23] zinc: ChaCha20 generic C implementation
 and selftest
Date: Tue, 2 Oct 2018 05:18:38 +0200
Message-ID: <CAHmME9qo0cBnptzSe=G=L0uzvOj1-LN=8-Z-osHcE=0XS4N0zw@mail.gmail.com>
References: <20180925145622.29959-4-Jason@zx2c4.com> <20181002031542.dbxu44gvqrughlgw@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181002031542.dbxu44gvqrughlgw@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

On Tue, Oct 2, 2018 at 5:15 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> I don't have any problems with this interface.
>
> However, I'm very unhappy about the fact that this adds another
> copy of the chacha20 implementation to the kernel.  Either this
> is better than the one that we already have or it isn't.
>
> So if it's better please replace the existing chacha20 C
> implementation with this or otherwise just adapt the existing
> implementation to this interface.
>
> If we're replacing the existing one then you can either replace
> it directly within this patch or in a subsequent patch but please
> do it in the same series because otherwise we could wind up with
> two implementations for years to come.

Indeed this series takes care of removing the other implementation later on.

In case it helps to see things visualized, here's the layout of the
whole series:
https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/log/?h=jd/wireguard

Note that comments on this are probably a bit more useful than on the
version posted to the mailing list, since I've already started
incorporating quite a bit of feedback from v6, and so v7 will be
posted sometime later containing these.

Jason
