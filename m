From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 3/3] crypto: Add Allwinner Security System crypto
 accelerator
Date: Sat, 24 May 2014 13:26:26 +0200
Message-ID: <201405241326.26260.marex@denx.de>
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com>
 <537E3E2F.7000407@gmail.com> <201405231246.10365.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, linux@arm.linux.org.uk,
 herbert@gondor.apana.org.au, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
 rdunlap@infradead.org, linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 Corentin LABBE <clabbe.montjoie@gmail.com>, linux-crypto@vger.kernel.org,
 galak@codeaurora.org, grant.likely@linaro.org,
 maxime.ripard@free-electrons.com, davem@davemloft.net,
 linux-arm-kernel@lists.infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <201405231246.10365.arnd@arndb.de>
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

On Friday, May 23, 2014 at 12:46:10 PM, Arnd Bergmann wrote:
> On Thursday 22 May 2014, Corentin LABBE wrote:
> > Le 22/05/2014 17:28, Arnd Bergmann a =E9crit :
> > > On Thursday 22 May 2014 17:09:56 LABBE Corentin wrote:
> > >> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> > > =

> > > My feeling is that this should either be one driver that provides
> > > all five algorithms unconditionally, or five drivers that are each
> > > separate loadable modules and based on top of a common module
> > > that only exports functions but has no active logic itself
> > =

> > I agree for the split.
> > It was my first intention but I feared to add too many files.
> > So I propose to split in 6, sunxi-ss-hash.c, sunxi-ss-des.c,
> > sunxi-ss-aes.c, sunxi-ss-rng.c, sunxi-ss-common.c and sunxi-ss.h Does
> > can I add a sunxi-ss directory in drivers/crypto ?
> =

> Yes, I think a subdirectory would be best.

Full ACK on this one. Use drivers/crypto/sunxi-ss/ .
[...]

Best regards,
Marek Vasut
