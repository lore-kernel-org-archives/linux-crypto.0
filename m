From: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [2.6 patch] add include/asm-avr32/xor.h
Date: Mon, 14 Apr 2008 17:50:10 -0400
Message-ID: <8bd0f97a0804141450x51d93a5eh38a5144f5e6ec0f1@mail.gmail.com>
References: <20080414141632.GA6695@cs181133002.pp.htv.fi>
	 <20080414181140.GA813@Chamillionaire.breakpoint.cc>
	 <20080414181536.GZ6695@cs181133002.pp.htv.fi>
	 <20080414214640.GA2282@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Adrian Bunk" <bunk@kernel.org>, hskinnemoen@atmel.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	shannon.nelson@intel.com, dan.j.williams@intel.com
To: "Sebastian Siewior" <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.238]:16236 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbYDNVuN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Apr 2008 17:50:13 -0400
Received: by wr-out-0506.google.com with SMTP id c48so991381wra.1
        for <linux-crypto@vger.kernel.org>; Mon, 14 Apr 2008 14:50:12 -0700 (PDT)
In-Reply-To: <20080414214640.GA2282@Chamillionaire.breakpoint.cc>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 14, 2008 at 5:46 PM, Sebastian Siewior
<linux-crypto@ml.breakpoint.cc> wrote:
> * Adrian Bunk | 2008-04-14 21:15:36 [+0300]:
>  >> >601f75e99c076c16e2648f4860cac4fc6ce187ea diff --git a/include/asm-avr32/xor.h b/include/asm-avr32/xor.h
>  >> >new file mode 100644
>  >> >index 0000000..99c87aa
>  >> >--- /dev/null
>  >> >+++ b/include/asm-avr32/xor.h
>  >> >@@ -0,0 +1,6 @@
>  >> >+#ifndef _ASM_XOR_H
>  >> >+#define _ASM_XOR_H
>  >> >+
>  >> >+#include <asm-generic/xor.h>
>  >> >+
>  >> >+#endif
>  >>
>  >> What about providing <linux/xor.h> which includes the right file from
>  >> asm/ or asm-generic/ depending on HAVE_.* ?
>  >
>  >Where's the advantage?
>
>  This week you are going through avr32. The same fixup is required for
>  blackfin or cris if my ls isn't lying. So either you fix every arch
>  with this missing include or you provide a generic include and every
>  arch that provides a private xor.h includes it. From what I can see
>  almost every arch includes the generic except for x86 & sparc so most
>  xor.h files are identical copies and this is probably as bad as a
>  trailing white space :)

indeed.  the less work for arches the better :).
-mike
