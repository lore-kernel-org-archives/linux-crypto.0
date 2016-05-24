From: Denis B <begun.denis@gmail.com>
Subject: SKB dst field is NULL when AEAD request complete() is called
Date: Tue, 24 May 2016 15:03:22 +0300
Message-ID: <CADREXsqviDO5RvN87LmDOQU3By_y8YPaGbcRxDpNW4Eyf62_6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:34154 "EHLO
	mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306AbcEXMDX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 May 2016 08:03:23 -0400
Received: by mail-vk0-f43.google.com with SMTP id c189so18204130vkb.1
        for <linux-crypto@vger.kernel.org>; Tue, 24 May 2016 05:03:23 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Working with kernel 3.12.14, in AEAD mode, I register my crypto driver
and the givencrypt() method in the driver gets called when I send
IPSec traffic. I store the request, and later call its complete()
method from a work queue. There is no actual encryption happening at
the moment, I'm just testing flow. As stated, the complete() call
stumbles upon a NULL pointer exception in xfrm_output_resume() because
skb_dst(skb) is NULL. When I receive the request in givencrypt(), dst
is not null in the SKB.

Why would the framework meddle with the SKB? Has anyone experienced
anything similar?

Thanks,
Dennis.
