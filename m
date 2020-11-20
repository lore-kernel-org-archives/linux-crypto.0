Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33728C2D0E4
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 18:53:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4C202242B
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 18:53:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="n5W8DqB0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731956AbgKTSwi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Nov 2020 13:52:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:34338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731852AbgKTSwh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Nov 2020 13:52:37 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 641C72242B;
        Fri, 20 Nov 2020 18:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605898357;
        bh=hLPZb8iExdwklsyXpivIHTZH7cu3MZVNRHIV7AOiAXM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n5W8DqB0dy27EIrepwTa0pzByFN1uYe4L3XjSaVw9nUpAv7UAkGo39AlKRx9MwrMm
         mR7XTUZZRjX3VU3r70ypKcQpOkEQ5XykpQdOFMN0KTnnjfHSjrVfjd+zsEtsQMUszo
         h3w31apWVM2vp5rioX0tnSdekkRC6XPvRYtu9bKI=
Date:   Fri, 20 Nov 2020 10:52:35 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] random: remove dead code left over from blocking pool
Message-ID: <X7gQc1IrC18+WBST@sol.localdomain>
References: <20200916043652.96640-1-ebiggers@kernel.org>
 <20201007035058.GC912@sol.localdomain>
 <20201026163403.GC858@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026163403.GC858@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 26, 2020 at 09:34:03AM -0700, Eric Biggers wrote:
> On Tue, Oct 06, 2020 at 08:50:58PM -0700, Eric Biggers wrote:
> > On Tue, Sep 15, 2020 at 09:36:52PM -0700, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > Remove some dead code that was left over following commit 90ea1c6436d2
> > > ("random: remove the blocking pool").
> > > 
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > 
> > Ping?
> 
> Ping.

Ping.
