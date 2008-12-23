From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: alg: cipher: Test 1 failed on encryption for aes-asm
Date: Tue, 23 Dec 2008 14:01:54 +0100
Message-ID: <20081223130154.GA23717@Chamillionaire.breakpoint.cc>
References: <20081219202603.GA31265@lst.de> <20081220032159.GA15615@gondor.apana.org.au> <1230022166.17529.82.camel@yhuang-dev.sh.intel.com>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Christoph Hellwig <hch@lst.de>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:43305 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbYLWNB7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Dec 2008 08:01:59 -0500
Content-Disposition: inline
In-Reply-To: <1230022166.17529.82.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Huang Ying | 2008-12-23 16:49:26 [+0800]:

>If aes_x86_64 and aes_generic are compiled as builtin, the
>initialization order is undetermined. That is, aes_x86_64 may be
>initilized before aes_generic is initilized, but aes_x86_64 depends on
>tables generated in aes_generic initialization code. aes_x86_64 can
>not work before aes_generic is initialized, so that cause register
>time testing failed with following error message:

Couldn't we link arch/x/crypto after crypto ?

Sebastian
