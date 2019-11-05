Return-Path: <SRS0=QWZk=Y5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44532C5DF60
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 17:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FF44214D8
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 17:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572975163;
	bh=uT3bEZMqcvE0LO6gjZrYNNNtYgoxVgzmdR0oJRRV3Q4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=v3fMe1YFB9tul5trcdLxClDmX3R5E1V0P2vp8ib5mR8LBcSHBMPMBWeZu6ZrW/tRm
	 ZWwGfMXK4U9EikmRyujx/s95BENBg9mvFfUrrcBN7T4VLGB5Li0ZOeZFvxJYOOpW+9
	 OJXBXY8SU1msSYd0eX0W6cb7Ex8zF99oHc6ZLVAU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389523AbfKERcm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Nov 2019 12:32:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:54302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387776AbfKERcm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Nov 2019 12:32:42 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 314BB2087E;
        Tue,  5 Nov 2019 17:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572975161;
        bh=uT3bEZMqcvE0LO6gjZrYNNNtYgoxVgzmdR0oJRRV3Q4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q8ZNADz7U0snS9szacn2Cr5QJ/4QCcW1W0a+DJICsARMF1kCYi8Kr8vNKI9gh4JdG
         9LRW/573QUVpGcLX98RCqH58tH6/xZX+BIQes9bGMgtwhJTJdm7SyvI+8DCgo3Lfh8
         V4SAJ4hnBqXK34lpTuv0bjdCHmD9poqXaCmOHs64=
Date:   Tue, 5 Nov 2019 09:32:39 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Gonglei <arei.gonglei@huawei.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 03/29] crypto: virtio - switch to skcipher API
Message-ID: <20191105173239.GB757@sol.localdomain>
Mail-Followup-To: Ard Biesheuvel <ardb@kernel.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Gonglei <arei.gonglei@huawei.com>,
        virtualization@lists.linux-foundation.org
References: <20191105132826.1838-1-ardb@kernel.org>
 <20191105132826.1838-4-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105132826.1838-4-ardb@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 05, 2019 at 02:28:00PM +0100, Ard Biesheuvel wrote:
> So switch this driver to the skcipher API, allowing us to finally drop the
> blkcipher code in the near future.

Strictly speaking this should say "ablkcipher", not "blkcipher".
Same in the other commit messages.

- Eric
