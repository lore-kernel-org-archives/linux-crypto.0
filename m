From: Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH 1/2] [v3] crypto: sha1/ARM: make use of common SHA-1
 structures
Date: Tue, 1 Jul 2014 17:29:39 +0200
Message-ID: <20140701152939.GC8243@orbit.nwl.cc>
References: <20140630163845.32348.80374.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Russell King <linux@arm.linux.org.uk>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-crypto@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20140630163845.32348.80374.stgit@localhost6.localdomain6>
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

Hi,

On Mon, Jun 30, 2014 at 07:38:46PM +0300, Jussi Kivilinna wrote:
> Common SHA-1 structures are defined in <crypto/sha.h> for code sharing.
> 
> This patch changes SHA-1/ARM glue code to use these structures.

I find it worth noting that this patch also fixes mv_cesa if sha1-arm is
also enabled. This is because software SHA1 is used as fallback,
accessing the context's data which was layed out differently before this
patch.

I have not checked, but other crypto engine drivers might be affected by
that, as well.

> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

Acked-by: Phil Sutter <phil@nwl.cc>

Best wishes, Phil
