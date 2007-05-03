From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Testing the geode-aes driver with the tcrypt module completely freezes the machine
Date: Thu, 3 May 2007 17:23:10 +0400
Message-ID: <20070503132310.GA21082@2ka.mipt.ru>
References: <000601c78d84$bc24b430$1a04010a@V505CP>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: linux-crypto@vger.kernel.org
To: Martin Schiller <mschiller@tdt.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:52947 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056AbXECNX0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 May 2007 09:23:26 -0400
Content-Disposition: inline
In-Reply-To: <000601c78d84$bc24b430$1a04010a@V505CP>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 03, 2007 at 03:12:43PM +0200, Martin Schiller (mschiller@tdt.de) wrote:
> The freeze is the result of an invinite while-loop in the function
> geode_ecb_encrypt()
> (and maybe also in the geode_ecb_decrypt()).
> 
> The cause for this seems to be, that the op->src == op->dst whereby the
> geode_aes_crypt() function does nothing at all,
> and so the value of nbytes will never be changed.

Hm, driver does not perform encryption in-place at all.
Since we did not hear from AMD quite for a while, could you please
remove src==dst check in geode_aes_crypt() and run tests again.
If it is software protection against hardware bug, I doubt such hardware
should be used at all...

> Regards,
> Martin

-- 
	Evgeniy Polyakov
