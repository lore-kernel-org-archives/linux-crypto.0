From: Atul Gupta <atul.gupta@chelsio.com>
Subject: Re: [PATCH v14 net-next 08/12] crypto : chtls - CPL handler
 definition
Date: Fri, 30 Mar 2018 00:38:06 +0530
Message-ID: <97a6ce0d-d188-8171-7985-bb31030b1ee8@chelsio.com>
References: <1522339074-4681-1-git-send-email-atul.gupta@chelsio.com>
 <1522339074-4681-9-git-send-email-atul.gupta@chelsio.com>
 <20180329162623.GA9805@bistromath.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        davejwatson@fb.com, sbrivio@redhat.com,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        werner@chelsio.com, leedom@chelsio.com,
        swise@opengridcomputing.com, indranil@chelsio.com,
        ganeshgr@chelsio.com
To: Sabrina Dubroca <sd@queasysnail.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180329162623.GA9805@bistromath.localdomain>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 3/29/2018 9:56 PM, Sabrina Dubroca wrote:
> 2018-03-29, 21:27:50 +0530, Atul Gupta wrote:
> ...
>> +static void chtls_pass_accept_request(struct sock *sk,
>> +				      struct sk_buff *skb)
>> +{
> ...
>> +	if (chtls_get_module(newsk))
>> +		goto reject;
>> +	inet_csk_reqsk_queue_added(sk);
>> +	reply_skb->sk = newsk;
>> +	chtls_install_cpl_ops(newsk);
> Function defined in patch 11, declared in patch 6, and used in patch
> 8.  Are you actually listening to the comments we've been sending?
Patch series is broken to make it bisectable, it ensures that existing modules net, cxgb4, chcr compiles fine, since chtls is new module the sequence of patches builds clean by virtue of having Makefile change in the last patch. We have followed a similar approach in the past for new submission of chcr, cxgbit drivers.
>
