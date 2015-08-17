From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [cryptodev:master 144/149] DockBook: Warning(include/crypto/aead.h): no structured comments found
Date: Mon, 17 Aug 2015 15:28:51 +0200
Message-ID: <3781548.3X8LGU0KYF@tauon.atsec.com>
References: <201508172126.SON4mfzb%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>, kbuild-all@01.org,
	linux-crypto@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48123 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981AbbHQN25 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Aug 2015 09:28:57 -0400
In-Reply-To: <201508172126.SON4mfzb%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 17. August 2015, 21:14:27 schrieb kbuild test robot:

Hi,

thanks for the report.

>tree:  
>git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
>master head:   dd43c4e92fbb135dcbf02845578db60be56a453a
>commit: b0d955ba4688fcba8112884931aea1f1e6f50f03 [144/149] crypto: aead -
>Remove old AEAD interfaces reproduce: make htmldocs
>
>All warnings (new ones prefixed by >>):
>
>   Warning(include/crypto/aead.h:98): Excess struct/union/enum/typedef member
>'__ctx' description in 'aead_request' Warning(include/crypto/aead.h:149): No
>description found for parameter 'base' Warning(include/crypto/aead.h:98):
>Excess struct/union/enum/typedef member '__ctx' description in
>'aead_request' Warning(include/crypto/aead.h:149): No description found for
>parameter 'base' Warning(include/crypto/aead.h:98): Excess
>struct/union/enum/typedef member '__ctx' description in 'aead_request'
>Warning(include/crypto/aead.h:149): No description found for parameter
>'base' Warning(include/crypto/aead.h:98): Excess struct/union/enum/typedef
>member '__ctx' description in 'aead_request'
>Warning(include/crypto/aead.h:149): No description found for parameter
>'base' Warning(include/crypto/aead.h:98): Excess struct/union/enum/typedef
>member '__ctx' description in 'aead_request'
>Warning(include/crypto/aead.h:149): No description found for parameter
>'base' Warning(include/crypto/aead.h:98): Excess struct/union/enum/typedef
>member '__ctx' description in 'aead_request'
>Warning(include/crypto/aead.h:149): No description found for parameter
>'base' Warning(include/crypto/aead.h:98): Excess struct/union/enum/typedef
>member '__ctx' description in 'aead_request'
>Warning(include/crypto/aead.h:149): No description found for parameter
>'base' Warning(include/crypto/aead.h:98): Excess struct/union/enum/typedef
>member '__ctx' description in 'aead_request'
>Warning(include/crypto/aead.h:149): No description found for parameter
>'base' Warning(include/crypto/aead.h:98): Excess struct/union/enum/typedef
>member '__ctx' description in 'aead_request'
>Warning(include/crypto/aead.h:149): No description found for parameter
>'base' Warning(include/crypto/aead.h:98): Excess struct/union/enum/typedef
>member '__ctx' description in 'aead_request'
>Warning(include/crypto/aead.h:149): No description found for parameter
>'base' Warning(include/crypto/aead.h:98): Excess struct/union/enum/typedef
>member '__ctx' description in 'aead_request'
>Warning(include/crypto/aead.h:149): No description found for parameter
>'base' Warning(include/crypto/aead.h:98): Excess struct/union/enum/typedef
>member '__ctx' description in 'aead_request'
>Warning(include/crypto/aead.h:149): No description found for parameter
>'base' Warning(include/crypto/aead.h:98): Excess struct/union/enum/typedef
>member '__ctx' description in 'aead_request'
>Warning(include/crypto/aead.h:149): No description found for parameter
>'base' Warning(include/crypto/aead.h:98): Excess struct/union/enum/typedef
>member '__ctx' description in 'aead_request'
>Warning(include/crypto/aead.h:149): No description found for parameter
>'base' Warning(include/crypto/aead.h:98): Excess struct/union/enum/typedef
>member '__ctx' description in 'aead_request'
>Warning(include/crypto/aead.h:149): No description found for parameter
>'base' Warning(include/crypto/aead.h:98): Excess struct/union/enum/typedef
>member '__ctx' description in 'aead_request'
>Warning(include/crypto/aead.h:149): No description found for parameter
>'base' Warning(include/crypto/aead.h:98): Excess struct/union/enum/typedef
>member '__ctx' description in 'aead_request'
>Warning(include/crypto/aead.h:149): No description found for parameter
>'base' Warning(include/crypto/aead.h:98): Excess struct/union/enum/typedef
>member '__ctx' description in 'aead_request'
>Warning(include/crypto/aead.h:149): No description found for parameter
>'base' Warning(include/crypto/aead.h:98): Excess struct/union/enum/typedef
>member '__ctx' description in 'aead_request'
>Warning(include/crypto/aead.h:149): No description found for parameter
>'base' Warning(include/crypto/aead.h:98): Excess struct/union/enum/typedef
>member '__ctx' description in 'aead_request'
>Warning(include/crypto/aead.h:149): No description found for parameter
>'base'
>>> Warning(include/crypto/aead.h): no structured comments found

This is an error in the parser tool in scripts/.

I tried to find the issue, but the tool I was not able to. At least this is 
nothing that can be fixed in the documentation.
>
>       Was looking for 'aead_request_set_assoc'.
>   Warning(include/crypto/aead.h:98): Excess struct/union/enum/typedef member
>'__ctx' description in 'aead_request' Warning(include/crypto/aead.h:149): No
>description found for parameter 'base' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning(include/crypto/hash.h:188):
>No description found for parameter 'hash_alg_common))))'
>Warning(include/crypto/hash.h:188): Excess struct/union/enum/typedef member
>'digestsize' description in 'shash_alg' Warning: didn't use docs for
>crypto_rng_generate

This one is kind of true as we do not document hash_alg_common as it is the 
used data structure is documented. Adding another description looks strange to 
me.

Ciao
Stephan
