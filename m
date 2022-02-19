Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7789C4332F
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Feb 2022 07:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241582AbiBSHPC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 19 Feb 2022 02:15:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiBSHPB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Feb 2022 02:15:01 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A19E580D9;
        Fri, 18 Feb 2022 23:14:43 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 73DC068BEB; Sat, 19 Feb 2022 08:14:40 +0100 (CET)
Date:   Sat, 19 Feb 2022 08:14:40 +0100
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
Subject: Re: [PATCH 20/22] HID: intel-ish-hid: Use dma_alloc_noncoherent()
 for dma buffer
Message-ID: <20220219071440.GF26711@lst.de>
References: <20220219005221.634-1-bhe@redhat.com> <20220219005221.634-21-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220219005221.634-21-bhe@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
