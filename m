Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30590611B;
	Fri, 22 Dec 2023 04:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rGXH8-00DhSU-Jr; Fri, 22 Dec 2023 12:36:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 Dec 2023 12:36:53 +0800
Date: Fri, 22 Dec 2023 12:36:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Mimi Zohar <zohar@linux.ibm.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: lib/mpi - Fix unexpected pointer access
Message-ID: <ZYUSZV8zHJMC444n@gondor.apana.org.au>
References: <20231214030834.2665-1-tianjia.zhang@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214030834.2665-1-tianjia.zhang@linux.alibaba.com>

On Thu, Dec 14, 2023 at 11:08:34AM +0800, Tianjia Zhang wrote:
> When the mpi_ec_ctx structure is initialized, some fields are not
> cleared, causing a crash when referencing the field when the
> structure was released. Initially, this issue was ignored because
> memory for mpi_ec_ctx is allocated with the __GFP_ZERO flag.
> For example, this error will be triggered when calculating the
> Za value for SM2 separately.
> 
> Fixes: d58bb7e55a8a ("lib/mpi: Introduce ec implementation to MPI library")
> Cc: stable@vger.kernel.org # v6.5
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  lib/crypto/mpi/ec.c | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
