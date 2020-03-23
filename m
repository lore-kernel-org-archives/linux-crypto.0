Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D864C10F26
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 06:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1DF420736
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 06:50:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="AaJZewlt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgCWGuA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 02:50:00 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:39003 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbgCWGuA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 02:50:00 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 99ad1ccc;
        Mon, 23 Mar 2020 06:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=subject:to:cc
        :references:from:message-id:date:mime-version:in-reply-to
        :content-type:content-transfer-encoding; s=mail; bh=4Vv9+g8w3f6g
        JEugg2tt/vKG5sw=; b=AaJZewltCzB/r295DAZYUG8u1eSC+WCa57UD6J+3xLM2
        xO0sbryZ0XohzwZoif6y2Bii9a5maw9ctWMUxX+ocdq1PL7SGU5cW+YA9zcvBNXA
        IBiiDGqgsycXK8cvCmDYF9BSzIqJcCaCilkPUdkdeKcT5fBX+Hgqk9ZN73VDB7RC
        ThSglMfJZxko7T7d8FrOKxt1rShrLtLu0mVgeL97lzKkMZtYkE5Y4Jg6ojtTrgGR
        OMvd45fI6ObODQoEGHS3v41vxkl2vIYhAkep1UTNUE8kJX9uoO3EkryO/TZ6wWM9
        WvO72hrlm0vI+8rLOiruuoi8ldMnLVt2rb7CF0y+RQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 87a500ae (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 23 Mar 2020 06:43:01 +0000 (UTC)
Subject: Re: nCipher HSM kernel driver submission feedback request
To:     "Kim, David" <david.kim@ncipher.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Magee, Tim" <tim.magee@ncipher.com>, Arnd Bergmann <arnd@arndb.de>
References: <1584092894266.92323@ncipher.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Message-ID: <9644fcdd-1453-616a-f607-4a1f39f433ff@zx2c4.com>
Date:   Mon, 23 Mar 2020 00:49:57 -0600
MIME-Version: 1.0
In-Reply-To: <1584092894266.92323@ncipher.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Dave,

I took a look at your driver to try to understand what's going on here 
and what the disagreement is all about.

It looks like this is some sort of PCIe HSM device. As far as I know, 
Linux doesn't have a standardized API for HSM devices (somebody correct 
me if I'm wrong), and probably that doesn't quite make sense, either, 
seeing as most HSMs are accessed anyway through userspace "drivers" -- 
that is, via libusb or over some networking protocol, or something else. 
Your situation is different in that it uses PCIe, so you need some 
kernel mediation in order to give access to your userspace components. 
And, different manufacturers' HSMs expose very different pieces of 
functionality, and I'm not sure a unified API for them would even make 
sense.

It looks like this driver exposes some device file, with a few IOCTLs 
and then support for reading and writing from and to the device. Besides 
some driver control things, what actually goes into the device -- that 
is, the protocol one must use to talk to the thing -- isn't actually 
described by the driver. You're just shuffling bytes in and out with 
some mediation around that.

Can you confirm to me whether or not the above is accurate?

If so, then I'm not sure this belongs in the purview of the crypto list 
or has anything much to do with Linux crypto. This is a PCIe driver for 
some hardware that userspace has to talk to in order to do some stuff 
with it.

However, there's something else that you wrote that might make people 
less inclined to merge this:

 > Our driver code is just a tube between proprietary code on the host 
machine and proprietary code on the HSM.

It sounds like you need the kernel to expose your PCIe device in a way 
userspace can access, so that you can talk to it using proprietary code. 
In other words, this is a kernel driver that exists only to support 
closed source components. I have no idea about "official policy" on this 
matter, but I could imagine some people howling about it. On the other 
hand, the driver _is_ doing something, and it seems like your hardware 
is somewhat complicated to interface with, and who wouldn't want an open 
source driver for that, even if it's just the low-level kernel/PCIe 
components?

Anyway, if my suppositions above are indeed correct, I'd encourage you 
to submit your driver to whoever maintains drivers/misc/ (Greg and Arnd, 
IIRC), and ignore the fact that your hardware has something to do with 
cryptography (though little to do with the Linux crypto API's range of 
responsibilities).

Jason
