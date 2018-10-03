From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v6 23/23] net: WireGuard secure network tunnel
Date: Wed, 3 Oct 2018 16:13:02 +0200
Message-ID: <CAKv+Gu9dOLbiBYKp9HG+GSPML0OJ-UuXnGsJO_re2S75ZF_qNA@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-24-Jason@zx2c4.com>
 <CAKv+Gu-oCH4D_otvMk+R_6z_p73Le90PkdQUUPnT6q0kWVL4Jw@mail.gmail.com> <CAHmME9rWkLT=92QVhbYZd1oee5wYtVRnYu0BGHkGn3bXjN-OxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9rWkLT=92QVhbYZd1oee5wYtVRnYu0BGHkGn3bXjN-OxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 3 October 2018 at 16:12, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Hi Ard,
>
> On Wed, Oct 3, 2018 at 1:15 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> > +config WIREGUARD
>> > +       tristate "WireGuard secure network tunnel"
>> > +       depends on NET && INET
>>
>> I think you need to add IPV6 here
>
> Nope. Like much of the net tree, WireGuard can function on ipv6-less
> kernels. If you do find something in WireGuard isn't working in a
> v6-less configuration, I consider that to be a bug that needs fixing.
>

OK. I hit a build error yesterday, and setting CONFIG_IPV6 fixed it.
Let me see if I can reproduce.
