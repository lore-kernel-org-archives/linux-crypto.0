From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH v3 04/17] crypto: Add userspace configuration API
Date: Mon, 26 Sep 2011 12:56:46 +0200
Message-ID: <20110926105646.GZ1808@secunet.com>
References: <20110921085855.GE1808@secunet.com>
 <20110921090238.GI1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:32869 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab1IZK4s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Sep 2011 06:56:48 -0400
Content-Disposition: inline
In-Reply-To: <20110921090238.GI1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 21, 2011 at 11:02:38AM +0200, Steffen Klassert wrote:
> +
> +static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> +{
> +	struct nlattr *attrs[CRYPTOCFGA_MAX+1];
> +	struct crypto_link *link;
> +	int type, err;
> +
> +	type = nlh->nlmsg_type;
> +	if (type > CRYPTO_MSG_MAX)
> +		return -EINVAL;
> +
> +	type -= CRYPTO_MSG_BASE;
> +	link = &crypto_dispatch[type];
> +
> +	if (security_netlink_recv(skb, CAP_NET_ADMIN))
> +		return -EPERM;
> +

I'm just wondering whether CAP_NET_ADMIN is the right capability to
use here? Do you think we can keep it like that, or would it be better
to define a new CAP_CRYPTO_ADMIN capability?
 
