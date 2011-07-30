From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: cryptsetup: "FATAL" padlock_{aes,sha} error during boot
Date: Sat, 30 Jul 2011 14:13:07 +0800
Message-ID: <20110730061307.GA24394@gondor.apana.org.au>
References: <201107281403.27224.ralfjung-e@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, 485070@bugs.debian.org,
	katzj@redhat.com
To: Ralf Jung <ralfjung-e@gmx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:58191 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab1G3GNM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 30 Jul 2011 02:13:12 -0400
Content-Disposition: inline
In-Reply-To: <201107281403.27224.ralfjung-e@gmx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ralf Jung <ralfjung-e@gmx.de> wrote:
> Hi,
> 
> as per request of Jonathan at http://bugs.debian.org/cgi-
> bin/bugreport.cgi?bug=485070, I am reporting the mentioned bug to this list as 
> well:
> 
> With current Debian testing (Kernel 2.6.39), I am getting this error on each 
> boot:
> FATAL: Error inserting padlock_sha (/lib/modules/2.6.39-2-
> amd64/kernel/drivers/crypto/padlock-sha.ko): No such device
> I understand it is harmless, but it should still be fixed since it irritates 
> users suggesting something is seriously going wrong.

That message comes from user-space and needs to be fixed there.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
