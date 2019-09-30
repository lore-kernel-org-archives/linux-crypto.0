Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FEADC32792
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 11:51:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E556A216F4
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 11:51:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aFUbZShV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbfI3Lv4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 07:51:56 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40358 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729337AbfI3Lv4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 07:51:56 -0400
Received: by mail-wm1-f67.google.com with SMTP id b24so12361421wmj.5
        for <linux-crypto@vger.kernel.org>; Mon, 30 Sep 2019 04:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xCv6dTbvnMB8SFeV9cl5+3jUQ6kSDfEgdA6pLywECvQ=;
        b=aFUbZShVUOmZJo92jk2pfKp/Cdp/oRyOyVvqKqRLjsGCciLpXxi35+HGugTDn8COUK
         1z5SwHPf29fCWO+NL1OJxS2BickZ+RzuxZCTYq3jtBn3wBnOPel4ArRAwsFSPOOfDFRW
         7Oz8ejoQHJ4VJQhE/Up9+sj/cNgXYo8msfuDXFECqV+XENolW7P13O2XA/avg3lqgxJ9
         deXQj9noPxVa1MLjPczHDL4mcjktJu9DPg9e1xqV8CtP4M0uBL+QgouLDaim3BBlZa6t
         Gwrv7Qyxxy3gCkCydHAc1YlY/PtumfQfmKNNWXDnwNFPF1qmobK4Q5e1ZvJzOVeYQrLN
         AGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xCv6dTbvnMB8SFeV9cl5+3jUQ6kSDfEgdA6pLywECvQ=;
        b=ahDKkjSDQivzrSGMA3TQsEauAh5/LmWQ7LpaFlsCnz9181IjUD71eTczmpU9dipyK1
         jye8/K60zU1wWE1BZxj9K6b3Hjh4u5JHzPFmClcI8B5OIYfA6gSsVmsYoiw8FqLwuTcb
         s5eNLDfdzrwD/7c767sNF897kpB7F75A6FPT8g8hoKOa7GKpEy2xIqtqogHLWfmxPnWZ
         m4MQAc/rC1vIwcEHhyVe+sR2RsuaQWmwK+kFYUMzbuj+1MhrOTBbftZ6UB/PqQrBxu7G
         Spp8uQz6w3gGOcCcaiKiBN3/hsVtGFef7+KiADHRdGWjHRIB+CEVr1b4JTALqRMa74M5
         bbuQ==
X-Gm-Message-State: APjAAAUmofSxdawQ8DXIMREuzeuzXczrJMMEsP0/Lx9QoUoqwOrMbfYD
        pOWX0OuUYTJAprZn8BV0qCB/L3/rgvqhzgdILEDNZPquOAAwgg==
X-Google-Smtp-Source: APXvYqynkRE1OhQvv5mNhErEeJpUfsCrVWxWvxzycgxMVCdC4RtlIG+fMFRDY2pXsJwieVzyRlUyEv38DsEHLdJujbs=
X-Received: by 2002:a7b:c451:: with SMTP id l17mr15223458wmi.61.1569844314003;
 Mon, 30 Sep 2019 04:51:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190929173850.26055-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20190929173850.26055-1-ard.biesheuvel@linaro.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 30 Sep 2019 13:51:42 +0200
Message-ID: <CAKv+Gu9=b2VRGo7MZxuSEPZH0Sm67nd1wKd1JVpp45wNkgL8Sw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/20] crypto: wireguard with crypto API library interface
To:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Cc:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 29 Sep 2019 at 19:38, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
...
>
> Patches can be found here:
> https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=wireguard-crypto-library-api
>

Note: I touched up some minor issues spotted by the build robots, so
if anyone pulled this for testing, you may want to pull again.
