Return-Path: <SRS0=zZ2Z=US=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F85C43613
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 21:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A30BD208CA
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 21:47:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aoMXkXVU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbfFSVrd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jun 2019 17:47:33 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40513 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfFSVrd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jun 2019 17:47:33 -0400
Received: by mail-io1-f65.google.com with SMTP id n5so314115ioc.7
        for <linux-crypto@vger.kernel.org>; Wed, 19 Jun 2019 14:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jn7rTsnoTMINgPGQpUAUNP/1ZCSKZbUiyrspL4IPrIQ=;
        b=aoMXkXVUNysZd1OrGPLYLxbG1L1WIqZrN++sOPLGf5wLhzrpv/HyMBSWHaOqdby9L/
         GRzrD2jhF4Tjv7ZXw/krKAuSvvPEri4IfhP184lovzMb9ZZOZWN3flbPXHUbYouRboTB
         N83QI2LaI7RAgFNrEq5pxgZaNPry9y78ug5mxC9CqUBsHfJj3a1ehexiKAmDJDyQ4GAk
         EESxIL14siyPmN+fIxtwntOVZkENSNFLpAnPoENtF1qRC/ScqSKjAZtfYAyceqagTyC4
         aCkmW3jYhKuyEs0eS9BnPVYZe5AKxj4ESv5UR4ZZanEqtF2MORQsBKhoR70thUuG+J12
         tUmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jn7rTsnoTMINgPGQpUAUNP/1ZCSKZbUiyrspL4IPrIQ=;
        b=uaZhoVd0mAR5YYJPK+pv4V/w6a9c8S7mPH1xpN4+ZHb7hWnIplk274gff1swgJ5+Oy
         2IJWmPTp8emfKEuaXJrHEAKaw+Z4uCYf+6jKlyT12ghoMcOcrzzz7NUtsCiVvHfUGlXP
         aXcCSeCROoYcH6U4TvMC1j27AgLVzJiYipqLCcz7lYYK9yeRyMwlHBcmo0nY685hWw99
         DzWhNSZiNs0T7avSO9VotDNhKOv1b0f087SrWidKb2+2zlTc8W7eB4zntXPJMOtVtWxE
         lkAkCrdMuzQWJSoVAo80kKildXzhQ3R+nyV9U8Kb/8Gz/xDC8X+pNk3+mG7FE3YUeeq3
         2Zzg==
X-Gm-Message-State: APjAAAV4VwrJJxISCAMJHzIkh81Iqp0+yovx0gWbwbaX1w3tlgCOI9N2
        EnXT1kWyPuL2LAjcJGdNiRbd6vwhuU0xGcy52+/ucQ==
X-Google-Smtp-Source: APXvYqwubEzC2W3o+M/c7dg3wspsTqDJRo7V9LviqwzAh4/9pKsymlPU4a8TvgNldaxNRieGyMcrWmR2PWbukIQGy8o=
X-Received: by 2002:a5e:820a:: with SMTP id l10mr13045052iom.283.1560980852010;
 Wed, 19 Jun 2019 14:47:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190619065510.23514-1-ard.biesheuvel@linaro.org>
 <20190619065510.23514-2-ard.biesheuvel@linaro.org> <20190619.174234.2210089047219514238.davem@davemloft.net>
In-Reply-To: <20190619.174234.2210089047219514238.davem@davemloft.net>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 19 Jun 2019 23:47:19 +0200
Message-ID: <CAKv+Gu9h7tJo=faEOceZ=6Zk1sBOCh-jBa3bgBAd3jr-sATbJQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/1] net: fastopen: robustness and endianness
 fixes for SipHash
To:     David Miller <davem@davemloft.net>
Cc:     "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Christoph Paasch <cpaasch@apple.com>,
        David Laight <David.Laight@aculab.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 19 Jun 2019 at 23:42, David Miller <davem@davemloft.net> wrote:
>
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Date: Wed, 19 Jun 2019 08:55:10 +0200
>
> > +     ctx->key[0] = (siphash_key_t){
> > +             get_unaligned_le64(primary_key),
> > +             get_unaligned_le64(primary_key + 8)
> > +     };
>
> Please just use normal assignment(s), because not only does this warn
> it looks not so nice.
>

OK

Please disregard the v3 I just sent out, v4 has ordinary assignments.
