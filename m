Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21C8C61DA4
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Mar 2023 08:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjCKIm0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Mar 2023 03:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjCKImZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Mar 2023 03:42:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E433712E157
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 00:42:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F036B80315
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 08:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A712C4339E
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 08:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678524140;
        bh=NfzeRCBt8y1/S0dXQt9hiXH0wK/TyCCUYfE9y9hYTFg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=r8gbJdJmzACvvgyL6g9VI99gYujEaqnJxOOxzmHHOBsmztmc3KxP7cbgRhHkP1IwW
         BeBZUcmI004lyVoK75ygAzUPKwYz9LbT46vIiywpo3UQgNm1U87AVNS8jcfySDERb5
         1Nn+W/C5uHT7/CdS7TE/ltVJMvP/U1wH+Mmn5ThNDIt25R5UdjED9kIIpi+lvQJYVe
         R/4kaLY/nyREtR9XLSBpAklmPkhv9dnVvGUXK+5zUVtvnpA5Tgklqxyi/YvZ4GF+QV
         fAaUAub9RYnHJTAAUBmyjVjdJZ7thP06eLJyey1ngJ9GTsK4AGLvL1didDaRWXyw4n
         MMBh8ii9c3Btw==
Received: by mail-lj1-f176.google.com with SMTP id y14so7749209ljq.4
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 00:42:20 -0800 (PST)
X-Gm-Message-State: AO0yUKWzwnOctzk0t9dabQGsqtOrNfo3X4Gt8MFzN/zsiPXymknpmYEt
        5gG3slY/42BxvTnhjCzD+s09jpA8+MYwLWXrABA=
X-Google-Smtp-Source: AK7set+qdG2fztXylZgBZqPC5NvqxKpyC0sYv/P9Iml1CeMrCMJws3pXERVPUhHKTcwCc4mqFFS2d6tGsnd/oFohlSY=
X-Received: by 2002:a2e:a912:0:b0:293:4ba5:f626 with SMTP id
 j18-20020a2ea912000000b002934ba5f626mr1891889ljq.2.1678524138032; Sat, 11 Mar
 2023 00:42:18 -0800 (PST)
MIME-Version: 1.0
References: <20230217144348.1537615-1-ardb@kernel.org> <Y/L6rSGDidhhWq2v@gondor.apana.org.au>
 <CAMj1kXE8ZjVh=hLVgnRGr8cJpkqzRHsVxuq3dm1P=Aqc1QpcXg@mail.gmail.com>
 <ZAsDT00Jgs2p6luL@gondor.apana.org.au> <CAMj1kXHhF7CyeGV2QHu6MRVQNKo1EHFkshewOfptEOdJ5znJDA@mail.gmail.com>
 <ZAw2eHDQELdiVXcZ@gondor.apana.org.au> <CAMj1kXGC81=z_h-gcdQ0OoNA01kSAJz58QNiB1ixCPFA0_YnUw@mail.gmail.com>
 <ZAw5Ffv7X2mNmbG8@gondor.apana.org.au>
In-Reply-To: <ZAw5Ffv7X2mNmbG8@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 11 Mar 2023 09:42:06 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEr8W1NP0Xcny7ed1xb7ofb7Y6R57TPNe6=jAASDzHzKw@mail.gmail.com>
Message-ID: <CAMj1kXEr8W1NP0Xcny7ed1xb7ofb7Y6R57TPNe6=jAASDzHzKw@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: lib - implement library version of AES in CFB mode
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 11 Mar 2023 at 09:17, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Sat, Mar 11, 2023 at 09:15:42AM +0100, Ard Biesheuvel wrote:
> >
> > Doesn't that depend on the implementation? It might have a >0 size
> > request context size, no? Or do we just allocate that on the stack?
>
> Do you have a concrete example of something that needs this?
> Is this a temporary scratch buffer used only during computation?
>

Every call to crypto_skcipher_set_reqsize(), no?
