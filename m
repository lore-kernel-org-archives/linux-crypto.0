Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 709C2C4743C
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jun 2021 17:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5442B611AD
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jun 2021 17:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhFWRaW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jun 2021 13:30:22 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.166]:28398 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWRaW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jun 2021 13:30:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1624469275;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=d9TuVPZ0rF7UOU9FBUncImFHBMM9OrT22FVksrVNH28=;
    b=kQbYTHrtVA1PcBtqv8k9BakqwylVLXQFp5YIYYIHJYlmbFAyt0pVCV6I/WftuiTyWp
    CoSvn1Rkshyxo79rhWuKF2LSeBhVaHlV9PHhiBvd88IT9XAjKSeI4Mz7hmB+w+om3qI6
    c0wGK+6ppTPLQZdTEU9x0aFsTkkBaZgbfjGDp9AudiVmlFyLwQESbiYx0moHvtU32edI
    tWvNo6HQEWaYPZZsbAeTYMcpM6oYwApLfdQK2uVNzs71UxJcgPHS9KAGkSUuaUJMH4D5
    ENKt67VuS9LZocL7svC/A/IaMYFC/bZ7VbjkYDfUzfJ/yEJCn3I05jCz7eAvXgKDIW8G
    x0OQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbJfScDuy6"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.27.5 DYNA|AUTH)
    with ESMTPSA id L04113x5NHRs1oF
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 23 Jun 2021 19:27:54 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     James Morris <jamorris@linux.microsoft.com>
Cc:     =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Haxby <john.haxby@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Simo Sorce <simo@redhat.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>,
        hpa@zytor.com, tytso@mit.edu
Subject: Re: [PATCH v1] crypto: Make the DRBG compliant with NIST SP800-90A rev1
Date:   Wed, 23 Jun 2021 19:27:53 +0200
Message-ID: <8811360.37IJKxs2K1@positron.chronox.de>
In-Reply-To: <a4e1c071-32af-9650-e6fd-8943b3a79bb0@linux.microsoft.com>
References: <20210623120751.3033390-1-mic@digikod.net> <9dbbf4e751cb4953fe63079cdc917a0bb3a91670.camel@chronox.de> <a4e1c071-32af-9650-e6fd-8943b3a79bb0@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, 23. Juni 2021, 19:00:29 CEST schrieb James Morris:

Hi James,

> On Wed, 23 Jun 2021, Stephan Mueller wrote:
> > > These changes replace the use of the Linux RNG with the Jitter RNG,
> > > which is NIST SP800-90B compliant, to get a proper entropy input and a
> > > nonce as defined by FIPS.
> > 
> > Can you please help me understand what is missing in the current code
> > which
> > seemingly already has achieved this goal?
> 
> The advice we have is that if an attacker knows the internal state of the
> CPU, then the output of the Jitter RNG can be predicted.

Thank you for the hint. And I think such goal is worthwhile (albeit I have to 
admit that if an attacker is able to gain the internal state of a CPU, I would 
assume we have more pressing problems that a bit of entropy).

Anyways, the current code does:

- in regular mode: seed the DRBG with 384 bits of data from get_random_bytes

- in FIPS mode: seed the DRBG with 384 bits of data from get_random_bytes 
concatenated with 384 bits from the Jitter RNG


If I understand the suggested changes right, I would see the following changes 
in the patch:

- in the regular case: 640 bits from get_random_bytes

- in FIPS mode: 256 bits of data from get_random_bytes concatenated with 384 
bits from the Jitter RNG

So, I am not fully sure what the benefit of the difference is: in FIPS mode 
(where the Jitter RNG is used), the amount of data pulled from 
get_random_bytes seems to be now reduced.

Maybe I miss a point here, but I currently fail to understand why the changes 
should be an improvement compared to the current case.

Ciao
Stephan


