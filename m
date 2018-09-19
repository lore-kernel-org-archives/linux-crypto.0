From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v5 07/20] zinc: Poly1305 generic C
 implementations and selftest
Date: Wed, 19 Sep 2018 13:50:03 +0200
Message-ID: <CAHmME9oERxpgxavBjoHEGwPCCq+O20eiDAXPvDSKgB4D+TRcDQ@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-8-Jason@zx2c4.com>
 <20180919005054.GC74746@gmail.com> <CAHmME9oL98adRp6xXqaXxA0E4Oa4ecPW+JHChCS3hTgH7RLPjA@mail.gmail.com>
 <BF781C43-52C2-410A-A6D0-AAD0AC998C2D@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eric Biggers <ebiggers@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <BF781C43-52C2-410A-A6D0-AAD0AC998C2D@amacapital.net>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 19, 2018 at 6:19 AM Andy Lutomirski <luto@amacapital.net> wrote:
> Can you not uglify the code a bit by using normal (non-compound) liberals as described in the response to that email?

I can define a bunch of variables, and then string them all together
in an array at the end. This is a bit ugly and less maintainable, but
would be the best of both worlds.
