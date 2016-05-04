From: David Howells <dhowells@redhat.com>
Subject: Re: v4.6-rc1 regression bisected, Problem loading in-kernel X.509 certificate (-2)
Date: Wed, 04 May 2016 10:01:49 +0100
Message-ID: <21436.1462352509@warthog.procyon.org.uk>
References: <45d1a06b-4ec4-17f5-2888-3068558da0bb@gmail.com> <20160503172536.GC20775@cucamonga.audible.transient.net> <20160430083248.GA20775@cucamonga.audible.transient.net> <26795.1462266613@warthog.procyon.org.uk> <11323.1462307740@warthog.procyon.org.uk> <20160504022608.GF20775@cucamonga.audible.transient.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, Jamie Heilman <jamie@audible.transient.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	tadeusz.struk@intel.com
To: Tadeusz Struk <tstruk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757678AbcEDJBw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 05:01:52 -0400
In-Reply-To: <45d1a06b-4ec4-17f5-2888-3068558da0bb@gmail.com>
Content-ID: <21435.1462352509.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tadeusz Struk <tstruk@gmail.com> wrote:

> I think the problem is that pkcs1pad template needs CRYPTO_MANAGER, but
> your configuration doesn't enable CRYPTO_MANAGER. Could you try this
> please:
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 93a1fdc..1d33beb 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -96,6 +96,7 @@ config CRYPTO_AKCIPHER
>  config CRYPTO_RSA
>  	tristate "RSA algorithm"
>  	select CRYPTO_AKCIPHER
> +	select CRYPTO_MANAGER
>  	select MPILIB
>  	select ASN1
>  	help

Do you want to push this via Herbert's tree?

David
