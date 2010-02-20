From: "Wang, Shane" <shane.wang@intel.com>
Subject: RE: [PATCH] to fix vmac test fails on s390
Date: Sat, 20 Feb 2010 14:29:04 +0800
Message-ID: <6CADD16F56BC954D8E28F3836FA7ED71282AC1E1E9@shzsmsx501.ccr.corp.intel.com>
References: <1263477930.5880.22.camel@bender>
 <20100117110546.GA32690@gondor.apana.org.au>
 <6CADD16F56BC954D8E28F3836FA7ED711EB163307A@shzsmsx501.ccr.corp.intel.com>
 <20100216123938.GA313@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Jan Glauber <jang@linux.vnet.ibm.com>,
	"Cihula, Joseph" <joseph.cihula@intel.com>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14031 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab0BTGa0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Feb 2010 01:30:26 -0500
In-Reply-To: <20100216123938.GA313@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> Sorry but you can't fix it like this.  Your hash output must be
> invariant with respect to endianness.
> 
> That means, whether I run it on a big-endian machine or a little-
> endian one it should produce the same output.
> 
> Otherwise this hash will be totally useless as soon as you get
> onto the network.
> 
> Cheers,

OK, I understand.
The problem is the VMAC result is an integer instead of a string.
I also tested the original VMAC algorithm (w/ Jan), since I ported from it.
It proved the above.

In this case, should I change the original algorithm to produce an invariant string output?

Thanks.
Shane
