From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/4] crypto: s5p-sss: Fix and add aes-ctr support
Date: Fri, 28 Sep 2018 13:07:43 +0800
Message-ID: <20180928050743.7mqgbs2femmacq5o@gondor.apana.org.au>
References: <CGME20180917151002eucas1p27689f043367e1bc64bf63bc402dffcdd@eucas1p2.samsung.com>
 <20180917151002eucas1p27689f043367e1bc64bf63bc402dffcdd~VOId3-CTL2961529615eucas1p2I@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Christoph Manszewski <c.manszewski@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180917151002eucas1p27689f043367e1bc64bf63bc402dffcdd~VOId3-CTL2961529615eucas1p2I@eucas1p2.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 17, 2018 at 05:09:26PM +0200, Christoph Manszewski wrote:
> Hello,
> 
> This patch series adds aes-ctr support in s5p-sss.c driver. Additionally it
> it provides a fix, and a minor code cleanup.
> 
> Patch 1 contains a simple fix, of a possible race condition.
> Patches 2-3 are code cleanup patches.
> Patch 4 adds support for aes-ctr block cipher mode of operation.
> 
> Regards,
> Chris
> 
> Changes in v2:
> - pass dev->req directly to s5p_aes_complete in s5p_aes_interrupt
> non-error path,
> - move req asignment in s5p_aes_interrupt before if statement,
> - change commit message and subject for patch 2/4,
> - remove empty lines and add rationale in commit message for 
> patch 3/4,
> 
> Christoph Manszewski (4):
>   crypto: s5p-sss: Fix race in error handling
>   crypto: s5p-sss: Fix Fix argument list alignment
>   crypto: s5p-sss: Minor code cleanup
>   crypto: s5p-sss: Add aes-ctr support
> 
>  drivers/crypto/s5p-sss.c | 113 +++++++++++++++++++++++++++--------------------
>  1 file changed, 65 insertions(+), 48 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
