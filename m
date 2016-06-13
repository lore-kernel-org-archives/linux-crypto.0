From: Kevin Hilman <khilman@baylibre.com>
Subject: Re: [PATCH v2 0/3] hw_random: Add Amlogic Meson SoCs Random Generator driver
Date: Mon, 13 Jun 2016 15:10:28 -0700
Message-ID: <m2wplsviy3.fsf@baylibre.com>
References: <1465546915-24229-1-git-send-email-narmstrong@baylibre.com>
	<20160613123109.GA8674@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Neil Armstrong <narmstrong@baylibre.com>,
	linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Matt Mackall <mpm@selenic.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:32897 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423768AbcFMWKb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2016 18:10:31 -0400
Received: by mail-pa0-f43.google.com with SMTP id b13so27161194pat.0
        for <linux-crypto@vger.kernel.org>; Mon, 13 Jun 2016 15:10:30 -0700 (PDT)
In-Reply-To: <20160613123109.GA8674@gondor.apana.org.au> (Herbert Xu's message
	of "Mon, 13 Jun 2016 20:31:09 +0800")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Fri, Jun 10, 2016 at 10:21:52AM +0200, Neil Armstrong wrote:
>> Add support for the Amlogic Meson SoCs Hardware Random generator as a hw_random char driver.
>> The generator is a single 32bit wide register.
>> Also adds the Meson GXBB SoC DTSI node and corresponding DT bindings.
>> 
>> Changes since v1 at http://lkml.kernel.org/r/1464943621-18278-1-git-send-email-narmstrong@baylibre.com :
>> - change to depend on ARCH_MESON || COMPILE_TEST
>> - check buffer max size in read
>> 
>> Neil Armstrong (3):
>>   char: hw_random: Add Amlogic Meson Hardware Random Generator
>>   dt-bindings: hwrng: Add Amlogic Meson Hardware Random Generator
>>     bindings
>>   ARM64: dts: meson-gxbb: Add Hardware Random Generator node
>
> All applied.  Thanks.

Could you take just the driver please?

Due to lots of other activity in the DT, I'd prefer to send the DT &
bindings though the arm-soc (via the amlogic tree.)

Thanks,

Kevin
