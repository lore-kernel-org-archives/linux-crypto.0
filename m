From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v7 2/3] crypto: rsa: add a new rsa generic implementation
Date: Tue, 16 Jun 2015 19:32:16 -0700
Message-ID: <5580DC30.4030301@intel.com>
References: <20150616173101.1248.55033.stgit@tstruk-mobl1> <20150616173050.1248.21847.stgit@tstruk-mobl1> <18687.1434492657@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	keescook@chromium.org, jwboyer@redhat.com, smueller@chronox.de,
	richard@nod.at, steved@redhat.com, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25311 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbbFQCcX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 22:32:23 -0400
In-Reply-To: <18687.1434492657@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi David,
On 06/16/2015 03:10 PM, David Howells wrote:
>> +static int _rsa_sign(const struct rsa_key *key, MPI s, MPI m)
>> > +{
>> > +	/* (1) Validate 0 <= m < n */
>> > +	if (mpi_cmp_ui(m, 0) < 0 || mpi_cmp(m, key->n) >= 0)
>> > +		return -EINVAL;
> Why -EINVAL not -EBADMSG?

I thought that -EBADMSG was mainly used for authenticated ciphers in case when verification of auth data fails.
Since this are input params I thought that -EINVAL would be more appropriate.
I can change it to -EBADMSG, no problem.
Herbert, what do you think?
