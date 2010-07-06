From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH v3]crypto:hifn_795x.c Fix warning: variable 'ctx' set
 but not used
Date: Tue, 06 Jul 2010 12:27:16 -0700
Message-ID: <4C338394.1030708@gmail.com>
References: <1278441397-10960-1-git-send-email-justinmattock@gmail.com> <20100706185853.GA27664@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, jkosina@suse.cz, kim.phillips@freescale.com
To: Evgeniy Polyakov <zbr@ioremap.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:63519 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab0GFT0l (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Jul 2010 15:26:41 -0400
Received: by pxi14 with SMTP id 14so2317341pxi.19
        for <linux-crypto@vger.kernel.org>; Tue, 06 Jul 2010 12:26:40 -0700 (PDT)
In-Reply-To: <20100706185853.GA27664@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/06/2010 11:58 AM, Evgeniy Polyakov wrote:
> On Tue, Jul 06, 2010 at 11:36:37AM -0700, Justin P. Mattock (justinmattock@gmail.com) wrote:
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
> Looks good, thank you.
> I can only wonder how I wanted to use it in that context...
>

sure no problem.. s for the question how I wanted to use it in that 
context... not sure.. if you have any ideas, let me know I can test it 
out for you..

Justin P. Mattock
