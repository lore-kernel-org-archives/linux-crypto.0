From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 23/23] net: WireGuard secure network tunnel
Date: Wed, 26 Sep 2018 18:04:09 +0200
Message-ID: <CAHmME9oQJ9y51Pv7U=+=5uDA_tb+U1zWZdsLcyNMhdcFZmjM8Q@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-24-Jason@zx2c4.com>
 <7830522a-968e-0880-beb7-44904466cf14@labo.rs>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: labokml@labo.rs, Dave Taht <dave.taht@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7830522a-968e-0880-beb7-44904466cf14@labo.rs>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Ivan,

On Wed, Sep 26, 2018 at 6:00 PM Ivan Lab=C3=A1th <labokml@labo.rs> wrote:
>
> On 25.09.2018 16:56, Jason A. Donenfeld wrote:
> > Extensive documentation and description of the protocol and
> > considerations, along with formal proofs of the cryptography, are> avai=
lable at:
> >
> >   * https://www.wireguard.com/
> >   * https://www.wireguard.com/papers/wireguard.pdf
> []
> > +enum { HANDSHAKE_DSCP =3D 0x88 /* AF41, plus 00 ECN */ };
> []
> > +     if (skb->protocol =3D=3D htons(ETH_P_IP)) {
> > +             len =3D ntohs(ip_hdr(skb)->tot_len);
> > +             if (unlikely(len < sizeof(struct iphdr)))
> > +                     goto dishonest_packet_size;
> > +             if (INET_ECN_is_ce(PACKET_CB(skb)->ds))
> > +                     IP_ECN_set_ce(ip_hdr(skb));
> > +     } else if (skb->protocol =3D=3D htons(ETH_P_IPV6)) {
> > +             len =3D ntohs(ipv6_hdr(skb)->payload_len) +
> > +                   sizeof(struct ipv6hdr);
> > +             if (INET_ECN_is_ce(PACKET_CB(skb)->ds))
> > +                     IP6_ECN_set_ce(skb, ipv6_hdr(skb));
> > +     } else
> []
> > +     skb_queue_walk (&packets, skb) {
> > +             /* 0 for no outer TOS: no leak. TODO: should we use flowi=
->tos
> > +              * as outer? */
> > +             PACKET_CB(skb)->ds =3D ip_tunnel_ecn_encap(0, ip_hdr(skb)=
, skb);
> > +             PACKET_CB(skb)->nonce =3D
> > +                             atomic64_inc_return(&key->counter.counter=
) - 1;
> > +             if (unlikely(PACKET_CB(skb)->nonce >=3D REJECT_AFTER_MESS=
AGES))
> > +                     goto out_invalid;
> > +     }
> Hi,
>
> is there documentation and/or rationale for ecn handling?
> Quick search for ecn and dscp didn't reveal any.

ECN support was developed with Dave Taht so that it does the right
thing with CAKE and such. He's CC'd, so that he can fill in details,
and sure, we can write these up. As well, I can add the rationale for
the handshake-packet-specific DSCP value to the paper in the next few
days; thanks for pointing out these documentation oversights.

Jason
