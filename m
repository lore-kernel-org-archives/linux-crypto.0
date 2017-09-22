From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: add OSCCA SM3 secure hash and tests
Date: Fri, 22 Sep 2017 18:13:47 +0800
Message-ID: <20170922101346.GG16270@gondor.apana.org.au>
References: <1503312690-2770-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1503312690-2770-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 21, 2017 at 01:51:27PM +0300, Gilad Ben-Yossef wrote:
> Add OSCCA SM3 secure hash (OSCCA GM/T 0004-2012 SM3)
> generic hash transformation, testmgr and tcrypt tests.
> 
> SM3 is a secure hash function which is part of the Chinese
> "Commercial Cryptography" suite of algorithms which use is
> required for certain commercial applications in China.
> 
> References:
>  http://www.oscca.gov.cn/UpFile/20101222141857786.pdf
>  https://datatracker.ietf.org/doc/html/draft-shen-sm3-hash
> 
> Tested via testmgr and tcrypt on Arm 64 and 32 bit. Compile
> tested for x86_64.
> 
> Gilad Ben-Yossef (2):
>   crypto: add OSCCA SM3 secure hash
>   crypto: add SM3 test vectors

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
