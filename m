From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 1/4] crypto: powerpc - Factor out the core CRC vpmsum
 algorithm
Date: Wed, 15 Mar 2017 16:10:28 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6DCFFB1A81@AcuExch.aculab.com>
References: <20170315123737.20234-1-dja@axtens.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Cc: "anton@samba.org" <anton@samba.org>
To: 'Daniel Axtens' <dja@axtens.net>, "linuxppc-dev@lists.ozlabs.org"
 <linuxppc-dev@lists.ozlabs.org>, "linux-crypto@vger.kernel.org"
 <linux-crypto@vger.kernel.org>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20170315123737.20234-1-dja@axtens.net>
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

From: Linuxppc-dev Daniel Axtens
> Sent: 15 March 2017 12:38
> The core nuts and bolts of the crc32c vpmsum algorithm will
> also work for a number of other CRC algorithms with different
> polynomials. Factor out the function into a new asm file.
>=20
> To handle multiple users of the function, a user simply
> provides constants, defines the name of their CRC function,
> and then #includes the core algorithm file.
...

While not part of this change, the unrolled loops look as though
they just destroy the cpu cache.
I'd like be convinced that anything does CRC over long enough buffers
to make it a gain at all.

With modern (not that modern now) superscalar cpus you can often
get the loop instructions 'for free'.
Sometimes pipelining the loop is needed to get full throughput.
Unlike the IP checksum, you don't even have to 'loop carry' the
cpu carry flag.

	David
