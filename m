Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C309B1715
	for <linux-crypto@vger.kernel.org>; Thu,  7 Dec 2023 20:07:24 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rBS92-008IiG-1K; Fri, 08 Dec 2023 12:07:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 Dec 2023 12:07:29 +0800
Date: Fri, 8 Dec 2023 12:07:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Damian Muszynski <damian.muszynski@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - fix error path in add_update_sla()
Message-ID: <ZXKWgd1bTpbq1Daq@gondor.apana.org.au>
References: <20231128173828.84083-1-damian.muszynski@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128173828.84083-1-damian.muszynski@intel.com>

On Tue, Nov 28, 2023 at 06:37:32PM +0100, Damian Muszynski wrote:
> The input argument `sla_in` is a pointer to a structure that contains
> the parameters of the SLA which is being added or updated.
> If this pointer is NULL, the function should return an error as
> the data required for the algorithm is not available.
> By mistake, the logic jumps to the error path which dereferences
> the pointer.
> 
> This results in a warnings reported by the static analyzer Smatch when
> executed without a database:
> 
>     drivers/crypto/intel/qat/qat_common/adf_rl.c:871 add_update_sla()
>     error: we previously assumed 'sla_in' could be null (see line 812)
> 
> This issue was not found in internal testing as the pointer cannot be
> NULL. The function add_update_sla() is only called (indirectly) by
> the rate limiting sysfs interface implementation in adf_sysfs_rl.c
> which ensures that the data structure is allocated and valid. This is
> also proven by the fact that Smatch executed with a database does not
> report such error.
> 
> Fix it by returning with error if the pointer `sla_in` is NULL.
> 
> Fixes: d9fb8408376e ("crypto: qat - add rate limiting feature to qat_4xxx")
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_rl.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
