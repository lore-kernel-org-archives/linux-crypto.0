Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AB5CC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 09:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71DB620EDD
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 09:16:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="vGAa71h9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgFZJQg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 05:16:36 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:42284 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgFZJQf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 05:16:35 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05Q9FkLI001185;
        Fri, 26 Jun 2020 04:15:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593162946;
        bh=2NIvKg6o9HQpxqVdkiZ19PgyBblsdU+mdkzmqdMlpKM=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=vGAa71h90Bq6lyBT88zwPXrBkDjwjGkf4Z3rFGn9/6m2rQiOr5LFuJPG84MN+9R5j
         1ca35m/q+q3AAhV6fyh9+771vDbbM3A+2AIY4Eart+PqXIMBAiq5kJDBYLvVzx0AkI
         /G4TcSwfn8x/c1M11CZ8gKFJIuxOWCxSLJFfdyy0=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05Q9FkaF085758
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 26 Jun 2020 04:15:46 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 26
 Jun 2020 04:15:46 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 26 Jun 2020 04:15:46 -0500
Received: from [127.0.0.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05Q9Fhl6058791;
        Fri, 26 Jun 2020 04:15:45 -0500
Subject: Re: [PATCHv4 3/7] crypto: sa2ul: add sha1/sha256/sha512 support
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <j-keerthy@ti.com>
References: <20200615071452.25141-1-t-kristo@ti.com>
 <20200615071452.25141-4-t-kristo@ti.com>
 <20200626043155.GA2683@gondor.apana.org.au>
From:   Tero Kristo <t-kristo@ti.com>
Message-ID: <2a89ea86-3b9e-06b5-fa8e-9dc6e5ad9aeb@ti.com>
Date:   Fri, 26 Jun 2020 12:15:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200626043155.GA2683@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 26/06/2020 07:31, Herbert Xu wrote:
> On Mon, Jun 15, 2020 at 10:14:48AM +0300, Tero Kristo wrote:
>>
>> +static int sa_sha_update(struct ahash_request *req)
>> +{
>> +	struct sa_sha_req_ctx *rctx = ahash_request_ctx(req);
>> +	struct scatterlist *sg;
>> +	void *buf;
>> +	int pages;
>> +	struct page *pg;
>> +
>> +	if (!req->nbytes)
>> +		return 0;
>> +
>> +	if (rctx->buf_free >= req->nbytes) {
>> +		pg = sg_page(rctx->sg_next);
>> +		buf = kmap_atomic(pg);
>> +		scatterwalk_map_and_copy(buf + rctx->offset, req->src, 0,
>> +					 req->nbytes, 0);
>> +		kunmap_atomic(buf);
>> +		rctx->buf_free -= req->nbytes;
>> +		rctx->sg_next->length += req->nbytes;
>> +		rctx->offset += req->nbytes;
>> +	} else {
>> +		pages = get_order(req->nbytes);
>> +		buf = (void *)__get_free_pages(GFP_ATOMIC, pages);
>> +		if (!buf)
>> +			return -ENOMEM;
>> +
>> +		sg = kzalloc(sizeof(*sg) * 2, GFP_KERNEL);
>> +		if (!sg)
>> +			return -ENOMEM;
>> +
>> +		sg_init_table(sg, 1);
>> +		sg_set_buf(sg, buf, req->nbytes);
>> +		scatterwalk_map_and_copy(buf, req->src, 0, req->nbytes, 0);
>> +
>> +		rctx->buf_free = (PAGE_SIZE << pages) - req->nbytes;
>> +
>> +		if (rctx->sg_next) {
>> +			sg_unmark_end(rctx->sg_next);
>> +			sg_chain(rctx->sg_next, 2, sg);
>> +		} else {
>> +			rctx->src = sg;
>> +		}
>> +
>> +		rctx->sg_next = sg;
>> +		rctx->src_nents++;
>> +
>> +		rctx->offset = req->nbytes;
>> +	}
>> +
>> +	rctx->len += req->nbytes;
>> +
>> +	return 0;
>> +}
> 
> This is not how it's supposed to work.  To support the partial
> hashing interface, you must actually hash the data and not just
> save it in your context.  Otherwise your export is completely
> meaningless.

I have been experimenting with an alternate approach, where I have a 
small buffer within the context, this would be more like the way other 
drivers do this. If the buffer is closed before running out of space, I 
can push this to be processed by HW, otherwise I must fallback to SW. 
Does this sound like a better approach?

> If your hardware cannot export partially hashed state, then you
> should use a software fallback for everything but digest.

Yea, HW can't support partial hashes.

-Tero
--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
