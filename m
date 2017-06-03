From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 02/20] staging: ccree: replace bit shift with BIT macro
Date: Sat, 3 Jun 2017 17:46:10 +0900
Message-ID: <20170603084610.GA13935@kroah.com>
References: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
 <1496314993-30229-3-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1496314993-30229-3-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 01, 2017 at 02:02:52PM +0300, Gilad Ben-Yossef wrote:
> CC_CTX_SIZE was being defined using a hand rolled bit shift operation.
> Replace with use of BIT macro.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  drivers/staging/ccree/cc_crypto_ctx.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This patch didn't apply at all, are you sure you are working against the
correct tree?  I've tried to apply some of this series, but most do not
work at all...

Please rebase against my staging-next branch and resend the ones that do
work.

thanks,

greg k-h
