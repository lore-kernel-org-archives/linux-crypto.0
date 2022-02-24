Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51045C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Feb 2022 14:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235336AbiBXOL7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Feb 2022 09:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbiBXOL7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Feb 2022 09:11:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3CCC2294FC2
        for <linux-crypto@vger.kernel.org>; Thu, 24 Feb 2022 06:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645711888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QcE0EVUjCg6X/xa4J/ZeUVoMtNaV/sF9sKuaRTVThoM=;
        b=EoC+W1rEMWdkpZhEU2yHU8dL8eRo+WrhZT6aSlseLlxOJNDVxKS3ZpYmvTKHrC2ozxhtHS
        sGtKpacVENI6XFd1JE+cf4gtMGdnDxNxrUg4/OcIrJQ5jRdjlifCgLJRqJTPCIom63IZq8
        oIvhaD7eHETZhNt6fhUTe2RdaG/3g4w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446-1e0tpTSFOiWgY-PtsWJlVw-1; Thu, 24 Feb 2022 09:11:27 -0500
X-MC-Unique: 1e0tpTSFOiWgY-PtsWJlVw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C8FB1006AA7;
        Thu, 24 Feb 2022 14:11:22 +0000 (UTC)
Received: from localhost (ovpn-13-73.pek2.redhat.com [10.72.13.73])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FC2684008;
        Thu, 24 Feb 2022 14:11:19 +0000 (UTC)
Date:   Thu, 24 Feb 2022 22:11:17 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, cl@linux.com, 42.hyeyoo@gmail.com,
        penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        vbabka@suse.cz, David.Laight@aculab.com, david@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org, wsa@kernel.org
Subject: Re: [PATCH 1/2] dma-mapping: check dma_mask for streaming mapping
 allocs
Message-ID: <YheSBTJY216m6izG@MiWiFi-R3L-srv>
References: <20220219005221.634-22-bhe@redhat.com>
 <20220219071730.GG26711@lst.de>
 <20220220084044.GC93179@MiWiFi-R3L-srv>
 <20220222084530.GA6210@lst.de>
 <YhSpaGfiQV8Nmxr+@MiWiFi-R3L-srv>
 <20220222131120.GB10093@lst.de>
 <YhToFzlSufrliUsi@MiWiFi-R3L-srv>
 <20220222155904.GA13323@lst.de>
 <YhV/nabDa5zdNL/4@MiWiFi-R3L-srv>
 <20220223142555.GA5986@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223142555.GA5986@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 02/23/22 at 03:25pm, Christoph Hellwig wrote:
> On Wed, Feb 23, 2022 at 08:28:13AM +0800, Baoquan He wrote:
> > Could you tell more why this is wrong? According to
> > Documentation/core-api/dma-api.rst and DMA code, __dma_alloc_pages() is
> > the core function of dma_alloc_pages()/dma_alloc_noncoherent() which are
> > obviously streaming mapping,
> 
> Why are they "obviously" streaming mappings?

Because they are obviously not coherent mapping?

With my understanding, there are two kinds of DMA mapping, coherent
mapping (which is also persistent mapping), and streaming mapping. The
coherent mapping will be handled during driver init, and released during
driver de-init. While streaming mapping will be done when needed at any
time, and released after usage.

Are we going to add another kind of mapping? It's not streaming mapping,
but use dev->coherent_dma_mask, just because it uses dma_alloc_xxx()
api.

> 
> > why do we need to check
> > dev->coherent_dma_mask here? Because dev->coherent_dma_mask is the subset
> > of dev->dma_mask, it's safer to use dev->coherent_dma_mask in these
> > places? This is confusing, I talked to Hyeonggon in private mail, he has
> > the same feeling.
> 
> Think of th coherent_dma_mask as dma_alloc_mask.  It is the mask for the
> DMA memory allocator.  dma_mask is the mask for the dma_map_* routines.

I will check code further. While this may need be noted in doc, e.g
dma_api.rst or dma-api-howto.rst.

If you have guide, I can try to add some words to make clear this. Or
leave this to people who knows this clearly. I believe it will be very
helpful to understand DMA api.

