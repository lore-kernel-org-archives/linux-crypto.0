From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: arm: workaround for building with old binutils
Date: Sat, 11 Apr 2015 22:44:59 +0200
Message-ID: <2057328.zEoCGSuP0u@wuerfel>
References: <3461827.FYLMCAIQyv@wuerfel> <2148670.W34n3asXfA@wuerfel> <51652361-AEE7-4C88-920A-5F0ED60EE275@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Russell King <linux@arm.linux.org.uk>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:64005 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482AbbDKUpL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 11 Apr 2015 16:45:11 -0400
In-Reply-To: <51652361-AEE7-4C88-920A-5F0ED60EE275@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Saturday 11 April 2015 12:35:19 Ard Biesheuvel wrote:
> 
> Yes, that should work. Could we also move the CE objs to ce-obj-$() and put
> 
> ifneq ($(ce-obj-y)$(ce-obj-m),)
> if <as check>
> obj-y += $(ce-obj-y)
> obj-m += $(ce-obj-m)
> else
> $(warning ...)
> endif
> endif
> 
> around it so you only get the warning if you have selected any of these modules?

Sounds good, I had not thought of that.

> In any case, I strongly prefer to leave the .S files themselves alone if at all possible

Yes, makes sense.

	Arnd
