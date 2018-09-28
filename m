From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] crypto: OFB and tests
Date: Fri, 28 Sep 2018 13:09:30 +0800
Message-ID: <20180928050930.6ohzrmgtxnuqgxfd@gondor.apana.org.au>
References: <1537449521-16182-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>, ofir.drang@arm.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1537449521-16182-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 20, 2018 at 02:18:37PM +0100, Gilad Ben-Yossef wrote:
> Add OFB mode generic implementation and more SM4 tests
> 
> Gilad Ben-Yossef (3):
>   crypto: testmgr: update sm4 test vectors
>   crypto: add output feedback mode
>   crypto: tcrypt: add OFB functional tests
> 
>  crypto/Kconfig   |  12 +++
>  crypto/Makefile  |   1 +
>  crypto/ofb.c     | 225 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  crypto/tcrypt.c  |  17 +++++
>  crypto/tcrypt.h  |   1 +
>  crypto/testmgr.c |  12 +++
>  crypto/testmgr.h | 122 ++++++++++++++++++++++++++++--
>  7 files changed, 383 insertions(+), 7 deletions(-)
>  create mode 100644 crypto/ofb.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
