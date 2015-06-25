From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] crypto: aesni - fix failing setkey for rfc4106-gcm-aesni
Date: Thu, 25 Jun 2015 16:37:48 -0700
Message-ID: <CA+55aFwZBfRGJY3NQtEWyWFBA+Vkh0QDtyYj-Cf4-vt4Wt_eXg@mail.gmail.com>
References: <20150624141421.30466.28034.stgit@tstruk-mobl1>
	<20150625142525.GA10550@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38714 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbbFYXht (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Jun 2015 19:37:49 -0400
Received: by igin14 with SMTP id n14so2911634igi.1
        for <linux-crypto@vger.kernel.org>; Thu, 25 Jun 2015 16:37:48 -0700 (PDT)
In-Reply-To: <20150625142525.GA10550@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 25, 2015 at 7:25 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Linus, could you confirm that you have AESNI built into the kernel
> and not as a module?

Yes, confirmed.

                 Linus
