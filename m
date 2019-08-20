Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF9EC3A59E
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 05:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26AB422CF4
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 05:54:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mBAWDpjT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfHTFyu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 01:54:50 -0400
Received: from mail-lf1-f49.google.com ([209.85.167.49]:38327 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729024AbfHTFyu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 01:54:50 -0400
Received: by mail-lf1-f49.google.com with SMTP id h28so3144981lfj.5
        for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2019 22:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jowVXpXZgLEBuubaLIPC/QF8SFYMD8+3/TNrlzPJxE8=;
        b=mBAWDpjTTfJVh3RC0922MA5+HowZtwi7RtzXrtoBI1p2A0G0YGWQXsIiSmuUuqYyCU
         MAyIWLCURsQlmS5RB3pHRhsabjxs0tQ/4YtoNmDgSGxpPYggJKJyeVZs7oThaxWQP8Ur
         YaZ2GhoxcFJjPekwgESCVZnPcqH5ldcWCjWaagKDoMMDrDsj+LD4Z8EvfU4PWOv2Ubwm
         lWFXcNFcNmAkglcGF5BU5vjQUtUTkTI2VE7CdEmu0B5ao5QZCjEiZWJDDqG5dXHVfLh+
         ocmeghdQqT00z2j9smJzZApj6YMlQN+lUKqAF8lJAfaJlPX+3VyK0GBaUdH+szAJX/Vh
         PPUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jowVXpXZgLEBuubaLIPC/QF8SFYMD8+3/TNrlzPJxE8=;
        b=RNR5Q8pL9VMXUHvVlRXC9ok4nyT8fjMo77pRuo/oTC5DwKAlNAr0LZWt9WR/W+wBlV
         sGUX0xEAX53UqqwMXqu9zv2XDulsKtw8RRCh/Zh2XS4KXFWvJfHP9xEfS56etUqaEogV
         /pSF79GO+dLVMmQGaIy9c/zfoH0C1t51oJaxgN9HAP2Iyb2h3wc/JTr/GowTyYqJS+9D
         Qpfqp1158UOwbG2aOR2UHf7kMdzZSANToFmxaE8B+pVWpXai4eLELiLPkmDzLsDmQDZZ
         7tN2+/f5YTmKcl0QB+3DmbfHyIs49wMaOp+FNyZO2CRaUICBBr/N3T0HNTLZsqUm6pl5
         Lm3Q==
X-Gm-Message-State: APjAAAUqMbl4VUA9pMveBrOcullMFYs4+S+3Wr5Kpvu258x3zVZHhhk8
        CVHbjLc8iP5MiX7cn2HBmUWsoaw4SVhsEnl7EeTV4g==
X-Google-Smtp-Source: APXvYqxK6lXyXCiPc+VFsi+NqG4Bwv+McsYBNdyejsbuMvGdswPfMXEh6xMWaxxRYosmxjdTcrCIZv43cDqFKzqOkeM=
X-Received: by 2002:ac2:5c42:: with SMTP id s2mr14740567lfp.61.1566280488399;
 Mon, 19 Aug 2019 22:54:48 -0700 (PDT)
MIME-Version: 1.0
References: <1565682784-10234-1-git-send-email-sumit.garg@linaro.org>
 <1565682784-10234-5-git-send-email-sumit.garg@linaro.org> <20190819170750.7cl7bdmtam3jras4@linux.intel.com>
In-Reply-To: <20190819170750.7cl7bdmtam3jras4@linux.intel.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Tue, 20 Aug 2019 11:24:37 +0530
Message-ID: <CAFA6WYP8aF8=crPXQiBg0eb8cRk7o6_=iMQp1KMMmxQrkMS8uw@mail.gmail.com>
Subject: Re: [RFC/RFT v4 4/5] KEYS: trusted: move tpm2 trusted keys code
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

On Mon, 19 Aug 2019 at 22:37, Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Tue, Aug 13, 2019 at 01:23:03PM +0530, Sumit Garg wrote:
> > Move TPM2 trusted keys code to trusted keys subsystem. The reason
> > being it's better to consolidate all the trusted keys code to a single
> > location so that it can be maintained sanely.
> >
> > Suggested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> > ---
> >  drivers/char/tpm/tpm-chip.c               |   1 +
> >  drivers/char/tpm/tpm-interface.c          |  56 -----
> >  drivers/char/tpm/tpm.h                    |  16 --
> >  drivers/char/tpm/tpm2-cmd.c               | 308 +-----------------------
> >  include/keys/trusted_tpm.h                |   7 +
> >  include/linux/tpm.h                       |  56 +++--
> >  security/keys/trusted-keys/Makefile       |   1 +
> >  security/keys/trusted-keys/trusted-tpm2.c | 378 ++++++++++++++++++++++++++++++
>
> Would prefer trusted_tpm2.c.
>

Okay.

-Sumit

> /Jarkko
