From: Eduardo Valentin <eduval@amazon.com>
Subject: Re: [PATCH] treewide: remove duplicate includes
Date: Mon, 4 Dec 2017 11:21:23 -0800
Message-ID: <20171204192123.GA1463@u40b0340c692b58f6553c.ant.amazon.com>
References: <1512337779-16842-1-git-send-email-pravin.shedge4linux@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-security-module@vger.kernel.org,
 sstabellini@kernel.org, gregkh@linuxfoundation.org, x86@kernel.org,
 ast@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 mcgrof@kernel.org, mhiramat@kernel.org, linux-kselftest@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, namhyung@kernel.org, mchehab@kernel.org,
 shuah@kernel.org, davem@davemloft.net, linux-crypto@vger.kernel.org
To: Pravin Shedge <pravin.shedge4linux@gmail.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1512337779-16842-1-git-send-email-pravin.shedge4linux@gmail.com>
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

Hello,

On Mon, Dec 04, 2017 at 03:19:39AM +0530, Pravin Shedge wrote:
<cut>

> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> index d04ec3b..e09f035 100644
> --- a/drivers/thermal/of-thermal.c
> +++ b/drivers/thermal/of-thermal.c
> @@ -30,7 +30,6 @@
>  #include <linux/err.h>
>  #include <linux/export.h>
>  #include <linux/string.h>
> -#include <linux/thermal.h>
>  
>  #include "thermal_core.h"
>  

No issues with this but,

Please send a separate patch to linux-pm@vger.kernel.org and copy edubezva@gmail.com

thanks,

-- 
All the best,
Eduardo Valentin
