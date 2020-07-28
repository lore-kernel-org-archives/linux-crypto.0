Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B5E2C433E3
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 17:15:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DE732083B
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 17:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595956515;
	bh=p+b5rbkmNq4J3RbttJwQWEjgKgPneF3+g2ppzts7L1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=gvhXea+yDbn+E9ecNXk3H28KIR9258VXfdXV8E6QjFYCcthq9JCkflleUSAr4L0OJ
	 ajXGc0Fah3F/dc26USWiyuY0ohIz6ExPpWRfTcDqUTL3SQWfv6+697OocGzL3/LYOV
	 1S9Cfe6dN7uhT7b6TFqHoDJbl3TD08UqfOgU0Z0Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731840AbgG1RPO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 13:15:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731655AbgG1RPO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 13:15:14 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D197D20809;
        Tue, 28 Jul 2020 17:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595956514;
        bh=p+b5rbkmNq4J3RbttJwQWEjgKgPneF3+g2ppzts7L1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nXnw/DK0z4lvc99mPWvLffUX6z7/86fRWKS+9alyVaOYgWyYqDi72k4lMdQNYP6OY
         SdNf0mXIsyDOTvf3Iu7LkzGzrA8uJIsums4e2aP6ghU5D8yaB5u3tUGr9vxKHoO8c1
         n455h4NT0dj5LkaATe4Ss3jqntKGkiFo8q25c9xY=
Date:   Tue, 28 Jul 2020 10:15:12 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v3 PATCH 1/31] crypto: skcipher - Add final chunk size field
 for chaining
Message-ID: <20200728171512.GB4053562@gmail.com>
References: <20200728071746.GA22352@gondor.apana.org.au>
 <E1k0Jsl-0006Ho-Gf@fornost.hmeau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1k0Jsl-0006Ho-Gf@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 28, 2020 at 05:18:39PM +1000, Herbert Xu wrote:
> Crypto skcipher algorithms in general allow chaining to break
> large operations into smaller ones based on multiples of the chunk
> size.  However, some algorithms don't support chaining while others
> (such as cts) only support chaining for the leading blocks.
> 
> This patch adds the necessary API support for these algorithms.  In
> particular, a new request flag CRYPTO_TFM_REQ_MORE is added to allow
> chaining for algorithms such as cts that cannot otherwise be chained.
> 
> A new algorithm attribute final_chunksize has also been added to
> indicate how many blocks at the end of a request that cannot be
> chained and therefore must be withheld if chaining is attempted.
> 
> This attribute can also be used to indicate that no chaining is
> allowed.  Its value should be set to -1 in that case.

Shouldn't chaining be disabled by default?  This is inviting bugs where drivers
don't implement chaining, but leave final_chunksize unset (0) which apparently
indicates that chaining is supported.

- Eric
