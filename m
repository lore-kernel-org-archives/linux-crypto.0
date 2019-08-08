Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12E3AC32754
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 13:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDF3D208C3
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 13:21:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VnEIalSf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389844AbfHHNVy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 09:21:54 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36623 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389860AbfHHNVw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 09:21:52 -0400
Received: by mail-lf1-f68.google.com with SMTP id j17so12818315lfp.3
        for <linux-crypto@vger.kernel.org>; Thu, 08 Aug 2019 06:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yPRSbt/ERroXQ3CLHiXg6WnTxTB+hRN/pv9SKNLhs4Y=;
        b=VnEIalSfu0SZj1Vm/7X2ReQgboUTXdytq3Ju8ZMCLD0t3tVftiaZQuk+TGh7D/LUAa
         gaJaZK+auUmyKPLOORwZmJFQiOa1ihPZgxLYmqTdU8rB/57WqFu9TtOa5uA20I7UgE+3
         hlphlO0UxK7JErrmwkGtDe4+fieeQpbxTcEr9701DA3NfDdfJaSMaDWW6uMdHChjnTxs
         c7obhEnph33x5gT/xTjbhUcev8i0z9IHueN7LM/Nj0+821pA2r/BLVCjqtKE7qdaOENC
         ts+fBmh/V6Fk09XKlbD70WrSjLEs1MNWTmkYJYa4UFM30KkQvAf/nYNhcMDAvtHbjAzX
         tcrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yPRSbt/ERroXQ3CLHiXg6WnTxTB+hRN/pv9SKNLhs4Y=;
        b=hx7lyMslDr/qWxCE8OT5becKeHX9mIHTvXulUrWlsiGhqxwcx193GoCqmN+e/pGixe
         VPlK4UPBp5RXYhwEVWJPkOSeY+yaCp11O5dn6MwN+YDb1pZ7QvI1TXhxpGS6G0t7tDMb
         laxS/ASzRXbQ34zlLCBT7Tim4Is0HSNcbeBrdGfOf5I7of1OLP/nniQG+5S4roPxyJRi
         2sNQeaG4u9CKxHXpS10hkiwEpa7lQAvDjQW0ImnhcG7PE8PVJSyRjFkqO7WtY1SnrE3U
         S1BoWLLCbppHLHM+XsFnpxACnbCTYaXoDgUbAT0BKOtFekvP3QJnr8EEKbqCLP7/kzmY
         ecJA==
X-Gm-Message-State: APjAAAVIzXc/NpS9zSBX20/EuD7bOj4tRfEqtBimBFqoUyl8Gvhqf8Zx
        ysXI0RbWg98n6GbhUkro75bpWjdCCKJ1bh4F6dZjZA==
X-Google-Smtp-Source: APXvYqw4VebWjEwpo3i9J0LRc5h0s+ynpfKok3QYD7qKC4/j06X+QGgIcDtFC+QCcnhYJmwAPh6zR54jEVVZOZgyJm8=
X-Received: by 2002:ac2:4901:: with SMTP id n1mr9552721lfi.0.1565270510135;
 Thu, 08 Aug 2019 06:21:50 -0700 (PDT)
MIME-Version: 1.0
References: <1565098640-12536-1-git-send-email-sumit.garg@linaro.org>
 <1565098640-12536-3-git-send-email-sumit.garg@linaro.org> <20190807190320.th4sbnsnmwb7myzx@linux.intel.com>
In-Reply-To: <20190807190320.th4sbnsnmwb7myzx@linux.intel.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Thu, 8 Aug 2019 18:51:38 +0530
Message-ID: <CAFA6WYN-6MpP2TZQEz49BmjSQiMSqghVFWRZCCY0o1UVad1AFw@mail.gmail.com>
Subject: Re: [RFC/RFT v3 2/3] KEYS: trusted: move tpm2 trusted keys code
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     keyrings@vger.kernel.org, linux-integrity@vger.kernel.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-security-module@vger.kernel.org, dhowells@redhat.com,
        Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        peterhuewe@gmx.de, jgg@ziepe.ca, jejb@linux.ibm.com,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "tee-dev @ lists . linaro . org" <tee-dev@lists.linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 8 Aug 2019 at 00:33, Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Tue, Aug 06, 2019 at 07:07:19PM +0530, Sumit Garg wrote:
> > Move TPM2 trusted keys code to trusted keys subsystem.
>
> Missing a long description. The reason is that it is better consolidate
> all trusted keys code to a single location so that it can be maintained
> sanely and it should be stated here.

Sure will extend the description.

>
> > Suggested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
>
> I would suggest adding at least two commits before this:
>
> - A commit that just exports tpm_buf stuff and TPM2 constants to
>   include/linux

Okay, will create a separate patch for this.

> - A commit that just changes the existing TPM 1.x trusted keys
>   code to use tpm_buf.

It seems to be a functional change which I think requires proper unit
testing. I am afraid that I don't posses a TPM device to test this and
also very less conversant with tpm_buf code.

So what I have done here is to rename existing TPM 1.x trusted keys
code to use tpm1_buf.

And I would be happy to integrate a tested patch if anyone familiar
could work on this.

-Sumit

>
> These should be before the current 1/3 commit.
>
> /Jarkko
