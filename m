From: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 5/9] crypto: qce: Adds sha and hmac transforms
Date: Fri, 11 Apr 2014 13:12:27 -0700
Message-ID: <20140411201227.GA20486@codeaurora.org>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
 <1396541886-10966-6-git-send-email-svarbanov@mm-sol.com>
 <20140409000931.GN9985@codeaurora.org>
 <5346AD64.1000409@mm-sol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5346AD64.1000409@mm-sol.com>
Sender: linux-arm-msm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 04/10, Stanimir Varbanov wrote:
> On 04/09/2014 03:09 AM, Stephen Boyd wrote:
> > On 04/03, Stanimir Varbanov wrote:
> > 
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int qce_ahash_import(struct ahash_request *req, const void *in)
> >> +{
> >> +	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
> >> +	u32 flags = rctx->flags;
> >> +	bool hmac = IS_SHA_HMAC(flags);
> >> +	int ret;
> >> +
> >> +	if (IS_SHA1(flags) || IS_SHA1_HMAC(flags)) {
> >> +		struct sha1_state *state = (struct sha1_state *)in;
> > 
> > Unnecessary cast from void *.
> 
> Nope, "in" is "const void *". Cast is needed to avoid compiler warnings.
> 

Ouch. Why are we casting away const? It should be possible to
make qce_import_common() take const state and buffer arguments?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
