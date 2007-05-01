From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 4/5] jffs2: Allow selection of compression mode via a
 sysfs attribute
Date: Tue, 1 May 2007 13:08:11 -0700
Message-ID: <20070501130811.5c9c9f7d.randy.dunlap@oracle.com>
References: <1178030839.5883.56.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	herbert@gondor.apana.org.au,
	linux-mtd <linux-mtd@lists.infradead.org>,
	linux-crypto@vger.kernel.org
To: Richard Purdie <rpurdie@openedhand.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:44224 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbXEAUGn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 May 2007 16:06:43 -0400
In-Reply-To: <1178030839.5883.56.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 01 May 2007 15:47:19 +0100 Richard Purdie wrote:

> Allow selection of the compression mode for jffs2 via a sysfs
> attribute. This establishes a sysfs presence for jffs2 through
> which other compression options could easily be exported too.
> 
> Signed-off-by: Richard Purdie <rpurdie@openedhand.com>
> ---
>  fs/Kconfig       |    9 ++++++++
>  fs/jffs2/compr.c |   41 ++++++++++++++++++++++++++++++++++++
>  fs/jffs2/compr.h |    6 +++++
>  fs/jffs2/super.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 117 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 328a62f..9da136b 100644
> diff --git a/fs/jffs2/compr.c b/fs/jffs2/compr.c
> index fdb0efd..8c57dc7 100644
> --- a/fs/jffs2/compr.c
> +++ b/fs/jffs2/compr.c
> @@ -11,6 +11,7 @@
>   *
>   */
>  
> +#include <linux/kobject.h>

is that used/needed in this source file?

>  #include "compr.h"
>  
>  static DEFINE_SPINLOCK(jffs2_compressor_list_lock);
> @@ -296,6 +297,46 @@ int jffs2_unregister_compressor(struct jffs2_compressor *comp)
>          return 0;
>  }
>  
> +#ifdef CONFIG_JFFS2_SYSFS
> +
> +char *jffs2_get_compression_mode_name(void)
> +{
> +        switch (jffs2_compression_mode) {
> +        case JFFS2_COMPR_MODE_NONE:
> +                return "none";
> +        case JFFS2_COMPR_MODE_PRIORITY:
> +                return "priority";
> +        case JFFS2_COMPR_MODE_SIZE:
> +                return "size";
> +	case JFFS2_COMPR_MODE_FAVOURLZO:
> +		return "favourlzo";
> +        }
> +        return "unkown";

Lots of whitespace damage above (needs tabs).

> +}
> +
> +int jffs2_set_compression_mode_name(const char *name)
> +{
> +        if (!strncmp("none", name, 4)) {
> +                jffs2_compression_mode = JFFS2_COMPR_MODE_NONE;
> +                return 0;
> +        }
> +        if (!strncmp("priority", name, 8)) {
> +                jffs2_compression_mode = JFFS2_COMPR_MODE_PRIORITY;
> +                return 0;
> +        }
> +        if (!strncmp("size", name, 4)) {
> +                jffs2_compression_mode = JFFS2_COMPR_MODE_SIZE;
> +                return 0;
> +        }
> +	if (!strncmp("favourlzo", name, 9)) {
> +		jffs2_compression_mode = JFFS2_COMPR_MODE_FAVOURLZO;
> +		return 0;
> +	}
> +        return -EINVAL;

Lots of tabs needed above also.

> +}
> +
> +#endif
> +
>  void jffs2_free_comprbuf(unsigned char *comprbuf, unsigned char *orig)
>  {
>          if (orig != comprbuf)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
