Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 299ACC10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 18:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E72C720693
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 18:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555612910;
	bh=l8sd8IrFb97v66DXGn62OiCWseCv3cwAKFKKaH3HMFE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=IfWZJUnDBrQB16WRU/YziCcONZRoWXaA4MH/QKsz5OPgkr/VSv/tkFRZXzHqJ3hWw
	 kVj6LuPJtYMrJS20nRKSxIDwdTUOXjpPUGXPhjnq+tt7PqEgFFQV1Jw4Sne384XjQZ
	 KKg5r5WSB/ARX3WGu4mz37c4O+w9LY9LRGm10NL8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389770AbfDRSls (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 14:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388819AbfDRSls (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 14:41:48 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 011802064A;
        Thu, 18 Apr 2019 18:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555612908;
        bh=l8sd8IrFb97v66DXGn62OiCWseCv3cwAKFKKaH3HMFE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=13FCgvmutbVraTzzdXxz0YCU4SmMdjb1+/cCl/50in0X79iGdNQ6KyJcD/ou1erYc
         pANEKjvkX1L3bZaqq+z001Cs+SS+jOuNaeXFt1BDViD2IanyYOFoHXH+E3tOQPF9wq
         C/S+FtaBODSSUwqkMXphp9RfChrfMd2kQJ5+qhew=
Date:   Thu, 18 Apr 2019 11:41:46 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 5/7] crypto: gcm - fix incompatibility between "gcm"
 and "gcm_base"
Message-ID: <20190418184145.GB1827@sol.localdomain>
References: <20190410064635.11813-6-ebiggers@kernel.org>
 <20190418140006.x3aaja7vvntu6p5p@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190418140006.x3aaja7vvntu6p5p@gondor.apana.org.au>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 18, 2019 at 10:00:06PM +0800, Herbert Xu wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > @@ -638,7 +637,7 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
> >                goto err_free_inst;
> > 
> >        err = -EINVAL;
> > -       if (ghash->digestsize != 16)
> > +       if (strcmp(ghash->base.cra_name, "ghash") != 0)
> >                goto err_drop_ghash;
> 
> We should keep both tests because the self-tests can be compiled
> out so there is no guarantee that something claiming to be ghash
> actually is ghash.
> 

I'm not necessarily opposed to doing this, but if we're assuming that untested,
arbitrarily broken algorithms may be registered with the crypto API under any
name, "ghash" could easily still be broken even if it declares a 16-byte digest
size.  Verifying the digest size is just an extra sanity check; we're really
still relying on the implementation to be correct.  (Same for the ccm patch.)

- Eric
