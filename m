Return-Path: <SRS0=MZ7V=QG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E05C282D7
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 14:39:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78AFB20857
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Jan 2019 14:39:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="tFT+n6ob"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfA3Ojk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Jan 2019 09:39:40 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:27286 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727149AbfA3Ojk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Jan 2019 09:39:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1548859178;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=lOHjx49VveWcbpzwKb8LwDQ/AQ7msHuvzFJK5Zg+ZQA=;
        b=tFT+n6obLMLzQ5aGqyxs3s2Y/j/QceG/DLlMi4Y5c8icGLB2qI5LX2LGDw2sHxmzoj
        s9b2OMH+7HX8NcZhS0smJ8upjfB8hpmvknotN4fOy7LSH0dC8RW62cQNOhUcoc1XDa+Y
        OuU5i9Cb2qV34az+499KoQmTNfZMHiQeMxQR2mnS09LW7TPLOFlnN4Ccm9l1hgAUAfVG
        NU0sDj9hLrwaZ+riyTh8+txvMWUE1yT+EysgTQ2ZRzxdYzlWsIdHTuCD4DHPo5kbQncc
        vERwyK116caccSNm55CbglpqUd3fWQVKhZrmjm+TPEpkhSMwOUhUqLvWlu/Dn+BdZaE7
        XU3g==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9x24dP3Zg1I6xSGfZ"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.9 AUTH)
        with ESMTPSA id 309bcfv0UEdCLXm
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Wed, 30 Jan 2019 15:39:12 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, keyrings@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chen Yu <yu.c.chen@intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Ryan Chen <yu.chen.surf@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Giovanni Gherdovich <ggherdovich@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jann Horn <jannh@google.com>,
        Andy Lutomirski <luto@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 0/6] General Key Derivation Function Support
Date:   Wed, 30 Jan 2019 15:39:10 +0100
Message-ID: <12103603.N4N57GesWC@tauon.chronox.de>
In-Reply-To: <20190130100854.iey2mbmz6777pn2n@gondor.apana.org.au>
References: <20190103143227.9138-1-jlee@suse.com> <5418064.ltLFQScYi2@tauon.chronox.de> <20190130100854.iey2mbmz6777pn2n@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, 30. Januar 2019, 11:08:54 CET schrieb Herbert Xu:

Hi Herbert,

> I'm still not convinced why this needs to go into the crypto API
> instead of being hosted in a helper which should achieve pretty
> much the same result.

How do you propose to handle the FIPS 140-2 related requirements of enforcing 
the integrity test result and the known-answer self tests?

Thanks
Stephan


