From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v2] crypto: vmx - VMX crypto should depend on CONFIG_VSX
Date: Fri, 11 Sep 2015 10:47:07 +1000
Message-ID: <1441932427.23806.2.camel@ellerman.id.au>
References: <1441786955-6249-1-git-send-email-mpe@ellerman.id.au>
	 <20150910092642.GA28753@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, leosilva@linux.vnet.ibm.com,
	Paul Mackerras <paulus@samba.org>, tim.gardner@canonical.com,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:60454 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbbIKArK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Sep 2015 20:47:10 -0400
In-Reply-To: <20150910092642.GA28753@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2015-09-10 at 17:26 +0800, Herbert Xu wrote:
> On Wed, Sep 09, 2015 at 06:22:35PM +1000, Michael Ellerman wrote:
> > This code uses FP (floating point), Altivec and VSX (Vector-Scalar
> > Extension). It can just depend on CONFIG_VSX though, because that
> > already depends on FP and Altivec.
> > 
> > Otherwise we get lots of link errors such as:
> > 
> >   drivers/built-in.o: In function `.p8_aes_setkey':
> >   aes.c:(.text+0x2d325c): undefined reference to `.enable_kernel_altivec'
> >   aes.c:(.text+0x2d326c): undefined reference to `.enable_kernel_vsx'
> > 
> > Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> 
> Applied.

Thanks.

Is that targeted for 4.3 ?

cheers
