Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC066C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 13 May 2022 10:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiEMKNz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 May 2022 06:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiEMKNy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 May 2022 06:13:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B8F72E28;
        Fri, 13 May 2022 03:13:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC3DDB82C43;
        Fri, 13 May 2022 10:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00980C34100;
        Fri, 13 May 2022 10:13:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="bHDhDcUv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1652436829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zZ6BudfxP76D6plnuX/SQddqB1tD+iQ/1Sw2mOoHt7Q=;
        b=bHDhDcUvUqsDaev+SziIU0FvvNWTLWVEz+ZGeCiBp+5hV89f/RSmaOtsj0881Dv17mpO/P
        Kuf8N/iQPqFJs4ONZIfnZEWZImWZrJ4vG8lz9Pc90Qe3J6tRkzacgMD0iAKDcApQc5EHGu
        UDztwNZ9dlC6P7k/AOhbbOAykkvvFQg=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d28befee (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 13 May 2022 10:13:49 +0000 (UTC)
Date:   Fri, 13 May 2022 12:13:47 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Dominik Brodowski <linux@dominikbrodowski.net>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] random: credit architectural init the exact amount
Message-ID: <Yn4vW1kvHIfUbl2g@zx2c4.com>
References: <20220512133835.102028-1-Jason@zx2c4.com>
 <Yn34NiJUnZOgK99X@owl.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yn34NiJUnZOgK99X@owl.dominikbrodowski.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Dominik,

On Fri, May 13, 2022 at 08:18:30AM +0200, Dominik Brodowski wrote:
> > -	bool arch_init = true;
> > +	unsigned int i, arch_init;
> 
> Maybe s/arch_init/arch_init_cnt/g to clarify that this is now used as a
> counter?

Good idea. I'll call it arch_bytes, which will make the `* 8` lower down
more obviously doing bytes->bits.

Jason
