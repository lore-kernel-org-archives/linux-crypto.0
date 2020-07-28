Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36FAAC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 17:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FD3520825
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 17:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595956764;
	bh=3IPvPPUwh/V5phVrdIt3i+dOW1vDse+nM3m3QLusr8k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=a5u3BCr4MJrln/XG3AQ4znaN7Lu/rEg+EJ+fom/RrjdMLiJzDQuOYg9Pula/a7nCj
	 oufC8H5YJZsi++4g7qa8sPtDksEUirmM8uom8bSHnzzO9DsDf8w5Q/DRcKuf7YdDJM
	 a1Q+VH2ENjt6d0GUT6He4uV6hxczGbDMC/9nxBjs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731935AbgG1RTX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 13:19:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731903AbgG1RTX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 13:19:23 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C24F920809;
        Tue, 28 Jul 2020 17:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595956762;
        bh=3IPvPPUwh/V5phVrdIt3i+dOW1vDse+nM3m3QLusr8k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DIVjKZ+LWRi04DGLfkRWx9bxABM7YlvrHWgVB84qhou2jbPWp84SllEFt6R/tpisf
         XdNgBuEtwtmU3F/rNjsrMDR7XQpqWP6TtexlrhLoy28dcenNna3jsVbfBseWwUa8el
         NTsf6Em76wqWer3xA57PlM+UhDOHQh7gY6XtmNz0=
Date:   Tue, 28 Jul 2020 10:19:21 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v3 PATCH 0/31] crypto: skcipher - Add support for no chaining
 and partial chaining
Message-ID: <20200728171921.GC4053562@gmail.com>
References: <20200728071746.GA22352@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728071746.GA22352@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 28, 2020 at 05:17:46PM +1000, Herbert Xu wrote:
> This patch-set adds support to the Crypto API and algif_skcipher
> for algorithms that cannot be chained, as well as ones that can
> be chained if you withhold a certain number of blocks at the end.
> 
> The vast majority of algorithms can be chained already, e.g., cbc
> and lrw.  Everything else can either be modified to support chaining,
> e.g., chacha and xts, or they cannot chain at all, e.g., keywrap.
> 
> Some drivers that implement algorithms which can be chained with
> modification may not be able to support chaining due to hardware
> limitations.  For now they're treated the same way as ones that
> cannot be chained at all.
> 
> The algorithm arc4 has been left out of all this owing to ongoing
> discussions regarding its future.
> 

Can you elaborate on the use case for supporting chaining on algorithms that
don't currently support it?

Also, the self-tests need to be updated to test all this.

- Eric
