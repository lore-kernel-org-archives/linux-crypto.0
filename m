From: Michal Suchanek <hramrach@gmail.com>
Subject: un4i-ss-cipher.c warning
Date: Wed, 19 Aug 2015 16:35:36 +0200
Message-ID: <CAOMqctShdb9xEkBmuaQKfB1cwGupbfH5TS5ZB_P85Hwpn+4zAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

when building a kernel with sunxi crypto driver as merged into the
sinxi-wip branch I get a compiler warning.

I am not sure this is the latest version of the driver. It does not
seem to be in mainline yet.

Thanks

Michal

In file included from /scratch/build/linux/include/linux/printk.h:277:0=
,
                 from /scratch/build/linux/include/linux/kernel.h:13,
                 from /scratch/build/linux/include/linux/clk.h:16,
                 from
/scratch/build/linux/drivers/crypto/sunxi-ss/sun4i-ss.h:15,
                 from
/scratch/build/linux/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c:17:
/scratch/build/linux/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c: In
function =E2=80=98sun4i_ss_cipher_poll=E2=80=99:
/scratch/build/linux/include/linux/dynamic_debug.h:86:3: warning:
=E2=80=98todo=E2=80=99 may be used uninitialized in this function
[-Wmaybe-uninitialized]
   __dynamic_dev_dbg(&descriptor, dev, fmt, \
   ^
/scratch/build/linux/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c:144:15:
note: =E2=80=98todo=E2=80=99 was declared here
  unsigned int todo;
