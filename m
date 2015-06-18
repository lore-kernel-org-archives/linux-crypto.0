From: Ambarus Tudor-Dan-B38632 <b38632@freescale.com>
Subject: Re: variable iv lengths for aes-gcm
Date: Thu, 18 Jun 2015 12:44:06 +0300
Message-ID: <558292E6.3060708@freescale.com>
References: <55827696.20704@freescale.com>
 <20150618080707.GA29218@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0139.outbound.protection.outlook.com ([157.56.111.139]:13664
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754506AbbFRKRw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 06:17:52 -0400
In-Reply-To: <20150618080707.GA29218@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 6/18/2015 11:07 AM, Herbert Xu wrote:
> On Thu, Jun 18, 2015 at 10:43:18AM +0300, Ambarus Tudor-Dan-B38632 wrote:
>>
>> I'm trying to find a method to pass IVs of various lengths to an
>> algorithm. A particular case would be aes-gcm IV. It can have any
>> number of bits between 1 and 2^64.
>>
>> A possible way to do this is to set the ivlen per request. Are there
>> any (better) ways to do this?
>
> Why would you want do this apart from the fact that your hardware
> supports it and you want to export this?
>

The reason is to cover a wide range of applications. Your question also 
applies to the gcm NIST publication.

Users may want to use a crypto module that meets the requirements of 
FIPS Pub. for various applications that use variable lengths for IV.

ta
