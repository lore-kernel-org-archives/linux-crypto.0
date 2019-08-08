Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B94C433FF
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 12:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA8062171F
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 12:27:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pK2Jy2aJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732035AbfHHM1L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 08:27:11 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42679 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728718AbfHHM1L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 08:27:11 -0400
Received: by mail-lj1-f196.google.com with SMTP id t28so88711679lje.9
        for <linux-crypto@vger.kernel.org>; Thu, 08 Aug 2019 05:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LJoQH6xbNoByXFD03CQzff1T1rg3XHHfexy4zm58VFs=;
        b=pK2Jy2aJCqvL6Zbsse9R6qW+16L7rOEkySHszCEBs5F0VKRotPrPyu44jyyDIClbQQ
         3DXllrjriP90L6RaVglWIEDATs2iioGY3o/+TzwopWNuXqtMPsTNpy1XfXKhSr8pH2AI
         PmKanKd9U5CeLi80hdvEiobNCfwIbFdEuMJ60bzrJ9LAfk/2OYiAurZUw0qcixF4M5SE
         YcUWAOtvqaMQSuC25S5dtrp2wI4qSjIkU4XQisSWyRh30It0AZ85X2drJbvJNBnGIRzL
         Z6OeCrSjtn5x6V4mqIwHu4iZR4MPFncMiR6jAKvSTmHx2mMzGxStUZG6zRF4OiFk7FmD
         /3Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LJoQH6xbNoByXFD03CQzff1T1rg3XHHfexy4zm58VFs=;
        b=slR+WxfHRh9syrYxA4sKdRKf5mioT89pUHmD2H752jv9sx9PCUW0+bqDyzc5OyBcGt
         K5cA6DxiFPgfO1JMBch4g6jeUTNIeri6V5GOgB8AneVn70bsomAR+L6PeP1hz0ZtPjnM
         lJIJqgrZGWMNNku//8o/I/Vfh6nZlHcP3HLQYuuLxSESRgjMT1bcMPio8JQH92sqn0zH
         m5vkNDHTsawnLtjIGx92O2aKnJ7FFdSjSshyJxMUIUIbaRE2FOvU0/X1MC/6q9aZE/DQ
         SyTr82lFEkhpvygOKpxut5dbd/1VmuQW+Zgbqs9lP+Wybn4mjFfQUp3Ktj4tBQUXiy87
         fq7A==
X-Gm-Message-State: APjAAAW5zqQ/0uPx8ZqUVTWbHnjcjbI74zmiTPyARm1knwDFcT1ShUq0
        W41ONop+ca/FWDyEjivIq5le2mlr4fgroxG4wbEAlA==
X-Google-Smtp-Source: APXvYqynn5VMST3cneWTKIKRfdQOUrgp2WS4DuM61xZXzMCVt2m7Y/3Qm9PGybsLU6uCQeZXVn92r6kYkU7iqFaN4is=
X-Received: by 2002:a2e:4b12:: with SMTP id y18mr7770792lja.238.1565267229165;
 Thu, 08 Aug 2019 05:27:09 -0700 (PDT)
MIME-Version: 1.0
References: <1565098640-12536-1-git-send-email-sumit.garg@linaro.org>
 <1565098640-12536-2-git-send-email-sumit.garg@linaro.org> <20190807185921.lhdt3ek6tphj33bo@linux.intel.com>
In-Reply-To: <20190807185921.lhdt3ek6tphj33bo@linux.intel.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Thu, 8 Aug 2019 17:56:57 +0530
Message-ID: <CAFA6WYPsNuN=F9y+Q0r8-6MQAGGZeKUtRheQgKv3HmE1ViyviA@mail.gmail.com>
Subject: Re: [RFC/RFT v3 1/3] KEYS: trusted: create trusted keys subsystem
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

On Thu, 8 Aug 2019 at 00:29, Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Tue, Aug 06, 2019 at 07:07:18PM +0530, Sumit Garg wrote:
> > Move existing code to trusted keys subsystem. Also, rename files with
> > "tpm" as suffix which provides the underlying implementation.
> >
> > Suggested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
>
> The name for should be still trusted.ko even if new backends are added.
> Must be done in order not to break user space.

Agree. I think I need to update Makefile as follows:

obj-$(CONFIG_TRUSTED_KEYS) += trusted.o
trusted-y += trusted-tpm.o

-Sumit

>
> Situation is quite similar as when new backends were added to tpm_tis
> some time ago: MMIO backed implementation was kept as tpm_tis.ko, the
> core module was named as tpm_tis_core and SPI backed implementation was
> named as tpm_tis_spi.ko.
>
> /Jarkko
