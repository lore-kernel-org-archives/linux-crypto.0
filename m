Return-Path: <SRS0=w8RP=WS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E58C3A59D
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 04:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0C102145D
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 04:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730337AbfHVEN6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Aug 2019 00:13:58 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58330 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbfHVEN6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Aug 2019 00:13:58 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1i0eTq-0001w2-S9; Thu, 22 Aug 2019 14:13:46 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1i0eTk-00009t-MR; Thu, 22 Aug 2019 14:13:40 +1000
Date:   Thu, 22 Aug 2019 14:13:40 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] padata: unbind parallel jobs from specific CPUs
Message-ID: <20190822041340.GA590@gondor.apana.org.au>
References: <20190813005224.30779-1-daniel.m.jordan@oracle.com>
 <20190813005224.30779-9-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813005224.30779-9-daniel.m.jordan@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 12, 2019 at 08:52:23PM -0400, Daniel Jordan wrote:
>
> @@ -191,22 +184,25 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
>  		padata = list_entry(reorder->list.next,
>  				    struct padata_priv, list);
>  
> -		list_del_init(&padata->list);
> -		atomic_dec(&pd->reorder_objects);
> +		/*
> +		 * The check fails in the unlikely event that two or more
> +		 * parallel jobs have hashed to the same CPU and one of the
> +		 * later ones finishes first.
> +		 */
> +		if (padata->seq_nr == pd->processed) {
> +			list_del_init(&padata->list);
> +			atomic_dec(&pd->reorder_objects);

Now that you've changed the test for whether there is work to be
done you also need to update the code at the end of padata_reorder
that checks whether there is work to do.  Otherwise we can end up
in a busy loop that just wastes CPU cycles.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
