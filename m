Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C89B1716;
	Thu,  7 Dec 2023 20:10:19 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rBSBq-008Imt-3s; Fri, 08 Dec 2023 12:10:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 Dec 2023 12:10:23 +0800
Date: Fri, 8 Dec 2023 12:10:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Zhiqi Song <songzhiqi1@huawei.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, wangzhou1@hisilicon.com,
	fanghao11@huawei.com, liulongfang@huawei.com, qianweili@huawei.com,
	shenyang39@huawei.com
Subject: Re: [PATCH 0/5] crypto: hisilicon - fix the process to obtain
 capability register value
Message-ID: <ZXKXL7zTnD2Yxdum@gondor.apana.org.au>
References: <20231202091722.1974582-1-songzhiqi1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231202091722.1974582-1-songzhiqi1@huawei.com>

On Sat, Dec 02, 2023 at 05:17:17PM +0800, Zhiqi Song wrote:
> This patchset fixes the process to obtain the value of capability
> registers related to irq and alg support info. Pre-store the valid
> values of them.
> 
> Wenkai Lin (1):
>   crypto: hisilicon/qm - add a function to set qm algs
> 
> Zhiqi Song (4):
>   crypto: hisilicon/qm - save capability registers in qm init process
>   crypto: hisilicon/hpre - save capability registers in probe process
>   crypto: hisilicon/sec2 - save capability registers in probe process
>   crypto: hisilicon/zip - save capability registers in probe process
> 
>  drivers/crypto/hisilicon/hpre/hpre_main.c  | 122 +++++++++++----------
>  drivers/crypto/hisilicon/qm.c              |  98 +++++++++++++++--
>  drivers/crypto/hisilicon/sec2/sec.h        |   7 ++
>  drivers/crypto/hisilicon/sec2/sec_crypto.c |  10 +-
>  drivers/crypto/hisilicon/sec2/sec_main.c   |  70 ++++++------
>  drivers/crypto/hisilicon/zip/zip_main.c    | 120 +++++++++++---------
>  include/linux/hisi_acc_qm.h                |  20 +++-
>  7 files changed, 293 insertions(+), 154 deletions(-)
> 
> -- 
> 2.30.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
