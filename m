Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46EE17D1;
	Fri, 29 Dec 2023 03:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rJ3XT-00FG2J-5X; Fri, 29 Dec 2023 11:28:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 Dec 2023 11:28:10 +0800
Date: Fri, 29 Dec 2023 11:28:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Srujana Challa <schalla@marvell.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, kuba@kernel.org, bbrezillon@kernel.org,
	arno@natisbad.org, corbet@lwn.net,
	kalesh-anakkur.purayil@broadcom.com, horms@kernel.org,
	sgoutham@marvell.com, bbhushan2@marvell.com, jerinj@marvell.com,
	ndabilpuram@marvell.com
Subject: Re: [PATCH v3 0/9] Add Marvell CPT CN10KB/CN10KA B0 support
Message-ID: <ZY48yrgPHj1WW82u@gondor.apana.org.au>
References: <20231213073055.588530-1-schalla@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231213073055.588530-1-schalla@marvell.com>

On Wed, Dec 13, 2023 at 01:00:46PM +0530, Srujana Challa wrote:
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
> v3:
> - Dropped a patch to submit to netdev.
> v2:
> - Addressed review comments.
> - Fixed sparse errors reported by kernel test robot.
> 
> Nithin Dabilpuram (2):
>   crypto/octeontx2: register error interrupts for inline cptlf
>   crypto: octeontx2: support setting ctx ilen for inline CPT LF
> 
> Srujana Challa (7):
>   crypto: octeontx2: remove CPT block reset
>   crypto: octeontx2: add SGv2 support for CN10KB or CN10KA B0
>   crypto: octeontx2: add devlink option to set t106 mode
>   crypto: octeontx2: remove errata workaround for CN10KB or CN10KA B0
>     chip.
>   crypto: octeontx2: add LF reset on queue disable
>   octeontx2-af: update CPT inbound inline IPsec mailbox
>   crypto: octeontx2: add ctx_val workaround
> 
>  Documentation/crypto/device_drivers/index.rst |   9 +
>  .../crypto/device_drivers/octeontx2.rst       |  25 ++
>  Documentation/crypto/index.rst                |   1 +
>  drivers/crypto/marvell/octeontx2/cn10k_cpt.c  |  86 ++++-
>  drivers/crypto/marvell/octeontx2/cn10k_cpt.h  |  27 ++
>  .../marvell/octeontx2/otx2_cpt_common.h       |  54 +++-
>  .../marvell/octeontx2/otx2_cpt_devlink.c      |  44 ++-
>  .../marvell/octeontx2/otx2_cpt_hw_types.h     |   9 +-
>  .../marvell/octeontx2/otx2_cpt_mbox_common.c  |  26 ++
>  .../marvell/octeontx2/otx2_cpt_reqmgr.h       | 298 ++++++++++++++++++
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.c | 133 +++++---
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.h | 105 ++++--
>  drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   4 +
>  .../marvell/octeontx2/otx2_cptpf_main.c       |  73 ++---
>  .../marvell/octeontx2/otx2_cptpf_mbox.c       |  82 ++++-
>  .../marvell/octeontx2/otx2_cptpf_ucode.c      |  49 +--
>  .../marvell/octeontx2/otx2_cptpf_ucode.h      |   3 +-
>  drivers/crypto/marvell/octeontx2/otx2_cptvf.h |   2 +
>  .../marvell/octeontx2/otx2_cptvf_algs.c       |  31 ++
>  .../marvell/octeontx2/otx2_cptvf_algs.h       |   5 +
>  .../marvell/octeontx2/otx2_cptvf_main.c       |  23 +-
>  .../marvell/octeontx2/otx2_cptvf_mbox.c       |  28 ++
>  .../marvell/octeontx2/otx2_cptvf_reqmgr.c     | 162 +---------
>  23 files changed, 975 insertions(+), 304 deletions(-)
>  create mode 100644 Documentation/crypto/device_drivers/index.rst
>  create mode 100644 Documentation/crypto/device_drivers/octeontx2.rst
> 
> -- 
> 2.25.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
