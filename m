From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sahara: constify platform_device_id
Date: Tue, 22 Aug 2017 15:57:51 +0800
Message-ID: <20170822075751.GE6269@gondor.apana.org.au>
References: <f8f2d2b5610c724bf83d31a47fe3b017e047424a.1502614870.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f8f2d2b5610c724bf83d31a47fe3b017e047424a.1502614870.git.arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Aug 13, 2017 at 02:34:00PM +0530, Arvind Yadav wrote:
> platform_device_id are not supposed to change at runtime. All functions
> working with platform_device_id provided by <linux/platform_device.h>
> work with const platform_device_id. So mark the non-const structs as
> const.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
