From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] SP800-38F / RFC3394 key wrapping
Date: Fri, 01 May 2015 09:27:07 +0200
Message-ID: <43350012.VMEhAijB9c@tauon>
References: <1515730.LIeS5qas5m@myon.chronox.de> <1906826.TjaHhvv93b@myon.chronox.de> <20150501032035.GA371@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34650 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbbEAH1J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 May 2015 03:27:09 -0400
In-Reply-To: <20150501032035.GA371@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 1. Mai 2015, 11:20:35 schrieb Herbert Xu:

Hi Herbert,

>On Tue, Apr 28, 2015 at 04:58:31AM +0200, Stephan Mueller wrote:
>> Hm, in case of dm-crypt, that is not really possible, because this is fully
>> driven by user space: libcryptsetup sets up a temporary dm-crypt container
>> for the LUKS header space. Then user space accesses the data it needs and
>> re- injects it into the kernel for the bulk encryption dm-crypt component.
>If both user-space and the kernel implements the same algorithm
>correctly why wouldn't it work?

User space does not use any ciphers to protect the key, that is the 
interesting part. The LUKS header will be mapped by a dm-crypt mapping and 
then read from user space to access the key. So, userspace does not en/decrypt 
the data.

Ciao
Stephan
