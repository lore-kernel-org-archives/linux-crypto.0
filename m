From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: Broken userspace crypto in linux-4.1.18
Date: Wed, 17 Feb 2016 09:37:30 -0500
Message-ID: <56C485AA.5060303@oracle.com>
References: <56C47DF9.6030704@whissi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: dvyukov@google.com,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: "Thomas D." <whissi@whissi.de>, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22015 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696AbcBQOhx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Feb 2016 09:37:53 -0500
In-Reply-To: <56C47DF9.6030704@whissi.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/17/2016 09:04 AM, Thomas D. wrote:
> Hi,
> 
> something is broken with crypto in linux-4.1.18.
> 
> On my system I have two disks (sda and sdb), both encrypted with LUKS
> (cipher=aes-xts-plain64).
> 
> My rootfs resides encrypted on sda2 (sda1 is an unencrypted boot
> partition).
> sdb has one full encrypted partition (sdb1) mounted in "/backup".
> 
> After I upgraded from linux-4.1.17 to linux-4.1.18 and rebooted I noticed
> that my encrypted rootfs was opened successfully (must be my initramfs)
> however opening sdb1 with key file failed:

Thanks for the report Thomas.

[...]

> After I bisect the kernel I found the following bad commit:
> 
>> commit 0571ba52a19e18a1c20469454231eef681cb1310
>> Author: Herbert Xu <herbert@gondor.apana.org.au>
>> Date:   Wed Dec 30 11:47:53 2015 +0800
>>
>>     crypto: af_alg - Disallow bind/setkey/... after accept(2)
>>
>>     [ Upstream commit c840ac6af3f8713a71b4d2363419145760bd6044 ]
>>
>>     Each af_alg parent socket obtained by socket(2) corresponds to a
>>     tfm object once bind(2) has succeeded.  An accept(2) call on that
>>     parent socket creates a context which then uses the tfm object.
>>
>>     Therefore as long as any child sockets created by accept(2) exist
>>     the parent socket must not be modified or freed.
>>
>>     This patch guarantees this by using locks and a reference count
>>     on the parent socket.  Any attempt to modify the parent socket will
>>     fail with EBUSY.

So either the upstream patch is broken, or the 4.1 backport is wrong/missing
dependency/missing fix.

Any chance you could try 4.5-rc3 and see if that works for you? That'll narrow
it down a lot.


Thanks,
Sasha
