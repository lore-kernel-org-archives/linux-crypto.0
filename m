From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: xts - consolidate sanity check for keys
Date: Tue, 16 Feb 2016 20:21:05 +0000
Message-ID: <20160216202105.GE11908@gondor.apana.org.au>
References: <15158977.dkvNB9OP41@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, ard.biesheuvel@linaro.org,
	stockhausen@collogia.de, jang@de.ibm.com, ying.huang@intel.com,
	jussi.kivilinna@mbnet.fi,
	Johannes.Goetzfried@informatik.stud.uni-erlangen.de,
	rsnel@cube.dyndns.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48073 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbcBPUVO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2016 15:21:14 -0500
Content-Disposition: inline
In-Reply-To: <15158977.dkvNB9OP41@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 09, 2016 at 03:37:47PM +0100, Stephan Mueller wrote:
> Hi,
> 
> Changes v2: remove comment and remove FIPS ifdefs as requested by Ard
> Biesheuvel

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
