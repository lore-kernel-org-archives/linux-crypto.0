From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] dm-crypt: disable block encryption with arc4
Date: Tue, 26 Jan 2010 10:22:34 +0100
Message-ID: <20100126092234.GA3304@Chamillionaire.breakpoint.cc>
References: <Pine.LNX.4.64.1001251324310.18309@hs20-bc2-1.build.redhat.com>
 <4B5DE54F.7050206@redhat.com>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com,
	Alasdair G Kergon <agk@redhat.com>,
	linux-crypto@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:48834 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752378Ab0AZJWg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2010 04:22:36 -0500
Content-Disposition: inline
In-Reply-To: <4B5DE54F.7050206@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Milan Broz | 2010-01-25 19:39:11 [+0100]:

>On 01/25/2010 07:29 PM, Mikulas Patocka wrote:
>> Hi
>> 
>> When using arc4 to encrypt a block device, the resulting device is 
>> unreliable. It reads garbage. That's because arc4 is a stream cipher, if 
>> you write something, it advances its state and if you attempt to decrypt 
>> the same sector, it uses new state that is different.
>> 
>> This patch disables the use of arc4 on block devices.
>
>arc4 again. it is simply not a block cipher:-)
>
>This should be solved inside cryptoAPI and not blacklist it in dm-crypt,
>see that thread
>http://article.gmane.org/gmane.linux.kernel.cryptoapi/3441

I some how remember Herbert saying to test for block size > 1. Wouldn't
this be acceptable to block all stream cipher in one go?

>Milan

Sebastian
