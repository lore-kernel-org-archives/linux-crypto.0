From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] powerpc/crypto/crct10dif-vpmsum: Fix missing
 preempt_disable()
Date: Fri, 21 Apr 2017 21:16:35 +0800
Message-ID: <20170421131635.GH14803@gondor.apana.org.au>
References: <1492666509-4568-1-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linuxppc-dev@ozlabs.org, dja@axtens.net,
        linux-crypto@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:42934 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1039759AbdDUNRJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 09:17:09 -0400
Content-Disposition: inline
In-Reply-To: <1492666509-4568-1-git-send-email-mpe@ellerman.id.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 20, 2017 at 03:35:09PM +1000, Michael Ellerman wrote:
> In crct10dif_vpmsum() we call enable_kernel_altivec() without first
> disabling preemption, which is not allowed.
> 
> It used to be sufficient just to call pagefault_disable(), because that
> also disabled preemption. But the two were decoupled in commit 8222dbe21e79
> ("sched/preempt, mm/fault: Decouple preemption from the page fault
> logic") in mid 2015.
> 
> The crct10dif-vpmsum code inherited this bug from the crc32c-vpmsum code
> on which it was modelled.
> 
> So add the missing preempt_disable/enable(). We should also call
> disable_kernel_fp(), although it does nothing by default, there is a
> debug switch to make it active and all enables should be paired with
> disables.
> 
> Fixes: b01df1c16c9a ("crypto: powerpc - Add CRC-T10DIF acceleration")
> Acked-by: Daniel Axtens <dja@axtens.net>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
