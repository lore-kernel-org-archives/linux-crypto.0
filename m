Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1345FC43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 20:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD20C20665
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 20:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbfFXUhu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 16:37:50 -0400
Received: from ms.lwn.net ([45.79.88.28]:45466 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbfFXUhu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 16:37:50 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 808AD35A;
        Mon, 24 Jun 2019 20:37:49 +0000 (UTC)
Date:   Mon, 24 Jun 2019 14:37:48 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Joe Perches <joe@perches.com>
Cc:     Gary R Hook <ghook@amd.com>, "Hook, Gary" <Gary.Hook@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 0/3] Clean up crypto documentation
Message-ID: <20190624143748.7fcfe623@lwn.net>
In-Reply-To: <977bc7c484ef55ff78de51d7555afcc3c3350b1e.camel@perches.com>
References: <156140322426.29777.8610751479936722967.stgit@taos>
        <23a5979082c89d7028409ad9ae082840411e1ca6.camel@perches.com>
        <d8b359ff-5891-7bb8-d292-9f10cca04f17@amd.com>
        <977bc7c484ef55ff78de51d7555afcc3c3350b1e.camel@perches.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 24 Jun 2019 13:29:42 -0700
Joe Perches <joe@perches.com> wrote:

> > Finally, would you prefer a v2 of the patch set? Happy to do
> > whatever is preferred, of course.  
> 
> Whatever Jonathan decides is fine with me.
> Mine was just a plea to avoid unnecessarily
> making the source text harder to read as
> that's what I mostly use.

Usually Herbert seems to take crypto docs, so it's not necessarily up to
me :)

I don't see much that's objectionable here.  But...

> I don't know if this extension is valid yet, but
> I believe just using <function_name>() is more
> readable as text than ``<function_name>`` or
> :c:func:`<function_name>`

It's been "valid" since I wrote it...it's just not upstream yet :)  I
expect it to be in 5.3, though.  So the best way to refer to a kernel
function, going forward, is just function() with no markup needed.

Thanks,

jon
