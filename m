From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/5] crypto: caampkc - extend RSA private key
 representation
Date: Thu, 18 May 2017 13:25:51 +0800
Message-ID: <20170518052551.GC32485@gondor.apana.org.au>
References: <20170425132639.20178-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Dan Douglass <dan.douglass@nxp.com>,
        Radu Alexe <radu.alexe@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:41866 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754063AbdERF0G (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 May 2017 01:26:06 -0400
Content-Disposition: inline
In-Reply-To: <20170425132639.20178-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 25, 2017 at 04:26:34PM +0300, Horia Geantă wrote:
> This patch set adds support for the second and third RSA private key
> representations and extends caampkc to use the fastest key when all related
> components are present in the private key.
> 
> Additionally a rsa tcrypt test has been added.

Patches 2-5 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
