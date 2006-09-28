From: "Jordan Crouse" <jordan.crouse@amd.com>
Subject: Re: crypto: Add support for the Geode AES engine
Date: Thu, 28 Sep 2006 10:31:15 -0600
Message-ID: <20060928163115.GL25387@cosmic.amd.com>
References: <20060927193147.GA21043@cosmic.amd.com>
 <LYRIS-4270-86779-2006.09.28-04.27.47--jordan.crouse#amd.com@whitestar.amd.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, info-linux@ldcmail.amd.com,
	akpm@osdl.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:64602 "EHLO
	outbound1-blu-R.bigfish.com") by vger.kernel.org with ESMTP
	id S1751922AbWI1QX1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Sep 2006 12:23:27 -0400
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
In-Reply-To: <LYRIS-4270-86779-2006.09.28-04.27.47--jordan.crouse#amd.com@whitestar.amd.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> As far as I can see, register access is not protected, how can your
> driver handle the case when dm-crypt and IPsec simultaneously try to
> encrypt/decrypt some data, it can happen even around 
> preemt_disable/enable calls and actually crypto processing can happen 
> in interrupt context too (although it is not the best thing to do).

I had the mutex in there, but I took it out based on our previous
conversations, which probably was a little rash.  If CRYPTO_TFM_REQ_MAY_SLEEP
is still a valid flag to check, I could use that along with a spin lock of
some sort.   I'll think about this a bit more.

> You added timeout for the broken hardware condition, I think it is
> better to return some error from _crypt() in that case, and, btw, that
> name is not very good choice.

I normally use _<blah> for static functions within my module - it helps
me remember which commands might be important to others and which are just
utility functions for my own use and abuse.  I'll change the name.

Thanks,
Jordan

-- 
Jordan Crouse
Senior Linux Engineer
Advanced Micro Devices, Inc.
<www.amd.com/embeddedprocessors>


