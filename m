Return-Path: <SRS0=MZ7V=QG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E465C282D7
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 09:19:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2E4420882
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 09:19:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="e4HY0tE+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfA3JTZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Jan 2019 04:19:25 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:40549 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbfA3JTZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Jan 2019 04:19:25 -0500
Received: by mail-io1-f68.google.com with SMTP id k2so18779851iog.7
        for <linux-crypto@vger.kernel.org>; Wed, 30 Jan 2019 01:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PhvCaN4Kv7vm7G6iA7saM9KjT4UB8mVq8grjhF2dBy4=;
        b=e4HY0tE+qHmSaKLgA4INHl4e+AgXVkiwSq7KR/BFdSRXM28li1IHnkT/yaqqVEuleF
         PWzms/8pP0XziQAjvJmHFbQVuvPlCrqN7Tc43z89fLJTahu4NzLfiiiYz+boqcS8eRi5
         1YRdv0rMxGrFvt6TLA62gKg0v+BmK8Yt9TuWk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PhvCaN4Kv7vm7G6iA7saM9KjT4UB8mVq8grjhF2dBy4=;
        b=ogBDAs4MTx7qh36mmNc0IQqu7Jy0V2AkQPgJdCJRNT9luqjPW0bIkpC6jvoPMk0b5f
         IqRJJkdGlXEYzrNU+BzZbvCjdPb7FKdmc+9NVB/G5Qx4lZWuIU+4eramqWC3VQ8X3mbm
         VnaWqHhCBocTF0AB0fr4AO+RayliO8sep2eIGQEUQH4eiTrFG1RHLxtl27gAhnJfyHck
         NRmyMbT35eEkVej8sQ3cvukhJSNpcLh+16Cq2zNpqXGjaZVxhZ2knGwW+f5/HH9aVv9Q
         NAP4uqYF4kUgR6sYSWAGj2J+F7MRfvFo0/c199d067gNCb8HxP9S7Gcs8Kv6kqpgLHpa
         ULbA==
X-Gm-Message-State: AHQUAuZ68re1ozJlmQc3AxcwMuXflrezcTKVjphfftahZN7S1EMLGVru
        7qeW9mNTRIzR+43KfabKr9d31xHL8rz0Tj9G9OYe2A==
X-Google-Smtp-Source: AHgI3IYsJJbYy2Zb+/BCEA0T7MAjCosJLSEg4zJR49yRfHTeNdEsmgC6azsTd813JhRiW1IfihrfCFfSl60l+Fvprog=
X-Received: by 2002:a5d:8410:: with SMTP id i16mr559462ion.173.1548839964162;
 Wed, 30 Jan 2019 01:19:24 -0800 (PST)
MIME-Version: 1.0
References: <20190130031444.28935-1-ebiggers@kernel.org> <CAKv+Gu95j-ZJC7vbUzJKqNczht1cjgx09sBiSRcwg+qn-HtXew@mail.gmail.com>
 <20190130091332.gbcce2oyb24ienu2@gondor.apana.org.au>
In-Reply-To: <20190130091332.gbcce2oyb24ienu2@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 30 Jan 2019 10:19:10 +0100
Message-ID: <CAKv+Gu8NL+J0NncuyKEjo-K5Z_qXwRRuGMvm1227Q6s2rTGQ3w@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] crypto: crct10dif assembly cleanup and optimizations
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 30 Jan 2019 at 10:13, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Jan 30, 2019 at 09:33:57AM +0100, Ard Biesheuvel wrote:
> >
> > So what remains is the way these implementations are encapsulated by
> > the crct10dif() library function, which is raster nasty, making
> > CRC-T10DIF an excellent use case to discuss whether we can make any
> > improvements to address some of the concerns that were also raised in
> > the zinc discussion. I threw some code together a while ago [0] (and
> > posted it as well, IIRC). In the mean time, a 'static call'
> > infrastructure is being proposed that could be used in a similar way
> > to avoid function pointers. I'm also interested in hearing opinions on
> > whether the indirect call overhead is actually significant in use
> > cases such as this one.
>
> I think even if the overhead wasn't significant it would still make
> sense to make the move just for the sake of simplicity.
>

Agreed, we should simplify this if we can.

However, my question is whether in this particular case, a simple
indirect call via a function pointer is /so/ much worse than a direct
call that relies on code patching techniques that are different on
every arch (and may rely on objtool or GCC plugins) that the extra
complexity is justified.
