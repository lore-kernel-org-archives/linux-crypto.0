Return-Path: <SRS0=EVKT=6F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3F4C54FCC
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 14:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B29E0206B8
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 14:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgDUOJx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Apr 2020 10:09:53 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:37769 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728316AbgDUOJx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Apr 2020 10:09:53 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 49656h5krGz9sT6; Wed, 22 Apr 2020 00:09:46 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: d53979b589609d87036d8daf9500f7eccb0c6317
In-Reply-To: <20200420205538.25181-2-rzinsly@linux.ibm.com>
To:     Raphael Moreira Zinsly <rzinsly@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        dja@axtens.net
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     abali@us.ibm.com, haren@linux.ibm.com, herbert@gondor.apana.org.au,
        rzinsly@linux.ibm.com
Subject: Re: [PATCH V4 1/5] selftests/powerpc: Add header files for GZIP engine test
Message-Id: <49656h5krGz9sT6@ozlabs.org>
Date:   Wed, 22 Apr 2020 00:09:46 +1000 (AEST)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 2020-04-20 at 20:55:34 UTC, Raphael Moreira Zinsly wrote:
> Add files to access the powerpc NX-GZIP engine in user space.
> 
> Signed-off-by: Bulent Abali <abali@us.ibm.com>
> Signed-off-by: Raphael Moreira Zinsly <rzinsly@linux.ibm.com>

Series applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/d53979b589609d87036d8daf9500f7eccb0c6317

cheers
