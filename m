From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC PATCH] crypto: RSA padding transform
Date: Mon, 07 Sep 2015 17:10:47 +0200
Message-ID: <1917255.6DsdEGCabm@tauon.atsec.com>
References: <1441494029-6765-1-git-send-email-andrew.zaborowski@intel.com> <2234268.M7UZMy8YJa@tauon.atsec.com> <CAOq732K1k0qsgZx8qxoPj=Hq2fNZTVWQbf5=hwF6k9-ya36THA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org
To: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33793 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbbIGPLG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Sep 2015 11:11:06 -0400
In-Reply-To: <CAOq732K1k0qsgZx8qxoPj=Hq2fNZTVWQbf5=hwF6k9-ya36THA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 7. September 2015, 16:42:42 schrieb Andrzej Zaborowski:

Hi Andrzej,
>
>Specifically I use 1 + prandom_u32_max(255) which should give me
>numbers > 0 although it can't be perfectly uniform.

Oh, now I see. Thanks for the clarification. And yes, per definition the 
values cannot be uniform (not just because of the +1 but also since prandom is 
not a cryptographic RNG).


Ciao
Stephan
