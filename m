From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Initcall ordering problem (TTY vs modprobe vs MD5) and cryptomgr
	problem
Date: Thu, 5 Aug 2010 19:01:21 -0700
Message-ID: <AANLkTi=+-Y2GOZYAZHeaX+op3XB9AY5S85rfJD3jSDvz@mail.gmail.com>
References: <23662.1281056463@redhat.com> <20100806011706.GA21657@gondor.apana.org.au>
	<20100806014057.GA22395@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Howells <dhowells@redhat.com>, gregkh@suse.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759160Ab0HFCBu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Aug 2010 22:01:50 -0400
In-Reply-To: <20100806014057.GA22395@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 5, 2010 at 6:40 PM, Herbert Xu <herbert@gondor.hengli.com.a=
u> wrote:
>
> -config CRYPTO_MANAGER_TESTS
> - =A0 =A0 =A0 bool "Run algolithms' self-tests"
> - =A0 =A0 =A0 default y
> - =A0 =A0 =A0 depends on CRYPTO_MANAGER2
> +config CRYPTO_MANAGER_DISABLE_TESTS
> + =A0 =A0 =A0 bool "Disable run-time self tests"
> + =A0 =A0 =A0 depends on CRYPTO_MANAGER2 && EMBEDDED

Why do you still want to force-enable those tests? I was going to
complain about the "default y" anyway, now I'm _really_ complaining,
because you've now made it impossible to disable those tests. Why?

People always think that their magical code is so important. I tell
you up-front that is absolutely is not. Just remove the crap entirely,
please.

            Linus
