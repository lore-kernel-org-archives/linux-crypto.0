From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] crypto/arm: accelerated SHA-512 using ARM generic ASM and NEON
Date: Sat, 11 Apr 2015 22:43:49 +0200
Message-ID: <12435253.sNXyjYQRd4@wuerfel>
References: <1428676148-28210-1-git-send-email-ard.biesheuvel@linaro.org> <2845656.4sNJ3XBxnz@wuerfel> <F30C78C6-9DED-47DE-BB9F-D88F1716B4D1@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"samitolvanen@google.com" <samitolvanen@google.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:63590 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbbDKUob (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 11 Apr 2015 16:44:31 -0400
In-Reply-To: <F30C78C6-9DED-47DE-BB9F-D88F1716B4D1@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Saturday 11 April 2015 12:27:18 Ard Biesheuvel wrote:
> 
> Ah i see it now. The new Sha256 module as well as the Sha512 i am proposing here both use a single .o containing the !neon and neon implementations, and only expose the latter if KERNEL_MODE_NEON. This way, we can use the exact same .S file ad OpenSSL, which should mean less maintenance burden.
> 
> So your fix seems the most appropriate, even if it means v7m won't be able to use the !neon part either.
> 
> 

Ok, sounds good. If someone wants to change that code to work on ARMv7-M,
they probably want that fix in the openssl version as well, and then we
can update both.

	Arnd
