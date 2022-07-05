Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 179A4C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 18:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiGESTX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jul 2022 14:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGESTV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jul 2022 14:19:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFBF13EB0;
        Tue,  5 Jul 2022 11:19:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F5C6B818C2;
        Tue,  5 Jul 2022 18:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D908C341C7;
        Tue,  5 Jul 2022 18:19:16 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gdFk/u3c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657045154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=042acYZNRqutxCTZso2/xN/cDh3Bzh4OrsVvre+rL7Y=;
        b=gdFk/u3cCxNOKBPwOJGXbzlvqbS366vUCluM0yvGbgJ0q2tKfF2wGEbiAT6uT48avV21d0
        BcZsx1rNX32k4WkRjPUoqEXDpWcmW36vRkQRmQD1Wg9T9XwBK9oF+6TwRWpzivgH5rXzRi
        jEPNZrR4ZCN+8vl9cAI0QpiO1clOzao=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 53dff522 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 5 Jul 2022 18:19:13 +0000 (UTC)
Date:   Tue, 5 Jul 2022 20:19:11 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Holger Dengler <dengler@linux.ibm.com>
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Juergen Christ <jchrist@linux.ibm.com>,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] s390/arch_random: Buffer true random data
Message-ID: <YsSAn2qXqlFkS5sH@zx2c4.com>
References: <20220705112712.4433-1-dengler@linux.ibm.com>
 <20220705112712.4433-2-dengler@linux.ibm.com>
 <YsQ6OOrOWPhdynoM@zx2c4.com>
 <9a0561c0-68f7-b630-4440-3ca32bf28dc2@linux.ibm.com>
 <YsRUowTs9n98p9EL@zx2c4.com>
 <aafbb400-d0cb-99de-8b10-3c39c7b9bae5@linux.ibm.com>
 <YsRoXObdpCNbtpHS@zx2c4.com>
 <30e681b2-a411-cdb1-4b46-243db25abeef@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <30e681b2-a411-cdb1-4b46-243db25abeef@linux.ibm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hey Holger,

On Tue, Jul 05, 2022 at 07:47:37PM +0200, Holger Dengler wrote:
> A trng call runs for minimal ~20-190us for 32 bytes. 20us on newer
> machine generations, 190us on older ones. These are not 100% exact
> measurements, but the dimension should be correct.

Holy smokes. Yea, okay, I see what you're saying. So indeed it sounds
like the `!in_hardirq()` addition would be a good idea. Let's do that.

Also, I noticed that the TRNG has a hwrng driver. That means the RNG
will still be getting continuous input from it in a kthread, not an
interrupt handler, so from a crypto PoV, we're not really losing /that/
much by adding the `!in_hardirq()` clause. So all and all, that seems
like the simplest solution without too big of a downside.

Jason
