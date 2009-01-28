From: James Hsiao <jhsiao@amcc.com>
Subject: Re: [PATCH] AMCC Crypto4xx Device Driver v5
Date: Wed, 28 Jan 2009 09:41:56 -0800
Message-ID: <1233164516.4809.9.camel@jhsiao-usb>
References: <1231788650.5533.16.camel@jhsiao-usb>
	 <20090128035937.GA13157@gondor.apana.org.au>
Reply-To: jhsiao@amcc.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: kim.phillips@freescale.com, jwboyer@linux.vnet.ibm.com,
	linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02.amcc.com ([198.137.200.73]:31099 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZA1RiT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Jan 2009 12:38:19 -0500
In-Reply-To: <20090128035937.GA13157@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I will re submit the patch with proper changelog.
I had the change log this way is for the reviewer easy to see the
difference. But, I agree this is not proper for a newly created driver.

Thanks
James 
On Wed, 2009-01-28 at 14:59 +1100, Herbert Xu wrote:
> On Mon, Jan 12, 2009 at 11:30:50AM -0800, James Hsiao wrote:
> > This is the 5th submission of AMCC's security driver.
> > - remove aad support in build pd function, since we didn't release any
> > algorithm that use aead yet.
> > 
> > - changed some hardcode value to #defines
> > 
> > - changed local_irq_disable/enable to spinlock_irq_save/restore
> > 
> > - fixed bug in crypto4xx_probe on error exit.
> > 
> > 
> > Signed-off-by: James Hsiao <jhsiao@amcc.com>
> 
> I was going to apply this but you didn't give me a changelog
> that I can throw into the tree without feeling guilty!
> 
> Please always attach a proper changelog with each submission
> so I don't have to do this.  You can put the changelog elsewhere
> in the email.
> 
> Thanks,

