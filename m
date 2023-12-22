Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023046111;
	Fri, 22 Dec 2023 03:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rGWVY-00DgxT-W1; Fri, 22 Dec 2023 11:47:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 Dec 2023 11:47:43 +0800
Date: Fri, 22 Dec 2023 11:47:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Srujana Challa <schalla@marvell.com>, davem@davemloft.net,
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	linux-doc@vger.kernel.org, bbrezillon@kernel.org, arno@natisbad.org,
	pabeni@redhat.com, edumazet@google.com, corbet@lwn.net,
	sgoutham@marvell.com, bbhushan2@marvell.com, jerinj@marvell.com,
	sbhatta@marvell.com, hkelam@marvell.com, lcherian@marvell.com,
	gakula@marvell.com, ndabilpuram@marvell.com
Subject: Re: [PATCH net-next v2 00/10] Add Marvell CPT CN10KB/CN10KA B0
 support
Message-ID: <ZYUG38ATpvE+/2eI@gondor.apana.org.au>
References: <20231212051730.386088-1-schalla@marvell.com>
 <20231212100357.452dff35@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231212100357.452dff35@kernel.org>

On Tue, Dec 12, 2023 at 10:03:57AM -0800, Jakub Kicinski wrote:
> On Tue, 12 Dec 2023 10:47:20 +0530 Srujana Challa wrote:
> > [PATCH net-next v2 00/10] Add Marvell CPT CN10KB/CN10KA B0 support
> 
> I'm not sure why we're expected to take this via netdev.
> Looks like crypto stuff.

Where there is very little crypto in it too, even though it lives
under the crypto subdirectory it's mostly IPsec offload so it's
hooked up to the network stack and does not touch the crypto API
at all.

This seems to be adding a bunch of devlink parameters.  If you're
OK with that then I could take it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
