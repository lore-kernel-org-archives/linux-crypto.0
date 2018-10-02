From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v6 00/23] WireGuard: Secure Network Tunnel
Date: Tue, 2 Oct 2018 08:04:04 +0200
Message-ID: <CAKv+Gu8fr_qADiTJH05nVWF7Yi3U722nfKJsMaRE9CP3YjNBbg@mail.gmail.com>
References: <CAKv+Gu-ZMR7zEAKv6_2tyD3OqnjVugOzKHzBEXW3pQs5W-SvLw@mail.gmail.com>
 <20181002033908.324yhwqaohfsq65d@gondor.apana.org.au> <CAHmME9piX1kbUhOBcUKVdecr45EjxuruxYuMTepfXVvRrkVmyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9piX1kbUhOBcUKVdecr45EjxuruxYuMTepfXVvRrkVmyg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 2 October 2018 at 05:45, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Hi Herbert,
>
> On Tue, Oct 2, 2018 at 5:39 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> > I would also strongly prefer that all crypto work is taken through
>> > Herbert's tree, so we have a coherent view of it before it goes
>> > upstream.
>>
>> I agree.  I don't have any problems with the zinc code living in
>> its own git tree.  But any upstream merges should definitely go
>> through the crypto tree because the inherent ties between the two
>> code-base.
>
> I can send you pull requests then if there are development cycles when
> there are in fact relations between the two trees. I'll update the
> commit message describing Zinc to include this.
>

Can you explain why you it is so important to you that your changes
remain outside the crypto tree?

Also, I still think the name Zinc (zinc is not crypto/) is needlessly
divisive and condescending, and unsaying it (in v2 and up) doesn't
really work on the Internet (especially since you are still repeating
it in your conference talk.)
