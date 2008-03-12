From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH -mm crypto] AES: remove crypto_fl_tab and replace
	crypto_il_tab with isb_tab
Date: Wed, 12 Mar 2008 10:22:26 +0100
Message-ID: <20080312092226.GA32150@Chamillionaire.breakpoint.cc>
References: <1205210576.3676.7.camel@caritas-dev.intel.com>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"Adam J. Richter" <adam@yggdrasil.com>,
	Alexander Kjeldaas <astor@fast.no>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: "Huang, Ying" <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:54608 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130AbYCLJWc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Mar 2008 05:22:32 -0400
Content-Disposition: inline
In-Reply-To: <1205210576.3676.7.camel@caritas-dev.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Huang, Ying | 2008-03-11 12:42:56 [+0800]:

>Remove crypto_fl_tab from aes implementation. Because mix_col(1,n) = n,
>all information in cryto_fl_tab is in crypto_ft_tab too.
>crypto_il_tab is replaced by isb_tab, the byte shift is done
>during decryption.
nice.

>This patch is only for generic C implementation. If this kind of idea
>is desired, I will implement the ASM version for x86.
Could you please run 
| modprobe tcrypt mode=200
with and without the patch?

Sebastian
