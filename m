Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B26ECAAD1
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Aug 2022 10:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiHaKBB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Aug 2022 06:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiHaKAh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Aug 2022 06:00:37 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3C0A2DA6
        for <linux-crypto@vger.kernel.org>; Wed, 31 Aug 2022 03:00:32 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id d16so1306344ils.8
        for <linux-crypto@vger.kernel.org>; Wed, 31 Aug 2022 03:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=btMbTIPSX5dbCacGerCyAxqDIoBmYrvBMjvjrYIGNig=;
        b=WYM3XeLVMXVxeaZOoVzvPbeAuSlTMMHkX0Y2eZD1K4/ThGlZ6+Eg/Bv6VJyoDJlB+u
         W9LgBtDjWINhH+2OYh6n1/A5BSQmHGsWXMj8XqAhtn+krL7C++jj6y+j+FmlTs31utN0
         k9tC2ICHRKzAD6KXirg6CojpcPygW6KLNOetc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=btMbTIPSX5dbCacGerCyAxqDIoBmYrvBMjvjrYIGNig=;
        b=BI43R9l6CgfE6iVRnYZdECKVBuzASvUFaRFeedEpPg09YBA9o/X8oHnsJcHdZyQeYx
         COBC9XmKfrGx6LCYZGCJaj1BMk5c6Q72/06sMJtn2eNGBj428FrmbZJDPWjRds127OsC
         zax5qcRRxydyOn4ujlsvo0JACS99Qop8KVV3K2sTGolvBDuZWoh8adQblCcL8g9qPW6O
         Y5Y0UwhGvcEi4A+//HwCGv+SupSa1vi/mwcgM9UPM1wePHYT7FSGfZweUwa1CRhW2/Yf
         TzpKIC41B1I23ApZrmtpou5K3/6Z6ONfTqh5Cgc1zxc2peAc0zG+JA3e9TajpSH3L+LZ
         upQg==
X-Gm-Message-State: ACgBeo328rIu0ne20f/PF3Xsgs9Iet8z6R0xXIlCUEePQtSyrWyfD9fo
        fvJO5V3YDDsvaSgBPMI8BVCk0ORhqHkJI8KhYXvvjg==
X-Google-Smtp-Source: AA6agR7Ykym679T8iG+4ASbb+ENC/8XjLuzKLFnYo9eL16xdbnKf1MwaRtCyWd2Kj1UhmxqnIYOvsKqLHnQSC+/aFFU=
X-Received: by 2002:a92:cd0d:0:b0:2eb:e4a:2d4a with SMTP id
 z13-20020a92cd0d000000b002eb0e4a2d4amr6517370iln.309.1661940031852; Wed, 31
 Aug 2022 03:00:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220729165954.991-1-ignat@cloudflare.com> <Yv9dvvy0rK/1T0sU@gondor.apana.org.au>
 <CALrw=nEh7LX3DSCa3FTu8BYr4QWx+W2h3Jei9Qo67+XXH-Vegw@mail.gmail.com>
 <Yw3Rneo6Ik1QEfbG@gondor.apana.org.au> <CALrw=nGJgMACrFVy+FVVCDb4H3wNUN2E-GLZaXzLsm3ReOUeVg@mail.gmail.com>
 <Yw8iTNjGlsP1LpNG@gondor.apana.org.au>
In-Reply-To: <Yw8iTNjGlsP1LpNG@gondor.apana.org.au>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Wed, 31 Aug 2022 11:00:21 +0100
Message-ID: <CALrw=nECpsJA-Q1ze2-ErQN37hMeWYbyfrWpmzUpsFCq=6R7Ew@mail.gmail.com>
Subject: Re: [PATCH] crypto: akcipher - default implementations for setting
 private/public keys
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 31, 2022 at 9:56 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Aug 30, 2022 at 11:48:23AM +0100, Ignat Korchagin wrote:
> >
> > I vaguely remember some initial research in quantum-resistant
> > signatures, which used HMAC for "signing" thus don't have any public
> > keys. But it is way beyond my expertise to comment on the practicality
> > and availability of such schemes.
>
> We could always add this again should an algorithm requiring
> it be introduced.
>
> > I'm more concerned here about a buggy "third-party" RSA driver, which
> > may not implement the callback and which gets prioritised by the
> > framework, thus giving the ability to trigger a NULL-ptr dereference
> > from userspace via keyctl(2). I think the Crypto API framework should
> > be a bit more robust to handle such a case, but I also understand that
> > there are a lot of "if"s in this scenario and we can say it is up to
> > crypto driver not to be buggy. Therefore, consider my opinion as not
> > strong and I can post a v2, which does not provide a default stub for
> > set_pub_key, if you prefer.
>
> If you're concerned with buggy algorithms/drivers, we should
> ensure that the self-tests catch this.

So it does currently, because I caught it via testmgr. Will send a v2
without a default set_pub_key.
