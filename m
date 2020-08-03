Return-Path: <SRS0=sEgb=BN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D0DC433E1
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Aug 2020 15:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3712620678
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Aug 2020 15:30:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VxDfE4Lh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgHCPaf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Aug 2020 11:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgHCPae (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Aug 2020 11:30:34 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64370C06174A
        for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2020 08:30:34 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id f68so9558122ilh.12
        for <linux-crypto@vger.kernel.org>; Mon, 03 Aug 2020 08:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1gpaqMfM1RaEdZU6qCKEYFsVmVbfEOCw+45iqyc8K0Y=;
        b=VxDfE4LhW2UCDyGQ10ukZMQFod761jShnvEByqlHJV3QS60i6yWL9oTsK3ivUeTcBm
         UUsD96PVdAPqGph/KvrMUD4D+mHIYRBTjhHvGfHMlTHlMz4WP5hsIvl2VUTDR+y0UoYb
         sUiqoXtkS6tnPLMwEPiTMM8FNu0SCWG6uwU7mQ6WAB2U6zbOZqQAV6V9gHYH5KkUbicy
         hdW9rM36v0a8WlnTkHGHdL53obPNd/GVUmesTvfkwkzNHnilpe/WpcMS9FhfKMtaPaFr
         EpYYk0o2Jjhb8ZtsYWYwQAWUXC7Fs55ZAmH5lYWd8gCsKdoHHZbzxfLSsRzc1TB6LvOn
         btnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1gpaqMfM1RaEdZU6qCKEYFsVmVbfEOCw+45iqyc8K0Y=;
        b=e5pP9heY1hzg/qvVfqcJVVCEe6nc3SsO5HLVtjJ0O67d8aSeNnlq95MQCJRd0za5Eo
         K9r5SVevV9uw7EmGm45PqPUFWH4Ofqy8TFJJ+/oAq0uG2fKNxFOIT678YjmKFcGSPgzq
         7/Ynb7/3xwRIU2SzWfavP226KPw8y6Rxli14DDenUTasg1EFQ3zQ0KCERFd/V6rSIjQ0
         wv3WIrcXBiI38pokGxOBSLzgel3LKM6TlrU0KgoAnDuoyTlSO9v80h3A6ae1miLbN/OA
         Z777Bvv/ntQQmJ+QSxHBSdqbtjGdLZG/jetLAHttMTlATYdFTBbozC6lHpfW5YXyfCJz
         CACQ==
X-Gm-Message-State: AOAM533Akgsv/n/3xr8XGtFoqpsoNuTcw1phQNG3jcKyKbcFZcKYUNhu
        x4ifBLZsReu7e76cUWCzZYiA0HH3UokxW54e7TYJew==
X-Google-Smtp-Source: ABdhPJwPifMcxuTs6houKPzYWXUvbD0rJqsshB2W3l1T0mmCmIYnFUmDuKSvD6oi3t0AFzu99D1ceCUC77jzJ+3ym90=
X-Received: by 2002:a92:354d:: with SMTP id c74mr16610554ila.27.1596468633405;
 Mon, 03 Aug 2020 08:30:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200729154501.2461888-1-lenaptr@google.com> <20200731072338.GA17285@gondor.apana.org.au>
 <CABvBcwY-F6Euo2SAY6MKpT0KP7OtyswLhUmShPNPfB0qqL6heQ@mail.gmail.com> <4818892.iTQEcLzFEP@tauon.chronox.de>
In-Reply-To: <4818892.iTQEcLzFEP@tauon.chronox.de>
From:   Elena Petrova <lenaptr@google.com>
Date:   Mon, 3 Aug 2020 16:30:21 +0100
Message-ID: <CABvBcwaV0FdSeEz1ddW3yGwcbOOOVy-3jL32futGrtDWc506vg@mail.gmail.com>
Subject: Re: [PATCH v4] crypto: af_alg - add extra parameters for DRBG interface
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jeffrey Vander Stoep <jeffv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

On Mon, 3 Aug 2020 at 16:10, Stephan Mueller <smueller@chronox.de> wrote:
>
> Am Montag, 3. August 2020, 16:48:02 CEST schrieb Elena Petrova:
>
> Hi Elena,
>
> > On Fri, 31 Jul 2020 at 08:27, Herbert Xu <herbert@gondor.apana.org.au>
> wrote:
> > > Eric Biggers <ebiggers@kernel.org> wrote:
> > > > lock_sock() would solve the former.  I'm not sure what should be done
> > > > about
> > > > rng_recvmsg().  It apparently relies on the crypto_rng doing its own
> > > > locking, but maybe it should just use lock_sock() too.
> > >
> > > The lock_sock is only needed if you're doing testing.  What I'd
> > > prefer is to have a completely different code-path for testing.
> >
> > sendmsg is used for "Additional Data" input, and unlike entropy, it
> > could be useful outside of testing. But if you confirm it's not
> > useful, then yes, I can decouple the testing parts.
>
> Nobody has requested it for now - so why not only compiling it when the DRBG
> test config value is set? If for some reason there is a request to allow
> setting the additional data from user space, we may simply take the ifdef
> away.
>
> My approach is to have only interfaces into the kernel that are truly
> requested and needed.

Ok, makes sense, thanks!

> Ciao
> Stephan
>
>
