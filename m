From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: via-rng - support new Centaur CPU
Date: Sat, 21 Apr 2018 01:05:36 +0800
Message-ID: <20180420170536.rglsnmjqqndywb6t@gondor.apana.org.au>
References: <1523602983-3418-1-git-send-email-davidwang@zhaoxin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, arnd@arndb.de, grehkg@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        brucechang@via-alliance.com, cooperyan@zhaoxin.com,
        qiyuanwang@zhaoxin.com, benjaminpan@viatech.com,
        lukelin@viacpu.com, timguo@zhaoxin.com
To: David Wang <davidwang@zhaoxin.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1523602983-3418-1-git-send-email-davidwang@zhaoxin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Apr 13, 2018 at 03:03:03PM +0800, David Wang wrote:
> New Centaur CPU(Family > 6) supprt Random Number Generator, but can't
> support MSR_VIA_RNG. Just like VIA Nano.
> 
> Signed-off-by: David Wang <davidwang@zhaoxin.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
