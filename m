From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] Change CCP ISR handler model
Date: Mon, 24 Apr 2017 18:22:19 +0800
Message-ID: <20170424102219.GC20943@gondor.apana.org.au>
References: <20170421151225.11643.91749.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:47324 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1168571AbdDXKim (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Apr 2017 06:38:42 -0400
Content-Disposition: inline
In-Reply-To: <20170421151225.11643.91749.stgit@taos.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 21, 2017 at 10:49:56AM -0500, Gary R Hook wrote:
> he CCP has the ability to perform several operations
> simultaneously, but only one interrupt. The current design
> exposes a window when using MSI/MSI-X interrupts wherein
> state can change but no interrupt is generated; this can
> lead to a hang in the engine.  Switch to a tasklet backend
> which allows serializing state changes, handles processing
> of the interrupts, and avoids the loss of task completion
> status.
> 
> ---
> 
> Gary R Hook (2):
>       crypto: ccp - Change ISR handler method for a v3 CCP
>       crypto: ccp - Change ISR handler method for a v5 CCP

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
