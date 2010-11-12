From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: [PATCH v1.3 2/4] key: add tpm_send command
Date: Fri, 12 Nov 2010 19:24:50 -0200
Message-ID: <4CDDB0A2.7090606@linux.vnet.ibm.com>
References: <1289514356.2726.18.camel@localhost.localdomain> <1289404309-15955-3-git-send-email-zohar@linux.vnet.ibm.com> <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com> <6651.1289504931@redhat.com>  <22962.1289571072@redhat.com> <1289573330.4341.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	James Morris <jmorris@namei.org>
To: David Safford <safford@watson.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1289573330.4341.31.camel@localhost.localdomain>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



Hi Dave,

On 11/12/2010 12:48 PM, David Safford wrote:

> On Fri, 2010-11-12 at 14:11 +0000, David Howells wrote:
>> Mimi Zohar<zohar@linux.vnet.ibm.com>  wrote:
>>
>>>>> +	module_put(chip->dev->driver->owner);
>>>> Where's the corresponding module_get()?  I suspect this should be wrapped to
>>>> match tpm_chip_find_get().
>>>>
>>>> David
>>> The module_get() is in tpm_chip_find_get(), which is just a helper.
>>> (It's used this way throughout tpm.c)
>> I'd make a function tpm_chip_find_put() just to wrap module_put() and then
>> place it with tpm_chip_find_get() in the sources.  That makes it easier to see
>> what's going on.
> Or alternately rename the helper to tpm_chip_find_and_module_get()?
> In either case, this is really up to Rajiv (the maintainer for tpm.c
> who has already acked this patch), as this usage already appears in
> other places in tpm.c. There would have to be a separate patch fixing
> this for all of the instances. Rajiv, your thoughts?
>
> dave
Rename the helper to tpm_chip_find_and_module_get() solves the naming issue in a simpler and better way in my opinion.

Thanks,
Rajiv

