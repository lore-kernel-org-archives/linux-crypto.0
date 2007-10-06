From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [crypto] load the SHA1[1|256] module by an alias
Date: Sat, 6 Oct 2007 23:54:08 +0200
Message-ID: <20071006215408.GA3645@Chamillionaire.breakpoint.cc>
References: <E1IMveX-0002Kv-00@gondolin.me.apana.org.au> <20070820101618.GE16680@bingen.suse.de> <20070820120605.GA13163@gondor.apana.org.au> <20070930124239.GB24811@Chamillionaire.breakpoint.cc> <20071003073522.GA7285@gondor.apana.org.au> <20071004083512.GA11305@Chamillionaire.breakpoint.cc> <E1IdMSX-0004KV-LS@Chamillionaire.breakpoint.cc> <20071005085744.GC10959@gondor.apana.org.au> <20071005135056.GA19693@Chamillionaire.breakpoint.cc> <20071005142022.GA13265@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38207 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765646AbXJFVyP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Oct 2007 17:54:15 -0400
Content-Disposition: inline
In-Reply-To: <20071005142022.GA13265@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-10-05 22:20:22 [+0800]:

>On Fri, Oct 05, 2007 at 03:50:56PM +0200, Sebastian Siewior wrote:
>>
>> I did not find a module_mutex. We hold a readlock of crypto_alg_sem
>> within the crypto subsystem and request_module() increments
>> kmod_concurrent (which may not exceed a certain limit). 
>
>However, it's still good to remove this code since doing a nested
>modprobe of "sha" within a modprobe of "sha" just feels wrong.

Yes it feels wrong. It even may show that the fallback is not available
if padlock is loaded before the generic ones.

Sebastian
