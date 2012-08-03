From: Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: Re: [PATCH] powerpc/crypto: Remove virt_to_abs() usage in nx-842.c
Date: Fri, 03 Aug 2012 09:40:54 -0500
Message-ID: <501BE2F6.5080506@linux.vnet.ibm.com>
References: <1343960595-30232-1-git-send-email-michael@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linuxppc-dev@ozlabs.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Ellerman <michael@ellerman.id.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33100 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab2HCOlC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Aug 2012 10:41:02 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <sjenning@linux.vnet.ibm.com>;
	Fri, 3 Aug 2012 10:41:01 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 9A2A9C90047
	for <linux-crypto@vger.kernel.org>; Fri,  3 Aug 2012 10:40:57 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q73EevQu083190
	for <linux-crypto@vger.kernel.org>; Fri, 3 Aug 2012 10:40:57 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q73EeuV4017715
	for <linux-crypto@vger.kernel.org>; Fri, 3 Aug 2012 11:40:56 -0300
In-Reply-To: <1343960595-30232-1-git-send-email-michael@ellerman.id.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/02/2012 09:23 PM, Michael Ellerman wrote:
> virt_to_abs() is just a wrapper around __pa(), use __pa() directly.
> 
> We should be including <asm/page.h> to get __pa(). abs_addr.h will be
> removed shortly so drop that.
> 
> We were getting of.h via abs_addr.h so we need to include that directly.
> 
> Having done all that, clean up the ordering of the includes.
> 
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
> ---
>  drivers/crypto/nx/nx-842.c |   34 ++++++++++++++++++----------------
>  1 file changed, 18 insertions(+), 16 deletions(-)

Looks good here.  Thanks for doing this!

Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
