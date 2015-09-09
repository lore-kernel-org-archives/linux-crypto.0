From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 5/8] lib/scatterlist: Add sg_len helper
Date: Wed, 09 Sep 2015 18:27:06 +0200
Message-ID: <2806088.jJiH2yOvUX@tauon.atsec.com>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1> <20150909161526.2828.55032.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33819 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbbIIQ1L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 12:27:11 -0400
In-Reply-To: <20150909161526.2828.55032.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 9. September 2015, 09:15:26 schrieb Tadeusz Struk:

Hi Tadeusz,

>Add sg_len function which returns the total number of bytes in sg.
>
>Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
>---
> include/linux/scatterlist.h |    1 +
> lib/scatterlist.c           |   18 ++++++++++++++++++
> 2 files changed, 19 insertions(+)
>
>diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
>index 9b1ef0c..7c82fc1 100644
>--- a/include/linux/scatterlist.h
>+++ b/include/linux/scatterlist.h
>@@ -246,6 +246,7 @@ static inline void *sg_virt(struct scatterlist *sg)
> }
>
> int sg_nents(struct scatterlist *sg);
>+int sg_len(struct scatterlist *sg);
> int sg_nents_for_len(struct scatterlist *sg, u64 len);
> struct scatterlist *sg_next(struct scatterlist *);
> struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
>diff --git a/lib/scatterlist.c b/lib/scatterlist.c
>index d105a9f..71324bb 100644
>--- a/lib/scatterlist.c
>+++ b/lib/scatterlist.c
>@@ -57,6 +57,24 @@ int sg_nents(struct scatterlist *sg)
> EXPORT_SYMBOL(sg_nents);
>
> /**
>+  * sg_len - return total size of bytes in the scatterlist
>+  * @sg:         The scatterlist
>+  *
>+  * Description:
>+  * Allows to know how the total size of bytes in sg, taking into acount
>+  * chaining as well
>+  **/
>+int sg_len(struct scatterlist *sg)

unsigned int?
>+{
>+	int len;
>+
>+	for (len = 0; sg; sg = sg_next(sg))
>+		len += sg->length;
>+	return len;
>+}
>+EXPORT_SYMBOL(sg_len);
>+
>+/**
>  * sg_nents_for_len - return total count of entries in scatterlist
>  *                    needed to satisfy the supplied length
>  * @sg:		The scatterlist
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan
