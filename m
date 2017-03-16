From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH 1/4] crypto: powerpc - Factor out the core CRC vpmsum
 algorithm
Date: Thu, 16 Mar 2017 22:13:07 +1100
Message-ID: <20170316221307.52d14611@kryten>
References: <20170315123737.20234-1-dja@axtens.net>
 <063D6719AE5E284EB5DD2968C1650D6DCFFB1A81@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 'Daniel Axtens' <dja@axtens.net>
To: David Laight <David.Laight@ACULAB.COM>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DCFFB1A81@AcuExch.aculab.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

Hi David,

> While not part of this change, the unrolled loops look as though
> they just destroy the cpu cache.
> I'd like be convinced that anything does CRC over long enough buffers
> to make it a gain at all.

btrfs data checksumming is one area.

> With modern (not that modern now) superscalar cpus you can often
> get the loop instructions 'for free'.

A branch on POWER8 is a three cycle redirect. The vpmsum instructions
are 6 cycles.

> Sometimes pipelining the loop is needed to get full throughput.
> Unlike the IP checksum, you don't even have to 'loop carry' the
> cpu carry flag.

It went through quite a lot of simulation to reach peak performance.
The loop is quite delicate, we have to pace it just right to avoid
some pipeline reject conditions.

Note also that we already modulo schedule the loop across three
iterations, required to hide the latency of the vpmsum instructions.

Anton
