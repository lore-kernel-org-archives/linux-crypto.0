From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: caam - add support for rfc4543(gcm(aes))
Date: Thu, 4 Dec 2014 18:22:45 -0600
Message-ID: <20141204182245.f352ea22dc61ea6f65d85c62@freescale.com>
References: <1414686811-6527-1-git-send-email-tudor.ambarus@freescale.com>
	<1414688107-8196-1-git-send-email-tudor.ambarus@freescale.com>
	<20141106151714.GE4544@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Tudor Ambarus <tudor.ambarus@freescale.com>,
	<linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0114.outbound.protection.outlook.com ([157.56.111.114]:8741
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752093AbaLEA2E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Dec 2014 19:28:04 -0500
In-Reply-To: <20141106151714.GE4544@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 6 Nov 2014 23:17:14 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Thu, Oct 30, 2014 at 06:55:07PM +0200, Tudor Ambarus wrote:
> > Add AES-GMAC as an IPSec ESP mechanism to provide
> > data origin authentication, but not confidentiality.
> > This method is referred as ENCR_NULL_AUTH_AES_GMAC.
> > 
> > Signed-off-by: Tudor Ambarus <tudor.ambarus@freescale.com>
> 
> Applied.

this commit gets this when running the tcrypt module:

caam_jr ffe302000.jr: 2000221a: CCB: desc idx 34: AES: ICV check failed.
caam_jr ffe302000.jr: 2000221a: CCB: desc idx 34: AES: ICV check failed.
caam_jr ffe302000.jr: 2000221a: CCB: desc idx 34: AES: ICV check failed.

Briefly looking at testmgr's aes_gcm_rfc4543_dec_tv_template, there
are only two decryption vectors, and, according to the comment, only
the latter should fail?

Thanks,

Kim
