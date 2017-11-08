From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2] lib/mpi: call cond_resched() from mpi_powm() loop
Date: Wed, 08 Nov 2017 12:50:17 +0000
Message-ID: <25888.1510145417@warthog.procyon.org.uk>
References: <20171107221527.98433-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752289AbdKHMuU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Nov 2017 07:50:20 -0500
In-Reply-To: <20171107221527.98433-1-ebiggers3@gmail.com>
Content-ID: <25887.1510145417.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Eric Biggers <ebiggers3@gmail.com> wrote:

> On a non-preemptible kernel, if KEYCTL_DH_COMPUTE is called with the
> largest permitted inputs (16384 bits), the kernel spends 10+ seconds
> doing modular exponentiation in mpi_powm() without rescheduling.  If all
> threads do it, it locks up the system.  Moreover, it can cause
> rcu_sched-stall warnings.

Do you want this to go in immediately, or I should I push it to James for the
next merge window?

David
