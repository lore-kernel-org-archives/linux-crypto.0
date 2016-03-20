From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 07/10] crypto: qat - remove duplicate ASN.1 parser
Date: Sun, 20 Mar 2016 07:55:36 -0700
Message-ID: <56EEB9E8.3070808@intel.com>
References: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <1458325927-14737-7-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, smueller@chronox.de,
	horia.geanta@nxp.com
To: Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:60099 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbcCTPAU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Mar 2016 11:00:20 -0400
In-Reply-To: <1458325927-14737-7-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/18/2016 11:32 AM, Tudor Ambarus wrote:
> Use the RSA's software implementation parser with
> raw integer actions.
> 
> Compile-tested only.
> 
> Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
> ---
>  drivers/crypto/qat/Kconfig                        |   3 +-
>  drivers/crypto/qat/qat_common/Makefile            |  10 +-
>  drivers/crypto/qat/qat_common/qat_asym_algs.c     | 265 +++++++---------------
>  drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1 |  11 -
>  drivers/crypto/qat/qat_common/qat_rsapubkey.asn1  |   4 -
>  5 files changed, 83 insertions(+), 210 deletions(-)
>  delete mode 100644 drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1
>  delete mode 100644 drivers/crypto/qat/qat_common/qat_rsapubkey.asn1

Thanks for converting qat, but I'm working on adding support for the Chinese
remainder algorithm, which gives us big performance improvement, so please
do not change the qat driver just yet.
Please just add a generic ANS.1 parser that would allow to obtain all
components of the private key and I'll use it to add the handlers
and remove the ASN.1 parsing from qat. I will then test it to make sure
that it works fine before it is committed.
Thanks,
-- 
TS
