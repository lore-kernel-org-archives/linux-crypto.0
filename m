Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD196C433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  2 May 2022 18:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241853AbiEBSLz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 May 2022 14:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238752AbiEBSLz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 May 2022 14:11:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C950D2AD7
        for <linux-crypto@vger.kernel.org>; Mon,  2 May 2022 11:08:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 529B36143F
        for <linux-crypto@vger.kernel.org>; Mon,  2 May 2022 18:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587C2C385AC;
        Mon,  2 May 2022 18:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651514904;
        bh=AIZfpmMXV7aBgF8mEs9CKybKyqea+iHrJTfw+3yuRfU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hqmKUpMN6wHUEcSmX3QIdTRvUdftdsWeU1kVGa+6IsUsooocap7rfIGaVLVFTj9E0
         SYS/66qKjrioWocACR/fM+z5c8mkhTvzcB6CsRnZZp4LkatGEe92hIWQsIRaACp5Wp
         Llw7TDrhCNuaFEolwVabCLDl2Lr5SJI0Pg9PoFxSRebuofy3qo3OiQDIfxQNokzgA7
         MqLYPzcNG4GHDRVT9qxWj6iaxH5s3uptSgZZMNVI6kwra0RtiwxMYUGF/er4l3YLOY
         vI8vLxOjgKruA0rD7BrwNoalNm4S3e86OnbIlxJZ6ft4rqotMRkJlZvRi/UWwbJcsJ
         pd35JwamnpKQQ==
Date:   Mon, 2 May 2022 11:08:22 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        linux-fscrypt.vger.kernel.org@google.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v5 6/8] crypto: x86/polyval: Add PCLMULQDQ accelerated
 implementation of POLYVAL
Message-ID: <YnAeFluc6G7hJ1pT@sol.localdomain>
References: <20220427003759.1115361-1-nhuck@google.com>
 <20220427003759.1115361-7-nhuck@google.com>
 <Ym7w47ngugGohQE/@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ym7w47ngugGohQE/@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, May 01, 2022 at 01:43:23PM -0700, Eric Biggers wrote:
> > diff --git a/include/crypto/polyval.h b/include/crypto/polyval.h
> > index b14c38aa9166..bf64fb6c665f 100644
> > --- a/include/crypto/polyval.h
> > +++ b/include/crypto/polyval.h
> > @@ -8,10 +8,19 @@
> >  #ifndef _CRYPTO_POLYVAL_H
> >  #define _CRYPTO_POLYVAL_H
> >  
> > +#include <crypto/gf128mul.h>
> 
> <crypto/gf128mul.h> doesn't appear to be needed here.
> 

It looks like the issue is that this patch removes <crypto/gf128mul.h> from
crypto/polyval-generic.c.  If you just don't do that, then it won't be needed
here.

- Eric
