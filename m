Return-Path: <SRS0=ZPwR=WJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D32FFC433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 18:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8F3320665
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 18:16:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x2xJ9KtU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbfHMSQ1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Aug 2019 14:16:27 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53125 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbfHMSQ1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Aug 2019 14:16:27 -0400
Received: by mail-wm1-f67.google.com with SMTP id o4so2227297wmh.2
        for <linux-crypto@vger.kernel.org>; Tue, 13 Aug 2019 11:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=Nrxu1gfhcbocfYIZUw0NkOzczURAyLQVnvTJn31YeTc=;
        b=x2xJ9KtUYmejpdb+kbqiHkXaAfhfDNN7U5IiJWhmumpTtrK2rYVpy7DfvU5zbhsimZ
         BFn+M9U7v5lyzCZ8INrOLufJ55/GJ6x2y97ZMvzps+dzZwn/ZnbZyp5Qmriva94OcoXF
         UFQo5zsChF51q+meunPCt2HLWsmUCIWsAhFmvmIppYUwsLjq+fhqxN8xBzryTW2S5icI
         qFsR9P/sxKCOP8dg2dA7Ukpb18hfmjtwUBGMmhgM07rBO0+og1B1PYI/6+EaIiGn97DZ
         8DslTNM23x8u8/qGyruiVB51ZiixCmm0J0n9o2HMF/S9F02kEtZMxm/C7vAv8BRvUCMC
         iKVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=Nrxu1gfhcbocfYIZUw0NkOzczURAyLQVnvTJn31YeTc=;
        b=IkE5CaTI5q49A6ZEcT4QSjERgWx5OgjzzHycqcmM6q2DEVKull0afp10sWYGwjgNbD
         Wp5AjbIQxumgztjj2AuWD8jd8FM73R7EC1HMhEXS/RTPlqCHeHUxd08lhhYmzh1dz/vj
         7zFfqZb72ESBMCJ/G6/GYTIez8aGjlQx9Fb2p7XEI85E+P4YD5MSmLTw8zJkFMKOAgHu
         iWgEyF16GwZlIKet82fJDLTbaRsucrr57oqXtATCyLgko0PZ7ZVDjsSofaMNbNBn3m8U
         UUeJ4KgZylGkKsRSIJkZBhAbGEcZGvh5OYZe0ai92DXhO+LxBXlAVu350OOVhRaIyBkj
         a53Q==
X-Gm-Message-State: APjAAAUxpeggic3JtxQsMaGDIMtBxpFIPNkKjvgfNR6IalHbQYsVgIhy
        JcIpdLDjStOadihw2uvLdK9HremTIKOa6iYuP0IrqA==
X-Google-Smtp-Source: APXvYqxtZ6RS190EVhcPAEXpCsTTHX9gHaKFcumPuHU1VSD712jSdxyEDlEcsx+6ns9L97XUK86wnf9qb5k9JtXw1r8=
X-Received: by 2002:a7b:c21a:: with SMTP id x26mr4097412wmi.61.1565720185710;
 Tue, 13 Aug 2019 11:16:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190812145324.27090-1-ard.biesheuvel@linaro.org>
 <20190812145324.27090-3-ard.biesheuvel@linaro.org> <20190812194747.GB131059@gmail.com>
 <CAKv+Gu-9aHY0op6MEmN8PfQhNa0kv=xNYB6rqtaCoiUdH4OASA@mail.gmail.com> <20190813180020.GA233786@gmail.com>
In-Reply-To: <20190813180020.GA233786@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 13 Aug 2019 21:16:14 +0300
Message-ID: <CAKv+Gu8BFxyre0XDpE2To6yEvBP4E16abMZbR=r17TpQQko54Q@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH v10 2/7] fs: crypto: invoke crypto API for
 ESSIV handling
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 13 Aug 2019 at 21:00, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Aug 13, 2019 at 08:09:41AM +0300, Ard Biesheuvel wrote:
> > On Mon, 12 Aug 2019 at 22:47, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > On Mon, Aug 12, 2019 at 05:53:19PM +0300, Ard Biesheuvel wrote:
> > > > Instead of open coding the calculations for ESSIV handling, use a
> > > > ESSIV skcipher which does all of this under the hood.
> > > >
> > > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > >
> > > This looks fine (except for one comment below), but this heavily conflicts with
> > > the fscrypt patches planned for v5.4.  So I suggest moving this to the end of
> > > the series and having Herbert take only 1-6, and I'll apply this one to the
> > > fscrypt tree later.
> > >
> >
> > I think the same applies to dm-crypt: at least patch #7 cannot be
> > applied until my eboiv patch is applied there as well, but [Milan
> > should confirm] I'd expect them to prefer taking those patches via the
> > dm tree anyway.
> >
> > Herbert, what would you prefer:
> > - taking a pull request from a [signed] tag based on v4.3-rc1 that
> > contains patches #1, #4, #5 and #6, allowing Eric and Milan/Mike to
> > merge it as well, and apply the respective fscrypt and dm-crypt
> > changes on top
> > - just take patches #1, #4, #5 and #6 as usual, and let the fscrypt
> > and dm-crypt changes be reposted to the respective lists during the
> > next cycle
> >
>
> FWIW I'd much prefer the second option, to minimize the number of special things
> that Linus will have to consider or deal with.  (There's also going to be a
> conflict between the fscrypt and keyrings trees.)  I'd be glad to take the
> fscrypt patch for 5.5, if the essiv template is added in 5.4.
>

Works for me. I'll respin with the dm-crypt and fscrypt patches
omitted (and the minor fixes you suggested applied).
