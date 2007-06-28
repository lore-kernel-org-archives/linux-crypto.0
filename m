From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC 0/2] AES ablkcipher driver for SPUs
Date: Thu, 28 Jun 2007 13:24:51 +0200
Message-ID: <20070628112451.GA29054@Chamillionaire.breakpoint.cc>
References: <20070626225952.GA4571@Chamillionaire.breakpoint.cc> <20070627102420.GA11016@2ka.mipt.ru> <20070627114159.GA6456@Chamillionaire.breakpoint.cc> <20070628105034.GA3771@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33618 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759841AbXF1LZR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Jun 2007 07:25:17 -0400
Content-Disposition: inline
In-Reply-To: <20070628105034.GA3771@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Evgeniy Polyakov | 2007-06-28 14:50:36 [+0400]:

>On Wed, Jun 27, 2007 at 01:41:59PM +0200, Sebastian Siewior (linux-crypto@ml.breakpoint.cc) wrote:
>> Yes I do. Those number are gathered from a PS3 and with a sync
>> interface. sync means the SPU is idle, I queue the request, start the
>> SPU, SPU requests the data, waits from completion, computes it,
>> transfers it back and finally the SPU stops (idle again). Oh and only
>> one SPU is used.
>> The test is generated with a simple module that allocated four pages (16
>> kb) and calls the SPU crypto code over and over again until approx 156
>> MB of memory passed/processed. From the time and total size I get my
>> kb/sec.
>...
>> [1] http://breakpoint.cc/spu_aes/spu_code.png
>> [2] http://breakpoint.cc/spu_aes/spu_sync_blocksize.png
>
>Mmm, looks really good. Did powerpc folks acked this changes?
I submitted some patches last week or two weeks ago to the cbe-oss-dev
ml and I did not get a nack. Just style, naming and this sort of things.
I plan to clean those up (address all issues) and post it once again.
Maybe, the IV problem is solved until then :)

>-- 
>	Evgeniy Polyakov
Sebastian
