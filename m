Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD50C61DA4
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Mar 2023 09:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbjCKJCS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Mar 2023 04:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCKJCR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Mar 2023 04:02:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA30134AD9
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 01:02:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26E1060A2A
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 09:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874A2C4339C
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 09:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678525334;
        bh=J4WKdLkDNVjkQ6fyMAemQNH7XXbJFT+5E+yEwAMEe5c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PEDtdlF284BfHQbFwcaSqpJ9d6baKZ9C0B9JBB95Dx/nnFDP5Xu1Ipm8RxuPhILmR
         QAtBzxripSp981WFU8Sy2D/HFN5B2emIFvV9/181Q+KB8ZPklWSZHDs8e8pcFFT+a4
         8HbexWlZm8wdFmEQZGC/VxP9nqha9bSO1EAxSK3KFS+Hxs6hbt5OkR14gITSg1wstP
         mr75oUdf/+i9zBEd5E5kLMZdSulvbYn+HoyEcFDCoYWHT5AanUZAju3PEw7FHbSk9i
         yNBu0PDuSeUJnV8ZkNOvzynU7Ut8rkki3laInwrz2f+UjoHu6Bo8rFJ6z9Ps4ZKHNF
         50r+6hsoxPS2Q==
Received: by mail-lj1-f175.google.com with SMTP id y14so7777576ljq.4
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 01:02:14 -0800 (PST)
X-Gm-Message-State: AO0yUKULPc1p+EbnpXg1KJfpUxyX7fcMfnbQCmbtwtmcb8SP+AmtuXIk
        xsiL2y6GBiq5+k+iyBflHTxVanQVZ3dvMqd/NqQ=
X-Google-Smtp-Source: AK7set9vtcwyZSk4EastX5sV33V0WFun2KWhCw9izbCFRp93Z8Jm6eZ0mJFuKt8kTJqNWYTcQvapMt2mQGUfF7O07cI=
X-Received: by 2002:a2e:a268:0:b0:295:ba26:8ad4 with SMTP id
 k8-20020a2ea268000000b00295ba268ad4mr8776912ljm.2.1678525332553; Sat, 11 Mar
 2023 01:02:12 -0800 (PST)
MIME-Version: 1.0
References: <Y/L6rSGDidhhWq2v@gondor.apana.org.au> <CAMj1kXE8ZjVh=hLVgnRGr8cJpkqzRHsVxuq3dm1P=Aqc1QpcXg@mail.gmail.com>
 <ZAsDT00Jgs2p6luL@gondor.apana.org.au> <CAMj1kXHhF7CyeGV2QHu6MRVQNKo1EHFkshewOfptEOdJ5znJDA@mail.gmail.com>
 <ZAw2eHDQELdiVXcZ@gondor.apana.org.au> <CAMj1kXGC81=z_h-gcdQ0OoNA01kSAJz58QNiB1ixCPFA0_YnUw@mail.gmail.com>
 <ZAw5Ffv7X2mNmbG8@gondor.apana.org.au> <CAMj1kXEr8W1NP0Xcny7ed1xb7ofb7Y6R57TPNe6=jAASDzHzKw@mail.gmail.com>
 <ZAxAK2rlOsQjlgB9@gondor.apana.org.au> <CAMj1kXG_27v0YXoO_8Avjcz=YtYhCfX_6pcXowk0fy5cYR6gVw@mail.gmail.com>
 <ZAxDOhfuSTsgncMU@gondor.apana.org.au>
In-Reply-To: <ZAxDOhfuSTsgncMU@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 11 Mar 2023 10:02:01 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHdNZ-=3-VuerRVWiRYixFf8KoeFk54Gz=09aV9Wwtdsg@mail.gmail.com>
Message-ID: <CAMj1kXHdNZ-=3-VuerRVWiRYixFf8KoeFk54Gz=09aV9Wwtdsg@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: lib - implement library version of AES in CFB mode
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 11 Mar 2023 at 10:00, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Sat, Mar 11, 2023 at 09:55:15AM +0100, Ard Biesheuvel wrote:
> >
> > That way, the implementations can remain the same,
>
> That's like doing a house renovation and keeping the scaffold
> around forever :)
>
> Yes I agree that it would save a little bit of work for now but
> all the implementations would have to carry this unnecessary
> walking code with them forever.
>
> With a setup like ahash/shash the walking code disappears totally
> from the underlying implementations.
>

So we are basically going back to ablkcipher/blkcipher then? How about aead?
