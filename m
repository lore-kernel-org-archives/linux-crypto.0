From: James Hsiao <jhsiao@amcc.com>
Subject: Re: [PATCH] AMCC Crypto4xx Device Driver v6
Date: Thu, 05 Feb 2009 11:47:48 -0800
Message-ID: <1233863268.4815.9.camel@jhsiao-usb>
References: <1233183185.4809.52.camel@jhsiao-usb>
	 <20090205051839.GC22749@gondor.apana.org.au>
Reply-To: jhsiao@amcc.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: kim.phillips@freescale.com, jwboyer@linux.vnet.ibm.com,
	linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02.amcc.com ([198.137.200.73]:54530 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763276AbZBETnf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Feb 2009 14:43:35 -0500
In-Reply-To: <20090205051839.GC22749@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Thanks for apply the patch.
Somehow the new directory driver/crypto/amcc is missing from the tree.
I can see everything else in the tree except the driver source code.
Do you want me to submit a new patch, or you can fix it with the V6
patch.

Thanks
James
On Thu, 2009-02-05 at 16:18 +1100, Herbert Xu wrote:
> On Wed, Jan 28, 2009 at 02:53:05PM -0800, James Hsiao wrote:
> > This patch adds support for AMCC ppc4xx security device driver. This is the
> > initial release that includes the driver framework with AES and SHA1 algorithms
> > support.
> > The remaining algorithms will be released in the near future.
> > 
> > Signed-off-by: James Hsiao <jhsiao@amcc.com>
> 
> Patch applied.  Thanks James!

