From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: MPI - kunmap after finishing accessing buffer
Date: Tue, 22 Aug 2017 14:33:15 +0800
Message-ID: <20170822063315.GA5344@gondor.apana.org.au>
References: <3348160.hjCpAHFZrS@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37330 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751384AbdHVGd2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2017 02:33:28 -0400
Content-Disposition: inline
In-Reply-To: <3348160.hjCpAHFZrS@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 10, 2017 at 08:06:18AM +0200, Stephan Müller wrote:
> Hi Herbert,
> 
> I found that issue while playing around with edge conditions in my
> algif_akcipher implementation. This issue only manifests in a
> segmentation violation on 32 bit machines and with an SGL where each
> SG points to one byte. SGLs with larger buffers seem to be not
> affected by this issue.
> 
> Yet this access-after-unmap should be a candidate for stable, IMHO.

Good catch.  Thanks!

Fixes: 4816c9406430 ("lib/mpi: Fix SG miter leak")
Cc: <stable@vger.kernel.org>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
