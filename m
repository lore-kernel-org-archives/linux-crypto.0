From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 02/28] crypto: omap-sham: Don't idle/start SHA device
 between Encrypt operations
Date: Tue, 7 Jun 2016 18:08:37 +0800
Message-ID: <20160607100837.GA30875@gondor.apana.org.au>
References: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
 <1464771389-10640-3-git-send-email-t-kristo@ti.com>
 <574EB091.6040001@ti.com> <574F69D8.1010809@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Grygorii Strashko <grygorii.strashko@ti.com>, tony@atomide.com,
 Tero Kristo <t-kristo@ti.com>, lokeshvutla@ti.com,
 linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org, davem@davemloft.net,
 linux-arm-kernel@lists.infradead.org
To: Dave Gerlach <d-gerlach@ti.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <574F69D8.1010809@ti.com>
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

On Wed, Jun 01, 2016 at 06:03:52PM -0500, Dave Gerlach wrote:
> On 06/01/2016 04:53 AM, Grygorii Strashko wrote:
> >On 06/01/2016 11:56 AM, Tero Kristo wrote:
> >>From: Lokesh Vutla <lokeshvutla@ti.com>
> >>
> >>Calling runtime PM API for every block causes serious perf hit to
> >>crypto operations that are done on a long buffer.
> >>As crypto is performed on a page boundary, encrypting large buffers can
> >>cause a series of crypto operations divided by page. The runtime PM API
> >>is also called those many times.
> >>
> >>We call runtime_pm_get_sync only at beginning on the session (cra_init)
> >>and runtime_pm_put at the end. This result in upto a 50% speedup.
> >>This doesn't make the driver to keep the system awake as runtime get/put
> >>is only called during a crypto session which completes usually quickly.
> >>
> >>Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> >>Signed-off-by: Tero Kristo <t-kristo@ti.com>
> >>---
> >>  drivers/crypto/omap-sham.c | 27 +++++++++++++++++----------
> >>  1 file changed, 17 insertions(+), 10 deletions(-)
> >>
> >>diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> >>index 6eefaa2..bd0258f 100644
> >>--- a/drivers/crypto/omap-sham.c
> >>+++ b/drivers/crypto/omap-sham.c
> >>@@ -360,14 +360,6 @@ static void omap_sham_copy_ready_hash(struct
> >>ahash_request *req)
> >>
> >>  static int omap_sham_hw_init(struct omap_sham_dev *dd)
> >>  {
> >>-    int err;
> >>-
> >>-    err = pm_runtime_get_sync(dd->dev);
> >>-    if (err < 0) {
> >>-        dev_err(dd->dev, "failed to get sync: %d\n", err);
> >>-        return err;
> >>-    }
> >>-
> 
> Would it be worth it to investigate a pm_runtime autosuspend
> approach rather than knocking runtime PM out here completely? I am
> not clear if the overhead is coming from the pm_runtime calls
> themselves or the actual idling of the IP, but if it's the idling of
> the IP causing the slowdown, with a large enough autosuspend_delay
> we don't actually sleep between each block but after a long enough
> period of idle time we would actually suspend.

Indeed, I think this patch is bogus.  cra_init is associated
with the tfm object which is usually long-lived.  So doing power
management there makes no sense.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
