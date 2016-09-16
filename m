From: Romain Perier <romain.perier@free-electrons.com>
Subject: Re: [PATCH v2 3/8] hwrng: omap - Switch to non-obsolete read API
 implementation
Date: Fri, 16 Sep 2016 12:11:26 +0200
Message-ID: <57DBC54E.2010102@free-electrons.com>
References: <20160907155743.6403-1-romain.perier@free-electrons.com>
 <20160907155743.6403-4-romain.perier@free-electrons.com>
 <20160913094825.GA30645@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: dsaxena@plexity.net, mpm@selenic.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Omri Itach <omrii@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Yahuda Yitschak <yehuday@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Neta Zur Hershkovits <neta@marvell.com>,
        Igal Liberman <igall@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:60795 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752920AbcIPKLj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2016 06:11:39 -0400
In-Reply-To: <20160913094825.GA30645@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Le 13/09/2016 11:48, Herbert Xu a écrit :
> On Wed, Sep 07, 2016 at 05:57:38PM +0200, Romain Perier wrote:
>> +
>> +static int omap_rng_do_read(struct hwrng *rng, void *data, size_t max,
>> +			    bool wait)
>>   {
>>   	struct omap_rng_dev *priv;
>> -	int data, i;
>>
>>   	priv = (struct omap_rng_dev *)rng->priv;
>>
>> -	for (i = 0; i < 20; i++) {
>> -		data = priv->pdata->data_present(priv);
>> -		if (data || !wait)
>> -			break;
>> -		/* RNG produces data fast enough (2+ MBit/sec, even
>> -		 * during "rngtest" loads, that these delays don't
>> -		 * seem to trigger.  We *could* use the RNG IRQ, but
>> -		 * that'd be higher overhead ... so why bother?
>> -		 */
>> -		udelay(10);
>
> So in the wait case you're changing the driver's behaviour.  Instead
> of waiting for 1us you'll now wait for 1s if there is no data.  Is
> this what really what you want?
>
> Cheers,
>

Mhhh, you're right, in this specific case it will add more latency... 
with busy loop, on average, 20 retries will be enough to have data...

Thanks!
-- 
Romain Perier, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
