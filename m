Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF469C433F5
	for <linux-crypto@archiver.kernel.org>; Sun, 15 May 2022 10:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbiEOKRV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 May 2022 06:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236253AbiEOKRU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 May 2022 06:17:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C243017A8E;
        Sun, 15 May 2022 03:17:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA76F60EC6;
        Sun, 15 May 2022 10:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECA0C385B8;
        Sun, 15 May 2022 10:17:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Y4NvPVhN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1652609836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0o2sK9SiTyazcAoY3sQ2kelM8l35xwqcMUnMwIMkSWY=;
        b=Y4NvPVhNyzUERLxKCPVU/603iJX2SN5RYATdy5+npvykSCz1EjVvdLECgcirQkwT/DN3D8
        2CHg5I4Taa6eNMkUpPzm3PlYqu7v/loBIldAJBHa6yd0ZCzZ2jrUReklnDMWqDoAPNKr30
        pm9D/k0kvNxwJe3Wu8KZo6jW/M61NCs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 646f83ef (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sun, 15 May 2022 10:17:15 +0000 (UTC)
Date:   Sun, 15 May 2022 12:17:13 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] random: do not pretend to handle premature next security
 model
Message-ID: <YoDTKTxrCXnIxDyJ@zx2c4.com>
References: <20220504113025.285784-1-Jason@zx2c4.com>
 <YntvKcp5PYDUKoFE@sol.localdomain>
 <YnuQlIOuOy7nHvSr@zx2c4.com>
 <YoBNHEqeNahziJt5@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YoBNHEqeNahziJt5@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

On Sat, May 14, 2022 at 05:45:16PM -0700, Eric Biggers wrote:
> On Wed, May 11, 2022 at 12:32:19PM +0200, Jason A. Donenfeld wrote:
> > Hi Eric,
> > 
> > On Wed, May 11, 2022 at 01:09:13AM -0700, Eric Biggers wrote:
> > > A couple very minor comments:
> > 
> > Thanks, will fix these.
> > 
> > Jason
> 
> Found one more:
> 
>  /*
>   * Return whether the crng seed is considered to be sufficiently
>   * old that a reseeding might be attempted.
> 
> It should say "that a reseeding is needed", or something similar.

Ahh, since it's now unconditional. Nice catch. Fixed as you suggested.

Jason
