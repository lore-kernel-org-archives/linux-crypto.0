Return-Path: <SRS0=m/1o=EG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F94C388F7
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 21:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A36D20731
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 21:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604178037;
	bh=yssWbUwDVJcZPWfmz3jy+6AwfCVsx+dhjmWlIITords=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=dVhH0Raq3zQaqJ+xHoaSZRxYlO94xTpfPs9BZMvHk19N/vGDKQOmaQnlgRet1mBoE
	 m6l2J41fHgWiDzdPXnajKAWLWidQIhuYSDxmxXip+8o1zss1p6awYCc+W/p/egazXg
	 GX0KMaGxyC72FW8vuf4tdCSq8ZGK+O/AoI8iiqoU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgJaVAg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Oct 2020 17:00:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgJaVAg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Oct 2020 17:00:36 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C2C7206DD;
        Sat, 31 Oct 2020 21:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604178035;
        bh=yssWbUwDVJcZPWfmz3jy+6AwfCVsx+dhjmWlIITords=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d0BkMDeTEwfx2PZQTUcxJLbCWP0F1HOJ7PvyTC7LSUtEnFtapqZFFGRxXNM+D9rDV
         e4ptnn/yUpb3SYfNjHmbAXs3DE2xoqoyUIvE31WMGW/H56uKDc9dU6hLXYr3TLnT4I
         CFySUNIpbJnFW0hM8+TmXCOTqHY015zNNuiqUBMk=
Date:   Sat, 31 Oct 2020 14:00:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Srujana Challa <schalla@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-crypto@vger.kernel.org, sgoutham@marvell.com,
        gakula@marvell.com, sbhatta@marvell.com, schandran@marvell.com,
        pathreya@marvell.com
Subject: Re: [PATCH v8,net-next,00/12] Add Support for Marvell OcteonTX2
Message-ID: <20201031140034.4af041ee@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CA+FuTSc9KJg+MSWvXDCMaNSMkXxxKEW6JkDa9wNvQ9xg_7RS5Q@mail.gmail.com>
References: <20201028145015.19212-1-schalla@marvell.com>
        <CA+FuTSc9KJg+MSWvXDCMaNSMkXxxKEW6JkDa9wNvQ9xg_7RS5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 31 Oct 2020 15:28:59 -0400 Willem de Bruijn wrote:
> The point about parsing tar files remains open. In general error-prone
> parsing is better left to userspace.

The tar files have to go. Srujana said they have 3 files to load, 
just load them individually.
