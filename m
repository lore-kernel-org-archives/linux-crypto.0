From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 0/4] padata/pcrypt: fixes
Date: Tue, 20 Jul 2010 08:47:36 +0200
Message-ID: <20100720064736.GB11081@secunet.com>
References: <20100714142951.22817d0c@leibniz>
 <20100719060426.GA19696@gondor.apana.org.au>
 <20100719064050.GA11081@secunet.com>
 <20100719073255.GA20403@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Kruchinin <dkruchinin@acm.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100719073255.GA20403@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patchset contains the following fixes:

1. padata - Fix a potential hang of the parallel worker threads on
cpu hotplug.

2. padata - Fix two NULL pointer dereference crashes if one of the
padata cpumasks is empty. The crashes can be triggered by doing
echo 0 > /sys/kernel/pcrypt/pencrypt/[parallel_cpumask/serial_cpumask]

3. padata - Fix a division by zero crash if the parallel cpumask
contains no active cpu. Can be triggered by doing
echo 0 > /sys/kernel/pcrypt/pencrypt/parallel_cpumask

4. pcrypt - Fix division by zero crash if the callback cpumask
is empty. Can be triggered by doing
echo 0 > /sys/kernel/pcrypt/pencrypt/serial_cpumask

I ran a script that does cpumask changes and cpu hotplugs as fast as
possible while sending IPsec packets on maximal rate with pcrypt.
It showed no furter crashes overnight, so I hope I've got them all.

padata API corrections and some minor fixes/cleanups are comming later.

Steffen
