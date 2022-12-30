Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F02EC4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Dec 2022 22:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbiL3WBK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiL3WBI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Dec 2022 17:01:08 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70BD19C37
        for <linux-crypto@vger.kernel.org>; Fri, 30 Dec 2022 14:01:06 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id fy4so23623891pjb.0
        for <linux-crypto@vger.kernel.org>; Fri, 30 Dec 2022 14:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DQYLGAH0uGXo3xlMz5nVls5ASt4VNqU9CWQhF48EYvw=;
        b=jOFraJc2+le2FfTl9+hl81vOAbgJL9wX3Ldrv9YY+Gu/AxmtD+bQtclTHwnTGgH27A
         BVgmvTTbPItZ5UYgTIKhy5tzqyLIBe5JtpltE5LFgZr8kwMR28Mj8I8kEcPJC/vvtnLb
         ohnaHo1wEWqxF/beEMnmqoUoVT8oHOP73zM6s1VE/TUIYTqbG5k/Vn7cJIJC3jmdG5M+
         IQP4ojENssjjADyCnE40YNMpAIZQVU+6IGsNiZVKUVyv3nOsgB+u3UUg7okJzREaaB6s
         uYmVb5ffLAbJl/HtlLZj7TCY+kTUVU9+SEK+5gmpEznsAaSXXeA7hDJhlsEbSkbGVdD4
         4xcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DQYLGAH0uGXo3xlMz5nVls5ASt4VNqU9CWQhF48EYvw=;
        b=DkWTJoR/dc6CIHb6Vlh6hy02R+bOk60AaA313Tbv9bCjfs0ehAdPBAmNchGhZTipAv
         9U6DCZS62EqRqH7PBnr1jWnGtaZAzwrvnCZdQ4cGvDzIpmfEBnKn5x7f2G3xhkZ/T9yW
         PSFv9h1N2uIhpEBbGcm13Cfq1r9/tt4Wy+wql/hL2JPaOgJWJnWE92h8Dqg790jdwhCF
         YFzpqeXq3PISQzR+YIG2y2kewvJ63smsDUK3eLdTnCuOTAsU0yDBsBP6M+p4o5M7S7Mm
         WUgBvUAQNnTvVFv7QgnRfHm8+5PNM7BuFhCGglQDHVD1OHu7tsvJIZVtnP8nUwn8zcv+
         tMOA==
X-Gm-Message-State: AFqh2koAoXi9oOYhKh0A71m7ReYimnvorkOSV5CUA4cO9Sg++MkBEHTT
        hsA4JWYVFfbFpNhLPsU3nQDpQg==
X-Google-Smtp-Source: AMrXdXv4oXVZT5rM0N5imJkkR+zQ6Brwur97rGFFx35dL6Lhe4dDs6060zOcH2NrU1vXy9LrW/DdbQ==
X-Received: by 2002:a17:902:d4d1:b0:189:3a04:4466 with SMTP id o17-20020a170902d4d100b001893a044466mr3420177plg.2.1672437666185;
        Fri, 30 Dec 2022 14:01:06 -0800 (PST)
Received: from [2620:15c:29:203:8954:8b68:67ce:a964] ([2620:15c:29:203:8954:8b68:67ce:a964])
        by smtp.gmail.com with ESMTPSA id g19-20020a635213000000b0044ed37dbca8sm9241470pgb.2.2022.12.30.14.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 14:01:05 -0800 (PST)
Date:   Fri, 30 Dec 2022 14:01:04 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
cc:     Peter Gonda <pgonda@google.com>, Andy Nguyen <theflow@google.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, John Allen <john.allen@amd.com>,
        "Thomas . Lendacky" <thomas.lendacky@amd.com>
Subject: Re: [PATCH] crypto: ccp - Limit memory allocation in SEV_GET_ID2
 ioctl
In-Reply-To: <Y6wDJd3hfztLoCp1@gondor.apana.org.au>
Message-ID: <826b3dda-5b48-2d42-96b8-c49ccebfdfed@google.com>
References: <20221214202046.719598-1-pgonda@google.com> <Y5rxd6ZVBqFCBOUT@gondor.apana.org.au> <762d33dc-b5fd-d1ef-848c-7de3a6695557@google.com> <Y6wDJd3hfztLoCp1@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 28 Dec 2022, Herbert Xu wrote:

> On Tue, Dec 27, 2022 at 05:42:31PM -0800, David Rientjes wrote:
> >
> > The goal was to be more explicit about that, but setting __GFP_NOWARN 
> > would result in the same functional behavior.  If we're to go that route, 
> > it would likely be best to add a comment about the limitation.
> > 
> > That said, if AMD would prefer this to be an EINVAL instead of a ENOMEM by 
> > introducing a more formal limitation on the length that can be used, that 
> > would be preferred so that we don't need to rely on the page allocator's 
> > max length to enforce this arbitrarily.
> 
> Ideally the limit should be set according to the object that
> you're trying to allocate.  But if that is truly unlimited,
> and you don't want to see a warning, then GFP_NOWARN seems to
> fit the bill.
> 

AMD would be able to speak authoritatively on it, but I think the length 
of the ID isn't to be assumed by software because it will likely change 
later.

I don't think there's an active vulnerability with the currnet code so we 
can likely drop stable@vger.kernel.org for this.  The kzalloc() will fail 
if you try to allocate over 2MB.  If you try to allocate >32KB, the page 
allocator will attempt to reclaim but won't oom kill.  If you try to 
allocate <=32KB, there's the potential for oom kill if nothing is 
reclaimable, but if memory is that scarce I think we have bigger problems.

So __GFP_NOWARN will work, but I also think it's subtle enough that it 
warrants being coupled with a comment.
