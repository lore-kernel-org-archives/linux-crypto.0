Return-Path: <SRS0=j/eP=BK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 345BBC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 13:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1769222B49
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Jul 2020 13:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731515AbgGaNaJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Jul 2020 09:30:09 -0400
Received: from [216.24.177.18] ([216.24.177.18]:40508 "EHLO fornost.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbgGaNaJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Jul 2020 09:30:09 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k1V6D-00016B-Mf; Fri, 31 Jul 2020 23:29:26 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Jul 2020 23:29:25 +1000
Date:   Fri, 31 Jul 2020 23:29:25 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
Subject: Re: [PATCH v3 0/5] DH: SP800-56A rev 3 compliant validation checks
Message-ID: <20200731132925.GA14360@gondor.apana.org.au>
References: <2543601.mvXUDI8C0e@positron.chronox.de>
 <5722559.lOV4Wx5bFT@positron.chronox.de>
 <2544426.mvXUDI8C0e@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2544426.mvXUDI8C0e@positron.chronox.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 20, 2020 at 07:05:45PM +0200, Stephan Müller wrote:
> Hi,
> 
> This patch set adds the required checks to make all aspects of
> (EC)DH compliant with SP800-56A rev 3 assuming that all keys
> are ephemeral. The use of static keys adds yet additional
> validations which are hard to achieve in the kernel.
> 
> SP800-56A rev 3 mandates various checks:
> 
> - validation of remote public key defined in section 5.6.2.2.2
>   is already implemented in:
> 
>   * ECC: crypto_ecdh_shared_secret with the call of
>     ecc_is_pubkey_valid_partial
> 
>   * FFC: dh_compute_val when the req->src is read and validated with
>     dh_is_pubkey_valid
> 
> - validation of generated shared secret: The patch set adds the
>   shared secret validation as defined by SP800-56A rev 3. For
>   ECDH this only implies that the validation of the shared secret
>   is moved before the shared secret is returned to the caller.
> 
>   For DH, the validation is required to be performed against the prime
>   of the domain parameter set.
> 
>   This patch adds the MPI library file mpi_sub_ui that is required
>   to calculate P - 1 for the DH check. It would be possible, though
>   to simply set the LSB of the prime to 0 to obtain P - 1 (since
>   P is odd per definition) which implies that mpi_sub_ui would not
>   be needed. However, this would require a copy operation from
>   the existing prime MPI value into a temporary MPI where the
>   modification can be performed. Such copy operation is not available.
>   Therefore, the solution with the addition of mpi_sub_ui was chosen.
> 
>   NOTE: The function mpi_sub_ui is also added with the patch set
>   "[PATCH v5 2/8] lib/mpi: Extend the MPI library" currently sent
>   to the linux-crypto mailing list.
> 
> - validation of the generated local public key: Patches 4 and 5 of
>   this patch set adds the required checks.
> 
> Changes to v2:
> 
> - add reference to GnuMP providing the basis for patch 2 and updating
>   the copyright note in patch 2
> 
> Changes to v1:
> 
> - fix reference to Gnu MP as outlined by Ard Biesheuvel
> - addition of patches 4 and 5
> 
> Marcelo Henrique Cerri (1):
>   lib/mpi: Add mpi_sub_ui()
> 
> Stephan Mueller (4):
>   crypto: ECDH - check validity of Z before export
>   crypto: DH - check validity of Z before export
>   crypto: DH SP800-56A rev 3 local public key validation
>   crypto: ECDH SP800-56A rev 3 local public key validation
> 
>  crypto/dh.c          | 38 +++++++++++++++++++++
>  crypto/ecc.c         | 42 +++++++++++++++++++++---
>  crypto/ecc.h         | 14 ++++++++
>  include/linux/mpi.h  |  3 ++
>  lib/mpi/Makefile     |  1 +
>  lib/mpi/mpi-sub-ui.c | 78 ++++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 172 insertions(+), 4 deletions(-)
>  create mode 100644 lib/mpi/mpi-sub-ui.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
