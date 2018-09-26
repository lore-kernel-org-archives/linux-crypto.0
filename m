From: =?UTF-8?Q?Ivan_Lab=c3=a1th?= <labokml@labo.rs>
Subject: Re: [PATCH net-next v6 23/23] net: WireGuard secure network tunnel
Date: Wed, 26 Sep 2018 18:00:31 +0200
Message-ID: <7830522a-968e-0880-beb7-44904466cf14@labo.rs>
References: <20180925145622.29959-1-Jason@zx2c4.com>
 <20180925145622.29959-24-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180925145622.29959-24-Jason@zx2c4.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 25.09.2018 16:56, Jason A. Donenfeld wrote:
> Extensive documentation and description of the protocol and
> considerations, along with formal proofs of the cryptography, are> available at:
> 
>   * https://www.wireguard.com/
>   * https://www.wireguard.com/papers/wireguard.pdf
[]
> +enum { HANDSHAKE_DSCP = 0x88 /* AF41, plus 00 ECN */ };
[]
> +	if (skb->protocol == htons(ETH_P_IP)) {
> +		len = ntohs(ip_hdr(skb)->tot_len);
> +		if (unlikely(len < sizeof(struct iphdr)))
> +			goto dishonest_packet_size;
> +		if (INET_ECN_is_ce(PACKET_CB(skb)->ds))
> +			IP_ECN_set_ce(ip_hdr(skb));
> +	} else if (skb->protocol == htons(ETH_P_IPV6)) {
> +		len = ntohs(ipv6_hdr(skb)->payload_len) +
> +		      sizeof(struct ipv6hdr);
> +		if (INET_ECN_is_ce(PACKET_CB(skb)->ds))
> +			IP6_ECN_set_ce(skb, ipv6_hdr(skb));
> +	} else
[]
> +	skb_queue_walk (&packets, skb) {
> +		/* 0 for no outer TOS: no leak. TODO: should we use flowi->tos
> +		 * as outer? */
> +		PACKET_CB(skb)->ds = ip_tunnel_ecn_encap(0, ip_hdr(skb), skb);
> +		PACKET_CB(skb)->nonce =
> +				atomic64_inc_return(&key->counter.counter) - 1;
> +		if (unlikely(PACKET_CB(skb)->nonce >= REJECT_AFTER_MESSAGES))
> +			goto out_invalid;
> +	}
Hi,

is there documentation and/or rationale for ecn handling?
Quick search for ecn and dscp didn't reveal any.

Regards,
Ivan
