From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/4] Introduce bulk mode for crypto engine framework
Date: Fri, 15 Apr 2016 21:48:49 +0800
Message-ID: <20160415134849.GA32694@gondor.apana.org.au>
References: <cover.1458023695.git.baolin.wang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, agk@redhat.com, snitzer@redhat.com,
	axboe@fb.com, dm-devel@redhat.com, akpm@linux-foundation.org,
	david.s.gordon@intel.com, thomas.lendacky@amd.com,
	robert.jarzmik@free.fr, yamada.masahiro@socionext.com,
	smueller@chronox.de, tadeusz.struk@intel.com,
	standby24x7@gmail.com, shli@kernel.org, broonie@kernel.org,
	linus.walleij@linaro.org, arnd@arndb.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-raid@vger.kernel.org
To: Baolin Wang <baolin.wang@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54480 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbcDONti (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Apr 2016 09:49:38 -0400
Content-Disposition: inline
In-Reply-To: <cover.1458023695.git.baolin.wang@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 15, 2016 at 03:47:58PM +0800, Baolin Wang wrote:
> Now some cipher hardware engines prefer to handle bulk block by merging requests
> to increase the block size and thus increase the hardware engine processing speed.
> 
> This patchset introduces request bulk mode to help the crypto hardware drivers
> improve in efficiency.

Could you please explain why this merging can't be done in dm-crypt
instead?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
