Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4909BC43331
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 02:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15B9A2087E
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 02:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573179225;
	bh=1KFbirskEXIU/c7xK5k4i25uPFEg3vr7Nv4LYuZca9A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=OliiqymwOzTKVNujORK5Xfg2Pv3XeXlVpGyL/j2hPP3rOuXMXHdVRJXWUZwNf5G/N
	 b8V70pCjr1jeCIM8vB44N9iOcWGaMe3n0x5SnY0fJxNweeVBBzOGe9iPIZqwHCuvqN
	 TZ3jDLNtyeIkM6k69/8JN18BgizCFnE9cv3+feOs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbfKHCNn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Nov 2019 21:13:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:39412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbfKHCNn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Nov 2019 21:13:43 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F14CC2084C;
        Fri,  8 Nov 2019 02:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573179223;
        bh=1KFbirskEXIU/c7xK5k4i25uPFEg3vr7Nv4LYuZca9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y4DRw94wfgV1sEZaPNo3GxfntawACQM6fSfmIlK6cbWcChXhS6TnhaV4ttEwSfO24
         il+c2/CNhYwIm8FC0NBfl0rcINoa0FPn/c/DJw8z1NNz13tfrJoaEQ8VVAZBAAWnpk
         dLarO1SP1V0JKAjpBaAO8JcQW1PAINLffNmnMUsA=
Date:   Thu, 7 Nov 2019 18:13:29 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/7] BLAKE2b cleanups
Message-ID: <20191108021329.GA1140@sol.localdomain>
Mail-Followup-To: David Sterba <dsterba@suse.com>,
        linux-crypto@vger.kernel.org
References: <cover.1573047517.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1573047517.git.dsterba@suse.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 06, 2019 at 02:48:24PM +0100, David Sterba wrote:
> Hi,
> 
> the patchset implements cleanups suggested by Eric in
> https://lore.kernel.org/linux-crypto/20191025051550.GA103313@sol.localdomain/
> 
> The diff is the same, split into pieces with some additional comments
> where it would help understand the simplifications. This is based on v7
> of the BLAKE2b patchset.
> 

Actually the diff isn't quite the same.  Your version looks fine though, except
that I think digest_setkey() should be renamed to blake2b_setkey().  Otherwise
it's inconsistent, since all the other digest_*() functions were renamed.

Thanks!

- Eric
