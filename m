From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Using alloc_coherent for caam job rings
Date: Wed, 11 Jul 2012 11:24:04 +0800
Message-ID: <20120711032403.GA5263@gondor.apana.org.au>
References: <1340774912-19042-1-git-send-email-bharat.bhushan@freescale.com>
 <20120627143411.b33d3ddab40e67b511297dcd@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bharat Bhushan <r65777@freescale.com>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	Bharat Bhushan <Bharat.Bhushan@freescale.com>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:55067 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753431Ab2GKDYI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Jul 2012 23:24:08 -0400
Content-Disposition: inline
In-Reply-To: <20120627143411.b33d3ddab40e67b511297dcd@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 27, 2012 at 07:34:11PM +0000, Kim Phillips wrote:
> On Wed, 27 Jun 2012 10:58:32 +0530
> Bharat Bhushan <r65777@freescale.com> wrote:
> 
> > This resolves the Linux boot crash issue when "swiotlb=force" is set
> > in bootargs on systems which have memory more than 4G.
> 
> Acked-by: Kim Phillips <kim.phillips@freescale.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
