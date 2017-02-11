From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 0/3] Add Broadcom SPU Crypto Driver
Date: Sat, 11 Feb 2017 18:54:04 +0800
Message-ID: <20170211105404.GF855@gondor.apana.org.au>
References: <1486144534-44887-1-git-send-email-rob.rice@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
To: Rob Rice <rob.rice@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1486144534-44887-1-git-send-email-rob.rice@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Feb 03, 2017 at 12:55:31PM -0500, Rob Rice wrote:
> Changes in v4:
> - Added Rob Herring's Acked-by to patch 1/3 for bindings doc
> - In response to Herbert's comment, in ahash_export() and 
>   ahash_import(), only copy the hash state, not state params
>   related to cipher or aead algos. 
> - Noticed that hmac_offset in iproc_reqctx_s and spu_hash_params
>   wasn't really used. So removed.

Patches 1-2 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
