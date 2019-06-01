Return-Path: <SRS0=xfQ5=UA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC32C28CC1
	for <linux-crypto@archiver.kernel.org>; Sat,  1 Jun 2019 16:28:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BA0827754
	for <linux-crypto@archiver.kernel.org>; Sat,  1 Jun 2019 16:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559406516;
	bh=uCeN449FLUw2mHtKLIIhlW8Nt7bEVeY3B/gW5PJZFkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=N/RYNS+gdZn9FlNxwrEF5ic0MayZThq9+lUDKTQO+Z7l2JV+JxeraxHV8tf3C1SPQ
	 EQ8T0jPTvnDV2xQHamWz7y/LBIH05WvptjTMPPWTUuewUopPs7ojd8JxRoiuRu13gJ
	 tDwi9QcYZ3id6yDpsnOMnpMRer8KLMdY3nT1fAsE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfFAQ2f (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 1 Jun 2019 12:28:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbfFAQ2f (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Jun 2019 12:28:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09F9D27753;
        Sat,  1 Jun 2019 16:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559406514;
        bh=uCeN449FLUw2mHtKLIIhlW8Nt7bEVeY3B/gW5PJZFkc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2rcZoi7n4RPUgZGfNRdD4taMZFkglYlDMylrrtcd4e6s81N3qduZNetzqkDqV9RCb
         GVP88xTWKW2eMqLzHQ7ysUjHJ0DpD3ix+pcnTqa+BZy6ZpdMMc4aO/gPWinNONFszN
         XGznKgTFhjWRmO3+hRXvOGxD0LdYR+U62OPVPEk0=
Date:   Sat, 1 Jun 2019 18:28:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        tglx@linutronix.de, allison@lohutok.net, alexios.zavras@intel.com,
        swinslow@gmail.com, rfontana@redhat.com,
        linux-spdx@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] crypto: ux500 - fix license comment syntax error
Message-ID: <20190601162831.GA6261@kroah.com>
References: <20190601144943.126995-1-alex_y_xu@yahoo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190601144943.126995-1-alex_y_xu@yahoo.ca>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jun 01, 2019 at 10:49:43AM -0400, Alex Xu (Hello71) wrote:
> Causes error: drivers/crypto/ux500/cryp/Makefile:5: *** missing
> separator.  Stop.
> 
> Fixes: af873fcecef5 ("treewide: Replace GPLv2 boilerplate/reference with
> SPDX - rule 194")
> 
> Signed-off-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
> ---
>  drivers/crypto/ux500/cryp/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Ugh, sorry about that.  Will go queue that up right now.

thanks,

greg k-h
