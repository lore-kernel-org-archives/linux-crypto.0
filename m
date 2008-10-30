From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: Enabling Talitos kills all IPsec traffic
Date: Wed, 29 Oct 2008 19:40:01 -0500
Message-ID: <20081029194001.1264cf20.kim.phillips@freescale.com>
References: <61362e760810231612s6fe4dfbfk1c63986881d7152e@mail.gmail.com>
	<20081028190257.a0d5a6d8.kim.phillips@freescale.com>
	<61362e760810291033i565bb105pe0c8056b8c5538d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Barry G" <mr.scada@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:55666 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbYJ3A3u (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Oct 2008 20:29:50 -0400
In-Reply-To: <61362e760810291033i565bb105pe0c8056b8c5538d@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 29 Oct 2008 10:33:39 -0700
"Barry G" <mr.scada@gmail.com> wrote:

> >> Also, is it correct that Talitos only accelerates AEAD connections, not ESP/AH
> >> protocols so there will be no performance increase for me until Strongswan
> >> adds rfc5282 support?
> >
> > I'm not sure what you mean here; talitos supports aes-cbc but doesn't
> > support aes-ccm nor aes-gcm.
> The reason I ask is:
> # cat /proc/crypto | grep -i talitos
> driver       : authenc-hmac-md5-cbc-3des-talitos
> driver       : authenc-hmac-md5-cbc-aes-talitos
> driver       : authenc-hmac-sha256-cbc-3des-talitos
> driver       : authenc-hmac-sha256-cbc-aes-talitos
> driver       : authenc-hmac-sha1-cbc-3des-talitos
> driver       : authenc-hmac-sha1-cbc-aes-talitos
> 
> All talitos drivers have the authenc prefix.  The aes-cbc entry in my
> crypto is:
> name         : cbc(aes)
> driver       : cbc(aes-generic)
> module       : kernel
> priority     : 100
> refcnt       : 1
> type         : blkcipher
> blocksize    : 16
> min keysize  : 16
> max keysize  : 32
> ivsize       : 16
> geniv        : <default>
> 
> Since its priority isn't 3000 and its driver isn't a talitos driver, I figure
> it is software.   Disabling the software AES driver in the kernel
> results in an error
> from strongswan when it tries to add the SA to the kernel.

Selecting talitos also selects CRYPTO_AUTHENC.  Can you try sending
traffic with CRYPTO_DEV_TALITOS unset and CRYPTO_AUTHENC set if you
haven't already?

If Strongswan works with authenc and s/w crypto (talitos unset), and
the SEC is firing interrupts (grep talitos /proc/interrupts), can you
try with the latest cryptodev-2.6 git tree?  There's an error reporting
fix for talitos there that may manifest any h/w the error may be
reporting, depending on the level of traffic.

Otherwise, if you still want to use Strongswan, you can keep talitos
entropy support by commenting out the crypto algorithm registration
section of talitos_probe().

hth,

Kim
