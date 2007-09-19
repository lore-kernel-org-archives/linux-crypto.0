From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Wed, 19 Sep 2007 20:29:43 +0800
Message-ID: <20070919122943.GD19866@gondor.apana.org.au>
References: <200708200234.25620.ak@suse.de> <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au> <20070820130639.GN16680@bingen.suse.de> <20070902224226.GA22869@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Andi Kleen <ak@suse.de>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3530 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754625AbXISM3w (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Sep 2007 08:29:52 -0400
Content-Disposition: inline
In-Reply-To: <20070902224226.GA22869@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 03, 2007 at 12:42:27AM +0200, Sebastian Siewior wrote:
>
> [crypto] do not use generic AES on i386 and x86_64
> 
> This patch automatically selects the assembly optimized version
> of AES (if selected) and the generic version can no longer be
> selected. The module will be called aes.ko

You don't need to rename it because it already provides an
alias for aes.

Also please provide a way to build the generic AES code so
that it can at least be tested on i386/x86_64.
 
Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
