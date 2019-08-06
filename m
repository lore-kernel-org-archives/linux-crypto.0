Return-Path: <SRS0=y31I=WC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A30DC31E40
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 12:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEC6020B1F
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 12:17:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zhsryLY5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfHFMRt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Aug 2019 08:17:49 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33544 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfHFMRt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Aug 2019 08:17:49 -0400
Received: by mail-wm1-f68.google.com with SMTP id h19so8825639wme.0
        for <linux-crypto@vger.kernel.org>; Tue, 06 Aug 2019 05:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E45FnivbPqKcsfGpty7g0LI8JR/YbnVdWPgdzzyZ8l0=;
        b=zhsryLY5ezEpM2wJSrHlUJ2yOPeDDT8X9D/yM9kU0zwraM1GOWynxFvK+Rg9phJMna
         QSdb0HGiAdgRVHUC7oImVgjvA01Aq0eDYXKXZmHqruI/vKBdNW7/wmnKhNKgxI3LmE7K
         mDBL+nk01XdDrOj60gf/jAN5OICJJsLWbk04y4OUD2UrqtWux/6yyXoLl9AWWr91IA8V
         BdgvRikMKffqzrke0xFGSWNg2wNPGy3Dc7VyBc5qHMQE2YiFHDI/cjKtBWcX2uXVI4cY
         lL7uEc6SnT9fZZc9ZF3yUMFvSHZq5uOFbYvJzG4EJcsQA8R+PCQo8IejwfOuf58ge5e1
         k68w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E45FnivbPqKcsfGpty7g0LI8JR/YbnVdWPgdzzyZ8l0=;
        b=ahTofHszHtH4kap6bAYNkUCHsmNhumdUX819ZYRbBK3CRtQx5WqaM+Yx1dA9JCTqBg
         DUQycCVN8s5ooWI3l/cUJxlcBt6cbfe+tK3spQpyqPG0EhQhNWXj65jM14J491uwcdnd
         ZU5FnOymwpgye0V5cM/tj5LD2omUa3oA3+cze6dXMiEyGsnYt+WGguOPGjlICpdzGtP4
         fGI8ReWC8T7SPHG81iqDizdAPNXM9KLV1BDJ58oyiRrgyrlddm5pSkiB2nJitzusGRrw
         clPUnYnduD4q96O8OmYmZ1PTmbVIo58xCVVPZA7Jb6GZV18vVvrNdGsRy7UNWdsK0oIw
         04fw==
X-Gm-Message-State: APjAAAU3kHV9/wOeV6tLMOC9P0L2VCxCkE69RphODlkg2R4/T+TsBNsc
        CnTKkck1XiU5pHWGN7fHaUooWi2cbFYL03xIgTvBbA==
X-Google-Smtp-Source: APXvYqw4xhdMYu6PeQSd8jt0KIbWrrCarttfBeILCOrC7Z39wvCWaB+sg/8duCT9s57+m+mDn63caNW3QLYsl1clec8=
X-Received: by 2002:a1c:b706:: with SMTP id h6mr4506053wmf.119.1565093867280;
 Tue, 06 Aug 2019 05:17:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190806080234.27998-1-ard.biesheuvel@linaro.org>
 <20190806080234.27998-3-ard.biesheuvel@linaro.org> <22f5bfd5-7563-b85b-925e-6d46e7584966@gmail.com>
In-Reply-To: <22f5bfd5-7563-b85b-925e-6d46e7584966@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 6 Aug 2019 15:17:36 +0300
Message-ID: <CAKv+Gu_LQwtM47njiksCJL2tMx_Zv8Paoegfkah--T6Mh55u3A@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] md/dm-crypt - switch to AES library for EBOIV
To:     Milan Broz <gmazyland@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 6 Aug 2019 at 13:43, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 06/08/2019 10:02, Ard Biesheuvel wrote:
> > The EBOIV IV mode reuses the same AES encryption key that is used for
> > encrypting the data, and uses it to perform a single block encryption
> > of the byte offset to produce the IV.
> >
> > Since table-based AES is known to be susceptible to known-plaintext
> > attacks on the key, and given that the same key is used to encrypt
> > the byte offset (which is known to an attacker), we should be
> > careful not to permit arbitrary instantiations where the allocated
> > AES cipher is provided by aes-generic or other table-based drivers
> > that are known to be time variant and thus susceptible to this kind
> > of attack.
> >
> > Instead, let's switch to the new AES library, which has a D-cache
> > footprint that is only 1/32th of the generic AES driver, and which
> > contains some mitigations to reduce the timing variance even further.
>
> NACK.
>
> We discussed here that we will not limit combinations inside dm-crypt.
> For generic crypto API, this policy should be different, but I really
> do not want these IVs to be visible outside of dm-crypt.
>
> Allowing arbitrary combinations of a cipher, mode, and IV is how dm-crypt
> works since the beginning, and I really do not see the reason to change it.
>
> This IV mode is intended to be used for accessing old BitLocker images,
> so I do not care about performance much.
>

Apologies for being blunt, but you are basically driving home the
point I made before about why the cipher API should become internal to
the crypto subsystem.

Even though EBOIV is explicitly only intended for accessing old
BitLocker images, you prioritize non-functional properties like API
symmetry and tradition over sound cryptographic engineering practice,
even after I pointed out to you that
a) the way EBOIV uses the same symmetric key for two different
purposes is a bad idea in general, and
b) table based AES in particular is a hazard for this mode, since the
way the IV is generated is susceptible to exactly the attack that
table based AES is most criticized for.

So if you insist on supporting EBOIV in combination with arbitrary
skciphers or AEADs (or AES on systems where crypto_alloc_cipher()
produces a table based AES driver), how do you intend to mitigate
these issues?
