From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: caam - fix sg dump
Date: Thu, 22 Sep 2016 18:55:00 +0800
Message-ID: <20160922105500.GA6306@gondor.apana.org.au>
References: <DB4PR04MB0847584C19565F8B3FBE6ED698C90@DB4PR04MB0847.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cata.vasile@nxp.com, linux-crypto@vger.kernel.org,
        linux-crypto-owner@vger.kernel.org
To: Horia Geanta Neag <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37636 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933521AbcIVKzG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 06:55:06 -0400
Content-Disposition: inline
In-Reply-To: <DB4PR04MB0847584C19565F8B3FBE6ED698C90@DB4PR04MB0847.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Horia Geanta Neag <horia.geanta@nxp.com> wrote:
>
>> +
>> +static void dbg_dump_sg(const char *level, const char *prefix_str,
>> +                       int prefix_type, int rowsize, int groupsize,
>> +                        struct scatterlist *sg, size_t tlen, bool ascii,
>> +                    bool may_sleep)
> may_sleep is no longer needed.

As I've already applied this patch, please send any improvements
as incremental patches.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
