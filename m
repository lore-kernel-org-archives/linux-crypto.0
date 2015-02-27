From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sha-mb: Fix big integer constant sparse warning
Date: Fri, 27 Feb 2015 22:53:58 +1300
Message-ID: <20150227095357.GB29177@gondor.apana.org.au>
References: <1423132175-6800-1-git-send-email-prabhakar.csengg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:41038 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbbB0JyZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Feb 2015 04:54:25 -0500
Content-Disposition: inline
In-Reply-To: <1423132175-6800-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 05, 2015 at 10:29:35AM +0000, Lad Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> this patch fixes following sparse warning:
> 
> sha1_mb_mgr_init_avx2.c:59:31: warning: constant 0xF76543210 is so big it is long
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
