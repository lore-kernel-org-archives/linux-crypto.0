Return-Path: <SRS0=KZld=OW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-io1-f66.google.com ([209.85.166.66]:43434 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728115AbeLMTme (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Dec 2018 14:42:34 -0500
Received: by mail-io1-f66.google.com with SMTP id l3so2542862ioc.10
        for <linux-crypto@vger.kernel.org>; Thu, 13 Dec 2018 11:42:33 -0800 (PST)
Subject: Re: [PATCH 2/2] scsi: ufs: add inline crypto support to UFS HCD
To: Ladvine D Almeida <ladvine.dalmeida@synopsys.com>,
        Parshuram Raju Thombare <pthombar@cadence.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc: "vinholikatti@gmail.com" <vinholikatti@gmail.com>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "mchehab+samsung@kernel.org" <mchehab+samsung@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Alan Douglas <adouglas@cadence.com>,
        Janek Kotas <jank@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>,
        AnilKumar Chimata <anilc@codeaurora.org>,
        Satya Tangirala <satyat@google.com>,
        Paul Crowley <paulcrowley@google.com>,
        Manjunath M Bettegowda <manjunath.mb@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <20181211095027.GA3316@lvlogina.cadence.com>
 <20181211181647.GC221175@gmail.com>
 <CO2PR07MB2469AD9C0A121EBF94129A11C1A70@CO2PR07MB2469.namprd07.prod.outlook.com>
 <BD7FB879CC136E419544C8E2AE7B9C30227EE5@IN01WEMBXA.internal.synopsys.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <fb17d794-c682-3261-cbad-94ce4c14eea1@kernel.dk>
Date: Thu, 13 Dec 2018 12:42:30 -0700
MIME-Version: 1.0
In-Reply-To: <BD7FB879CC136E419544C8E2AE7B9C30227EE5@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/13/18 12:39 PM, Ladvine D Almeida wrote:
> Suggest to take a look into the article https://lwn.net/Articles/717754
> My real concern is how to achieve it without any modifications to the
> bio.(because key slot information has to finally reach the target block
> device)

Guys, you both need to edit when you reply, wading through 650 lines of
text to get to this...

You obviously can't modify the bio if you don't own it, but you could
clone it and then you have storage in ->bi_private.

-- 
Jens Axboe
