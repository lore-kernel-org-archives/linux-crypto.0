From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH v3]crypto:hifn_795x.c Fix warning: variable 'ctx' set
 but not used
Date: Wed, 14 Jul 2010 06:35:59 -0700
Message-ID: <4C3DBD3F.3010808@gmail.com>
References: <1278441397-10960-1-git-send-email-justinmattock@gmail.com> <20100714121204.GA11194@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net, jkosina@suse.cz,
	kim.phillips@freescale.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38698 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab0GNNgC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Jul 2010 09:36:02 -0400
Received: by pvc7 with SMTP id 7so2724997pvc.19
        for <linux-crypto@vger.kernel.org>; Wed, 14 Jul 2010 06:36:02 -0700 (PDT)
In-Reply-To: <20100714121204.GA11194@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/14/2010 05:12 AM, Herbert Xu wrote:
> On Tue, Jul 06, 2010 at 11:36:37AM -0700, Justin P. Mattock wrote:
>> The below patch gets rid of an unused variable ctx reported by
>> GCC when building the kernel.
>>    CC [M]  drivers/crypto/hifn_795x.o
>> drivers/crypto/hifn_795x.c: In function 'hifn_flush':
>> drivers/crypto/hifn_795x.c:2021:23: warning: variable 'ctx' set but not used
>> drivers/crypto/hifn_795x.c: In function 'hifn_process_queue':
>> drivers/crypto/hifn_795x.c:2142:23: warning: variable 'ctx' set but not used
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>
> Patch applied.  Thanks Justin!

o.k.!!

cheers,

Justin P. Mattock
