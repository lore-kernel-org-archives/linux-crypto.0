From: Dwi Sasongko Supriyadi <ruckuus@gmail.com>
Subject: Re: Crypto API from user space
Date: Fri, 18 Jun 2010 12:01:57 +0700
Message-ID: <AANLkTinsnTCMubAlGlwR9adUI_iKY3C3h-AzhE-TeE_V@mail.gmail.com>
References: <4C178BF8.8020604@nokia.com>
	<4C17A94B.7060906@gnutls.org>
	<4C188EAF.2020004@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: ext Herbert Xu <herbert@gondor.hengli.com.au>,
	ext Nikos Mavrogiannopoulos <nmav@gnutls.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34951 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab0FRFB6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Jun 2010 01:01:58 -0400
Received: by mail-gy0-f174.google.com with SMTP id 5so524527gye.19
        for <linux-crypto@vger.kernel.org>; Thu, 17 Jun 2010 22:01:57 -0700 (PDT)
In-Reply-To: <4C188EAF.2020004@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 16, 2010 at 3:43 PM, Dmitry Kasatkin
<dmitry.kasatkin@nokia.com> wrote:
> Hi,
>
> BTW.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
>
> Has this kernel anything about cryptodev as well?
>
> Thanks,
> - Dmitry
>
> On 15/06/10 19:24, ext Nikos Mavrogiannopoulos wrote:
>> Dmitry Kasatkin wrote:
>>
>>> Hi,
>>>
>>> Can I use kernel Crypto API from user space?
>>> I remember 2 or 3 projects about it.
>>>
>>> But what is the one and only one I need? :)
>>>
>> I don't know which is the one you need, but I know the one I use. Check
>> http://home.gna.org/cryptodev-linux/
>>

Thanks for this link, I never know about it.

So far, I wrote my own driver to access kernel crypto API with certain
fops (read/write/ioctls).

Regards,
DWI
