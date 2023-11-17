Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0282A194;
	Fri, 17 Nov 2023 02:25:52 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r3w2j-000bmr-Iu; Fri, 17 Nov 2023 18:25:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Nov 2023 18:25:53 +0800
Date: Fri, 17 Nov 2023 18:25:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Srujana Challa <schalla@marvell.com>, Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	netdev@vger.kernel.org, linux-doc@vger.kernel.org,
	bbrezillon@kernel.org, arno@natisbad.org, kuba@kernel.org,
	ndabilpuram@marvell.com, sgoutham@marvell.com
Subject: Re: [PATCH v1 00/10] Add Marvell CN10KB/CN10KA B0 support
Message-ID: <ZVc/sQWzWYWYeFSt@gondor.apana.org.au>
References: <20231103053306.2259753-1-schalla@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103053306.2259753-1-schalla@marvell.com>

On Fri, Nov 03, 2023 at 11:02:56AM +0530, Srujana Challa wrote:
> Marvell OcteonTX2's next gen platform CN10KB/CN10KA B0
> introduced changes in CPT SG input format(SGv2) to make
> it compatibile with NIX SG input format, to support inline
> IPsec in SG mode.
> 
> This patchset modifies the octeontx2 CPT driver code to
> support SGv2 format for CN10KB/CN10KA B0. And also adds
> code to configure newly introduced HW registers.
> This patchset also implements SW workaround for couple of
> HW erratas.
> 
> ---
> v1:
> - Documented devlink parameters supported by octeontx2 CPT
>   driver.
> ---
> 
> Nithin Dabilpuram (2):
>   crypto/octeontx2: register error interrupts for inline cptlf
>   crypto: octeontx2: support setting ctx ilen for inline CPT LF
> 
> Srujana Challa (8):
>   crypto: octeontx2: remove CPT block reset
>   crypto: octeontx2: add SGv2 support for CN10KB or CN10KA B0
>   crypto: octeontx2: add devlink option to set max_rxc_icb_cnt
>   crypto: octeontx2: add devlink option to set t106 mode
>   crypto: octeontx2: remove errata workaround for CN10KB or CN10KA B0
>     chip.
>   crypto: octeontx2: add LF reset on queue disable
>   octeontx2-af: update CPT inbound inline IPsec mailbox
>   crypto: octeontx2: add ctx_val workaround
> 
>  Documentation/crypto/device_drivers/index.rst |   9 +
>  .../crypto/device_drivers/octeontx2.rst       |  29 ++
>  Documentation/crypto/index.rst                |   1 +
>  drivers/crypto/marvell/octeontx2/cn10k_cpt.c  |  87 +++++-
>  drivers/crypto/marvell/octeontx2/cn10k_cpt.h  |  25 ++
>  .../marvell/octeontx2/otx2_cpt_common.h       |  68 +++-
>  .../marvell/octeontx2/otx2_cpt_devlink.c      |  88 +++++-
>  .../marvell/octeontx2/otx2_cpt_hw_types.h     |   9 +-
>  .../marvell/octeontx2/otx2_cpt_mbox_common.c  |  26 ++
>  .../marvell/octeontx2/otx2_cpt_reqmgr.h       | 293 ++++++++++++++++++
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.c | 131 +++++---
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.h | 102 ++++--
>  drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   4 +
>  .../marvell/octeontx2/otx2_cptpf_main.c       |  76 ++---
>  .../marvell/octeontx2/otx2_cptpf_mbox.c       |  81 ++++-
>  .../marvell/octeontx2/otx2_cptpf_ucode.c      |  49 +--
>  .../marvell/octeontx2/otx2_cptpf_ucode.h      |   3 +-
>  drivers/crypto/marvell/octeontx2/otx2_cptvf.h |   2 +
>  .../marvell/octeontx2/otx2_cptvf_algs.c       |  31 ++
>  .../marvell/octeontx2/otx2_cptvf_algs.h       |   5 +
>  .../marvell/octeontx2/otx2_cptvf_main.c       |  25 +-
>  .../marvell/octeontx2/otx2_cptvf_mbox.c       |  27 ++
>  .../marvell/octeontx2/otx2_cptvf_reqmgr.c     | 162 +---------
>  .../net/ethernet/marvell/octeontx2/af/rvu.h   |  20 ++
>  .../ethernet/marvell/octeontx2/af/rvu_cpt.c   |  14 +
>  .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   1 +
>  26 files changed, 1063 insertions(+), 305 deletions(-)
>  create mode 100644 Documentation/crypto/device_drivers/index.rst
>  create mode 100644 Documentation/crypto/device_drivers/octeontx2.rst

Even though this touches drivers/crypto, it appears to be mainly
a networking patch.  So I'd prefer for this to go through the net
tree to ensure it gets reviewed properly.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
