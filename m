From: "Dilger, Andreas" <andreas.dilger@intel.com>
Subject: Re: [PATCH v4] crypto api: add crc32 pclmulqdq implementation and
 wrappers for table implementation
Date: Fri, 11 Jan 2013 00:39:39 +0000
Message-ID: <CD14ACF3.1403F%andreas.dilger@intel.com>
References: <1357848481.17632.140.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Tim Chen <tim.c.chen@linux.intel.com>,
	Alexander Boyko <alexander_boyko@xyratex.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:13207 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141Ab3AKAjl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jan 2013 19:39:41 -0500
In-Reply-To: <1357848481.17632.140.camel@schen9-DESK>
Content-Language: en-US
Content-ID: <88BA6EB29040524D8F866521DA386A42@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2013/10/01 1:08 PM, "Tim Chen" <tim.c.chen@linux.intel.com> wrote:
>On Thu, 2013-01-10 at 23:26 +0400, Alexander Boyko wrote:
>> 1/10/13 9:54 PM, Tim Chen =EF=E8=F8=E5=F2:
>> >
>> > On Thu, 2013-01-10 at 18:54 +0400, Alexander Boyko wrote:
>> >> From: Alexander Boyko <alexander_boyko@xyratex.com>
>> >>
>> >> This patch adds crc32 algorithms to shash crypto api. One is wrap=
per
>>to
>> >> gerneric crc32_le function. Second is crc32 pclmulqdq
>>implementation. It
>> >> use hardware provided PCLMULQDQ instruction to accelerate the CRC=
32
>>disposal.
>> >> This instruction present from Intel Westmere and AMD Bulldozer CP=
Us.
>> >>
>> >> For intel core i5 I got 450MB/s for table implementation and
>>2100MB/s=20
>> >> for pclmulqdq implementation (
>> > Alexander,
>> >
>> > Wonder if you have a chance to test performance of our PCLMULQDQ
>> > implementation for crc32c that's in the current code (see
>> > crc32c-pcl-intel-asm_64.asm). The throughput will probably be
>>comparable
>> > with your implementation.
>>
>> I have no chance to test crc32c pclmul, but I tested previous crc32c
>> implementation on crc32 instruction, the speed was about 2500 MB/s. =
So,
>> I think, the newest version should be faster.
>
>It will be troublesome to maintain two separate versions of PCLMUL
>crc32c code.  So we should find out if there's performance benefit of
>your PCLMUL code over the one in the codebase.  Testing should be
>straight forward by enabling the CRYPTO_CRC32C_INTEL option in kernel
>and inserting the crc32c-intel module.

Maybe there is some confusion here?  The submitted patch is for CRC32,
while you are referring to CRC32C (note trailing "C")?  Are they not
different CRC functions, or can both CRCs be computed by the same code
if there are different constants loaded?

>You may also want to add check in your glue code for support of the
>PCLMUL feature before calling the pclmul version.  You probably also
>don't want to use this feature if the data size is small, as
>kernel_fpu_begin and kernel_fpu_end takes significant time.  In that
>case, using the crc32c hw instructions in a loop is faster (see
>crc32c-intel_glue.c).

Cheers, Andreas
--=20
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division
