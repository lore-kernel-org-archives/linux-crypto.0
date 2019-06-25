Return-Path: <SRS0=EEB8=UY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CFD1C48BD4
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 13:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0957D20644
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 13:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfFYNww (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jun 2019 09:52:52 -0400
Received: from ms.lwn.net ([45.79.88.28]:60692 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbfFYNww (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jun 2019 09:52:52 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id BC37130A;
        Tue, 25 Jun 2019 13:52:51 +0000 (UTC)
Date:   Tue, 25 Jun 2019 07:52:50 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Gary R Hook <ghook@amd.com>
Cc:     Joe Perches <joe@perches.com>, "Hook, Gary" <Gary.Hook@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 0/3] Clean up crypto documentation
Message-ID: <20190625075250.3a912863@lwn.net>
In-Reply-To: <d0803cdf-e4d8-102a-d67f-d3a32a4dfff0@amd.com>
References: <156140322426.29777.8610751479936722967.stgit@taos>
        <23a5979082c89d7028409ad9ae082840411e1ca6.camel@perches.com>
        <d8b359ff-5891-7bb8-d292-9f10cca04f17@amd.com>
        <977bc7c484ef55ff78de51d7555afcc3c3350b1e.camel@perches.com>
        <20190624143748.7fcfe623@lwn.net>
        <d0803cdf-e4d8-102a-d67f-d3a32a4dfff0@amd.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 25 Jun 2019 13:33:27 +0000
Gary R Hook <ghook@amd.com> wrote:

> > It's been "valid" since I wrote it...it's just not upstream yet :)  I
> > expect it to be in 5.3, though.  So the best way to refer to a kernel
> > function, going forward, is just function() with no markup needed.  
> 
> So I'm unclear:
> 
> 1) would you prefer I wait on your 5.3 change being fully committed,
> 2) add your change to my local tree and use it, then submit an update 
> patchset that depends upon it, or
> 3) re-submit now (using the current method) with suggested changes?

I would just not mark up function() at all, and the right thing will
happen to it in the very near future.

Thanks,

jon
