From: Stewart Smith <stewart@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] crypto: vmx - Adding asm subroutines for XTS
Date: Wed, 13 Jul 2016 13:05:03 +1000
Message-ID: <8737nep7a8.fsf@linux.vnet.ibm.com>
References: <1468264060-22769-1-git-send-email-pfsmorigo@linux.vnet.ibm.com> <20160712093705.6f0fde7a@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
	"open list\:IBM Power VMX Cryptographic instructions"
	<linux-crypto@vger.kernel.org>,
	"open list\:LINUX FOR POWERPC 32-BIT AND 64-BIT"
	<linuxppc-dev@lists.ozlabs.org>,
	"David S. Miller" <davem@davemloft.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11359 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750816AbcGMDFx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 23:05:53 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6D33b47042647
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2016 23:05:42 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
	by mx0b-001b2d01.pphosted.com with ESMTP id 24567bk93r-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2016 23:05:42 -0400
Received: from localhost
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <stewart@linux.vnet.ibm.com>;
	Tue, 12 Jul 2016 21:05:41 -0600
In-Reply-To: <20160712093705.6f0fde7a@canb.auug.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Stephen Rothwell <sfr@canb.auug.org.au> writes:
> On Mon, 11 Jul 2016 16:07:39 -0300 Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com> wrote:
>>
>> diff --git a/drivers/crypto/vmx/aesp8-ppc.pl b/drivers/crypto/vmx/aesp8-ppc.pl
>> index 2280539..813ffcc 100644
>> --- a/drivers/crypto/vmx/aesp8-ppc.pl
>> +++ b/drivers/crypto/vmx/aesp8-ppc.pl
>> @@ -1,4 +1,11 @@
>> -#!/usr/bin/env perl
>> +#! /usr/bin/env perl
>> +# Copyright 2014-2016 The OpenSSL Project Authors. All Rights Reserved.
>> +#
>> +# Licensed under the OpenSSL license (the "License").  You may not use
>> +# this file except in compliance with the License.  You can obtain a copy
>> +# in the file LICENSE in the source distribution or at
>> +# https://www.openssl.org/source/license.html
>
> So, I assume that this license is compatible with the GPLv2?

https://people.gnome.org/~markmc/openssl-and-the-gpl.html has an
explanation and points to:
https://www.openssl.org/docs/faq.html#LEGAL2

which makes it anything but clearer.

it appears the answer is "probably not, unless you have an explicit
exemption in your license"

-- 
Stewart Smith
OPAL Architect, IBM.
