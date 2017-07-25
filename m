From: Harsh Jain <Harsh@chelsio.com>
Subject: Re: [bug report] crypto: chcr - Select device in Round Robin fashion
Date: Tue, 25 Jul 2017 10:12:35 +0530
Message-ID: <482b055f-3509-0b92-e255-e5118e04a367@chelsio.com>
References: <20170720103252.jrtckdbcnnsbf4v3@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:42054 "EHLO l.chelsio.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750778AbdGYEmm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jul 2017 00:42:42 -0400
In-Reply-To: <20170720103252.jrtckdbcnnsbf4v3@mwanda>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 20-07-2017 16:02, Dan Carpenter wrote:
> Hello Harsh Jain,
>
> The patch 14c19b178a01: "crypto: chcr - Select device in Round Robin
> fashion" from Jun 15, 2017, leads to the following static checker
> warning:
>
> 	drivers/crypto/chelsio/chcr_core.c:163 chcr_uld_add()
> 	warn: overwrite may leak 'u_ctx'
>
> drivers/crypto/chelsio/chcr_core.c
>    152  static void *chcr_uld_add(const struct cxgb4_lld_info *lld)
>    153  {
>    154          struct uld_ctx *u_ctx;
>    155  
>    156          /* Create the device and add it in the device list */
>    157          u_ctx = kzalloc(sizeof(*u_ctx), GFP_KERNEL);
>    158          if (!u_ctx) {
>    159                  u_ctx = ERR_PTR(-ENOMEM);
>    160                  goto out;
>    161          }
>    162          if (!(lld->ulp_crypto & ULP_CRYPTO_LOOKASIDE)) {
>
> Sure, we could move this check before the allocation, to prevent the
> leak but is -ENOMEM really the right error code?  It feels like -EINVAL
> with a WARN_ON_ONCE() message would be better but I don't really
> understand this code.
Will fix both issues in next change set. Thanks.
>
>    163                  u_ctx = ERR_PTR(-ENOMEM);
>    164                  goto out;
>    165          }
>    166          u_ctx->lldi = *lld;
>    167  out:
>    168          return u_ctx;
>    169  }
>
> regards,
> dan carpenter
