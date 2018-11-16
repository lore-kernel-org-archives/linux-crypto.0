Return-Path: <SRS0=1iZj=N3=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37612 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727353AbeKPQ3k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Nov 2018 11:29:40 -0500
Date: Fri, 16 Nov 2018 14:18:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Vitaly Chikunov <vt@altlinux.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Mimi Zohar <zohar@linux.ibm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org
Subject: Re: [PATCH v4 0/3] crypto: streebog - add Streebog hash function
Message-ID: <20181116061835.cxrsjiktoawt3nof@gondor.apana.org.au>
References: <20181106210008.11241-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106210008.11241-1-vt@altlinux.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 07, 2018 at 12:00:00AM +0300, Vitaly Chikunov wrote:
> Add GOST/IETF Streebog hash function (GOST R 34.11-2012, RFC 6986)
> generic hash transformation with appropriate testmgr and tcrypt
> tests and vectors.
> 
> Streebog Hash Function (GOST R 34.11-2012, RFC 6986) is one of the Russian
> cryptographic standard algorithms (called GOST algorithms).
> 
> Intended user is the IMA subsystem, which does not need any particular
> patching besides adding the hash names into Hash Info arrays, this is also
> done in this patchset.
> 
> References:
>   https://tc26.ru/upload/iblock/fed/feddbb4d26b685903faa2ba11aea43f6.pdf
>   https://tools.ietf.org/html/rfc6986
> 
> Tested using testmgr and tcrypt on (LE) x86_64, arm, arm64, and (BE) s390x
> in qemu.
> 
> Changes from v1:
> - Fix of big-endian problem in add512.
> - More architectures are tested, including big-endian and 32-bit.
> 
> Changes from v2:
> - Register hash in Hash Info for use by IMA.
> - Add hmac() tests.
> 
> Changes from v3:
> - Remove not needed includes, and register, inline, const, ULL, and
>   __aligned specifiers.
> - Covert define macros into functions.
> - Use block size define instead of a number.
> - Rename algorithm names sb256, sb512 to streebog256, streebog512.
> - Rename bufsize to a more meaningful name (fillsize).
> - Prefix all static functions names with streebog_.
> 
> Vitaly Chikunov (3):
>   crypto: streebog - add Streebog hash function
>   crypto: streebog - register Streebog in hash info for IMA
>   crypto: streebog - add Streebog test vectors
> 
>  crypto/Kconfig                 |   12 +
>  crypto/Makefile                |    1 +
>  crypto/hash_info.c             |    4 +
>  crypto/streebog_generic.c      | 1140 ++++++++++++++++++++++++++++++++++++++++
>  crypto/tcrypt.c                |   37 ++
>  crypto/testmgr.c               |   24 +
>  crypto/testmgr.h               |  116 ++++
>  include/crypto/hash_info.h     |    1 +
>  include/crypto/streebog.h      |   34 ++
>  include/uapi/linux/hash_info.h |    2 +
>  10 files changed, 1371 insertions(+)
>  create mode 100644 crypto/streebog_generic.c
>  create mode 100644 include/crypto/streebog.h

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
