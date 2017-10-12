From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: pr_err() strings should end with newlines
Date: Thu, 12 Oct 2017 23:09:18 +0800
Message-ID: <20171012150918.GA31122@gondor.apana.org.au>
References: <83efca3fa5f581e0d150fa72b4efa38340fb0a31.1506325384.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, mingo@kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <83efca3fa5f581e0d150fa72b4efa38340fb0a31.1506325384.git.arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 25, 2017 at 01:15:00PM +0530, Arvind Yadav wrote:
> pr_err() messages should terminated with a new-line to avoid
> other messages being concatenated onto the end.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
