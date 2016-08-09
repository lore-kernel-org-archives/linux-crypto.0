From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/10] Enablement of a v5 CCP
Date: Tue, 9 Aug 2016 19:01:05 +0800
Message-ID: <20160809110105.GC7099@gondor.apana.org.au>
References: <20160727000652.24944.44919.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
	davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56136 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbcHILBK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 07:01:10 -0400
Content-Disposition: inline
In-Reply-To: <20160727000652.24944.44919.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 26, 2016 at 07:09:11PM -0500, Gary R Hook wrote:
> The following series updates the CCP driver to support
> both current and new cryptographic coprocessor models.
> Refactor code to further separate device-specific code
> from driver logic, then add equivalent support for the
> new device version.
> 
> ---
> 
> Gary R Hook (10):
>       crypto: ccp - Abstract PCI info for the CCP
>       crypto: ccp - Shorten the fields of the action structure
>       crypto: ccp - Refactoring: symbol cleanup
>       crypto: ccp - Refactor the storage block allocation code
>       crypto: ccp - Refactor code supporting the CCP's RNG
>       crypto: ccp - Refactor code to enable checks for queue space.
>       crypto: ccp - Let a v5 CCP provide the same function as v3
>       crypto: ccp - Add support for the RNG in a version 5 CCP
>       crypto: ccp - Enable DMA service on a v5 CCP
>       crypto: ccp - Enable use of the additional CCP

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
