From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Thu, 17 Jul 2014 13:35:15 -0700
Message-ID: <53C83383.4040507@amacapital.net>
References: <201407171848.s6HImBb4027900@glazunov.sibelius.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	beck@openbsd.org
To: Mark Kettenis <mark.kettenis@xs4all.nl>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:64165 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaGQUfT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Jul 2014 16:35:19 -0400
Received: by mail-pd0-f171.google.com with SMTP id z10so3743289pdj.16
        for <linux-crypto@vger.kernel.org>; Thu, 17 Jul 2014 13:35:18 -0700 (PDT)
In-Reply-To: <201407171848.s6HImBb4027900@glazunov.sibelius.xs4all.nl>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/17/2014 11:48 AM, Mark Kettenis wrote:
> On Thu, Jul 17, 2014, Theodore Ts'o wrote:
>>
>> The getrandom(2) system call is a superset of getentropy(2).  When we
>> add the support for this into glibc, it won't be terribly difficult
>> nor annoying to drop the following in alongside the standard support
>> needed for any new system call:
>>
>> int getentropy(void *buf, size_t buflen)
>> {
>> 	int	ret;
>>
>> 	ret = getentropy(buf, buflen, 0);
>> 	return (ret > 0) ? 0 : ret;
>> }
> 
> I'm sure you meant to use getrandom() there ;)
> 
> Since for LibreSSL we'd want a getentropy() that cannot fail the
> getrandom() call should use GRND_BLOCK flag.  Actually it makes sense
> (to me) to make blocking the default behaviour and have a
> BRND_NONBLOCK flag.  Much in the same way as you need to specify
> O_NONBLOCK if you want non-blocking behaviour for files.
> 

Can we please have a mode in which getrandom(2) can neither block nor
fail?  If that gets added, then this can replace things like AT_RANDOM.

There are non-crypto things out there that will want this.  There are
also probably VM systems (especially ones that have something like my
KVM_GET_RNG_SEED patches applied, or many VMs on Haswell, for that
matter) that will have perfectly fine cryptographically secure urandom
output immediately after bootup but that won't consider themselves
"initialized" for a while.  At least these will be perfectly fine from
the POV of those who trust their hypervisor and Intel :)

--Andy
