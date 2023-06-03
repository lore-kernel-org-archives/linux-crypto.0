Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85734C7EE2C
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Jun 2023 00:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236574AbjFCAIP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Jun 2023 20:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236467AbjFCAIO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jun 2023 20:08:14 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809D11BF
        for <linux-crypto@vger.kernel.org>; Fri,  2 Jun 2023 17:08:13 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-974f4897d87so143306266b.0
        for <linux-crypto@vger.kernel.org>; Fri, 02 Jun 2023 17:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685750891; x=1688342891;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UIfddwJGgEUnwUCFA5IlnKSK6V7h4JvROQevxAQzNhk=;
        b=haM75PQBkuqw+UWlyLARJvJ6YuWufLMf+LPGfYfVzXQNgRX9DwRI8tEA1riys0gSxO
         0hTcajB+4GOiZZlSdECHvyT3ySrZt0Fy7GLp8Ba/0HUzO0vyjGpQzZd2qUZH2D2N7K0Q
         a5IhAqy1GMwKlhuNhW2N9XR0uyLXD6JQNyq3U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685750891; x=1688342891;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UIfddwJGgEUnwUCFA5IlnKSK6V7h4JvROQevxAQzNhk=;
        b=IBdF5yb7EfNlZfz7QD4DYP7/iwbQoyNU3CCj5y4V+Zv6DyHBKQ8XkDz5k169280cZm
         wnh4BHGWGYFuzmxA17a34e0GlcsQ33sHzsNRsXoFjnf2JZlahWeubGkTDybeb2PtbTrf
         EpJw/09moVGz8ZKSU7YHl/o3maT5/uST8CfOtyQa+M9VtVRGVwmXAJ28x6BxlJhyhykW
         wsOCzpn6nCmC0P9UHcCbtmGTRAmrrjnW3F4B7eMDY+i5oEJy13hTBToFz3c+O60BnRU0
         9KmyNmAthyMag1IIyBEX8lCngrA9Q5ZLaDgMjOnkFWvSrlFs2NEcugOnEo0TtBPK//Zy
         hJPg==
X-Gm-Message-State: AC+VfDwEP6uf9xPYBomAbY1n+8EizEPdC4N33lOv/afNAJw4qgf8Xu2V
        vsFsmpxYHdK7w8FpVJ/h3j8PSp1meo7XUProCVzr8uB+
X-Google-Smtp-Source: ACHHUZ4f+F7EbcI1pjtwiKjkrW9QyEq6fVRpnHr37U1vped6f8AW9EzjzHeaKHG70rW0ylPOYBil5w==
X-Received: by 2002:a17:907:971b:b0:972:aa30:203e with SMTP id jg27-20020a170907971b00b00972aa30203emr118424ejc.34.1685750891624;
        Fri, 02 Jun 2023 17:08:11 -0700 (PDT)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com. [209.85.128.52])
        by smtp.gmail.com with ESMTPSA id j21-20020a170906095500b0096b20c968afsm1309271ejd.124.2023.06.02.17.08.11
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 17:08:11 -0700 (PDT)
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-3f6e4554453so25464505e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 02 Jun 2023 17:08:11 -0700 (PDT)
X-Received: by 2002:ac2:52ba:0:b0:4f2:7b65:baeb with SMTP id
 r26-20020ac252ba000000b004f27b65baebmr2458573lfm.53.1685750560415; Fri, 02
 Jun 2023 17:02:40 -0700 (PDT)
MIME-Version: 1.0
References: <4d7e38ff5bbc496cb794b50e1c5c83bcd2317e69.camel@huaweicloud.com> <CAHk-=wj4S0t5RnJQmF_wYwv+oMTKggwdLnrA9D1uMNKq4H4byw@mail.gmail.com>
In-Reply-To: <CAHk-=wj4S0t5RnJQmF_wYwv+oMTKggwdLnrA9D1uMNKq4H4byw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 2 Jun 2023 20:02:23 -0400
X-Gmail-Original-Message-ID: <CAHk-=wgCUzRNTg4fC8DF=UFnznK0M=mNUBDcsnLt7D4+HP2_1Q@mail.gmail.com>
Message-ID: <CAHk-=wgCUzRNTg4fC8DF=UFnznK0M=mNUBDcsnLt7D4+HP2_1Q@mail.gmail.com>
Subject: Re: [GIT PULL] Asymmetric keys fix for v6.4-rc5
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>, davem@davemloft.net,
        zohar@linux.ibm.com, dmitry.kasatkin@gmail.com,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
        Jarkko Sakkinen <jarkko@kernel.org>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 2, 2023 at 1:38=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The patch re-uses the allocation it already does for the key data, and
> it seems sane.

Ugh. I had to check that it was ok to re-use the key buffer, but it
does seem to be the case that you can just re-use the buffer after
you've done that crypto_akcipher_set_priv/pub_key() call, and the
crypto layer has to copy it into its own data structures.

I absolutely abhor the crypto interfaces. They all seem designed for
that "external DMA engine" case that seems so horrendously pointless
and slow.  In practice so few of them are that, and we have all those
optimized routines for doing it all on the CPU - but have in the
meantime wasted all that time and effort into copying everything,
turning simple buffers into sg-bufs etc etc. The amount of indirection
and "set this state in the state machine" is just nasty, and this
seems to all be a prime example of it all. With some of it then
randomly going through some kthread too.

I still think that patch is probably fine, but was also going "maybe
the real problem is in that library helper function
(asymmetric_verify(), in this case), which takes those (sig, siglen,
digest, digestlen) arguments and turns it into a 'struct
public_key_signature' without marshalling them.

Just looking at this mess of indirection and different "helper"
functions makes me second-guess myself about where the actual
conversion should be - while also feeling like it should never have
been done as a scatter-gather entry in the first place.

Anyway, I don't feel competent to decide if that pull request is the
right fix or not.

But it clearly is *a* fix.

            Linus
