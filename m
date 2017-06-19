From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/2] crypto: engine - replace pr_xxx by dev_xxx
Date: Mon, 19 Jun 2017 14:46:52 +0800
Message-ID: <20170619064652.GG13800@gondor.apana.org.au>
References: <20170606134417.18850-1-clabbe.montjoie@gmail.com>
 <20170606134417.18850-2-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170606134417.18850-2-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 06, 2017 at 03:44:16PM +0200, Corentin Labbe wrote:
> By adding a struct device *dev to struct engine, we could store the
> device used at register time and so use all dev_xxx functions instead of
> pr_xxx.
> 
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
