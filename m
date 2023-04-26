Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D691C77B60
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Apr 2023 13:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240500AbjDZNsa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Apr 2023 09:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240277AbjDZNs3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Apr 2023 09:48:29 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3644E4EED;
        Wed, 26 Apr 2023 06:48:27 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id CDA371C0AAC; Wed, 26 Apr 2023 15:48:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1682516904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vobIZzsu6G/ruKba7Fcr/sNGHFKo94RsPgCWSvtPggw=;
        b=EnUnI12wJod78pbZUXWy+B2EbuDd+pFb6VuuVRLCVZmzO2x89Z0qyd4gQs+dSGNNPiz3GO
        NyEJA6fsoybJSVPvUxkrXvOYBxRQx6KNrBa8syfTLTFKzjBwMXSfAS/GSaHjEjsfXPl66m
        JG3AW6zRt9J+y48qJgu4+Y82HP2wZxA=
Date:   Wed, 26 Apr 2023 15:47:19 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        John Allen <john.allen@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] Add dynamic boost control support
Message-ID: <ZEkrZ83fFwiweCTz@localhost>
References: <20230420163140.14940-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420163140.14940-1-mario.limonciello@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi!

> Dynamic boost control is a feature of some SoCs that allows
> an authenticated entity to send commands to the security processor
> to control certain SOC characteristics with the intention to improve
> performance.
> 
> This is implemented via a mechanism that a userspace application would
> authenticate using a nonce and key exchange over an IOCTL interface.
> 
> After authentication is complete an application can exchange signed
> messages with the security processor and both ends can validate the
> data transmitted.

Why is this acceptable? This precludes cross-platform interfaces,
right? Why would application want to validate data from PSP? That
precludes virtualization, right?

Just put the key in kernel. Users have right to control their own
hardware.
							Pavel

-- 
