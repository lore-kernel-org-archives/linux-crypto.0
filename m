From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUGFIX] Fix AES-NI CTR optimization compiling failure with
	gas 2.16.1
Date: Wed, 24 Mar 2010 21:38:29 +0800
Message-ID: <20100324133828.GA9700@gondor.apana.org.au>
References: <1268377307.1640.491.camel@yhuang-dev.sh.intel.com> <20100323142324.a53b20de.akpm@linux-foundation.org> <1269411858.23970.26.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:44608 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754982Ab0CXNik (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Mar 2010 09:38:40 -0400
Content-Disposition: inline
In-Reply-To: <1269411858.23970.26.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 24, 2010 at 02:24:18PM +0800, Huang Ying wrote:
>
> Subject: [BUGFIX] Fix another AES-NI CTR optimization compiling failure with gas 2.16.1
> 
> The previous AES-NI CTR optimization compiling failure gas 2.16.1 fix
> introduces another compiling failure by itself. This patch fixes that.
> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Patch applied.  Thank you.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
