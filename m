From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 3/4] crypto: axis: add ARTPEC-6/7 crypto accelerator
 driver
Date: Thu, 3 Aug 2017 14:26:33 +0800
Message-ID: <20170803062633.GP12039@gondor.apana.org.au>
References: <cover.1500879613.git.larper@axis.com>
 <f980a14f9f07e47575ecf71b3e3be6ffc1073a33.1500879613.git.larper@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars Persson <larper@axis.com>
To: Lars Persson <lars.persson@axis.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f980a14f9f07e47575ecf71b3e3be6ffc1073a33.1500879613.git.larper@axis.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 24, 2017 at 09:07:31AM +0200, Lars Persson wrote:
> This is an asynchronous crypto API driver for the accelerator present
> in the ARTPEC-6 and -7 SoCs from Axis Communications AB.
> 
> The driver supports AES in ECB/CTR/CBC/XTS/GCM modes and SHA1/2 hash
> standards.
> 
> Signed-off-by: Lars Persson <larper@axis.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
