From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v4.7-6816-g797cee982eef] Call-trace: modprobe | asymmetric-keys?
Date: Sat, 30 Jul 2016 22:25:47 +0800
Message-ID: <20160730142547.GA22578@gondor.apana.org.au>
References: <CA+icZUVTG9hjrHarFts_SV1oAX1-fH7YMeHkC8oXcAd=1AKKvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	David Howells <dhowells@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Sedat Dilek <sedat.dilek@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53851 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbcG3OZ4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 30 Jul 2016 10:25:56 -0400
Content-Disposition: inline
In-Reply-To: <CA+icZUVTG9hjrHarFts_SV1oAX1-fH7YMeHkC8oXcAd=1AKKvw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jul 30, 2016 at 02:55:12PM +0200, Sedat Dilek wrote:
> [ CC "MODULE SUPPORT" | "ASYMMETRIC KEYS" | "CRYPTO API" maintainers ]
> 
> Hi,
> 
> with latest Linus Git (v4.7-6816-g797cee982eef) I see the following
> call-trace in my Ubuntu/precise AMD64 system...

This should be fixed by

https://patchwork.kernel.org/patch/9250679/

which I will push to Linus soon.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
