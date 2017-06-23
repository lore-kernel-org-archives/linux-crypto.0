From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [bug] sha1-avx2 and read beyond
Date: Fri, 23 Jun 2017 09:39:08 -0700
Message-ID: <ea4d8991-7452-053e-8e53-8dcb6d28f69d@linux.intel.com>
References: <1950313665.4516034.1493507041652.JavaMail.zimbra@redhat.com>
 <502554512.20705544.1495630017500.JavaMail.zimbra@redhat.com>
 <20170623084330.GA30353@gondor.apana.org.au>
 <1943517473.41520875.1498207731142.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
        ilya albrekht <ilya.albrekht@intel.com>,
        maxim locktyukhin <maxim.locktyukhin@intel.com>,
        ronen zohar <ronen.zohar@intel.com>, mouli@linux.intel.com,
        minipli@googlemail.com, hpa@linux.intel.com, marex@denx.de
To: Jan Stancek <jstancek@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        megha.dey@linux.intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:38333 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751488AbdFWQjJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 12:39:09 -0400
In-Reply-To: <1943517473.41520875.1498207731142.JavaMail.zimbra@redhat.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/23/2017 01:48 AM, Jan Stancek wrote:
> 
> 
> ----- Original Message -----
>> On Wed, May 24, 2017 at 08:46:57AM -0400, Jan Stancek wrote:
>>>
>>>
>>> ----- Original Message -----
>>>> Hi,
>>>>
>>>> I'm seeing rare crashes during NFS cthon with krb5 auth. After
>>>> some digging I arrived at potential problem with sha1-avx2.
>>>
>>> Adding more sha1_avx2 experts to CC.
>>>
>>>>
>>>> Problem appears to be that sha1_transform_avx2() reads beyond
>>>> number of blocks you pass, if it is an odd number. It appears
>>>> to try read one block more. This creates a problem if it falls
>>>> beyond a page and there's nothing there.
>>>
>>> As noted in my reply, worst case appears to be read ahead
>>> of up to 3 SHA1 blocks beyond end of data:
>>>   http://marc.info/?l=linux-crypto-vger&m=149373371023377
>>>
>>>  +----------+---------+---------+---------+
>>>  | 2*SHA1_BLOCK_SIZE  | 2*SHA1_BLOCK_SIZE |
>>>  +----------+---------+---------+---------+
>>>             ^ page boundary
>>>     ^ data end
>>>
>>> It is still reproducible with 4.12-rc2.
>>
>> Can someone from Intel please look into this? Otherwise we'll have
>> to disable sha-avx2.
> 
> So I take it my workaround patch [1] is not acceptable in
> short-term as well?
> 
> [1] http://marc.info/?l=linux-crypto-vger&m=149373371023377
> 
> Regards,
> Jan
> 

Megha,

Can you take a look at this issue?

Thanks.

Tim
