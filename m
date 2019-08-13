Return-Path: <SRS0=ZPwR=WJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15AA3C32750
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 07:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D74A920665
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 07:59:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gMNzHJkj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbfHMH7d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:59:33 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35561 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbfHMH7c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Aug 2019 03:59:32 -0400
Received: by mail-lj1-f196.google.com with SMTP id l14so10745299lje.2
        for <linux-crypto@vger.kernel.org>; Tue, 13 Aug 2019 00:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ppVR4stowlIJ6/4pZZBiqz7XFOa7GBtQMtynjohKpDM=;
        b=gMNzHJkjPlTKg8J3P1ItvpHxlkyUzWeShHE+QJSJ32VauPTGnzGKsD+QuZrHHI76pj
         RQaLjgiFHttMYl1YL5egx0p1M2IIOgyXxDeB1ftBhbKgE91RpNxJqdP+/QCc15BfoOhL
         Z1+PP778xl2OwXclKn24vrxEMqdB2zsz1S9Mo+1+LLBC3XvBF1qfh81VIeKQdgw15Wfs
         3UPAiB+GQfna3uzgBhqY2DIQZ1U1Dd6wdEjtIkq7MQrftD+JJ76fJF/zUJB30qtgXZ8g
         gkbmkqgpWNNJ+9OWrPYhYkczySrcOktUtmOi5kVY6tzWBM01UKaeDCvccNuWK35inzMd
         u0UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ppVR4stowlIJ6/4pZZBiqz7XFOa7GBtQMtynjohKpDM=;
        b=fRNpAoqWEgTGWXbWyVfdvWpWyir3pPYSMKrGwiKRzSpjB57rSjYEJkrwMRFn8DszHp
         iuIxB5V2H0eAkeESYtMiJ4sPyzcTjZd5SwC2hGpjBtOna+pk/WtcwYjdOSySR0t9VmXc
         lLSzBIs4lnIXqY3VyAw7jtUZJEeJNL17b3ftf+LaPzd202E9L7gp8bWKNNi22X81UoLn
         NC0/mVjgqbZpx+4xSkktx3KSguHnxPGrpRtwmOihGBXsbJEIZ7rfsFrBK6T0BQgMX3Kk
         W27RxkoZhPqEpPUBnlTbXyV1PDGfSOs4+93PloO8LEoOxGeTBgVZPx9X3kmPIpjibmIh
         ULxg==
X-Gm-Message-State: APjAAAX7MvB+ylSj9hPcSOoaKzI3aBsrEJVnqNFxBMOLM1MCd1A/k3R7
        scjERlDVl3l1JueDPImgW1e9a2KbihmLUyRRionjVQ==
X-Google-Smtp-Source: APXvYqy9Xa1Q8vdR2OCkDVG7ShxG5L9IQXmi6qKK2LlN8HtiapeB1JlrnTXdtXIphrZmMJ+SZciCiafKR0IU/QMDd44=
X-Received: by 2002:a2e:970a:: with SMTP id r10mr19876829lji.115.1565683170315;
 Tue, 13 Aug 2019 00:59:30 -0700 (PDT)
MIME-Version: 1.0
References: <1565098640-12536-1-git-send-email-sumit.garg@linaro.org>
 <1565098640-12536-3-git-send-email-sumit.garg@linaro.org> <20190807190320.th4sbnsnmwb7myzx@linux.intel.com>
 <CAFA6WYN-6MpP2TZQEz49BmjSQiMSqghVFWRZCCY0o1UVad1AFw@mail.gmail.com> <20190808151500.ypfcqowklalu76uq@linux.intel.com>
In-Reply-To: <20190808151500.ypfcqowklalu76uq@linux.intel.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Tue, 13 Aug 2019 13:29:19 +0530
Message-ID: <CAFA6WYNqBH9aAM-uke6jFTCeLB2GG7UYyrYEPHgyVy8p_q+Pww@mail.gmail.com>
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

On Thu, 8 Aug 2019 at 20:46, Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Thu, Aug 08, 2019 at 06:51:38PM +0530, Sumit Garg wrote:
> > It seems to be a functional change which I think requires proper unit
> > testing. I am afraid that I don't posses a TPM device to test this and
> > also very less conversant with tpm_buf code.
> >
> > So what I have done here is to rename existing TPM 1.x trusted keys
> > code to use tpm1_buf.
> >
> > And I would be happy to integrate a tested patch if anyone familiar
> > could work on this.
>
> I can test it on TPM 1.2.
>

I have posted v4 with changes as you requested. I hope they work well
with a real TPM 1.x or TPM 2.0 device.

-Sumit

> /Jarkko
