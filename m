From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: s390 des3 - permit weak keys unless
	REQ_WEAK_KEY set
Date: Thu, 18 Jun 2009 19:53:21 +0800
Message-ID: <20090618115321.GE6596@gondor.apana.org.au>
References: <200906081332.10608.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:35489 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756496AbZFRLxU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2009 07:53:20 -0400
Content-Disposition: inline
In-Reply-To: <200906081332.10608.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 08, 2009 at 01:32:09PM -0400, Jarod Wilson wrote:
> Just started running fips cavs test vectors through an s390x system
> for giggles, and discovered that I missed patching s390's arch-specific
> des3 implementation w/an earlier des3 patch to permit weak keys.
> 
> This change adds the same flag tweaks as ad79cdd77fc1466e45cf923890f66bcfe7c43f12
> for s390's des3 implementation, yields expected test results now.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Patch applied to cryptodev.  Thanks Jarod!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
