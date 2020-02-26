Return-Path: <SRS0=wQ8K=4O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CBBC4BA09
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 02:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AAE6222C2
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Feb 2020 02:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582684374;
	bh=02ouW81DUsPHAJzxSAPTvGoxzGwv4BggF6TdJk2BivY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=NmqYit7UYIZAO+Sxd/I6TRhMhFRSWFKjUcVtxse91yy1RZwjhIDCbGUYsntQHVNGL
	 ehX48Xa8GluO4Wy52jytPq1avawdXhuRE6hljBtS3YqIpzhM7U0le9AVJ8Jla+hu4G
	 v3lLXgWta9kCgU5hRpY2cMRbkmmVXFLdarL7J0js=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbgBZCcx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Feb 2020 21:32:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729045AbgBZCcx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Feb 2020 21:32:53 -0500
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1830721D7E;
        Wed, 26 Feb 2020 02:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582684372;
        bh=02ouW81DUsPHAJzxSAPTvGoxzGwv4BggF6TdJk2BivY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZLKokWUTzTs0OqW+20nt+1D3cwx7Q4MkCz3mWJn/pl5n9lI1dHWx15PSutwErtEg/
         gF/1rcGRKMcbixPFtR+T+DS8KCGAad/4MTP1YByuB0HD6F/f4X6DMe2srFf9pejKnl
         HOIkEaKtNr+FgUDBVQGxmV3Q5MqK/odSzAC+I0UM=
Date:   Tue, 25 Feb 2020 18:32:50 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: testmgr - use generic algs making test vecs
Message-ID: <20200226023250.GA1053@sol.localdomain>
References: <20200225154834.25108-1-gilad@benyossef.com>
 <20200225154834.25108-2-gilad@benyossef.com>
 <20200225194551.GA114977@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225194551.GA114977@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 25, 2020 at 11:45:51AM -0800, Eric Biggers wrote:
> On Tue, Feb 25, 2020 at 05:48:33PM +0200, Gilad Ben-Yossef wrote:
> > Use generic algs to produce inauthentic AEAD messages,
> > otherwise we are running the risk of using an untested
> > code to produce the test messages.
> > 
> > As this code is only used in developer only extended tests
> > any cycles/runtime costs are negligible.
> > 
> > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> > Cc: Eric Biggers <ebiggers@kernel.org>
> 
> It's intentional to use the same implementation to generate the inauthentic AEAD
> messages, because it allows the inauthentic AEAD input tests to run even if the
> generic implementation is unavailable.
> 
> > @@ -2337,8 +2338,42 @@ static int test_aead_inauthentic_inputs(struct aead_extra_tests_ctx *ctx)
> >  {
> >  	unsigned int i;
> >  	int err;
> > +	struct crypto_aead *tfm = ctx->tfm;
> > +	const char *algname = crypto_aead_alg(tfm)->base.cra_name;
> > +	const char *driver = ctx->driver;
> > +	const char *generic_driver = ctx->test_desc->generic_driver;
> > +	char _generic_driver[CRYPTO_MAX_ALG_NAME];
> > +	struct crypto_aead *generic_tfm = NULL;
> > +	struct aead_request *generic_req = NULL;
> > +
> > +	if (!generic_driver) {
> > +		err = build_generic_driver_name(algname, _generic_driver);
> > +		if (err)
> > +			return err;
> > +		generic_driver = _generic_driver;
> > +	}
> > +
> > +	if (!strcmp(generic_driver, driver) == 0) {
> > +		/* Already the generic impl? */
> > +
> > +		generic_tfm = crypto_alloc_aead(generic_driver, 0, 0);
> 
> I think you meant the condition to be 'if (strcmp(generic_driver, driver) != 0)'
> and for the comment to be "Not already the generic impl?".
> 
> > +		if (IS_ERR(generic_tfm)) {
> > +			err = PTR_ERR(generic_tfm);
> > +			pr_err("alg: aead: error allocating %s (generic impl of %s): %d\n",
> > +			generic_driver, algname, err);
> > +			return err;
> > +		}
> 
> This means the test won't run if the generic implementation is unavailable.
> Is there any particular reason to impose that requirement?
> 
> You mentioned a concern about the implementation being "untested", but it
> actually already passed test_aead() before getting to test_aead_extra().
> 
> We could also just move test_aead_inauthentic_inputs() to below
> test_aead_vs_generic_impl() so that it runs last.
> 

Also: if we did make the inauthentic input tests use the generic implementation,
then it would be better to move them into test_aead_vs_generic_impl() so that we
don't duplicate the code that allocates a tfm and request for the generic
implementation.

But to me it makes more sense to keep them separate, since a generic
implementation is not needed to run the inauthentic input tests.

- Eric
