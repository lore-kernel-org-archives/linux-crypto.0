From: Denis Kenzior <denkenz@gmail.com>
Subject: Re: [PATCH 4/8] crypto: rsa-pkcs1pad - Require hash to be present
Date: Wed, 22 Jun 2016 09:19:16 -0500
Message-ID: <576A9E64.2020209@gmail.com>
References: <20160622101432.GA30454@gondor.apana.org.au>
 <E1bFfDK-0007yq-FV@gondolin.me.apana.org.au>
 <CAOq732+p7M5Cn2mPnbN3H3tkxvjf_UkKqQSR+eceBp4-CJYh-w@mail.gmail.com>
 <20160622140225.GA315@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Andrzej Zaborowski <andrew.zaborowski@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34993 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbcFVOTT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 10:19:19 -0400
Received: by mail-pa0-f51.google.com with SMTP id hl6so17383186pac.2
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jun 2016 07:19:18 -0700 (PDT)
In-Reply-To: <20160622140225.GA315@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On 06/22/2016 09:02 AM, Herbert Xu wrote:
> On Wed, Jun 22, 2016 at 03:20:51PM +0200, Andrzej Zaborowski wrote:
>>
>> We use pkcs1pad with AF_ALG to implement lightweight TLS.  TLS
>> versions < 1.2 use a non-standard hash so we'd have to move the PKCS#1
>> padding back to userspace if this is changed.
>
> When this is submitted for upstream inclusion we can add support
> for it.
>

Just to clarify, we use this from userspace.  So we _already_ depend on 
this functionality.  Please keep the hash and non-hash versions of 
pkcs1pad available.

Regards,
-Denis
