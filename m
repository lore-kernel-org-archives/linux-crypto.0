From: Romain Perier <romain.perier@free-electrons.com>
Subject: Re: [PATCH] crypto: marvell - Copy IVDIG before launching partial DMA
 ahash requests
Date: Wed, 14 Dec 2016 14:59:17 +0100
Message-ID: <e23dc7fb-8096-b729-118e-1b7d79b0fa52@free-electrons.com>
References: <20161214131737.3884-1-romain.perier@free-electrons.com>
 <20161214143943.1dd5508b@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Arnaud Ebalard <arno@natisbad.org>, linux-crypto@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Ofer Heifetz <oferh@marvell.com>, radioconfusion@gmail.com,
        stable@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:52800 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753463AbcLNOAW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Dec 2016 09:00:22 -0500
In-Reply-To: <20161214143943.1dd5508b@bbrezillon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Le 14/12/2016 à 14:39, Boris Brezillon a écrit :


> Nit: can you move the above code in a function called
> mv_cesa_ahash_dma_step()?

Sure

>
>> +	}
>>  	else
>>  		mv_cesa_ahash_std_step(ahashreq);
>
> I'm pretty sure checkpatch complains here ;-).

Probably :P


I will fix these points,

Thanks,
Romain
