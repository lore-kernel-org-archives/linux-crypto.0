From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: XTS - remove test that will fail in FIPS mode
Date: Wed, 17 Aug 2016 16:57:53 +0200
Message-ID: <1521535.SOsKusk3RD@tauon.atsec.com>
References: <D3CF7065.28F3%tsarangi@trustwave.com> <16370043.OYgDIDmMpM@tauon.atsec.com> <D3D9E3A3.30E6%tsarangi@trustwave.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Tapas Sarangi <TSarangi@trustwave.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36716 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbcHQO56 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Aug 2016 10:57:58 -0400
In-Reply-To: <D3D9E3A3.30E6%tsarangi@trustwave.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 17. August 2016, 14:52:32 CEST schrieb Tapas Sarangi:

Hi Tapas,

(please, do not top-post)

> Hi Stephan,
> 
> Yes, can you give me some more detail about your findings on dracut-fips
> !? This seems to be the major difference between our test environments
> where a bunch of algorithms are failing self-test during boot with fips=1.

cmac must be statically compiled as otherwise dracut-fips does not find it (it 
misses it in the module list).

The authenc() cipher must not be compiled as somehow the modprobe in dracut-
fips does not find some components -- I am not sure what the issue is yet. I 
even have compiled all parts forming an authenc cipher (authenc, hmac, the 
hashes, the block chaining modes, the symmetric ciphers) to be bound into the 
kernel statically. But still, something is not found by the tcrypt module in 
dracut-fips.



Ciao
Stephan
