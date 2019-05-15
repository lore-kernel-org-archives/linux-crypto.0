Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A751EC04E53
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 12:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FF842082E
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 12:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbfEOMyG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 08:54:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:60302 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726677AbfEOMyG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 08:54:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 585B1AC8E;
        Wed, 15 May 2019 12:54:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B7B24DA866; Wed, 15 May 2019 14:55:05 +0200 (CEST)
Date:   Wed, 15 May 2019 14:55:05 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Can crypto API provide information about hw acceleration?
Message-ID: <20190515125505.GP3138@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190514163348.GM3138@twin.jikos.cz>
 <20190514213409.GA115510@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514213409.GA115510@gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 14, 2019 at 02:34:10PM -0700, Eric Biggers wrote:
> On Tue, May 14, 2019 at 06:33:48PM +0200, David Sterba wrote:
> > Hi,
> > 
> > Q: is there a way to query the crypto layer whether a given algorithm
> > (digest, crypto) is accelerated by the driver?
> > 
> > This information can be used to decide if eg. a checksum should can be
> > calculated right away or offloaded to a thread. This is done in btrfs,
> > (fs/btrfs/disk-io.c:check_async_write).
> > 
> > At this moment it contains a static check for a cpu feature, and only
> > for x86. I briefly searched the arch/ directory for implementations of
> > crc32c that possibly use hw aid and there are several of them. Adding a
> > static check a-la x86 for the other architectures (arm, ppc, mips,
> > sparc, s390) is wrong, so I'm looking for a clean solution.
> > 
> > The struct shash_alg definition of the algorithms does not say anything
> > about the acceleration. The closest thing is the cra_priority, but I
> > don't know if this is reliable information. The default implementations
> > seem to have 100, and acceleated 200 or 300.
> > 
> > This would be probably sufficient, but I'd like a confirmation from
> > crypto people.
> > 
> 
> There's only one default implementation of crc32c, not multiple, and it has
> priority 100.  All other crc32c implementations have priority > 100.  So yes,
> you can check the priority (which would require adding a function to
> lib/libcrc32c.c to get it).  Alternatively you could check whether the driver
> name is "crc32c-generic" or not.

Thanks, the driver name check seems to be ok for my needs. At mount time
the struct crypto_shash is initialized and this provides the driver
name, then a bit is set whether it's generic or not and later used to
decide whether to offload.
