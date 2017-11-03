From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat: remove unused and redundant pointer vf_info
Date: Fri, 3 Nov 2017 22:23:21 +0800
Message-ID: <20171103142321.GG9011@gondor.apana.org.au>
References: <20171012170456.32505-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Ahsan Atta <ahsan.atta@intel.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171012170456.32505-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 12, 2017 at 06:04:56PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer vf_info is being assigned but never read, it is redundant
> and therefore can be removed.
> 
> Cleans up clang warning: Value stored to 'vf_info' is never read
> 
> Fixes: ed8ccaef52fa ("crypto: qat - Add support for SRIOV")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
