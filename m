Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F5BC433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Feb 2022 07:13:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241552AbiBSHOH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 19 Feb 2022 02:14:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241556AbiBSHOG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Feb 2022 02:14:06 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85ED416EA81;
        Fri, 18 Feb 2022 23:13:47 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id C328E68BEB; Sat, 19 Feb 2022 08:13:44 +0100 (CET)
Date:   Sat, 19 Feb 2022 08:13:44 +0100
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
Subject: Re: [PATCH 18/22] net: ethernet: mtk-star-emac: Don't use GFP_DMA
 when calling dmam_alloc_coherent()
Message-ID: <20220219071344.GD26711@lst.de>
References: <20220219005221.634-1-bhe@redhat.com> <20220219005221.634-19-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220219005221.634-19-bhe@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Feb 19, 2022 at 08:52:17AM +0800, Baoquan He wrote:
> dmam_alloc_coherent() uses struct dma_devres to manage data, and call
> dma_alloc_attrs() to allocate cohenrent DMA memory, so it's redundent
> to specify GFP_DMA when calling.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
