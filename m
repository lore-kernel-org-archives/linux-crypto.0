Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0550C32792
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 14:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FA5B215EA
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 14:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731441AbfI3Ooa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 10:44:30 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3196 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730809AbfI3Ooa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 10:44:30 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5854182C76215ADB9DD0;
        Mon, 30 Sep 2019 22:44:26 +0800 (CST)
Received: from localhost (10.202.226.61) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Mon, 30 Sep 2019
 22:44:18 +0800
Date:   Mon, 30 Sep 2019 15:44:05 +0100
From:   Jonathan Cameron <jonathan.cameron@huawei.com>
To:     Tian Tao <tiantao6@huawei.com>
CC:     <gilad@benyossef.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH] crypto: fix comparison of unsigned expression warnings
Message-ID: <20190930154405.00004187@huawei.com>
In-Reply-To: <20190930151702.0000131f@huawei.com>
References: <1569833361-47224-1-git-send-email-tiantao6@huawei.com>
        <20190930151702.0000131f@huawei.com>
Organization: Huawei
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.61]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 30 Sep 2019 15:17:02 +0100
Jonathan Cameron <jonathan.cameron@huawei.com> wrote:

> On Mon, 30 Sep 2019 16:49:21 +0800
> Tian Tao <tiantao6@huawei.com> wrote:
> 
> > This patch fixes the following warnings:
> > drivers/crypto/ccree/cc_aead.c:630:5-12: WARNING: Unsigned expression
> > compared with zero: seq_len > 0
> > 
> > Signed-off-by: Tian Tao <tiantao6@huawei.com>  
> 
> Apologies, I should have looked into this in more depth when you asked
> me about it earlier rather than assuming it was 'obviously' the right
> fix.
> 
> It's more complex than I expected given the warning, which I note
> is > 0 so it's not always true.  I'm curious, which compiler generates
> that warning?
> 
> So there are two ways seq_len can be set to non 0, hmac_setkey which returns a
> signed int, but one that is reality is >= 0. The other is xcbc_setkey
> which returns an unsigned int.
> 
> So I would suggest that in addition to what you have here, a change
> to the return type of hmac_setkey in order to make it clear that
> never returns a negative anyway.

Hmm. Perhaps I shouldn't review with jetlag...   That should have said
that I think the variable should be left unsigned as reality is that
it is always >= 0.

> 
> Can also use if (seq_len)
> rather than if (seq_len > 0)
> 
> Thanks,
> 
> Jonathan
> 
> 
>  
> > ---
> >  drivers/crypto/ccree/cc_aead.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
> > index d3e8faa..b19291d 100644
> > --- a/drivers/crypto/ccree/cc_aead.c
> > +++ b/drivers/crypto/ccree/cc_aead.c
> > @@ -546,7 +546,7 @@ static int cc_aead_setkey(struct crypto_aead *tfm, const u8 *key,
> >  	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
> >  	struct cc_crypto_req cc_req = {};
> >  	struct cc_hw_desc desc[MAX_AEAD_SETKEY_SEQ];
> > -	unsigned int seq_len = 0;
> > +	int seq_len = 0;
> >  	struct device *dev = drvdata_to_dev(ctx->drvdata);
> >  	const u8 *enckey, *authkey;
> >  	int rc;  
> 


