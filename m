Return-Path: <SRS0=g5s/=PY=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727025AbfAPRtx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Jan 2019 12:49:53 -0500
Date: Wed, 16 Jan 2019 09:49:51 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        broonie@kernel.org, ard.biesheuvel@linaro.org,
        jonathan.cameron@huawei.com
Subject: Re: [PATCH 0/5] Crypto Cleanup
Message-ID: <20190116174949.GA152952@gmail.com>
References: <1547607034-40948-1-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547607034-40948-1-git-send-email-wangxiongfeng2@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 16, 2019 at 10:50:29AM +0800, Xiongfeng Wang wrote:
> The patchset introduce a helper to (un)register a array of crypto templates.
> The following patches use this helper to simplify the code. This is also
> a preparation for a coming patchset, which will register several crypto
> templates.
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
>  crypto/ccm.c              | 81 +++++++++++++++--------------------------------
>  crypto/chacha20poly1305.c | 38 +++++++++-------------
>  crypto/ctr.c              | 46 ++++++++++-----------------
>  crypto/gcm.c              | 76 +++++++++++++++-----------------------------
>  include/crypto/algapi.h   |  2 ++
>  6 files changed, 113 insertions(+), 157 deletions(-)
> 
> -- 
> 1.7.12.4
> 

Hi Xiongfeng, I think this a useful cleanup but can you please rebase this onto
cryptodev?  There is a conflict in crypto/ctr.c.

- Eric
