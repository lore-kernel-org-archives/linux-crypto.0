From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH net-next] cryptd: Add cryptd_max_cpu_qlen module parameter
Date: Wed, 29 Nov 2017 17:39:11 +1100
Message-ID: <20171129063911.GN21575@gondor.apana.org.au>
References: <20171122050817.21385-1-jmaxwell37@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmaxwell@redhat.com
To: Jon Maxwell <jmaxwell37@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:40778 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752184AbdK2Gjg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 01:39:36 -0500
Content-Disposition: inline
In-Reply-To: <20171122050817.21385-1-jmaxwell37@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 22, 2017 at 04:08:17PM +1100, Jon Maxwell wrote:
> Make the cryptd queue length configurable. We recently had customer where this 
> needed to be tuned to accommodate the aesni_intel module and prevent packet 
> drop.
> 
> Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
