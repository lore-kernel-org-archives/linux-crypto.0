Return-Path: <SRS0=+pKF=VH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B7F1C74A21
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 14:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C2242084B
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Jul 2019 14:05:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="Qjdcrz2I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbfGJOFz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Jul 2019 10:05:55 -0400
Received: from mail-ua1-f41.google.com ([209.85.222.41]:43392 "EHLO
        mail-ua1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbfGJOFy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jul 2019 10:05:54 -0400
Received: by mail-ua1-f41.google.com with SMTP id o2so907712uae.10
        for <linux-crypto@vger.kernel.org>; Wed, 10 Jul 2019 07:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mn+ZlmXMoQVb8yGmJIWtoOdOytUNAr89dX9zWx6CB0A=;
        b=Qjdcrz2I8BrO/Fp8heGmw+8ii1A686F5gxDnoYaVIphQ3/bq6JxCkW7NWLWM/THhVM
         W0JHZkIXWWgYJrb/i2IM27neacw57z7X0zbGHwr1ksGUkeqMlpPiBMsKVvIp6VU6OPFv
         TawjXFNnxQD/VG0Ebvw0KoNrU1QjEubmSRPw1XijCTdNBCWmwLDhkg1xvTPH3xsL0QyA
         T3UUXqYAFi6zjSLLFGtQ8wgYiHp3qxhsspn3qeQmUHAp2cuxaeybjnSjksDV0T72XPcH
         Mi+sSDpSaecJuqvR6xqSGuDpMV1QN4eyr/dIGPaUgPQD9EgRudb+E8diYlGLvF2WxD9M
         o5yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mn+ZlmXMoQVb8yGmJIWtoOdOytUNAr89dX9zWx6CB0A=;
        b=BDWN2F74J8O+cq0taxtGy5veQJxQ8SrGTXaN1fGP3QkiNtO2HbkEfCOLPb9lXvn/Pl
         y3QtxxJQzZyfwubFwOGn1IAKlxTys10n7DwBufrBzhTwmDvgzE4j/AQWCHoKHst8nYXc
         MXesb8XRbOfmo6fSaVNtmHoDNP4F/q7BjBvYRcZYgXPH+DS3mETUzAJc6PUVilZpy1V2
         mKqZRt7sM64HIq6IFEmHxSph0D1wUuZ0O+m2f8pfUVzNtfXRVr8+IBc987qk08sPmRXv
         KCkuFMgRsdbbcaE/wBXIIKNeC9pc6aJ4VezD0UlUmFo3Go6JRnvxCPyeXP4JmFcRem+f
         r8lA==
X-Gm-Message-State: APjAAAXsYh3CCHuAYHW9UMJj+PWj8RIoOQLeFpNWPnSsf5Xlu/QuSaDi
        ZjEHwOnzMQqJ8hAyt5UcucGvbXPOGLnsDFqGnCHzm07A+cc=
X-Google-Smtp-Source: APXvYqxPIo/zI7WlN+1FZszqnuulz7d5DHaC8rUzK4VeHniB0Rh0XbNaLNITGUVXBGq8bifcxRMFXpQGieJCj0zs4/Y=
X-Received: by 2002:ab0:168a:: with SMTP id e10mr17886088uaf.87.1562767553483;
 Wed, 10 Jul 2019 07:05:53 -0700 (PDT)
MIME-Version: 1.0
References: <TU4PR8401MB0544875B118D39899547FDEFF6F10@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
 <CAOtvUMcUeVYh_eUrQWqunR8NUpos5-7zRU0jn0RdSTMtikm0XQ@mail.gmail.com> <TU4PR8401MB0544C80A8F678CF1DF2BCDF5F6F10@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <TU4PR8401MB0544C80A8F678CF1DF2BCDF5F6F10@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Wed, 10 Jul 2019 17:05:42 +0300
Message-ID: <CAOtvUMeTciKu91cwGidXm1bvaAB+zWvfdARgwF5m64QWEpYx8Q@mail.gmail.com>
Subject: Re: CAVS test harness
To:     "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 9, 2019 at 7:07 PM Bhat, Jayalakshmi Manjunath
<jayalakshmi.bhat@hp.com> wrote:
>
> Hi Gilad,
>
> Thank you very much for the response. I am an entry level engineer when it comes to Linux Kernel.  I have gone through the testmgr. I am not very clear on how to use it for KAT (Known answer tests), MMT and MCT tests.
> Also I am not clear on how to use it with various test vectors for AES, SHA, HMAC, DRBG and RSA
>
> If you point me any example on how to use it, it will provide me a direction to use it.


testmgr automatically runs KAT tests for every crypto protocol that
registers with the kernel at the time of registration. You don't have
to do anything for it to work (except avoiding disabling it - there is
a kernel config option to do that at build time but it is not the
default).
This is typically either at boot for statically built drivers or at
module load time for dynamically built drivers.

If the test fails the specific implementation of that crypto algorithm
will be disabled and if running in FIPS enforcement mode the entire
system will be shut down.

I am not sure what MMT and MCT tests are.

I hope this helped.
Gilad
