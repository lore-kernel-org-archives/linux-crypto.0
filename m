From: "Lingbo Tang (SINA)" <tanglb@sina.com>
Subject: Re: =?UTF-8?B?5Zue5aSN77yaUmU6IHZnZGlzcGxheSBwcm9ibGVtIHdpdGggaGk=?=
 =?UTF-8?B?Zm43OTV4?=
Date: Sun, 07 Dec 2008 18:13:38 +0800
Message-ID: <493BA1D2.2080108@sina.com>
References: <20081130082600.C00C836FC34@mail3-113.sinamail.sina.com.cn> <20081130101208.GA20720@ioremap.net> <493A87B3.3050209@sina.com> <20081206151914.GA31165@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail3-165.sinamail.sina.com.cn ([202.108.3.165]:60080 "EHLO
	smtp3-75.sinamail.sina.com.cn" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750802AbYLGKOF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 05:14:05 -0500
Received: from mail5-202.sinamail.sina.com.cn (unknown [10.55.5.202])
	by smtp3-75.sinamail.sina.com.cn (SINAMAIL) with ESMTP id C2FD5D63688
	for <linux-crypto@vger.kernel.org>; Sun,  7 Dec 2008 18:14:01 +0800 (CST)
In-Reply-To: <20081206151914.GA31165@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Evgeniy Polyakov wrote:
> On Sat, Dec 06, 2008 at 10:09:55PM +0800, Lingbo Tang (SINA) (tanglb@sina.com) wrote:
>> In some cases the non-debug version can work with "mkfs.xfs", but it
>> could not in most case.
>> I tried to disable most services in the system, but it seems have no
>> related to the system load.
> 
> So I suppose it is easy to reproduce problem. Please show 'dmesg' output
> for the hung case when debug is turned off. Did you see register dump
> message when that happened? Please also try attached patch and show the
> hung dmesg (with tured off heavy debug).
> 

There is no message when my system hung with debug disabled.

After I patched your new code, there is no hang anymore. I got following 
message:

Dec  7 18:06:15 localhost kernel: hifn_handle_req: nbytes: 512, started: 
23, qlen: 1, err: -115.
Dec  7 18:06:16 localhost last message repeated 87 times
Dec  7 18:06:16 localhost kernel: hifn_handle_req: nbytes: 512, started: 
23, qlen: 0, err: -115.
Dec  7 18:06:16 localhost kernel: hifn_handle_req: nbytes: 512, started: 
23, qlen: 1, err: -115.
Dec  7 18:06:18 localhost last message repeated 344 times
Dec  7 18:06:18 localhost kernel: Filesystem "dm-3": Disabling barriers, 
trial barrier write failed
Dec  7 18:06:18 localhost kernel: XFS mounting filesystem dm-3
Dec  7 18:06:19 localhost kernel: hifn_handle_req: nbytes: 512, started: 
23, qlen: 1, err: -115.
Dec  7 18:06:19 localhost last message repeated 21 times
Dec  7 18:06:19 localhost kernel: XFS quotacheck dm-3: Please wait.
Dec  7 18:06:19 localhost kernel: XFS quotacheck dm-3: Done.
Dec  7 18:06:19 localhost kernel: hifn_handle_req: nbytes: 512, started: 
23, qlen: 1, err: -115.
Dec  7 18:06:19 localhost last message repeated 2 times
Dec  7 18:06:25 localhost ntpd[2125]: synchronized to LOCAL(0), stratum 10
Dec  7 18:06:25 localhost ntpd[2125]: kernel time sync enabled 0001
Dec  7 18:06:35 localhost kernel: hifn_handle_req: nbytes: 512, started: 
23, qlen: 0, err: -115.
Dec  7 18:06:35 localhost kernel: hifn_handle_req: nbytes: 512, started: 
23, qlen: 1, err: -115.

Regards,
Lingbo

