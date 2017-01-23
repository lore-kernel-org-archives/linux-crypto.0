From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: vmx -- disable preemption to enable vsx in
 aes_ctr.c
Date: Mon, 23 Jan 2017 23:03:45 +0800
Message-ID: <20170123150345.GA21071@gondor.apana.org.au>
References: <1484901333.8207.11.camel@TP420>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, leosilva@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com
To: Li Zhong <zhong@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59063 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750705AbdAWPFX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2017 10:05:23 -0500
Content-Disposition: inline
In-Reply-To: <1484901333.8207.11.camel@TP420>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Li Zhong <zhong@linux.vnet.ibm.com> wrote:
> Some preemptible check warnings were reported from enable_kernel_vsx(). This
> patch disables preemption in aes_ctr.c before enabling vsx, and they are now 
> consistent with other files in the same directory.
> 
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
