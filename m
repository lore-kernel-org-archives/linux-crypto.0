From: Leonard Crestez <leonard.crestez@nxp.com>
Subject: [PATCH 0/3] crypto: mxs-dcp - Fix tcrypt on imx6
Date: Tue, 2 Oct 2018 19:01:46 +0000
Message-ID: <cover.1538505573.git.leonard.crestez@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Horia Geanta <horia.geanta@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S . Miller " <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Marek Vasut <marek.vasut@gmail.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The mxs-dcp driver currently fails to probe on imx6. Fix the whole thing
by porting a cleaned/squashed version of fixes carried in the NXP vendor
tree.

Tested with "modprobe tcrypt" and CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=3Dn
on imx6sl imx6sll imx6ull: no failures.

I'm not very familiar with crypto and did not write write these fixes so
a skeptical review would be appreciated.

Previously:
  https://lore.kernel.org/patchwork/patch/989652/

Dan Douglass (1):
  crypto: mxs-dcp - Implement sha import/export

Radu Solea (2):
  crypto: mxs-dcp - Fix SHA null hashes and output length
  crypto: mxs-dcp - Fix AES issues

 drivers/crypto/mxs-dcp.c | 121 ++++++++++++++++++++++++++++++++-------
 1 file changed, 101 insertions(+), 20 deletions(-)

--=20
2.17.1
