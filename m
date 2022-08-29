Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B470ECAAD2
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Aug 2022 10:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiH2Ksn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Aug 2022 06:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiH2Ksi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Aug 2022 06:48:38 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5E35AC7E
        for <linux-crypto@vger.kernel.org>; Mon, 29 Aug 2022 03:48:34 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id q81so6182986iod.9
        for <linux-crypto@vger.kernel.org>; Mon, 29 Aug 2022 03:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=6eEhRyK8tN1mfI2AWsGzTZ1EUrn0gEvL2xA2WQ+MKj0=;
        b=i1WalOLcijhyVYUdO8039B4A6ay+Zlf40F54H7uq4GpTD5HdY7G8Bwfh7cf75YCfP2
         zWx2gXj1Fso4mvLE3U1MBEMkqLkbTz97hIn5T9pEIeA02u4N6mJ8mUW3lqJUdXu6r6i+
         Tyt5pqILw1IEX/msz5o7/wsPZvqj9BpiIjjG0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=6eEhRyK8tN1mfI2AWsGzTZ1EUrn0gEvL2xA2WQ+MKj0=;
        b=VR3xjAhyqaENeR/Oz/td91CXb8KYxlTxrRmb51zfv6fyQSUIKQks9g6B6VmQZ4pm3/
         ktoPH89L3r6r16OCwyRHk6GYMiRDmiWNXNyBOSyLmftG0Vmy6mhwx+zSIKRVwp/IXwTB
         X2/X/6cStF71c2CJCs95173DysI/GpfF7c6uuZQcMz8IVQ1vP6kWb9kQ8anVKLp2imqe
         mub0mT1fIg+k6eQ0uyZsPUdFOz+fvLNjYilzBsGkr2PyZiea07Mopo6XXmXGuq/vO9/5
         /1FEqoOCE/i68Pu3W5CiTuiJV9+wlBhKAG/ptCVCQcn28LfZ52fepVBpwkYLnRrvGWLe
         mfAQ==
X-Gm-Message-State: ACgBeo0MyjZDxXD8945ZzGk5poscwuvdRcUs1wG1Emj+OcaoUop6s4IC
        H6KZStMSoxACqLdPHoJRpRjW/7WlF51jquQTwks3mg==
X-Google-Smtp-Source: AA6agR4REKnRoTZDrAnY0rribqVHuCqe5bvTvVYBr3N5m+fmepZ+EGusZxIoSzIdJoax9PbGfq9c2KBrxkiPll/Bh2s=
X-Received: by 2002:a05:6638:1686:b0:346:a3a5:638d with SMTP id
 f6-20020a056638168600b00346a3a5638dmr9844031jat.0.1661770113770; Mon, 29 Aug
 2022 03:48:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220729165954.991-1-ignat@cloudflare.com> <Yv9dvvy0rK/1T0sU@gondor.apana.org.au>
In-Reply-To: <Yv9dvvy0rK/1T0sU@gondor.apana.org.au>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Mon, 29 Aug 2022 11:48:23 +0100
Message-ID: <CALrw=nEh7LX3DSCa3FTu8BYr4QWx+W2h3Jei9Qo67+XXH-Vegw@mail.gmail.com>
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

On Fri, Aug 19, 2022 at 10:54 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Jul 29, 2022 at 05:59:54PM +0100, Ignat Korchagin wrote:
> >
> > @@ -132,6 +138,10 @@ int crypto_register_akcipher(struct akcipher_alg *alg)
> >               alg->encrypt = akcipher_default_op;
> >       if (!alg->decrypt)
> >               alg->decrypt = akcipher_default_op;
> > +     if (!alg->set_priv_key)
> > +             alg->set_priv_key = akcipher_default_set_key;
> > +     if (!alg->set_pub_key)
> > +             alg->set_pub_key = akcipher_default_set_key;
>
> Under what circumstances could we have an algorithm without a
> set_pub_key function?

I can only elaborate here as I didn't encounter any real-world
use-cases, but may assume some limited crypto hardware device, which
may somehow "encourage" doing public key operations in software and
providing only "private-key" operations due to its limited resources.

Ignat

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
