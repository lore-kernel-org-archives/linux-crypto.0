From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 00/22] staging: ccree: fixes and simplifications
Date: Wed, 16 Aug 2017 15:12:06 -0700
Message-ID: <20170816221206.GA20227@kroah.com>
References: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40146 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752428AbdHPWMG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Aug 2017 18:12:06 -0400
Content-Disposition: inline
In-Reply-To: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 15, 2017 at 09:26:28AM +0300, Gilad Ben-Yossef wrote:
> The series includes various bug fixes, code simplification and style
> cleanups. 
> 
> Changer from v2:
> - Drop M32R as supported architecture, which resolve the kbuild bot
>   warnings on Joe Perches patch.
> - Bug fix that properly saves last bytes of ciphertext for CTS in
>   skcipher
> - Even more coding style fixes

This patch series didn't apply at all, please fix up and resend.

thanks,

greg k-h
