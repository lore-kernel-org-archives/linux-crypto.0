From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: Re: [PATCH] crypto: change hwrng device default permissions to 0444
Date: Thu, 13 Jul 2017 09:01:03 +0200
Message-ID: <d28602be-740c-b0d4-246a-422316ee5c82@linux.vnet.ibm.com>
References: <1499078279-19135-1-git-send-email-freude@linux.vnet.ibm.com>
 <20170712101356.GA21862@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, schwidefsky@de.ibm.com,
        Christian.Rund@de.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34492 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751170AbdGMHBP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jul 2017 03:01:15 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6D6wgZP071095
        for <linux-crypto@vger.kernel.org>; Thu, 13 Jul 2017 03:01:09 -0400
Received: from e06smtp11.uk.ibm.com (e06smtp11.uk.ibm.com [195.75.94.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bnt3q2uxp-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Thu, 13 Jul 2017 03:01:09 -0400
Received: from localhost
        by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.vnet.ibm.com>;
        Thu, 13 Jul 2017 08:01:07 +0100
In-Reply-To: <20170712101356.GA21862@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/12/2017 12:13 PM, Herbert Xu wrote:
> On Mon, Jul 03, 2017 at 12:37:59PM +0200, Harald Freudenberger wrote:
>> Currently /dev/hwrng uses default device node permissions
>> which is 0600. So by default the device node is not accessible
>> by an ordinary user. Some distros do rewrite the device node
>> permissions via udev rule, others don't. This patch provides
>> 0444 as the new mode value and so makes the device node
>> accessible for all users without the need to have udev rules
>> rewriting the access rights.
>>
>> Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
> Hmm, one usage scenario for /dev/hwrng is to feed rngd which then
> feeds into /dev/random.  In that case it may not be desirable to
> allow arbitrary access to hwrgn since it may cause the rate of
> entropy going into /dev/random to go down.
>
> In any case, as you noted userspace can change this anyway so I
> don't see why we need to make this policy change in the kernel.
>
> Cheers,
It was worth a try to get rid of complains from customers.
However, your argument about the possible weakness in
the entropy pool for /dev/random with pumping hwrng dry
does not really fit: This can be easier done by just pulling
random directly from /dev/random, as every distro I could
get a hand on uses crw-rw-rw- permissions on /dev/random
and /dev/urandom.

Thanks
Harald Freudenberger
