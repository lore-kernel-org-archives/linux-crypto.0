From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH 0/3] Support new function in the newer CCP
Date: Mon, 27 Feb 2017 11:41:09 -0600
Message-ID: <ca544586-4d1a-5b22-66fb-42641b9c640d@amd.com>
References: <20170215214954.26536.76736.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
To: Gary R Hook <gary.hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0062.outbound.protection.outlook.com ([104.47.41.62]:11995
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751341AbdB0SST (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Feb 2017 13:18:19 -0500
In-Reply-To: <20170215214954.26536.76736.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/15/2017 03:55 PM, Gary R Hook wrote:
> The following series implements new function in a version 5
> coprocessor. New features are:
>  - Support for SHA-2 384-bit and 512-bit hashing
>  - Support for AES GCM encryption
>  - Support for 3DES encryption


Please ignore. This patchset introduces build breaks. Will send a V2 
shortly.


>
> ---
>
> Gary R Hook (3):
>       crypto: ccp - Add SHA-2 384-/512-/bit support
>       crypto: ccp - Add support for AES GCM on v5 CCPs
>       crypto: ccp - Add 3DES function on v5 CCPs
>
>
>  drivers/crypto/ccp/Makefile                |    3
>  drivers/crypto/ccp/ccp-crypto-aes-galois.c |  257 ++++++++++++++
>  drivers/crypto/ccp/ccp-crypto-des3.c       |  254 ++++++++++++++
>  drivers/crypto/ccp/ccp-crypto-main.c       |   30 ++
>  drivers/crypto/ccp/ccp-crypto-sha.c        |   22 +
>  drivers/crypto/ccp/ccp-crypto.h            |   44 ++
>  drivers/crypto/ccp/ccp-dev-v3.c            |    1
>  drivers/crypto/ccp/ccp-dev-v5.c            |   54 +++
>  drivers/crypto/ccp/ccp-dev.h               |   14 +
>  drivers/crypto/ccp/ccp-ops.c               |  522
> ++++++++++++++++++++++++++++
>  include/linux/ccp.h                        |   68 ++++
>  11 files changed, 1263 insertions(+), 6 deletions(-)
>  create mode 100644 drivers/crypto/ccp/ccp-crypto-aes-galois.c
>  create mode 100644 drivers/crypto/ccp/ccp-crypto-des3.c
>
> --
> I'm pretty sure donuts would help.

-- 
This is my day job. Follow me at:
IG/Twitter/Facebook: @grhookphoto
IG/Twitter/Facebook: @grhphotographer
