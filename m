From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH] KEYS: Add optional key derivation parameters for DH
Date: Tue, 31 May 2016 09:25:46 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1605310912390.4028@mjmartin-mac01.local>
References: <20160526165741.2634-1-mathew.j.martineau@linux.intel.com> <23038.1464293450@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>,
	smueller@chronox.de, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4117 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154AbcEaQZs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 12:25:48 -0400
In-Reply-To: <23038.1464293450@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 26 May 2016, David Howells wrote:

> Mat Martineau <mathew.j.martineau@linux.intel.com> wrote:
>
>> +struct keyctl_kdf_params {
>> +	char *name;
>> +	__u8 reserved[32]; /* Reserved for future use, must be 0 */
>> +};
>> +
>>  #endif /*  _LINUX_KEYCTL_H */
>> diff --git a/security/keys/compat.c b/security/keys/compat.c
>> index c8783b3..36c80bf 100644
>> --- a/security/keys/compat.c
>> +++ b/security/keys/compat.c
>> @@ -134,7 +134,7 @@ COMPAT_SYSCALL_DEFINE5(keyctl, u32, option,
>>
>>  	case KEYCTL_DH_COMPUTE:
>>  		return keyctl_dh_compute(compat_ptr(arg2), compat_ptr(arg3),
>> -					 arg4);
>> +					 arg4, compat_ptr(arg5));
>
> Given the new structure above, this won't work.  The problem is that on a
> 64-bit system the kernel expects 'name' to be a 64-bit pointer, but if we're
> in the compat handler, we have a 32-bit userspace's idea of the struct - in
> which 'name' is a 31-bit (s390x) or a 32-bit pointer without any padding.
>
> So in compat code you can't just pass the user pointer direct through to
> keyctl_dh_compute().  You need to supply a compat_keyctl_kdf_params struct and
> translator code.

Since none of the members of the structure were accessed, I thought the 
simple conversion was adequate for the null check and was deferring the 
real compat handling until the rest of the structure was known. I should 
have explained that in a comment.

> What I would recommend you do at the moment is to mark the syscall argument as
> "reserved, must be 0" and deal with the implementation in the next merge
> window.

Yeah, there's not much value in defining the keyctl_kdf_params struct and 
then not using it. Should have kept it simple.

Thanks to you and Stephan for updating the patch and moving things along.


Regards,

--
Mat Martineau
Intel OTC
