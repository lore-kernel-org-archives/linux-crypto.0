From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: AES-NI for x86?
Date: Mon, 25 Oct 2010 19:50:03 -0400
Message-ID: <20101025235003.GA6076@gondor.apana.org.au>
References: <28ED7E64-4E61-4868-B0CD-89FD18B08BBE@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Huang Ying <ying.huang@intel.com>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:41377 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0JYXuG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Oct 2010 19:50:06 -0400
Content-Disposition: inline
In-Reply-To: <28ED7E64-4E61-4868-B0CD-89FD18B08BBE@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mathias Krause <minipli@googlemail.com> wrote:
> Hello list,
> 
> will there be a 32-bit version of the Intel AES-NI code? I've seen a 32-bit
> version in openssl so it should be possible. Not?

It won't exist unless someone writes one.  Are you volunteering? :)

Ccing the author in case there is some reason why it won't work in
32-bit mode.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
