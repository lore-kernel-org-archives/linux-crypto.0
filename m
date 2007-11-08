From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH 3/3] [crypto] AES x86_64, remove setkey
Date: Thu, 8 Nov 2007 15:31:12 +0100
Message-ID: <20071108143112.GD25676@Chamillionaire.breakpoint.cc>
References: <1193585742-26284-1-git-send-email-linux-crypto@ml.breakpoint.cc> <E1ImAGK-0006r6-Nw@Chamillionaire.breakpoint.cc> <20071108132633.GB17186@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:56229 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752999AbXKHObN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Nov 2007 09:31:13 -0500
Content-Disposition: inline
In-Reply-To: <20071108132633.GB17186@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-11-08 21:26:33 [+0800]:

>On Sun, Oct 28, 2007 at 01:30:09PM +0100, Sebastian Siewior wrote:
>> 
>> The setkey() function can be shared with the generic algorithm.
>> 
>> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
>
>Beautiful.  All applied.  Thanks Sebastian!
thx. There is also one for i586 (if you are in merge mode :))

Sebastian
