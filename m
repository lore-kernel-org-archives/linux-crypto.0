Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D1FC48BC2
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jun 2021 20:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D55C8610C7
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jun 2021 20:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhFWUwb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jun 2021 16:52:31 -0400
Received: from terminus.zytor.com ([198.137.202.136]:57443 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229955AbhFWUw3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jun 2021 16:52:29 -0400
Received: from [IPv6:2601:646:8602:8be1:41b0:e4be:291d:d842] ([IPv6:2601:646:8602:8be1:41b0:e4be:291d:d842])
        (authenticated bits=0)
        by mail.zytor.com (8.16.1/8.15.2) with ESMTPSA id 15NKnWss1881455
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Wed, 23 Jun 2021 13:49:42 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 15NKnWss1881455
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2021052901; t=1624481384;
        bh=uk/YtYtF3NyTcumCvliy/vR0llJ6HHjAYyR6yNJrg3w=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=EcOg1YMYqPLQxUgyx8chx9DZmodpxIRbipSdhYYcxSs3rn7jMEBpK5mbU95wcKOHR
         8+J9iFvUKX4MpFyHsGHbs1ZbzA8tZN4bli0dBI0Q9ZO5nT13ALURL0ZGH15qs3lm06
         I0hgFtqJmdl9+88R2EfcxlyXCMcXQkX/2mXB7zcLZfwNvbqVE0f/PR03s1zQV6B/KF
         Brz0EfQcp6vaYwKUQtDUdsfHOc+dz8mZepwYF/3MOena43Y8cHodwE77M2t6r8mza0
         okpf8DNsnbpcy2OKv4CDNjxl2FTphyEiTOSQZ4HtqTjjQ6Arhgn5Qmv8/NHmKtu+Cp
         ct/ESNxGHl9eA==
Date:   Wed, 23 Jun 2021 13:49:24 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <a4e1c071-32af-9650-e6fd-8943b3a79bb0@linux.microsoft.com>
References: <20210623120751.3033390-1-mic@digikod.net> <9dbbf4e751cb4953fe63079cdc917a0bb3a91670.camel@chronox.de> <a4e1c071-32af-9650-e6fd-8943b3a79bb0@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v1] crypto: Make the DRBG compliant with NIST SP800-90A rev1
To:     James Morris <jamorris@linux.microsoft.com>,
        Stephan Mueller <smueller@chronox.de>
CC:     =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Haxby <john.haxby@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Simo Sorce <simo@redhat.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>,
        tytso@mit.edu
From:   "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <98006AFB-C40E-46F7-BE88-D8E66653B71B@zytor.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This one really does keep coming back like yesterday's herring, doesn't it=
=2E=2E=2E

On June 23, 2021 10:00:29 AM PDT, James Morris <jamorris@linux=2Emicrosoft=
=2Ecom> wrote:
>On Wed, 23 Jun 2021, Stephan Mueller wrote:
>
>>=20
>> > These changes replace the use of the Linux RNG with the Jitter RNG,
>> > which is NIST SP800-90B compliant, to get a proper entropy input
>and a
>> > nonce as defined by FIPS=2E
>>=20
>> Can you please help me understand what is missing in the current code
>which
>> seemingly already has achieved this goal?
>
>The advice we have is that if an attacker knows the internal state of
>the=20
>CPU, then the output of the Jitter RNG can be predicted=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
