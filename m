From: Harsh Jain <harsh@chelsio.com>
Subject: Re: [PATCH v3 1/4] crypto: AF_ALG AIO - lock context IV
Date: Thu, 15 Feb 2018 11:00:36 +0530
Message-ID: <d6890111-fc19-7f97-c13b-2c217145b0a5@chelsio.com>
References: <2118226.LQArbCsRu5@tauon.chronox.de>
 <4507333.JelVKMRNjF@positron.chronox.de>
 <617281e5-543c-0d8c-1fa6-56c4a65cc515@chelsio.com>
 <2080270.jPJprzxrh7@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:33627 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751930AbeBOFaw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 00:30:52 -0500
In-Reply-To: <2080270.jPJprzxrh7@tauon.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 14-02-2018 18:22, Stephan Mueller wrote:
> Am Mittwoch, 14. Februar 2018, 06:43:53 CET schrieb Harsh Jain:
>
> Hi Harsh,
>
>> Patch set is working fine with chelsio Driver.
> Thank you.
>
>> Do we really need IV locking mechanism for AEAD algo because AEAD algo's
>> don't support Partial mode operation and Driver are not updating(atleast
>> Chelsio) IV's on AEAD request completions.
> Yes, I think we would need it. It is technically possible to have multiple 
> IOCBs for AEAD ciphers. Even though your implementation may not write the IV 
> back, others may do that. At least I do not see a guarantee that the IV is 
> *not* written back by a driver.
There is no  use of writing IV back in AEAD algo till Framework starts supporting Partial mode.
Even if Driver starts updating IV for AEAD, Multiple IOCB's in both cases will yield wrong results only.

Case 1 : If we have AEAD IV serialization  applied,  Encryption will be wrong if same IV gets used.
Case 2: If we do not have IV serialization for AEAD. Encryption will be fine but user will have multiple Authentication  tag (that too with final block processed).  Its like 2nd Block encryption is based on IV received from 1st block  and Authentication Tag value is based on 2nd block content only.

>
> In case your driver does not write the IV back and thus does not need to 
> serialize, the driver can report CRYPTO_ALG_SERIALIZES_IV_ACCESS. In this 
> case, the higher level functions would not serialize as the driver serializes 
> the requests (or the driver deems it appropriate that no serialization is 
> needed as is the case with your driver).
>
> Ciao
> Stephan
>
>
