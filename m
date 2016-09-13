From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next] hwrng: st - Fix missing clk_disable_unprepare() on
 error in st_rng_probe()
Date: Tue, 13 Sep 2016 20:41:28 +0800
Message-ID: <20160913124128.GE31835@gondor.apana.org.au>
References: <1473509022-3478-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrice Chotard <patrice.chotard@st.com>,
        Matt Mackall <mpm@selenic.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        linux-crypto@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41914 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbcIMMm3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 08:42:29 -0400
Content-Disposition: inline
In-Reply-To: <1473509022-3478-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Sep 10, 2016 at 12:03:42PM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Fix the missing clk_disable_unprepare() before return
> from st_rng_probe() in the error handling case.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
