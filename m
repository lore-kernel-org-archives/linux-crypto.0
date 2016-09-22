From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: omap - Only fail if pm_runtime_get_sync returns < 0
Date: Thu, 22 Sep 2016 18:46:24 +0800
Message-ID: <20160922104624.GK5884@gondor.apana.org.au>
References: <20160920152540.3004-1-d-gerlach@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Nishanth Menon <nm@ti.com>, Deepak Saxena <dsaxena@plexity.net>,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 Matt Mackall <mpm@selenic.com>, linux-omap@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
To: Dave Gerlach <d-gerlach@ti.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20160920152540.3004-1-d-gerlach@ti.com>
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

On Tue, Sep 20, 2016 at 10:25:40AM -0500, Dave Gerlach wrote:
> Currently omap-rng checks the return value of pm_runtime_get_sync and
> reports failure if anything is returned, however it should be checking
> if ret < 0 as pm_runtime_get_sync return 0 on success but also can return
> 1 if the device was already active which is not a failure case. Only
> values < 0 are actual failures.
> 
> Fixes: 61dc0a446e5d ("hwrng: omap - Fix assumption that runtime_get_sync will always succeed")
> Signed-off-by: Dave Gerlach <d-gerlach@ti.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
