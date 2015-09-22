From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH  v2 1/2] lib/scatterlist: Add sg_len helper
Date: Tue, 22 Sep 2015 07:52:02 +0200
Message-ID: <1629054.0zdmkST5GO@tauon.atsec.com>
References: <20150921234408.23782.52608.stgit@tstruk-mobl1> <20150921234414.23782.63763.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34145 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbbIVFwG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Sep 2015 01:52:06 -0400
In-Reply-To: <20150921234414.23782.63763.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 21. September 2015, 16:44:14 schrieb Tadeusz Struk:

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
>index 556ec1e..1ca63bd 100644
>--- a/include/linux/scatterlist.h
>+++ b/include/linux/scatterlist.h
>@@ -242,6 +242,7 @@ static inline void *sg_virt(struct scatterlist *sg)
> }
>
> int sg_nents(struct scatterlist *sg);
>+int sg_len(struct scatterlist *sg);
> int sg_nents_for_len(struct scatterlist *sg, u64 len);
> struct scatterlist *sg_next(struct scatterlist *);
> struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
>diff --git a/lib/scatterlist.c b/lib/scatterlist.c
>index bafa993..dc71f27 100644
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
>+{
>+	int len;

Is there a reason why unsigned int is not used? Note, this applies to the 
users of that function too.

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
