Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726834AbfARC5d (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jan 2019 21:57:33 -0500
Date: Thu, 17 Jan 2019 18:57:30 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        broonie@kernel.org, ard.biesheuvel@linaro.org,
        jonathan.cameron@huawei.com
Subject: Re: [PATCH V2 0/5] Crypto Cleanup
Message-ID: <20190118025729.GA737@sol.localdomain>
References: <1547707683-45878-1-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547707683-45878-1-git-send-email-wangxiongfeng2@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 17, 2019 at 02:47:58PM +0800, Xiongfeng Wang wrote:
> The patchset introduce a helper to (un)register a array of crypto templates.
> The following patches use this helper to simplify the code. This is also
> a preparation for a coming patchset, which will register several crypto
> templates.
> 
> Changelog:
> v1 -> v2: 
> 	rebased to cryptodev, fix some format issue
> 
> Xiongfeng Wang (5):
>   crypto: api - add a helper to (un)register a array of templates
>   crypto: ccm - use template array registering API to simplify the code
>   crypto: gcm - use template array registering API to simplify the code
>   crypto: ctr - use template array registering API to simplify the code
>   crypto: chacha20poly1305 - use template array registering API to
>     simplify the code
> 
>  crypto/algapi.c           | 27 ++++++++++++++++
>  crypto/ccm.c              | 78 ++++++++++++++---------------------------------
>  crypto/chacha20poly1305.c | 37 +++++++++-------------
>  crypto/ctr.c              | 43 +++++++++-----------------
>  crypto/gcm.c              | 73 ++++++++++++++------------------------------
>  include/crypto/algapi.h   |  2 ++
>  6 files changed, 104 insertions(+), 156 deletions(-)
> 
> -- 
> 1.7.12.4
> 

For all 5 patches:

Reviewed-by: Eric Biggers <ebiggers@google.com>

However, you need to fix your email address to be the same in the Author and
Signed-off-by.  Right now it's:

Author: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>

(checkpatch.pl also warns about this.)

Thanks!

- Eric
