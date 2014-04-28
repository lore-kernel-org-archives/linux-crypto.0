From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH v2 4/9] crypto: qce: Add ablkcipher algorithms
Date: Mon, 28 Apr 2014 16:00:06 +0800
Message-ID: <20140428080006.GA14510@gondor.apana.org.au>
References: <1397479725-20954-1-git-send-email-svarbanov@mm-sol.com>
 <1397479725-20954-5-git-send-email-svarbanov@mm-sol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-arm-msm@vger.kernel.org,
	Mona Hossain <mhossain@codeaurora.org>,
	Hariprasad Dhalinarasimha <hnamgund@codeaurora.org>,
	Zhen Kong <zkong@codeaurora.org>,
	Niranjana Vishwanathapura <nvishwan@codeaurora.org>,
	Rohit Vaswani <rvaswani@codeaurora.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1397479725-20954-5-git-send-email-svarbanov@mm-sol.com>
Sender: linux-arm-msm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 14, 2014 at 03:48:40PM +0300, Stanimir Varbanov wrote:
>
> +	if (IS_AES(flags)) {
> +		switch (keylen) {
> +		case AES_KEYSIZE_128:
> +		case AES_KEYSIZE_256:
> +			break;
> +		default:
> +			goto badkey;

You need to support 192 here.  If the hardware doesn't do that
you can work around it by using a software fallback.

In general you need to provide everything that is supported by
the generic software implementation.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
