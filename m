From: =?ISO-8859-15?Q?Adrian-Ken_R=FCegsegger?= <rueegsegger@swiss-it.ch>
Subject: Re: tcrypt: hmac test with keys > blocksize fail
Date: Sat, 03 May 2008 13:44:41 +0200
Message-ID: <481C5029.9040406@swiss-it.ch>
References: <481BAD7A.3010003@swiss-it.ch> <20080503062113.GB30328@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:2364 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbYECLot (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 3 May 2008 07:44:49 -0400
In-Reply-To: <20080503062113.GB30328@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Sebastian Siewior wrote:
> * Adrian-Ken R?egsegger | 2008-05-03 02:10:34 [+0200]:
> 
>> Hi,
> Hi Adrian-Ken,

Hello Sebastian,

>> using the cryptodev-2.6 tree I noticed that the hmac tests that have
>> keys larger than blocksize for md5 and the various sha algorithms all
>> fail (tcrypt mode=10[0-5]). The other tests seem to pass just fine.
>>
>> The issue seems to have come from commit
>> de224c309b5631bdaae3fcd6880cfb93b52f5a53.
> Is this a bisect result?

No, this was a guess of mine, since I tested the two revisions just
prior and after the three tcrypt-commits from you. I did a full bisect
and the actual guilty commit is:

[562954d5e01d08154cf15c7e12e6e9ec803f50f7] [CRYPTO] tcrypt: Change the
usage of the test vectors

>> I have tested 48c8949ea8460216783dd33640121187b9531b60 which does not
>> contain this bug.  It's just before the various tcrypt-changes from
>> Sebastian Siewior.
> I tested it with tcrypt mode=0 what covers 100-105 but it may slip
> through. I will look into this later.

As I mentioned, it's only the hmac tests with keys larger than blocksize
that fail.
Additionaly I just saw, that ecb(des) encryption test nr 5 passes but it
seems that the setkey operation fails with:

setkey() failed flags=100100

-Adrian
