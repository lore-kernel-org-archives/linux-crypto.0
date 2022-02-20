Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6166C43219
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Feb 2022 01:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243344AbiBTBz5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 19 Feb 2022 20:55:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243339AbiBTBz4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Feb 2022 20:55:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E26655BDA
        for <linux-crypto@vger.kernel.org>; Sat, 19 Feb 2022 17:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645322135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FsMKZ+jo6tQ83rekBbXbEArcQHPB6qui/zgsNtgoZyk=;
        b=ei1NRLj+oykHkObilHOcqgIKvGGTbfvuRvqXRzstidoNemxWvolRPu8d9sF5X5sLpUqdKF
        UwcqC9QuIYH1n1DnuCW76y+4OrZMkxU47nFkr1+0n0xzWHCZciu+Ydc4FPr/xQ8w3Qgsdj
        8iaAWS+WXQuTtImbyrJTv8gb1a+pnRw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-SFHeQ4QtNDO9nrvEsTYolQ-1; Sat, 19 Feb 2022 20:55:31 -0500
X-MC-Unique: SFHeQ4QtNDO9nrvEsTYolQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 044FA1898290;
        Sun, 20 Feb 2022 01:55:28 +0000 (UTC)
Received: from localhost (ovpn-12-31.pek2.redhat.com [10.72.12.31])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 89EBB60C81;
        Sun, 20 Feb 2022 01:55:21 +0000 (UTC)
Date:   Sun, 20 Feb 2022 09:55:18 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Wolfram Sang <wsa@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org, hch@lst.de,
        cl@linux.com, 42.hyeyoo@gmail.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz,
        David.Laight@aculab.com, david@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 11/22] staging: emxx_udc: Don't use GFP_DMA when calling
 dma_alloc_coherent()
Message-ID: <20220220015518.GA93179@MiWiFi-R3L-srv>
References: <20220219005221.634-1-bhe@redhat.com>
 <20220219005221.634-12-bhe@redhat.com>
 <YhCTgS4PmyuPHjE8@kunai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhCTgS4PmyuPHjE8@kunai>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 02/19/22 at 07:51am, Wolfram Sang wrote:
> 
> > --- a/drivers/staging/media/imx/imx-media-utils.c
> 
> $subject says 'emxx_udc' instead of 'imx: media-utils'.

Ah, good catch. It should be wrongly copied from the patch 12, will fix
it, thanks.

