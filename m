From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: crypto: zeroization of sensitive data in af_alg
Date: Mon, 10 Nov 2014 21:55:43 -0500
Message-ID: <CACXcFmmp=SMisc0p-Fx=M3myXE0E-kH3zN6NGrODeVzQrXUdFA@mail.gmail.com>
References: <1979092.odOtqL46qU@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:33474 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaKKCzo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Nov 2014 21:55:44 -0500
In-Reply-To: <1979092.odOtqL46qU@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 9, 2014 at 5:33 PM, Stephan Mueller <smueller@chronox.de> wrote:

> while working on the AF_ALG interface, I saw no active zeroizations of memory
> that may hold sensitive data that is maintained outside the kernel crypto API
> cipher handles. ...

> I think I found the location for the first one: hash_sock_destruct that should
> be enhanced with a memset(0) of ctx->result.

See also a thread titled "memset() in crypto code?" on the linux
crypto list. The claim is that gcc can optimise memset() away so you
need a different function to guarantee the intended results. There's a
patch to the random driver that uses a new function
memzero_explicit(), and one of the newer C standards has a different
function name for the purpose.
