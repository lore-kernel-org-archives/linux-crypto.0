From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH -mm crypto] AES: remove crypto_fl_tab and replace
	crypto_il_tab with isb_tab
Date: Wed, 26 Mar 2008 00:33:56 +0100
Message-ID: <20080325233356.GA2577@Chamillionaire.breakpoint.cc>
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
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:56725 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945AbYCYXeM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Mar 2008 19:34:12 -0400
Content-Disposition: inline
In-Reply-To: <1205210576.3676.7.camel@caritas-dev.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Huang, Ying | 2008-03-11 12:42:56 [+0800]:

>These changes reduce the encryption cache footprint to 50% and
>decryption cache footprint to 53.1%. The code size is increased
>slightly. On my Intel CORE micro-architecture CPU, there is almost no
>performance penalty.
According to the tcrypt numbers you've posted it is getting "slightly"
slower on encryption/decryption of 64+ bytes. How did you measure your
"almost no performance penalty"?

 Sebastian
