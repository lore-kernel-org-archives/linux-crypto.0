From: Tapas Sarangi <TSarangi@trustwave.com>
Subject: Re: RSA key size not allowed in FIPS
Date: Tue, 9 Aug 2016 15:00:00 +0000
Message-ID: <D3CF597F.289B%tsarangi@trustwave.com>
References: <D3CF4E8C.2883%tsarangi@trustwave.com>
 <2825660.AnRQGUh0XD@tauon.atsec.com> <D3CF5455.2887%tsarangi@trustwave.com>
 <21317106.O9C0GvNNQc@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>,
	"dhowells@redhat.com" <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from seg-node-elk-02.trustwave.com ([204.13.202.189]:17200 "EHLO
	seg-node-elk-02.trustwave.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932428AbcHIPAF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 11:00:05 -0400
In-Reply-To: <21317106.O9C0GvNNQc@positron.chronox.de>
Content-Language: en-US
Content-ID: <9C1B42840EF5E946887B9099C7993AFE@namprd07.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Embarrassing! Yes, I just saw this while you are pressing send on that
replyä default bits were set to 4096 in x509.genkey. :-(

I am trying out with 2048 bits. I will confirm.

-Tapas


On 8/9/16, 9:55 AM, "Stephan Mueller" <smueller@chronox.de> wrote:

>Am Dienstag, 9. August 2016, 14:39:03 CEST schrieb Tapas Sarangi:
>
>Hi Tapas, David,
>
>> Hi Stephan,
>>
>> If I understand this correctly, this (CONFIG_MODULE_SIG_HASH=≥sha256")
>> tells about the key size used.
>> I am using ≥sha256≤. Initially, I was using ≥sha512≤ which I thought
>>could
>> be causing problem, but I am getting same error when change it to
>> ≥sha256≤.
>>
>> [root@localhost ~]# grep MODULE_SIG /boot/config-4.7.0-1.tos2_5
>>
>> CONFIG_MODULE_SIG=y
>> # CONFIG_MODULE_SIG_FORCE is not set
>> CONFIG_MODULE_SIG_ALL=y
>> # CONFIG_MODULE_SIG_SHA1 is not set
>> # CONFIG_MODULE_SIG_SHA224 is not set
>> CONFIG_MODULE_SIG_SHA256=y
>> # CONFIG_MODULE_SIG_SHA384 is not set
>> # CONFIG_MODULE_SIG_SHA512 is not set
>> CONFIG_MODULE_SIG_HASH="sha256"
>> CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
>
>It is rather the question how signing_key.pem is generated.
>
>Do you have the file certs/x509.genkey? If yes, what is the default_bits
>value?
>
>David, the x509.genkey file seems to generate a 4k RSA key per default.
>This
>will cause a panic with fips=1 as only 2k and 3k keys are allowed.
>
>Ciao
>Stephan


________________________________

This transmission may contain information that is privileged, confidential, and/or exempt from disclosure under applicable law. If you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution, or use of the information contained herein (including any reliance thereon) is strictly prohibited. If you received this transmission in error, please immediately contact the sender and destroy the material in its entirety, whether in electronic or hard copy format.
