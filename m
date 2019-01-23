Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6789FC282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 06:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C7BE217F5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 06:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548226560;
	bh=Tkc7rDSg0QL9HPWws+CpjjP/yX9Rh5dgxYMvX3gFKcM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=xAXtUbUDb38/6pglgoV9XR2zRKF1YNZ1IauRtxQn9cablUwhaSpBEvwcDoqGwzs8P
	 cP+9CaowgLXt/DciB+SAEqqPkHoN5ZMVnyufN0XfzTt/UfoUOBQmk9vhulxCfs2aUT
	 MpNF4xuHlpkchP/VBNAsk0byFjgV24lQ2nddmLTk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfAWGz7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 01:55:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbfAWGz7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 01:55:59 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25D4D21726;
        Wed, 23 Jan 2019 06:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548226558;
        bh=Tkc7rDSg0QL9HPWws+CpjjP/yX9Rh5dgxYMvX3gFKcM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BD9ZPS0GCmz2ebBY5F5QXoOaL6L0rB/hPQynCnJO88TeuQR7cvjAS3DiKqUlTfAOp
         gMve2T0zfJ1gcE2nmDxO9lcVDGWqs5sh1hIgTnDQg0eDly0FiWNugG5m4GkJ+rQWpx
         HxCERsV9y7I8IVkg54qYUGQVaEtIpGIkD1JjYX6s=
Date:   Wed, 23 Jan 2019 07:55:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Gary R Hook <ghook@amd.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>
Subject: Re: [PATCH 6/7] crypto: ccp: no need to check return value of
 debugfs_create functions
Message-ID: <20190123065556.GB27466@kroah.com>
References: <20190122151422.14204-1-gregkh@linuxfoundation.org>
 <20190122151422.14204-7-gregkh@linuxfoundation.org>
 <1330d284-560a-5e09-6d15-50da354d0da2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330d284-560a-5e09-6d15-50da354d0da2@amd.com>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 22, 2019 at 10:06:54PM +0000, Gary R Hook wrote:
> On 1/22/19 9:14 AM, Greg Kroah-Hartman wrote:
> > When calling debugfs functions, there is no need to ever check the
> > return value.  The function can work or not, but the code logic should
> > never do something different based on this.
> 
> Stupid question(s) time.
> 
> If we don't care about failures (because the subsystem handles them 
> without our involvement) why do these functions even have return values? 
> Why haven't they been changed to void so that they reflect the current 
> style of intended use?

Because on "normal" operations, you use the return value for something
(i.e. a parent directory to pass to other functions, or a value so you
can remove the file later).

> I realize I'm old fashioned, but if a failure occurs, I've always been 
> of a mind to kick out and not try to do any further work. But debugfs is 
> to be treated as an exception to that paradigm? Carry on, ignore errors, 
> don't worry about it?

Yes, that is the case here, it goes against what everyone normally
thinks about kernel development :)

thanks,

greg k-h
