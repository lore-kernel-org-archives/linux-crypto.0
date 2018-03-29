From: Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH v14 net-next 08/12] crypto : chtls - CPL handler
 definition
Date: Thu, 29 Mar 2018 18:26:23 +0200
Message-ID: <20180329162623.GA9805@bistromath.localdomain>
References: <1522339074-4681-1-git-send-email-atul.gupta@chelsio.com>
 <1522339074-4681-9-git-send-email-atul.gupta@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        davejwatson@fb.com, sbrivio@redhat.com,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        werner@chelsio.com, leedom@chelsio.com,
        swise@opengridcomputing.com, indranil@chelsio.com,
        ganeshgr@chelsio.com
To: Atul Gupta <atul.gupta@chelsio.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1522339074-4681-9-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

2018-03-29, 21:27:50 +0530, Atul Gupta wrote:
...
> +static void chtls_pass_accept_request(struct sock *sk,
> +				      struct sk_buff *skb)
> +{
...
> +	if (chtls_get_module(newsk))
> +		goto reject;
> +	inet_csk_reqsk_queue_added(sk);
> +	reply_skb->sk = newsk;
> +	chtls_install_cpl_ops(newsk);

Function defined in patch 11, declared in patch 6, and used in patch
8.  Are you actually listening to the comments we've been sending?

-- 
Sabrina
