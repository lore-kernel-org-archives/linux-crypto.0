From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 1/4] crypto: powerpc - Factor out the core CRC vpmsum
 algorithm
Date: Thu, 16 Mar 2017 09:50:13 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6DCFFB2524@AcuExch.aculab.com>
References: <20170315123737.20234-1-dja@axtens.net>
 <063D6719AE5E284EB5DD2968C1650D6DCFFB1A81@AcuExch.aculab.com>
 <87efxy41hi.fsf@possimpible.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Cc: "anton@samba.org" <anton@samba.org>
To: 'Daniel Axtens' <dja@axtens.net>, "linuxppc-dev@lists.ozlabs.org"
 <linuxppc-dev@lists.ozlabs.org>, "linux-crypto@vger.kernel.org"
 <linux-crypto@vger.kernel.org>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <87efxy41hi.fsf@possimpible.ozlabs.ibm.com>
Content-Language: en-US
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

From: Daniel Axtens
> Sent: 15 March 2017 22:30
> Hi David,
>=20
> > While not part of this change, the unrolled loops look as though
> > they just destroy the cpu cache.
> > I'd like be convinced that anything does CRC over long enough buffers
> > to make it a gain at all.
> >
> > With modern (not that modern now) superscalar cpus you can often
> > get the loop instructions 'for free'.
> > Sometimes pipelining the loop is needed to get full throughput.
> > Unlike the IP checksum, you don't even have to 'loop carry' the
> > cpu carry flag.
>=20
> Internal testing on a NVMe device with T10DIF enabled on 4k blocks
> shows a 20x - 30x improvement. Without these patches, crc_t10dif_generic
> uses over 60% of CPU time - with these patches CRC drops to single
> digits.
>=20
> I should probably have lead with that, sorry.

I'm not doubting that using the cpu instruction for crcs gives a
massive performance boost.

Just that the heavily unrolled loop is unlikely to help overall.
Some 'cold cache' tests on shorter buffers might be illuminating.
=20
> FWIW, the original patch showed a 3.7x gain on btrfs as well -
> 6dd7a82cc54e ("crypto: powerpc - Add POWER8 optimised crc32c")
>=20
> When Anton wrote the original code he had access to IBM's internal
> tooling for looking at how instructions flow through the various stages
> of the CPU, so I trust it's pretty much optimal from that point of view.

Doesn't mean he used it :-)

	David
