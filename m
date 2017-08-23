From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [BUGFIX PATCH v2] staging: ccree: save ciphertext for CTS IV
Date: Wed, 23 Aug 2017 13:09:27 +0200
Message-ID: <2466942.Cj26oPppaK@tauon.chronox.de>
References: <1503479525-23947-1-git-send-email-gilad@benyossef.com> <4515717.kZM3QcrMqT@tauon.chronox.de> <CAOtvUMe-Z1r0Lr-AszyYZONod53+hA42gvy7UihRNwZTDCTwkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59432 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753842AbdHWLJa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Aug 2017 07:09:30 -0400
In-Reply-To: <CAOtvUMe-Z1r0Lr-AszyYZONod53+hA42gvy7UihRNwZTDCTwkA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 23. August 2017, 12:47:36 CEST schrieb Gilad Ben-Yossef:

Hi Gilad,
> 
> Thank you for your persistence. It is appreciated :-)
> 
> If I understood correctly what you are referring to than the buffer is not
> allocated in this code path (unless I've missed something):

Ah, that is what I was missing :-)

Thanks for clarification. No further objections ;-)

Ciao
Stephan
