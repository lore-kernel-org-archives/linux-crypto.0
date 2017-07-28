From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/3] staging: ccree: Replace kzalloc with devm_kzalloc
Date: Thu, 27 Jul 2017 21:56:01 -0700
Message-ID: <20170728045601.GA30772@kroah.com>
References: <CAOtvUMeypygShtn4+nXCsepUrsDhBmZmqXMp60D116P8+2WT4A@mail.gmail.com>
 <1501165654-30601-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Suniel Mahesh <sunil.m@techveda.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37046 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750785AbdG1E4H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2017 00:56:07 -0400
Content-Disposition: inline
In-Reply-To: <1501165654-30601-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 27, 2017 at 05:27:32PM +0300, Gilad Ben-Yossef wrote:
> From: Suniel Mahesh <sunil.m@techveda.org>
> 
> It is recommended to use managed function devm_kzalloc, which
> simplifies driver cleanup paths and driver code.
> This patch does the following:
> (a) replace kzalloc with devm_kzalloc.
> (b) drop kfree(), because memory allocated with devm_kzalloc() is
> automatically freed on driver detach, otherwise it leads to a double
> free.
> (c) remove unnecessary blank lines.
> 
> Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
> [gby: rebase on top of latest coding style fixes changes]
> Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

None of these 3 applied to my tree :(
