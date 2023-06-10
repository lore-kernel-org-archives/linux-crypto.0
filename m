Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C51CC7EE29
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Jun 2023 06:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjFJGvI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 10 Jun 2023 02:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjFJGvH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2023 02:51:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107AE3C00;
        Fri,  9 Jun 2023 23:51:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0B9862162;
        Sat, 10 Jun 2023 06:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E12C433D2;
        Sat, 10 Jun 2023 06:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1686379864;
        bh=9+jSZur8kKMdp4QWKKR2gLKbPRbyGHjjK9ectU9UX8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DLyNaTuBZQE7+MgYKCoxoCdQRA94X8bROaqvfbkU8gx0+NpwaPibZJk0l5oukkECv
         8shxby16yQICGsI/X9KxsIYpcvuMmRmv7jmH1pproqP6uZLaxRNF6gfzkNeplAAhtY
         PNYR16QU+v/DdQh80N9kmwlgVWWVSsxtRb62w5TA=
Date:   Sat, 10 Jun 2023 08:51:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, arei.gonglei@huawei.com,
        jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
        herbert@gondor.apana.org.au, davem@davemloft.net, amit@kernel.org,
        arnd@arndb.de, marcel@holtmann.org, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, linux-bluetooth@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xianting Tian <tianxianting.txt@alibaba-inc.com>
Subject: Re: [PATCH 1/3] virtio-crypto: fixup potential cpu stall when free
 unused bufs
Message-ID: <2023061036-lived-earflap-26ee@gregkh>
References: <20230609131817.712867-1-xianting.tian@linux.alibaba.com>
 <20230609131817.712867-2-xianting.tian@linux.alibaba.com>
 <20230609115617-mutt-send-email-mst@kernel.org>
 <a0a07bfd-6e44-5478-395d-be6c1f3bd92a@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a0a07bfd-6e44-5478-395d-be6c1f3bd92a@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jun 10, 2023 at 11:20:49AM +0800, Xianting Tian wrote:
> 
> 在 2023/6/9 下午11:57, Michael S. Tsirkin 写道:
> > On Fri, Jun 09, 2023 at 09:18:15PM +0800, Xianting Tian wrote:
> > > From: Xianting Tian <tianxianting.txt@alibaba-inc.com>
> > > 
> > > Cpu stall issue may happen if device is configured with multi queues
> > > and large queue depth, so fix it.
> > What does "may happen" imply exactly?
> > was this observed?
> I didn't met such issue, this patch set just a theoretical fix.

Then I would not recommend adding it at this time, as you just slowed
down the kernel for something that no one has reported :(

thanks,

greg k-h
