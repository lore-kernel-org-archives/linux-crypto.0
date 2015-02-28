From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCHv2 0/7] Add VMX module for PPC64
Date: Sat, 28 Feb 2015 23:14:12 +1300
Message-ID: <20150228101412.GA7073@gondor.apana.org.au>
References: <20150206165452.GA21740@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:47754 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbbB1KOS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 28 Feb 2015 05:14:18 -0500
Content-Disposition: inline
In-Reply-To: <20150206165452.GA21740@bluepex.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 06, 2015 at 02:54:55PM -0200, Leonidas S. Barbosa wrote:
> VMX cryptographic acceleration instructions were added to the POWER8
> CPU. These instructions implement portions of AES and GHASH in hardware.
> 
> This patch set adds a new module for PPC64, vmx, that support
> cryptographic routines such as AES and GHASH on hardware. In order to
> access VMX instructions on Power 8 CPU this module uses scripts
> implemented in colaboration with OpenSSL.
> 
> Changelog[v2]
> 1. Patch style fixes 
> 2. Redo unecessary conditions on drivers/crypto/Kconfig
> and vmx/Makefile in previous [Patch 7/7]

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
