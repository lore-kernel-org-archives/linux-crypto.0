Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2888C4332F
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Feb 2022 07:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241541AbiBSHNx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 19 Feb 2022 02:13:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241542AbiBSHNw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Feb 2022 02:13:52 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB7B15C1B0;
        Fri, 18 Feb 2022 23:13:34 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 06F6668BEB; Sat, 19 Feb 2022 08:13:32 +0100 (CET)
Date:   Sat, 19 Feb 2022 08:13:31 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Baoquan He <bhe@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hch@lst.de, cl@linux.com,
        42.hyeyoo@gmail.com, penberg@kernel.org, rientjes@google.com,
        iamjoonsoo.kim@lge.com, vbabka@suse.cz, David.Laight@ACULAB.COM,
        david@redhat.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org, wsa@kernel.org
Subject: Re: [PATCH 17/22] net: marvell: prestera: Don't use GFP_DMA when
 calling dma_pool_alloc()
Message-ID: <20220219071331.GC26711@lst.de>
References: <20220219005221.634-1-bhe@redhat.com> <20220219005221.634-18-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220219005221.634-18-bhe@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Feb 19, 2022 at 08:52:16AM +0800, Baoquan He wrote:
> dma_pool_alloc() uses dma_alloc_coherent() to pre-allocate DMA buffer,
> so it's redundent to specify GFP_DMA when calling.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
