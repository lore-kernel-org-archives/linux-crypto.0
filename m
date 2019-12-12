Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A04BC43603
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 15:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 243CC2073B
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 15:39:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ypcPLXip"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbfLLPjl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 10:39:41 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:46893 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729097AbfLLPjl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 10:39:41 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 83fadd44
        for <linux-crypto@vger.kernel.org>;
        Thu, 12 Dec 2019 14:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=ECa0uhCehXyjyzPZCUPxPZw+zZo=; b=ypcPLX
        ipHBsjcKjqTNHBnw3JXmvx9FqhnkMkdJPor23oDgHvbXiv+j9xF4mW4DM/Y+5wHS
        Hpws7RIU839RAPktWcF6D9UbInqQ5MBaOlbcQxlpIk8VBKPyfi9EALLdF/8QrGKE
        V8bNfFcKpo4X9H4fzw/L4snZIK6UnyHAR1DGbHQlO520FRjMkECSY+RblJb7g165
        W7GvGhYNL+EZd8RFZWJ3iC9aSFTgOVtZZz2KIPqe0Y3AI49GtswgUdDktW6aIQVL
        qZ35v1yF8EtE1P9DUP1e1an8kpV0AgPOtvTcxTQ7M5wQ3GYDofzpL7eWTpekwUgQ
        ZlEhIuSUBXwTMJcg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0a5c969a (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Thu, 12 Dec 2019 14:43:51 +0000 (UTC)
Received: by mail-ot1-f45.google.com with SMTP id i4so2419507otr.3
        for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2019 07:39:39 -0800 (PST)
X-Gm-Message-State: APjAAAV9eWSnEKiug04Mxs1bbTGOnWSMmntIJowEISxlhn6clet/VK1i
        3e0585fCKWpEE8wvNwOZy96g4G9UkzKJXC3JlD0=
X-Google-Smtp-Source: APXvYqwpZjmg4D3IHbSbi24sxNXY/MIiQ6lDHg8rlHm1Ij9JA4/4/id5aufjgvgRxGaDnYfwo9WiOenUH1Xmif0krMU=
X-Received: by 2002:a9d:4f0f:: with SMTP id d15mr8984016otl.179.1576165179198;
 Thu, 12 Dec 2019 07:39:39 -0800 (PST)
MIME-Version: 1.0
References: <20191211170936.385572-1-Jason@zx2c4.com> <20191212093008.217086-1-Jason@zx2c4.com>
 <20191212093008.217086-2-Jason@zx2c4.com> <ab103a1e20889d6f4d1a68991e29ae542c85c83c.camel@strongswan.org>
In-Reply-To: <ab103a1e20889d6f4d1a68991e29ae542c85c83c.camel@strongswan.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 12 Dec 2019 16:39:27 +0100
X-Gmail-Original-Message-ID: <CAHmME9qTsQN5-k+Rjgh2C1r6jhBDFSio+qyzUW8b5imOGQdi1A@mail.gmail.com>
Message-ID: <CAHmME9qTsQN5-k+Rjgh2C1r6jhBDFSio+qyzUW8b5imOGQdi1A@mail.gmail.com>
Subject: Re: [PATCH crypto-next v2 2/3] crypto: x86_64/poly1305 - add faster implementations
To:     Martin Willi <martin@strongswan.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Polyakov <appro@openssl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Martin,

On Thu, Dec 12, 2019 at 4:34 PM Martin Willi <martin@strongswan.org> wrote:
> As the author of the removed code, I'm certainly biased, so I won't
> hinder the adaption of the new code.

Thanks.

>  * It removes the existing SSE2 code path. Most likely not that much of
>    an issue due to the new AVX variant.

It's not clear that that sse2 code is even faster than the x86_64
scalar code in the new implementation, actually. Either way,
regardless of that, in spite of the previous sentence, I don't think
it really matters, based on the chips we care about targeting.

>  * I certainly would favor gradual improvement, and I think the code
>    would allow it. But as said, not my pick.

You saw this code well over a year ago and seemed okay with it at the
time. Meanwhile you were inspired to fix your ChaCha implementation to
narrow the gap, but no progress with your Poly1305 one. And I'd like
to avoid adding a NEW implementation to audit for bugs and
vulnerabilities and stuff. On the contrary, this code here is in
widespread use and has been highly scrutinized. So please, don't waste
time doing such a thing. I'd nack it on the grounds of it being an
unnecessary risk.

>  * Those 4000+ lines perl/asm are a lot

Ard just added the same for the new Poly1305 implementations on ARM,
ARM64, MIPS, and MIPS64. This is code that's seen the most possible
eyeballs of code in this category. And now we're finally converging on
a complete set for that, with x86_64 being the last holdout. Please
don't hinder its adoption. Your old code is slow and hasn't received
much scrutiny. This new code is fast and has received a lot of
scrutiny.

Jason
