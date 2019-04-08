Return-Path: <SRS0=0IUk=SK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57BC6C10F13
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 16:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3300820857
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 16:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfDHQFV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Apr 2019 12:05:21 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:50552 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbfDHQFU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Apr 2019 12:05:20 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 0770B72CCAC;
        Mon,  8 Apr 2019 19:05:17 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id E74854A4A2A;
        Mon,  8 Apr 2019 19:05:16 +0300 (MSK)
Date:   Mon, 8 Apr 2019 19:05:16 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/10] crypto: add EC-RDSA (GOST 34.10) algorithm
Message-ID: <20190408160516.wvpcnvrmask56b2g@altlinux.org>
Mail-Followup-To: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190326125842.24110-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20190326125842.24110-1-vt@altlinux.org>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert,

On Tue, Mar 26, 2019 at 03:58:32PM +0300, Vitaly Chikunov wrote:
> This patchset changes akcipher API to support ECDSA style signature
> verification, augments x509 parser to make it work with EC-RDSA certificates,
> and, finally, implements EC-RDSA (GOST 34.10) signature verification and its
> integration with IMA.

Can you please explain what changes are requested?

Thanks,

> 
> Special request to Mimi Zohar and David Howells to Ack relevant commits, please.
> 
> ---
> This patchset should be applied over cryptodev tree commit 4e5180eb3d4f
> 
> Changes since v7:
> - Do not check callback validity in akcipher requests, instead define default
>   callbacks on register, suggested by Herbert Xu.
> - Sanity checks in crypto_akcipher_maxsize are removed (not needed).
> - Sanity checks for `dst' and `dst_len' are removed from verify op (not
>   needed in akcipher API and should be checked by a driver).
> - Patch "KEYS: report to keyctl only actually supported key ops" is removed,
>   as it would affect user-space API.
> 
> Changes since (v5-v6):
> - set_params API is removed in favor of appending parameters into a key stream,
>   as requested by Herbert Xu.
> - verify op signature de-kmemdup'ed (as requested by David Howells) in separate
>   patch (as requested by Herbert Xu).
> - Add forgotten ASN.1 parser files to EC-RDSA patch.
> - Tested on x86_64.
> 
> Changes since v5:
> - Comparison of hash algo by enum id instead of text name, as suggested by
>   Thiago Jung Bauermann and Mimi Zohar.
> 
> Changes since RFC (v1-v4):
> - akcipher set_max_size, encrypt, decrypt, sign, verify callbacks may be
>   undefined by the drivers, so their crypto_akcipher_* frontends check for
>   their presence before passing the call.
> - supported_ops flags are set for keyctl, based on the presence of implemented
>   akcipher callbacks.
> - Transition to verify2 API is abandoned because raw RSA does not need
>   sign/verify ops at all, and we can switch to the new verify in one step.
>   For this RSA backends have sign/verify ops removed as they should only
>   be used (and actually used only) via PKCS1 driver.
> - Verify callback requires digest as the input parameter in src SGL, as
>   suggested by Herbert Xu, (instead of a separate parameter, as it was in
>   verify2).
> - For verify op signature is moved into kmalloc'd memory as suggested by
>   Herbert Xu.
> - set_params API should be called before set_{pub,priv}_key, thus set_*_key
>   knows everything it needs to set they key properly. Also, set_params made
>   optional for back compatibility with RSA drivers.
> - Public-key cryptography section is created in Kconfig.
> - ecc.c is made into separate module object, to be used together by ECDH and
>   EC-RDSA.
> - EC-RDSA parameters and public key are parsed using asn1_ber_decoder as
>   suggested by Stephan Mueller and David Howells.
> - Test vectors are added and tests are passing.
> - Curves/parameters definitions are split from ecrdsa.c into ecrdsa_defs.h.
> - Integration with IMA in asymmetric_verify(). Userspace ima-evm-utils already
>   have a patch in the queue to support this. Tested on x86_64.
> 
> Vitaly Chikunov (10):
>   crypto: akcipher - default implementations for request callbacks
>   crypto: rsa - unimplement sign/verify for raw RSA backends
>   crypto: akcipher - new verify API for public key algorithms
>   KEYS: do not kmemdup digest in {public,tpm}_key_verify_signature
>   X.509: parse public key parameters from x509 for akcipher
>   crypto: Kconfig - create Public-key cryptography section
>   crypto: ecc - make ecc into separate module
>   crypto: ecrdsa - add EC-RDSA (GOST 34.10) algorithm
>   crypto: ecrdsa - add EC-RDSA test vectors to testmgr
>   integrity: support EC-RDSA signatures for asymmetric_verify
> 
>  crypto/Kconfig                                |  63 ++--
>  crypto/Makefile                               |  10 +-
>  crypto/akcipher.c                             |  14 +
>  crypto/asymmetric_keys/asym_tpm.c             |  77 +++--
>  crypto/asymmetric_keys/public_key.c           | 105 ++++---
>  crypto/asymmetric_keys/x509.asn1              |   2 +-
>  crypto/asymmetric_keys/x509_cert_parser.c     |  57 +++-
>  crypto/ecc.c                                  | 417 +++++++++++++++++++++++++-
>  crypto/ecc.h                                  | 153 +++++++++-
>  crypto/ecc_curve_defs.h                       |  15 -
>  crypto/ecrdsa.c                               | 296 ++++++++++++++++++
>  crypto/ecrdsa_defs.h                          | 225 ++++++++++++++
>  crypto/ecrdsa_params.asn1                     |   4 +
>  crypto/ecrdsa_pub_key.asn1                    |   1 +
>  crypto/rsa-pkcs1pad.c                         |  33 +-
>  crypto/rsa.c                                  | 109 -------
>  crypto/testmgr.c                              |  80 +++--
>  crypto/testmgr.h                              | 159 ++++++++++
>  drivers/crypto/caam/caampkc.c                 |   2 -
>  drivers/crypto/ccp/ccp-crypto-rsa.c           |   2 -
>  drivers/crypto/qat/qat_common/qat_asym_algs.c |   2 -
>  include/crypto/akcipher.h                     |  54 ++--
>  include/crypto/public_key.h                   |   4 +
>  include/linux/oid_registry.h                  |  18 ++
>  security/integrity/digsig_asymmetric.c        |  11 +-
>  25 files changed, 1606 insertions(+), 307 deletions(-)
>  create mode 100644 crypto/ecrdsa.c
>  create mode 100644 crypto/ecrdsa_defs.h
>  create mode 100644 crypto/ecrdsa_params.asn1
>  create mode 100644 crypto/ecrdsa_pub_key.asn1
> 
> -- 
> 2.11.0
