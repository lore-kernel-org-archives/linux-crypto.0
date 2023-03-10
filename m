Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E861C64EC4
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Mar 2023 16:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbjCJQWx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Mar 2023 11:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbjCJQW0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Mar 2023 11:22:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DB09EC8
        for <linux-crypto@vger.kernel.org>; Fri, 10 Mar 2023 08:18:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 937CAB82294
        for <linux-crypto@vger.kernel.org>; Fri, 10 Mar 2023 16:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551D9C433D2
        for <linux-crypto@vger.kernel.org>; Fri, 10 Mar 2023 16:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678465098;
        bh=+h2abdH7n7pFyTCttEwmQkQnxL7n4vcNDy0esZY4iVU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MjZ/Wq7Az9MYEpFE5IgsJsIdQUx2jmbzp7dqOw194AS3z8+6oKdv5HjOTizqHtitz
         dmBj7QyKemvI/+0nX82Y8aFWPLbPU4L8Obr0FqEtLjPO0c+VJ8JVSInt7V7zeFHYJU
         YXj6GkGSMaKZXv1ITjCTmXiiSZvNU/FXJXhOK17pckQLXKiZK2RHZi+Q2szCqIBpuh
         7Z+mwl+nL51//z0spwm0W0R1gi4DXQddS8jfqea5Pok4igsr/FjvtDQIT4VrhBinHI
         GGnBwOh2Pky9EmXM8ZzkBU97Oe5fKB+/k70dw+VM0Hv5dFsLtJ7Z4Yjl2MnjGzfcdc
         bZZ+/lAVZmWag==
Received: by mail-lj1-f175.google.com with SMTP id z42so5806730ljq.13
        for <linux-crypto@vger.kernel.org>; Fri, 10 Mar 2023 08:18:18 -0800 (PST)
X-Gm-Message-State: AO0yUKUIyR+YQRDem56ekLAd9q+ZU+XHcE5/VzZmwyI1KYIEAzPazTww
        zqmTGFxyLaULPZ+PdCJrZ32fLerqCORlSpjOrO4=
X-Google-Smtp-Source: AK7set9skecbzGMncFJHW2kGi9GEz2iyrrh1tYvEBj0wDr8KRoeTxH2cQl0qUZVcTa1wHEwpn/UOkIzFBZ2QN/FCJKM=
X-Received: by 2002:a2e:a228:0:b0:295:8918:9d77 with SMTP id
 i8-20020a2ea228000000b0029589189d77mr8195640ljm.2.1678465096419; Fri, 10 Mar
 2023 08:18:16 -0800 (PST)
MIME-Version: 1.0
References: <20230217144348.1537615-1-ardb@kernel.org> <Y/L6rSGDidhhWq2v@gondor.apana.org.au>
 <CAMj1kXE8ZjVh=hLVgnRGr8cJpkqzRHsVxuq3dm1P=Aqc1QpcXg@mail.gmail.com> <ZAsDT00Jgs2p6luL@gondor.apana.org.au>
In-Reply-To: <ZAsDT00Jgs2p6luL@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 10 Mar 2023 17:18:05 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHhF7CyeGV2QHu6MRVQNKo1EHFkshewOfptEOdJ5znJDA@mail.gmail.com>
Message-ID: <CAMj1kXHhF7CyeGV2QHu6MRVQNKo1EHFkshewOfptEOdJ5znJDA@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: lib - implement library version of AES in CFB mode
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 10 Mar 2023 at 11:15, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Feb 20, 2023 at 08:28:05AM +0100, Ard Biesheuvel wrote:
> >
> > We would still not have any in-tree users of cfb(aes) or any other
> > cfb(*), so in that sense, yes.
> >
> > However, skciphers can be called from user space, and we also rely on
> > this template for the extended testing of the various cfb() hardware
> > implementations that we have in the tree.
> >
> > So the answer is no, I suppose. I would like to simplify it a bit,
> > though - it is a bit more complicated than it needs to be.
>
> Could we hold onto this for a little bit? I'd like to finally
> remove crypto_cipher, and in doing so I will add a virtual address
> interface (i.e., not sg) to skcipher like we do with scomp and shash.
>

Does that mean you are bringing back blkcipher? I think that would the
right thing to do tbh, although it might make sense to enhance
skcipher (and aead) to support this.

Could we perhaps update struct skcipher_request so it can describe
virtually mapped address ranges, but permit this only for synchronous
implementations? Then, we could update the skcipher walker code to
produce a single walk step covering the entire range, and just use the
provided virtual addresses directly, rather than going through a
mapping interface?
