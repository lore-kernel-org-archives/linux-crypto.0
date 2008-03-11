From: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH -mm crypto] AES: remove crypto_fl_tab and replace
	crypto_il_tab with isb_tab
Date: Tue, 11 Mar 2008 14:47:21 +0800
Message-ID: <1205218041.8393.11.camel@caritas-dev.intel.com>
References: <1205210576.3676.7.camel@caritas-dev.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Adam J. Richter" <adam@yggdrasil.com>,
	Alexander Kjeldaas <astor@fast.no>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:8155 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947AbYCKGqJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Mar 2008 02:46:09 -0400
In-Reply-To: <1205210576.3676.7.camel@caritas-dev.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2008-03-11 at 12:42 +0800, Huang, Ying wrote:
> Remove crypto_fl_tab from aes implementation. Because mix_col(1,n) = n,
> all information in cryto_fl_tab is in crypto_ft_tab too.
> crypto_il_tab is replaced by isb_tab, the byte shift is done
> during decryption.
> 
> These changes reduce the encryption cache footprint to 50% and
> decryption cache footprint to 53.1%. The code size is increased
> slightly. On my Intel CORE micro-architecture CPU, there is almost no
> performance penalty.

Similar optimization is used by OpenSSL too. So I think this is
reasonable.

Best Regards,
Huang Ying


