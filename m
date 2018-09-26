From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 1/2] dt-bindings: crypto: hip07-sec, drop incorrect commas
Date: Wed, 26 Sep 2018 15:36:31 -0500
Message-ID: <20180926203631.GA30812@bogus>
References: <20180912160718.3324-2-Jonathan.Cameron@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
 linux-crypto@vger.kernel.org, xuwei <xuwei5@huawei.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180912160718.3324-2-Jonathan.Cameron@huawei.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 12, 2018 at 05:07:17PM +0100, Jonathan Cameron wrote:
> There should not be a comma in the address used for the instance
> so drop them.
> 
> This is a left over from a review of the final version before
> Herbert Xu picked the series up.
> 
> Reported-by: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Fixes: 8f026dc887fe ("dt-bindings: Add bidnings for Hisilicon SEC crypto accelerators")
> ---
>  .../devicetree/bindings/crypto/hisilicon,hip07-sec.txt          | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied. The dts change can go thru arm-soc.

Rob
