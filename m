From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/testmgr.c: fix !x==y confusion
Date: Tue, 9 Aug 2016 19:01:45 +0800
Message-ID: <20160809110145.GD7099@gondor.apana.org.au>
References: <1469781129-24304-1-git-send-email-yanjiang.jin@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, jinyanjiang@gmail.com
To: yanjiang.jin@windriver.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1469781129-24304-1-git-send-email-yanjiang.jin@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jul 29, 2016 at 04:32:09PM +0800, yanjiang.jin@windriver.com wrote:
> From: Yanjiang Jin <yanjiang.jin@windriver.com>
> 
> "if (!ret == template[i].fail)" is confusing to compilers (gcc5):
> 
> crypto/testmgr.c: In function '__test_aead':
> crypto/testmgr.c:531:12: warning: logical not is only applied to the
> left hand side of comparison [-Wlogical-not-parentheses]
>    if (!ret == template[i].fail) {
>             ^
> 
> Let there be 'if (template[i].fail == !ret) '.
> 
> Signed-off-by: Yanjiang Jin <yanjiang.jin@windriver.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
