From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat: adf_aer: Replace GFP_ATOMIC with GFP_KERNEL
 in adf_dev_aer_schedule_reset()
Date: Fri, 3 Aug 2018 21:58:04 +0800
Message-ID: <20180803135804.4snrn45ayf7bvyj7@gondor.apana.org.au>
References: <20180723082744.25409-1-baijiaju1990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: giovanni.cabiddu@intel.com, davem@davemloft.net,
        qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180723082744.25409-1-baijiaju1990@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 23, 2018 at 04:27:44PM +0800, Jia-Ju Bai wrote:
> adf_dev_aer_schedule_reset() is never called in atomic context, as it
> calls wait_for_completion_timeout().
> 
> adf_dev_aer_schedule_reset() calls kzalloc() with GFP_ATOMIC,
> which is not necessary.
> GFP_ATOMIC can be replaced with GFP_KERNEL.
> 
> This is found by a static analysis tool named DCNS written by myself.
> I also manually check the kernel code before reporting it.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
