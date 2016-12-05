From: Yang Shi <yang.shi@windriver.com>
Subject: Re: [PATCH] crypto: rsa - fix a potential race condition in build
Date: Mon, 5 Dec 2016 09:49:29 -0800
Message-ID: <b4e75c35-1a43-b761-af8f-a25977f7390b@windriver.com>
References: <1480722064-31714-1-git-send-email-yang.shi@windriver.com>
 <20161205064800.GA9496@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:45478 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751913AbcLERtj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Dec 2016 12:49:39 -0500
In-Reply-To: <20161205064800.GA9496@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/4/2016 10:48 PM, Herbert Xu wrote:
> On Fri, Dec 02, 2016 at 03:41:04PM -0800, Yang Shi wrote:
>> When building kernel with RSA enabled with multithreaded, the below
>> compile failure might be caught:
>>
>> | /buildarea/kernel-source/crypto/rsa_helper.c:18:28: fatal error: rsapubkey-asn1.h: No such file or directory
>> | #include "rsapubkey-asn1.h"
>> | ^
>> | compilation terminated.
>> | CC crypto/rsa-pkcs1pad.o
>> | CC crypto/algboss.o
>> | CC crypto/testmgr.o
>> | make[3]: *** [/buildarea/kernel-source/scripts/Makefile.build:289: crypto/rsa_helper.o] Error 1
>> | make[3]: *** Waiting for unfinished jobs....
>> | make[2]: *** [/buildarea/kernel-source/Makefile:969: crypto] Error 2
>> | make[1]: *** [Makefile:150: sub-make] Error 2
>> | make: *** [Makefile:24: __sub-make] Error 2
>>
>> The header file is not generated before rsa_helper is compiled, so
>> adding dependency to avoid such issue.
>>
>> Signed-off-by: Yang Shi <yang.shi@windriver.com>
> This should already be fixed in the latest crypto tree.  Could
> you please double-check?

Thanks, Herbert, I just found the commit. Please ignore my patch, sorry 
for the inconvenience.

I will backport that commit to our kernel tree.

Yang

>
> Thanks,
