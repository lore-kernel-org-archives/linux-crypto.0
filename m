Return-Path: <SRS0=KYvO=NY=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:41147 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbeKMKIz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Nov 2018 05:08:55 -0500
MIME-Version: 1.0
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-24-Jason@zx2c4.com>
 <7830522a-968e-0880-beb7-44904466cf14@labo.rs> <CAHmME9oQJ9y51Pv7U=+=5uDA_tb+U1zWZdsLcyNMhdcFZmjM8Q@mail.gmail.com>
 <e4b500e9-f24a-43c5-c2df-834dafc3aae5@labo.rs> <CAHmME9q8tp3Ch43o3D6zYTVujcjBWLVpNdzVw6RqYqHisd_suQ@mail.gmail.com>
 <CAA93jw7e61mbbLMoDwshxpWWK+oGUz71pGrsUYVX8uWM-s5Krg@mail.gmail.com>
In-Reply-To: <CAA93jw7e61mbbLMoDwshxpWWK+oGUz71pGrsUYVX8uWM-s5Krg@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 12 Nov 2018 19:13:13 -0500
Message-ID: <CAHmME9rOhBwsGhFXP8qmfX-0XooJ+CLekLZ7+mNpy3kw9oq0jQ@mail.gmail.com>
Subject: Re: [PATCH net-next v6 23/23] net: WireGuard secure network tunnel
To: Dave Taht <dave.taht@gmail.com>
Cc: labokml@labo.rs, LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 12, 2018 at 7:10 PM Dave Taht <dave.taht@gmail.com> wrote:
> you have a speling error (ECM). :)

Thanks.

>
> side note:
>
> I have to say that wireguard works really well with ecn and non-ecn marked flows
> against codel and fq_codel on the bottleneck router.

Yup!

> I'd still rather like it if wireguard focused a bit more on
> interleaving multiple flows better
> rather than on single stream benchmarks, one day.

We're working on it, actually. Toke has been running some tests on
some beefy 100gbps hardware he recently acquired, and after v1 lands
we'll probably have a few interesting ideas for this.

Jason
