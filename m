Return-Path: <SRS0=IFNk=NQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:49439 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728870AbeKEW02 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Nov 2018 17:26:28 -0500
Subject: Re: [PATCH net-next v6 23/23] net: WireGuard secure network tunnel
To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dave Taht <dave.taht@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20180925145622.29959-1-Jason@zx2c4.com>
 <20180925145622.29959-24-Jason@zx2c4.com>
 <7830522a-968e-0880-beb7-44904466cf14@labo.rs>
 <CAHmME9oQJ9y51Pv7U=+=5uDA_tb+U1zWZdsLcyNMhdcFZmjM8Q@mail.gmail.com>
From: =?UTF-8?Q?Ivan_Lab=c3=a1th?= <labokml@labo.rs>
Message-ID: <e4b500e9-f24a-43c5-c2df-834dafc3aae5@labo.rs>
Date: Mon, 5 Nov 2018 14:06:42 +0100
MIME-Version: 1.0
In-Reply-To: <CAHmME9oQJ9y51Pv7U=+=5uDA_tb+U1zWZdsLcyNMhdcFZmjM8Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 26. 9. 2018 18:04, Jason A. Donenfeld wrote:
> Hi Ivan,
> 
> On Wed, Sep 26, 2018 at 6:00 PM Ivan Labáth <labokml@labo.rs> wrote:
>>
>> On 25.09.2018 16:56, Jason A. Donenfeld wrote:
>>> Extensive documentation and description of the protocol and
>>> considerations, along with formal proofs of the cryptography, are> available at:
>>>
>>>   * https://www.wireguard.com/
>>>   * https://www.wireguard.com/papers/wireguard.pdf
>> []
>>> +enum { HANDSHAKE_DSCP = 0x88 /* AF41, plus 00 ECN */ };
>> []
>>> +     if (skb->protocol == htons(ETH_P_IP)) {
>>> +             len = ntohs(ip_hdr(skb)->tot_len);
>>> +             if (unlikely(len < sizeof(struct iphdr)))
>>> +                     goto dishonest_packet_size;
>>> +             if (INET_ECN_is_ce(PACKET_CB(skb)->ds))
>>> +                     IP_ECN_set_ce(ip_hdr(skb));
>>> +     } else if (skb->protocol == htons(ETH_P_IPV6)) {
>>> +             len = ntohs(ipv6_hdr(skb)->payload_len) +
>>> +                   sizeof(struct ipv6hdr);
>>> +             if (INET_ECN_is_ce(PACKET_CB(skb)->ds))
>>> +                     IP6_ECN_set_ce(skb, ipv6_hdr(skb));
>>> +     } else
>> []
>>> +     skb_queue_walk (&packets, skb) {
>>> +             /* 0 for no outer TOS: no leak. TODO: should we use flowi->tos
>>> +              * as outer? */
>>> +             PACKET_CB(skb)->ds = ip_tunnel_ecn_encap(0, ip_hdr(skb), skb);
>>> +             PACKET_CB(skb)->nonce =
>>> +                             atomic64_inc_return(&key->counter.counter) - 1;
>>> +             if (unlikely(PACKET_CB(skb)->nonce >= REJECT_AFTER_MESSAGES))
>>> +                     goto out_invalid;
>>> +     }
>> Hi,
>>
>> is there documentation and/or rationale for ecn handling?
>> Quick search for ecn and dscp didn't reveal any.
> 
> ECN support was developed with Dave Taht so that it does the right
> thing with CAKE and such. He's CC'd, so that he can fill in details,
> and sure, we can write these up. As well, I can add the rationale for
> the handshake-packet-specific DSCP value to the paper in the next few
> days; thanks for pointing out these documentation oversights.
> 
> Jason
> 

Any news on this?

To be clear, question is not about an insignificant documentation
oversight. It is about copying bits from inner packets to outer packets
of a secure* tunnel and documenting it AFAICT nowhere, while claiming
extensive documentation.

* it really should be specified what secure tunnel means, as it has many
plausible interpretations and wireguard surely does not fulfill all of them.

Ivan
