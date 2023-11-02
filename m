Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D1BC4332F
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Nov 2023 11:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjKBLaM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Nov 2023 07:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjKBLaL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Nov 2023 07:30:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C73419D;
        Thu,  2 Nov 2023 04:30:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E6BC433C8;
        Thu,  2 Nov 2023 11:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1698924602;
        bh=4DNk2VUEvgSWKLNkH95u/woAYm/KFEWzwGpl1fZbsM8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aHopZP2BLY3h0tOiaWpblDzevOK201BQDTmgkvYoVjLPNzU76iLhYJL5QkZmoWmnN
         D9pgWQvEeQU8M9YiEJMp3jVtlAWi8008jzX2AmUNeha27z+tPAoq5HhfTZAXfD97LT
         uCefay+zDd8llAm+5o0viy+wEOQ0LZp0TOZOdvb0=
Date:   Thu, 2 Nov 2023 12:29:50 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexander Graf <graf@amazon.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Olivia Mackall <olivia@selenic.com>,
        Petre Eftime <petre.eftime@gmail.com>,
        Erdem Meydanlli <meydanli@amazon.nl>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH v7] misc: Add Nitro Secure Module driver
Message-ID: <2023110207-payphone-unlit-8590@gregkh>
References: <20231011213522.51781-1-graf@amazon.com>
 <6b836c66-dbbf-417f-8fbe-dfd67f464a64@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b836c66-dbbf-417f-8fbe-dfd67f464a64@amazon.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 02, 2023 at 10:54:34AM +0100, Alexander Graf wrote:
> On 11.10.23 23:35, Alexander Graf wrote:
> > When running Linux inside a Nitro Enclave, the hypervisor provides a
> > special virtio device called "Nitro Security Module" (NSM). This device
> > has 3 main functions:
> > 
> >    1) Provide attestation reports
> >    2) Modify PCR state
> >    3) Provide entropy
> > 
> > This patch adds a driver for NSM that exposes a /dev/nsm device node which
> > user space can issue an ioctl on this device with raw NSM CBOR formatted
> > commands to request attestation documents, influence PCR states, read
> > entropy and enumerate status of the device. In addition, the driver
> > implements a hwrng backend.
> > 
> > Originally-by: Petre Eftime <petre.eftime@gmail.com>
> > Signed-off-by: Alexander Graf <graf@amazon.com>
> 
> 
> Ping for inclusion? I haven't seen any further comments on v7 of this patch,
> so I'd assume it's good to go? :)

Ah, I thought there would be a new version for some reason, sorry about
that.  I'll review it after -rc1 is out, in the middle of the merge
window right now, I can't add anything to my trees, but new drivers can
always be added after that.

thanks,

greg k-h
