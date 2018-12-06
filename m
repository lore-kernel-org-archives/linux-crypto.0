Return-Path: <SRS0=k6po=OP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727762AbeLFAFC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Dec 2018 19:05:02 -0500
Date: Wed, 5 Dec 2018 16:04:59 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Corentin Labbe <clabbe@baylibre.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] crypto: Implement a generic crypto statistics
Message-ID: <20181206000458.GA209772@gmail.com>
References: <1537351855-16618-1-git-send-email-clabbe@baylibre.com>
 <1537351855-16618-2-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537351855-16618-2-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Corentin,

On Wed, Sep 19, 2018 at 10:10:54AM +0000, Corentin Labbe wrote:
> +int crypto_dump_reportstat(struct sk_buff *skb, struct netlink_callback *cb)
> +{
> +	struct crypto_alg *alg;
> +	struct crypto_dump_info info;
> +	int err;
> +
> +	if (cb->args[0])
> +		goto out;
> +
> +	cb->args[0] = 1;
> +
> +	info.in_skb = cb->skb;
> +	info.out_skb = skb;
> +	info.nlmsg_seq = cb->nlh->nlmsg_seq;
> +	info.nlmsg_flags = NLM_F_MULTI;
> +
> +	list_for_each_entry(alg, &crypto_alg_list, cra_list) {
> +		err = crypto_reportstat_alg(alg, &info);
> +		if (err)
> +			goto out_err;
> +	}
> +
> +out:
> +	return skb->len;
> +out_err:
> +	return err;
> +}
> +
> +int crypto_dump_reportstat_done(struct netlink_callback *cb)
> +{
> +	return 0;
> +}

How did you test this part?  Hint: these functions are never executed.

- Eric
