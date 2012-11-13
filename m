From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 5/9] kernel: padata : use __this_cpu_read per-cpu
 helper
Date: Tue, 13 Nov 2012 15:36:27 +0800
Message-ID: <20121113073627.GA18882@gondor.apana.org.au>
References: <50A1A7E1.3030401@gmail.com>
 <20121113072703.GH22290@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shan Wei <shanwei88@gmail.com>,
	Kernel-Maillist <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, cl@linux-foundation.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:53043 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753023Ab2KMHgd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Nov 2012 02:36:33 -0500
Content-Disposition: inline
In-Reply-To: <20121113072703.GH22290@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 13, 2012 at 08:27:03AM +0100, Steffen Klassert wrote:
> On Tue, Nov 13, 2012 at 09:52:33AM +0800, Shan Wei wrote:
> > From: Shan Wei <davidshan@tencent.com>
> > 
> > For bottom halves off, __this_cpu_read is better.
> > 
> > Signed-off-by: Shan Wei <davidshan@tencent.com>
> > Reviewed-by: Christoph Lameter <cl@linux.com>
> 
> Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
> 
> Herbert, are you going to take this one?

Thanks Steffen, I'll apply his patch.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
