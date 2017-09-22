From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1] crypto: mediatek - Add empty messages check in GCM
 mode
Date: Fri, 22 Sep 2017 18:13:56 +0800
Message-ID: <20170922101356.GH16270@gondor.apana.org.au>
References: <efa7d94ce1b5b63f192d05e7c0a1c74b6b48ec38.1503387350.git.ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
To: Ryder Lee <ryder.lee@mediatek.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <efa7d94ce1b5b63f192d05e7c0a1c74b6b48ec38.1503387350.git.ryder.lee@mediatek.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 22, 2017 at 03:53:39PM +0800, Ryder Lee wrote:
> Currently, empty messages are not supported in GCM mode, hence add
> a check to prevent producing incorrect results.
> 
> Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
