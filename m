From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] ARM: convert all "mov.* pc, reg" to "bx reg" for ARMv6+
Date: Fri, 4 Jul 2014 16:24:38 +0200
Message-ID: <20140704142438.GA7827@pengutronix.de>
References: <E1X20Rs-00082S-KI@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Andrew Lunn <andrew@lunn.ch>, kvm@vger.kernel.org, linux-sh@vger.kernel.org,
 Kevin Hilman <khilman@deeprootsystems.com>, Sekhar Nori <nsekhar@ti.com>,
 linux-tegra@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>,
 kvmarm@lists.cs.columbia.edu, linux-samsung-soc@vger.kernel.org,
 Kukjin Kim <kgene.kim@samsung.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
 Magnus Damm <magnus.damm@gmail.com>, Gleb Natapov <gleb@kernel.org>,
 Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.infradead.org,
 xen-devel@lists.xenproject.org,
 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
 Jason Cooper <jason@lakedaemon.net>, Stephen Warren <swarren@wwwdotorg.org>,
 Marc Zyngier <marc.zyngier@arm.com>,
 Hans Ulli Kroll <ulli.kroll@googlemail.com>,
 Haojian Zhuang <haojian.zhuang@gmail.com>, Simon Horman <horms@verge.net.
To: Russell King <rmk+kernel@arm.linux.org.uk>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <E1X20Rs-00082S-KI@rmk-PC.arm.linux.org.uk>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 01, 2014 at 04:58:24PM +0100, Russell King wrote:
> ARMv6 and greater introduced a new instruction ("bx") which can be used
> to return from function calls.  Recent CPUs perform better when the
> "bx lr" instruction is used rather than the "mov pc, lr" instruction,
> and this sequence is strongly recommended to be used by the ARM
> architecture manual (section A.4.1.1).
> =

> We provide a new macro "ret" with all its variants for the condition
> code which will resolve to the appropriate instruction.
> =

> Rather than doing this piecemeal, and miss some instances, change all
> the "mov pc" instances to use the new macro, with the exception of
> the "movs" instruction and the kprobes code.  This allows us to detect
> the "mov pc, lr" case and fix it up - and also gives us the possibility
> of deploying this for other registers depending on the CPU selection.
> =

> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Works fine on my ARM-v7M machine:

$ objdump -d vmlinux | grep -E 'mov.*pc'
8c000022:	46e7      	mov	pc, ip
8c000028:	46ef      	mov	pc, sp
8c000b26:	46af      	movne	pc, r5
8c0037e0:	4687      	mov	pc, r0
8c0828d2:	4697      	mov	pc, r2
8c1213ee:	469f      	mov	pc, r3

Also boots fine.

Tested-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

but I wonder what is the reason to not use bx if \reg !=3D lr.

Thanks
Uwe

-- =

Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
