Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFB50C433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Feb 2022 13:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbiBBNgK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Feb 2022 08:36:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31321 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229552AbiBBNgJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Feb 2022 08:36:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643808969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Y/tCcKryHNXOhXcpKvt9O1GxoDARflPECbDyG7zIOM=;
        b=Dse7gU8ebueedVq2h1lRJ7XZ2KEda75P28AaU7FVMJUhAsRuQIdy+9pYkmVp8I6MIzfD0i
        RMFevDSjRVlQ2NwL/2M0dh/8IB0GZ2bfeNkQtF84Yc3t95ZF7op/JNnHWVX7rFFnwPnMLl
        5k3D6j7+x3rJrPJdSQastCqnXECP2zs=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-1ctkUoUhOI-9EYjXVZVfYg-1; Wed, 02 Feb 2022 08:36:08 -0500
X-MC-Unique: 1ctkUoUhOI-9EYjXVZVfYg-1
Received: by mail-qt1-f197.google.com with SMTP id c20-20020ac84e14000000b002d198444921so15433083qtw.23
        for <linux-crypto@vger.kernel.org>; Wed, 02 Feb 2022 05:36:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=6Y/tCcKryHNXOhXcpKvt9O1GxoDARflPECbDyG7zIOM=;
        b=mSthlDqRnTB71J+TMvT8RHa+TdIwVRv6yZivmvDJmrFU9gBE/ANXT88k6C2LdSXiu2
         H1jp2/RUR+QKfBr7jZJgvXkrLZnVac++O0vQADGDXiD2gwbfpQyqqsoDNC0eyz2T6gC6
         fHwo0qq/Wu9rJxqTk/xNZ1fIOsUzFWI+CWenMzWODjPh3P2fYemP9qHZM4X5MSZ6tNDb
         viqfj3ppJw8NhtN8p//b1JtGToKFPOhCxou89fhhxNMg3Zk65XpXgKXzByOj9aDswViX
         I1bMUrWP9LssOBObJdr5LgPYNzimol/+rutlDLwfmSatn4CpZ0ZT5un/wgjKo6bfNuBw
         1jjQ==
X-Gm-Message-State: AOAM5324fhlt81sfBh5/InT26oWnMbCmXvZrvAGqRLTlwJzgSmAO/pHz
        09LKCYR+r6pQAyKKkjrmyKF1U+2moY2CScSfH8BFBHmA48SQZf3p4UGGnLCv7jWxnMlgf/EYuGn
        3g6Qs5qG02s8JoGgSSDewJLwT
X-Received: by 2002:a05:6214:e63:: with SMTP id jz3mr26635019qvb.24.1643808967718;
        Wed, 02 Feb 2022 05:36:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwiCnyRwi2H6w6JFHC4Wf9S8I+4E+HaEq5bvxXpGLRZuECjF5NxRRPczuDeTGlK9ad1s6vNFA==
X-Received: by 2002:a05:6214:e63:: with SMTP id jz3mr26635004qvb.24.1643808967488;
        Wed, 02 Feb 2022 05:36:07 -0800 (PST)
Received: from m8.users.ipa.redhat.com (cpe-158-222-141-151.nyc.res.rr.com. [158.222.141.151])
        by smtp.gmail.com with ESMTPSA id s1sm4802575qkp.102.2022.02.02.05.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 05:36:07 -0800 (PST)
Message-ID: <daffe6272525376d955a4eaa73263a7f08634ac1.camel@redhat.com>
Subject: Re: [PATCH] random: use computational hash for entropy extraction
From:   Simo Sorce <simo@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Stephan Mueller <smueller@chronox.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Date:   Wed, 02 Feb 2022 08:36:06 -0500
In-Reply-To: <CAHmME9ouMHtTQxB1WHq3H+nfbg27OFaJtw78E5epCJsiHt3sHg@mail.gmail.com>
References: <20220201161342.154666-1-Jason@zx2c4.com>
         <1920812.EuvsCRJjSr@tauon.chronox.de>
         <CAHmME9ouMHtTQxB1WHq3H+nfbg27OFaJtw78E5epCJsiHt3sHg@mail.gmail.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Jason,
if the current code is mistakenly stretching the entropy, perhaps the
correct curse of action is to correct that mistake first, before
introducing a new conditioning function.
As it is, these patches cannot be say to just perform conditioning if
they are stretching the entropy, the risk is compounding errors and
voiding any reasonable analysis of the entropy carried through the RNG.

It would also be nice to have an explanation (in the patch or at least
the commit message) about how entropy is preserved and why a specific
function is cryptographically adequate. Note that there is no study
about using internal states of hash functions, it would be better to
base these decisions on solid ground by citing relevant research or
standards.

Thanks,
Simo.

On Wed, 2022-02-02 at 13:23 +0100, Jason A. Donenfeld wrote:
> Hi Stephan,
> 
> It's like this for a few reasons:
> 
> - Primarily, we want to feed 32 bytes back in after finalization (in
> this case as a PRF key), just as the code does before this patch, and
> return 32 bytes to the caller, and we don't want those to be relatable
> to each other after the seed is erased from the stack.
> - Actually, your statement isn't correct: _extract_entropy is called
> for 48 bytes at ~boot time, with the extra 16 bytes affecting the
> block and nonce positions of the chacha state. I'm not sure this is
> very sensible to do -- it really is not adding anything -- but I'd
> like to avoid changing multiple things at once, when these are better
> discussed and done separately. (I have a separate patch for something
> along those lines.)
> - Similarly, I'd like to avoid changing the general idea of what
> _extract_entropy does (the underscore version has never accounted for
> entropy counts), deferring anything like that, should it become
> necessary, to an additional patch, where again it can be discussed
> separately.
> - By deferring the RDRAND addition to the second phase, we avoid a
> potential compression call while the input pool lock is held, reducing
> our critical section.
> - HKDF-like constructions are well studied and understood in the model
> we're working in, so it forms a natural and somewhat boring fit for
> doing what we want to do.
> 
> Regards,
> Jason
> 

-- 
Simo Sorce
RHEL Crypto Team
Red Hat, Inc




