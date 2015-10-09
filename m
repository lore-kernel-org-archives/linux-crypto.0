From: arno@natisbad.org (Arnaud Ebalard)
Subject: Re: [PATCH] MAINTAINERS: add maintainers for the Marvell Crypto driver
Date: Fri, 09 Oct 2015 21:22:09 +0200
Message-ID: <87twpz6e5a.fsf@natisbad.org>
References: <1444405142-4469-1-git-send-email-thomas.petazzoni@free-electrons.com>
	<20151009175629.545e124a@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Russell King <linux@arm.linux.org.uk>
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 36.223.133.77.rev.sfr.net ([77.133.223.36]:58856 "EHLO
	smtp.natisbad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbbJITaf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 15:30:35 -0400
In-Reply-To: <20151009175629.545e124a@bbrezillon> (Boris Brezillon's message
	of "Fri, 9 Oct 2015 17:56:29 +0200")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

Boris Brezillon <boris.brezillon@free-electrons.com> writes:

>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>> ---
>>  MAINTAINERS | 7 +++++++
>>  1 file changed, 7 insertions(+)
>> 
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 7ba7ab7..d3f47f5c 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -6555,6 +6555,13 @@ M:	Guenter Roeck <linux@roeck-us.net>
>>  S:	Maintained
>>  F:	drivers/net/dsa/mv88e6352.c
>>  
>> +MARVELL CRYPTO DRIVER
>> +M:	Boris Brezillon <boris.brezillon@free-electrons.com>
>> +M:	Arnaud Ebalard <arno@natisbad.org>

Acked-by: Arnaud Ebalard <arno@natisbad.org>


>> +F:	drivers/crypto/marvell/
>> +S:	Maintained
>> +L:	linux-crypto@vger.kernel.org
>> +
>>  MARVELL GIGABIT ETHERNET DRIVERS (skge/sky2)
>>  M:	Mirko Lindner <mlindner@marvell.com>
>>  M:	Stephen Hemminger <stephen@networkplumber.org>
