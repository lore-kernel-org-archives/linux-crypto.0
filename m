From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ux500: add missing comma
Date: Fri, 5 Apr 2013 21:02:39 +0800
Message-ID: <20130405130239.GA3181@gondor.apana.org.au>
References: <1365163595-21926-1-git-send-email-linus.walleij@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
 Magnus Myrstedt <magnus.p.persson@stericsson.com>,
 Linus Walleij <linus.walleij@linaro.org>, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
To: Linus Walleij <linus.walleij@stericsson.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1365163595-21926-1-git-send-email-linus.walleij@stericsson.com>
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

On Fri, Apr 05, 2013 at 02:06:35PM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Commit 4f31f5b19eb0418a847b989abc9ac22af1991fe2
> "PM / crypto / ux500: Use struct dev_pm_ops for power management"
> add a new line to the driver struct but missed to add a
> trailing comma, causing build errors when crypto is
> selected. This adds the missing comma.
> 
> This was not noticed until now because the crypto block
> is not in the ux500 defconfig. A separate patch will
> be submitted to fix this.
> 
> Cc: <stable@vger.kernel.org> # 3.8.x
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Magnus Myrstedt <magnus.p.persson@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
