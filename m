From: Kevin Hilman <khilman@baylibre.com>
Subject: Re: [PATCH v3 1/3] clk: meson-gxbb: expose clock CLKID_RNG0
Date: Thu, 16 Mar 2017 11:24:31 -0700
Message-ID: <m2mvcl6pwg.fsf@baylibre.com>
References: <4e2d12e5-f75b-3ac6-a3f7-18e8a8b7283b@gmail.com>
        <20170316100743.GA12137@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, linux-crypto@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Michael Turquette <mturquette@baylibre.com>,
        linux-clk@vger.kernel.org, devicetree@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:35735 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753801AbdCPSYe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 14:24:34 -0400
Received: by mail-pg0-f53.google.com with SMTP id b129so28966895pgc.2
        for <linux-crypto@vger.kernel.org>; Thu, 16 Mar 2017 11:24:33 -0700 (PDT)
In-Reply-To: <20170316100743.GA12137@gondor.apana.org.au> (Herbert Xu's
        message of "Thu, 16 Mar 2017 18:07:43 +0800")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Wed, Feb 22, 2017 at 07:55:24AM +0100, Heiner Kallweit wrote:
>> Expose clock CLKID_RNG0 which is needed for the HW random number generator.
>> 
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>
> All patches applied.  Thanks.

Actually, can you just apply [PATCH 4/4] to your tree?

The clock and DT patches need to go through their respective trees or
will otherwise have conflicts with other things going in via those
trees.

Thanks,

Kevin
