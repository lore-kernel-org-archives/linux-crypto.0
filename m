From: Anatoly Pugachev <matorola@gmail.com>
Subject: linux kernel (sparc), n2 rng for newer hardware
Date: Sat, 9 Jan 2016 23:18:27 +0300
Message-ID: <CADxRZqwHDVZrmaM7AOyxSLhMbbUhMXpqnRCaoma+SZGyxxFfeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: davem@redhat.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:36507 "EHLO
	mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbcAIUS2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 9 Jan 2016 15:18:28 -0500
Received: by mail-vk0-f48.google.com with SMTP id n1so53343454vkb.3
        for <linux-crypto@vger.kernel.org>; Sat, 09 Jan 2016 12:18:28 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello!

Could someone please (Dave?) read my message from
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=809815#32

It's about fix to n2_rng (sparc) kernel module, but I'm not a kernel
or C/C++ programmer, and I can't write a proper patch to n2_rng (i
have no idea about data field of of_device_id structure).

Thanks.
