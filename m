Return-Path: <SRS0=KYvO=NY=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-qk1-f182.google.com ([209.85.222.182]:38943 "EHLO
        mail-qk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbeKMKGR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Nov 2018 05:06:17 -0500
MIME-Version: 1.0
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-24-Jason@zx2c4.com>
 <7830522a-968e-0880-beb7-44904466cf14@labo.rs> <CAHmME9oQJ9y51Pv7U=+=5uDA_tb+U1zWZdsLcyNMhdcFZmjM8Q@mail.gmail.com>
 <e4b500e9-f24a-43c5-c2df-834dafc3aae5@labo.rs> <CAHmME9q8tp3Ch43o3D6zYTVujcjBWLVpNdzVw6RqYqHisd_suQ@mail.gmail.com>
In-Reply-To: <CAHmME9q8tp3Ch43o3D6zYTVujcjBWLVpNdzVw6RqYqHisd_suQ@mail.gmail.com>
From: Dave Taht <dave.taht@gmail.com>
Date: Mon, 12 Nov 2018 16:10:36 -0800
Message-ID: <CAA93jw7e61mbbLMoDwshxpWWK+oGUz71pGrsUYVX8uWM-s5Krg@mail.gmail.com>
Subject: Re: [PATCH net-next v6 23/23] net: WireGuard secure network tunnel
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: labokml@labo.rs, linux-kernel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 12, 2018 at 3:54 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hey Ivan,
>
> Sorry for not getting back to you sooner.
>
> On Mon, Nov 5, 2018 at 8:06 AM Ivan Lab=C3=A1th <labokml@labo.rs> wrote:
> > Any news on this?
> >
> > To be clear, question is not about an insignificant documentation
> > oversight. It is about copying bits from inner packets to outer packets
>
> The short answer is RFC6040 with DSCP fixed to 0 so as not to leak
> anything. I've added a description of this to
> <wireguard.com/protocol/>.

you have a speling error (ECM). :)

side note:

I have to say that wireguard works really well with ecn and non-ecn marked =
flows
against codel and fq_codel on the bottleneck router.

I'd still rather like it if wireguard focused a bit more on
interleaving multiple flows better
rather than on single stream benchmarks, one day.

In this case, codel is managing things not fq and we could possibly
shave a few ms of induced latency off of it in this particular test series:

http://tun.taht.net/~d/wireguard/rrul_-_comcast_v6.png

vs wireguard (doing it ivp6 over that ipv6)

http://tun.taht.net/~d/wireguard/rrul_-_wireguard.png

That said, I've been deploying wireguard widely in replacement of my
old tinc network particularly on machines that were formerly cpu
bottlenecked
and am insanely pleased with it. what's a few extra ms of latency
between friends?

>
> Regards,
> Jason



--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
