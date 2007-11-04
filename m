From: Michal Ludvig <michal@logix.cz>
Subject: Re: [patch 0/2] remove setkey function in VIA's padlock
Date: Mon, 05 Nov 2007 12:54:50 +1300
Message-ID: <472E5BCA.2060000@logix.cz>
References: <20071102181323.632030242@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from maxipes.logix.cz ([217.11.251.249]:55202 "EHLO maxipes.logix.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161AbXKEA0O (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 4 Nov 2007 19:26:14 -0500
In-Reply-To: <20071102181323.632030242@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Sebastian Siewior wrote:
> Hello Michal,
> 
> you wrote the padlock-aes driver so you probably have the hardware for
> testing :) The setkey function in the driver's code looks like it
> expands the key the same way like the new crypto_aes_set_key() I've
> posted earlier [1], [2]. Could you please test this patch and see if it is
> working correct?

I'll test and get back to you.

> I have one question regarding the size of the expanded key: You reserve
> 64 * 4 bytes for each key but it seems that you use only 60 * 4 bytes.
> Are the other bytes used by the hardware or did you allocate it by
> accident?

The hardware needs it. From the VIA Padlock Programming Guide:

| For the application-loaded keys option, the hardware always
| loads sixteen 128-bit values from memory regardless of the
| specified key size. Any values beyond the normal extended key
| size are ignored and have no effect on the results, but that
| memory area must be accessible (within the segment limit, etc.)

Michal
-- 
* http://www.logix.cz/michal
