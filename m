Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB4CC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Dec 2020 09:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF5C12251F
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Dec 2020 09:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgLXJ5b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Dec 2020 04:57:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:38356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbgLXJ5a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Dec 2020 04:57:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE723229CA
        for <linux-crypto@vger.kernel.org>; Thu, 24 Dec 2020 09:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608803809;
        bh=FaH+aUDPfv9aEaqn2OQODZ7wMaqcyGEzBVlxSt4e2ME=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hOKtiF1VNXOh9ThiewHgZElhZP1FCc8jBEvTfa1GxTQAoSa9/Xo9Y9VxQJ3eI8ncR
         UWxsjyyZe6xj2jP46ZTH42Iqo5Z5cp8RUtDlaJh2Wfjhv6gHqmCz0w2itptSajKQt5
         ys3QyoQ08NJtgtUDbLgmSFy+dkar3dENtBvIf7nTeXgkjTXaenqE3Un0p6C77tls+X
         v9Jd3yZigMHbj+RgD4MsQaMt0CoXivnQmIWF+rQ0XRO39LOT3sDds+W3Dkmiru4fOT
         MXcJjDtzk8jYH2OZMPs3YDXR+aBSaqIDMMCsG9FGJjwu2jtRu8kqM6uY4jw0SO6SPi
         1RIV6+gaFqiTg==
Received: by mail-oi1-f179.google.com with SMTP id 15so1915916oix.8
        for <linux-crypto@vger.kernel.org>; Thu, 24 Dec 2020 01:56:49 -0800 (PST)
X-Gm-Message-State: AOAM531fTSu9LabNZPCXLju/ktGqa24KDwpoy8hiqluVdtxrQYf/A9uZ
        UgBvABBQt47CPp5UUG4pse0ga3oTTqFJAcbVePw=
X-Google-Smtp-Source: ABdhPJyJVKnUfd3D1h+72t/QQy4A04Gab7AwQXcwdGD1QMVLr97Qh1xVnE4NhLIimRh41kNmduD2cCZK8KAA2XDa3GQ=
X-Received: by 2002:aca:dd03:: with SMTP id u3mr2420893oig.47.1608803809071;
 Thu, 24 Dec 2020 01:56:49 -0800 (PST)
MIME-Version: 1.0
References: <20201223223841.11311-1-ardb@kernel.org> <dff974aa-4dcf-9f4a-83db-eb4883aa3376@gmail.com>
In-Reply-To: <dff974aa-4dcf-9f4a-83db-eb4883aa3376@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 24 Dec 2020 10:56:38 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE2Y=7OKsHccv59uzc_Jg7vixkrnYQRgX6RRYJQiHnKOw@mail.gmail.com>
Message-ID: <CAMj1kXE2Y=7OKsHccv59uzc_Jg7vixkrnYQRgX6RRYJQiHnKOw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] crypto: x86 - remove XTS and CTR glue helper code
To:     Milan Broz <gmazyland@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        dm-devel@redhat.com, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mike Snitzer <snitzer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 24 Dec 2020 at 10:33, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 23/12/2020 23:38, Ard Biesheuvel wrote:
> > After applying my performance fixes for AES-NI in XTS mode, the only
> > remaining users of the x86 glue helper module are the niche algorithms
> > camellia, cast6, serpent and twofish.
> >
> > It is not clear from the history why all these different versions of these
> > algorithms in XTS and CTR modes were added in the first place: the only
> > in-kernel references that seem to exist are to cbc(serpent), cbc(camellia)
> > and cbc(twofish) in the IPsec stack. The XTS spec only mentions AES, and
> > CTR modes don't seem to be widely used either.
>
> FYI: Serpent, Camellia and Twofish are used in TrueCrypt/VeraCrypt implementation;
> cryptsetup and I perhaps even VeraCrypt itself tries to use native dm-crypt mapping.
> (They also added Russian GOST Kuznyechik with XTS, but this is not in mainline,
> but Debian packages it as gost-crypto-dkms).
>
> Serpent and Twofish can be also used with LRW and CBC modes (for old containers only).
>
> Cryptsetup uses crypto userspace API to decrypt the key from header, then it configures
> dm-crypt mapping for data. We need both use and in-kernel API here.
>
> For reference, see this table (my independent implementation of TrueCrypt/VeraCrypt modes,
> it should be complete history though):
> https://gitlab.com/cryptsetup/cryptsetup/-/blob/master/lib/tcrypt/tcrypt.c#L77
>
> If the above still works (I would really like to have way to open old containers)
> it is ok to do whatever you want to change here :-)
>

Thanks Milan.

With the XTS code removed from these drivers, the XTS template will be
used, which relies on the ECB mode helpers instead. So once we fix
those to get rid of the indirect calls, I'd expect XTS to actually
improve in performance for these algorithms.

> I have no info that CTR is used anywhere related to dm-crypt
> (IIRC it can be tricked to be used there but it does not make any sense).
>

Yes, that was my assumption. Thanks for confirming.
