From: Nicolas Porcel <nicolasporcel06@gmail.com>
Subject: crypto: xts: regression in 4.10
Date: Wed, 22 Feb 2017 00:17:17 +0100
Message-ID: <20170221231717.GA7186@nicolas-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:35408 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752819AbdBUXRZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Feb 2017 18:17:25 -0500
Received: by mail-wr0-f174.google.com with SMTP id s27so44519862wrb.2
        for <linux-crypto@vger.kernel.org>; Tue, 21 Feb 2017 15:17:23 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I am using aes-xts-plain64 with LUKS headers to crypt the root. In 4.10,
the partition cannot be opened and I have the following errors when
booting:

    device-mapper: table: 253:0: crypt: Error allocating crypto tfm
    device-mapper: ioctl: error adding target to table
    device-mapper: reload ioctl on  failed: No such file or directory
    Failed to setup dm-crypt key mapping for device /dev/mmcblk0p2
    Check that the kernel supports aes-xts-plain64 cipher (check syslog for more info)

I found that this commit is responsible for the regression (reverting it
solves the problem):

> commit f1c131b45410a202eb45cc55980a7a9e4e4b4f40
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Tue Nov 22 20:08:19 2016 +0800
> 
>     crypto: xts - Convert to skcipher

Some precision: I am using the vanilla kernel source for 4.10. The aes,
xts and dm-crypt modules are directly compiled in the kernel and not as
modules. I also had the same problem with kernel 4.10-rc*.

Is it a known issue? I found 1 related email with no answer on the
dm-crypt mailing. If this is a regression, I can start digging, although
any guidance would be greatly appreciated.

Thank you in advance,

Best regards,

-- 
Nicolas Porcel
