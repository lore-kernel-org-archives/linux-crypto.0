From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: pseries: constify vio_device_id
Date: Fri, 22 Sep 2017 18:13:02 +0800
Message-ID: <20170922101302.GD16270@gondor.apana.org.au>
References: <ba527ef090617a90e6909bab75b09e1c1ac8be68.1502990171.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, mpe@ellerman.id.au, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ba527ef090617a90e6909bab75b09e1c1ac8be68.1502990171.git.arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 17, 2017 at 11:06:23PM +0530, Arvind Yadav wrote:
> vio_device_id are not supposed to change at runtime. All functions
> working with vio_device_id provided by <asm/vio.h> work with
> const vio_device_id. So mark the non-const structs as const.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
