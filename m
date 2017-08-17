From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: ccp: use dma_mapping_error to check map error
Date: Thu, 17 Aug 2017 17:00:36 +0800
Message-ID: <20170817090036.GD25646@gondor.apana.org.au>
References: <1502199767-2578-1-git-send-email-bianpan2016@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pan Bian <bianpan2016@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1502199767-2578-1-git-send-email-bianpan2016@163.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 08, 2017 at 09:42:47PM +0800, Pan Bian wrote:
> The return value of dma_map_single() should be checked by
> dma_mapping_error(). However, in function ccp_init_dm_workarea(), its
> return value is checked against NULL, which could result in failures.
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
