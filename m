Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6193DC433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Dec 2021 05:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbhLKF4j (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Dec 2021 00:56:39 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57714 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhLKF4j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Dec 2021 00:56:39 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1mvvN1-000512-Ut; Sat, 11 Dec 2021 16:56:33 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 11 Dec 2021 16:56:31 +1100
Date:   Sat, 11 Dec 2021 16:56:31 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Shijith Thotton <sthotton@marvell.com>
Cc:     Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        linux-crypto@vger.kernel.org, jerinj@marvell.com,
        sgoutham@marvell.com, gcherian@marvell.com,
        ndabilpuram@marvell.com, schalla@marvell.com
Subject: Re: [PATCH 0/2] Octeon TX2 CPT custom engine group
Message-ID: <20211211055631.GD6841@gondor.apana.org.au>
References: <cover.1638348922.git.sthotton@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1638348922.git.sthotton@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 01, 2021 at 02:31:59PM +0530, Shijith Thotton wrote:
> Octeon TX2 CPT has three type of engines to handle symmetric, asymmetric
> and ipsec specific workload. For better utilization, these engines can
> be grouped to custom groups at runtime. Devlink parameters are used to
> create and destroy the custom groups (devlink is a framework mainly used
> in network subsystem).
> 
> Srujana Challa (2):
>   crypto: octeontx2: add apis for custom engine groups
>   crypto: octeontx2: parameters for custom engine groups
> 
>  drivers/crypto/marvell/octeontx2/Makefile     |   2 +-
>  .../marvell/octeontx2/otx2_cpt_common.h       |   1 +
>  .../marvell/octeontx2/otx2_cpt_devlink.c      | 108 ++++++
>  .../marvell/octeontx2/otx2_cpt_devlink.h      |  20 ++
>  drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   3 +
>  .../marvell/octeontx2/otx2_cptpf_main.c       |   9 +
>  .../marvell/octeontx2/otx2_cptpf_ucode.c      | 322 +++++++++++++++++-
>  .../marvell/octeontx2/otx2_cptpf_ucode.h      |   7 +-
>  8 files changed, 464 insertions(+), 8 deletions(-)
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cpt_devlink.h

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
