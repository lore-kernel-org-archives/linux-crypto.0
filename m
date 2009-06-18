From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUGFIX 2/3] crypto: Remove CRYPTO_TFM_REQ_MAY_SLEEP flag in
	AES-NI accelerated ecb/cbc mode
Date: Thu, 18 Jun 2009 19:40:33 +0800
Message-ID: <20090618114032.GB6596@gondor.apana.org.au>
References: <1245056697.5320.350.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761615AbZFRLkl@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1245056697.5320.350.camel@yhuang-dev.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 15, 2009 at 05:04:57PM +0800, Huang Ying wrote:
> Because AES-NI instructions will touch XMM state, corresponding code
> must be enclosed within kernel_fpu_begin/end, which used
> preempt_disable/enable. So sleep should be prevented between
> kernel_fpu_begin/end.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

I'll apply this for now.  But it would be much better to allow
sleeping in this case.

Couldn't we simply move the kernel_fpu_begin/end inside the loop?
It shouldn't be too expensive when it runs the 2nd time since it
doesn't have to save anything, right?

Cheer,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
