Return-Path: <SRS0=k6po=OP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39645 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbeLFLJC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Dec 2018 06:09:02 -0500
Received: by mail-wr1-f67.google.com with SMTP id t27so55328wra.6
        for <linux-crypto@vger.kernel.org>; Thu, 06 Dec 2018 03:09:01 -0800 (PST)
Date: Thu, 6 Dec 2018 12:08:57 +0100
From: LABBE Corentin <clabbe@baylibre.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] crypto: Implement a generic crypto statistics
Message-ID: <20181206110857.GB12268@Red>
References: <1537351855-16618-1-git-send-email-clabbe@baylibre.com>
 <1537351855-16618-2-git-send-email-clabbe@baylibre.com>
 <20181206000458.GA209772@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181206000458.GA209772@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 05, 2018 at 04:04:59PM -0800, Eric Biggers wrote:
> Hi Corentin,
> 
> On Wed, Sep 19, 2018 at 10:10:54AM +0000, Corentin Labbe wrote:
> > +int crypto_dump_reportstat(struct sk_buff *skb, struct netlink_callback *cb)
> > +{
> > +	struct crypto_alg *alg;
> > +	struct crypto_dump_info info;
> > +	int err;
> > +
> > +	if (cb->args[0])
> > +		goto out;
> > +
> > +	cb->args[0] = 1;
> > +
> > +	info.in_skb = cb->skb;
> > +	info.out_skb = skb;
> > +	info.nlmsg_seq = cb->nlh->nlmsg_seq;
> > +	info.nlmsg_flags = NLM_F_MULTI;
> > +
> > +	list_for_each_entry(alg, &crypto_alg_list, cra_list) {
> > +		err = crypto_reportstat_alg(alg, &info);
> > +		if (err)
> > +			goto out_err;
> > +	}
> > +
> > +out:
> > +	return skb->len;
> > +out_err:
> > +	return err;
> > +}
> > +
> > +int crypto_dump_reportstat_done(struct netlink_callback *cb)
> > +{
> > +	return 0;
> > +}
> 
> How did you test this part?  Hint: these functions are never executed.
> 

Right, it is not used, only crypto_reportstat is used by the getstat.c example tool.
And for using it, I need to do changes in crypto_user_rcv_msg().
But I am not sure if it is interesting to do so.

So I will send a patch for removing it.

Regards
