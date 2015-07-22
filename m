From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 2/3] crypto: algif_akcipher user space interface
Date: Wed, 22 Jul 2015 09:01:15 -0700
Message-ID: <55AFBE4B.8080805@intel.com>
References: <3908391.JkjAozYBaW@tachyon.chronox.de> <1537904.OY6iC43nQX@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48008 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934537AbbGVQBv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2015 12:01:51 -0400
In-Reply-To: <1537904.OY6iC43nQX@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/21/2015 03:13 PM, Stephan Mueller wrote:
> +static ssize_t akcipher_sendpage(struct socket *sock, struct page *page,
> +				 int offset, size_t size, int flags)
> +{
> +	struct sock *sk = sock->sk;
> +	struct alg_sock *ask = alg_sk(sk);
> +	struct akcipher_ctx *ctx = ask->private;
> +	int err = -EINVAL;
> +
> +	if (flags & MSG_SENDPAGE_NOTLAST)
> +		flags |= MSG_MORE;
> +
> +	lock_sock(sk);
> +
> +	/*
> +	 * We do not allow mixing of sendmsg and sendpage calls as this would
> +	 * require a hairy memory management.
> +	 *
> +	 * This check also guards against double call of sendpage.
> +	 * We require that the output buffer size must be provided with one
> +	 * sendpage request as otherwise we cannot have a linear buffer required
> +	 * by the akcipher API.
> +	 */
> +	if (ctx->req_data_ptr)
> +		goto unlock;

Shouldn't we be more flexible and copy the data if it comes in chunks here too.
The user doesn't really have control over this and it would look bad if splice
would randomly fail for a valid buffer.
