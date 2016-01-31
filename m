From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [patch] crypto: keywrap - memzero the correct memory
Date: Sun, 31 Jan 2016 14:00:16 +0100
Message-ID: <7459893.TVu3jshKD9@positron.chronox.de>
References: <20160130143828.GC3462@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160130143828.GC3462@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Samstag, 30. Januar 2016, 17:38:28 schrieb Dan Carpenter:

Hi Dan,

> We're clearing the wrong memory.  The memory corruption is likely
> harmless because we weren't going to use that stack memory again but not
> zeroing is a potential information leak.
> 
> Fixes: e28facde3c39 ('crypto: keywrap - add key wrapping block chaining
> mode') Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Stephan Mueller <smueller@chronox.de>

Thanks
Stephan
