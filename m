Return-Path: <SRS0=wJ3R=TO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3560BC04AB4
	for <linux-crypto@archiver.kernel.org>; Tue, 14 May 2019 21:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2F4A20862
	for <linux-crypto@archiver.kernel.org>; Tue, 14 May 2019 21:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557869654;
	bh=yp5vDecb7fjI+ywiWRJ0DWnZe3v5cnUIYIfAnA9p2m0=;
	h=Date:From:To:Subject:References:In-Reply-To:List-ID:From;
	b=wFYf0Z1m+Qw+dzTuNfFoILU8jH2MPCrAqswn2/9IS1Z8Jei0ef00KjwsfYm7HpLZR
	 TLkrlGqYgoEJQQhn581GJDg1Lwh2hni3EMSfHbE1jtB3Cve4qdeCTtiaoiZbxsHrpB
	 qHMDYMtBrOXNBL62NPUT9Xyte+PSchHb/jB1Xf8o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfENVeM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 May 2019 17:34:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbfENVeM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 May 2019 17:34:12 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DBFA20862;
        Tue, 14 May 2019 21:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557869652;
        bh=yp5vDecb7fjI+ywiWRJ0DWnZe3v5cnUIYIfAnA9p2m0=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=v3Nl8+PvRk9oI3IdjpCKGOTljU7wVAzidgmXYqBadBGQ8bveQQOx1zFjPVlX2yeeJ
         TgBN8i9jVo+DislgBiPfKIE3gY8BMmCSfbCK3ReG19mFtfz2DidG22o1mCfBxuWVW3
         oR/Qqscim7fPTarMugC2eu8kv9AWq3wJVQQzyvPU=
Date:   Tue, 14 May 2019 14:34:10 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     dsterba@suse.cz, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Can crypto API provide information about hw acceleration?
Message-ID: <20190514213409.GA115510@gmail.com>
References: <20190514163348.GM3138@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514163348.GM3138@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 14, 2019 at 06:33:48PM +0200, David Sterba wrote:
> Hi,
> 
> Q: is there a way to query the crypto layer whether a given algorithm
> (digest, crypto) is accelerated by the driver?
> 
> This information can be used to decide if eg. a checksum should can be
> calculated right away or offloaded to a thread. This is done in btrfs,
> (fs/btrfs/disk-io.c:check_async_write).
> 
> At this moment it contains a static check for a cpu feature, and only
> for x86. I briefly searched the arch/ directory for implementations of
> crc32c that possibly use hw aid and there are several of them. Adding a
> static check a-la x86 for the other architectures (arm, ppc, mips,
> sparc, s390) is wrong, so I'm looking for a clean solution.
> 
> The struct shash_alg definition of the algorithms does not say anything
> about the acceleration. The closest thing is the cra_priority, but I
> don't know if this is reliable information. The default implementations
> seem to have 100, and acceleated 200 or 300.
> 
> This would be probably sufficient, but I'd like a confirmation from
> crypto people.
> 

There's only one default implementation of crc32c, not multiple, and it has
priority 100.  All other crc32c implementations have priority > 100.  So yes,
you can check the priority (which would require adding a function to
lib/libcrc32c.c to get it).  Alternatively you could check whether the driver
name is "crc32c-generic" or not.

- Eric
