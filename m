Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDC67476;
	Fri, 22 Dec 2023 04:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rGX4r-00DhGk-B3; Fri, 22 Dec 2023 12:24:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 Dec 2023 12:24:12 +0800
Date: Fri, 22 Dec 2023 12:24:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	qat-linux@intel.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>
Subject: Re: [PATCH 1/5] math.h: Add avg_array()
Message-ID: <ZYUPbIGNJAfow5tz@gondor.apana.org.au>
References: <20231215152440.34537-1-lucas.segarra.fernandez@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231215152440.34537-1-lucas.segarra.fernandez@intel.com>

On Fri, Dec 15, 2023 at 04:24:40PM +0100, Lucas Segarra Fernandez wrote:
> Add macro to compute average of values within an array.
> 
> This patch is based on earlier work done by Wojciech Ziemba.
> 
> Signed-off-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
> ---
>  include/linux/math.h | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)

I think adding this to a common header when there are no other
users is a bit premature.  Please keep it in a local header file
until a new user appears.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
