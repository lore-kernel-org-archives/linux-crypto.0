From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] MPI: Fix mpi_read_buffer
Date: Tue, 15 Sep 2015 10:09:56 +0100
Message-ID: <12302.1442308196@warthog.procyon.org.uk>
References: <20150824145214.26239.98271.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483AbbIOJKA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Sep 2015 05:10:00 -0400
In-Reply-To: <20150824145214.26239.98271.stgit@tstruk-mobl1>
Content-ID: <12301.1442308196.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tadeusz Struk <tadeusz.struk@intel.com> wrote:

> Change mpi_read_buffer to return a number without leading zeros
> so that mpi_read_buffer and mpi_get_buffer return the same thing.

Hmmm...  This would appear to have the undesirable side effect of causing 1
out of 256 module signing keys to be unusable (ie. those that begin with 00).

David
