Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C149C433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Feb 2021 00:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E054564D9D
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Feb 2021 00:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhBEA05 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 19:26:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:56670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231922AbhBEA04 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 19:26:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90E5A64D9D;
        Fri,  5 Feb 2021 00:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612484775;
        bh=leZEpI4tCbCaIcMRqiMOvFUKRIKm1hwWHpDcUc3Hyew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uWgZGLa6VR1Mty6aqa7qwwo12eQtntAaYwA2MJoYK2F6O/ahDB2GevWUOWuZSjuyR
         iaLKcWs06tkiewx7woo0aUrRg4ZfSgZbbsH/JM+v3kRw1URyZvEARhA6PauvR0789x
         d7A87g1JA4aDGsCCZSGsP22zFSRIDRB7kXqkRBVTsI6R5jR6n8i+dWGVNoWEKGNifo
         NgsI0jR5oIsIWE0/8qN6J9IgTfCNQDQLd+24I+qu7GzC9ptxJ1g3Dc7B6BvbvQmpVL
         M3M9xU0knt5ykidCH+BLwbOpLclspcuQA5UB54a+nKeT9g+6zouS04XJGgx60xBlBO
         mq6VQfFjMHOWg==
Date:   Thu, 4 Feb 2021 16:26:13 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org, ardb@kernel.org,
        sivaprak@codeaurora.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 05/11] crypto: qce: skcipher: Return error for zero
 length messages
Message-ID: <YByQpRG0SC0k0gYC@gmail.com>
References: <20210204214359.1993065-1-thara.gopinath@linaro.org>
 <20210204214359.1993065-6-thara.gopinath@linaro.org>
 <YBx5yWhKtT2EC2Ce@gmail.com>
 <00d759f3-8ea3-1f85-b623-225c372c0a04@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00d759f3-8ea3-1f85-b623-225c372c0a04@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 04, 2021 at 07:09:53PM -0500, Thara Gopinath wrote:
> > > @@ -260,6 +261,10 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
> > >   	rctx->flags |= encrypt ? QCE_ENCRYPT : QCE_DECRYPT;
> > >   	keylen = IS_XTS(rctx->flags) ? ctx->enc_keylen >> 1 : ctx->enc_keylen;
> > > +	/* CE does not handle 0 length messages */
> > > +	if (!req->cryptlen)
> > > +		return -EOPNOTSUPP;
> > > +
> > 
> > For the algorithms in question, the correct behavior is to return 0.
> 
> What do you mean? The driver should return a 0 ?

Yes, there is nothing to do for empty inputs, so just return 0 (success).

> > Aren't the tests catching that difference?
> 
> I was anyways planning on sending an email to the list with these queries.
> But since you asked,  these are my observations with fuzz testing which I
> have been doing quite a bit now (I am also working on adding a few qualcomm
> AEAD algorithms support in mainline).
> 
> - if the generic algorithm supports 0 length messages and the transformation
> I am testing does not, the test framework throws an error and stops.
> - key support mismatch between the generic algorithm vs my algorithm /engine
> also does the same thing.For eg, Qualcomm CE engine does not support any
> three keys being same for triple des algorithms. Where as a two key 3des is
> a valid scenario for generic algorithm(k1=k3). Another example is hardware
> engine not supporting AES192.
> 
> How are these scenarios usually handled ? Why not allow the test framework
> to proceed with the testing if the algorithm does not support a particular
> scenario ?

Omitting support for certain inputs isn't allowed.  Anyone in the kernel who
wants to use a particular algorithm could get this driver for it, and if they
happen to use inputs which the driver decided not to support, things will break.

The way that drivers handle this is to use a fallback cipher for inputs they
don't support.

- Eric
