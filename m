From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: crypto: NULL deref in sha512_mb_mgr_get_comp_job_avx2
Date: Mon, 13 Feb 2017 09:20:48 -0800
Message-ID: <1487006448.2833.94.camel@linux.intel.com>
References: <CACT4Y+Z6_x2smshuSgQx0wA+g0H+5dJsF23UqYb9Z_WkDUvwcw@mail.gmail.com>
         <20170201184502.GA11649@linux.intel.com>
         <20170211105043.GA855@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: Dmitry Vyukov <dvyukov@google.com>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        megha.dey@linux.intel.com, fenghua.yu@intel.com,
        syzkaller <syzkaller@googlegroups.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:27752 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752252AbdBMRUu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Feb 2017 12:20:50 -0500
In-Reply-To: <20170211105043.GA855@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 2017-02-11 at 18:50 +0800, Herbert Xu wrote:
> On Wed, Feb 01, 2017 at 10:45:02AM -0800, Tim Chen wrote:
> > 
> > 
> > One theory that Mehga and I have is that perhaps the flusher
> > and regular computaion updates are stepping on each other. 
> > Can you try this patch and see if it helps?
> Patch applied.  Thanks.

Herbert,

Megha is now able to create a test set up that produce
similar problem reported by Dmitry.  This patch did not
completely fix it.  So maybe you can hold off on merging
this patch to the mainline till we can develop a more
complete fix.

Thanks.

Tim
