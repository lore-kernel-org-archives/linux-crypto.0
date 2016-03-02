From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] crypto: implement DH primitives under akcipher API
Date: Wed, 2 Mar 2016 06:54:21 -0800
Message-ID: <69E0CA7E-C7A5-4AC5-8FC1-930A115F6F66@holtmann.org>
References: <1455526915-23104-1-git-send-email-salvatore.benedetto@intel.com> <20160302095351.GB2384@sbenedet-virtual-machine> <CACXcFmmuBJR93nW+-Qp2Yo95EXzuz+RXyH9_hw+RVXFqYZtgrw@mail.gmail.com> <1547276.hIHXt6xUvB@positron.chronox.de>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Sandy Harris <sandyinchina@gmail.com>,
	Salvatore Benedetto <salvatore.benedetto@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	tadeusz.struk@intel.com, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [82.165.8.211] ([82.165.8.211]:55698 "EHLO mail.holtmann.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753603AbcCBOy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Mar 2016 09:54:26 -0500
In-Reply-To: <1547276.hIHXt6xUvB@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

>>>>>>> +static int dh_check_params_length(unsigned int p_len)
>>>>>>> +{
>>>>>>> +       switch (p_len) {
>>>>>>> +       case 768:
>>>>>>> +       case 1024:
>>>>>>> +       case 1536:
>>>>>>> +       case 2048:
>>>>>>> +       case 3072:
>>>>>>> +       case 4096:
>>>>>>> +               return 0;
>>>>>>> +       }
>>>>>>> +       return -EINVAL;
>>>>>>> +}
>> 
>> As far back as 1999, the FreeS/WAN project refused to
>> implement the 768-bit IPsec group 1 (even though it was
>> the only one required by the RFCs) because it was not thought
>> secure enough. I think the most-used group was 1536-bit
>> group 5; it wasn't in the original RFCs but nearly everyone
>> implemented it.
>> 
>>>> And besides, I would like to disallow all < 2048 right from the start.
>> 
>> I'm not up-to-date on the performance of attacks. You may be right,
>> or perhaps the minimum should be even higher. Certainly there is
>> no reason to support 768 or 1024-bit groups.
>> 
>> On the other hand, we should consider keeping the 1536-bit
>> group since it is very widely used, likely including by people
>> we'll want to interoperate with.
> 
> Considering the recent attacks which kind of broke DH <= 768, all smaller than 
> 1024 is not to be used any more. Even 1024 bit is not too far off from 768 so 
> I would consider not using 1024 to keep a safety margin.
> 
> It is widely suggested to use 2048 and higher. But for compatibility, I agree 
> with 1536.
> 
> However, that leaves us with the open question for the upper bound. I have no 
> idea which sizes hardware may implement. But considering that OpenSSH uses DH 
> up to and including 8192 these days (see /etc/ssh/moduli), I would suggest to 
> allow 8192 too.
> 
> In addition, we should all be prepared to increase the limit with a reasonable 
> effort. Thus, if we have implementations covering hardware support, they 
> should cope with reasonable efforts.

and why is this not an userspace policy decision on what minimum it allows? Why are we discussing this in the context of the kernel in the first place? The kernel should just expose the support for it.

Regards

Marcel
