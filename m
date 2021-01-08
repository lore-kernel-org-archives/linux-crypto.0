Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F265C433E6
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 18:57:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED4B923A82
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 18:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbhAHS5c (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Jan 2021 13:57:32 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:31933 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbhAHS5c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Jan 2021 13:57:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1610132020;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
        Subject:Sender;
        bh=LoKSKXeSFEpp9jINwdUpf+aWvrLnEVKmmEkvbrb/wZ4=;
        b=Sm/E2IBfmtHca4J3xAZwOLZdL5GrG9EIAGiZM8kGw17OzLHbO3UcaTprROwcbcU1K7
        T9G5yjYH6tWsyWaO7/Mi4ziKmEpn6H2spYsZf1fQd32G1FZuf/1Uf6KGI40U5vshwdXa
        VYIWVge8SgDRj1jg92msvi4xqDTf+uFBmqetAubGmwPsUZwY9D9RNnYBN/i/bXgoJtih
        /X+IPN47a6FonYagFAZmGxBc8aDzPM3vLv41crjC3uQ2tbD5GmiQXC+5e459VAPm7acz
        5sx1T6HlAK5M4yQI/vOm0KM9Qz5RwtJNSlMH/E/cxTcOVjaLUX5fw7i8Cq79h+poCcp6
        Vlxg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884EC0GFGHavJShPkMRYMkE="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 47.12.1 DYNA|AUTH)
        with ESMTPSA id Z04c46x08IrbOAD
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 8 Jan 2021 19:53:37 +0100 (CET)
Message-ID: <4b688e56ae45defedb08603945741218736923c0.camel@chronox.de>
Subject: Re: [PATCH] crypto: testmgr - add NIAP FPT_TST_EXT.1 subset of tests
From:   Stephan Mueller <smueller@chronox.de>
To:     Elena Petrova <lenaptr@google.com>, linux-crypto@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>
Date:   Fri, 08 Jan 2021 19:53:36 +0100
In-Reply-To: <20210108173849.333780-1-lenaptr@google.com>
References: <20210108173849.333780-1-lenaptr@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, dem 08.01.2021 um 17:38 +0000 schrieb Elena Petrova:
> NIAP FPT_TST_EXT.1 [1] specification requires testing of a small set of
> cryptographic modules on boot for devices that need to be NIAP
> compliant. This is also a requirement for FIPS CMVP 140-2/140-3
> certification.
> 
> Currently testmgr adds significant boot time overhead when enabled; we
> measured 3-5 seconds for Android.

I am not sure whether this is necessary. If you build the ciphers as modules,
you can insmod them during boot time before general user space is made
available. Once you insmoded all needed KOs, you load tcrypt to invoke them
which implies that they are verified. This approach allows user space to
determine which KOs are self-tested during boot.

This is the approach all Linux validations took in the past.

Besides, for FIPS 140-3, it is now allowed to have "lazy" self testing which
allows the self-tests to be executed before first use (just like what the
kernel testmgr already does).

Can you please help us understand why the mentioned approach is not
sufficient?

Thanks
Stephan

