Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C7DC4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Feb 2022 20:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbiBVUvv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Feb 2022 15:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233936AbiBVUvs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Feb 2022 15:51:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6014EA9A5D;
        Tue, 22 Feb 2022 12:51:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06A71B81C65;
        Tue, 22 Feb 2022 20:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE34BC340E8;
        Tue, 22 Feb 2022 20:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645563079;
        bh=yFCTKtU4S4kZ8VG3SPDKnuEe4TM3uJOIlCjMCkPGssY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H7P1MrpmNd4yRIrwLKQqnRJhf/+Nw7ooVt64h4odrPcEbm9dIEoo7G7m/XHIUcbA/
         mWm5n1oaEWH24ZukQHiQmeFv06NgG2XuJHfVdC3QkVFRHha0PrWsqHmrOdVPmuHlsO
         HIaYK8KKt+B7kXPfSm0gG7H0kZzO4hbmiV35Xxgixu1LTmuW9ijHHkaxNu4cqeFkgo
         X3ZsNxuAKB3K1BwNNV0kLFERkrfG8TYr7fx74VmwKsaSMZsWkM+2RJ3ocx7ZvyLZkJ
         lLTu34xFakBrtBDyGB9NccLleSss8Xliz40wOrGVzMOu5P9qM6TQ9ik92k0t9Tm2NT
         9CAKcY/qyrvSg==
Date:   Tue, 22 Feb 2022 12:51:16 -0800
From:   Keith Busch <kbusch@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     David Laight <David.Laight@aculab.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "colyli@suse.de" <colyli@suse.de>
Subject: Re: [PATCHv3 10/10] x86/crypto: add pclmul acceleration for crc64
Message-ID: <20220222205116.GB1782741@dhcp-10-100-145-180.wdc.com>
References: <20220222163144.1782447-1-kbusch@kernel.org>
 <20220222163144.1782447-11-kbusch@kernel.org>
 <a7e806ed3c074534a24b74f827bcc914@AcuMS.aculab.com>
 <20220222171405.GA1782521@dhcp-10-100-145-180.wdc.com>
 <YhVCTzUOUHZnze4x@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhVCTzUOUHZnze4x@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 22, 2022 at 12:06:39PM -0800, Eric Biggers wrote:
> Is the license of that code compatible with the kernel's license?

It's released into "public domain", so I assume we can leverage it into
GPL licenced code. I don't have similar past experiences with this
scenario, so please correct me if I'm mistaken.
 
> In any case, adding uncommented generated assembly isn't acceptable.  The most
> common convention for Linux kernel crypto is to use hand-written assembly that
> is properly commented.
>
> There is some precedent for using compiler intrinsics instead, e.g.
> crypto/aegis128-neon-inner.c.  (I'm not sure why they aren't used more often.)
>
> There are also some files where a Perl script generates the assembly code.
> (This is a bit ugly IMO, but it's what the author of much of OpenSSL's crypto
> assembly code does, and it was desired to reuse that code.)
> 
> Anyway, those are the available options.  Checking in some uncommented generated
> assembly isn't one of them.

Fair enough. I'll find help from someone to author an appropriate form
to replace this patch.
