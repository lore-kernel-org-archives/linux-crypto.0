From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - make qat_asym_algs.o depend on asn1 headers
Date: Thu, 21 Jul 2016 12:14:41 +0800
Message-ID: <20160721041441.GA8731@gondor.apana.org.au>
References: <a53076f443d43d1153dcef0fb35126b5753b08c7.1467281942.git.jstancek@redhat.com>
 <20160701093008.GB13424@gondor.apana.org.au>
 <75bc3619-1d11-4759-257c-d2db4ba442ff@mageia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Stancek <jstancek@redhat.com>, tadeusz.struk@intel.com,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Salvatore Benedetto <salvatore.benedetto@intel.com>
To: Thomas Backlund <tmb@mageia.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41904 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbcGUEOu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Jul 2016 00:14:50 -0400
Content-Disposition: inline
In-Reply-To: <75bc3619-1d11-4759-257c-d2db4ba442ff@mageia.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 20, 2016 at 06:37:07PM +0300, Thomas Backlund wrote:
>
> Yeah, but that patch seem to be heading to 4.8 only , so qat build
> in upcoming 4.7 still breaks...
> 
> and pulling that fix only to 4.7 breaks too, so I guess more fixes
> would be needed for proper backport then...
> 
> or are the qat fixes already queued somewhere for 4.7 final ?

You're right.  This patch is probably the safest fix for 4.7.

I'll bounce it to stable.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
