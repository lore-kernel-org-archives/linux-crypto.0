From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: fix nx-842 pSeries driver minimum buffer size
Date: Thu, 4 Jun 2015 16:14:21 +0800
Message-ID: <20150604081421.GB23360@gondor.apana.org.au>
References: <1433272930-5991-1-git-send-email-ddstreet@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1433272930-5991-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 02, 2015 at 03:22:10PM -0400, Dan Streetman wrote:
> Reduce the nx-842 pSeries driver minimum buffer size from 128 to 8.
> Also replace the single use of IO_BUFFER_ALIGN macro with the standard
> and correct DDE_BUFFER_ALIGN.
> 
> The hw sometimes rejects buffers that contain padding past the end of the
> 8-byte aligned section where it sees the "end" marker.  With the minimum
> buffer size set too high, some highly compressed buffers were being padded
> and the hw was incorrectly rejecting them; this sets the minimum correctly
> so there will be no incorrect padding.
> 
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
