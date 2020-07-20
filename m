Return-Path: <SRS0=2iMm=A7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64CCFC433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jul 2020 17:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46371207DF
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jul 2020 17:10:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="qjoizLUn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbgGTRKN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jul 2020 13:10:13 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:25776 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgGTRKN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jul 2020 13:10:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1595265011;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=H8QB6i+b+GWECQyf6JYKMrFEuHuVS9Nhju9X2TokEgg=;
        b=qjoizLUnlh1aHFxBDV2Dey1AoOPSA0CeGuuYMiTpLT6xsw0gtePqa7/+g2LXTtk3Fc
        nBtHNUZdOXuDS/zqjO3TY4S/RQEAwA10zk3479DNERuHSccwPZB7JtVYYcfvbBmywFS8
        UiMEW8PJYI0EHI1UUVOp3EItL7eFerWY5BYycK7hypOZoM/EZRVP1fgxbbx8hMPkaswQ
        6+24Y9uwVQ5j5wYbms2KxWoYoeZNWSmvL87/lFTOwXkIvqC1E2qLiE8Rq/Bbq0JLsI1d
        HDY3jMl1CqVTLGYMfbgkk/XZ9vRXU4bbW6ByBYzvUCFLlF77bXhzBOLtFRsy7XOLIiGV
        JFww==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZJPScHiDh"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw6KH9uULO
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 20 Jul 2020 19:09:56 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
Subject: [PATCH v3 0/5] DH: SP800-56A rev 3 compliant validation checks
Date:   Mon, 20 Jul 2020 19:05:45 +0200
Message-ID: <2544426.mvXUDI8C0e@positron.chronox.de>
In-Reply-To: <5722559.lOV4Wx5bFT@positron.chronox.de>
References: <2543601.mvXUDI8C0e@positron.chronox.de> <5722559.lOV4Wx5bFT@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

This patch set adds the required checks to make all aspects of
(EC)DH compliant with SP800-56A rev 3 assuming that all keys
are ephemeral. The use of static keys adds yet additional
validations which are hard to achieve in the kernel.

SP800-56A rev 3 mandates various checks:

- validation of remote public key defined in section 5.6.2.2.2
  is already implemented in:

  * ECC: crypto_ecdh_shared_secret with the call of
    ecc_is_pubkey_valid_partial

  * FFC: dh_compute_val when the req->src is read and validated with
    dh_is_pubkey_valid

- validation of generated shared secret: The patch set adds the
  shared secret validation as defined by SP800-56A rev 3. For
  ECDH this only implies that the validation of the shared secret
  is moved before the shared secret is returned to the caller.

  For DH, the validation is required to be performed against the prime
  of the domain parameter set.

  This patch adds the MPI library file mpi_sub_ui that is required
  to calculate P - 1 for the DH check. It would be possible, though
  to simply set the LSB of the prime to 0 to obtain P - 1 (since
  P is odd per definition) which implies that mpi_sub_ui would not
  be needed. However, this would require a copy operation from
  the existing prime MPI value into a temporary MPI where the
  modification can be performed. Such copy operation is not available.
  Therefore, the solution with the addition of mpi_sub_ui was chosen.

  NOTE: The function mpi_sub_ui is also added with the patch set
  "[PATCH v5 2/8] lib/mpi: Extend the MPI library" currently sent
  to the linux-crypto mailing list.

- validation of the generated local public key: Patches 4 and 5 of
  this patch set adds the required checks.

Changes to v2:

- add reference to GnuMP providing the basis for patch 2 and updating
  the copyright note in patch 2

Changes to v1:

- fix reference to Gnu MP as outlined by Ard Biesheuvel
- addition of patches 4 and 5

Marcelo Henrique Cerri (1):
  lib/mpi: Add mpi_sub_ui()

Stephan Mueller (4):
  crypto: ECDH - check validity of Z before export
  crypto: DH - check validity of Z before export
  crypto: DH SP800-56A rev 3 local public key validation
  crypto: ECDH SP800-56A rev 3 local public key validation

 crypto/dh.c          | 38 +++++++++++++++++++++
 crypto/ecc.c         | 42 +++++++++++++++++++++---
 crypto/ecc.h         | 14 ++++++++
 include/linux/mpi.h  |  3 ++
 lib/mpi/Makefile     |  1 +
 lib/mpi/mpi-sub-ui.c | 78 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 172 insertions(+), 4 deletions(-)
 create mode 100644 lib/mpi/mpi-sub-ui.c

-- 
2.26.2




