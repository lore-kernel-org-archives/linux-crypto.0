From: Nicolai Stange <nicstange@gmail.com>
Subject: Re: [PATCH RESEND v2 00/14] lib/mpi: bug fixes and cleanup
Date: Tue, 22 Mar 2016 08:06:41 +0100
Message-ID: <87mvprrny6.fsf@gmail.com>
References: <1458566775-5239-1-git-send-email-nicstange@gmail.com>
	<56F0D00C.7000005@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Nicolai Stange <nicstange@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Michal Marek <mmarek@suse.com>,
	Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36557 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbcCVHGo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Mar 2016 03:06:44 -0400
In-Reply-To: <56F0D00C.7000005@intel.com> (Tadeusz Struk's message of "Mon, 21
	Mar 2016 21:54:36 -0700")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hi Tadeusz,

thank you very much for your quick reply!

Tadeusz Struk <tadeusz.struk@intel.com> writes:
> On 03/21/2016 06:26 AM, Nicolai Stange wrote:
>> This is a resend of v2 with the crypto people properly CC'd.
>> 
>> The original v1 can be found here:
>> 
>>   http://lkml.kernel.org/g/1458237606-4954-1-git-send-email-nicstange@gmail.com
>> 
>> 
>> While v1 (hopefully) fixed some issues in mpi_write_sgl() and
>> mpi_read_buffer() introduced by
>>   commit 2d4d1eea540b ("lib/mpi: Add mpi sgl helpers") and by
>>   commit 9cbe21d8f89d ("lib/mpi: only require buffers as big as needed for
>>                         the integer"),
>> I missed that there are some, including out-of-bounds buffer accesses,
>> in mpi_read_raw_from_sgl() as well.
>> 
>> Hence v2, which includes the original stuff from v1 plus my new fixes to
>> mpi_read_raw_from_sgl().
>> 
>> 
>> Applicable to linux-next-20160318.
>> 
>> 
>> Changes to v1:
>>   - [1-8/14]
>>     former [1-8/8], unchanged.
>> 
>>   - [9-14/14]
>>     Added in v2. Fixes to mpi_read_raw_from_sgl().
>> 
>> Nicolai Stange (14):
>>   lib/mpi: mpi_write_sgl(): fix skipping of leading zero limbs
>>   lib/mpi: mpi_write_sgl(): fix style issue with lzero decrement
>>   lib/mpi: mpi_write_sgl(): purge redundant pointer arithmetic
>>   lib/mpi: mpi_write_sgl(): fix out-of-bounds stack access
>>   lib/mpi: mpi_write_sgl(): replace open coded endian conversion
>>   lib/mpi: mpi_read_buffer(): optimize skipping of leading zero limbs
>>   lib/mpi: mpi_read_buffer(): replace open coded endian conversion
>>   lib/mpi: mpi_read_buffer(): fix buffer overflow
>>   lib/mpi: mpi_read_raw_from_sgl(): replace len argument by nbytes
>>   lib/mpi: mpi_read_raw_from_sgl(): don't include leading zero SGEs in
>>     nbytes
>>   lib/mpi: mpi_read_raw_from_sgl(): purge redundant clearing of nbits
>>   lib/mpi: mpi_read_raw_from_sgl(): fix nbits calculation
>>   lib/mpi: mpi_read_raw_from_sgl(): sanitize meaning of indices
>>   lib/mpi: mpi_read_raw_from_sgl(): fix out-of-bounds buffer access
>> 
>>  lib/mpi/mpicoder.c | 122 +++++++++++++++++++----------------------------------
>>  1 file changed, 43 insertions(+), 79 deletions(-)
>
> Thanks for sending this. Nice work. In fact the mpi_write_sgl() function
> worked only because the mpi_normalize() stripped all MSB zero limbs.
> Given that this will hold for all cases we can simplify this even more.
> Unfortunately I don't know if this will be true for mpi_sub() or
> mpi_set_ui() because they are declared in include/linux/mpi.h,
> but never defined anywhere.
>
> I've found one problem in 08/14 in mpi_read_buffer()
> It's a pointer arithmetic issue, which causes the first limb to be
> written at an invalid address if lzeros > 0. This incremental patch
> fixes it.

Ugh. I'll send a v3 fixing this up during the course of the day. Or do
you prefer to apply your incremental patch below to this v2 as it
stands?

Anyway, thank you for spotting this!


>
> ---8<---
> Subject: [PATCH] lib/mpi: fix pointer arithmetic issue in mpi_read_buffer
>
> Fix pointer arithmetic issue, which causes the first limb to be
> written at invalid address if lzeros > 0.
>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
>  lib/mpi/mpicoder.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
> index 0c534ac..747606f 100644
> --- a/lib/mpi/mpicoder.c
> +++ b/lib/mpi/mpicoder.c
> @@ -201,7 +201,7 @@ int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
>  #else
>  #error please implement for this limb size.
>  #endif
> -		memcpy(p, &alimb + lzeros, BYTES_PER_MPI_LIMB - lzeros);
> +		memcpy(p, (u8 *)&alimb + lzeros, BYTES_PER_MPI_LIMB - lzeros);
>  		p += BYTES_PER_MPI_LIMB - lzeros;
>  		lzeros = 0;
>  	}
>
> ---
> Other than that  please include my 
> Tested-by: Tadeusz Struk <tadeusz.struk@intel.com>
> for the whole series.

Glad to get that one :)

Nicolai
