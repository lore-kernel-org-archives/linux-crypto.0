From: michael-dev@fami-braun.de
Subject: Re: [BUG] SLOB breaks Crypto
Date: Thu, 18 Mar 2010 22:24:41 +0100
Message-ID: <4BA29A19.2050307@fami-braun.de>
References: <4B9E38AF.70309@fami-braun.de> <84144f021003180930s44e239dfmb38183096f07c8a8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:53504 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0CRVY4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Mar 2010 17:24:56 -0400
In-Reply-To: <84144f021003180930s44e239dfmb38183096f07c8a8@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Pekka Enberg schrieb:
> Even with CONFIG_DEBUG_SLAB enabled or with CONFIG_SLUB and
> CONFIG_SLUB_DEBUG_ON?

no, these options have not been / are not enabled.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkuimhkACgkQ+6sI4XSM4u1jtACfS9YfQfKZ/Pu/n62lT50xSise
RdAAmgMfVmKXPFRT2hz7bSWAMIor9zTo
=gMEL
-----END PGP SIGNATURE-----
