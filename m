From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] MPI: Fix mpi_read_buffer
Date: Tue, 15 Sep 2015 08:56:09 -0700
Message-ID: <55F83F99.60904@intel.com>
References: <20150824145214.26239.98271.stgit@tstruk-mobl1>
 <12302.1442308196@warthog.procyon.org.uk>
 <20150915122424.GA3743@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:55552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbbIOP55 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Sep 2015 11:57:57 -0400
In-Reply-To: <20150915122424.GA3743@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/15/2015 05:24 AM, Herbert Xu wrote:
>>> Change mpi_read_buffer to return a number without leading zeros
>>> > > so that mpi_read_buffer and mpi_get_buffer return the same thing.
>> > 
>> > Hmmm...  This would appear to have the undesirable side effect of causing 1
>> > out of 256 module signing keys to be unusable (ie. those that begin with 00).
> I thought Tadeusz was just restoring the original behaviour, no?

That was the intention.
David, I can ran some more test if you have the key that was failing and
be willing to share it.
