From: Zain <zain.wang@rock-chips.com>
Subject: Re: [PATCH v2 1/4] Crypto: Crypto driver support aes/des/des3 for
 rk3288
Date: Mon, 9 Nov 2015 08:53:46 +0800
Message-ID: <563FEE9A.2020505@rock-chips.com>
References: <1446772644-2352-1-git-send-email-zain.wang@rock-chips.com>
 <1446772644-2352-2-git-send-email-zain.wang@rock-chips.com>
 <CACXcFmmFeK6kO7Q9sWf0SE5gmw0ZzX126=TUaA6YPGApVsopCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Sandy Harris <sandyinchina@gmail.com>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.135]:54032 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbbKIAxz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Nov 2015 19:53:55 -0500
In-Reply-To: <CACXcFmmFeK6kO7Q9sWf0SE5gmw0ZzX126=TUaA6YPGApVsopCg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 2015=E5=B9=B411=E6=9C=8807=E6=97=A5 12:40, Sandy Harris wrote:
> On Thu, Nov 5, 2015 at 8:17 PM, Zain Wang <zain.wang@rock-chips.com> =
wrote:
>> The names registered are:
>>     ecb(aes) cbc(aes) ecb(des) cbc(des) ecb(des3_ede) cbc(des3_ede)
>> You can alloc tags above in your case.
> Why on Earth are you allowing DES? Here's a reference from around the
> turn of the century on why the FreeS/WAN project refused to implement
> it then:
> http://www.freeswan.org/freeswan_trees/freeswan-1.97/doc/politics.htm=
l#desnotsecure
>
> In 1998 a $200,000-odd purpose-built machine using FPGAs could break
> DES in a few days. Morre's Law applies; my guess would be that today
> you could break it in hours for well under $10,000 using either GPUs
> or Intel's Xeon Phi.
>
> Even if you have to implement DES because you need it as a component
> for 3DES and some standards still require 3DES, single DES should not
> be exposed in the user interface.
>
>
>
Thanks for your comment.
I built it because DES has been built in many other patch about crypto
like atmel, marvell, samsung... though I don't known how it can be used=
=2E
Do I remove DES?
