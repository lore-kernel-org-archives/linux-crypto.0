From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v5 1/2] lib/mpi: Add mpi sgl helpers
Date: Thu, 8 Oct 2015 06:31:52 -0700
Message-ID: <56167048.5080505@intel.com>
References: <20151002051032.27263.21150.stgit@tstruk-mobl1>
 <20151002051038.27263.5476.stgit@tstruk-mobl1>
 <20151008130203.GA24128@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:46848 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932596AbbJHNeG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Oct 2015 09:34:06 -0400
In-Reply-To: <20151008130203.GA24128@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/08/2015 06:02 AM, Herbert Xu wrote:
> On Thu, Oct 01, 2015 at 10:10:38PM -0700, Tadeusz Struk wrote:
>>
>> +/**
>> + * mpi_write_to_sgl() - Funnction exports MPI to an sgl (msb first)
>> + *
>> + * This function works in the same way as the mpi_read_buffer, but it
>> + * takes an sgl instead of u8 * buf.
>> + *
>> + * @a:		a multi precision integer
>> + * @sgl:	scatterlist to write to. Needs to be at least
>> + *		mpi_get_size(a) long.
>> + * @nbytes:	receives the actual length of the data written.
>> + * @sign:	if not NULL, it will be set to the sign of a.
>> + *
>> + * Return:	0 on success or error code in case of error
>> + */
>> +int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned *nbytes,
>> +		     int *sign)
> 
> Where is the maximum length of sgl? You should not assume that the
> entire SG list is for you to use.  So the length that you are allowed
> to use should be passed in explicitly.  You can just put it into
> nbytes.

The sgl has to be big enough to take the whole integer.
What would be the point to export only part of a number?
