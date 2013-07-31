From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [BUG] 3.11 boot failure caused by commit crypto
Date: Wed, 31 Jul 2013 09:39:37 +0930
Message-ID: <87vc3r4mke.fsf@rustcorp.com.au>
References: <51EF3BCC.30102@huawei.com> <20130724070621.GA30415@gondor.apana.org.au> <1375130346.22432.399.camel@schen9-DESK> <20130729230806.GA1506@gondor.apana.org.au> <1375140048.22432.400.camel@schen9-DESK> <87li4o615p.fsf@rustcorp.com.au> <20130730112817.GA5516@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Zhao Hongjiang <zhaohongjiang@huawei.com>, davem@davemloft.net,
	Andrew Morton <akpm@linux-foundation.org>,
	"gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:43070 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab3GaDJi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Jul 2013 23:09:38 -0400
In-Reply-To: <20130730112817.GA5516@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu <herbert@gondor.apana.org.au> writes:
> On Tue, Jul 30, 2013 at 03:26:50PM +0930, Rusty Russell wrote:
>>
>> Does this imply that you want me to push that to Linus now, and/or CC
>> stable?  Was planning for *next* merge window...
>
> Next merge window is fine.  However, it would be good to restore
> the new driver for that as well.  So I see two ways to do this,
> either we push the crct10dif driver patches through your tree,
> on top of the MODULES_SOFTDEP patch, or I pull the MODULES_SOFTDEP
> patch into the crypto tree.
>
> What would you like to do?

You're welcome to it: it's v. unlikely to conflict with anything else.

Here it is, fresh from my pending-rebases branch, with my Signed-off-by.

Cheers,
Rusty.

From: Andreas Robinson <andr345@gmail.com>
Subject: modules: add support for soft module dependencies

Additional and optional dependencies not found while building the kernel and
modules, can now be declared explicitly.

Signed-off-by: Andreas Robinson <andr345@gmail.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/module.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/module.h b/include/linux/module.h
index 46f1ea0..504035f 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -97,6 +97,11 @@ extern const struct gtype##_id __mod_##gtype##_table		\
 /* For userspace: you can also call me... */
 #define MODULE_ALIAS(_alias) MODULE_INFO(alias, _alias)
 
+/* Soft module dependencies. See man modprobe.d for details.
+ * Example: MODULE_SOFTDEP("pre: module-foo module-bar post: module-baz")
+ */
+#define MODULE_SOFTDEP(_softdep) MODULE_INFO(softdep, _softdep)
+
 /*
  * The following license idents are currently accepted as indicating free
  * software modules
