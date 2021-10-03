Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C7CC433FE
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 00:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D845E61AF9
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 00:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbhJCAJx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Oct 2021 20:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234236AbhJCAJw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Oct 2021 20:09:52 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CB6C0613EC
        for <linux-crypto@vger.kernel.org>; Sat,  2 Oct 2021 17:08:06 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id t4so726379plo.0
        for <linux-crypto@vger.kernel.org>; Sat, 02 Oct 2021 17:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=callas.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=DkQ6IRkEUKachDYiECv++90Ss3z7wENE2DZR/9gtVkA=;
        b=Vhlbv7VZp+Mp0SiIE9/L5FUOMKYWZAlkclV5VwfUi/MFgTbBH3ChSsTo1GjWz2FWZy
         PkEZFGr/VEyyllOLJmDwffvMZprjG/Bnd5ldapGUbNarziavqXlKX0KTWpaEa08paSWW
         tq5C2cCQmNX+PZn5ZrGhwh2ecc0sSdqWNNzpOwo1rFRdtcXnSiDd5/lUK7p2aOsQyDcL
         aQUaDZ/u3VCwdklggH/msLX/XA1daGpX0SDQ4Mj2IegAkYmHaMJSYKQFqvq7dgD9luQi
         tkuy399/Zk2CyLRoJtKOsGjzdCsNUI/YQCxBJPIKf08LeSgQBvOn2sxzQd4/iDV03AWs
         VwUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=DkQ6IRkEUKachDYiECv++90Ss3z7wENE2DZR/9gtVkA=;
        b=7RrJ9g6xBrYmUG1ao3Z0FzIkZCcGxbUk40T3vnkNCIF951RzZguQFRqtUU/D3cnFVo
         KJ6MGfKP/pDVunwjyZo1KfptmUGGnxUhwtzmZR5EMWmZQN/HG0osfcHJIDoOHI3iGRT4
         W5vOJzDmY42C0LaHD2eJiRe1E7Rtg+lnVbFdOexpiMF6NJd0ita10s2/ka/bbBiF+4BI
         RRT10KPD2zv7zrxhtaAcmy8OozYBrjGLe96GMu9jokQV8fMaPH2raCKUQx5Hr4yZcz08
         ITEbozTIKzOZwjdpZZt/C4Kpw9yMFywAdRukD2hIY4jR4PYl7Uodt6KKFc9Nz3mfVDGZ
         bb8Q==
X-Gm-Message-State: AOAM53313vxvKnlQhKBtzO18QMvriFA9zSqRhNuFifwUAWVM5GQhrzdE
        VEzreQrNi7OAfhxWUypdol6zoylWw5/VZdKc
X-Google-Smtp-Source: ABdhPJwiI+lO/lgvi0ZCzecyyibDIEJchExxB7Dj8qllU0wGLvIIRALNTPrxbtDI09onD0il5PQJYQ==
X-Received: by 2002:a17:902:7d95:b0:13d:a304:1b55 with SMTP id a21-20020a1709027d9500b0013da3041b55mr16342343plm.51.1633219685560;
        Sat, 02 Oct 2021 17:08:05 -0700 (PDT)
Received: from smtpclient.apple ([2600:1700:38c4:12bf:b553:2d38:d1e0:adbb])
        by smtp.gmail.com with ESMTPSA id p17sm10335352pfo.9.2021.10.02.17.08.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 02 Oct 2021 17:08:04 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [Cryptography] [RFC] random: add new pseudorandom number
 generator
From:   Jon Callas <jon@callas.org>
In-Reply-To: <CACXcFm=-E_wnDdRPztKJwDo8hvt6ENf84D90iFUXReuw2s0kuQ@mail.gmail.com>
Date:   Sat, 2 Oct 2021 17:08:03 -0700
Cc:     Jon Callas <jon@callas.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Cryptography <cryptography@metzdowd.com>,
        Ted Ts'o <tytso@mit.edu>
Content-Transfer-Encoding: quoted-printable
Message-Id: <378733E4-D976-4E2D-BE14-AD900C901CE8@callas.org>
References: <CACXcFm=-E_wnDdRPztKJwDo8hvt6ENf84D90iFUXReuw2s0kuQ@mail.gmail.com>
To:     Sandy Harris <sandyinchina@gmail.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> On Sep 16, 2021, at 20:18, Sandy Harris <sandyinchina@gmail.com> =
wrote:
>=20
> I have a PRNG that I want to use within the Linux random(4) driver. It
> looks remarkably strong to me, but analysis from others is needed.

A good block cipher in counter mode makes a pretty-okay PRNG. I say =
pretty-okay only because I would like my PRNG not to be invertible. =
Iterated hash functions are better. However, they are slower, and a =
property you want in a PRNG is that it's fast. I did a system PRNG that =
was intentionally faster than arc4random() and close to =
linear-congruential because then there's no excuse for not using it. A =
mildly evil person would replace both of those with a fast real PRNG. =
(Mildly evil because if some user knew the internals and was counting on =
it acting the way the internals specified, they might be disappointed.)

XTEA is an okay block cipher. Not great, okay. Probably good enough for =
a PRNG. But -- why wouldn't you use AES? An obvious answer is that you =
don't have it in hardware and see previous 'graph commentary about =
speed. Note that XTEA is a 64-bit block, so if you compare to AES, take =
that in mind.

The NIST AES_CTR_DRBG is mostly-okay. It's got a few issues (see =
<https://eprint.iacr.org/2020/619.pdf>), but you can get around them. I =
don't like that it takes a simple concept (a good block cipher is a good =
PRP/PRF) and throws enough scaffolding around it to make it hard to =
understand. I understand the reasons (they are essentially the same as =
your rekey protection and some more), it just bugs me.

So why not just use your CPU's AES (assuming you have one), or further =
wrap XTEA in the DRBG stuff for the added misuse protection? Or even =
iterate MD5, or, ummm, you knew this was coming, didn't you, use the =
PRNG mode of Skein-512 (which is about twice as fast as software AES on =
a 64-bit CPU)? Yeah, I know, driver. So we're back to why not AES? =
What's the design consideration?

	Jon

