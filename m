Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523ED19BD2;
	Fri, 15 Dec 2023 09:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rE4xb-00BCm1-El; Fri, 15 Dec 2023 17:58:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Dec 2023 17:58:33 +0800
Date: Fri, 15 Dec 2023 17:58:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bharat Bhushan <bbhushan2@marvell.com>
Cc: bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
	davem@davemloft.net, alobakin@pm.me, masahiroy@kernel.org,
	tj@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: octeontx2: Fix cptvf driver cleanup
Message-ID: <ZXwjSTIwJIfcWKeX@gondor.apana.org.au>
References: <20231211044558.41461-1-bbhushan2@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211044558.41461-1-bbhushan2@marvell.com>

On Mon, Dec 11, 2023 at 10:15:58AM +0530, Bharat Bhushan wrote:
> This patch fixes following cleanup issues:
>  - Missing instruction queue free on cleanup. This
>    will lead to memory leak.
>  - lfs->lfs_num is set to zero before cleanup, which
>    will lead to improper cleanup.
>  - Missing otx2_cptlf_shutdown() from cptvf driver cleanup
> 
> Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
> ---
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.c      |  6 ++++--
>  drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c | 10 ++++------
>  2 files changed, 8 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
