From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v4 1/3] Documentation/bindings: Document the SafeXel
 cryptographic engine driver
Date: Wed, 17 May 2017 16:25:48 -0500
Message-ID: <CAL_JsqKB-D4UBJWX==pQdKsDd+rGP6JJD3jnwPBbLxpHS85XCw@mail.gmail.com>
References: <20170427132459.23159-1-antoine.tenart@free-electrons.com>
 <20170427132459.23159-2-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
 Andrew Lunn <andrew@lunn.ch>, Herbert Xu <herbert@gondor.apana.org.au>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 Boris BREZILLON <boris.brezillon@free-electrons.com>,
 linux-crypto@vger.kernel.org, Nadav Haklai <nadavh@marvell.com>,
 oferh@marvell.com, Igal Liberman <igall@marvell.com>,
 Gregory Clement <gregory.clement@free-electrons.com>,
 David Miller <davem@davemloft.net>, Jason Cooper <jason@lakedaemon.net>,
 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170427132459.23159-2-antoine.tenart@free-electrons.com>
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

On Thu, Apr 27, 2017 at 8:24 AM, Antoine Tenart
<antoine.tenart@free-electrons.com> wrote:
> The Inside Secure Safexcel cryptographic engine is found on some Marvell
> SoCs (7k/8k). Document the bindings used by its driver.
>
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>  .../bindings/crypto/inside-secure-safexcel.txt     | 27 ++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt

If you would like this reviewed, please re-send to the DT list.

Rob
