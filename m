Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 281D7C4332F
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Nov 2022 11:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbiKGLSO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Nov 2022 06:18:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiKGLSN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Nov 2022 06:18:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C7AB1F5
        for <linux-crypto@vger.kernel.org>; Mon,  7 Nov 2022 03:18:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3310EB80E15
        for <linux-crypto@vger.kernel.org>; Mon,  7 Nov 2022 11:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1B7C433C1;
        Mon,  7 Nov 2022 11:18:09 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="SjDbBwDa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667819887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s7U86p4AtvwDins/lcZYBv//WqfDek01ql6jIET96E4=;
        b=SjDbBwDaxhyjBcKA+KlTxh+/it5r/XSlZWhFUqZuOKzyZcBsxPP88sFLaOb7Nk6N7zqCo7
        TjLjC6c5iJLs9+xVUAxdYUs0hTepi/UVrE6jivMK0YC6xTlpPIkjigqnNOrYfhjFrLjPCS
        EwqghD0ttB7ElvWXNtkZgiNqX57cSOU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0dd01ac2 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 7 Nov 2022 11:18:06 +0000 (UTC)
Date:   Mon, 7 Nov 2022 12:18:04 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Harald Freudenberger <freude@linux.ibm.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Holger Dengler <dengler@linux.ibm.com>
Subject: Re: [PATCH] hw_random: treat default_quality as a maximum and
 default to 1024
Message-ID: <Y2jpbDnEqlOT6RoB@zx2c4.com>
References: <20221104154230.52836-1-Jason@zx2c4.com>
 <a0863b503b22b42fb8129b6847188a2e@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a0863b503b22b42fb8129b6847188a2e@linux.ibm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Harald,

On Mon, Nov 07, 2022 at 10:24:42AM +0100, Harald Freudenberger wrote:
> Well, I am not sure if this is the right way to go. So by default a
> hw rng which does not implement the registration correctly is
> rewarded with the implicit assumption that it produces 100% of
> entropy.
> I see your point - a grep through the kernel code gives the impression
> that a whole bunch of registrations is done with an empty quality
> field. What about assuming a default quality of 50% if the field
> is not filled ?

The vast majority of hardware RNGs do *not* work this way. The
reasonable assumption is to assume that a hardware RNG provides fully
random bits, unless the documentation leads the driver author to specify
something less.

Really, just quit with all the nutty mailing list stuff here. Next: "how
about 74.4% because that matches the vibrations of cedar trees"... If
you want this to be different on a particular kernel, you can set your
exact value as a command line. This patch here is simply about a
sensible default.

Jason
