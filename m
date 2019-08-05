Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A8FC433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 05:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D024B20B1F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 05:03:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Pp7rr9JW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfHEFDN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 01:03:13 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43272 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfHEFDN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 01:03:13 -0400
Received: by mail-lf1-f65.google.com with SMTP id c19so56857971lfm.10
        for <linux-crypto@vger.kernel.org>; Sun, 04 Aug 2019 22:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=59rGgYKXfbOVeORIb/3aPCsYO+up32tSP1XLT583cgM=;
        b=Pp7rr9JWyW8rvNf7mskAanI9AtGCJ6FROK5Y/83r2NqcfGniuX15dpaNbFLBKhal8P
         wcn6BAM1OS2b7l9JhEUu+FS4jI0d/3GAs5fSPHIOYeXXTcNlYrreX9QFYp2amkc/us3n
         fPQS0IYuedLccQz4EBV6PVVi4j1lGml4t6nHKJjsvODNUqz+ZKWMwtQ4XS8y7BbkFPlR
         UfGU2a2Vdilwtonwk61BmmALDw8mJueH6lj6efGPTYSB54fQ4ghZlgkmuLk0TB4C9uCT
         q+r1ixbNM2GsHvVAAVMDTBsMBXdUeRcU3exa0a88mrKmpwKKtzY2uB0ycJSYruz7r9JQ
         GjlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=59rGgYKXfbOVeORIb/3aPCsYO+up32tSP1XLT583cgM=;
        b=eD+6sep/SShRtbDeVW6+mvLUIqZL1yIDjM5l1ZmT3ejQcCWvd1L5BeEAF8xFXuRa9c
         KT43GErxLt1Nol6KXoE2JFUUb27urMt7R0QE6LpMKlG81H2fvN21kjy7NQ4hR4RnPBcs
         MbUfw/cQM9g2S5js2vzLQ23y0QoVhMlivsYfSlhFEHAYh7dT1pAejdLKFqzyjXscffJV
         M63GZlZFK4ix4PuIFHFRJQw0celWQVwC9UbgbS5R6mTEpkg0jtwA9r/mPlRuq0/j8Pf+
         TXMHbP1jsuI9SwxkwFU5U0O05l6K4Kiv25je8K44OLbRY/s3+mNsWgP9yK0p5AvUmyOF
         TbZg==
X-Gm-Message-State: APjAAAWv9VaxciqoaI3SIWElLCOt4+0iOIV4Or65zkBpFXgzJ4UTXk7z
        S1NO0oaqRr9CaACb7AwT9Em5kAx4PMzQqrHU7Mfv9g==
X-Google-Smtp-Source: APXvYqy5gh4FUNfT5zeuzGIzpHixqpgMfXNy82xJgmEg1C0rn6VH0AyjgsO7hoUJnb3lPf96FzNFy/x/O14eI0YZFv4=
X-Received: by 2002:a19:c7ca:: with SMTP id x193mr14674281lff.151.1564981391240;
 Sun, 04 Aug 2019 22:03:11 -0700 (PDT)
MIME-Version: 1.0
References: <1563449086-13183-1-git-send-email-sumit.garg@linaro.org>
 <1563449086-13183-2-git-send-email-sumit.garg@linaro.org> <20190801172310.cldcftfdoh5vyfjg@linux.intel.com>
 <CAFA6WYM+FQuXA9Saj5+ffOGsc-shhiF5Uos4g14Qndvu6w97Sg@mail.gmail.com> <20190802193802.jn56jhoz5crebggt@linux.intel.com>
In-Reply-To: <20190802193802.jn56jhoz5crebggt@linux.intel.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Mon, 5 Aug 2019 10:32:59 +0530
Message-ID: <CAFA6WYOMXc2y=vXOwRv+PYyF8oBV70G7CrJ81jvD5yJT41zLZw@mail.gmail.com>
Subject: Re: [RFC/RFT v2 1/2] KEYS: trusted: create trusted keys subsystem
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     keyrings@vger.kernel.org, linux-integrity@vger.kernel.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-security-module@vger.kernel.org, dhowells@redhat.com,
        Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        jejb@linux.ibm.com, Mimi Zohar <zohar@linux.ibm.com>,
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

On Sat, 3 Aug 2019 at 01:08, Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Fri, Aug 02, 2019 at 11:20:09AM +0530, Sumit Garg wrote:
> > On Thu, 1 Aug 2019 at 22:54, Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com> wrote:
> > >
> > > On Thu, Jul 18, 2019 at 04:54:45PM +0530, Sumit Garg wrote:
> > > > Move existing code to trusted keys subsystem. Also, rename files with
> > > > "tpm" as suffix which provides the underlying implementation.
> > > >
> > > > Suggested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> > >
> > > What about TPM2 trusted keys code?
> >
> > Isn't TPM2 code located here: "drivers/char/tpm/"? Would you like to
> > move that code under trusted keys subsystem only?
>
> Yeah, we need a design decision here. What I care is that they should
> be in the same subsystem. I did trusted keys directly to TPM 2.0 subsys
> because the subsystem was not too robust back then.
>
> Right now I think it would be feasible to implement TPM2 trusted keys
> outside TPM driver since the whole transmit functionality is way more
> robust.
>

Okay, I will try to move TPM2 trusted keys code also.

-Sumit

> /Jarkko
