From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: nx: 842: constify vio_device_id
Date: Fri, 22 Sep 2017 18:12:56 +0800
Message-ID: <20170922101255.GC16270@gondor.apana.org.au>
References: <35e1702104da09dee65dd407bde06b8cb31f6483.1502974810.git.arvind.yadav.cs@gmail.com>
 <75815c8052e9a456ac887965cc50945aedb877e0.1502974810.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, benh@kernel.crashing.org,
        leosilva@linux.vnet.ibm.com, pfsmorigo@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <75815c8052e9a456ac887965cc50945aedb877e0.1502974810.git.arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 17, 2017 at 06:44:11PM +0530, Arvind Yadav wrote:
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
