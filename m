From: James Yonan <james@openvpn.net>
Subject: Re: [PATCH] crypto: aesni - fix "by8" variant for 128 bit keys
Date: Thu, 01 Jan 2015 10:08:18 -0700
Message-ID: <54A57F02.1020502@openvpn.net>
References: <1419976254-30208-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Romain Francoise <romain@orebokech.com>,
	Chandramouli Narayanan <mouli@linux.intel.com>
To: Mathias Krause <minipli@googlemail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.yonan.net ([54.244.116.145]:35055 "EHLO mail.yonan.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbbAARIU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Jan 2015 12:08:20 -0500
In-Reply-To: <1419976254-30208-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 30/12/2014 14:50, Mathias Krause wrote:
> The "by8" counter mode optimization is broken for 128 bit keys with
> input data longer than 128 bytes. It uses the wrong key material for
> en- and decryption.
>
> The key registers xkey0, xkey4, xkey8 and xkey12 need to be preserved
> in case we're handling more than 128 bytes of input data -- they won't
> get reloaded after the initial load. They must therefore be (a) loaded
> on the first iteration and (b) be preserved for the latter ones. The
> implementation for 128 bit keys does not comply with (a) nor (b).
>
> Fix this by bringing the implementation back to its original source
> and correctly load the key registers and preserve their values by
> *not* re-using the registers for other purposes.
>
> Kudos to James for reporting the issue and providing a test case
> showing the discrepancies.
>
> Reported-by: James Yonan <james@openvpn.net>
> Cc: Chandramouli Narayanan <mouli@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v3.18
> Signed-off-by: Mathias Krause <minipli@googlemail.com>

This looks great, fixes the issue on 3.18.1 for all of our use cases.

Thanks to Mathias for putting this together.

James
