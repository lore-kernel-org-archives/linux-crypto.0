From: Daniel Walker <dwalker@fifo99.com>
Subject: Re: [PATCH -v3] crypto: Add PCLMULQDQ accelerated GHASH
 implementation
Date: Tue, 15 Sep 2009 07:42:11 -0700
Message-ID: <1253025731.11643.333.camel@desktop>
References: <1252993367.15717.340.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fifo99.com ([67.223.236.141]:48065 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443AbZIOOlS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Sep 2009 10:41:18 -0400
In-Reply-To: <1252993367.15717.340.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2009-09-15 at 13:42 +0800, Huang Ying wrote:
> Hi, Herbert,
> 
> The dependency to irq_fpu_usable has been merged by linus' tree.
> 
> Best Regards,
> Huang Ying
> -------------------------------------------------------------------------->
> PCLMULQDQ is used to accelerate the most time-consuming part of GHASH,
> carry-less multiplication. More information about PCLMULQDQ can be
> found at:
> 
> http://software.intel.com/en-us/articles/carry-less-multiplication-and-its-usage-for-computing-the-gcm-mode/
> 
> Because PCLMULQDQ changes XMM state, its usage must be enclosed with
> kernel_fpu_begin/end, which can be used only in process context, the
> acceleration is implemented as crypto_ahash. That is, request in soft
> IRQ context will be defered to the cryptd kernel thread.
> 
> v3:
>  - Revise GHASH implementation, performance increase about 2x.


You have three style issues in this patch, for instance you shouldn't
set values inside if() statements .. If you run checkpatch on this it
will tell you all the style problems. Could you run this through
checkpatch and fix any errors it's find ?

Daniel

