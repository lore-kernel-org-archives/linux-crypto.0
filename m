From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: NULL deref in sha512_mb_mgr_get_comp_job_avx2
Date: Wed, 15 Feb 2017 11:42:13 +0800
Message-ID: <20170215034213.GA11004@gondor.apana.org.au>
References: <CACT4Y+Z6_x2smshuSgQx0wA+g0H+5dJsF23UqYb9Z_WkDUvwcw@mail.gmail.com>
 <20170201184502.GA11649@linux.intel.com>
 <20170211105043.GA855@gondor.apana.org.au>
 <1487006448.2833.94.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Dmitry Vyukov <dvyukov@google.com>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        megha.dey@linux.intel.com, fenghua.yu@intel.com,
        syzkaller <syzkaller@googlegroups.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46943 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751503AbdBODmi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2017 22:42:38 -0500
Content-Disposition: inline
In-Reply-To: <1487006448.2833.94.camel@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 13, 2017 at 09:20:48AM -0800, Tim Chen wrote:
> 
> Megha is now able to create a test set up that produce
> similar problem reported by Dmitry.  This patch did not
> completely fix it.  So maybe you can hold off on merging
> this patch to the mainline till we can develop a more
> complete fix.

Tim, please send them as follow-up patches.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
