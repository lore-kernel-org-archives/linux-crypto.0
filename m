From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V3 0/2] Interrupt management fixes
Date: Fri, 21 Apr 2017 21:17:04 +0800
Message-ID: <20170421131704.GJ14803@gondor.apana.org.au>
References: <20170420202030.4843.76826.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:42954 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1039839AbdDUNRf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 09:17:35 -0400
Content-Disposition: inline
In-Reply-To: <20170420202030.4843.76826.stgit@taos.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 20, 2017 at 03:24:00PM -0500, Gary R Hook wrote:
> Correct the driver to attend to only relevant interrupt
> bits, and ensure that interrupts are managed properly
> at module unload.
> 
> Changes from V2:
> - Apply patches to relevant stable branches

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
