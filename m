Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 968F0C61DA4
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Mar 2023 09:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjCKJ0f (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Mar 2023 04:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjCKJ0I (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Mar 2023 04:26:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2009114E8B
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 01:26:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACE5560AB1
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 09:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1414EC4339C
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 09:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678526762;
        bh=Sn0aGFUAOuXSJrGbqsmKe+vsf+Ufy/4xLQ3omBLN9i8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ULdY5Dm28KW/qAC9EwB+fy/kh8j+FK0rDnFOyrWxuEegBkw0jvb9DwR1I7Ng6o3PW
         vtV230hVd/49PySXmeJL8B+JxjmX3ZbrjPszyYrgo1AjCGfCtCHt/ZEkSnzzCgLijX
         MfTjYM/7XULFzqquS5y3DWE7xUTO8FKcQgjZNeiSqZoqvqVnKvr8WJ5WlO8Bw4E6Yi
         iYfbc0MGQzNS370RNpAmG5oTVnTEJKpyayxx+JVrB7CDNpWaczmWwIux2NCeANcS4K
         tbyKrBDSgxFLWkEoxCSnh+j6hQxuWwxRQqYHySsD81VxKCmjoX5UuJ6i683WBWqQPq
         y84z8GPnoI40Q==
Received: by mail-lj1-f172.google.com with SMTP id z42so7760037ljq.13
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 01:26:01 -0800 (PST)
X-Gm-Message-State: AO0yUKXeAL5DOcpF+OICXWJ5YsSLAJMYyotKkdABsaG9JMElM8AcpLAS
        fqI6PUG/FdwJqx0E+uCEnPfTQux+ZWUIeC/MU2c=
X-Google-Smtp-Source: AK7set8DeLz9TIH99P6MLyzdQp6uWiZET0tZTAi8pQ4KbEJXeXImazFdv+GbsUY3dWKrYjStWmf6b92UTnDSsaMS/5U=
X-Received: by 2002:a2e:b550:0:b0:295:acea:5875 with SMTP id
 a16-20020a2eb550000000b00295acea5875mr1629806ljn.2.1678526760114; Sat, 11 Mar
 2023 01:26:00 -0800 (PST)
MIME-Version: 1.0
References: <ZAsDT00Jgs2p6luL@gondor.apana.org.au> <CAMj1kXHhF7CyeGV2QHu6MRVQNKo1EHFkshewOfptEOdJ5znJDA@mail.gmail.com>
 <ZAw2eHDQELdiVXcZ@gondor.apana.org.au> <CAMj1kXGC81=z_h-gcdQ0OoNA01kSAJz58QNiB1ixCPFA0_YnUw@mail.gmail.com>
 <ZAw5Ffv7X2mNmbG8@gondor.apana.org.au> <CAMj1kXEr8W1NP0Xcny7ed1xb7ofb7Y6R57TPNe6=jAASDzHzKw@mail.gmail.com>
 <ZAxAK2rlOsQjlgB9@gondor.apana.org.au> <CAMj1kXG_27v0YXoO_8Avjcz=YtYhCfX_6pcXowk0fy5cYR6gVw@mail.gmail.com>
 <ZAxDOhfuSTsgncMU@gondor.apana.org.au> <CAMj1kXHdNZ-=3-VuerRVWiRYixFf8KoeFk54Gz=09aV9Wwtdsg@mail.gmail.com>
 <ZAxIKu3t4NJEGz6I@gondor.apana.org.au>
In-Reply-To: <ZAxIKu3t4NJEGz6I@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 11 Mar 2023 10:25:48 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF6_JFMFTqzmXWxM=zJ7HmDqnivAKjUT=pN-34werkd5g@mail.gmail.com>
Message-ID: <CAMj1kXF6_JFMFTqzmXWxM=zJ7HmDqnivAKjUT=pN-34werkd5g@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: lib - implement library version of AES in CFB mode
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 11 Mar 2023 at 10:21, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Sat, Mar 11, 2023 at 10:02:01AM +0100, Ard Biesheuvel wrote:
> >
> > So we are basically going back to ablkcipher/blkcipher then? How about aead?
>
> No I just dug up the old blkcipher code and it's based on SGs
> just like skcipher.
>
> I went back to the beginning of git and we've only ever had
> an SG-based encryption interface.  This would be the very first
> time that we've had this in the Crypto API.
>
> Do we have any potential users for such an AEAD interface?
>

Not sure. I just added the libaesgcm library interface, but that is
used in SMP secondary bringup, so that shouldn't use the crypto API in
any case.

Synchronous AEADs are being used in the wifi code, but I am not aware
of any problematic use cases.

So what use case is the driver for this sync skcipher change? And how
will this work with existing templates? Do they all have to implement
two flavors now?
