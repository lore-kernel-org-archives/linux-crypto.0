Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED7DD5F;
	Fri, 17 Nov 2023 03:24:12 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r3wx5-000dL3-JK; Fri, 17 Nov 2023 19:24:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Nov 2023 19:24:07 +0800
Date: Fri, 17 Nov 2023 19:24:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Ciunas Bennett <ciunas.bennett@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Adam Guerin <adam.guerin@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	Shashank Gupta <shashank.gupta@intel.com>,
	Tero Kristo <tero.kristo@linux.intel.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - prevent underflow in rp2srv_store()
Message-ID: <ZVdNV87FWjlCmHYf@gondor.apana.org.au>
References: <3fb31247-5f9c-4dba-a8b7-5d653c6509b6@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fb31247-5f9c-4dba-a8b7-5d653c6509b6@moroto.mountain>

On Tue, Oct 31, 2023 at 11:58:32AM +0300, Dan Carpenter wrote:
> The "ring" variable has an upper bounds check but nothing checks for
> negatives.  This code uses kstrtouint() already and it was obviously
> intended to be declared as unsigned int.  Make it so.
> 
> Fixes: dbc8876dd873 ("crypto: qat - add rp2svc sysfs attribute")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_sysfs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
