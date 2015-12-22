From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 0/4] crypto: add precalculated hash for zero message
 length
Date: Tue, 22 Dec 2015 21:23:49 +0800
Message-ID: <20151222132349.GC25829@gondor.apana.org.au>
References: <1450356342-12971-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, geert+renesas@glider.be,
	luis@debethencourt.com, maxime.ripard@free-electrons.com,
	thomas.lendacky@amd.com, vinod.koul@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1450356342-12971-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Dec 17, 2015 at 01:45:38PM +0100, LABBE Corentin wrote:
> Hello
> 
> Some crypto drivers cannot process empty data message and so rely on
> precalculated hash.
> This patch series add precalculated hash in headers and
> make the drivers use them.
> 
> Changes since v3
> - Added missing Kconfig depends on SHA256

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
