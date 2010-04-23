From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: Long pause when using pcrypt
Date: Fri, 23 Apr 2010 11:49:38 +0200
Message-ID: <20100423094938.GB2347@secunet.com>
References: <4BD00F74.9030102@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Nils Rennebarth <Nils.Rennebarth@web.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:56626 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab0DWKPi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Apr 2010 06:15:38 -0400
Content-Disposition: inline
In-Reply-To: <4BD00F74.9030102@web.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 22, 2010 at 10:57:24AM +0200, Nils Rennebarth wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hi,
> 
> As parallel encryption of ipsec is now in the official kernel, I tried to use
> it, and to actually make ipsec connections use it, I did
> 
>   $ modprobe tcrypt alg='pcrypt(authenc(hmac(sha1),cbc(aes)))' type=3
> 
> This works, but the computer pauses for about 60s when running the modprobe,
> and appears to be completely idle in the meantime. Why is that necessary?

You can try to specify the drivers e.g.

modprobe tcrypt alg="pcrypt(authenc(hmac(sha1-generic),cbc(aes-asm)))" type=3

this should be faster.

> 
> Is there another recommended way to instantiate pcrypt, e.g. via netlink?
> I searched for a while, by browsing the sources, but found nothing appropriate.
> 

Unfortunately not yet, this should change as soon as we have a generic crypto user
configuration interface.

Steffen
