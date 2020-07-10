Return-Path: <SRS0=tT4M=AV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E6A4C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 06:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E1D42077D
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 06:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594362246;
	bh=0iudI8GItJrjboxkecmA5wcRisuExIGeLK0OikBUx2g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=0P/iw14dH/RPwYdwX8tSu+g3Od0TgFBiyUHNqJbLDUxS7lCBcnTJJjxG8lBlRx9PF
	 eCtSeagVO4nItzHP63RxLAwQSk22PDr53wWmjGiYQYNN5UZFzKALKSyk7YDNqCDNmc
	 NY4p+g8uEgNlSQqExzVJxS3C6haj9JGPcx44M4DY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgGJGYF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jul 2020 02:24:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbgGJGYE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jul 2020 02:24:04 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AF8B2072E;
        Fri, 10 Jul 2020 06:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594362244;
        bh=0iudI8GItJrjboxkecmA5wcRisuExIGeLK0OikBUx2g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LpdmIhXmFiuEbie6AAlWUDBl3zIcto5YvzHODWR2P0zFp2/LziAW5vv0BTRau+AFN
         h9YNpOiuefsS0TJf5+Vq3FqNdckuV6Erx/YaFS2Ovyk/1eoxMUqdOqaMCZSNYvMQtG
         rm+ssYcCs475o1uK3f2foe7/TuAfbREm4MtgnokU=
Date:   Thu, 9 Jul 2020 23:24:03 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     mpatocka@redhat.com, linux-crypto@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [PATCH 2/6] crypto: algapi - use common mechanism for inheriting
 flags
Message-ID: <20200710062403.GB2805@sol.localdomain>
References: <20200701045217.121126-3-ebiggers@kernel.org>
 <20200709053126.GA5510@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709053126.GA5510@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 09, 2020 at 03:31:26PM +1000, Herbert Xu wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > @@ -875,14 +873,21 @@ static void cbcmac_exit_tfm(struct crypto_tfm *tfm)
> > 
> > static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
> > {
> > +       struct crypto_attr_type *algt;
> >        struct shash_instance *inst;
> >        struct crypto_cipher_spawn *spawn;
> >        struct crypto_alg *alg;
> > +       u32 mask;
> >        int err;
> > 
> > -       err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH);
> > -       if (err)
> > -               return err;
> > +       algt = crypto_get_attr_type(tb);
> > +       if (IS_ERR(algt))
> > +               return PTR_ERR(algt);
> > +
> > +       if ((algt->type ^ CRYPTO_ALG_TYPE_SHASH) & algt->mask)
> > +               return -EINVAL;
> > +
> > +       mask = crypto_algt_inherited_mask(algt);
> 
> How about moving the types check into crypto_algt_inherited_mask,
> e.g.,
> 
> 	u32 mask;
> 	int err;
> 
> 	err = crypto_algt_inherited_mask(tb, CRYPTO_ALG_TYPE_SHASH);
> 	if (err < 0)
> 		return err;
> 
> 	mask = err;
> 
> This could then be used to simplify other templates too, such as
> gcm.
> 

I decided to make crypto_check_attr_type() return the mask instead, and do so
via a pointer argument instead of the return value (so that we don't overload an
errno return value and prevent flag 0x80000000 from working).
Please take a look at v2.  Thanks!

- Eric
