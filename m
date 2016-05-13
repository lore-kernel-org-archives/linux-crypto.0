From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: SHA1-MB algorithm broken on latest kernel
Date: Fri, 13 May 2016 11:10:21 +0800
Message-ID: <20160513031020.GA12467@gondor.apana.org.au>
References: <1463095866.2594.8.camel@megha-Z97X-UD7-TH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Ingo Molnar <mingo@kernel.org>
To: Megha Dey <megha.dey@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51673 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbcEMDK6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 May 2016 23:10:58 -0400
Content-Disposition: inline
In-Reply-To: <1463095866.2594.8.camel@megha-Z97X-UD7-TH>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 12, 2016 at 04:31:06PM -0700, Megha Dey wrote:
> Hi,
>  
> When booting latest kernel with the CONFIG_CRYPTO_SHA1_MB enabled, I
> observe a panic.
>  
> After having a quick look, on reverting the following patches, I am able
> to complete the booting process.
> aec4d0e301f17bb143341c82cc44685b8af0b945
> 8691ccd764f9ecc69a6812dfe76214c86ac9ba06
> 68874ac3304ade7ed5ebb12af00d6b9bbbca0a16
>  
> Of the 3 patches, aec4d0e301f17bb143341c82cc44685b8af0b945 seems wrong.
> The r10 to r15 registers are used in sha1_x8_avx2.S, which is called
> from sha1_mb_mgr_flush_avx2.S.
>  
> I do not think the functionality of the SHA1-MB crypto algorithm has
> been tested after applying these changes. (I am not sure if any of the
> other crypto algorithms have been affected by these changes).

Josh, Ingo:

Any ideas on this? Should we revert?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
