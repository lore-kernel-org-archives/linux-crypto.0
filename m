Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9DEBEE49B0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Aug 2023 10:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjHWKHE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Aug 2023 06:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbjHWKGV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Aug 2023 06:06:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D53E10B;
        Wed, 23 Aug 2023 03:06:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0FAB63327;
        Wed, 23 Aug 2023 10:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580ABC433C7;
        Wed, 23 Aug 2023 10:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1692785175;
        bh=S/tRBgvfmFafEY0NNIlhshuLBbudgpjLYxMaO2Jaq5c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nu9W/JEFszyKDZrhMU1WUqqZbhMZUV3YN72hbzQdUX/yNu8joV7FADzoUmI97qOcu
         CEEoysUvAQXgMyHgpcixsKKh3LaLCpYj5VAJbl4Vmz408A08kaeLG8b9H3+G0R2JaT
         lzDaE7FW5AoPdjVjFESMP7OwE8frmfu/ALs39bmM=
Date:   Wed, 23 Aug 2023 12:06:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Babis Chalios <bchalios@amazon.es>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Theodore Ts'o <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, graf@amazon.de,
        xmarcalx@amazon.co.uk, aams@amazon.de, dwmw@amazon.co.uk
Subject: Re: [RFC PATCH 1/2] random: emit reseed notifications for PRNGs
Message-ID: <2023082340-daybreak-lagged-f157@gregkh>
References: <20230823090107.65749-1-bchalios@amazon.es>
 <20230823090107.65749-2-bchalios@amazon.es>
 <2023082322-semester-heave-e5bc@gregkh>
 <ff6aa77e-4e5c-488e-bd45-319fc09720c3@amazon.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff6aa77e-4e5c-488e-bd45-319fc09720c3@amazon.es>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 23, 2023 at 11:27:11AM +0200, Babis Chalios wrote:
> Hi Greg,
> 
> On 23/8/23 11:08, Greg KH wrote:
> > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> > 
> > 
> > 
> > On Wed, Aug 23, 2023 at 11:01:05AM +0200, Babis Chalios wrote:
> > > Sometimes, PRNGs need to reseed. For example, on a regular timer
> > > interval, to ensure nothing consumes a random value for longer than e.g.
> > > 5 minutes, or when VMs get cloned, to ensure seeds don't leak in to
> > > clones.
> > > 
> > > The notification happens through a 32bit epoch value that changes every
> > > time cached entropy is no longer valid, hence PRNGs need to reseed. User
> > > space applications can get hold of a pointer to this value through
> > > /dev/(u)random. We introduce a new ioctl() that returns an anonymous
> > > file descriptor. From this file descriptor we can mmap() a single page
> > > which includes the epoch at offset 0.
> > > 
> > > random.c maintains the epoch value in a global shared page. It exposes
> > > a registration API for kernel subsystems that are able to notify when
> > > reseeding is needed. Notifiers register with random.c and receive a
> > > unique 8bit ID and a pointer to the epoch. When they need to report a
> > > reseeding event they write a new epoch value which includes the
> > > notifier ID in the first 8 bits and an increasing counter value in the
> > > remaining 24 bits:
> > > 
> > >                RNG epoch
> > > *-------------*---------------------*
> > > | notifier id | epoch counter value |
> > > *-------------*---------------------*
> > >       8 bits           24 bits
> > Why not just use 32/32 for a full 64bit value, or better yet, 2
> > different variables?  Why is 32bits and packing things together here
> > somehow simpler?
> 
> We made it 32 bits so that we can read/write it atomically in all 32bit
> architectures.
> Do you think that's not a problem?

What 32bit platforms care about this type of interface at all?

thanks,

greg k-h
