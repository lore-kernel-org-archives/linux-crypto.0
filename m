From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/8] update mediatek crypto driver
Date: Mon, 23 Jan 2017 23:01:35 +0800
Message-ID: <20170123150135.GH20806@gondor.apana.org.au>
References: <1484890875-57105-1-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Ryder Lee <ryder.lee@mediatek.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484890875-57105-1-git-send-email-ryder.lee@mediatek.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jan 20, 2017 at 01:41:07PM +0800, Ryder Lee wrote:
> Hi,
> 
> This series of patches is a global rework of the mtk driver.
> Fix bug - incomplete DMA data transfer when SG buffer dst.len != src.len
> 
> It also updates some part of the code to make them more generic. For
> instance the crypto request queue management supports both async block
> cipher and AEAD requests, which allows us to add support the the GCM mode.
> GMAC mode is not supported yet.
> 
> Current implementation was validated using the tcrypt
> module running modes:
> - 10: ecb(aes), cbc(aes), ctr(aes), rfc3686(ctr(aes))
> - 35: gcm(aes)
> - 2,6,11,12: sha1, sha2 family
> 
> tcrypt speed test was run with modes:
> - 211: rfc4106(gcm(aes)), gcm(aes)
> - 500: ecb(aes), cbc(aes), ctr(aes), rfc3686(ctr(aes))
> - 403 ~ 406: sha1, sha2 family
> 
> IxChariot multiple pairs throughput 24 hours test:
> - IPSec VPN
> - MACSec
> 
> Ryder Lee (8):
>   crypto: mediatek - move HW control data to transformation context
>   crypto: mediatek - fix incorrect data transfer result
>   crypto: mediatek - make crypto request queue management more generic
>   crypto: mediatek - rework crypto request completion
>   crypto: mediatek - regroup functions by usage
>   crypto: mediatek - fix typo and indentation
>   crypto: mediatek - add support to CTR mode
>   crypto: mediatek - add support to GCM mode

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
