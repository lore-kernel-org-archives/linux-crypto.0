Return-Path: <SRS0=lMhp=YI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 032BBECE588
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 18:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB3F720854
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 18:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfJOS13 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Oct 2019 14:27:29 -0400
Received: from ms.lwn.net ([45.79.88.28]:36136 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfJOS12 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Oct 2019 14:27:28 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id AA813316;
        Tue, 15 Oct 2019 18:27:27 +0000 (UTC)
Date:   Tue, 15 Oct 2019 12:27:26 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Changbin Du <changbin.du@gmail.com>
Cc:     linux-pci@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-fpga@vger.kernel.org,
        linux-usb@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH] kernel-doc: rename the kernel-doc directive 'functions'
 to 'specific'
Message-ID: <20191015122726.7e12f551@lwn.net>
In-Reply-To: <20191013055359.23312-1-changbin.du@gmail.com>
References: <20191013055359.23312-1-changbin.du@gmail.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 13 Oct 2019 13:53:59 +0800
Changbin Du <changbin.du@gmail.com> wrote:

> The 'functions' directive is not only for functions, but also works for
> structs/unions. So the name is misleading. This patch renames it to
> 'specific', so now we have export/internal/specific directives to limit
> the functions/types to be included in documentation. Meanwhile we improved
> the warning message.

I agree with the others that "specific" doesn't really make things
better.  "Interfaces" maybe; otherwise we could go for something like
"filter" or "select".

Paint mine green :)

Whatever we end up with, I think it should be added as a synonym for
"functions".  Then the various selectors that are actually pulling out
docs for functions could be changed at leisure - or not at all.  I'd
rather not see a big patch changing everything at once.

Thanks,

jon
