From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] crypto: cavium/nitrox - Added support for SR-IOV
 configuration.
Date: Fri, 14 Sep 2018 14:12:18 +0800
Message-ID: <20180914061218.uhtza76d72cwpipj@gondor.apana.org.au>
References: <1536303678-3674-1-git-send-email-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgadam@cavium.com
To: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1536303678-3674-1-git-send-email-Jampala.Srikanth@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 07, 2018 at 12:31:18PM +0530, Srikanth Jampala wrote:
> Added support to configure SR-IOV using sysfs interface.
> Supported VF modes are 16, 32, 64 and 128. Grouped the
> hardware configuration functions to "nitrox_hal.h" file.
> Changed driver version to "1.1".
> 
> Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
> Reviewed-by: Gadam Sreerama <sgadam@cavium.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
