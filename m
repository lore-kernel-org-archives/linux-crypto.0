From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch] crypto: sha256-mb - cleanup a || vs | typo
Date: Mon, 11 Jul 2016 18:09:03 +0800
Message-ID: <20160711100903.GA21163@gondor.apana.org.au>
References: <20160629144242.GE22818@mwanda>
 <8538242a-eab7-127e-e47e-26027fee4f6d@zytor.com>
 <1467319339.22178.256.camel@linux.intel.com>
 <20160701075559.GA11902@gmail.com>
 <20160701092806.GA13424@gondor.apana.org.au>
 <20160701101329.GA3833@gmail.com>
 <20160708162803.GA29111@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	Megha Dey <megha.dey@intel.com>,
	"Wang, Rui Y" <rui.y.wang@intel.com>,
	Denys Vlasenko <dvlasenk@redhat.com>,
	Xiaodong Liu <xiaodong.liu@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160708162803.GA29111@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jul 08, 2016 at 09:28:03AM -0700, Tim Chen wrote:
> 
> From: Tim Chen <tim.c.chen@linux.intel.com>
> Subject: [PATCH] crypto: Cleanup sha multi-buffer code to use || instead of |
>  for condition comparison and cleanup multiline comment style
> 
> In sha*_ctx_mgr_submit, we currently use the | operator instead of ||
> ((ctx->partial_block_buffer_length) | (len < SHA1_BLOCK_SIZE))
> 
> Switching it to || and remove extraneous paranthesis to
> adhere to coding style.
> 
> Also cleanup inconsistent multiline comment style.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
