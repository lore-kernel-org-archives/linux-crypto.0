From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] dm-crypt: disable block encryption with arc4
Date: Tue, 26 Jan 2010 11:48:55 +0100
Message-ID: <4B5EC897.5050102@redhat.com>
References: <Pine.LNX.4.64.1001251324310.18309@hs20-bc2-1.build.redhat.com> <4B5DE54F.7050206@redhat.com> <20100126092234.GA3304@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com,
	Alasdair G Kergon <agk@redhat.com>,
	linux-crypto@vger.kernel.org
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559Ab0AZKtU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2010 05:49:20 -0500
In-Reply-To: <20100126092234.GA3304@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/26/2010 10:22 AM, Sebastian Andrzej Siewior wrote:
> * Milan Broz | 2010-01-25 19:39:11 [+0100]:
>> On 01/25/2010 07:29 PM, Mikulas Patocka wrote:
>>> When using arc4 to encrypt a block device, the resulting device is 
>>> unreliable. It reads garbage. That's because arc4 is a stream cipher, if 
>>> you write something, it advances its state and if you attempt to decrypt 
>>> the same sector, it uses new state that is different.
>>>
>>> This patch disables the use of arc4 on block devices.
>>
>> arc4 again. it is simply not a block cipher:-)
>>
>> This should be solved inside cryptoAPI and not blacklist it in dm-crypt,
>> see that thread
>> http://article.gmane.org/gmane.linux.kernel.cryptoapi/3441
> 
> I some how remember Herbert saying to test for block size > 1. Wouldn't
> this be acceptable to block all stream cipher in one go?

yes, I think it is better.
(...and I just forgot to add that test to dm-crypt after that suggestion.)

Milan
