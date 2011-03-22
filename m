From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: RSA signature verification
Date: Tue, 22 Mar 2011 08:59:56 +0200
Message-ID: <4D8848EC.6070306@nokia.com>
References: <4D875AF9.4060302@nokia.com> <20110321140653.GA14174@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:53865 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab1CVHAI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Mar 2011 03:00:08 -0400
In-Reply-To: <20110321140653.GA14174@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

As I have said in my email that it will be used by IMA/EVM subsystem.
See security/integrity subdirectory in Linux kernel...

Indeed, use of HW accelerator is also on of the targets...

- Dmitry



On 21/03/11 16:06, ext Herbert Xu wrote:
> On Mon, Mar 21, 2011 at 04:04:41PM +0200, Dmitry Kasatkin wrote:
>> Do you think it make sense to have it as a crypto "algo"
>> What kind of API you would have in mind?
> So the obvious question is who will use this functionality in
> the kernel? If the only use is going to be in user-space, then
> the next question is are you doing this for hardware enablement.
>
> Cheers,
