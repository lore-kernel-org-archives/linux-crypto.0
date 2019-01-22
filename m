Return-Path: <SRS0=98p2=P6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B77C9C282C4
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 12:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F7D221019
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 12:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548160853;
	bh=Nt/KFXkMFf5rJjWveK8LpeImMAzvq4xFOjgjObeR1EY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=SWBT8BR3A1dgM5mSPOSvDmDYDQG9ysipgoePuXHIpKd2D/i337XwMW/UBu0f6D6s4
	 yPY1HOo2QK22Oc1pqSsPUO5hoo1vXHnRz+cjvLthE8vXTLVEpqUBCPvNYOTnqZwADR
	 UDmrAM41WKZAqV+DMU19WvSLuZeoNb7//ZJTyHOY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbfAVMks (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jan 2019 07:40:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbfAVMkr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jan 2019 07:40:47 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACEDA20870;
        Tue, 22 Jan 2019 12:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548160847;
        bh=Nt/KFXkMFf5rJjWveK8LpeImMAzvq4xFOjgjObeR1EY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E+Vj25W+EVu0Zh3sPQXh5/XJPwJN9y/EZINOeXqj/Ps8Yyykpw0i5TeGz8XMxWD/Z
         UJyMQ79ouz79WcSwsu3jktWoCgRgAa2B14hRa0NqvqxjBkUH5fwPaZw7pzReZLbDXR
         BtsmAfyUphhfCFqiYP5SB8etsAnN4Zsj9yOeCTXE=
Date:   Tue, 22 Jan 2019 13:40:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v25 0/6] Add io{read|write}64 to io-64-atomic headers
Message-ID: <20190122124044.GA11753@kroah.com>
References: <20190116182523.19446-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190116182523.19446-1-logang@deltatee.com>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 16, 2019 at 11:25:17AM -0700, Logan Gunthorpe wrote:
> This is resend number 6 since the last change to this series.
> 
> This cleanup was requested by Greg KH back in June of 2017. I've resent the series
> a couple times a cycle since then, updating and fixing as feedback was slowly
> recieved some patches were alread accepted by specific arches. In June 2018,
> Andrew picked the remainder of this up and it was in linux-next for a
> couple weeks. There were a couple problems that were identified and addressed
> back then and I'd really like to get the ball rolling again. A year
> and a half of sending this without much feedback is far too long.
> 
> @Andrew, can you please pick this set up again so it can get into
> linux-next? Or let me know if there's something else I should be doing.

version 25?  That's crazy, this has gone on too long.  I've taken this
into my char/misc driver tree now, so sorry for the long suffering you
have gone through for this.

Thanks for being persistent,

greg k-h
