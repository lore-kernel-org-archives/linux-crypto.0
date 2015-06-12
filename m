From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v4 1/4] MPILIB: add mpi_read_buf(), mpi_copy() and
 mpi_get_size() helpers
Date: Fri, 12 Jun 2015 11:59:16 -0700
Message-ID: <557B2C04.4070406@intel.com>
References: <20150611190533.31826.13956.stgit@tstruk-mobl1> <20150611190538.31826.97258.stgit@tstruk-mobl1> <8104647.vddsXnptAF@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	keescook@chromium.org, jwboyer@redhat.com, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:37303 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbbFLS7R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Jun 2015 14:59:17 -0400
In-Reply-To: <8104647.vddsXnptAF@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/12/2015 09:21 AM, Stephan Mueller wrote:
>> +void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign)
>> >+{
>> >+       uint8_t *buf, *p;
>> >+       int n, ret;
>> >+
>> >+       if (!nbytes)
>> >+               return NULL;
>> >+
>> >+       n = mpi_get_size(a);
> Shouldn't n be unsigned int?

You are right, thanks.
