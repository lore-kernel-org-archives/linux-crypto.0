From: Milan Broz <gmazyland@gmail.com>
Subject: Re: crypto: xts: regression in 4.10
Date: Wed, 22 Feb 2017 12:31:30 +0100
Message-ID: <fb8a2f22-053e-7b30-6f0f-58158c832ad5@gmail.com>
References: <20170221231717.GA7186@nicolas-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Nicolas Porcel <nicolasporcel06@gmail.com>,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34075 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932264AbdBVLbd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Feb 2017 06:31:33 -0500
Received: by mail-wr0-f196.google.com with SMTP id 89so1122275wrr.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2017 03:31:32 -0800 (PST)
In-Reply-To: <20170221231717.GA7186@nicolas-laptop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/22/2017 12:17 AM, Nicolas Porcel wrote:
> Hello,
> 
> I am using aes-xts-plain64 with LUKS headers to crypt the root. In 4.10,
> the partition cannot be opened and I have the following errors when
> booting:
> 
>     device-mapper: table: 253:0: crypt: Error allocating crypto tfm
>     device-mapper: ioctl: error adding target to table
>     device-mapper: reload ioctl on  failed: No such file or directory
>     Failed to setup dm-crypt key mapping for device /dev/mmcblk0p2
>     Check that the kernel supports aes-xts-plain64 cipher (check syslog for more info)
> 
> I found that this commit is responsible for the regression (reverting it
> solves the problem):
> 
>> commit f1c131b45410a202eb45cc55980a7a9e4e4b4f40
>> Author: Herbert Xu <herbert@gondor.apana.org.au>
>> Date:   Tue Nov 22 20:08:19 2016 +0800
>>
>>     crypto: xts - Convert to skcipher
> 
> Some precision: I am using the vanilla kernel source for 4.10. The aes,
> xts and dm-crypt modules are directly compiled in the kernel and not as
> modules. I also had the same problem with kernel 4.10-rc*.

Kernel 4.10 works with LUKS and XTS in general (otherwise I would scream much earlier:-)

I guess either there is a bug in some specific dependency missing
dependency in kernel config. Could you send your kernel .config that fails?

Do you have ECB mode compiled-in as well?

(See commit description, shouldn't XTS now select ECB as well? This seems to me
like a bug...)
 
> Is it a known issue? I found 1 related email with no answer on the
> dm-crypt mailing. If this is a regression, I can start digging, although
> any guidance would be greatly appreciated.

What mail on dmcrypt list? I do not see any recent mail.

Milan
