Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19296C636C9
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 14:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1BD6613C0
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Jul 2021 14:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhGQOPx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Jul 2021 10:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230003AbhGQOPx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Jul 2021 10:15:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46A2F613AF;
        Sat, 17 Jul 2021 14:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626531176;
        bh=CSqWbwnDQetPqNrqCiyqzlstecp4z8aojSFR6OWBeHE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YHLfkMcAhW3q0tcYt29I0fGtfM8rUS64uVWbUwB5VV+prO+xo4gSkNp9iKpSUor6i
         qnRdzGnj+0clXdYsYPm5HRi25jueLTd8oz8SBGzbUIFWjRwH4hGJHwTcoMpppgLyE7
         jWSXpogKnu84n0PF6KNtBKUkdg1eimerDyBLg35Kue4cKTjYGhzbYHWgsIOaOUct9Y
         CkrEMNpX0AfmcjezQI5rarlr3kXL0D5KeF45aLFdUMomXnn8eKj4CJ99scEmZWxRDg
         csikWLEha5YOSJmMmuH89qBzHdweUWLXw6PBo0yKu25SUJ2NL1/wa9aT7CxiqRXfEZ
         OqLm3kFhs1wTQ==
Date:   Sat, 17 Jul 2021 09:12:54 -0500
From:   Eric Biggers <ebiggers@kernel.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 04/11] lib/base64: RFC4648-compliant base64 encoding
Message-ID: <YPLlZvVTMvjs8UGu@quark.localdomain>
References: <20210716110428.9727-1-hare@suse.de>
 <20210716110428.9727-5-hare@suse.de>
 <a6708951-76f6-21bb-f7fe-e4bb32cd0448@grimberg.me>
 <7f320b51-1077-9b3f-bf29-49d0753adf6c@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f320b51-1077-9b3f-bf29-49d0753adf6c@suse.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jul 17, 2021 at 04:00:20PM +0200, Hannes Reinecke wrote:
> On 7/17/21 8:16 AM, Sagi Grimberg wrote:
> > 
> > > Add RFC4648-compliant base64 encoding and decoding routines.
> > 
> > Looks good to me (although didn't look in the logic itself).
> > Can you maybe mention where was this taken from?
> 
> Umm ... yeah, I guess I can; I _think_ I've copied it from base64 routines
> in fs/crypto/fname.c, but I'll check.
> 

Note that it wasn't simply a copy, as you changed the variant of base64 that is
implemented.  So please make sure that you are very clear about which variant of
base64 it is, and update all the comments accordingly.

- Eric
