From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: NULL deref in sha512_mb_mgr_get_comp_job_avx2
Date: Sat, 11 Feb 2017 18:50:44 +0800
Message-ID: <20170211105043.GA855@gondor.apana.org.au>
References: <CACT4Y+Z6_x2smshuSgQx0wA+g0H+5dJsF23UqYb9Z_WkDUvwcw@mail.gmail.com>
 <20170201184502.GA11649@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Vyukov <dvyukov@google.com>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        megha.dey@linux.intel.com, fenghua.yu@intel.com,
        syzkaller <syzkaller@googlegroups.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36097 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750989AbdBKS7d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Feb 2017 13:59:33 -0500
Content-Disposition: inline
In-Reply-To: <20170201184502.GA11649@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 01, 2017 at 10:45:02AM -0800, Tim Chen wrote:
>
> One theory that Mehga and I have is that perhaps the flusher
> and regular computaion updates are stepping on each other. 
> Can you try this patch and see if it helps?

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
