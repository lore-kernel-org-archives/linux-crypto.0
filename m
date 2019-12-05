Return-Path: <SRS0=t288=Z3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 566FAC43603
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 04:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15A362245C
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 04:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575518685;
	bh=FNH802CI4JJwbakGTQJPR0/LSINW2JI/LeJEuFxGms8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=V733Gf5C+3yAaxDBf4yIsPLGEW8I1L7JTjn+5AFu2gwxpzv4Y/i2RaJd89By+pBOC
	 SkPNZzRB6030uM/3sAbopgm/OKuMBNuEOVeYfsevywALk6HHy9hy8N+LXSQXATpk1Q
	 vxndbHKVMPNVe00SuUL5itGkyUcacKJyiNRGSG8k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbfLEEEo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Dec 2019 23:04:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:45106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728321AbfLEEEo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Dec 2019 23:04:44 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9EB321823;
        Thu,  5 Dec 2019 04:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575518683;
        bh=FNH802CI4JJwbakGTQJPR0/LSINW2JI/LeJEuFxGms8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rsy5pLPS1g0tP4m0xNod1+lEOFFk/XnbMhGZMmesUFbtNv8lj1VKEfdHh/4xJdunh
         lw98jrpZE+zwogt6TGb7j4IXMRxtBbow7HYtxJrmTWY/Lnp6hQT8lzxvrLt9jWe6/b
         b6Pg27vy6PbT/G+qioY8ULO5g3Mi6IOdU4B9n+8c=
Date:   Wed, 4 Dec 2019 20:04:42 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, pvanleeuwen@verimatrix.com
Subject: Re: [v3 PATCH] crypto: api - fix unexpectedly getting generic
 implementation
Message-ID: <20191205040442.GB1158@sol.localdomain>
References: <20191202221319.258002-1-ebiggers@kernel.org>
 <20191204091910.67fkpomnav4h5tuw@gondor.apana.org.au>
 <20191204172244.GB1023@sol.localdomain>
 <20191205015811.mg6r3qnv7uj3fgpz@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205015811.mg6r3qnv7uj3fgpz@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 05, 2019 at 09:58:11AM +0800, Herbert Xu wrote:
> +	/* Only satisfy larval waiters if we are the best. */
> +	list_for_each_entry(q, &crypto_alg_list, cra_list) {
> +		struct crypto_larval *larval;
> +
> +		if (crypto_is_moribund(q) || !crypto_is_larval(q))
> +			continue;
> +
> +		if (strcmp(alg->cra_name, q->cra_name))
> +			continue;
> +
> +		larval = (void *)q;
> +		if ((q->cra_flags ^ alg->cra_flags) & larval->mask)
> +			continue;
> +
> +		if (q->cra_priority > alg->cra_priority)
> +			goto complete;
> +	}
> +

This logic doesn't make sense to me either.  It's supposed to be looking for a
"test larval", not a "request larval", right?  But it seems that larval->mask is
always 0 for "test larvals", so the flags check will never do anything...

Also, different "request larvals" can use different flags and masks.  So I don't
think it's possible to know whether 'q' can fulfill every outstanding request
that 'alg' can without actually going through and looking at the requests.  So
that's another case where users can start incorrectly getting ENOENT.

If we don't try to skip setting larval->adult, but rather override the existing
value (as my patch does), the incorrect ENOENTs are prevented.

- Eric
