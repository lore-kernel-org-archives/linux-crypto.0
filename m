From: leroy christophe <christophe.leroy@c-s.fr>
Subject: Re: [PATCH v3 00/17] crypto: talitos - Add support for SEC1
Date: Fri, 17 Apr 2015 16:29:48 +0200
Message-ID: <553118DC.6000508@c-s.fr>
References: <20150417142353.76D561A242C@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150417142353.76D561A242C@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Oops, this is the first time I use directly the output of git=20
format-patch into sendmail, and
it looks like the mails are dated with the commit date, not today's dat=
e.

I will resend now with today's date. Sorry for the noise.

Christophe

Le 17/04/2015 15:47, Christophe Leroy a =E9crit :
> The purpose of this set of patchs is to add to talitos crypto driver
> the support for the SEC1 version of the security engine, which is
> found in mpc885 and mpc8272 processors.
>
> v3 is a complete rework of the patchset. Since a kernel can be built
> with support for both MPC82xx and MPC83xx at the same time, talitos
> driver shall support both SEC1 and SEC2+ at the same time.
>
> Based on cryptodev-2.6 tree
>
> Christophe Leroy (17):
>    crypto: talitos - Use zero entry to init descriptors ptrs to zero
>    crypto: talitos - Refactor the sg in/out chain allocation
>    crypto: talitos - talitos_ptr renamed ptr for more lisibility
>    crypto: talitos - Add a helper function to clear j_extent field
>    crypto: talitos - remove param 'extent' in map_single_talitos_ptr(=
)
>    crypto: talitos - helper function for ptr len
>    crypto: talitos - enhanced talitos_desc struct for SEC1
>    crypto: talitos - add sub-choice in talitos CONFIG for SEC1
>    crypto: talitos - Add a feature to tag SEC1
>    crypto: talitos - fill in talitos descriptor iaw SEC1 or SEC2+
>    crypto: talitos - adaptation of talitos_submit() for SEC1
>    crypto: talitos - base address for Execution Units
>    crypto: talitos - adapt interrupts and reset functions to SEC1
>    crypto: talitos - implement scatter/gather copy for SEC1
>    crypto: talitos - SEC1 bugs on 0 data hash
>    crypto: talitos - Add fsl,sec1.0 compatible
>    crypto: talitos - Update DT bindings with SEC1
>
>   .../devicetree/bindings/crypto/fsl-sec2.txt        |   6 +-
>   drivers/crypto/Kconfig                             |  18 +
>   drivers/crypto/talitos.c                           | 727 ++++++++++=
+++++------
>   drivers/crypto/talitos.h                           | 153 +++--
>   4 files changed, 644 insertions(+), 260 deletions(-)
>
