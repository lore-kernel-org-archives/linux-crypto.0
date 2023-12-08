Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5A51712
	for <linux-crypto@vger.kernel.org>; Thu,  7 Dec 2023 20:07:30 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rBS98-008IiN-H4; Fri, 08 Dec 2023 12:07:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 Dec 2023 12:07:36 +0800
Date: Fri, 8 Dec 2023 12:07:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Damian Muszynski <damian.muszynski@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - fix mutex ordering in adf_rl
Message-ID: <ZXKWiL5SqG/hvNYv@gondor.apana.org.au>
References: <20231128174053.84356-1-damian.muszynski@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128174053.84356-1-damian.muszynski@intel.com>

On Tue, Nov 28, 2023 at 06:39:30PM +0100, Damian Muszynski wrote:
> If the function validate_user_input() returns an error, the error path
> attempts to unlock an unacquired mutex.
> Acquire the mutex before calling validate_user_input(). This is not
> strictly necessary but simplifies the code.
> 
> Fixes: d9fb8408376e ("crypto: qat - add rate limiting feature to qat_4xxx")
> Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_rl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
