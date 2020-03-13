Return-Path: <SRS0=jmhz=46=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C565C2BB1D
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Mar 2020 10:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EBCE2074A
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Mar 2020 10:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584094165;
	bh=OLUkYJPLG0GeMB/64wQPZjV9SINc2e6iDAaKGjnf6AQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=A6SdrH7R5OkV5PVYfhgFqns8LKcvV+MQsj9/L3U0z2kDv2RwKfHyhwONhUgOY8Mgw
	 X7wkbXO/L73fdcp5fNgxyaO/K45fxQY8yVA+a6CPf/ok/ejUa5oSqTAElom6D7OU8n
	 IJVvBFFNxrefSJnZgtKaqv/BRmGea1oSPvy4iUUA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgCMKJZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Mar 2020 06:09:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgCMKJY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Mar 2020 06:09:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3D8D206E7;
        Fri, 13 Mar 2020 10:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584094164;
        bh=OLUkYJPLG0GeMB/64wQPZjV9SINc2e6iDAaKGjnf6AQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b4sph3o3dfes/f2mLF8fnX+PQaBtKrv/bnfXZezZyCuUPM9g67AIjVSbvrmRjGTPG
         oz4Y9rlbGnJgzyJ0P4s0PXORkDJeUBJ9tLObcA8G87FPtKrCQJpO6osrH3Lj3/ssd0
         iI8paWdLL3PZ9S1bGu84uQDHXS7UdifI19R8xP6k=
Date:   Fri, 13 Mar 2020 11:09:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Kim, David" <david.kim@ncipher.com>
Cc:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Magee, Tim" <tim.magee@ncipher.com>
Subject: Re: nCipher HSM kernel driver submission feedback request
Message-ID: <20200313100922.GB2161605@kroah.com>
References: <1584092894266.92323@ncipher.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584092894266.92323@ncipher.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 13, 2020 at 09:48:14AM +0000, Kim, David wrote:
> Hi Herbert,
> 
> We've been working on getting this driver code upstreamed into drivers/misc since the end of last
> year but things stalled a bit on our end. However, we are still interested in getting our submission
> approved and would please like your assistance and feedback on this.
> 
> The driver code for the hardware is straightforward and does not contain any cryptographic
> components as the cryptography is handled within the hardware's secure boundary. We have no
> plans to use the linux kernel crypto APIs as our customers require compliance to the FIPS 140
> standard or the eIDAS regulations.

But what I said was, you NEED to use the linux kernel crypto apis as you
need to not try to create your own.

Just because this is the way you did it before, does not mean it is the
correct thing to do.

So what is wrong if you do use the existing apis?  What is preventing
you from doing that?

thanks,

greg k-h
