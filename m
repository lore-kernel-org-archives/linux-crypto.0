From: Ganesh Goudar <ganeshgr@chelsio.com>
Subject: Re: [PATCH v14 net-next 08/12] crypto : chtls - CPL handler
 definition
Date: Fri, 30 Mar 2018 21:11:00 +0530
Message-ID: <20180330154058.GA19496@chelsio.com>
References: <1522339074-4681-1-git-send-email-atul.gupta@chelsio.com>
 <1522339074-4681-9-git-send-email-atul.gupta@chelsio.com>
 <20180329162623.GA9805@bistromath.localdomain>
 <97a6ce0d-d188-8171-7985-bb31030b1ee8@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sabrina Dubroca <sd@queasysnail.net>, davem@davemloft.net,
        herbert@gondor.apana.org.au, davejwatson@fb.com,
        sbrivio@redhat.com, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, werner@chelsio.com, leedom@chelsio.com,
        swise@opengridcomputing.com, indranil@chelsio.com, atul@chelsio.com
To: sd@queasysnail.net
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <97a6ce0d-d188-8171-7985-bb31030b1ee8@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Friday, March 03/30/18, 2018 at 00:38:06 +0530, Atul Gupta wrote:
> 
> 
> On 3/29/2018 9:56 PM, Sabrina Dubroca wrote:
> > 2018-03-29, 21:27:50 +0530, Atul Gupta wrote:
> > ...
> >> +static void chtls_pass_accept_request(struct sock *sk,
> >> +				      struct sk_buff *skb)
> >> +{
> > ...
> >> +	if (chtls_get_module(newsk))
> >> +		goto reject;
> >> +	inet_csk_reqsk_queue_added(sk);
> >> +	reply_skb->sk = newsk;
> >> +	chtls_install_cpl_ops(newsk);
> > Function defined in patch 11, declared in patch 6, and used in patch
> > 8.  Are you actually listening to the comments we've been sending?
> Patch series is broken to make it bisectable, it ensures that existing modules net, cxgb4, chcr compiles fine, since chtls is new module the sequence of patches builds clean by virtue of having Makefile change in the last patch. We have followed a similar approach in the past for new submission of chcr, cxgbit drivers.
> >
>
I hope you are fine with this, we will take care of your other comment in V15
and submit.

Thanks
