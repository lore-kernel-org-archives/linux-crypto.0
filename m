From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH v2 1/4] Crypto: Crypto driver support aes/des/des3 for rk3288
Date: Fri, 6 Nov 2015 23:40:33 -0500
Message-ID: <CACXcFmmFeK6kO7Q9sWf0SE5gmw0ZzX126=TUaA6YPGApVsopCg@mail.gmail.com>
References: <1446772644-2352-1-git-send-email-zain.wang@rock-chips.com>
	<1446772644-2352-2-git-send-email-zain.wang@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Zain Wang <zain.wang@rock-chips.com>, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34280 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbbKGEke (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Nov 2015 23:40:34 -0500
Received: by iody8 with SMTP id y8so141550310iod.1
        for <linux-crypto@vger.kernel.org>; Fri, 06 Nov 2015 20:40:34 -0800 (PST)
In-Reply-To: <1446772644-2352-2-git-send-email-zain.wang@rock-chips.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 5, 2015 at 8:17 PM, Zain Wang <zain.wang@rock-chips.com> wrote:
> The names registered are:
>     ecb(aes) cbc(aes) ecb(des) cbc(des) ecb(des3_ede) cbc(des3_ede)
> You can alloc tags above in your case.

Why on Earth are you allowing DES? Here's a reference from around the
turn of the century on why the FreeS/WAN project refused to implement
it then:
http://www.freeswan.org/freeswan_trees/freeswan-1.97/doc/politics.html#desnotsecure

In 1998 a $200,000-odd purpose-built machine using FPGAs could break
DES in a few days. Morre's Law applies; my guess would be that today
you could break it in hours for well under $10,000 using either GPUs
or Intel's Xeon Phi.

Even if you have to implement DES because you need it as a component
for 3DES and some standards still require 3DES, single DES should not
be exposed in the user interface.
