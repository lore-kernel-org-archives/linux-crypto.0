Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51605C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 06:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 239F364F07
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 06:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbhCDGoQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Mar 2021 01:44:16 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:52640 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235636AbhCDGnx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Mar 2021 01:43:53 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lHhhG-0007cA-84; Thu, 04 Mar 2021 17:42:55 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 04 Mar 2021 17:42:54 +1100
Date:   Thu, 4 Mar 2021 17:42:54 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/11] Regression fixes/clean ups in the Qualcomm
 crypto engine driver
Message-ID: <20210304064253.GH15863@gondor.apana.org.au>
References: <20210211200128.2886388-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211200128.2886388-1-thara.gopinath@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 11, 2021 at 03:01:17PM -0500, Thara Gopinath wrote:
> This patch series is a result of running kernel crypto fuzz tests (by
> enabling CONFIG_CRYPTO_MANAGER_EXTRA_TESTS) on the transformations
> currently supported via the Qualcomm crypto engine on sdm845.  The first
> nine patches are fixes for various regressions found during testing. The
> last two patches are minor clean ups of unused variable and parameters.
> 
> v6->v7:
> 	- Fixed sparse warning in patch 4 as pointed out by Herbert Xu.
> 	  This means the checking if any two keys are same for triple
> 	  des algorithms has been reverted back to using conditional OR
> 	  instead of using bitwise OR.
> 	- Rebased to 5.11-rc7.
> 
> v5->v6:
> 	- Return 0 for zero length messages instead of -EOPNOTSUPP in the
> 	  cipher algorithms as pointed out by Eric Biggers.
> 	- Remove the wrong TODO in patch 6 which implied that AES CBC can
> 	  do partial block sizes when it is actually CTS mode that can as
> 	  pointed out my Eric Biggers.
> 
> v4->v5:
> 	- Fixed build warning/error in patch for wrong assignment of const
> 	  pointer as reported by kernel test robot <lkp@intel.com>.
> 	- Rebased to 5.11-rc6.
> v3->v4:
> 	- Fixed the bug where only two bytes of byte_count were getting
> 	  saved and restored instead of all eight bytes. Thanks Bjorn for
> 	  catching this.
> 	- Split patch 3 "Fix regressions found during fuzz testing" into
> 	  6 patches as requested by Bjorn.
> 	- Dropped crypto from all subject headers.
> 	- Rebased to 5.11-rc5
> v2->v3:
>         - Made the comparison between keys to check if any two keys are
>           same for triple des algorithms constant-time as per
>           Nym Seddon's suggestion.
>         - Rebased to 5.11-rc4.
> v1->v2:
>         - Introduced custom struct qce_sha_saved_state to store and restore
>           partial sha transformation.
>         - Rebased to 5.11-rc3.
> 
> Thara Gopinath (11):
>   crypto: qce: sha: Restore/save ahash state with custom struct in
>     export/import
>   crypto: qce: sha: Hold back a block of data to be transferred as part
>     of final
>   crypto: qce: skcipher: Return unsupported if key1 and key 2 are same
>     for AES XTS algorithm
>   crypto: qce: skcipher: Return unsupported if any three keys are same
>     for DES3 algorithms
>   crypto: qce: skcipher: Return error for zero length messages
>   crypto: qce: skcipher: Return error for non-blocksize data(ECB/CBC
>     algorithms)
>   crypto: qce: skcipher: Set ivsize to 0 for ecb(aes)
> *** BLURB HERE ***
> 
> Thara Gopinath (11):
>   crypto: qce: sha: Restore/save ahash state with custom struct in
>     export/import
>   crypto: qce: sha: Hold back a block of data to be transferred as part
>     of final
>   crypto: qce: skcipher: Return unsupported if key1 and key 2 are same
>     for AES XTS algorithm
>   crypto: qce: skcipher: Return unsupported if any three keys are same
>     for DES3 algorithms
>   crypto: qce: skcipher: Return error for zero length messages
>   crypto: qce: skcipher: Return error for non-blocksize data(ECB/CBC
>     algorithms)
>   crypto: qce: skcipher: Set ivsize to 0 for ecb(aes)
>   crypto: qce: skcipher: Improve the conditions for requesting AES
>     fallback cipher
>   crypto: qce: common: Set data unit size to message length for AES XTS
>     transformation
>   crypto: qce: Remover src_tbl from qce_cipher_reqctx
>   crypto: qce: Remove totallen and offset in qce_start
> 
>  drivers/crypto/qce/cipher.h   |   1 -
>  drivers/crypto/qce/common.c   |  25 +++---
>  drivers/crypto/qce/common.h   |   3 +-
>  drivers/crypto/qce/sha.c      | 143 +++++++++++++---------------------
>  drivers/crypto/qce/skcipher.c |  69 +++++++++++++---
>  5 files changed, 126 insertions(+), 115 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
