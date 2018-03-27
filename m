From: Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH v13 net-next 09/12] crypto: chtls - Inline TLS record Tx
Date: Tue, 27 Mar 2018 19:51:16 +0200
Message-ID: <20180327195116.0ac14f7e@epycfail>
References: <1522172201-7629-1-git-send-email-atul.gupta@chelsio.com>
        <1522172201-7629-10-git-send-email-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        davejwatson@fb.com, sd@queasysnail.net,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        werner@chelsio.com, leedom@chelsio.com,
        swise@opengridcomputing.com, indranil@chelsio.com,
        ganeshgr@chelsio.com
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1522172201-7629-10-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 27 Mar 2018 23:06:38 +0530
Atul Gupta <atul.gupta@chelsio.com> wrote:

> +static u8 tcp_state_to_flowc_state(u8 state)
> +{
> +	u8 ret = FW_FLOWC_MNEM_TCPSTATE_ESTABLISHED;
> +
> +	switch (state) {
> +	case TCP_ESTABLISHED:
> +		ret = FW_FLOWC_MNEM_TCPSTATE_ESTABLISHED;
> +		break;
> +	case TCP_CLOSE_WAIT:
> +		ret = FW_FLOWC_MNEM_TCPSTATE_CLOSEWAIT;
> +		break;
> +	case TCP_FIN_WAIT1:
> +		ret = FW_FLOWC_MNEM_TCPSTATE_FINWAIT1;
> +		break;
> +	case TCP_CLOSING:
> +		ret = FW_FLOWC_MNEM_TCPSTATE_CLOSING;
> +		break;
> +	case TCP_LAST_ACK:
> +		ret = FW_FLOWC_MNEM_TCPSTATE_LASTACK;
> +		break;
> +	case TCP_FIN_WAIT2:
> +		ret = FW_FLOWC_MNEM_TCPSTATE_FINWAIT2;
> +		break;

Can't you just return those values right away instead?

> [...]
>
> +static u64 tlstx_seq_number(struct chtls_hws *hws)
> +{
> +	return hws->tx_seq_no++;
> +}

The name of this function, as I also had commented earlier, is
misleading, because you are also incrementing the sequence number.

> [...]
>
> +static void mark_urg(struct tcp_sock *tp, int flags,
> +		     struct sk_buff *skb)
> +{
> +	if (unlikely(flags & MSG_OOB)) {
> +		tp->snd_up = tp->write_seq;
> +			ULP_SKB_CB(skb)->flags = ULPCB_FLAG_URG |
> +						 ULPCB_FLAG_BARRIER |
> +						 ULPCB_FLAG_NO_APPEND |
> +						 ULPCB_FLAG_NEED_HDR;

Is this indentation the result of a previous 'if' clause which is now
gone?

> [...]
>
> +/*
> + * Returns true if a TCP socket is corked.
> + */
> +static int corked(const struct tcp_sock *tp, int flags)
> +{
> +	return (flags & MSG_MORE) | (tp->nonagle & TCP_NAGLE_CORK);

I guess you meant || here. Shouldn't this be a bool?

> +}
> +
> +/*
> + * Returns true if a send should try to push new data.
> + */
> +static int send_should_push(struct sock *sk, int flags)
> +{
> +	return should_push(sk) && !corked(tcp_sk(sk), flags);
> +}

If it returns true, I guess it should be a bool.

> [...]

-- 
Stefano
