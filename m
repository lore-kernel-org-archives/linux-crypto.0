From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hw_random: Remove check for max less than 4 bytes
Date: Wed, 31 Aug 2016 23:18:52 +0800
Message-ID: <20160831151852.GE28366@gondor.apana.org.au>
References: <1472236324-7067-1-git-send-email-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1472236324-7067-1-git-send-email-prasannatsmkumar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Aug 27, 2016 at 12:02:04AM +0530, PrasannaKumar Muralidharan wrote:
> HW RNG core never asks for data less than 4 bytes. The check whether max
> is less than 4 bytes is unnecessary. Remove the check.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
