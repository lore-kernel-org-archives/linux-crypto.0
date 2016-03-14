From: Mark McKinstry <Mark.McKinstry@alliedtelesis.co.nz>
Subject: Re: [PATCH] vti6: Add pmtu handling to vti6_xmit.
Date: Mon, 14 Mar 2016 21:52:05 +0000
Message-ID: <56E73285.5000702@alliedtelesis.co.nz>
References: <20150529182709.2147.78230.stgit@ahduyck-vm-fedora22>
 <56BA975D.2040706@alliedtelesis.co.nz>
 <20160217070805.GA316@gauss.secunet.com>
 <56C520F0.4050309@alliedtelesis.co.nz>
 <20160218121915.GH316@gauss.secunet.com>
 <56CE22A3.7030702@alliedtelesis.co.nz>
 <20160304070525.GA3347@gauss.secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"alexander.h.duyck@redhat.com" <alexander.h.duyck@redhat.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:34717 "EHLO
	gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbcCNVwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Mar 2016 17:52:18 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client did not present a certificate)
	by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 71D3C82553
	for <linux-crypto@vger.kernel.org>; Tue, 15 Mar 2016 10:52:07 +1300 (NZDT)
In-Reply-To: <20160304070525.GA3347@gauss.secunet.com>
Content-Language: en-US
Content-ID: <E8128F6FA69E434CB6BE51B2C30AC147@atlnz.lc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/03/16 20:05, Steffen Klassert wrote:
> On Wed, Feb 24, 2016 at 09:37:39PM +0000, Mark McKinstry wrote:
>> On 19/02/16 01:19, Steffen Klassert wrote:
>>> On Thu, Feb 18, 2016 at 01:40:00AM +0000, Mark McKinstry wrote:
>>>> This patch fixes our issue, thanks. In our scenario the tunnel path MTU
>>>> now gets updated so that subsequent large packets sent over the tunnel
>>>> get fragmented correctly.
>>> I've applied this patch to the ipsec tree now.
>>> Thanks for testing!
>> I spoke too soon. Upon further testing with this patch we have found it
>> causes
>> a skt buffer leak. This is problematic for us and can cause memory
>> exhaustion in
>> one of our test scenarios that has an IPv4 IPsec tunnel over a PPP link.
> The patch below is what I plan to apply on top of the original patch.
>
> Subject: [PATCH] vti: Fix recource leeks on pmtu discovery
>
> A recent patch introduced pmtu handling directly in the
> vti transmit routine. Unfortunately we now return without
> releasing the dst_entry and freeing the sk_buff. This patch
> fixes the issue.
>
> Fixes: 325b71fe0f57 ("vti: Add pmtu handling to vti_xmit.")
> Reported-by: Mark McKinstry <Mark.McKinstry@alliedtelesis.co.nz>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> ---
>   net/ipv4/ip_vti.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
> index 6862305..2ea2b6e 100644
> --- a/net/ipv4/ip_vti.c
> +++ b/net/ipv4/ip_vti.c
> @@ -206,7 +206,8 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
>   		else
>   			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
>   
> -		return -EMSGSIZE;
> +		dst_release(dst);
> +		goto tx_error;
>   	}
>   
>   	err = dst_output(tunnel->net, skb->sk, skb);
Your patch adds a dst_release() call to my suggested fix, but this is 
problematic because the kfree_skb() call at tx_error already takes care 
of releasing dst - via kfree_skb() > __kfree_skb() > skb_release_all() > 
skb_release_head_state() > skb_dst_drop()
 > refdst_drop() > dst_release(). In our scenario your patch results in 
a negative refcount kernel warning being generated in dst_release() for 
every packet that is too big to go over the vti.
