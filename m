From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto/arm: accelerated SHA-512 using ARM generic ASM
 and NEON
Date: Mon, 13 Apr 2015 12:13:43 +0800
Message-ID: <20150413041343.GB11091@gondor.apana.org.au>
References: <1428676148-28210-1-git-send-email-ard.biesheuvel@linaro.org>
 <F695F357-2A5C-4DFC-9F0E-188CDBBE7C01@linaro.org>
 <CAKv+Gu-6mZwrVSCvS+ZWWwwM-294nWAqX4_J3r5Z8NM7KKC0=Q@mail.gmail.com>
 <2845656.4sNJ3XBxnz@wuerfel>
 <CAKv+Gu9TU6ETRQDvp7M7Q43xAR5A25scgP3tsvZMmzBQNOK7Cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arnd Bergmann <arnd@arndb.de>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"samitolvanen@google.com" <samitolvanen@google.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54121 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbbDMEOA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Apr 2015 00:14:00 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9TU6ETRQDvp7M7Q43xAR5A25scgP3tsvZMmzBQNOK7Cg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Apr 11, 2015 at 09:15:10PM +0200, Ard Biesheuvel wrote:
>
> @Herbert: could you please apply this onto cryptodev before sending
> out your pull request for v4.1?

Done.

> And please disregard $subject, I will post a v3 with a similar
> 'depends on' added (unless you're ok to add it yourself)

Please resend the patch.  But I'll process it after the merge
window closes so no hurry.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
