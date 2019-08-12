Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE2BC31E40
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 07:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A2AB2085A
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 07:50:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oTfqh5iR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfHLHuc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 03:50:32 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52386 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbfHLHuc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 03:50:32 -0400
Received: by mail-wm1-f65.google.com with SMTP id s3so11250037wms.2
        for <linux-crypto@vger.kernel.org>; Mon, 12 Aug 2019 00:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P3fUIo7bf1pVPngPlyIX37AdYP0H8U4V2yGXzc3Q8PU=;
        b=oTfqh5iRHusnTRpAqy4qvCs8UwHzoKalNbqMK/GjgIboOgPnfdXRyXnph+Q37L7hc6
         5L8nRT1ZtexlBg+WQw5KrY1H+fYbgWjHqv9QL8Vg2kzsKzb2kYJPeOT2RZz4GFhzthnj
         2hKX6j7vrWopkZGcewExFiAeKafnl/M8gLPo2ku/KWuX0IG7cSgEIYJa41kqEKSwa/R7
         UDQ/J9fuH6hoNIYy7Gls/PJ2v3y7+aDjRhmBQwjqLNz29KSh+BgPUiiNdg1RIDJxB5E7
         NiNuN5ngcwxOe+en/TyM5rgehfOAJa54oo+rSMScntSkZDQfPLq1mJt0haiJX1v4UCm0
         obCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P3fUIo7bf1pVPngPlyIX37AdYP0H8U4V2yGXzc3Q8PU=;
        b=WTly54XvX6mfS9wnzxKwW7gllrUlNwi+DhZvE19rQv1B60SQEzwY73eISwaEiSmtKW
         IZnPFZDyAffmE6QWiJfSE5LdQcmjdERcVu5nRzL3M7Xd3PYedrqTe7Ag4hJHRbwsibca
         mz3b1+maMUZcLJwTmMaHmRbPzqltSM/l1yb6VoW/FdWuZLTXiCCUXrnaAu3jsPPOURHO
         v3kAkV5qYJdF3nkdIOYBJj8STdCrOLGAj4pACQkVILl58Bxjf0DRtjjqHnEHf7xJzRgD
         TkSksgnnO/Q+0ZX/AtEzePc98hpZhj1VQftOA12cqWWbhoV9K0tEVbV/uVJpo/mp4gf9
         adPw==
X-Gm-Message-State: APjAAAW1HXTI2L9MslQVFMCmMX+zKSZsUGTejKNaN1b/OwmKGV/vEWU3
        Unls6urJIbNEF9MDW5pNhnDSoz+6rU/awJnfOgSi6Q==
X-Google-Smtp-Source: APXvYqwgX4GSGhKVfxz1Y7uXiz3RKDX4LiVGl3zj4caTjar5UkkOQnpMqABzSOE6jltHT5IOZsjPe+lkzp++qlubqQ4=
X-Received: by 2002:a7b:cb8e:: with SMTP id m14mr5924657wmi.10.1565596229982;
 Mon, 12 Aug 2019 00:50:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190810094053.7423-1-ard.biesheuvel@linaro.org>
 <20190810094053.7423-4-ard.biesheuvel@linaro.org> <8679d2f5-b005-cd89-957e-d79440b78086@gmail.com>
 <CAKv+Gu-ZPPR5xQSR6T4o+8yJvsHY2a3xXZ5zsM_aGS3frVChgQ@mail.gmail.com> <82a87cae-8eb7-828c-35c3-fb39a9abe692@gmail.com>
In-Reply-To: <82a87cae-8eb7-828c-35c3-fb39a9abe692@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 12 Aug 2019 10:50:18 +0300
Message-ID: <CAKv+Gu_d+3NsTKFZbS+xeuxf5uCz=ENmPX-a=s-2kgLrW4d7cQ@mail.gmail.com>
Subject: Re: [PATCH v9 3/7] md: dm-crypt: switch to ESSIV crypto API template
To:     Milan Broz <gmazyland@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 12 Aug 2019 at 10:44, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 12/08/2019 08:54, Ard Biesheuvel wrote:
> > On Mon, 12 Aug 2019 at 09:33, Milan Broz <gmazyland@gmail.com> wrote:
> >> Try for example
> >> # cryptsetup luksFormat /dev/sdc -c aes-cbc-essiv:sha256 --integrity hmac-sha256 -q -i1
> >>
> >> It should produce Crypto API string
> >>   authenc(hmac(sha256),essiv(cbc(aes),sha256))
> >> while it produces
> >>   essiv(authenc(hmac(sha256),cbc(aes)),sha256)
> >> (and fails).
> >>
> >
> > No. I don't know why it fails, but the latter is actually the correct
> > string. The essiv template is instantiated either as a skcipher or as
> > an aead, and it encapsulates the entire transformation. (This is
> > necessary considering that the IV is passed via the AAD and so the
> > ESSIV handling needs to touch that as well)
>
> Hm. Constructing these strings seems to be more confusing than dmcrypt mode combinations :-)
>
> But you are right, I actually tried the former string (authenc(hmac(sha256),essiv(cbc(aes),sha256)))
> and it worked, but I guess the authenticated IV (AAD) was actually the input to IV (plain sector number)
> not the output of ESSIV? Do I understand it correctly now?
>

Indeed. The former string instantiates the skcipher version of the
ESSIV template, and so the AAD handling is omitted, and we end up
using the plain IV in the authentication rather than the encrypted IV.

So when using the latter string, does it produce any error messages
when it fails?
