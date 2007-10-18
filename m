From: Krzysztof Oledzki <olel@ans.pl>
Subject: Re: Truncated(?) /proc/crypto on x86_64 on 2.6.22
Date: Thu, 18 Oct 2007 17:19:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710181718450.12701@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0710161949410.21430@bizon.gios.gov.pl>
 <20071016193435.GA31668@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-731974481-1192720774=:12701"
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:45825 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbXJRPTv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Oct 2007 11:19:51 -0400
In-Reply-To: <20071016193435.GA31668@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-731974481-1192720774=:12701
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 16 Oct 2007, Sebastian Siewior wrote:

> * Krzysztof Oledzki | 2007-10-16 19:56:33 [+0200]:
>
>> After switching from i386 to x86_64 I noticed that /proc/crypto is much
>> shorter:
>>
>> #  wc -l /proc/crypto crypto-64
>>  482 /proc/crypto
>>  349 crypto-64
>>
>
> It is all fine from what I can see in this diff.
>
>
>> # diff -Nur /proc/crypto crypto-64
>> --- /proc/crypto        2007-10-16 19:49:45.110694374 +0200
>> +++ crypto-64   2007-10-16 19:48:10.000000000 +0200
>> @@ -1,136 +1,3 @@
>> -name         : cbc(twofish)
>> -driver       : cbc(twofish-i586)
>> -module       : kernel
>> -priority     : 200
>> -refcnt       : 1
>> -type         : blkcipher
>> -blocksize    : 16
>> -min keysize  : 16
>> -max keysize  : 32
>> -ivsize       : 16
>> -
>
> This algo is stacked, because it was used. You have probably one output
> after 'modprobe tcrypt' and the other before :)

Right. The other (bigger) output is after starting IPSec. Sorry for the=20
noise and thank you for the explanation.

Best regards,

 =09=09=09Krzusztof Ol=EAdzki
---187430788-731974481-1192720774=:12701--
