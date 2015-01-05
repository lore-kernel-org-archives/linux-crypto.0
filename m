From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: amcc: crypto4xx_sa.c:  Remove unused function
Date: Mon, 5 Jan 2015 21:37:22 +1100
Message-ID: <20150105103722.GC25200@gondor.apana.org.au>
References: <1420125228-26679-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1420125228-26679-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jan 01, 2015 at 04:13:47PM +0100, Rickard Strandqvist wrote:
> Remove the function get_dynamic_sa_offset_iv_field() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
