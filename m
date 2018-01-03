From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] staging: ccree: mark debug_regs[] as static
Date: Wed, 3 Jan 2018 12:10:14 +0200
Message-ID: <CAOtvUMf0AnkTqHss3ANsOqHMDX2fiZNy0oVWgi+R7VPdS+v3Tw@mail.gmail.com>
References: <20180103092628.1930457-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180103092628.1930457-1-arnd@arndb.de>
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

Hi

On Wed, Jan 3, 2018 at 11:26 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> The global array clashes with an existing symbol of the same name:
>
> drivers/staging/ccree/cc_debugfs.o:(.data+0x0): multiple definition of `debug_regs'
> drivers/mmc/host/s3cmci.o:(.data+0x70): first defined here
>
> We should fix both, this one addresses the ccree driver by removing
> the symbol from the global namespace.
>
> Fixes: 9bdd203b4dc8 ("s3cmci: add debugfs support for examining driver and hardware state")
> Fixes: b3ec9a6736f2 ("staging: ccree: staging: ccree: replace sysfs by debugfs interface")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/staging/ccree/cc_debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/ccree/cc_debugfs.c b/drivers/staging/ccree/cc_debugfs.c
> index 7cd33957fdc6..662fa07af832 100644
> --- a/drivers/staging/ccree/cc_debugfs.c
> +++ b/drivers/staging/ccree/cc_debugfs.c
> @@ -37,7 +37,7 @@ struct cc_debugfs_ctx {
>   */
>  static struct dentry *cc_debugfs_dir;
>
> -struct debugfs_reg32 debug_regs[] = {
> +static struct debugfs_reg32 debug_regs[] = {
>         CC_DEBUG_REG(HOST_SIGNATURE),
>         CC_DEBUG_REG(HOST_IRR),
>         CC_DEBUG_REG(HOST_POWER_DOWN_EN),
> --
> 2.9.0
>

Thank you Arnd.

I ran into this issue myself via a sparse check (I did not have s3cmci
compiled in) and was sure I sent a fix for it but now I see I did not.

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
