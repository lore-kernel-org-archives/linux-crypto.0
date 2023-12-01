Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90134F1;
	Fri,  1 Dec 2023 02:13:50 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r90Wo-005ho8-7w; Fri, 01 Dec 2023 18:13:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 01 Dec 2023 18:13:55 +0800
Date: Fri, 1 Dec 2023 18:13:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Weili Qian <qianweili@huawei.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	liulongfang@huawei.com
Subject: Re: [PATCH 0/3] crypto: hisilicon - some cleanups for hisilicon
 drivers
Message-ID: <ZWmx45BBeKYEd3wX@gondor.apana.org.au>
References: <20231125115011.22519-1-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231125115011.22519-1-qianweili@huawei.com>

On Sat, Nov 25, 2023 at 07:50:08PM +0800, Weili Qian wrote:
> Some cleanups for hisilicon drivers, and add comments
> to improve the code readability.
> 
> Weili Qian (3):
>   crypto: hisilicon/sgl - small cleanups for sgl.c
>   crypto: hisilicon/qm - simplify the status of qm
>   crypto: hisilicon/qm - add comments and remove redundant array element
> 
>  Documentation/ABI/testing/debugfs-hisi-hpre |   2 +-
>  Documentation/ABI/testing/debugfs-hisi-sec  |   2 +-
>  Documentation/ABI/testing/debugfs-hisi-zip  |   2 +-
>  drivers/crypto/hisilicon/debugfs.c          |   4 +
>  drivers/crypto/hisilicon/qm.c               | 141 ++++----------------
>  drivers/crypto/hisilicon/qm_common.h        |   4 -
>  drivers/crypto/hisilicon/sgl.c              |  12 +-
>  include/linux/hisi_acc_qm.h                 |   8 +-
>  8 files changed, 42 insertions(+), 133 deletions(-)
> 
> -- 
> 2.33.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
