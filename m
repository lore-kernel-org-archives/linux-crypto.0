From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH] x86, crypto: ported aes-ni implementation to x86
Date: Wed, 3 Nov 2010 13:47:28 +0100
Message-ID: <AANLkTimh_2xUJQNCv-68cKMcyBeiDFTzaOU24hg6W0AJ@mail.gmail.com>
References: <1288386624-5649-1-git-send-email-minipli@googlemail.com>
	<20101029221541.GA12822@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54950 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab0KCMr3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Nov 2010 08:47:29 -0400
Received: by gxk23 with SMTP id 23so433053gxk.19
        for <linux-crypto@vger.kernel.org>; Wed, 03 Nov 2010 05:47:29 -0700 (PDT)
In-Reply-To: <20101029221541.GA12822@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I modified the patch so it doesn't introduce a copy of the existing
assembler implementation but modifies the existing one to be usable for
64 and 32 bit. Additionally I added some alignment constraints for
internal functions which resulted in a noticeable speed-up.

I rerun the tests on another machine, an Core i7 M620, 2.67GHz. I also
took the "low-end" numbers for the AES-NI variants because I didn't
want to wait for the big numbers to come every now and then any more ;)
So here is the comparison of 5 consecutive tcrypt test runs for some
selected algorithms in MiB/s:

x86-64 (old):       1. run  2. run  3. run  4. run  5. run    mean
ECB, 256 bit, 8kB:  152.49  152.58  152.51  151.80  151.87  152.25
CBC. 256 bit, 8kB:  144.32  144.44  144.35  143.75  143.75  144.12
LRW, 320 bit, 8kB:  159.41  159.21  159.21  158.55  159.28  159.13
XTS, 512 bit, 8kB:  144.87  142.88  144.75  144.11  144.75  144.27

x86-64 (new):       1. run  2. run  3. run  4. run  5. run    mean
ECB, 256 bit, 8kB:  184.07  184.07  183.50  183.50  184.07  183.84
CBC. 256 bit, 8kB:  170.25  170.24  169.71  169.71  170.25  170.03
LRW, 320 bit, 8kB:  169.91  169.91  169.39  169.37  169.91  169.69
XTS, 512 bit, 8kB:  172.39  172.35  171.82  171.82  172.35  172.14

i586:               1. run  2. run  3. run  4. run  5. run    mean
ECB, 256 bit, 8kB:  125.98  126.03  126.03  125.64  126.03  125.94
CBC. 256 bit, 8kB:  118.18  118.19  117.84  117.84  118.19  118.04
LRW, 320 bit, 8kB:  128.37  128.35  127.97  127.98  128.35  128.20
XTS, 512 bit, 8kB:  118.52  118.50  118.14  118.14  118.49  118.35

x86 (AES-NI):       1. run  2. run  3. run  4. run  5. run    mean
ECB, 256 bit, 8kB:  187.33  187.34  187.33  186.75  186.74  187.09
CBC. 256 bit, 8kB:  171.84  171.84  171.84  171.28  171.28  171.61
LRW, 320 bit, 8kB:  168.54  168.54  168.53  168.00  168.02  168.32
XTS, 512 bit, 8kB:  166.61  166.60  166.60  166.08  166.60  166.49

Comparing the mean values gives us:

x86-64:                old     new   delta
ECB, 256 bit, 8kB:  152.25  183.84  +20.7%
CBC. 256 bit, 8kB:  144.12  170.03  +18.0%
LRW, 320 bit, 8kB:  159.13  169.69   +6.6%
XTS, 512 bit, 8kB:  144.27  172.14  +19.3%

x86:                  i586  aes-ni   delta
ECB, 256 bit, 8kB:  125.94  187.09  +48.6%
CBC. 256 bit, 8kB:  118.04  171.61  +45.4%
LRW, 320 bit, 8kB:  128.20  168.32  +31.3%
XTS, 512 bit, 8kB:  118.35  166.49  +40.7%

The funny thing is that the 32 bit implementation is sometimes even
faster then the 64 bit one. Nevertheless the minor optimization of
aligning function entries gave the 64 bit version quite a big
performance gain (up to 20%).

I'll post the new version of the patch in a follow-up email.

Regards,
Mathias
