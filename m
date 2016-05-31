From: Nicolai Stange <nicstange@gmail.com>
Subject: Re: [PATCH 0/5] refactor mpi_read_from_buffer()
Date: Tue, 31 May 2016 21:07:29 +0200
Message-ID: <87r3cihwr2.fsf@gmail.com>
References: <1464297595-24032-1-git-send-email-nicstange@gmail.com>
	<20160531101909.GL15376@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Nicolai Stange <nicstange@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Michal Marek <mmarek@suse.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36152 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbcEaTHc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 15:07:32 -0400
In-Reply-To: <20160531101909.GL15376@gondor.apana.org.au> (Herbert Xu's
	message of "Tue, 31 May 2016 18:19:09 +0800")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Thu, May 26, 2016 at 11:19:50PM +0200, Nicolai Stange wrote:
>> mpi_read_from_buffer() and mpi_read_raw_data() do almost the same and share a
>> fair amount of common code.
>> 
>> This patchset attempts to rewrite mpi_read_from_buffer() in order to implement
>> it in terms of mpi_read_raw_data().
>> 
>> The patches 1 and 3, i.e.
>>   "lib/mpi: mpi_read_from_buffer(): return error code"
>> and
>>   "lib/mpi: mpi_read_from_buffer(): return -EINVAL upon too short buffer"
>> do the groundwork in that they move any error detection unique to
>> mpi_read_from_buffer() out of the data handling loop.
>> 
>> The patches 2 and 4, that is
>>   "lib/digsig: digsig_verify_rsa(): return -EINVAL if modulo length is zero"
>> and
>>   "lib/mpi: mpi_read_from_buffer(): sanitize short buffer printk"
>> are not strictly necessary for the refactoring: they cleanup some minor oddities
>> related to error handling I came across.
>> 
>> Finally, the last patch in this series,
>>   "lib/mpi: refactor mpi_read_from_buffer() in terms of mpi_read_raw_data()"
>> actually does what this series is all about.
>> 
>> 
>> Applicable to linux-next-20160325.
>
> All applied.

Thanks! (As well as for applying the separately sent patches, of course)
