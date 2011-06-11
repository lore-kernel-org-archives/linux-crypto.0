From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: HW Accelerated IPSEC?
Date: Sat, 11 Jun 2011 09:18:42 +0800
Message-ID: <20110611011842.GA5222@gondor.apana.org.au>
References: <4DF22C5A.2000907@borg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Kent Borg <kentborg@borg.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:57154 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758379Ab1FKBSp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Jun 2011 21:18:45 -0400
Content-Disposition: inline
In-Reply-To: <4DF22C5A.2000907@borg.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kent Borg <kentborg@borg.org> wrote:
>
> Maybe both modules are processing the data-in/data-out aspect correctly, 
> but are misbehaving in some other way; a missing lock on a critical 
> section, for example. For some reason IPSec gets unhappy where self-test 
> and loopback are quite content. Or, maybe IPSec has a bug that is 
> somehow exposed when a different HW unit gets into the act. (Which is 
> why I was looking for any confirmed case of IPSec going through the 
> kernel's crypto infrastructure for HW acceleration.)

That is entirely possible.

One way to test whether this is a bug in IPsec or crypto is to
instantiate a cryptd instance on sha by using cryptd(sha1-generic).

If that works then it's probably a bug in your driver, otherwise
we may have an issue in IPsec itself.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
