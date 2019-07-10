Return-Path: <SRS0=+pKF=VH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C52FC74A35
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 20:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BF1F208E4
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 20:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562790872;
	bh=p8lTAdy9Dw7yYQYivprX1MC6WmdEbIB5xt84U0h/OyQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=NwElhGEjF1phMOp3fj0No5ECYgZPGUdjNpF/vKRGmzO7lwM/ONS1VKHCxTJ1Wf584
	 BA6dRvplDbt0EPCVMixj9U7O/KC9tFYkZLQBmzdfuivtiCUNmRkHWEi118jg9Zjyyu
	 yH7GGjb3Oxl7kt5mrIuhWdRkJ0rxwH8kLSNqakI8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfGJUeb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Jul 2019 16:34:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbfGJUeb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jul 2019 16:34:31 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7904B208C4;
        Wed, 10 Jul 2019 20:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562790870;
        bh=p8lTAdy9Dw7yYQYivprX1MC6WmdEbIB5xt84U0h/OyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lfb9pa60q496yHI3XOArioGoiwiRfVfWThAMS++R1aSfxRxrzpSH/++H6NPaxBF/m
         Hc6s3A1+3PdZn9H4HHMbn4i6bIvGtW65eCtMfN1pQ+t37oOVibe573MdYYFLhBoHuj
         3QB+ExojtD602Zqg92T3CUm7oOo/VYbsCTevGHNQ=
Date:   Wed, 10 Jul 2019 13:34:29 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gary R Hook <ghook@amd.com>
Cc:     "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Subject: Re: [PATCH v2] crypto: ccp - memset structure fields to zero before
 reuse
Message-ID: <20190710203428.GC83443@gmail.com>
Mail-Followup-To: Gary R Hook <ghook@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
References: <20190710000849.3131-1-gary.hook@amd.com>
 <20190710015725.GA746@sol.localdomain>
 <2875285f-d438-667e-52d9-801124ffba88@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2875285f-d438-667e-52d9-801124ffba88@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 10, 2019 at 03:59:05PM +0000, Gary R Hook wrote:
> On 7/9/19 8:57 PM, Eric Biggers wrote:
> > On Wed, Jul 10, 2019 at 12:09:22AM +0000, Hook, Gary wrote:
> >> The AES GCM function reuses an 'op' data structure, which members
> >> contain values that must be cleared for each (re)use.
> >>
> >> This fix resolves a crypto self-test failure:
> >> alg: aead: gcm-aes-ccp encryption test failed (wrong result) on test vector 2, cfg="two even aligned splits"
> >>
> >> Fixes: 36cf515b9bbe ("crypto: ccp - Enable support for AES GCM on v5 CCPs")
> >>
> >> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> > 
> > FYI, with this patch applied I'm still seeing another test failure:
> > 
> > [    2.140227] alg: aead: gcm-aes-ccp setauthsize unexpectedly succeeded on test vector "random: alen=264 plen=161 authsize=6 klen=32"; expected_error=-22
> > 
> > Are you aware of that one too, and are you planning to fix it?
> > 
> > - Eric
> > 
> 
> I just pulled the latest on the master branch of cryptodev-2.6, built, 
> booted, and loaded our module. And I don't see that error. It must be new?

Did you have CONFIG_CRYPTO_MANAGER_EXTRA_TESTS enabled?  This failure was with a
test vector that was generated randomly by the fuzz tests, so
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y is needed to reproduce it.

You probably just need to update ccp_aes_gcm_setauthsize() to validate the
authentication tag size.

> 
> In any event, if a test failure occurs, it gets fixed.
> 

Good to hear.

- Eric
