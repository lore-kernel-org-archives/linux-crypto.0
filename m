From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v1 2/2] dt-bindings: crypto: remove mediatek ethif clock
Date: Wed, 7 Jun 2017 16:38:17 -0500
Message-ID: <20170607213817.nr3n6vdrchspcc5i@rob-hp-laptop>
References: <1496284222-12560-1-git-send-email-ryder.lee@mediatek.com>
 <1496284222-12560-3-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
To: Ryder Lee <ryder.lee@mediatek.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1496284222-12560-3-git-send-email-ryder.lee@mediatek.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 01, 2017 at 10:30:22AM +0800, Ryder Lee wrote:
> This patch removes the parent clock 'ethif' in bindings, since we don't
> need to control the parent of a clock in current clock framework.
> 
> Moreover, the clocks are get by name in the driver, thus this change
> does not break backwards compatibility.
> 
> Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
> Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>  Documentation/devicetree/bindings/crypto/mediatek-crypto.txt | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)

Acked-by: Rob Herring <robh@kernel.org>
