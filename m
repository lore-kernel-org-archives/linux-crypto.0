From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/6] crypto: img-hash - Fix hash request context
Date: Tue, 12 Jul 2016 15:43:00 +0800
Message-ID: <20160712074300.GA29696@gondor.apana.org.au>
References: <1468229616-3888-3-git-send-email-will.thomas@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, will.thomas@imgtec.com
To: Will Thomas <will.thomas@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57657 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbcGLHnC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 03:43:02 -0400
Content-Disposition: inline
In-Reply-To: <1468229616-3888-3-git-send-email-will.thomas@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Will Thomas <will.thomas@imgtec.com> wrote:
> Move 0 length buffer to end of structure to stop overwriting
> fallback request data. This doesn't cause a bug itself as the
> buffer is never used alongside the fallback but should be
> changed.
> 
> Signed-off-by: Will Thomas <will.thomas@imgtec.com>
> Reviewed-by: James Hartley <james.hartley@imgtec.com>

This points out another bug, the fallback can have its own ctx
following the request.

So the set_reqsize call needs to be adjusted to take that into
account.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
