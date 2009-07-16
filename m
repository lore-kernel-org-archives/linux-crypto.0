From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [1/9] Convert padlock sha to shash
Date: Fri, 17 Jul 2009 00:23:45 +0200
Message-ID: <20090716222345.GA7790@Chamillionaire.breakpoint.cc>
References: <20090711101958.GA14642@gondor.apana.org.au> <20090714202615.GA21476@Chamillionaire.breakpoint.cc> <20090715004847.GA17017@gondor.apana.org.au> <20090715220606.GA30627@Chamillionaire.breakpoint.cc> <20090716021601.GA28776@gondor.apana.org.au> <20090716023413.GA28905@gondor.apana.org.au> <20090716073630.GA1294@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60041 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751593AbZGPWXr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Jul 2009 18:23:47 -0400
Content-Disposition: inline
In-Reply-To: <20090716073630.GA1294@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Sebastian Andrzej Siewior | 2009-07-16 09:36:30 [+0200]:

>* Herbert Xu | 2009-07-16 10:34:13 [+0800]:
>
>>On Thu, Jul 16, 2009 at 10:16:01AM +0800, Herbert Xu wrote:
>>>
>>> Can you please pull my tree again? There were quite a few bugs
>>> that I fixed last night.
>>
>>Oh and please make sure you have this patch applied too:
>
>It passes the testmgr with that patch on top. I try that ip xfrm thing
>later today.

Okay, Herbert it is working. I've setup a tunnel between two boxes and
was able to ping and copy stuff from /dev/zero on one box to /dev/null
on the other. 

Sebastian
