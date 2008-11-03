From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: Can anyone explain the AEAD implementation
Date: Mon, 3 Nov 2008 14:15:06 +0300
Message-ID: <20081103111506.GB19920@ioremap.net>
References: <200811031101.16398.djenkins@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dean Jenkins <djenkins@mvista.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from matrixpower.ru ([195.178.208.66]:55478 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950AbYKCLPI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Nov 2008 06:15:08 -0500
Content-Disposition: inline
In-Reply-To: <200811031101.16398.djenkins@mvista.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Mon, Nov 03, 2008 at 11:01:16AM +0000, Dean Jenkins (djenkins@mvista.com) wrote:
> I observe that the ESP module uses an AEAD crypto API. AEAD means 
> Authentication Encryption with Associated Data. It seems Encryption and HMAC 
> are combined into a single API. Am I correct ?
> 
> Please can anyone explain how individual Encryption algorithms and Hashing 
> algorithms are selected for the AEAD API ? For example, I want to use a 
> particular AES and SHA-1 implementations in a hardware accelerator.

You can find precise examples in crypto/tcrypt.c test module.

-- 
	Evgeniy Polyakov
