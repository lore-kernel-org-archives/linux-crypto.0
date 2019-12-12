Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 159D8C43603
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 15:30:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E778A206A5
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 15:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729097AbfLLPan (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 10:30:43 -0500
Received: from sitav-80046.hsr.ch ([152.96.80.46]:54238 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728939AbfLLPan (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 10:30:43 -0500
Received: from obook (unknown [IPv6:2a01:2a8:8500:5c01:6946:d015:47d4:9c3d])
        by mail.strongswan.org (Postfix) with ESMTPSA id 9E66A401A2;
        Thu, 12 Dec 2019 16:30:41 +0100 (CET)
Message-ID: <7d30f7c912a5565b1c26729b438c1a95286fcf56.camel@strongswan.org>
Subject: Re: [PATCH crypto-next v2 1/3] crypto: poly1305 - add new 32 and
 64-bit generic versions
From:   Martin Willi <martin@strongswan.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Date:   Thu, 12 Dec 2019 16:30:41 +0100
In-Reply-To: <CAHmME9oQ-Yj2WWuvNj1KNm=d4+PgnVFOusnh8HG0=yYWdi2UXQ@mail.gmail.com>
References: <20191211170936.385572-1-Jason@zx2c4.com>
         <20191212093008.217086-1-Jason@zx2c4.com>
         <d55e0390c7187b09f820e123b05df1e5e680df0b.camel@strongswan.org>
         <CAHmME9ovvwX3Or1ctRH8U5PjpNNMe9ixOZLi3F0vbO9SqA04Ow@mail.gmail.com>
         <CAHmME9reEXXSmQr+6vPM1cwr+pjvwPwJ5n3UZ0BUSjO2kQQcNg@mail.gmail.com>
         <CAKv+Gu80EVN-_aHPSYUu=0TvFJERBMKFvQS-gce3z_jx=X7www@mail.gmail.com>
         <CAHmME9oQ-Yj2WWuvNj1KNm=d4+PgnVFOusnh8HG0=yYWdi2UXQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> The principle advantage of this patchset is the 64x64 code

If there are platforms / code paths where this code matters, all fine.

But the 64-bit version adds a lot of complexity because of the
different state representation and the conversion between these states.
I just don't think the gain (?) justifies that added complexity.

Martin

