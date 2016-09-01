From: Stephan Mueller <smueller@chronox.de>
Subject: Re: CONFIG_FIPS without module loading support?
Date: Thu, 01 Sep 2016 03:49:16 +0200
Message-ID: <2366601.movXpHLGKJ@tauon.atsec.com>
References: <CAM5Ud7MDpZyTrcQ2NtghG6cGT8qfGfP6zYw+vJDQrHqFHor6sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: NTU <neotheuser@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:37340 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760064AbcIABtX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Aug 2016 21:49:23 -0400
In-Reply-To: <CAM5Ud7MDpZyTrcQ2NtghG6cGT8qfGfP6zYw+vJDQrHqFHor6sg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 31. August 2016, 20:32:42 CEST schrieb NTU:

Hi NTU,

> Hello,
> 
> CRYPTO_FIPS depends on MODULE_SIG and I understand why it would as you
> wouldn't want unsigned modules from external sources being loaded. If
> CONFIG_MODULES is disabled though (no module loading) there are no
> modules to sign in the first place.
> 
> Wouldn't it make more sense for CONFIG_FIPS to depend on (MODULE_SIG
> [=y] && CONFIG_MODULES [y]) ?
> 
> Thank you!

Yes, that is correct.
> 
> Alec Ari
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



Ciao
Stephan
