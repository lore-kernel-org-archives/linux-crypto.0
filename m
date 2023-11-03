Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A18C4167D
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Nov 2023 06:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjKCGdG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Nov 2023 02:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbjKCGdF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Nov 2023 02:33:05 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E931B9
        for <linux-crypto@vger.kernel.org>; Thu,  2 Nov 2023 23:32:57 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9becde9ea7bso562477366b.0
        for <linux-crypto@vger.kernel.org>; Thu, 02 Nov 2023 23:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1698993175; x=1699597975; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VyO1Z+S61kc8i/PizQbBIUgo6r//ondY8h0vjsIi3rI=;
        b=VW3j1xQ7TfWnVS5CQUvuXuRug9aMR4VjwGkaDd+ILQLGHJ49mF9aNafAQNZb9tb0pH
         OakWaouChUX28UgHtDppKSH210ULPs3bVnTSSqMwFZiSSDN2bhGMKuYKlqYuWcfuUcQG
         /Q11BJEzBhvWJwelbIkWVDjgcLLQx31zlMDak=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698993175; x=1699597975;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VyO1Z+S61kc8i/PizQbBIUgo6r//ondY8h0vjsIi3rI=;
        b=KjepRA4tE6DWJhom12ElrBzcwOAXRFpzd8fjhlEV/995jy1bNnZkpEXM6Vya6Gdw5T
         9oarPcxwTTG5EcGk9x5S/3X3pOTK0cFJAaYkv5/tpeUyoKE2eGlLvp1EvUgL6s2FZVVf
         AeGlw1dAxRcybHefBnTqg+RDQ1Ohu6dTJY04RAUp1p93g12l0lQm8X3CbvogAd2m7VNR
         shm/mOhIrn6Ek8XvOLkaasBDVoWX3qhr7rbrllPKJAd74l0eErSV3CM2IsT/Yd426lUy
         vQkq08KNJZ6cmzZEQ/DEarYPNhUwI4caFL/5ffZWKWhss7HO6hOVfrubW5EP9GwMikUt
         QrxQ==
X-Gm-Message-State: AOJu0Yxqf/cOwhyqAXc5OAfnhmoFkJMXH8iHcaovpSgpD5QEEVbDxMuJ
        oKQOjIDMbjhYZImzxOahm7LXV+G55mOl6HjkM0O32s8y
X-Google-Smtp-Source: AGHT+IGI3nZVqlSyjgs+GLGLktNY52LrX5zj/tJVenZ2chPbIguu2/5mfhhazS2CkbR0QNBnY/bDeA==
X-Received: by 2002:a17:906:74d4:b0:9b2:cee1:1f82 with SMTP id z20-20020a17090674d400b009b2cee11f82mr1528370ejl.7.1698993175333;
        Thu, 02 Nov 2023 23:32:55 -0700 (PDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id i11-20020a170906698b00b0098669cc16b2sm533562ejr.83.2023.11.02.23.32.54
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Nov 2023 23:32:54 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-9c3aec5f326so558443766b.1
        for <linux-crypto@vger.kernel.org>; Thu, 02 Nov 2023 23:32:54 -0700 (PDT)
X-Received: by 2002:a17:906:4fca:b0:9bd:a66a:a22 with SMTP id
 i10-20020a1709064fca00b009bda66a0a22mr2119584ejw.15.1698993173801; Thu, 02
 Nov 2023 23:32:53 -0700 (PDT)
MIME-Version: 1.0
References: <YpC1/rWeVgMoA5X1@gondor.apana.org.au> <Yui+kNeY+Qg4fKVl@gondor.apana.org.au>
 <Yzv0wXi4Uu2WND37@gondor.apana.org.au> <Y5mGGrBJaDL6mnQJ@gondor.apana.org.au>
 <Y/MDmL02XYfSz8XX@gondor.apana.org.au> <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au> <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au> <CAHk-=wj0-QNH5gMeYs3b+LU-isJyE4Eu9p8vVH9fb-vHHmUw0g@mail.gmail.com>
 <ZUSKk6Tb7+0n9X5s@gondor.apana.org.au>
In-Reply-To: <ZUSKk6Tb7+0n9X5s@gondor.apana.org.au>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 2 Nov 2023 20:32:36 -1000
X-Gmail-Original-Message-ID: <CAHk-=wh=xH7TNHeaYdsrVW6p1fCQEV5PZMpaFNsZyXYqzn8Stg@mail.gmail.com>
Message-ID: <CAHk-=wh=xH7TNHeaYdsrVW6p1fCQEV5PZMpaFNsZyXYqzn8Stg@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto Update for 6.7
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2 Nov 2023 at 19:52, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Fair enough.  How about adding an EXPERT dependency on this?

I think that would help the situation, but I assume the sizing for the
jitter buffer is at least partly due to trying to account for cache
sizing or similar issues?

Which really means that I assume any static compile-time answer to
that question is always wrong - whether you are an expert or not.
Unless you are just building the thing for one particular machine.

So I do think the problem is deeper than "this is a question only for
experts". I definitely don't think you should ask a regular user (or
even a distro kernel package manager). I suspect it's likely that the
question is just wrong in general - because any particular one buffer
size for any number of machines simply cannot be the right answer.

I realize that the commit says "*allow* for configuration of memory
size", but I really question the whole approach.

But yes - hiding these questions from any reasonable normal user is at
least a good first step.

              Linus
