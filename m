From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v5 4/4] dt-bindings: Add DT bindings document for
 Broadcom SBA RAID driver
Date: Mon, 27 Feb 2017 08:47:38 -0600
Message-ID: <20170227144738.szmppcir6bvav4bb@rob-hp-laptop>
References: <1487227695-965-1-git-send-email-anup.patel@broadcom.com>
 <1487227695-965-5-git-send-email-anup.patel@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Scott Branden <sbranden@broadcom.com>, Vinod Koul <vinod.koul@intel.com>,
 Ray Jui <rjui@broadcom.com>, Jassi Brar <jassisinghbrar@gmail.com>,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 Jon Mason <jonmason@broadcom.com>, bcm-kernel-feedback-list@broadcom.com,
 linux-crypto@vger.kernel.org, Rob Rice <rob.rice@broadcom.com>,
 dmaengine@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
 "David S . Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
To: Anup Patel <anup.patel@broadcom.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1487227695-965-5-git-send-email-anup.patel@broadcom.com>
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

On Thu, Feb 16, 2017 at 12:18:15PM +0530, Anup Patel wrote:
> This patch adds the DT bindings document for newly added Broadcom
> SBA RAID driver.
> 
> Signed-off-by: Anup Patel <anup.patel@broadcom.com>
> Reviewed-by: Ray Jui <ray.jui@broadcom.com>
> Reviewed-by: Scott Branden <scott.branden@broadcom.com>
> ---
>  .../devicetree/bindings/dma/brcm,iproc-sba.txt     | 29 ++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/brcm,iproc-sba.txt

Acked-by: Rob Herring <robh@kernel.org>
