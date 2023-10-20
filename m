Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA331C001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 20:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjJTUCZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 16:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjJTUCY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 16:02:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251D4D52
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 13:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697832096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nxVAke6nj6pjnBzkMWTFgH436aTevLZ6Tb2czviGv94=;
        b=E3c1Kw4hFMbb//H8DqR06Im5v3PewgLgvdcvBtcT9CrX6gE6nskF7zHnADG5Y0ev2P99CL
        KHLxpCB7FQWchPqk0EQSs297A5JNVL+wE/yL2CveOB6eQE72SPnc9B9Ni40mwHHSqEOZYj
        T9srVbIQG8VmqP+a01vwdZiJ1nmpjGE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-inBjuvcLOsuvnwjkpwBx7w-1; Fri, 20 Oct 2023 16:01:31 -0400
X-MC-Unique: inBjuvcLOsuvnwjkpwBx7w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C03D88CC72;
        Fri, 20 Oct 2023 20:01:13 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 46B3D1C060B1;
        Fri, 20 Oct 2023 20:01:13 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
        id 328B930C0521; Fri, 20 Oct 2023 20:01:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 2F0383FB77;
        Fri, 20 Oct 2023 22:01:13 +0200 (CEST)
Date:   Fri, 20 Oct 2023 22:01:13 +0200 (CEST)
From:   Mikulas Patocka <mpatocka@redhat.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [RFC PATCH] crypto: de-prioritize QAT
In-Reply-To: <ZTJ5fngubmYWgt8r@gcabiddu-mobl1.ger.corp.intel.com>
Message-ID: <5a961b42-7f6a-1f36-a684-e3ef49674@redhat.com>
References: <0171515-7267-624-5a22-238af829698f@redhat.com> <ZTJ5fngubmYWgt8r@gcabiddu-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Fri, 20 Oct 2023, Giovanni Cabiddu wrote:

> On Mon, Oct 16, 2023 at 01:26:47PM +0200, Mikulas Patocka wrote:
> > Hi
> > 
> > I created this kernel module that stress-tests the crypto API:
> > https://people.redhat.com/~mpatocka/benchmarks/qat/tools/module-multithreaded.c
> > 
> > It shows that QAT underperforms significantly compared to AES-NI (for 
> > large requests it is 10 times slower; for small requests it is even worse) 
> > - see the second table in this document: 
> > https://people.redhat.com/~mpatocka/benchmarks/qat/kernel-module.txt
> > 
> > QAT has higher priority than AES-NI, so the kernel prefers it (it is not 
> > used for dm-crypt because it has the flag "CRYPTO_ALG_ALLOCATES_MEMORY", 
> > but it is preferred over AES-NI in other cases).
> Probably you can get better performance by modifying your configuration
> and test.
> >From your test application I can infer that you are using a single QAT
> device. The driver allocates a ring pair per TFM and it loads balances
> allocations between devices.
> In addition, jobs are submitted synchronously. This way the cost of
> offload is not amortised between requests.
> 
> Regards,
> 
> -- 
> Giovanni

Yes, I thought about using more TFMs, but I don't have access to the dual 
Xeon machine anymore (I would have to request access and wait until people 
who are using it release it).

We can run more tests, but it would be best to batch all the tests in a 
small timeframe, to minimize blocking the machine for other people.

Regarding synchronous submission - the current test submits 112 requests 
concurrently. Do you think that it is too small and we should submit more? 
What would be the appropriate number of requests to submit concurrently?

I did synchronous submission because it was easier to write it than 
asynchronous submission, but if you think that 112 requests is too small 
and we need to submit more, I can try to do it.

Mikulas

