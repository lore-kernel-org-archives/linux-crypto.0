Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1087C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Mar 2022 23:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbiCUXWl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Mar 2022 19:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbiCUXWb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Mar 2022 19:22:31 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E2A54682
        for <linux-crypto@vger.kernel.org>; Mon, 21 Mar 2022 16:15:09 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id bu29so27116910lfb.0
        for <linux-crypto@vger.kernel.org>; Mon, 21 Mar 2022 16:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aJ9Cb5knxaydut4A69DGxHwlprGSZbckXL16qciG47U=;
        b=JJSzV91d6Mz09E35tlZODBUUR1INh/MgMi3TieAJqFtFVS46iVh9M1Q49i70AEnbaj
         hnmR0WUYT/+Qc4/tV3cWzDoNkvKrbUlLG6REkoGBt3sE1lc0NnSvCRqRwqnkbFgm1Ozw
         o5oyBE7O+2JdYVnmizZrwHmHk7Pj0fup2zIs0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aJ9Cb5knxaydut4A69DGxHwlprGSZbckXL16qciG47U=;
        b=KFS4SIhL7hOvTklssnmz1Y6z+0NCnJhs8nnr2Z336c0oR0g0Ww0rEQb0OT5qaVc1w5
         rlQd/dQJvjjR42vS6IYM0rdpPjNXIbO2xd8YKO3NaGAMjsvoON263mIUkhTRcwAAiCf6
         QXutoh8oQ2SbRdoQLSZog7x+D56HAAFvXcyo7XF32+ST2FYKK8YDyzSKfOEnhsSwHCqV
         Vs5NLI4wuWjyb+t5ZmLfa/pOGkWGY2ec8z1AUN5Du0vU26gz0MaznOmGBouBiZavDM8Q
         lczI6Jtv2ZqNrQuiWWOIeTVSmfU9r1PU+YGWpgsGrbafbjgoxoo5RjcL8MM38T7mb83Y
         kTOQ==
X-Gm-Message-State: AOAM530EHxJG3iFyrL+7l85QJMQfL7C+EHT/ThOryDKR5Fsam5oQQi5V
        KW5OR0GmxNBnETfNck1mI+KSPsC0L53pFP9jnQs=
X-Google-Smtp-Source: ABdhPJxxYscBn7MGIFOFB/tQ2lu6fHa5eX5RGTpOVnoYt1IvCAcUaWMXXwKAGtSZXH/x8XO+57YqvQ==
X-Received: by 2002:a05:6512:2349:b0:448:9b45:7718 with SMTP id p9-20020a056512234900b004489b457718mr16597240lfu.347.1647904507235;
        Mon, 21 Mar 2022 16:15:07 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id z2-20020ac24f82000000b0044850790636sm1951920lfs.87.2022.03.21.16.15.06
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 16:15:06 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id a26so9036976lfg.10
        for <linux-crypto@vger.kernel.org>; Mon, 21 Mar 2022 16:15:06 -0700 (PDT)
X-Received: by 2002:a19:e048:0:b0:448:2caa:7ed2 with SMTP id
 g8-20020a19e048000000b004482caa7ed2mr16519280lfj.449.1647904506069; Mon, 21
 Mar 2022 16:15:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200803044024.GA6429@gondor.apana.org.au> <20201012033249.GA25179@gondor.apana.org.au>
 <20201214055515.GA14196@gondor.apana.org.au> <20210215024721.GA20593@gondor.apana.org.au>
 <20210426123200.kgbyk6ayey4l4lrw@gondor.apana.org.au> <20210628110050.GA12162@gondor.apana.org.au>
 <20210830082818.GA30921@gondor.apana.org.au> <20211102035201.GA23331@gondor.apana.org.au>
 <Ydzlo+UmL5bbDgUZ@gondor.apana.org.au> <Yje766s7fIqYg1Tk@gondor.apana.org.au>
In-Reply-To: <Yje766s7fIqYg1Tk@gondor.apana.org.au>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 21 Mar 2022 16:14:50 -0700
X-Gmail-Original-Message-ID: <CAHk-=wix0F2nwk8v2Hmo-x6Yr0PEji9=oMTewk6YhL+ATM2fVg@mail.gmail.com>
Message-ID: <CAHk-=wix0F2nwk8v2Hmo-x6Yr0PEji9=oMTewk6YhL+ATM2fVg@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto Update for 5.18
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Mar 20, 2022 at 4:42 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

So perhaps somewhat ironically, the crypto tree is now the first tree
I'm merging in this merge window that doesn't have a signed tag.

I don't require signed tags for kernel.org pulls, but I really do
heavily prefer them, and they aren't that hard to do.

I'm sure there are several other non-signed pull requests waiting in
the queue, but still, your pull request stands out as being the first
one - out of 27 so far - that didn't have it.

Can I prod you in the direction of making signed tags a part of your
workflow? The tag can contain the details of the pull - in which case
git request-pull will populate the pull request with it - or it can be
just some dummy message and you write the details separately in the
pull request email like you do now.

I know you have a pgp key, because I have one in my keyring from you
going all the way back to 2011. And if you have lost sight of that one
and need to create a new one, that still better going forward than not
signing your pull requests at all..

            Linus
