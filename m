From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: arm: workaround for building with old binutils
Date: Sat, 11 Apr 2015 10:55:35 +0200
Message-ID: <2148670.W34n3asXfA@wuerfel>
References: <3461827.FYLMCAIQyv@wuerfel> <CAKv+Gu_n0-sMZZjWOmQ5koEfJRX6jqme5WOOP1zrF_zMnB7=nA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"David S. Miller" <davem@davemloft.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:56595 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425AbbDKI4C (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 11 Apr 2015 04:56:02 -0400
In-Reply-To: <CAKv+Gu_n0-sMZZjWOmQ5koEfJRX6jqme5WOOP1zrF_zMnB7=nA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Saturday 11 April 2015 09:41:08 Ard Biesheuvel wrote:
> Could you perhaps put the rules that build these modules inside a
> 
> ifneq ($(armv8-ce-flags),-DARMV8_CE_DISABLED)
> ...
> endif
> 

How about something like this:

ifeq ($(call as-option,-Wa$(comma)-mfpu=crypto-neon-fp-armv8),)
$(warning ARMv8 Crypto Extensions need binutils 2.23 or higher)
else
...
endif

That would basically be a reimplementation of the missing "as-option-yn"
macro though, so we could also add that instead and do

ifeq ($(call as-option-yn,-Wa$(comma)-mfpu=crypto-neon-fp-armv8),y)
$(warning ARMv8 Crypto Extensions need binutils 2.23 or higher)
else
...
endif

	Arnd
